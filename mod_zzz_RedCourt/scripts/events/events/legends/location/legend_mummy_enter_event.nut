this.legend_mummy_enter_event <- this.inherit("scripts/events/event", {
	m = {
		LootTable = [
			"loot/white_pearls_item",
			"loot/jeweled_crown_item",
			"loot/gemstones_item",
			"loot/golden_chalice_item",
			"loot/ancient_gold_coins_item"
		]
	},
	function create()
	{
		this.m.ID = "event.location.legend_mummy_enter";
		this.m.Title = "При приближении...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_173.png[/img]{Мелкий песок засасывает сапоги, пока вы с трудом карабкаетесь на вершину очередной дюны. С её гребня открывается всё тот же безрадостный вид - бескрайние пески, простирающиеся меж волн барханов. Кое-где из барханов торчат обломки колонн, обрушившиеся входы в склепы и побелевшие кости - как человеческие, так и звериные. Вдалеке, сквозь марево горячего воздуха, проступают очертания устремлённой ввысь пирамиды. Её зловещий силуэт мгновенно пробуждает в памяти старые пугающие легенды, от которых волосы встают дыбом.\n\nПо мере приближения постройка кажется всё более чужеродной. На её стенах чётко видны слои - словно гробницу бесконечно перестраивали в течение веков, используя разные материалы, но безжалостное время не оставило на ней ни единой царапины. Внезапный, леденящий душу страх сковывает отряд: люди невольно хватаются за оружие, всматриваясь в узкий, но величественный вход, который достоин принять самого Императора.\n\nВопреки здравому смыслу, вы обнажаете меч и приказываете людям идти внутрь.\n\nВоздух внутри склепа тёплый, но тяжёлый и спёртый. Здесь не просто пахнет древностью - кажется, будто само время застыло в этих стенах навсегда. Бесчисленные глиняные кувшины и ритуальные урны ровными рядами теснятся у подножия массивных колонн. Это желанная добыча для любого расхитителя гробниц, и они веками стояли здесь, оберегаемые глухим безмолвием - до этой самой секунды.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Тем больше сокровищ достанется нам!",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Давайте не будем тревожить то, что покоится здесь.",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_89.png[/img]{По мере того как вы медленно продвигается вглубь душного каменного монолита, температура резко падает. Прохладный полумрак гробницы приносит долгожданную свежесть, уберегая покрытую солью и потом кожу от палящего южного солнца.\n\nЗал почти пуст. Единственное, что приковывает к себе взгляд помимо испещрённых клинописью стен, - это массивные каменные саркофаги. Они разительно отличаются друг от друга: на одних высечены грандиозные батальные сцены, на других - жестокий владыка, занёсший бич над безмолвными рабами, а третьи украшены барельефами тайного ритуала, который кто-то намеренно и грубо изуродовал, соскоблив лица участников. Остальные усыпальницы лишены каких-либо изысков. То ли погребённые в них не заслужили внимания камнерезов, то ли работу древних мастеров прервал чей-то внезапный и яростный приказ.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Что это был за шум?",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_89.png[/img]{Сделав ещё несколько шагов к усыпальницам, вы с содроганием замечаете, что внутренние каменные стенки саркофагов испещрены глубокими бороздами от ногтей - кто-то в кромешной тьме отчаянно пытался выбраться наружу. Некоторые каменные крышки были разбиты изнутри, другие - грубо расколоты снаружи.\n\nОднако все каменные гробы мертвенно пусты.\n\nВоздух в зале внезапно тяжелеет и снова становится удушающе жарким. Вы понимаете, что в этом заброшенном святилище вы далеко не одни. Из густой темноты между колоннами беззвучно проскальзывает чей-то силуэт - высокая человеческая фигура. Шаг за шагом она приближается к вашему отряду.\n\nСущество медленно разлепляет иссохшие губы, но вместо слов из его открытого рта струится лишь серый могильный песок, а с лица лоскутами осыпается шелушащаяся мёртвая кожа.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Мёртвые настигли нас.",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						local p = this.Const.Tactical.CombatInfo.getClone();
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.CombatID = "Mastaba";
						p.TerrainTemplate = "tactical.sinkhole";
						p.LocationTemplate.Template[0] = "tactical.sunken_library";
						p.Music = this.Const.Music.UndeadTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Center;
						p.IsWithoutAmbience = true;
						p.Entities = [];

						for( local i = 0; i < 4; ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.LegendMummyHeavy);
						}

						for( local i = 0; i < 4; ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.LegendMummyPriest);
						}

						local f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID();

						for( local i = 0; i < p.Entities.len(); ++i )
						{
							p.Entities[i].Faction <- f;
						}

						p.BeforeDeploymentCallback = function ()
						{
							local light = 4;
							local light_tiles = [];
							do
							{
								local x = this.Math.rand(10, 28);
								local y = this.Math.rand(4, 28);
								local tile = this.Tactical.getTileSquare(x, y);

								if (!tile.IsEmpty)
								{
									continue
								}

								local skip = false;
								foreach( t in light_tiles )
								{
									if (t.getDistanceTo(tile) <= 5)
									{
										skip = true;
										break;
									}
								}

								if (skip)
								{
									continue
								}

								local e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/vampire", tile.Coords);
								e.setFaction(f);
								e.assignRandomEquipment();
								light = --light;
								light_tiles.push(tile);
							}
							while (light > 0);

							local toRise = 3;
							do
							{
								local r = this.Math.rand(0, light_tiles.len() - 1);
								local p = light_tiles[r];

								if (p.SquareCoords.X > 14)
								{
									p.Level = 1;
									toRise = --toRise;
								}

								light_tiles.remove(r);
							}
							while (toRise > 0 && light_tiles.len() > 0);

							local queen = 1;
							do
							{
								local x = this.Math.rand(9, 10);
								local y = this.Math.rand(15, 17);
								local tile = this.Tactical.getTileSquare(x, y);

								if (!tile.IsEmpty)
								{
									continue
								}

								local e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/legend_mummy_queen", tile.Coords);
								e.setFaction(f);
								e.assignRandomEquipment();
								queen = --queen;

							}
							while (queen > 0);

							local treasureHunters = 4;
							do
							{
								local x = this.Math.rand(9, 11);
								local y = this.Math.rand(11, 21);
								local tile = this.Tactical.getTileSquare(x, y);

								if (!tile.IsEmpty)
								{
									continue
								}

								local e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/legend_mummy_medium", tile.Coords);
								e.setFaction(f);
								e.assignRandomEquipment();
								treasureHunters = --treasureHunters;

							}
							while (treasureHunters > 0);

							local medium = 12;
							do
							{
								local x = this.Math.rand(9, 14);
								local y = this.Math.rand(8, 20);
								local tile = this.Tactical.getTileSquare(x, y);

								if (!tile.IsEmpty)
								{
									continue
								}

								local e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/legend_mummy_light", tile.Coords);
								e.setFaction(f);
								e.assignRandomEquipment();
								medium = --medium;
							}
							while (medium > 0);

							local heavy = 4;
							do
							{
								local x = this.Math.rand(12, 14);
								local y = this.Math.rand(12, 26);
								local tile = this.Tactical.getTileSquare(x, y);

								if (!tile.IsEmpty)
								{
									continue
								}

								local e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/legend_mummy_heavy", tile.Coords);
								e.setFaction(f);
								e.assignRandomEquipment();
								heavy = --heavy;
							}
							while (heavy > 0);
						};
						p.AfterDeploymentCallback = function ()
						{
							this.Tactical.getWeather().setAmbientLightingPreset(5);
							this.Tactical.getWeather().setAmbientLightingSaturation(0.9);
						};
						_event.addLootToScriptedCombat(p);
						_event.registerToShowAfterCombat("Victory", "Defeat");
						this.World.State.startScriptedCombat(p, false, false, false);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Statistics.getFlags().set("LegendsAncientMastaba", true);
			}

		});
		this.m.Screens.push({
			ID = "Victory",
			Text = "[img]gfx/ui/events/event_89.png[/img]{Древняя царица рассыпается в пепел прямо перед вами, не оставив в зале ничего, кроме песка.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Что это было?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "После битвы...";

				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().die();
				}

				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/weapons/legendary/legend_mage_swordstaff");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Вы получаете " + item.getName()
				});
				this.World.Flags.set("IsMastabaDefeated", true);
			}

		});
		this.m.Screens.push({
			ID = "Defeat",
			Text = "[img]gfx/ui/events/event_173.png[/img]Наёмники толпой вываливаются наружу, щурясь от бьющего в глаза палящего солнца.%SPEECH_ON%Может, ну его... в другой раз?%SPEECH_OFF% - отдуваясь, бормочет один из бойцов. %randombrother% сплёвывает под ноги и мрачно кивает.%SPEECH_ON%В другой раз, ага. Только пускай к тому времени я уже буду сидеть на пенсии, пить дешёвый эль да тискать шлюх в таверне. Вот тогда лезьте в эту проклятую темноту и развлекайтесь с мёртвыми колдунами сколько вашей душе угодно. По рукам?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Возможно, однажды...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "После битвы...";

				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(false);
				}
			}

		});
	}

	function addLootToScriptedCombat( _properties )
	{
		for (local i = 0; i < ::Math.rand(4, 5); ++i)
		{
			_properties.Loot.push("scripts/items/" + ::MSU.Array.rand(m.LootTable));
		}
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

	function onClear()
	{
	}

});

