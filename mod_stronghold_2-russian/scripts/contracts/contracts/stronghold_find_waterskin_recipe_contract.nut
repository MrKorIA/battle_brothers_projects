this.stronghold_find_waterskin_recipe_contract <- this.inherit("scripts/contracts/contract", {
	//unlock the waterskin buyable item
	//spawns a custom camp in the desert
	//success sets flag in stronghold to allow the special action
	m = {
		Reward = 0,
		Destination = null,
		Title = "Найти рецепт странной воды"
	},
	function create()
	{
		this.m.DifficultyMult = ::Math.rand(116, 130) * 0.01;
		this.m.Flags = this.new("scripts/tools/tag_collection");
		this.m.TempFlags = this.new("scripts/tools/tag_collection");
		this.createStates();
		this.createScreens();
		this.m.Type = "contract.stronghold_find_waterskin_recipe_contract";
		this.m.Name = "Мифический рецепт";
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
		return "ui/banners/factions/banner_05s"
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Найти место в пустыне."
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
				else
				{
					local disallowedTerrain = [];
					local camp;
					local distanceToOthers = 15;

					for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
					{
						if (i == this.Const.World.TerrainType.Desert)
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
						camp = this.World.spawnLocation("scripts/entity/world/locations/legendary/stronghold_waterskin_location", tile.Coords);
					}

					if (camp != null)
					{
						tile.TacticalType = this.Const.World.TerrainTacticalType.Desert;
						camp.onSpawned();
						camp.getSprite("selection").Visible = true;
						camp.setDiscovered(true);
						camp.setAttackable(true);
						camp.setOnEnterCallback(this.onDestinationAttacked.bindenv(this));
						this.World.uncoverFogOfWar(camp.getTile().Pos, 500.0);
						this.Contract.m.Destination = this.WeakTableRef(camp)
					}
				}
			}
			
			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					this.Contract.setScreen("SearchingTheCamp");
					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
			}
			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				this.Contract.setScreen("EnteringTheCamp");
				this.World.Contracts.showActiveContract();
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
			Text = "Согласно легендам, древнее кладбище в пустыне хранит рецепт вечной молодости. Отправляйтесь на поиски этого рецепта!",
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
			Text = "Отправиться на поиски?",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Да.",
					function getResult()
					{
						this.Contract.setState("Running");
						return 0;
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
			ID = "SearchingTheCamp",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_161.png[/img]{После победы над защитниками, вы обыскиваете останки и находите древний пергамент, заполненный неузнаваемыми письменами, а также колбу, наполненную странной жидкостью. Жидкость ведёт себя как вода, однако через стекло трудно определить ее истинную природу. Вы подозреваете, что это и есть легендарная вода жизни. Вы лениво тыкаете в грудные клетки скелетов поблизости - кости обглоданы начисто и притом уже довольно давно. Либо фляга не принесла им никакой пользы, либо они получили её уже после того, как умерли.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Пора возвращаться домой.",
					function getResult()
					{
						local item = this.new("scripts/items/special/fountain_of_youth_item");
						this.World.Assets.getStash().makeEmptySlots(1);
						this.World.Assets.getStash().add(item);
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/items/consumables/youth_01.png",
					text = "Вы получаете странную воду и пергамент."
				});
			}
		});
		this.m.Screens.push({
			ID = "EnteringTheCamp",
			Title = "По мере приближения",
			Text = "[img]gfx/ui/events/event_167.png[/img]{Вы находите остатки лагеря в пустыне. Он окружен забором из человеческих костей. Внезапно, кости в центре начинают двигаться, и перед вами появляется небольшая группа бесплотных мертвецов. Трое из них имеют богатые украшения и, тем самым, заметно отличаются от остальных. Пока вы удивляетесь, как эта жалкая группа сумела выжить так долго, земля начинает грохотать, и из нее поднимается множество массивных зачарованных камней.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "К оружию!",
					function getResult()
					{
						this.World.State.getLastLocation().setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
						this.World.Contracts.showCombatDialog();
					}
				},
				{
				Text = "Бегите, глупцы!",
					function getResult()
					{
						return 0;
					}
				}
				
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_15.png[/img]{Историку удается перевести пергамент. Он описывает процесс создания воды жизни. Это будет дорого стоить, но глава гильдии алхимиков уверен, что им удастся его создать.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Превосходно.",
					function getResult()
					{
						this.Stronghold.getPlayerFaction().m.Flags.set("Waterskin", true);
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
					icon = "ui/items/consumables/youth_01.png",
					text = "Вы получаете рецепт живой воды."
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
				this.m.Destination.die()
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

