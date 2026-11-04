//hooks, probably to add the faction after campaign load, add faction action to settlement faction
local modName = "mod_cultists"
::mods_registerMod(modName, 1.0.4, "Пробуждение Давкула");
::mods_queue(null, null, function()
{	
	local gt = this.getroottable()
	gt.setupDebugLog <- function (_enabled = false, _name = "default")
	{
		//keep table of mod names so that you can turn it on and off for specific mods
		if (!("debugLog" in gt)){
			gt.debugLog <- {}
		}
		if (!(_name in gt.debugLog))
		{
			gt.debugLog[_name] <- false
		}
		gt.debugLog[_name] <- _enabled
		if (gt.debugLog[_name]) this.logInfo("журнал отладки активирован для " + _name)

		gt.printDebug <- function(arg = "Нет аргумента для журнала отладки", _name = "default")
		{
			if (_name in this.debugLog && this.debugLog[_name]){
				local src = getstackinfos(2).src.slice(0, -4)
				src = split(src, "/")[split(src, "/").len()-1]
				this.logInfo(_name +  " " + src + " : " + arg)
			}
		}
		gt.isDebug <- function(_str)
		{
			return (_str in this.debugLog && this.debugLog[_str])
		}
	}
	gt.setupDebugLog(false, modName)
	if (this.isDebug("mod_cultists")) this.Const.AI.VerboseMode = true;
	
	this.Math.randArray <- function(_array){

		if (typeof _array != "array" || _array.len() == 0) {
			this.logWarning("_этот массив не является массивом, либо он пустой")
			return
		}
		return _array[this.Math.rand(0, _array.len()-1)]
	}

	::getCultists <- function()
	{
		return this.World.FactionManager.getFactionOfType(this.Const.FactionType.Cultists)
	}

	::mods_hookNewObjectOnce("states/world/asset_manager", function (o)
	{
		while (!("update" in o)) o = o[o.SuperName];
		local update = o.update;		
		o.update = function(_worldState)
		{	
			update(_worldState)
			if (this.World.FactionManager.getFactionOfType(this.Const.FactionType.Cultists) == null)
			{
				local cultist_faction = this.new("scripts/factions/cultist_faction")
				local faction_manager = this.World.FactionManager
				cultist_faction.setID(faction_manager.m.Factions.len());
				cultist_faction.setName("Cultist");
				cultist_faction.setDiscovered(true);
				cultist_faction.addTrait(this.Const.CultistTraits);
				faction_manager.m.Factions.push(cultist_faction);
				this.World.Flags.set("spawnedCultists", true)
				cultist_faction.m.Flags.set("RitualSitesBeat", 0)
				this.printDebug("создана фракция культистов", modName)
			}
		}
	})

	//check for AP cost when being grabbed by mancatcher
	::mods_hookNewObject("items/item_container", function(o){
		local payForAction = o.payForAction
		o.payForAction = function(_items)
		{
			payForAction(_items)
			if (this.m.Actor.getSkills().hasSkill("effects.serpent_ensnare"))
			{
				this.m.Actor.getSkills().getSkillByID("effects.serpent_ensnare").checkQuickHands()
			}
		}
	})
	::mods_hookExactClass("ai/tactical/behaviors/ai_attack_bow", function(o){
		o.m.PossibleSkills.push("actives.sling_heavy_stone")
	})
	::mods_hookExactClass("ai/tactical/behaviors/ai_engage_ranged", function(o){
		o.m.PossibleSkills.push("actives.sling_heavy_stone")
	})
	::mods_hookExactClass("skills/perks/perk_mastery_throwing", function(o){
		local onAnySkillUsed = o.onAnySkillUsed
		o.onAnySkillUsed = function( _skill, _targetEntity, _properties){
			onAnySkillUsed(_skill, _targetEntity, _properties)
			if (_targetEntity == null)
			{
				return;
			}

			if (_skill.isRanged() && (_skill.getID() == "actives.sling_heavy_stone"))
			{
				local d = this.getContainer().getActor().getTile().getDistanceTo(_targetEntity.getTile());

				if (d <= 2)
				{
					_properties.DamageTotalMult *= 1.4;
				}
				else if (d <= 3)
				{
					_properties.DamageTotalMult *= 1.2;
				}
			}
		}
	})
	
	::mods_hookExactClass("factions/actions/build_unique_locations_action", function(o){
		o.m.BuildGrandCultistSite <- true;

		local updateBuildings = o.updateBuildings
		o.updateBuildings = function(){
			updateBuildings()
			local locations = this.World.EntityManager.getLocations();

			foreach( v in locations )
			{
				if (v.getTypeID() == "location.cultist_legendary_camp")
				{
					this.m.BuildGrandCultistSite = false;
					break
				}
			}
		}

		local onExecute = o.onExecute
		o.onExecute = function(_faction){
			if (this.m.BuildGrandCultistSite){
				local camp;
				local distanceToOthers = 15;
				local avoidTerrain = [
				this.Const.World.TerrainType.Mountains, 
				this.Const.World.TerrainType.Swamp,	
				this.Const.World.TerrainType.Hills,
				this.Const.World.TerrainType.Forest,
				this.Const.World.TerrainType.SnowyForest,
				this.Const.World.TerrainType.LeaveForest,
				this.Const.World.TerrainType.AutumnForest
				]
				local legendarySpawned = false;
				local ritualsSpawned = 0;
				local tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries * 100, avoidTerrain, 35, 1000, 1000, 7, 7);

				if (tile != null)
				{
					camp = this.World.spawnLocation("scripts/entity/world/locations/cultist_legendary_location", tile.Coords);
				}
				if (camp != null)
				{
					camp.onSpawned();
					camp.setBanner("banner_13")
					this.World.Flags.set("spawnedLegendaryCultistLocation", true)
					this.printDebug("возрождена легендарная локация культистов в результате build_unique_locations_action", "mod_cultists")
				}
			}
			onExecute(_faction)
		}
	})



	//adds cultist twist to barb king contract
	::mods_hookExactClass("contracts/contracts/barbarian_king_contract", function(o){

		local create = o.create
		o.create = function()
		{
			create()
			local offerscreen = this.getState("Offer")
			local offerEndFunc = offerscreen.end
			offerscreen.end = function(){
				offerEndFunc()
				local odds = 15
				if (isDebug("mod_cultists")) odds = 101
				if (!this.Flags.get("IsAGreaterThreat") && this.Math.rand(0, 100) < odds){
					this.printDebug("Король варваров враждебен к культистам", "mod_cultists")
					this.Contract.m.Destination.getController().getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
					this.Flags.set("IsAGreaterThreat", true)
					this.Contract.overrideScreens()
				}
			}
		}
		o.overrideScreens <- function()
		{
			for( local i = 0; i < this.m.Screens.len()-1; i++ )
			{
				local s = this.m.Screens[i]
				if (s.ID == "AGreaterThreat1")
				{
					this.m.Screens[i] = {
						ID = "AGreaterThreat1",
						Title = "По мере приближения...",
						Text = "[img]gfx/ui/events/event_136.png[/img]{Вы находите короля варваров, и он в сопровождении старейшины приближается к вам, желая поговорить. Вопреки здравому смыслу, вы также выходите им навстречу. Король варваров начинает говорить, а старейшина переводит его слова.%SPEECH_ON%Явились мы не ради завоеваний, ведёт нас лишь желание сразить нечестивцев, что жаждут пробудить некогда изгнанное из сего мира древнее зло.%SPEECH_OFF%Подозревая неверный перевод, вы просите объяснить подробнее. Король со старейшиной продолжают говорить.%SPEECH_ON%Давным-давно древние боги повергли великое зло, изгнав его в загробный мир. Ныне же последователи сего зла собрали все свои силы, желая вызволить его из заслуженного узилища. Их должно остановить. Если сие зло пробудится, то весь мир будет ввергнут во мрак. Орда служителей зла уже близко, собирая души невинных, насыщая своего владыку. Их должно остановить - и мы пришли сюда, не за вами или знатью вашей. Если же встанешь ты рядом с нами и поможешь повергнуть зло, то покинем мы ваши земли и не будем более беспокоить твой род. Лишь на тех, кого зовут культистами, обрушится наш гнев.%SPEECH_OFF%%randombrother% наклоняется и шепчет.%SPEECH_ON%Мы могли бы присоединиться к ним, конечно, но мы можем также разрубить этот узел, напав на них сейчас. Они явно не в полной силе и, что бы варвары тут не говорили, сути это не меняет, командир: они всё равно опустошают эти земли, потому что они - примитивные дикари - насилие и грабёж у них в крови.%SPEECH_OFF%}",
						Image = "",
						List = [],
						Options = [
							{
								Text = "Мы нападём на них и избавим север от этого 'короля'.",
								function getResult()
								{
									return "AGreaterThreat2";
								}

							},
							{
								Text = "Мы присоединимся к ним, дабы выступить против культистов.",
								function getResult()
								{
									return "AGreaterThreat3";
								}

							}
						],
						function start()
						{
						}

					}
				}
				if (s.ID == "AGreaterThreat2")
				{
					this.m.Screens[i] = {
						ID = "AGreaterThreat2",
						Title = "По мере приближения...",
						Text = "[img]gfx/ui/events/event_136.png[/img]{Сплюнув под ноги, вы обращаетесь к старейшине.%SPEECH_ON%Мы прошли мимо сожжённых домов, изнасилованных женщин и убитых мужчин, дабы воздать вам по заслугам, а теперь ты предлагаешь объединиться? Мы не союзники. И не друзья. Скажи своему 'королю', чтобы он помолился какому-нибудь идолу, которому вы...%SPEECH_OFF%Старейшина поднимает руку и говорит с королём на их языке. Затем они обмениваются кивками, поворачиваются и уходят. %randombrother% улыбается.%SPEECH_ON%Краткость - душа презрения, командир.%SPEECH_OFF%Вы приказываете наёмнику вернуться в строй и подготовиться к предстоящей битве.}",
						Image = "",
						List = [],
						Options = [
							{
								Text = "Приготовьтесь к битве.",
								function getResult()
								{
									this.Flags.set("IsAGreaterThreat", false);
									this.Contract.getActiveState().onCombatWithKing(this.Contract.m.Destination, this.Contract.m.IsPlayerAttacking);
									return 0;
								}

							}
						],
						function start()
						{
						}
					}
				}
				if (s.ID == "AGreaterThreat3")
				{
					this.m.Screens[i] = {
						ID = "AGreaterThreat3",
						Title = "По мере приближения...",
						Text = "[img]gfx/ui/events/event_136.png[/img]{Вы киваете старейшине.%SPEECH_ON%Хорошо, мы пойдём с вами, чтобы увидеть эту великую угрозу.%SPEECH_OFF%Старейшина улыбается, складывает руки в молитвенном обращении к богам и произносит несколько фраз на своём родном языке. Король варваров бьёт себя кулаком в грудь, а затем ударяет вас кулаком в плечо, прежде чем взмахнуть рукою к небу. Смеясь, старец объясняет.%SPEECH_ON%Мы станем биться плечом к плечу, но знай: если мы падём, то наши боги поприветствуют нас в своих чертогах!%SPEECH_OFF%}",
						Image = "",
						List = [],
						Options = [
							{
								Text = "Приготовьтесь к походу.",
								function getResult()
								{
									return 0;
								}

							}
						],
						function start()
						{
							local playerTile = this.World.State.getPlayer().getTile();
							local nearest_cultists = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Cultists).getNearestSettlement(playerTile);
							local tile = this.Contract.getTileToSpawnLocation(playerTile, 9, 15);
							local party = this.World.FactionManager.getFaction(nearest_cultists.getFaction()).spawnCultistEntity(tile, "Культисты", false, this.Const.World.Spawn.CultistDefenders, 260 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
							party.getSprite("banner").setBrush(nearest_cultists.getBanner());
							party.setDescription("Войско культистов, рыщущих по земле в поисках душ для жертвы Давкулу.");
							party.setSlowerAtNight(false);
							party.setUsingGlobalVision(false);
							party.setLooting(false);
							this.Contract.m.UnitsSpawned.push(party);
							this.Contract.m.Threat = this.WeakTableRef(party);
							party.setAttackableByAI(false);
							local c = party.getController();
							c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
							local wait = this.new("scripts/ai/world/orders/wait_order");
							wait.setTime(99999);
							c.addOrder(wait);
							this.Contract.m.Destination.setFaction(2);
							this.Contract.m.Destination.getSprite("selection").Visible = false;
							this.Contract.m.Destination.setOnCombatWithPlayerCallback(null);
							c = this.Contract.m.Destination.getController();
							c.clearOrders();
							local move = this.new("scripts/ai/world/orders/move_order");
							move.setDestination(party.getTile());
							c.addOrder(move);
							this.Contract.setState("Running_GreaterThreat");
						}

					}
				}
				if (s.ID == "AGreaterThreat4")
				{
					this.m.Screens[i] = {
						ID = "AGreaterThreat4",
						Title = "По мере приближения...",
						Text = "[img]gfx/ui/events/event_03.png[/img]{Дикари не лгали: культисты направили против вас целую армию. Безумные фанатики, облачённые в доспехи из людской кожи, изувеченные и обезумевшие рабы и страшные чудища, коих могла породить лишь чья-то злая воля. Без сомнения, перед вами предстала армия зла. Если бы вы или варвары встретили эту армаду в одиночку, то без сомнений проиграли бы бой, но ваш союз даёт вам шанс на победу!}",
						Image = "",
						List = [],
						Options = [
							{
								Text = "Приготовьтесь к битве.",
								function getResult()
								{
									this.World.Contracts.showCombatDialog(false, true, true);
									return 0;
								}

							}
						],
						function start()
						{
						}

					}
				}
				if (s.ID == "AGreaterThreat5")
				{
					this.m.Screens[i] =  {
						ID = "AGreaterThreat5",
						Title = "После битвы...",
						Text = "[img]gfx/ui/events/event_136.png[/img]{Культисты повержены все до последнего. Пока дикари и ваши люди добивают раненых сектантов, вы встречаетесь с королём варваров. Старейшина, покрытый кровью врагов, с улыбкой стоит подле короля, готовый перевести вашу беседу.%SPEECH_ON%Мы хотели бы выразить тебе признательность, наёмник. Ты и твои люди сражались хорошо, и мой господин хотел бы, чтобы такие люди как вы сражались с ним и далее плечом к плечу, но мы оба понимаем, что это невозможно. Мы обитаем в лабиринте множества путей и троп, и в этом лабиринте мы так и останемся, лишь иногда слыша крики друг друга. Достаточно, чтобы друг друга ненавидеть, но недостаточно, чтобы друг друга узнать. От лица моего народа говорю тебе спасибо.%SPEECH_OFF%Вы спрашиваете старейшину, как он переводит простое ворчание дикаря, на что тот только улыбается.%SPEECH_ON%Наша дружба даёт нам связь куда большую, чем слова. Удачи тебе, наёмный меч.%SPEECH_OFF%Вы киваете и уже собираетесь уходить, как вдруг король варваров протягивает вам свой массивный шлем. Желая объясниться, он бьёт себя в грудь и направляет руки к небу, после чего безмолвно уходит.}",
						Image = "",
						List = [],
						Options = [
							{
								Text = "Прощай, король.",
								function getResult()
								{
									this.Contract.setState("Return");
									return 0;
								}

							}
						],
						function start()
						{
							if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull() && this.Contract.m.Destination.isAlive())
							{
								this.Contract.m.Destination.die();
								this.Contract.m.Destination = null;
							}

							local item = this.new("scripts/items/helmets/barbarians/heavy_horned_plate_helmet");
							this.World.Assets.getStash().add(item);
							this.List.push({
								id = 10,
								icon = "ui/items/" + item.getIcon(),
								text = "Вы получаете " + this.Const.Strings.getArticle(item.getName()) + item.getName()
							});
						}
					}
				}
			}
		}
	})






	//these two hooks are needed to allow for more factions. Create some unified mod to include this?
	::mods_hookNewObjectOnce("entity/world/combat_manager", function(o){
		local joinCombat = o.joinCombat
		o.joinCombat = function( _combat, _party){
			if (_combat.Factions.len() < 100)
			{
				_combat.Factions.resize(128)

				for( local f = 0; f != 128; f = ++f )
				{
					_combat.Factions[f] = [];
				}
			}
			joinCombat( _combat, _party)
		}
	})
		
	::mods_hookExactClass("states/world_state", function(o){
		o.getLocalCombatProperties = function( _pos, _ignoreNoEnemies = false )
		{
			local raw_parties = this.World.getAllEntitiesAtPos(_pos, this.Const.World.CombatSettings.CombatPlayerDistance);
			local parties = [];
			local properties = this.Const.Tactical.CombatInfo.getClone();
			local tile = this.World.getTile(this.World.worldToTile(_pos));
			local isAtUniqueLocation = false;
			properties.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
			properties.Tile = tile;
			properties.InCombatAlready = false;
			properties.IsAttackingLocation = false;
			local factions = [];
			factions.resize(100, 0);

			foreach( party in raw_parties )
			{
				if (!party.isAlive() || party.isPlayerControlled())
				{
					continue;
				}

				if (!party.isAttackable() || party.getFaction() == 0 || party.getVisibilityMult() == 0)
				{
					continue;
				}

				if (party.isLocation() && party.isLocationType(this.Const.World.LocationType.Unique))
				{
					isAtUniqueLocation = true;
					break;
				}

				if (party.isInCombat())
				{
					raw_parties = this.World.getAllEntitiesAtPos(_pos, this.Const.World.CombatSettings.CombatPlayerDistance * 2.0);
					break;
				}
			}

			foreach( party in raw_parties )
			{
				if (!party.isAlive() || party.isPlayerControlled())
				{
					continue;
				}

				if (!party.isAttackable() || party.getFaction() == 0 || party.getVisibilityMult() == 0)
				{
					continue;
				}

				if (isAtUniqueLocation && (!party.isLocation() || !party.isLocationType(this.Const.World.LocationType.Unique)))
				{
					continue;
				}

				if (!_ignoreNoEnemies)
				{
					local hasOpponent = false;

					foreach( other in raw_parties )
					{
						if (other.isAlive() && !party.isAlliedWith(other))
						{
							hasOpponent = true;
							break;
						}
					}

					if (hasOpponent)
					{
						parties.push(party);
					}
				}
				else
				{
					parties.push(party);
				}
			}

			foreach( party in parties )
			{
				if (party.isInCombat())
				{
					properties.InCombatAlready = true;
				}

				if (party.isLocation())
				{
					properties.IsAttackingLocation = true;
					properties.CombatID = "LocationBattle";
					properties.LocationTemplate = party.getCombatLocation();
					properties.LocationTemplate.OwnedByFaction = party.getFaction();
				}

				this.World.Combat.abortCombatWithParty(party);
				party.onBeforeCombatStarted();
				local troops = party.getTroops();

				foreach( t in troops )
				{
					if (t.Script != "")
					{
						t.Faction <- party.getFaction();
						t.Party <- this.WeakTableRef(party);
						properties.Entities.push(t);

						if (!this.World.FactionManager.isAlliedWithPlayer(party.getFaction()))
						{
							++factions[party.getFaction()];
						}
					}
				}

				if (troops.len() != 0)
				{
					party.onCombatStarted();
					properties.Parties.push(party);
					this.m.PartiesInCombat.push(party);

					if (party.isAlliedWithPlayer())
					{
						properties.AllyBanners.push(party.getBanner());
					}
					else
					{
						properties.EnemyBanners.push(party.getBanner());
					}
				}
			}

			local highest_faction = 0;
			local best = 0;

			foreach( i, f in factions )
			{
				if (f > best)
				{
					best = f;
					highest_faction = i;
				}
			}

			if (this.World.FactionManager.getFaction(highest_faction) != null)
			{
				properties.Music = this.World.FactionManager.getFaction(highest_faction).getCombatMusic();
			}

			return properties;
		}
	})

})
