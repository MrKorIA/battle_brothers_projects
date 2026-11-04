this.stronghold_free_trainer_contract <- this.inherit("scripts/contracts/contract", {
	//unlock turbo training
	//fight camp in the snow, 1 barb king champ and 2 chosen, select up to 3 of your guys to fight (works with less)
	//sets flag in base on success
	// the more contracts I write, the uglier they get
	m = {
		Reward = 0,
		Title = "Найти легендарного тренера",
		LastCombatTime = 0.0,
		Destination = null,
		Chosen = [],
		ChosenOptions = []
	},
	function create()
	{
		this.m.DifficultyMult = ::Math.rand(116, 130) * 0.01;
		this.m.Flags = this.new("scripts/tools/tag_collection");
		this.m.TempFlags = this.new("scripts/tools/tag_collection");
		this.createStates();
		this.createScreens();
		this.m.Type = "contract.stronghold_free_trainer_contract";
		this.m.Name = "Найти легендарного тренера";
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
		return "ui/banners/factions/banner_08s"
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Найти 'Поле войны'"
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
				if (this.Contract.m.Destination)
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
					this.Contract.m.Destination.setOnEnterCallback(this.onDestinationAttacked.bindenv(this));
				}
			}
			
			
			function update()
			{
				if (this.Flags.get("IsVictory"))
				{
					this.Contract.setScreen("IsVictory");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsFailure"))
				{
					this.Contract.setScreen("IsFailure");
					this.World.Contracts.showActiveContract();
				}
			}
			
			function onCombatVictory( _combatID )
			{
				if (_combatID == "ChosenTrainer")
				{
					this.Flags.set("IsVictory", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "ChosenTrainer")
				{
					this.Flags.set("IsFailure", true);
				}
			}
			
			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
					this.Contract.setScreen("EnteringTheCamp");
					this.World.Contracts.showActiveContract();
			}
			
			function end()
			{
				this.Contract.m.Destination.getSprite("selection").Visible = false;
				this.Contract.m.Destination.setOnEnterCallback(null);
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
					
					this.Contract.setScreen("Success1");
					this.World.Contracts.showActiveContract();
					
				}
			}

		});
	}

	function createScreens()
	{	
		this.m.Screens.push({
			ID = "Task",
			Title = this.m.Title,
			Text = "Рабы, сбежавшие от северных варваров, говорят о 'Поле войны', месте, где воины совершенствуют свои навыки и в конечном итоге становятся избранными, элитными варварскими воинами. И якобы мастерству их обучает легендарный тренер. Этот человек будет отличным подспорьем для нашей крепости. Мы должны найти его!",
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
					Text = "Поищу в другой раз.",
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
			Text = "Найдите 'Поле войны' в ледниках севера.",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Да.",
					function getResult()
					{
						local disallowedTerrain = [];
						local camp;
						local distanceToOthers = 15;

						for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
						{
							if (i == this.Const.World.TerrainType.SnowyForest)
							{
							}
							else
							{
								disallowedTerrain.push(i);
							}
						}

						local tile = this.Contract.getTileToSpawnLocation(this.Contract.m.Home.getTile(), 20, 300, disallowedTerrain);

						if (tile != null)
						{
							camp = this.World.spawnLocation("scripts/entity/world/locations/legendary/stronghold_trainer_location", tile.Coords);
						}

						if (camp != null)
						{
							tile.TacticalType = this.Const.World.TerrainTacticalType.SnowyForest;
							camp.onSpawned();
							camp.getSprite("selection").Visible = true;
							camp.setDiscovered(true);
							camp.setAttackable(true);
							this.World.uncoverFogOfWar(camp.getTile().Pos, 500.0);
							this.Contract.m.Destination = this.WeakTableRef(camp)
							this.Contract.setState("Running");
							return 0;
						}
						else
						{
							this.Contract.removeThisContract()
							this.logInfo("Could not find location to spawn Fields of War!")
							return 0
						}
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
			ID = "EnteringTheCamp",
			Title = "По мере приближения...",
			Text = "[img]gfx/ui/events/event_08.png[/img]{Уже издалека слышны стук металла и злобный смех. Вы приближаетесь к большой поляне в лесу, где множество варварских воинов практикуются, сражаясь друг с другом. Запах крови и меда наполняет воздух. Настороженные северяне отступают в сторону, когда вы пробираетесь к середине арены. В центре вы видите большой шатер, охраняемый множеством свирепых воинов. Ваши люди ждут снаружи, когда вы заходите внутрь. Великий царь варваров, называющий себя Повелителем войны, приветствует вас. Его сопровождает удивительный человек: старый мастер меча. Это, должно быть, и есть легендарный тренер избранных.\n Вы просите его сопровождать вас, но он отказывается.%SPEECH_ON%Эти люди знают истинный смысл жизни: овладеть боевыми искусствами и стать легендарными воинами. Покажи мне, что у тебя есть все необходимое, чтобы заслужить мои навыки!%SPEECH_OFF%Это соревнование мастеров.}" ,
			Image = "",
			List = [],
			Options = [
				{
					Text = "Мы принимаем вызов.",
					function getResult()
					{
						this.Contract.updateChosen()
						this.Contract.m.Screens.push({
							ID = "ChooseChampions",
							Title = "Подготовка.",
							Text = "[img]gfx/ui/events/event_07.png[/img]{Выберите бойцов.}",
							Image = "",
							List = [],
							Options = this.Contract.champtionOptions()
							function start()
							{
							}
						});
						return "ChooseChampions"
					}
				},
				{
				Text = "Мы ещё немного потренируемся и вернёмся попозже.",
					function getResult()
					{
						return 0;
					}
				}
				
			]
		});
		

		this.m.Screens.push({
			ID = "StartFight",
			Title = "Подготовка.",
			Text = "[img]gfx/ui/events/event_139.png[/img]{Северяне выстраиваются в круг, и ваши воины входят внутрь. Король выходит из шатра, к нему присоединяются еще двое избранных.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Заставьте меня гордиться вами, братья!",
					function getResult()
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.Entities = [];
						properties.CombatID = "ChosenTrainer";
						properties.Music = this.Const.Music.ArenaTracks;
						properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Arena;
						properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Arena;
						this.Contract.addToCombat(properties.Entities, this.Const.World.Spawn.Troops.BarbarianChosen, true, "Повелитель войны");
						this.Contract.addToCombat(properties.Entities, this.Const.World.Spawn.Troops.BarbarianChampion);
						this.Contract.addToCombat(properties.Entities, this.Const.World.Spawn.Troops.BarbarianChampion);
						foreach (bro in this.Contract.m.Chosen)
						{
							properties.Players.push(bro)
						}
						properties.IsUsingSetPlayers = true;
						properties.IsFleeingProhibited = true;
						properties.IsWithoutAmbience = true;
						properties.IsFogOfWarVisible = false;
						for( local i = 0; i < properties.Entities.len(); i = ++i )
						{
							properties.Entities[i].Faction <- this.Const.Faction.Enemy
						}
						properties.BeforeDeploymentCallback = function ()
						{
							local size = this.Tactical.getMapSize();

							for( local x = 0; x < size.X; x = ++x )
							{
								for( local y = 0; y < size.Y; y = ++y )
								{
									local tile = this.Tactical.getTileSquare(x, y);
									tile.Level = ::Math.min(1, tile.Level);
									tile.clear()
									tile.removeObject()
								}
							}
						};
						this.World.State.startScriptedCombat(properties, false, false, false);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		
		this.m.Screens.push({
			ID = "IsVictory",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_50.png[/img]{Ваши воины сразили Повелителя войны и его избранных. Некогда шумная толпа не протестует, когда вы собираете их снаряжение. Старый мастер меча впечатлен работой ваших людей.%SPEECH_ON%Значит, среди людей юга осталось несколько настоящих воинов. Что ж, очень хорошо, я буду сопровождать вас.' Вы покидаете Поле войны с мастером меча.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Пора домой.",
					function getResult()
					{
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
			ID = "IsFailure",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_135.png[/img]{Под оглушающие крики северян ваши воины повержены Повелителем войны и его избранными. Старый мастер меча усмехается, он знал, что так и будет. Вы покидаете Поле войны, не добившись ничего, кроме потери нескольких своих лучших людей.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Катастрофа.",
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
			ID = "Success1",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_53.png[/img]{Старый мастер меча оценил по достоинству вашу крепость. Он согласен обучать ваших новых людей, хотя его услуги стоят недёшево.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Превосходно.",
					function getResult()
					{
						this.Stronghold.getPlayerFaction().m.Flags.set("Teacher", true);
						this.Stronghold.getPlayerFaction().clearContracts()
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/events/event_134.png",
					text = "Теперь ваши новые братья могут получить ускоренное обучение."
				});

			}
		});
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
			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
			}
			this.World.FactionManager.getFaction(this.getFaction()).setActive(true);
			this.m.Home.getSprite("selection").Visible = false;
		}

	}

	function onIsValid()
	{
		return true;
	}
	
	function removeThisContract()
	{
		this.World.Contracts.removeContract(this);
		this.Stronghold.getPlayerFaction().updateQuests();
		this.World.State.getTownScreen().updateContracts();
	}
	
	function champtionOptions()
	{
		local options = [];
		foreach (bro in this.m.ChosenOptions)
		{
			options.push({
					Text = bro.getName() + ", ты - один из лучших!",
					function getResult()
					{
						{
							return "addChosen"
						}
					}

				});
		}
		return options;
	}
	function updateChosen()
	{
		local roster = this.World.getPlayerRoster().getAll();
		local options = []
		roster.sort(function ( _a, _b )
		{
			if (_a.getXP() > _b.getXP())
			{
				return -1;
			}
			else if (_a.getXP() < _b.getXP())
			{
				return 1;
			}

			return 0;
		});
		
		local numslots = ::Math.min(10, roster.len())
		for (local x = 0; x < numslots; x++)
		{
			options.push(roster[x])
		}
		this.m.ChosenOptions = options
	}
	function addToCombat( _list, _entityType, _champion = false, _name = "" )
	{
		local c = clone _entityType;

		if (c.Variant != 0 && _champion)
		{
			c.Variant = 1;
			c.Name <- _name;
		}
		else
		{
			c.Variant = 0;
		}

		_list.push(c);
	}
	
	function processInput( _option )
	{
		//hack into this function for dynamic bro selection
		if (this.m.ActiveScreen == null)
		{
			return false;
		}

		if (_option >= this.m.ActiveScreen.Options.len())
		{
			return true;
		}

		local result = this.m.ActiveScreen.Options[_option].getResult();
		if (result == "addChosen")
		{
			local has_unit = false
			foreach (bro in this.m.Chosen)
			{
				if (bro.getName() == this.m.ChosenOptions[_option].getName())
				{
					has_unit= true
				}
			}
			if (!has_unit)
			{
				this.m.Chosen.push(this.m.ChosenOptions[_option])
				this.m.ChosenOptions.remove(_option)				
				this.m.ActiveScreen.Options.remove(_option)
				this.World.Contracts.showActiveContract();
				
			}
			if(this.m.Chosen.len() == 3 || this.m.Chosen.len() == this.World.getPlayerRoster().getAll().len())
			{
				this.setScreen(this.getScreen("StartFight"));
			}
			return true;
		}
		
		if (typeof result != "string" && result <= 0)
		{
			if (this.isActive())
			{
				this.setScreen(null);
			}

			return false;
		}

		this.setScreen(this.getScreen(result));
		return true;
	}
	function cancel()
	{
		this.onCancel();
	}		

	function onSerialize( _out )
	{
		_out.writeI32(0);

		if (this.m.Destination != null && !this.m.Destination.isNull())
		{
			_out.writeU32(this.m.Destination.getID());
		}
		else
		{
			_out.writeU32(0);
		}
		this.contract.onSerialize(_out);
	}
	

	function onDeserialize( _in )
	{
		_in.readI32();
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		this.contract.onDeserialize(_in);
		

	}

});

