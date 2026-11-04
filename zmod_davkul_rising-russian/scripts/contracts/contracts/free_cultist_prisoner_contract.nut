this.free_cultist_prisoner_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Target = null,
		CultistLair = null,
		StartVillage = null,
		NobleName = null
	},

	function create()
	{
		this.contract.create();
		this.m.Type = "contract.free_cultist_prisoner";
		this.m.Name = "Освободить заключённого";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function setDifficultyBasedOnSize()
	{
		local size = this.m.CultistLair.m.Size
		if (size == 2) return this.Math.rand(95, 105) * 0.01
		else return this.Math.rand(115, 135) * 0.01
	}

	function setDestination(_faction)
	{
		local lairs = []
		foreach (lair in this.getCultists().getLairs()){
			if (lair.m.Size > 1 && lair.m.TargetSettlement != null && lair.m.TargetSettlement.getFactionOfType(this.Const.FactionType.NobleHouse).getID() == _faction.getID()) {
			    lairs.push(lair)
			}
		}
		this.m.CultistLair = this.WeakTableRef(this.Math.randArray(lairs))
		this.m.DifficultyMult = this.setDifficultyBasedOnSize()
	}

	function start()
	{
		local closestDist = 999
		foreach (village in this.World.EntityManager.getSettlements()){
			if (this.m.StartVillage == null || village.getTile().getDistanceTo(this.m.CultistLair.getTile()) <= closestDist){
				this.m.StartVillage = this.WeakTableRef(village);
				closestDist = village.getTile().getDistanceTo(this.m.CultistLair.getTile())
			}
		}
		if (this.getCultists().getLegendary() != null) this.m.Destination = this.WeakTableRef(this.getCultists().getLegendary())
		else
		{
			local dist = 0
			local chosen;
			foreach(loc in this.getCultists.getSettlements()){
				if(loc.getTile().getDistanceTo(this.m.StartVillage.getTile()) > dist){
					dist = loc.getTile().getDistanceTo(this.m.StartVillage.getTile())
					chosen = loc
				}
			}
			this.m.Destination = this.WeakTableRef(chosen)
		}
		this.m.Payment.Pool = 500 * this.m.CultistLair.getSize() * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
		local r = this.Math.rand(1, 2);

		if (r == 1)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else if (r == 2)
		{
			this.m.Payment.Completion = 1.0;
		}
		this.m.NobleName <- this.Const.Strings.NobleTitles[this.Math.rand(0, this.Const.Strings.NobleTitles.len() - 1)] + " " + this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]
		this.m.Flags.set("NobleName", this.m.NobleName)
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Освободить заключённого из локации к %startDirection% от поселения %startVillage%"
				];

				if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.IntroChance)
				{
					this.Contract.setScreen("Intro");
				}
				else
				{
					this.Contract.setScreen("Task");
				}
			}

			function end()
			{
				local turnedCultist = this.Math.rand(0, 100) <= 15
				if (turnedCultist && this.Contract.m.CultistLair.getSize() == 3){
					this.Flags.set("TurnedCultist", true);
				}
				
				local target = this.Contract.m.CultistLair
				target.clearTroops();
				target.m.Flags.set("ContractLocation", true)
				local resources = (80 + this.Contract.m.CultistLair.getSize() * 40) * this.Contract.getScaledDifficultyMult() * this.Contract.getDifficultyMult()
				this.Contract.addUnitsToEntity(target, this.Const.World.Spawn.CultistDefenders, resources);
				target.setLootScaleBasedOnResources(target.getResources()  * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());

				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.CultistLair != null || !this.Contract.m.CultistLair.isNull())
				{
					this.World.uncoverFogOfWar(this.Contract.m.CultistLair.getTile().Pos, 500.0);
					this.Contract.m.CultistLair.getSprite("selection").Visible = true;
					if(this.Flags.get("TurnedCultist")){
						this.Contract.m.CultistLair.setOnEnterCallback(this.onTurnedCultist.bindenv(this))
					}
				}
			}


			function update()
			{
				if (this.Contract.m.CultistLair == null || this.Contract.m.CultistLair.isNull())
				{
					if(this.Flags.get("TurnedCultist")){
						this.Contract.setScreen("Battlesite2");
					}
					else{
						this.Contract.setScreen("Battlesite1");
					}
					this.World.Contracts.showActiveContract();
				}
			}
			function onTurnedCultist(_dest){
				this.Contract.setScreen("TurnedCultist");
				this.World.Contracts.showActiveContract();
			}
		});

		this.m.States.push({
			ID = "Pursuit",
			function start()
			{
				local dir = this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.Contract.m.Destination.getTile())]
				this.Contract.m.Target.getSprite("selection").Visible = true;
				this.Contract.m.BulletpointsObjectives = [
					"Догнать шайку культистов, движущуюся к " + dir
				];
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull())
				{
					this.Contract.setScreen("TalkingToTheSurvivors");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.isEntityAt(this.Contract.m.Target, this.Contract.m.Destination))
				{
					this.Contract.m.Target.getController().addOrderInFront(this.new("scripts/ai/world/orders/despawn_order"));
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
				}
			}
		});
		
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Вернуться с освобожденными заключенными в " + this.Contract.m.Home.getName()
				];
				if (this.Flags.get("FailedToGetNoble")){
					this.Contract.m.BulletpointsObjectives = [
						"Вернуться в " + this.Contract.m.Home.getName() + " с докладом."
					];
				}
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					if (this.Flags.get("TurnedCultist"))
					{
					   	this.Contract.setScreen("SuccessTurnedCultist");
						this.World.Contracts.showActiveContract();
					}
					if(this.Flags.get("FailedToGetNoble"))
					{
						this.Contract.setScreen("BanditsTookNoblemen");
						this.World.Contracts.showActiveContract();
					}
					else {
					   	this.Contract.setScreen("Success1");
						this.World.Contracts.showActiveContract();
					}

				}
				if (this.Flags.get("BanditAmbush") &&this.Time.getVirtualTime() > this.Flags.get("BanditAmbushTime") + this.World.getTime().SecondsPerDay*0.7 
					&& this.World.State.getPlayer().getTile().getDistanceTo(this.Contract.m.Home.getTile()) < 10){
					this.Flags.set("BanditAmbush", false)
					this.Contract.setScreen("BanditAmbush")
					this.World.Contracts.showActiveContract();
				}
			}

		});
	}

	function createScreens()
	{
		this.importScreens(this.Const.Contracts.NegotiationDefault);
		this.importScreens(this.Const.Contracts.Overview);
		this.m.Screens.push({
			ID = "Task",
			Title = "Переговоры",
			Text = "[img]gfx/ui/events/event_45.png[/img]{Не успели вы войти в комнату, а нервный %employer% уже усадил вас на стул и дрожащими руками вручил кубок с вином в руку.%SPEECH_ON%%nobleman% отправился по моей просьбе проверить слухи о активности культистов возле деревни %startVillage%. Он должен был вернуться ещё несколько дней назад, но этого, как понимаешь, не случилось. Наёмник, я прошу тебя отправиться туда и узнать, где прячутся эти фанатики. Найди их и сотри в порошок. И самое главное - %nobleman% должен вернуться живым. Ты будешь щедро вознаграждён, если сделаешь всё как надо.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{И что же ты понимаешь под 'щедрой наградой'? | Сделать можно всё - лишь бы награда соответствовала.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Я не дурак, чтобы браться за подобное. | Это того не стоит.}",
					function getResult()
					{
						this.World.Contracts.removeContract(this.Contract);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});

		this.m.Screens.push({
			ID = "Battlesite1",
			Title = "На поле боя...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{После победы над культистами ваши люди принялись прочёсывать окрестности в поисках следов благородного пленника. Они находят множество изувеченных тел, но, к вашему облегчению, дворянина среди них нет. Внезапно, %randombrother% подходит к вам с вестью: он нашёл следы большой группы людей, среди которых, скорее всего, были и пленники. Они направились к %endDirection% отсюда, в дикие земли!",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Пора выдвигаться!",
					function getResult()
					{
						local playerTile = this.World.State.getPlayer().getTile();

						//get pivot point that'´s between player and legendary
						local destTile = this.Contract.m.Destination.getTile()
						local destX = playerTile.SquareCoords.X + (destTile.SquareCoords.X - playerTile.SquareCoords.X) /10
						local destY = playerTile.SquareCoords.Y + (destTile.SquareCoords.Y - playerTile.SquareCoords.Y) /10
						local pivotPoint = this.World.getTileSquare(destX, destY)
						local tile = this.Contract.getTileToSpawnLocation(pivotPoint, 0, 4, [this.Const.World.TerrainType.Mountains], true, true, true);


						local party = this.getCultists().spawnCultistEntity(tile, "Шайка Культистов", false, this.Const.World.Spawn.CultistRoamers, 200 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						party.setDescription("Шайка культистов, ведущая пленников");
						party.setFootprintType(this.Const.World.FootprintsType.Brigands);
						this.Contract.m.UnitsSpawned.push(party);
						party.getLoot().ArmorParts = this.Math.rand(0, 40);
						party.getLoot().Ammo = this.Math.rand(0, 40);
						party.addToInventory("supplies/strange_meat_item");
						party.addToInventory("supplies/strange_meat_item");
						party.addToInventory("supplies/strange_meat_item");
						this.Contract.m.Target = this.WeakTableRef(party);
						party.setAttackableByAI(false);
						party.setFootprintSizeOverride(0.75);
						party.m.BaseMovementSpeed = 75
						local c = party.getController();
						c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
						c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
						local move = this.new("scripts/ai/world/orders/move_noRoads_order");
						move.setDestination(this.Contract.m.Destination.getTile());
						c.addOrder(move);

						this.Const.World.Common.addFootprintsFromTo(playerTile, this.Contract.m.Target.getTile(), this.Const.GenericFootprints, this.Const.World.FootprintsType.Brigands, 0.75, 10.0);
						this.Contract.setState("Pursuit");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Battlesite2",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Ваши худшие ожидания оправдались - от %nobleman% остались только обугленные останки да фамильные украшения. Вы собираете его бренные останки и собираетесь вернуться в %startVillage%.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Возвращаемся к нашему нанимателю.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "TurnedCultist",
			Title = "По мере приближения к логову...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Ваш отряд осторожно пробирается к логову фанатиков. Культисты собрались вокруг центрального алтаря, на котором видна сгорбленная, изувеченная фигура. Должно быть это %nobleman%!\nПрежде чем вы принимаете решение о нападении, фигура на алтаре начинает подниматься. Теперь вы можете видеть, что дворянин стал слабо на себя похож: глаза выпучены, лицо искривлено в болезненном экстазе, а кожа и доспехи покрыты проклятыми рунами. Будто почуяв ваше присутствие, он оборачивается и впивается в вас ненавидящим взором.%SPEECH_ON%Думаешь, что тебе удастся прервать священный ритуал? Давкул принял меня, дабы я повёл его воинство к великой цели - погрузить очередной мир во мрак. Что же, пора опробовать свои новые силы. Я рад, что вы подвернулись мне под руку!%SPEECH_OFF%Истерзанный раб вручает осквернённому дворянину нечистое оружие, взмах которого порывает культистов в атаку.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "К оружию!",
					function getResult()
					{
						this.Math.seedRandom(this.Contract.m.CultistLair.getID())
						local boss = 
						{
							ID = this.Const.EntityType.Cultist_Defiler,
							Variant = 3,
							Strength = 40,
							Cost = 40,
							Row = 1,
							Script = "scripts/entity/tactical/cultist/mod_cultist_defiler",
							NameList = [this.Contract.m.NobleName + " Осквернённый"],
							TitleList = null
						}
						this.Const.World.Common.addTroop(this.Contract.m.CultistLair, {Type = boss}, false, 100);
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "TurnedCultist";
						properties.Music = this.Const.Music.CultistTracks;
						properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						
						this.World.Contracts.startScriptedCombat(properties, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% приглашает вас в свой кабинет. %nobleman% заходит вместе с вами. Они сердечно приветствуют друг друга. В конце концов, наниматель вспоминает о вашем присутствии.%SPEECH_ON%Молодец, наёмник. %reward_completion% крон, верно?%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Заслуженная награда.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Освободил заключённого дворянина из лап культистов");
						this.World.Contracts.finishActiveContract();

						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы получаете [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] крон"
				});
			}

		});

		this.m.Screens.push({
			ID = "SuccessTurnedCultist",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% наблюдает за тем, как вы следуете к нему сквозь город. Мёртвый %nobleman% лежит в повозке позади вас. Вы излагаете произошедшее в логове, в то время как %employer% слушает с нарастающим беспокойством.%SPEECH_ON%Ни за что бы не подумал... У этих культистов есть способ обратить даже лучших из людей. И всё же ты сделал то, о чем тебя просили. Вот, возьми свои %reward_completion% крон и оставь меня.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Заслуженная награда.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Сразил дворянина, обращённого в культиста");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы получаете [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] крон"
				});
			}

		});

		this.m.Screens.push({
			ID = "Failure1",
			Title = "Тем временем...",
			Text = "[img]gfx/ui/events/event_04.png[/img]%randombrother% подходит к вам. %SPEECH_ON%Командир, я не думаю, что мы их поймаем... Всё кончено.%SPEECH_OFF%",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Мы потерпели неудачу.",
					function getResult()
					{
						this.Flags.set("FailedToGetNoble", true)
						this.Contract.setState("Return");
						return 0
					}

				}
			],
		});
		this.m.Screens.push({
			ID = "BanditAmbush",
			Title = "Тем временем...",
			Text = "[img]gfx/ui/events/event_04.png[/img]Внезапно вы оказываетесь в окружении группы суровых мужчин, обнажающих оружие. Ваши люди, застигнутые врасплох, спешат вооружиться. Их предводитель подходит к вам.%SPEECH_ON%Это тот самый добрый лорд %nobleman% прячется за вашими спинами? Этот ублюдок приказал напасть на моего двоюродного брата, и за это я хочу оторвать ему голову! Вы отдадите его добровольно, или мне придётся послать за ним своих парней?%SPEECH_OFF%.",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Забирайте его, я не против.",
					function getResult()
					{
						return "BanditOfferAccepted"
					}

				},
				{
					Text = "Мы прошли через многое, чтобы вернуть его. Может договоримся?",
					function getResult()
					{
						if(this.Math.rand(1, 2) == 1){
							return "BanditsOfferMoney"
						}
						else return "BanditsAttack"
					}

				},
				{
					Text = "Только через мой труп.",
					function getResult()
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Contract";
						properties.Music = this.Const.Music.BanditTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.BanditRaiders, this.Math.rand(250, 350) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
						this.World.State.startScriptedCombat(properties, false, false, true);
					}

				}
			],
		});
		this.m.Screens.push({
			ID = "BanditsOfferMoney",
			Title = "Тем временем...",
			Text = "[img]gfx/ui/events/event_04.png[/img]%SPEECH_ON%Я могу предложить тебе такой вариант: три тысячи крон и расходимся мирно. Мой двоюродный брат, разумеется, был членом семьи, но он мне никогда не нравился.%SPEECH_OFF%",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Я принимаю это предложение.",
					function getResult()
					{
						
						return "BanditOfferAcceptedMoney"
					}

				},
				{
					Text = "Да ну на хрен! К оружию!",
					function getResult()
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Contract";
						properties.Music = this.Const.Music.BanditTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.BanditRaiders, this.Math.rand(250, 350) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
						this.World.State.startScriptedCombat(properties, false, false, true);
					}

				}
			],
		});
		this.m.Screens.push({
			ID = "BanditOfferAcceptedMoney",
			Title = "Тем временем...",
			Text = "[img]gfx/ui/events/event_04.png[/img]Игнорируя крики и мольбы дворянина, вы отдаёте его бандитам. Некоторые из ваших людей чувствуют себя неуютно из-за данного решения, но вы убеждаете их, что дворянин поступил бы c ними точно так же. Теперь пора подумать о том, какую историю рассказать вашему нанимателю...",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Такова жизнь в землях, где правят кроны.",
					function getResult()
					{
						this.Flags.set("FailedToGetNoble", true)
						this.Flags.set("BanditOfferAccepted", true)
						return 0
					}

				}
			],
			function start()
			{
				this.World.Assets.addMoney(3000);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы получаете [color=" + this.Const.UI.Color.PositiveEventValue + "]" +  "3000" + "[/color] крон"
				});
			}
		});
		this.m.Screens.push({
			ID = "BanditOfferAccepted",
			Title = "Тем временем...",
			Text = "[img]gfx/ui/events/event_04.png[/img]Игнорируя крики и мольбы дворянина, вы отдаёте его бандитам. Некоторые из ваших людей чувствуют себя неуютно из-за данного решения, но вы убеждаете их, что дворянин поступил бы c ними точно так же. Теперь пора подумать о том, какую историю рассказать вашему нанимателю...",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Такова жизнь в королевских землях.",
					function getResult()
					{
						this.Flags.set("FailedToGetNoble", true)
						this.Flags.set("BanditOfferAccepted", true)
						return 0
					}

				}
			],
		});

		this.m.Screens.push({
			ID = "BanditsAttack",
			Title = "Тем временем...",
			Text = "[img]gfx/ui/events/event_04.png[/img]%SPEECH_ON%Посмотрите на него, торгуется как напыщенный %nobleman%. Я знал, что все наёмники - ручные шавки, но это чересчур. Хватай их!%SPEECH_OFF%",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "К оружию!",
					function getResult()
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Contract";
						properties.Music = this.Const.Music.BanditTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.BanditRaiders, this.Math.rand(300, 400) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
						this.World.State.startScriptedCombat(properties, false, false, true);
					}

				}
			],
		});
		this.m.Screens.push({
			ID = "TalkingToTheSurvivors",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_53.png[/img]{Культисты побеждены, вы освобождаете их пленников. Среди них вы находите дворянина, потрёпанного, но, к вашему удивлению, всё ещё живого.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Мы сделали то, за чем пришли. Пришла пора вернуться в %townname%!",
					function getResult()
					{
						this.Contract.setState("Return");
						local ambush = this.Math.rand(0, 100)
						if (this.isDebug("mod_cultists")) {
						    ambush = 0
						}
						if(ambush < 10){
							this.Flags.set("BanditAmbush", true)
							this.Flags.set("BanditAmbushTime", this.Time.getVirtualTime())
						}
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BanditsTookNoblemen",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_53.png[/img]{Вы входите в гостиную своего нанимателя с удручённым выражением лица. Вы объясняете, что нашли и уничтожили логово культистов, но не вдаётесь в подробности о пропавшем дворянине.%SPEECH_ON%Что случилось? Где %nobleman%?%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Его не оказалось в логове культистов, нам не удалось его найти, к сожалению.",
					function getResult()
					{
						local odds = 80
						local rng = this.Math.rand(0, 100)
						local soldNobleman = this.Flags.get("BanditOfferAccepted") ? true:false;
						if (soldNobleman) odds -= 30
						if (this.World.Assets.getMoralReputation() >= 80) odds += 10
						if (rng < odds) return "FailureWeak"
						return  soldNobleman? "FailureAndLied" : "FailureMedium"
					}

				},
				{
					Text = "Мы попали в засаду бандитов, он погиб во время сражения.",
					function getResult()
					{
						local odds = 60
						local rng = this.Math.rand(0, 100)
						local soldNobleman = this.Flags.get("BanditOfferAccepted") ? true:false;
						if (soldNobleman) odds -= 30
						if (this.World.Assets.getMoralReputation() >= 80) odds += 10
						if (rng < odds) return "FailureWeak"
						return  "FailureMedium"
					}

				},
				{
					Text = "Мы продали его за кучу крон.",
					function getResult()
					{
						local odds = 40
						local soldNobleman = this.Flags.get("BanditOfferAccepted") ? true:false;
						if (soldNobleman) odds -= 30
						if (this.World.Assets.getMoralReputation() >= 80) odds += 10
						if (this.Math.rand(0, 100) < odds) return "EmployerThinksJoke"
						return "FailureAndAdmitted";
					}

				},
			]
		});
		this.m.Screens.push({
			ID = "FailureWeak",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_53.png[/img]Ваш наниматель тяжело вздыхает.%SPEECH_ON%Это очень прискорбно. Ты должен понимать, что я не могу выдать тебе вознаграждение полностью, так как вы выполнили не все условия контракта. Возьми эти кроны и постарайся не допускать подобных ошибок в будущем.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Могло быть и хуже.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Math.floor(this.Const.World.Assets.RelationNobleContractSuccess/2), "Уничтожил большое логово культистов");
						this.World.Assets.addMoney(this.Math.floor(this.Contract.m.Payment.getOnCompletion()/2));
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы получаете [color=" + this.Const.UI.Color.PositiveEventValue + "]" +  this.Math.floor(this.Contract.m.Payment.getOnCompletion()/2) + "[/color] крон"
				});
			}
		});
		this.m.Screens.push({
			ID = "FailureMedium",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_53.png[/img]Ваш наниматель заметно раздражён.%SPEECH_ON%Это не тот результат, которого я ожидал, наняв тебя! Меня не волнуют какие-то уроды на другом конце света, я хотел, чтобы %nobleman% вернулся! Убирайся отсюда.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Неблагодарный ублюдок.",
					function getResult()
					{
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
			}
		});
		this.m.Screens.push({
			ID = "FailureAndLied",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_53.png[/img]Всякое веселье покидает комнату, когда ваш наниматель прищуривает глаза.%SPEECH_ON%Как так? Почему тогда я только что получил сообщение о том, что %nobleman%, а точнее его сильно изуродованный труп, был найден повешенным на дереве недалеко отсюда? Убирайся с моих глаз, ты, лживый дьявол!%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Это была плохая идея.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(-30, "Продал дворянина бандитам.");
						this.World.Assets.addMoralReputation(-5);
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы потеряли 30 единиц репутации с " + this.World.FactionManager.getFaction(this.Contract.getFaction()).getName()
				});
			}
		});
		this.m.Screens.push({
			ID = "FailureAndAdmitted",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_53.png[/img]Ваш наниматель ударяет кулаками по столу.%SPEECH_ON%Негодяй! Предатель! Подонок! Убирайся с моих глаз, убирайся с моих земель, забудь дорогу сюда!%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Ноги в руки, парни!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(-100, "Продал дворянина бандитам");
						this.World.Assets.addMoralReputation(-10);
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = this.World.FactionManager.getFaction(this.Contract.getFaction()).getName()  + " теперь враждебен к вам."
				});
			}
		});
		this.m.Screens.push({
			ID = "EmployerThinksJoke",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_53.png[/img]Ухмыльнувшись, вы говорите.%SPEECH_ON%Мы продали его за огромную кучу крон.%SPEECH_OFF%Ваш наниматель смотрит на вас с недоверчивым выражением на лице, которое превращается в разрывающий грудь смех.%SPEECH_ON%О, какая дерзкая шутка! Что ж, я полагаю, что ничего нельзя было поделать. Вот, возьми эти кроны и постарайся не допускать подобных ошибок в будущем.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Я не могу поверить, что это сработало.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Освободил заключённого дворянина от культистов");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы получаете [color=" + this.Const.UI.Color.PositiveEventValue + "]" +  this.Contract.m.Payment.Completion + "[/color] крон"
				});
			}
		});


	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"startDirection",
			this.m.CultistLair == null || this.m.CultistLair.isNull() || !this.m.CultistLair.isAlive() ? "" : this.Const.Strings.Direction8[this.m.StartVillage.getTile().getDirection8To(this.m.CultistLair.getTile())]
		]);
		_vars.push([
			"endDirection",
			this.m.Destination == null ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Destination.getTile())]
		]);
		_vars.push([
			"startVillage",
			this.m.StartVillage == null ? "" : this.m.StartVillage.getName()
		]);
		_vars.push([
			"nobleman",
			this.m.NobleName
		]);
	}


	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.m.Flags.set("ContractLocation", false)
				this.m.Destination.getSprite("selection").Visible = false;
				this.m.Destination.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (this.getCultists().getLegendary() == null) return false
		local lvl3LairExists = false;
		foreach (lair in  this.getCultists().getLairs()){
			if (lair.m.Size == 3) {
			    lvl3LairExists = true
			}
		}
		return lvl3LairExists
	}

	function onSerialize( _out )
	{
		if (this.m.Destination != null && !this.m.Destination.isNull())
		{
			_out.writeU32(this.m.Destination.getID());
		}
		else
		{
			_out.writeU32(0);
		}
		if (this.m.CultistLair != null && !this.m.CultistLair.isNull())
		{
			_out.writeU32(this.m.CultistLair.getID());
		}
		else
		{
			_out.writeU32(0);
		}
		if (this.m.StartVillage != null && !this.m.StartVillage.isNull())
		{
			_out.writeU32(this.m.StartVillage.getID());
		}
		else
		{
			_out.writeU32(0);
		}
		if (this.m.Target != null && !this.m.Target.isNull())
		{
			_out.writeU32(this.m.Target.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}
		local CultistLair = _in.readU32();

		if (CultistLair != 0)
		{
			this.m.CultistLair = this.WeakTableRef(this.World.getEntityByID(CultistLair));
		}
		local StartVillage = _in.readU32();

		if (StartVillage != 0)
		{
			this.m.StartVillage = this.WeakTableRef(this.World.getEntityByID(StartVillage));
		}

		local Target = _in.readU32();

		if (Target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(Target));
		}
		this.contract.onDeserialize(_in);
		//save compatible
		this.m.NobleName = this.m.Flags.get("NobleName")
		// if flag not set
		if (this.m.NobleName == false){
			this.m.NobleName = this.Const.Strings.NobleTitles[this.Math.rand(0, this.Const.Strings.NobleTitles.len() - 1)] + " " + this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]
			this.m.Flags.set("NobleName", this.m.NobleName)
		}
	}

});

