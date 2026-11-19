this.shourenjingjichang_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.shourenjingjichang_enter_event";
		this.m.Title = "Когда вы приближаетесь...";
		this.m.Cooldown = 0.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_74.png[/img]{Вы подходите к огромной крепости и с удивлением обнаруживаете, что это орский лагерь. Появляются орки, и, к вашему изумлению, один из них говорит на человеческом языке. «Приветствую, великие воины. Эта арена построена мной. Меня называют наставником орков. В молодости я был вождём, а затем воздвиг это место, чтобы обучать молодых орков бою. Если хотите испытать свои силы — милости прошу на арену. Здесь вы встретите врагов, каких не сыскать за пределами этих стен!»}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Мы принимаем вызов!",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Не стоит тревожить то, что обитает здесь.",
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
			Text = "[img]gfx/ui/events/event_67.png[/img]{Мастер орков проводил вас на арену и объявил: «Игра началась. Если вы хотели сбежать — уже поздно. Выбирайте противника. Я тоже в списке». И он ухмыльнулся.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "/Кровожадный/ Гаргарус",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "/Великий вождь/ Блэйк Эндрю",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "/Похититель золота/ Калуарес",
					function getResult( _event )
					{
						return "E";
					}

				},
				{
					Text = "Глен",
					function getResult( _event )
					{
						return "F";
					}

				},
				
				{
					Text = "/Голос джунглей/ Трудитруди",
					function getResult( _event )
					{
						return "G";
					}

				},
				
				{
					Text = "Есть ли противник сильнее?",
					function getResult( _event )
					{
						return "H";
					}

				}
				
				
				
				
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_49.png[/img]{Когда вы сделали выбор, мастер орков расхохотался. Вы спросили, чему он так рад, но он ничего не ответил. Следом на арену вышел высокий орк. Толпа взревела — похоже, он здесь знаменитость. Когда он приблизился, вы поняли: с этим орком что-то не так... его дух словно не принадлежит этому миру!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Надеюсь, мы переживём эту встречу!!",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						local p = this.Const.Tactical.CombatInfo.getClone();
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.CombatID = "Arena";
						p.TerrainTemplate = "tactical.arena";
						p.LocationTemplate.Template[0] = "tactical.shourenjingjichang_floor";
						p.Music = this.Const.Music.OrcsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Arena;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Arena;
						p.IsFleeingProhibited = true;
						p.IsLootingProhibited = false;
						p.IsWithoutAmbience = true;
						p.IsFogOfWarVisible = false;
						p.IsArenaMode = false;
						p.IsAutoAssigningBases = false;
						p.Entities = [];

						for( local i = 0; i < 1; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.Fengzi);
						}

                        for( local i = 0; i < 9; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.OrcBerserker);
						}


						local f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getID();

						for( local i = 0; i < p.Entities.len(); i = ++i )
						{
							p.Entities[i].Faction <- f;
						}


						_event.registerToShowAfterCombat("Victory", "Defeat");
						this.World.State.startScriptedCombat(p, false, false, false);
						return 0;
					}

				}
			],
		});
		
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_49.png[/img]{Вы выбрали /Великого вождя/ Блэйка Эндрю. Из-за двери поднялась огромная фигура. Это самый большой и сильный орк, которого вы когда-либо видели. Говорить уже поздно. Остаётся только победить его — иначе смерть!!!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Покончим с ним!",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						local p = this.Const.Tactical.CombatInfo.getClone();
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.CombatID = "Arena";
						p.TerrainTemplate = "tactical.arena";
						p.LocationTemplate.Template[0] = "tactical.shourenjingjichang_floor";
						p.Music = this.Const.Music.OrcsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Arena;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Arena;
						p.IsFleeingProhibited = true;
						p.IsLootingProhibited = false;
						p.IsWithoutAmbience = true;
						p.IsFogOfWarVisible = false;
						p.IsArenaMode = false;
						p.IsAutoAssigningBases = false;
						p.Entities = [];

						for( local i = 0; i < 1; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.Daqiuzhang);
						}

                        for( local i = 0; i < 2; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.OrcWarrior);
						}

                        for( local i = 0; i < 1; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.OrcWarlord);
						}

                        for( local i = 0; i < 2; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.OrcBerserker);
						}

                        for( local i = 0; i < 6; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.OrcYoung);
						}

						local f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getID();

						for( local i = 0; i < p.Entities.len(); i = ++i )
						{
							p.Entities[i].Faction <- f;
						}


						_event.registerToShowAfterCombat("Victory", "Defeat");
						this.World.State.startScriptedCombat(p, false, false, false);
						return 0;
					}

				}
			],
		});
		
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_93.png[/img]{Вдалеке показался орк, сверкающий доспехами человеческой работы. Он осклабился — похоже, он намеревался поживиться вашим снаряжением. Но у этого типа такой богатый вид, что скорее стоит отрубить ему голову и забрать его сокровища.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Этот парень — ходячее сокровище. Забираем его!",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						local p = this.Const.Tactical.CombatInfo.getClone();
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.CombatID = "Arena";
						p.TerrainTemplate = "tactical.arena";
						p.LocationTemplate.Template[0] = "tactical.shourenjingjichang_floor";
						p.Music = this.Const.Music.OrcsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Arena;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Arena;
						p.IsFleeingProhibited = true;
						p.IsLootingProhibited = false;
						p.IsWithoutAmbience = true;
						p.IsFogOfWarVisible = false;
						p.IsArenaMode = false;
						p.IsAutoAssigningBases = false;
						p.Entities = [];

						for( local i = 0; i < 1; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.Shourenlueduozhe);
						}
						
						
						for( local i = 0; i < 21; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.OrcYoung);
						}

                        for( local i = 0; i < 1; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.OrcWarlord);
						}

						local f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getID();

						for( local i = 0; i < p.Entities.len(); i = ++i )
						{
							p.Entities[i].Faction <- f;
						}


						_event.registerToShowAfterCombat("Victory", "Defeat");
						this.World.State.startScriptedCombat(p, false, false, false);
						return 0;
					}

				}
			],
		});
		
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_93.png[/img]{К вашему удивлению, противник оказался молодым орком. Вы спросили мастера, в чём дело. Он медленно произнёс: «Этот юный орк одолел трёх орских вождей. Возможно, он самый молодой и самый перспективный боец из всех, кто здесь выступал».}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Что ж, проучим этого юнца!",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						local p = this.Const.Tactical.CombatInfo.getClone();
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.CombatID = "Arena";
						p.TerrainTemplate = "tactical.arena";
						p.LocationTemplate.Template[0] = "tactical.shourenjingjichang_floor";
						p.Music = this.Const.Music.OrcsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Arena;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Arena;
						p.IsFleeingProhibited = true;
						p.IsLootingProhibited = false;
						p.IsWithoutAmbience = true;
						p.IsFogOfWarVisible = false;
						p.IsArenaMode = false;
						p.IsAutoAssigningBases = false;
						p.Entities = [];


                        for( local i = 0; i < 1; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.Pochengzhe);
						}
 
                        for( local i = 0; i < 5; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.OrcWarrior);
						}

                        for( local i = 0; i < 8; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.OrcYoung);
						}


						local f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getID();

						for( local i = 0; i < p.Entities.len(); i = ++i )
						{
							p.Entities[i].Faction <- f;
						}


						_event.registerToShowAfterCombat("Victory", "Defeat");
						this.World.State.startScriptedCombat(p, false, false, false);
						return 0;
					}

				}
			],
		});
		
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_25.png[/img]{Издалека донёсся волчий вой. Похоже, ваш противник не так прост. Через мгновение на арену вышел высокий и могучий орк, а за ним... волки!!!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Разве это орская арена?",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						local p = this.Const.Tactical.CombatInfo.getClone();
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.CombatID = "Arena";
						p.TerrainTemplate = "tactical.arena";
						p.LocationTemplate.Template[0] = "tactical.shourenjingjichang_floor";
						p.Music = this.Const.Music.OrcsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Arena;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Arena;
						p.IsFleeingProhibited = true;
						p.IsLootingProhibited = false;
						p.IsWithoutAmbience = true;
						p.IsFogOfWarVisible = false;
						p.IsArenaMode = false;
						p.IsAutoAssigningBases = false;
						p.Entities = [];

                        for( local i = 0; i < 1; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.Xiongshou);
						}

						for( local i = 0; i < 1; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.Qiuzhang);
						}

                        for( local i = 0; i < 5; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.OrcBerserker);
						}

                        for( local i = 0; i < 10; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.Direwolf);
						}



						local f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getID();

						for( local i = 0; i < p.Entities.len(); i = ++i )
						{
							p.Entities[i].Faction <- f;
						}


						_event.registerToShowAfterCombat("Victory", "Defeat");
						this.World.State.startScriptedCombat(p, false, false, false);
						return 0;
					}

				}
			],
		});
		
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_67.png[/img]{Если вам кажется, что вышеперечисленного мало, вы можете вызвать более могущественных воинов! И, конечно же, меня!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Орк-мечник",
					function getResult( _event )
					{
						return "I";
					}

				},
				
				{
					Text = "Мастер орков",
					function getResult( _event )
					{
						return "J";
					}

				},
				  
				{
					Text = "Орк-колдун",
					function getResult( _event )
					{
						return "K";
					}

				},
				
				
				{
					Text = "/Ужас орков/ Андре Вуг",
					function getResult( _event )
					{
						return "L";
					}

				},
				  
				  
				{
					Text = "Таурен-монстр",
					function getResult( _event )
					{
						return "M";
					}

				}, 
				
				{
					Text = "Вернемся к обсуждению старых претендентов.",
					function getResult( _event )
					{
						return "B";
					}

				},
				
				
			],
			function start( _event )
			{
			}

		});
		
		this.m.Screens.push({
			ID = "I",
			Text = "[img]gfx/ui/events/event_49.png[/img]{Орк выглядит обычно, но чутьё подсказывает вам, что он не прост. Глядя на его огромный клинок, вы словно видите перед собой искусного фехтовальщика.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Может, он мечник среди орков?",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						local p = this.Const.Tactical.CombatInfo.getClone();
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.CombatID = "Arena";
						p.TerrainTemplate = "tactical.arena";
						p.LocationTemplate.Template[0] = "tactical.shourenjingjichang_floor";
						p.Music = this.Const.Music.OrcsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Arena;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Arena;
						p.IsFleeingProhibited = true;
						p.IsLootingProhibited = false;
						p.IsWithoutAmbience = true;
						p.IsFogOfWarVisible = false;
						p.IsArenaMode = false;
						p.IsAutoAssigningBases = false;
						p.Entities = [];

						for( local i = 0; i < 1; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.Balian);
						}


                        for( local i = 0; i < 1; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.OrcWarlord);
						}
 
                        for( local i = 0; i < 5; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.OrcWarrior);
						}

                        for( local i = 0; i < 8; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.OrcYoung);
						}

                        for( local i = 0; i < 3; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.OrcBerserker);
						}
						
						local f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getID();

						for( local i = 0; i < p.Entities.len(); i = ++i )
						{
							p.Entities[i].Faction <- f;
						}


						_event.registerToShowAfterCombat("Victory", "Defeat");
						this.World.State.startScriptedCombat(p, false, false, false);
						return 0;
					}

				}
			],
		});

		this.m.Screens.push({
			ID = "J",
			Text = "[img]gfx/ui/events/event_49.png[/img]{Мастер орков улыбнулся, ничего не сказал, развернулся и поднял свой топор. Когда он вышел на арену, толпа взревела. Тогда он заговорил: «Я жду того, кто сможет победить хозяина этой арены. Но такого ещё не было. Если вы одолеете меня — я отдам вам свой шлем и доспехи, которые сковал собственноручно. Они придадут вам огромную силу в битвах с орками. Разумеется, эти вещи сейчас при мне. Шлем? Он у меня на голове». И с громким рёвом мастер орков ринулся в атаку, крича: «Сможете ли вы одолеть меня?!»}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Я покажу тебе, кто здесь хозяин.",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						local p = this.Const.Tactical.CombatInfo.getClone();
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.CombatID = "Arena";
						p.TerrainTemplate = "tactical.arena";
						p.LocationTemplate.Template[0] = "tactical.shourenjingjichang_floor";
						p.Music = this.Const.Music.OrcsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Arena;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Arena;
						p.IsFleeingProhibited = true;
						p.IsLootingProhibited = false;
						p.IsWithoutAmbience = true;
						p.IsFogOfWarVisible = false;
						p.IsArenaMode = false;
						p.IsAutoAssigningBases = false;
						p.Entities = [];

						for( local i = 0; i < 1; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.Shourendashi);
						}

                        for( local i = 0; i < 1; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.Pochengzhe);
						}

                        for( local i = 0; i < 1; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.Daqiuzhang);
						}

                        for( local i = 0; i < 1; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.Fengzi);
						}

                        for( local i = 0; i < 3; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.OrcWarrior);
						}

                        for( local i = 0; i < 8; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.OrcYoung);
						}


						local f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getID();

						for( local i = 0; i < p.Entities.len(); i = ++i )
						{
							p.Entities[i].Faction <- f;
						}


						_event.registerToShowAfterCombat("Victory", "Defeat");
						this.World.State.startScriptedCombat(p, false, false, false);
						return 0;
					}

				}
			],
		});
		
		this.m.Screens.push({
			ID = "K",
			Text = "[img]gfx/ui/events/event_29.png[/img]{Вы спросили мастера орков о вашем противнике, но он сказал, что не знает его. Орк появился недавно, но число его сторонников растёт с каждым днём. Это его первое публичное выступление. Никто не знает, на что он способен, но орки-вожди и воины, что раньше сражались с ним, относятся к нему с необъяснимым почтением.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Загадочный тип.",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						local p = this.Const.Tactical.CombatInfo.getClone();
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.CombatID = "Arena";
						p.TerrainTemplate = "tactical.arena";
						p.LocationTemplate.Template[0] = "tactical.shourenjingjichang_floor";
						p.Music = this.Const.Music.OrcsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Arena;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Arena;
						p.IsFleeingProhibited = true;
						p.IsLootingProhibited = false;
						p.IsWithoutAmbience = true;
						p.IsFogOfWarVisible = false;
						p.IsArenaMode = false;
						p.IsAutoAssigningBases = false;
						p.Entities = [];



						for( local i = 0; i < 1; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.Guerdan);
						}

                        for( local i = 0; i < 1; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.Shourenbusiren);
						}

                        for( local i = 0; i < 5; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.Shourenbusiren04);
						}

                        for( local i = 0; i < 5; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.OrcYoung);
						}

                        for( local i = 0; i < 3; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.OrcBerserker);
						}

                        for( local i = 0; i < 3; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.OrcWarrior);
						}

						local f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getID();

						for( local i = 0; i < p.Entities.len(); i = ++i )
						{
							p.Entities[i].Faction <- f;
						}


						_event.registerToShowAfterCombat("Victory", "Defeat");
						this.World.State.startScriptedCombat(p, false, false, false);
						return 0;
					}

				}
			],
		});
		
		
		this.m.Screens.push({
			ID = "L",
			Text = "[img]gfx/ui/events/event_93.png[/img]{Выйдя на арену, вы видите, что ваш противник один. У вас дурное предчувствие. На голове и теле орка — странные узоры. А зрителей вокруг становится всё меньше... Похоже, этот орк очень опасен.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Странно.",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						local p = this.Const.Tactical.CombatInfo.getClone();
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.CombatID = "Arena";
						p.TerrainTemplate = "tactical.arena";
						p.LocationTemplate.Template[0] = "tactical.shourenjingjichang_floor";
						p.Music = this.Const.Music.OrcsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Arena;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Arena;
						p.IsFleeingProhibited = true;
						p.IsLootingProhibited = false;
						p.IsWithoutAmbience = true;
						p.IsFogOfWarVisible = false;
						p.IsArenaMode = false;
						p.IsAutoAssigningBases = false;
						p.Entities = [];

						for( local i = 0; i < 1; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.Zuie02);
						}

						local f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getID();

						for( local i = 0; i < p.Entities.len(); i = ++i )
						{
							p.Entities[i].Faction <- f;
						}


						_event.registerToShowAfterCombat("Victory", "Defeat");
						this.World.State.startScriptedCombat(p, false, false, false);
						return 0;
					}

				}
			],
		});
		
		this.m.Screens.push({
			ID = "M",
			Text = "[img]gfx/ui/events/event_146.png[/img]{Мастер орков улыбнулся и сказал: «Это дитя не из нашего племени. Я нашёл его далеко в диких землях и привёл сюда. Я обучил его боевым навыкам, чтобы приручить его дикость. Попробуйте свои силы с ним, наёмник. Возможно, он окажется сильнее меня».}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Да это же ОРК с головой быка!!!",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						local p = this.Const.Tactical.CombatInfo.getClone();
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.CombatID = "Arena";
						p.TerrainTemplate = "tactical.arena";
						p.LocationTemplate.Template[0] = "tactical.shourenjingjichang_floor";
						p.Music = this.Const.Music.OrcsTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Arena;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Arena;
						p.IsFleeingProhibited = true;
						p.IsLootingProhibited = false;
						p.IsWithoutAmbience = true;
						p.IsFogOfWarVisible = false;
						p.IsArenaMode = false;
						p.IsAutoAssigningBases = false;
						p.Entities = [];

						for( local i = 0; i < 1; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.Niutoukuangzhanshi);
						}

                        for( local i = 0; i < 10; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.OrcWarrior);
						}

                        for( local i = 0; i < 2; i = ++i )
						{
							p.Entities.push(clone this.Const.World.Spawn.Troops.OrcWarlord);
						}



						local f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getID();

						for( local i = 0; i < p.Entities.len(); i = ++i )
						{
							p.Entities[i].Faction <- f;
						}


						_event.registerToShowAfterCombat("Victory", "Defeat");
						this.World.State.startScriptedCombat(p, false, false, false);
						return 0;
					}

				}
			],
		});

		this.m.Screens.push({
			ID = "Victory",
			Text = "[img]gfx/ui/events/event_65.png[/img]{После тяжёлой битвы вы наконец одержали победу. «Возможно, в мире много таких сильных воинов», — подумали вы, глубоко вздыхая. Мастер орков подошёл и хлопнул вас по плечу. «Ваши навыки действительно впечатляют. Это подарки для вас. Вы всегда можете вернуться сюда вновь».}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Отличная работа, парни.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "После битвы...";


				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/loot/ancient_gold_coins_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Вы получаете " + item.getName()
				});
				this.World.Flags.set("IsLorekeeperDefeated", true);
				this.updateAchievement("Lorekeeper", 1, 1);
			}

		});
		this.m.Screens.push({
			ID = "Defeat",
			Text = "[img]gfx/ui/events/event_88.png[/img]Вы и ваши братья были повержены орками! Выжившие, перевязав раны, поспешили покинуть это место. Мастер орков улыбнулся вам вслед: «Надеюсь, вы вернётесь сюда, когда станете сильнее».",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Уходим отсюда.",
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
