this.horde_free_prisoners_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Dude = null,
		BattlesiteTile = null
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.horde_free_prisoners";
		this.m.Name = "Освободить пленников";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		if (this.m.BattlesiteTile == null || this.m.BattlesiteTile.IsOccupied)
		{
			local playerTile = this.World.State.getPlayer().getTile();
			this.m.BattlesiteTile = this.getTileToSpawnLocation(playerTile, 6, 12, [
				this.Const.World.TerrainType.Shore,
				this.Const.World.TerrainType.Ocean,
				this.Const.World.TerrainType.Mountains
			], false);
		}

		this.m.Payment.Pool = 1350 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
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

		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Осмотреть поле боя к %direction% от поселения %origin% в поисках улик",
					"Освободить всех пленников, которых найдёте"
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
				if (this.Contract.m.BattlesiteTile == null || this.Contract.m.BattlesiteTile.IsOccupied)
				{
					local playerTile = this.World.State.getPlayer().getTile();
					this.Contract.m.BattlesiteTile = this.getTileToSpawnLocation(playerTile, 6, 12, [
						this.Const.World.TerrainType.Shore,
						this.Const.World.TerrainType.Ocean,
						this.Const.World.TerrainType.Mountains
					], false);
				}

				local tile = this.Contract.m.BattlesiteTile;
				tile.clear();
				this.Contract.m.Destination = this.WeakTableRef(this.World.spawnLocation("scripts/entity/world/locations/battlefield_location", tile.Coords));
				this.Contract.m.Destination.onSpawned();
				this.Contract.m.Destination.setFaction(this.Const.Faction.PlayerAnimals);
				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local r = this.Math.rand(1, 100);

				if (r <= 5)
				{
					this.Flags.set("IsSurvivor", true);
				}
				else if (r <= 10)
				{
					this.Flags.set("IsLuckyFind", true);
				}
				else if (r <= 15)
				{
					this.Flags.set("IsAccident", true);
				}
				else if (r <= 35)
				{
					if (this.Contract.getDifficultyMult() > 0.85)
					{
						this.Flags.set("IsScouts", true);
					}
				}

				r = this.Math.rand(1, 100);

				if (r <= 50)
				{
					this.Flags.set("IsEnemyCamp", true);

					if (this.Math.rand(1, 100) <= 20 && this.Contract.getDifficultyMult() < 1.15)
					{
						this.Flags.set("IsEmptyCamp", true);
					}
				}
				else
				{
					this.Flags.set("IsEnemyParty", true);
				}

				if (this.Math.rand(1, 100) <= 20)
				{
					this.Flags.set("IsAmbush", true);
				}

				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (!this.TempFlags.get("IsBattlefieldReached") && this.Contract.isPlayerAt(this.Contract.m.Destination))
				{
					this.TempFlags.set("IsBattlefieldReached", true);
					this.Contract.setScreen("Battlesite1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsScoutsDefeated"))
				{
					this.Flags.set("IsScoutsDefeated", false);
					this.Contract.setScreen("Battlesite2");
					this.World.Contracts.showActiveContract();
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Scouts")
				{
					this.World.Contracts.removeContract(this.Contract);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Scouts")
				{
					this.Flags.set("IsScoutsDefeated", true);
				}
			}

		});
		this.m.States.push({
			ID = "Pursuit",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Следовать по следам орды, ведущим от места битвы",
					"Освободить всех пленников, которых найдёте"
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;

					if (this.Flags.get("IsEmptyCamp"))
					{
						this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
					}
				}
			}

			function update()
			{
				if ((this.Contract.m.Destination == null || this.Contract.m.Destination.isNull()) && !this.Flags.get("IsEmptyCamp"))
				{
					this.Contract.setScreen("Battlesite3");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsAmbush") && !this.Flags.get("IsAmbushTriggered") && !this.TempFlags.get("IsAmbushTriggered") && this.Contract.m.Destination.isHiddenToPlayer() && this.Contract.getDistanceToNearestSettlement() >= 5 && this.Math.rand(1, 1000) <= 2)
				{
					this.TempFlags.set("IsAmbushTriggered", true);
					this.Contract.setScreen("Ambush");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsAmbushDefeated"))
				{
					this.Contract.setScreen("AmbushFailed");
					this.World.Contracts.showActiveContract();
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Ambush")
				{
					this.Flags.set("IsAmbushTriggered", true);
					this.World.Contracts.removeContract(this.Contract);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Ambush")
				{
					this.Flags.set("IsAmbushTriggered", true);
					this.Flags.set("IsAmbushDefeated", true);
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				this.Contract.setScreen("EmptyCamp");
				this.World.Contracts.showActiveContract();
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Вернуться с освобождёнными пленниками в " + this.Contract.m.Home.getName()
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(null);
				}

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
		this.importScreens(this.Const.Contracts.NegotiationDefault);
		this.importScreens(this.Const.Contracts.Overview);
		this.m.Screens.push({
			ID = "Task",
			Title = "Переговоры",
			Text = "[img]gfx/ui/events/event_45.png[/img]{Когда вы входите, %employer% выслушивает перепуганного возчика. Тот вёз сюда обоз беженцев из приграничных деревень — повозки с пожитками, старики, дети. У переправы их догнала орда: крестьяне с вилами продержались недолго, сопротивлявшихся перебили, остальных связали и угнали с собой. Возчик успел затаиться в камышах, а когда степь опустела — побежал сюда. %employer% поворачивается к вам.%SPEECH_ON%Место стычки к %direction% отсюда. Иди туда, найди след и верни моих подданных, наёмник. Плата не разочарует.%SPEECH_OFF% | %employer% перехватывает вас ещё в дверях.%SPEECH_ON%Праздник урожая собрал половину округа на монастырский луг — песни, танцы, пироги. А потом с востока налетели степняки. Люди с палками против луков и сабель — сам понимаешь, чем это кончилось.%SPEECH_OFF%Орда не стала дожидаться подмоги: связала уцелевших и увела их с собой в полон, вместе с награбленным. Донёс весть пастух, переждавший резню в канаве. %employer% тычет пальцем в карту.%SPEECH_ON%Иди туда, где это случилось, — к %direction% от поселения %origin%. Найди, куда увели людей, и вызволи их.%SPEECH_OFF% | В зале ваш наниматель спорит с вербовщиком. Тот клянётся, что отправил сюда полный обоз рекрутов — молодых парней под охраной двух старых солдат. Обоз не дошёл: у дороги его настиг отряд орды. Старики держались, пока не пали, а новобранцы и не думали бежать — зря. Живых связали и угнали в степь. Один парень притворился мёртвым и дополз сюда. %employer% взмахом руки отсылает вербовщика и смотрит на вас.%SPEECH_ON%Место стычки к %direction% отсюда. Найди след, наёмник, и верни мне этих людей.%SPEECH_OFF% | Когда вы входите, %employer% допрашивает купца в дорожной пыли. Тот вёз на местную ярмарку обоз с тканями и солью, а с ним — подмастерья и возчиков. У самой дороги на них налетели степняки: охрана отбила первый наскок, но после короткой стычки сложила оружие. Купцу обещали жизнь за молчание, но он сбежал при первой же ночёвке и прибыл сюда. %employer% отпускает его и обращается к вам.%SPEECH_ON%Орда увела людей в полон — моих ремесленников и крестьян, между прочим. Иди на место стычки к %direction% отсюда и верни их. Вознаграждение щедрое.%SPEECH_OFF% | %employer% ждёт вас у карты, разложенной на столе.%SPEECH_ON%Слушай, наёмник. Сюда шёл обоз — беженцы из сожжённых деревень, да с ними отряд новобранцев с военным сборщиком. Орда перехватила их у переправы. Сборщик построил людей, но против луков и железа это продлилось недолго: часть перебили, остальных связали и увели. Один из новобранцев вырвался и добежал сюда.%SPEECH_OFF%Дворянин стучит пальцем по отметке на карте.%SPEECH_ON%Стычка была к %direction% отсюда. Пойди туда, иди по следу и вытащи моих людей из полона. Ну как, берёшься?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Надеюсь, плата будет высока. | Поговорим об оплате. | Сделать можно всё — за достойную цену.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Оно того не стоит. | Нас ждут в другом месте.}",
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
			Title = "На поле битвы...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Мухи жужжат так громко, что вы услышали их раньше, чем почуяли, чем они заняты. Тучи гнуса зависли над полем брани, где встретились ополчение и орда. Вы пробираетесь сквозь марево мух и приказываете людям искать выживших или их следы. | Дым, кровь и земля смешались в грязь. Вы вступаете на поле боя, приказывая прочесать местность. %randombrother% рассматривает степняка, наколотого на сломанный плуг, и ополченца, до конца сжимавшего серп. Он качает головой.%SPEECH_ON%\'Следы\'... как будто бы мы не понимаем, что здесь произошло.%SPEECH_OFF%Вы напоминаете ему: орда ушла, уведя пленных, и отряд \'%companyname%\' здесь, чтобы вызволить их. | %randombrother% рассматривает поле боя.%SPEECH_ON%Ты уверен, что здесь вообще были выжившие?%SPEECH_OFF%Действительно, всё выглядит так, словно в землю врезался огромный клинок: тела людей и степняков вперемешку, сломанные луки, оплавленная трава от пороха. Вы не уверены, что кто-нибудь выжил и попал в полон, но приказываете начать поиски. | Пленники, угнанные с этого поля, будут похожи на демонов, вытащенных из преисподней. Рассматривая холмы из мёртвых, вы не в силах поверить, что кто-то мог уцелеть здесь. И всё же — орда уводит пленных не для того, чтобы убивать. Пока есть следы — есть надежда.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Ищите везде!",
					function getResult()
					{
						if (this.Flags.get("IsAccident"))
						{
							return "Accident";
						}
						else if (this.Flags.get("IsLuckyFind"))
						{
							return "LuckyFind";
						}
						else if (this.Flags.get("IsSurvivor") && this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
						{
							return "Survivor";
						}
						else if (this.Flags.get("IsScouts"))
						{
							return "Scouts";
						}
						else
						{
							return "Battlesite2";
						}
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Battlesite2",
			Title = "На поле битвы...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{%randombrother% заметил цепочку следов, уводящую в сторону от поля боя. Отряд \'%companyname%\' должен пройти по ней! | Обнаружена цепочка следов, ведущая в сторону от поля боя. Среди небольших людских отпечатков — глубокие следы подкованных сапог и широкая колея обоза. Похоже, вы сможете найти пленников, если пройдёте по следу. | %randombrother% склоняется к земле и зовёт вас.%SPEECH_ON%На что это похоже, командир?%SPEECH_OFF%Вы видите небольшие отпечатки босых ног среди глубоких следов сапог. По краям петляют следы чуть меньше — детские. Вы выпрямляетесь.%SPEECH_ON%Люди. Пленные, босиком. След уводит прочь от поля боя — пройдём по нему и найдём их.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Выдвигаемся!",
					function getResult()
					{
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
						local playerTile = this.World.State.getPlayer().getTile();
						local nearest_jin = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Jurchen).getNearestSettlement(playerTile);
						local nearest_mgl = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Mgl).getNearestSettlement(playerTile);
						local camp;

						if (nearest_jin.getTile().getDistanceTo(playerTile) <= nearest_mgl.getTile().getDistanceTo(playerTile))
						{
							camp = nearest_jin;
						}
						else
						{
							camp = nearest_mgl;
						}

						if (this.Flags.get("IsEnemyParty"))
						{
							local tile = this.Contract.getTileToSpawnLocation(playerTile, 10, 15);
							local party = this.World.FactionManager.getFaction(camp.getFaction()).spawnEntity(tile, "Воины орды", false, this.Const.World.Spawn.HordeRaiders, 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
							party.getSprite("banner").setBrush(camp.getBanner());
							party.setDescription("Отряд Великой Орды, угоняющий пленных.");
							party.setFootprintType(this.Const.World.FootprintsType.Nomads);
							this.Contract.m.UnitsSpawned.push(party);
							party.getLoot().ArmorParts = this.Math.rand(0, 25);
							party.getLoot().Ammo = this.Math.rand(0, 10);
							party.addToInventory("supplies/rice_item");
							this.Contract.m.Destination = this.WeakTableRef(party);
							party.setAttackableByAI(false);
							party.setFootprintSizeOverride(0.75);
							local c = party.getController();
							c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
							local wait = this.new("scripts/ai/world/orders/wait_order");
							wait.setTime(15.0);
							c.addOrder(wait);
							local roam = this.new("scripts/ai/world/orders/roam_order");
							roam.setPivot(camp);
							roam.setMinRange(5);
							roam.setMaxRange(10);
							roam.setAllTerrainAvailable();
							roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
							roam.setTerrain(this.Const.World.TerrainType.Shore, false);
							roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
							c.addOrder(roam);
						}
						else
						{
							this.Contract.m.Destination = this.WeakTableRef(camp);
							camp.clearTroops();

							if (this.Flags.get("IsEmptyCamp"))
							{
								camp.setResources(0);
								this.Contract.m.Destination.setLootScaleBasedOnResources(0);
							}
							else
							{
								this.Contract.m.Destination.setLootScaleBasedOnResources(120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());

								if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
								{
									this.Contract.m.Destination.getLoot().clear();
								}

								camp.setResources(this.Math.min(camp.getResources(), 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
								this.Contract.addUnitsToEntity(camp, this.Const.World.Spawn.HordeRaiders, 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
							}
						}

						this.Const.World.Common.addFootprintsFromTo(playerTile, this.Contract.m.Destination.getTile(), this.Const.OrcFootprints, this.Const.World.FootprintsType.Nomads, 0.75, 10.0);
						this.Contract.setState("Pursuit");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Battlesite3",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_53.png[/img]{Воины орды повержены, и вы входите в их стан. Пленники сидят связанные, с повязками на глазах, под стеной из колючего кустарника. Вы приказываете освободить их. Уже смирившиеся со своей судьбой люди со слезами благодарят вас. Обычный рабочий день, правда. | Орда разбита, и вы спешно обыскиваете стан. Пленников находят в шатре, связанных вместе. После освобождения они едва могут говорить, но их глаза многое рассказывают о пережитом. %randombrother% приносит отрезы ткани, чтобы они могли одеться перед возвращением. | Со степняками покончено. Обыскивая лагерь, вы слышите людские крики из-за шатра. %randombrother% откидывает полог — там сотник орды с обнажённым клинком над связанными людьми. Наёмник одним движением выхватывает меч и рубит незадачливого стражника, прежде чем тот понял, что удача отвернулась. Пленники, перебивая друг друга, благодарят вас. %employer% будет рад: хотя бы некоторые из его людей вернутся домой.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Мы сделали то, за чем пришли. Пришла пора вернуться в город %townname%!",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Scouts",
			Title = "На поле битвы...",
			Text = "[img]gfx/ui/events/event_49.png[/img]{Обыскивая поле боя, вы внезапно замечаете отряд степняков! Скорее всего, они вернулись сюда поживиться среди трупов. Вы немедленно приказываете людям сомкнуть ряды. | Разведчики орды, пришедшие мародёрствовать на поле боя, вместо добычи встретили отряд \'%companyname%\'! Приготовиться к бою! | Пока вы ищете улики, небольшой отряд лёгких лучников появляется прямо перед отрядом \'%companyname%\'! Скорее всего, они просто рассчитывали поживиться, но вместо этого пополнят собой ряды мёртвых.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "К оружию!",
					function getResult()
					{
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "Scouts";
						p.Music = this.Const.Music.JinTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						local nearest_jin = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Jurchen).getNearestSettlement(tile);
						p.EnemyBanners.push(nearest_jin.getBanner());
						p.Entities = [];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.HordeRoamers, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Jurchen).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Survivor",
			Title = "На поле битвы...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{%randombrother% пробирается через тела, но внезапно отпрыгивает назад.%SPEECH_ON%Командир! Здесь выживший!%SPEECH_OFF%Вы бежите туда и видите человека, выбирающегося из груды тел. Пошатываясь, он поднимается, его лицо блестит от крови. Он рассказывает, что сражался в этой битве — и что битва ещё не закончена! По всей видимости, он хочет присоединиться к отряду \'%companyname%\'! | Осматривая поле боя, вы внезапно слышите человеческий крик из-под наваленных тел. %randombrother% начинает разгребать трупы, и вскоре показывается лицо, расплывающееся в улыбке.%SPEECH_ON%Во имя древних богов, я уже думал, что умру здесь.%SPEECH_OFF%Вы вытаскиваете его. Заметив знамя отряда \'%companyname%\', он спрашивает, найдётся ли для него место.%SPEECH_ON%У меня остались невыплаченные долги. Уверен, ты понимаешь, о чём я говорю.%SPEECH_OFF% | Обнаружен выживший: он лежал под двумя степняками и ополченцем, притворяясь мёртвым. %randombrother% даёт ему воды, вы спрашиваете, уцелел ли кто-то ещё. Он пожимает плечами.%SPEECH_ON%Ну, какое-то время они кричали, но сейчас уже нет. Скажите, вы — тот самый отряд \'%companyname%\'?%SPEECH_OFF%Мужчина вытирает кровь с лица и смотрит на вас с надеждой.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Добро пожаловать в \'%companyname%\'!",
					function getResult()
					{
						this.World.getPlayerRoster().add(this.Contract.m.Dude);
						this.World.getTemporaryRoster().clear();
						this.Contract.m.Dude.onHired();
						this.Contract.m.Dude = null;
						return "Battlesite2";
					}

				},
				{
					Text = "Этому не бывать. Проваливай отсюда.",
					function getResult()
					{
						this.World.getTemporaryRoster().clear();
						this.Contract.m.Dude = null;
						return "Battlesite2";
					}

				}
			],
			function start()
			{
				local roster = this.World.getTemporaryRoster();
				this.Contract.m.Dude = roster.create("scripts/entity/tactical/player");
				this.Contract.m.Dude.setStartValuesEx(this.Const.CharacterVeteranBackgrounds);
				this.Contract.m.Dude.setHitpointsPct(0.6);

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
				}

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).setArmor(this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body).getArmor() * 0.33);
				}

				if (this.Contract.m.Dude.getTitle() == "")
				{
					this.Contract.m.Dude.setTitle("Выживший");
				}

				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Accident",
			Title = "На поле битвы...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Поиски на поле боя — не самое безопасное занятие. Это правило находит очередное подтверждение, когда %hurtbro% умудряется пораниться. | %hurtbro% поскользнулся на щедро окроплённой кровью грязи и упал лицом прямо в разбитый щит степняка. Он получил несколько ран. | Поле брани ещё долго остаётся опасным местом, даже после боя: %hurtbro% поскальзывается и падает. Потрепало слегка, всё поправимо. | Вы догадывались, что один из этих идиотов обязательно поскользнётся: %hurtbro% неловко ставит ногу на окровавленный щит, соскальзывает и валится в груду оружия. Последствия неприятные.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Будь осторожнее.",
					function getResult()
					{
						this.Contract.m.Dude = null;
						return "Battlesite2";
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();
				local bro = brothers[this.Math.rand(0, brothers.len() - 1)];
				local injury = bro.addInjury(this.Const.Injury.Accident1);
				this.Contract.m.Dude = bro;
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = bro.getName() + " получает травму " + injury.getNameOnly()
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "LuckyFind",
			Title = "На поле битвы...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Вы даже не надеялись, что люди раскопают хоть что-то стоящее, однако вскоре появляется %randombrother% с добротным оружием в руках! | В процессе осмотра трофеев %randombrother% обнаруживает необычайно искусно сделанное оружие, чудесным образом уцелевшее в этой бане! | Найдено оружие! %randombrother% поднимает его над головой, чтобы все видели. | %randombrother% копошится в груде оружия. Вы просите его оставить это занятие, пока он не порезался, — и внезапно он распрямляется с необычно выглядящей боевой реликвией в руках.%SPEECH_ON%Да ну, а что ты скажешь теперь, командир?%SPEECH_OFF%Ладно, в этот раз он победил.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Неплохая находка.",
					function getResult()
					{
						return "Battlesite2";
					}

				}
			],
			function start()
			{
				local item;
				local r = this.Math.rand(1, 10);

				if (r == 1)
				{
					item = this.new("scripts/items/weapons/greatsword");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/weapons/greataxe");
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/weapons/billhook");
				}
				else if (r == 4)
				{
					item = this.new("scripts/items/weapons/noble_sword");
				}
				else if (r == 5)
				{
					item = this.new("scripts/items/weapons/warbrand");
				}
				else if (r == 6)
				{
					item = this.new("scripts/items/weapons/two_handed_hammer");
				}
				else if (r == 7)
				{
					item = this.new("scripts/items/weapons/greatsword");
				}
				else if (r == 8)
				{
					item = this.new("scripts/items/weapons/warbrand");
				}
				else if (r == 9)
				{
					item = this.new("scripts/items/weapons/named/named_sword");
				}
				else if (r == 10)
				{
					item = this.new("scripts/items/weapons/named/named_axe");
				}

				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Вы получаете " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Ambush",
			Title = "По пути...",
			Text = "[img]gfx/ui/events/event_48.png[/img]{Вы идёте по следу, когда из ближайших зарослей неожиданно раздаётся свист степного лука. Засада! | Вы идёте по следу, когда что-то замечаете. Припав к земле, вы сметаете пыль в сторону и обнаруживаете: следы ведут в обратном направлении. Кто бы их ни оставил — они вернулись, а это значит...\n\n%randombrother% прерывает ваши размышления.%SPEECH_ON%Засада! Орда!%SPEECH_OFF% | Следы резко обрываются посреди дороги — и вам известно, что это означает. Вы приказываете сомкнуть ряды. Едва слова срываются с губ, как цепочка степняков высыпает из зарослей! | Это не то, чем кажется... едва вы об этом подумали, как %randombrother% выпучивает глаза.%SPEECH_ON%Это ловушка!%SPEECH_OFF%Лучники орды появляются из зарослей, отрезая пути к отходу. Западня! Готовьтесь к битве!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "К оружию!",
					function getResult()
					{
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "Ambush";
						p.Music = this.Const.Music.JinTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						local nearest_mgl = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Mgl).getNearestSettlement(tile);
						p.EnemyBanners.push(nearest_mgl.getBanner());
						p.Entities = [];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.HordeRoamers, 125 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Mgl).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "AmbushFailed",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_53.png[/img]{Засадный отряд разгромлен, и вы следуете в стан орды. Оставшиеся степняки разбегаются, бросая всё. Пленников находят в шатре, связанными и обнажёнными. %randombrother% раздаёт им ткань, чтобы одеться. Их глаза многое рассказывают о пережитом. | Засада обернулась для степняков полным провалом. Вы входите в их лагерь, откуда всё живое уже разбежалось, и освобождаете пленников. %employer% будет рад: хотя бы некоторые из его людей вернутся домой.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Мы сделали то, за чем пришли. Пришла пора вернуться в город %townname%!",
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
			ID = "EmptyCamp",
			Title = "По мере приближения...",
			Text = "[img]gfx/ui/events/event_53.png[/img]{Вы врываетесь в стан орды с оружием наготове, но застаёте его пустым. Котелки с рисом перевёрнуты, костры брошены. %randombrother% приоткрывает полог шатра и находит связанных пленников. Они благодарят древних богов, завидев вас. %employer% будет доволен, а вы радуетесь, что орда сдалась без боя. | Лагерь орды покинут. Следы уходят вдаль — уходили в спешке, оставив обоз. %randombrother% подзывает вас: пленники сидят в яме под колючей решёткой. Вы открываете крышку и помогаете им выбраться. Не все выжили, но несколько человек дождались спасения — %employer% будет доволен. | Вы врываетесь в стан орды — пусто. Поваленные шатры, обугленные кострища. %randombrother% смеётся.%SPEECH_ON%Похоже, они знали, что отряд \'%companyname%\' идёт.%SPEECH_OFF%Внезапно из шатра раздаётся крик. Внутри — люди с завязанными глазами, забившиеся в угол. У кого-то не хватает пальцев, кто-то лишён глаза — следы недель в полону. Вы качаете головой и приказываете позаботиться о пострадавших.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Мы сделали то, за чем пришли. Пришла пора вернуться в город %townname%!",
					function getResult()
					{
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% приглашает вас в кабинет.%SPEECH_ON%Я хорошо рассмотрел пленников. Ну, то, что от них осталось. Они в плохой форме, но ты хорошо поработал. %reward_completion% крон, верно?%SPEECH_OFF% | %employer% расхаживает по комнате, то и дело выглядывая в окно. Внизу вовсю заботятся об освобождённых. Он качает головой.%SPEECH_ON%Я уже и не надеялся, что хоть одна из этих несчастных душ вернётся домой. Ты хорошо справился, наёмник.%SPEECH_OFF%Он толкает кошель в вашу сторону. %reward_completion% крон. | %employer% самолично кормит освобождённых. Увидев вас, он перепоручает заботы слуге и отводит вас в сторону.%SPEECH_ON%Я знаю, что эти люди теперь, по большому счёту, бесполезны. Орда не убила их, но с тем же успехом могла бы. Их тела живы, а дух сломлен. Ну да ладно. Ты выполнил мою просьбу — у стражника твои %reward_completion% крон. Не знаю, как тебе это удаётся, наёмник. Но я высоко ценю твои услуги.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Освободил пленников из лагерей Великой Орды");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isHordeInvasion())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCriticalContract);
						}

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
	}

	function onPrepareVariables( _vars )
	{
		if (this.m.BattlesiteTile == null || this.m.BattlesiteTile.IsOccupied)
		{
			local playerTile = this.World.State.getPlayer().getTile();
			this.m.BattlesiteTile = this.getTileToSpawnLocation(playerTile, 6, 12, [
				this.Const.World.TerrainType.Shore,
				this.Const.World.TerrainType.Ocean,
				this.Const.World.TerrainType.Mountains
			], false);
		}

		_vars.push([
			"location",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.m.Destination.getName()
		]);
		_vars.push([
			"dude_name",
			this.m.Dude == null ? "" : this.m.Dude.getNameOnly()
		]);
		_vars.push([
			"hurtbro",
			this.m.Dude == null ? "" : this.m.Dude.getName()
		]);

		if (this.m.Destination == null)
		{
			_vars.push([
				"direction",
				this.m.BattlesiteTile == null ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.BattlesiteTile)]
			]);
		}
		else
		{
			_vars.push([
				"direction",
				this.m.Destination == null || this.m.Destination.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Destination.getTile())]
			]);
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
				this.m.Destination.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isHordeInvasion())
		{
			return false;
		}

		return true;
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

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		this.contract.onDeserialize(_in);
	}

});
