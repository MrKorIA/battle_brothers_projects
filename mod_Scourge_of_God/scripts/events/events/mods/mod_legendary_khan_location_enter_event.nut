this.mod_legendary_khan_location_enter_event <- ::inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.legendary_khan_location_enter";
		this.m.Title = "По мере приближения...";
		this.m.Cooldown = 999999.0 * ::World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;

		// ============================================================
		// Сцена 1 — вход: холм, статуи стражей, провал в кургане
		// ============================================================
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_89.png[/img]{Пологий холм, поросший жёлтой степной травой, поначалу ничем не выделяется — таких в степи десятки. Но по мере приближения детали складываются воедино, и работа человеческих рук становится очевидной: по склону торчат обтёсанные валуны, выстроенные кольцом, а с южной стороны холма каменная громада — стена с узким проходом. Его обрамляет резной портал: над притолокой — распластанная крылатая птица и всадники, высеченные рукой мастера, а по обе стороны от входа стоят статуи конных воинов, закованных в латы и шлемы, с запрокинутыми к небу лицами. Возле них, у самой земли, воткнуты жерди с оборванными лентами — похоже, давние подношения, потемневшие от времени. Ветер волной пробегает по траве, и склон вдруг проступает целиком — округлый, слишком правильный для природы. Это не холм. Это курган, и тёмный проём между статуями ведёт внутрь — туда, куда, возможно, веками не ступала ничья нога.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Мы входим.",
					function getResult( _event )
					{
						return "B";
					}
				},
				{
					Text = "Лучше не будем беспокоить то, что покоится здесь.",
					function getResult( _event )
					{
						if (::World.State.getLastLocation() != null)
						{
							::World.State.getLastLocation().setVisited(false);
						}

						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});

		// ============================================================
		// Сцена 2 — внутри: коридор, проповедь, оступившийся брат
		// ============================================================
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_29.png[/img]{Долгое время коридор тянется во тьму — узкий, сырой, с низким потолком, с которого капает. Потом он начинает расширяться, и эхо приносит из глубины гул: многоголосый, низкий, похожий на молитву. Вы гасите факелы и крадётесь к свету, что льётся из-за последнего поворота.\n\nЗа ним открывается огромный грот. По каменному полу, среди засыхающих луж и следов чьих-то грубых пиров, теснится толпа искажённых тел. Над ними, у массивного саркофага, возвышается создание с несколькими руками и говорит — терпеливо, как говорят с детьми.%SPEECH_ON%Время прощения ещё не наступило. Великий хан оставил нас здесь хранить его покой — и мы храним. Век за веком, верно и неустанно. Но час близок: скоро мы выйдем из кургана и понесём хаос и разрушение во имя Хана.%SPEECH_OFF%Вы слушали бы и дальше, но %randombrother% оступается, и под сапогом хрустит кость. Толпа оборачивается разом. Многорукий вожак медленно поворачивает голову к вам, и в тишине его голос звучит как скрежет могильной плиты.%SPEECH_ON%Убейте их.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Бьёмся насмерть!",
					function getResult( _event )
					{
						if (::World.State.getLastLocation() != null)
						{
							::World.State.getLastLocation().setVisited(false);
						}

						local p = ::Const.Tactical.CombatInfo.getClone();
						p.LocationTemplate = clone ::Const.Tactical.LocationTemplate;
						p.CombatID = "KhanTomb";
						p.TerrainTemplate = "tactical.mgl_cave_ground"; // базовая каменная толща кургана (должна идти ПЕРЕД fill локации: патч стен красит только Type == 0)
						p.LocationTemplate.Template[0] = "tactical.mgl_khan_tomb";
						p.Music = ::Const.Music.UndeadTracks;
						p.PlayerDeploymentType = ::Const.Tactical.DeploymentType.Custom; // братьев расставляем вручную в AfterDeploymentCallback (паттерн tutorial_contract)
						p.EnemyDeploymentType = ::Const.Tactical.DeploymentType.Center;
						p.IsWithoutAmbience = true; // событийный бой без мировой клетки: ambience по Tile не звать, погода задаётся в AfterDeploymentCallback (паттерн legend_mummy_enter_event)
						p.Entities = [];

						local f = ::World.FactionManager.getFactionOfType(::Const.FactionType.Zombies).getID();

						local nicheCoords = [
							[13, 22], [19, 22], [25, 22],
							[13, 8], [19, 8], [25, 8]
						];

						p.BeforeDeploymentCallback = function ()
						{
							// Саркофаг — вплотную к тайлу босса (18,16). Ставим ПЕРЕД спавном врагов,
							// чтобы занятый тайл само исключалось. Тайл босса (смещение 0,0) не трогаем.
						    local bossX = 18;
							local bossY = 16;
							local khanSarcophagusTile;
							local sarcophagusOffsets = [ [1, 0], [0, 1], [-1, 0], [0, -1], [1, 1], [-1, 1], [1, -1], [-1, -1] ];
							foreach (o in sarcophagusOffsets)
							{
								local tile = this.Tactical.getTileSquare(bossX + o[0], bossY + o[1]);
								if (!tile.IsEmpty || tile.IsOccupiedByActor) continue;
								tile.spawnObject("entity/tactical/objects/mgl_khan_sarcophagus");
								khanSarcophagusTile = tile;
								break;
							}
                            // два сулде (штандарта) за саркофагом — с восточной стороны.
                            if (khanSarcophagusTile != null)
                            {
                                local suldePlaced = 0;
                                local suldeOffsets = [ [2, 0], [2, 1], [2, -1], [3, 0], [1, 1], [1, -1] ];
                                foreach (o in sarcophagusOffsets)
                                {
                                    if (suldePlaced >= 2) break;
                                    local tile = this.Tactical.getTileSquare(khanSarcophagusTile.SquareCoords.X + o[0], khanSarcophagusTile.SquareCoords.Y + o[1]);
                                    if (!tile.IsEmpty || tile.IsOccupiedByActor) continue;
                                    tile.spawnObject("entity/tactical/objects/mgl_camp_sulde");
                                    suldePlaced = ++suldePlaced;
                                }
                            }

							// ниши с верёвками (объекты-спавнеры)
							foreach (c in nicheCoords)
						    {
                                // если тайл ниши занят (декаль и т.п.), ищем свободный в пределах алькова 3x2
                                local placed = false;
                                for (local dx = -1; dx <= 1 && !placed; ++dx)
                                {
                                    for (local dy = 0; dy <= 1 && !placed; ++dy)
                                    {
                                        local nx = c[0] + dx;
                                        local ny = c[1] + (c[1] >= 15 ? dy : -dy);
                                        if (!this.Tactical.isValidTileSquare(nx, ny)) continue;
                                        local tile = this.Tactical.getTileSquare(nx, ny);
                                        if (!tile.IsEmpty || tile.IsOccupiedByActor) continue;
                                        tile.clear();
                                        local niche = this.Tactical.spawnEntity("scripts/entity/tactical/objects/mgl_khan_niche", tile.Coords);
                                        niche.setFaction(f);
                                        placed = true;
                                    }
                                }
                            }

							// враги: 1 вожак, 9 мутантов колонной, 15 крестьян
							local bossTile = this.Tactical.getTileSquare(bossX, bossY);
							if (!bossTile.IsEmpty || !bossTile.IsOccupiedByActor)
							{
							    bossTile.removeObject();
							}
                            local boss = this.Tactical.spawnEntity("scripts/entity/tactical/humans/wang", bossTile.Coords);
                            boss.setFaction(f);

							for (local i = 0; i < 9; ++i)
							{
								local y = 12 + i;
														local tile = this.Tactical.getTileSquare(17, y);
								if (!tile.IsEmpty || tile.IsOccupiedByActor) continue;
								tile.clear();
								local e = this.Tactical.spawnEntity("scripts/entity/tactical/humans/lingmujiangshi", tile.Coords);
								e.setFaction(f);
							}

							// крестьяне: собираем список ПОДХОДЯЩИХ тайлов заранее и выбираем из него —
							// никаких "300 попыток вслепую", гарантированно ставим сколько влезает.
							// Подходящий тайл: внутри зала (не стена), ровный (Level 0), свободный.
                            local peasantSpots = [];
                            local function gatherPeasantSpots( _x0, _x1, _y0, _y1 )
                            {
                                for (local x = _x0; x <= _x1; ++x)
                                {
                                    for (local y = _y0; y <= _y1; ++y)
                                    {
                                        if (!this.Tactical.isValidTileSquare(x, y)) continue;
                                        local tile = this.Tactical.getTileSquare(x, y);
                                        if (!tile.IsEmpty || tile.IsOccupiedByActor) continue;
                                        if (tile.IsSpecialTerrain || tile.Level != 0) continue;
                                        local dup = false;
                                        foreach (s in peasantSpots) { if (s.ID == tile.ID) { dup = true; break; } }
                                        if (!dup) peasantSpots.push(tile);
                                    }
                                }
                            }
                            // основная плотная зона (розовый прямоугольник): россыпь, но не размазано по залу
                            gatherPeasantSpots(17, 20, 13, 20);
                            // запас: если тесно — расширяемся по вертикали и вширину
                            if (peasantSpots.len() < 15) gatherPeasantSpots(16, 21, 11, 22);
                            ::logInfo("peasantSpots done");
							for (local i = 0; i < 15 && peasantSpots.len() > 0; ++i)
							{
								local idx = this.Math.rand(0, peasantSpots.len() - 1);
								local tile = peasantSpots[idx];
								peasantSpots.remove(idx);
								local e = this.Tactical.spawnEntity("scripts/entity/tactical/humans/cunmin", tile.Coords);
								e.setFaction(f);
							}
							::logInfo("cunmin done");
						};

						p.AfterDeploymentCallback = function ()
						{
							// высаживаем отряд игрока у входа в зал. Зона шире ванильных 12 мест:
							// рассчитана и на 24 бойца Legends. Кандидат обязан быть ровным полом
							// (IsSpecialTerrain == false, Level == 0) — иначе брат окажется
							// на возвышенности и не сможет сойти (случай сержанта со знаменем).
						// ручная высадка отряда (синхронный addEntityToMap — без Navigator/teleport,
						// который давал мёртвую блокировку в фазе развёртывания). Паттерн: tutorial_contract.
						// Координаты addEntityToMap — гексовые: (x, y - x/2).
						local bros = this.World.getPlayerRoster().getAll();
						local spots = [];
						local function gatherSpots( _x0, _x1, _y0, _y1 )
						{
							for (local x = _x0; x <= _x1; ++x)
							{
								for (local y = _y0; y <= _y1; ++y)
								{
									if (!this.Tactical.isValidTileSquare(x, y)) continue;
									local tile = this.Tactical.getTileSquare(x, y);
									if (!tile.IsEmpty || tile.IsOccupiedByActor) continue;
									if (tile.IsSpecialTerrain || tile.Level != 0) continue;
									local dup = false;
									foreach (s in spots) { if (s.ID == tile.ID) { dup = true; break; } }
									if (!dup) spots.push(tile);
								}
							}
						}
						gatherSpots(9, 10, 10, 21);
						if (spots.len() < this.World.Assets.getBrothersMaxInCombat()) gatherSpots(8, 11, 8, 23);

		                local num = 0;
						foreach (bro in bros)
						{
							if (spots.len() == 0) break;
							local idx = this.Math.rand(0, spots.len() - 1);
							local spot = spots[idx];
							spots.remove(idx);
							this.Tactical.addEntityToMap(bro, spot.SquareCoords.X, spot.SquareCoords.Y - spot.SquareCoords.X / 2);

                            num = ++num;
                            if (num >= this.World.Assets.getBrothersMaxInCombat())
                            {
                                break;
                            }
						}
						// fillVisibility(Player, true) сюда НЕ добавлять: в ванили это отключение тумана войны
						// (tactical_state:3465-3480 — тот же вызов в dev-переключателе FOW). Видимость
						// пересчитается по актёрам сама после развёртывания.

							local clouds = this.Tactical.getWeather().createCloudSettings();
							clouds.Type = this.getconsttable().CloudType.Fog;
							clouds.MinClouds = 20;
							clouds.MaxClouds = 20;
							clouds.MinVelocity = 3.0;
							clouds.MaxVelocity = 9.0;
							clouds.MinAlpha = 0.35;
							clouds.MaxAlpha = 0.45;
							clouds.MinScale = 2.0;
							clouds.MaxScale = 3.0;
							this.Tactical.getWeather().buildCloudCover(clouds);
							this.Tactical.getWeather().setAmbientLightingPreset(5);
							this.Tactical.getWeather().setAmbientLightingSaturation(0.9);
						};

						_event.registerToShowAfterCombat("Victory", "Defeat");
						::World.State.startScriptedCombat(p, false, false, false);
						return 0;
					}
				}
			],
			function start( _event )
			{
			}

		});

		// ============================================================
		// Сцена 3 — победа: саркофаг и награда
		// ============================================================
		this.m.Screens.push({
			ID = "Victory",
			Text = "[img]gfx/ui/events/event_24.png[/img]{Грот пуст. Вы добили тех, кто ещё держался на ногах, и перекрыли все ниши, из которых лезли новые и новые враги — теперь из-за завалов доносится лишь глухой гомон орды где-то внизу и тяжёлое дыхание ваших людей.\n\nСаркофаг стоит там, где и стоял. Крышка поддаётся не сразу — под ней оказывается не то, чего вы ждали: праха почти нет, зато на ложе из истлевших тканей лежат доспех и шлем, покрытые тёмной чеканкой, такой работы, что вы невольно замираете. Доспех Хана. Настоящий — не дарёный, не купленный, а вырванный у мёртвого владыки и его стражи.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Достойная цена за достойную вещь.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "После битвы...";

				if (::World.State.getLastLocation() != null)
				{
					::World.State.getLastLocation().die();
				}

				this.World.Assets.getStash().makeEmptySlots(2);
				local armor = this.new("scripts/items/armor/named/named_mgl10_armor_01");
				this.World.Assets.getStash().add(armor);
				this.List.push({
					id = 10,
					icon = "ui/items/" + armor.getIcon(),
					text = "Вы получаете " + armor.getName()
				});
				local helmet = this.new("scripts/items/helmets/named/named_mgl11_helmet_01");
				this.World.Assets.getStash().add(helmet);
				this.List.push({
					id = 10,
					icon = "ui/items/" + helmet.getIcon(),
					text = "Вы получаете " + helmet.getName()
				});
			}

		});

		// ============================================================
		// Сцена 4 — поражение: отступление
		// ============================================================
		this.m.Screens.push({
			ID = "Defeat",
			Text = "[img]gfx/ui/events/event_88.png[/img]Вы не были готовы к тому, что из ниш словно бесконечно появляются всё новые враги: одного срубили, из темноты выбрались двое, и вскоре держать строй стало бессмысленно. Отряд прорывается к выходу, оставляя на каменном полу своих братьев.%SPEECH_ON%Вернёмся. Позже. Тем, кто остался жив.%SPEECH_OFF% — хрипит кто-то из ваших. %randombrother% кивает, не оборачиваясь. Остальные молча прибавляют шагу.",
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

				if (::World.State.getLastLocation() != null)
				{
					::World.State.getLastLocation().setVisited(false);
				}
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

	function onClear()
	{
	}

});
