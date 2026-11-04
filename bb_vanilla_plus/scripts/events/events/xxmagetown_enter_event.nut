this.xxmagetown_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.xxmagetown_enter_event";
		this.m.Title = "По мере приближения...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_108.png[/img]{Мистическая аура окутывала гигантскую башню волшебника. Когда ваша группа приблизилась к башне, в мгновение ока окружающее пространство заполнило голубое туманное облако. Когда туман рассеялся, появился старик в роскошной мантии с группой солдат. Старик торжественно произнес: %SPEECH_ON%Я — хозяин башни и правитель этой области. Ни одна армия не может ступить в мою башню. Наемники, покиньте мою башню немедленно!%SPEECH_OFF%Сражаться с армией волшебников — рискованное предприятие, но в башне вас ждет нечто очень редкое. Вам предстоит сделать выбор.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Готовьтесь к битве!",
					function getResult( _event )
					{
						local pp = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						pp.CombatID = "Event";
						pp.Music = this.Const.Music.NobleTracks;
						pp.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						pp.LocationTemplate.Template[0] = "tactical.xxtactical_knighttown";
						pp.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
						pp.LocationTemplate.CutDownTrees = true;
						pp.LocationTemplate.ShiftX += 3;
						pp.TerrainTemplate = "tactical.quarry";
						pp.IsAutoAssigningBases = false;
						pp.IsLootingProhibited = true;
						pp.IsWithoutAmbience = true;
						pp.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
						pp.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						pp.BeforeDeploymentCallback = function ()
						{
							local size = this.Tactical.getMapSize();
							local tiletypemax = 0;
							for( local x = 0; x < size.X; x = ++x )
							{
								for( local y = 0; y < size.Y; y = ++y )
								{
									local tile = this.Tactical.getTileSquare(x, y);
									tile.Level = this.Math.min(1, tile.Level);
									tiletypemax = tiletypemax + 1;
									if (tiletypemax > 576 && this.Math.rand(1, 100) <= 95)
									{
										tile.setBrush("tile_road");
									}
									if (tiletypemax > 512 && tiletypemax < 545 && this.Math.rand(1, 100) <= 111)
									{
										tile.clear();
										tile.Type = 0;
										this.MapGen.get("tactical.tile.swamp1").onFirstPass({
											X = tile.SquareCoords.X,
											Y = tile.SquareCoords.Y,
											W = 1,
											H = 1,
											IsEmpty = true,
											SpawnObjects = false
										});
										tile.removeObject();
										tile.spawnDetail("steppe_stone_detail_0" + this.Math.rand(1, 9)).Scale = 0.9;
									}
									if (tiletypemax > 544 && tiletypemax < 577 && this.Math.rand(1, 100) <= 95)
									{
										tile.removeObject();
										tile.clear();
										local tt = tile.spawnObject("entity/tactical/objects/graveyard_wall");
										tt.getSprite("body").setBrush("graveyard_29_07");
									}
									if (tiletypemax > 557 && tiletypemax < 563 && this.Math.rand(1, 100) <= 95)
									{
										tile.removeObject();
										tile.clear();
									}
								}
							}
						};
						if (this.Const.DLC.Desert)
						{
							pp.IsArenaMode = true;
							this.Const.Sound.Volume.Arena = 0;
							this.Const.Sound.ArenaStart = [ "sounds/cloth_01.wav" ];
							this.Const.Sound.ArenaEnd = [ "sounds/cloth_01.wav" ];
							this.Const.Sound.ArenaOutro = [ "sounds/cloth_01.wav" ];
						}
						pp.Entities = [];
						for( local i = 0; i < 5; i = ++i )
						{
							pp.Entities.push({
								ID = this.Const.EntityType.AlpShadow,
								Variant = 0,
								Row = 0,
								Script = "scripts/entity/tactical/humans/noble_footman",
								Faction = this.Const.Faction.Enemy
							});
						}
						pp.Entities.push({
							ID = this.Const.EntityType.AlpShadow,
							Variant = 0,
							Row = 1,
							Script = "scripts/entity/tactical/humans/noble_sergeant",
							Faction = this.Const.Faction.Enemy
						});
						pp.Entities.push({
							ID = this.Const.EntityType.AlpShadow,
							Variant = 2,
							Row = 1,
							Script = "scripts/entity/tactical/enemies/xxmob_bannerman",
							Faction = this.Const.Faction.Enemy
						});
						for( local i = 0; i < 2; i = ++i )
						{
							pp.Entities.push({
								ID = this.Const.EntityType.AlpShadow,
								Variant = 0,
								Row = 0,
								Script = "scripts/entity/tactical/humans/noble_greatsword",
								Faction = this.Const.Faction.Enemy
							});
						}
						for( local i = 0; i < 4; i = ++i )
						{
							pp.Entities.push({
								ID = this.Const.EntityType.AlpShadow,
								Variant = 0,
								Row = 1,
								Script = "scripts/entity/tactical/humans/noble_billman",
								Faction = this.Const.Faction.Enemy
							});
						}
						for( local i = 0; i < 6; i = ++i )
						{
							pp.Entities.push({
								ID = this.Const.EntityType.AlpShadow,
								Variant = 0,
								Row = 2,
								Script = "scripts/entity/tactical/humans/noble_arbalester",
								Faction = this.Const.Faction.Enemy
							});
						}
						pp.Entities.push({
							ID = this.Const.EntityType.AlpShadow,
							Variant = 0,
							Row = 3,
							Script = "scripts/entity/tactical/enemies/xxmob_archmage",
							Faction = this.Const.Faction.Enemy
						});
						pp.Entities.push({
							ID = this.Const.EntityType.AlpShadow,
							Variant = 0,
							Row = 3,
							Script = "scripts/entity/tactical/enemies/xxmob_jinn",
							Faction = this.Const.Faction.Enemy
						});
						pp.Entities.push({
							ID = this.Const.EntityType.AlpShadow,
							Variant = 0,
							Row = 3,
							Script = "scripts/entity/tactical/enemies/xxmob_jinn",
							Faction = this.Const.Faction.Enemy
						});
						_event.registerToShowAfterCombat("Victory", "Defeat");
						this.World.State.startScriptedCombat(pp, false, false, true);
						return 0;
					}
				},
				{
					Text = "Отступаем!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(false);
				}
			}
		});
		this.m.Screens.push({
			ID = "Victory",
			Text = "[img]gfx/ui/events/event_108.png[/img]{В Шпиле больше нет врагов, которые стояли на вашем пути. Вы прошли весь путь до вершины шпиля, чтобы найти все полезные предметы. Виды окрестностей с вершины шпиля были захватывающими.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Это того стоило.",
					function getResult( _event )
					{
						this.Const.Sound.Volume.Arena = 0.6;
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "После битвы...";
				this.World.Assets.getStash().makeEmptySlots(2);
				local item = this.new("scripts/items/special/trade_jug_01_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Вы получаете "  + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				if ("LegendMod" in this.Const)
				{
					item = this.new("scripts/items/misc/xx11_lvlpotion");
				}
				else
				{
					item = this.new("scripts/items/helmets/named/xxinvisiblehat");
				}
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Вы получаете "  + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				this.World.Assets.addMoney(5000);
				this.List.push({
					id = 10,
					icon = "ui/items/supplies/money.png",
					text = "Вы получаете 5000 крон"
				});
				local brothers = this.World.getPlayerRoster().getAll();
				foreach( bro in brothers )
				{
					bro.improveMood(10, "Мораль повысилась");

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
				this.World.uncoverFogOfWar(this.World.State.getPlayer().getPos(), 1900.0);
				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().die();
				}
			}

		});
		this.m.Screens.push({
			ID = "Defeat",
			Text = "[img]gfx/ui/events/event_88.png[/img]{Что это за место? Увидев возможность сбежать, вы решаете убежать отсюда.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Не стоило сюда приходить...",
					function getResult( _event )
					{
						this.Const.Sound.Volume.Arena = 0.6;
						return 0;
					}
				}
			],
			function start( _event )
			{
				_event.m.Title = "После битвы...";
			}
		});
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
	}

});

