this.stronghold_free_mercenaries_contract <- this.inherit("scripts/contracts/contract", {
	//unlock hiring mercenaries
	//fight noble patrol going between two settlements
	//get hired mercenaries on success + flag in base to hire more in the future 
	m = {
		Reward = 0,
		Origin = null,
		Target = null,
		Title = "Освобождение наёмников",
		LastCombatTime = 0.0,
		Destination = null,
		Enemy_Faction = null,
	},
	function create()
	{
		this.m.DifficultyMult = ::Math.rand(116, 130) * 0.01;
		this.m.Flags = this.new("scripts/tools/tag_collection");
		this.m.TempFlags = this.new("scripts/tools/tag_collection");
		this.createStates();
		this.createScreens();
		this.m.Type = "contract.stronghold_free_mercenaries_contract";
		this.m.Name = "Освобождение наёмников";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 1500.0;
	}

	function onImportIntro()
	{
		#this.importSettlementIntro();
	}

	function start()
	{
		this.contract.start();
	}
	
	function getBanner()
	{
		return "ui/banners/factions/banner_09s"
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Выследить караван благородного дома",
					"Не дать сбежать людям благородного дома"
				];
				this.Contract.setScreen("Task");
			}

			function end()
			{					
				this.World.Contracts.setActiveContract(this.Contract);
				this.Contract.setScreen("Overview_Building");
			}

		});
		
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Target)
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
					this.Contract.m.Target.setVisibleInFogOfWar(true);
					local originTown = null;
					local originID = this.Contract.m.Flags.get("OriginID");
					foreach(settlement in ::World.EntityManager.getSettlements())
					{
						if (settlement.getID() == originID)
						{
							originTown = settlement;
							break;
						}
					}
					local originTownName = originTown == null ? "" : originTown.getName();

					this.Contract.m.BulletpointsObjectives = [
						"Перехватить караван благородного дома, едущий из города " + originTownName + " в " + this.Contract.m.Destination.getName(),
						"Не дайть ему достигнуть цели и не позволить никому сбежать из битвы!"
					];
				}
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
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
				}
			}
			
			function onActorRetreated( _actor, _combatID )
			{
				if (!_actor.isNonCombatant() && _actor.getFaction() == ::World.FactionManager.getFactionOfType(this.Const.FactionType.StrongholdEnemies).getID())
				{
					this.Contract.m.Flags.set("Survivors", this.Contract.m.Flags.get("Survivors") + 1);
				}
			}
			
		
		});
		
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Вернуться в " + this.Contract.m.Home.getName()
				];
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					if (this.Contract.m.Flags.get("Survivors") > 3)
					{
						this.Contract.setScreen("Failure2");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("Success1");
						this.World.Contracts.showActiveContract();
					}
				}
			}

		});
	}

	function createScreens()
	{	
		this.m.Screens.push({
			ID = "Task",
			Title = this.m.Title,
			Text = "До нас дошли слухи, что банду наёмников перевозят в крепость, где их ожидает казнь за преступление, в котором их почти наверняка не уличили. Сообщество наёмников всколыхнулось из-за очередного несправедливого обращения с абсолютно честными братьями по оружию.\n%randombrother% предполагает, что мы могли бы заработать несколько очков репутации, если бы пошли и помогли этим бедным душам избавиться от их наказания. Хотя, наверное, стоит провернуть это дело предельно скрытно.\n\nТранспортировка заключенных начнется через [b]три дня[/b]\n\nВнимание: У некоторых игроков возникают сбои при начале боя, связанного с этим заданием. Сохранитесь перед принятием контракта!",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Какие есть варианты?",
					function getResult()
					{
						
						return "Overview_Building";
					}

				},
				{
					Text = "Я не хочу начинать эти поиски прямо сейчас.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		
		this.m.Screens.push({
			ID = "Overview_Building",
			Title = this.m.Title,
			Text = "Разгромите патруль, который сопровождает заключённых, прежде чем они доберутся до места назначения. Не позволяйте слишком многим из них сбежать!",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Да.",
					function getResult()
					{
						return "Details"
					}

				},
				{
					Text = "Нет.",
					function getResult()
					{
						this.Contract.removeThisContract()
						return 0;
					}

				}
			],
			ShowObjectives = true,
			ShowPayment = true,
			ShowEmployer = true,
			ShowDifficulty = false,
			function start()
			{
				this.Contract.m.IsNegotiated = true;
			}
		});

		this.m.Screens.push({
			ID = "Details",
			Title = this.m.Title,
			Text = "",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Понятно.",
					function getResult()
					{
						if (this.Contract.m.Target == null)
						{
							this.Contract.setSuccessFlag();
							this.World.Contracts.finishActiveContract();
							return 0;
						}
						this.Contract.setState("Running");
						return 0;
					}

				}
			],
			function start()
			{
				local params = this.Contract.determineOriginAndDestination();
				//failsafe
				if (params.Origin == null || params.Destination == null)
				{
					this.Text = "На карте нет подходящих поселений для этого задания. Оно будет выполнено автоматически. Теперь вы можете пользоваться услугами банды наёмников.";
					return;
				}
				::Stronghold.getHostileFaction().copyLooks(params.Faction);
				local party = ::Stronghold.getHostileFaction().spawnEntity(params.Origin.getTile(), "Армия благородного дома", false, this.Const.World.Spawn.Noble, 800);
				party.setDescription("Армия благородного дома, сопровождающая заключённых.");
				party.setFootprintType(this.Const.World.FootprintsType.Nobles);
				party.setAttackableByAI(false);
				party.setVisibleInFogOfWar(true);
				party.setImportant(true);
				party.setDiscovered(true);
				party.setMovementSpeed(100);
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				local wait = this.new("scripts/ai/world/orders/wait_order");
				wait.setTime(3 * this.World.getTime().SecondsPerDay);
				local move = this.new("scripts/ai/world/orders/move_order");
				move.setDestination(params.Destination.getTile());
				move.setRoadsOnly(true);
				local despawn = this.new("scripts/ai/world/orders/despawn_order");
				c.addOrder(wait);
				c.addOrder(move);
				c.addOrder(despawn);
				this.Contract.m.Flags.set("Survivors", 0);

				this.Contract.m.Target = this.WeakTableRef(party);
				this.Contract.m.Enemy_Faction = party.getFaction();

				this.Contract.m.Flags.set("OriginID", params.Origin.getID());
				this.Contract.m.Destination = this.WeakTableRef(params.Destination);

				this.Text = "Караван будет готовиться три дня в городе " + params.Origin.getName() + " прежде чем начать движение в направлении города " + params.Destination.getName() + ". Убедитесь, что вы прибудете вовремя!"
			}
		});
		
		this.m.Screens.push({
			ID = "TalkingToTheSurvivors",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_53.png[/img]{После победы над благородной армией вы освобождаете наёмников от цепей. Они тут же набрасываются на трупы своих похитителей и забирают с них всё, что могут унести. Отчасти из злобы, отчасти из-за нищеты. Закончив, они дают знак, что готовы следовать за вами к дому.}"
			Image = "",
			List = [],
			Options = [
				{
					Text = "Пора парням обрести свой дом.",
					function getResult()
					{
						this.Contract.spawnMercenaries();
						this.Contract.setState("Return");
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
			Text = "[img]gfx/ui/events/event_53.png[/img]{Наёмники рады освобождению. Они спрашивают, могут ли они поселиться в вашей крепости, и вы с готовностью соглашаетесь: несколько сильных рук никогда не будут лишними.\nПосле этого проишествия вы в большом фаворе у других отрядов наёмников. Они могут даже вам предлагать свои услуги со скидкой.}"
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Вы можете пойти с нами.",
					function getResult()
					{
						this.Stronghold.getPlayerFaction().clearContracts()
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				},
				{
					Text = "Вы заслуживаете передышку.",
					function getResult()
					{
						foreach ( unit in this.Stronghold.getPlayerFaction().m.Units){
							if (unit.getFlags().get("Stronghold_Mercenaries")){
								unit.fadeOutAndDie()
							}
						}
						this.Stronghold.getPlayerFaction().clearContracts()
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.setSuccessFlag();
				this.List.push({
					id = 10,
					icon = "ui/events/event_134.png",
					text = "Теперь вы можете пользоваться помощью банды наёмников"
				});

			}
		});
		
		this.m.Screens.push({
			ID = "Failure1",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_95.png[/img]{Вы не смогли вовремя спасти наёмников. Они будут брошены в клетку и в скором времени окажутся в петле палача. А вам придётся жить с этим!}"
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Отвратительно.",
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
			ID = "Failure2",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_53.png[/img]{Наёмники рады освобождению. Они спрашивают, могут ли они поселиться в вашей крепости, и вы с готовностью соглашаетесь: несколько сильных рук никогда не будут лишними. Однако ваш смотритель сообщает, что ваши действия не остались незамеченными. Слишком многие из сопровождающих солдат выжили, рассказав произошедшую историю, в результате, дворяне объявили вас своим врагом.\nНо всё же, после этого проишествия вы в большом фаворе у других отрядов наёмников. Они могут даже вам предлагать свои услуги со скидкой.}"
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Проклятье!",
					function getResult()
					{
						this.World.FactionManager.getFaction(this.Contract.m.Enemy_Faction).addPlayerRelationEx( -50, "Убил людей благородного дома, с целью освободить осуждённых преступников")
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.setSuccessFlag();
				this.List.push({
					id = 10,
					icon = "ui/events/event_134.png",
					text = "Теперь вы можете пользоваться помощью банды наёмников"
				});

			}
		});
	}

	function determineOriginAndDestination()
	{
		local playerBase = this.m.Home;
		local noble_factions = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		local selected_faction = null;
		local selected_start_settlement = null;
		local selected_end_settlememt = null;
		local total_dist = 0;

		foreach (faction in noble_factions)
		{
			local settlements = faction.getSettlements()
			if (settlements.len() < 2)
			{
				continue;
			}
			local start_settlement = null
			local end_settlement = null
			local longestDistanceBetweenSettlements = 0
			local distFurthestFromBase = 0
			foreach (settlement in settlements)
			{
				if (!settlement.isIsolated() && settlement.getTile().getDistanceTo(playerBase.getTile()) > distFurthestFromBase)
				{
					start_settlement = settlement
					distFurthestFromBase = settlement.getTile().getDistanceTo(playerBase.getTile())
				}
			}
			if (start_settlement == null) continue
			foreach (settlement in settlements)
			{
				if (settlement != start_settlement && settlement.isMilitary() && settlement.isConnectedToByRoads(start_settlement) && settlement.getTile().getDistanceTo(start_settlement.getTile()) > longestDistanceBetweenSettlements)
				{
					end_settlement = settlement
					longestDistanceBetweenSettlements = settlement.getTile().getDistanceTo(start_settlement.getTile())
				}
			}
			if (end_settlement == null) continue
			if (selected_faction == null || longestDistanceBetweenSettlements > total_dist)
			{
				selected_faction = faction;
				total_dist = longestDistanceBetweenSettlements;
				selected_start_settlement = start_settlement
				selected_end_settlememt = end_settlement
			}
		}
		if (selected_end_settlememt == null || selected_start_settlement == null)
		{
			local settlements = this.World.EntityManager.getSettlements()
			local start_settlement = null
			local end_settlement = null
			local longestDistanceBetweenSettlements = 0
			local distFurthestFromBase = 0
			foreach (settlement in settlements)
			{
				if (!settlement.isIsolated() && settlement.m.Culture != this.Const.World.Culture.Southern && settlement.getTile().getDistanceTo(playerBase.getTile()) > distFurthestFromBase)
				{
					start_settlement = settlement
					distFurthestFromBase = settlement.getTile().getDistanceTo(playerBase.getTile())
				}
			}
			if (start_settlement != null)
			{
				foreach (settlement in settlements)
				{
					if (settlement != start_settlement && settlement.isAlliedWith( start_settlement ) && settlement.isMilitary() && settlement.isConnectedToByRoads(start_settlement)
						&& settlement.getTile().getDistanceTo(start_settlement.getTile()) > longestDistanceBetweenSettlements)
					{
						end_settlement = settlement
						longestDistanceBetweenSettlements = settlement.getTile().getDistanceTo(start_settlement.getTile())
					}
				}
			}
			if (end_settlement != null)
			{
				selected_faction = start_settlement.getFactionOfType(this.Const.FactionType.NobleHouse);
				total_dist = longestDistanceBetweenSettlements;
				selected_start_settlement = start_settlement
				selected_end_settlememt = end_settlement
			}
		}
		return {
			Origin = selected_start_settlement,
			Destination = selected_end_settlememt,
			Faction = selected_faction
		}
	}

	function setSuccessFlag()
	{
		this.Stronghold.getPlayerFaction().m.Flags.set("Mercenaries", true);
	}

	function onPrepareVariables( _vars )
	{
	}

	function onHomeSet()
	{
	}

	function onClear()
	{

		if (this.m.IsActive)
		{
			if (this.m.Target != null && !this.m.Target.isNull())
			{
				this.m.Target.getSprite("selection").Visible = false;
				this.m.Target.setOnCombatWithPlayerCallback(null);
			}
			this.World.FactionManager.getFaction(this.getFaction()).setActive(true);
			this.m.Home.getSprite("selection").Visible = false;
		}
	}
	
	function cancel()
	{
		this.onCancel();
	}
	function removeThisContract()
	{
		this.World.Contracts.removeContract(this);
		this.Stronghold.getPlayerFaction().updateQuests();
		this.World.State.getTownScreen().updateContracts();
	}
	function spawnMercenaries()
	{
		local playerBase =  this.getHome()
		local playerFaction = this.Stronghold.getPlayerFaction()
		local partyStrength = 200
		local trainingCamp = playerBase.getLocation( "attached_location.militia_trainingcamp" );
		if (trainingCamp)
			partyStrength += trainingCamp.getAlliedPartyStrengthIncrease();

		local party = playerFaction.spawnEntity(this.World.State.getPlayer().getTile(), "Освобожденные наемники", true, this.Const.World.Spawn.Mercenaries, partyStrength);
		party.getSprite("body").setBrush("figure_mercenary_01");
		party.setDescription("Банда наёмников, следующая за вами повсюду.");
		party.setFootprintType(this.Const.World.FootprintsType.CityState);
		party.setMovementSpeed(200)
		party.getFlags().set("Stronghold_Mercenaries", true);
		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false)
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false)
		local follow = this.new("scripts/ai/world/orders/stronghold_follow_order");
		follow.setDuration(::Stronghold.Misc.MercenaryFollowDays);
		c.addOrder(follow);
	}

	function onSerialize( _out )
	{
		_out.writeU8(this.m.Enemy_Faction);
		if (this.m.Destination != null && !this.m.Destination.isNull())
		{
			_out.writeU32(this.m.Destination.getID());
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
		this.m.Enemy_Faction = _in.readU8()

		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}
		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}
		this.contract.onDeserialize(_in);
	}
});

