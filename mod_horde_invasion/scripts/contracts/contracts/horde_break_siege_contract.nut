this.horde_break_siege_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Troops = null,
		IsPlayerAttacking = true,
		IsEscortUpdated = false
	},
	function create()
	{
		this.contract.create();
		local r = this.Math.rand(1, 100);

		if (r <= 70)
		{
			this.m.DifficultyMult = this.Math.rand(90, 105) * 0.01;
		}
		else
		{
			this.m.DifficultyMult = this.Math.rand(115, 135) * 0.01;
		}

		this.m.Type = "contract.horde_break_siege";
		this.m.Name = "Снять осаду";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
		this.m.MakeAllSpawnsResetOrdersOnContractEnd = false;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		if (this.m.Home == null)
		{
			this.setHome(this.World.State.getCurrentTown());
		}

		this.m.Flags.set("ObjectiveName", this.m.Origin.getName());
		local nearest_jin = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Jurchen).getNearestSettlement(this.m.Origin.getTile());
		this.m.Flags.set("JinBase", nearest_jin.getID());
		local nearest_mgl = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Mgl).getNearestSettlement(this.m.Origin.getTile());
		this.m.Flags.set("MglBase", nearest_mgl.getID());
		this.m.Payment.Pool = 1500 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
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
					"Отправиться в местечко %objective%",
					"Снять осаду Великой Орды"
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
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());
				local okLocations = 0;

				foreach( l in this.Contract.m.Origin.getAttachedLocations() )
				{
					if (l.isActive())
					{
						okLocations = ++okLocations;
						okLocations = okLocations;
					}
				}

				if (okLocations < 3)
				{
					foreach( l in this.Contract.m.Origin.getAttachedLocations() )
					{
						if (!l.isActive() && !l.isMilitary())
						{
							l.setActive(true);
							okLocations = ++okLocations;
							okLocations = okLocations;

							if (okLocations >= 3)
							{
								break;
							}
						}
					}
				}

				local faction = this.World.FactionManager.getFaction(this.Contract.getFaction());
				local party = faction.spawnEntity(this.Contract.getHome().getTile(), "Отряд города " + this.Contract.getHome().getName(), true, this.Const.World.Spawn.Noble, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.getSprite("banner").setBrush(faction.getBannerSmall());
				party.setDescription("Опытные воины на службе у местной знати.");
				this.Contract.m.Troops = this.WeakTableRef(party);
				party.getLoot().Money = this.Math.rand(50, 200);
				party.getLoot().ArmorParts = this.Math.rand(0, 25);
				party.getLoot().Medicine = this.Math.rand(0, 5);
				party.getLoot().Ammo = this.Math.rand(0, 30);
				local r = this.Math.rand(1, 4);

				if (r == 1)
				{
					party.addToInventory("supplies/bread_item");
				}
				else if (r == 2)
				{
					party.addToInventory("supplies/roots_and_berries_item");
				}
				else if (r == 3)
				{
					party.addToInventory("supplies/dried_fruits_item");
				}
				else if (r == 4)
				{
					party.addToInventory("supplies/ground_grains_item");
				}

				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				local move = this.new("scripts/ai/world/orders/move_order");
				move.setDestination(this.Contract.getOrigin().getTile());
				c.addOrder(move);
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = true;
				}

				this.World.State.setEscortedEntity(this.Contract.m.Troops);
			}

			function update()
			{
				if (this.Flags.get("IsContractFailed"))
				{
					this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
					this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Отряд разорвал контракт");
					this.World.Contracts.finishActiveContract(true);
					return;
				}

				if (this.Contract.m.Troops != null && !this.Contract.m.Troops.isNull())
				{
					if (!this.Contract.m.IsEscortUpdated)
					{
						this.World.State.setEscortedEntity(this.Contract.m.Troops);
						this.Contract.m.IsEscortUpdated = true;
					}

					this.World.State.setCampingAllowed(false);
					this.World.State.getPlayer().setPos(this.Contract.m.Troops.getPos());
					this.World.State.getPlayer().setVisible(false);
					this.World.Assets.setUseProvisions(false);
					this.World.getCamera().moveTo(this.World.State.getPlayer());

					if (!this.World.State.isPaused())
					{
						this.World.setSpeedMult(this.Const.World.SpeedSettings.FastMult);
					}

					this.World.State.m.LastWorldSpeedMult = this.Const.World.SpeedSettings.FastMult;
				}

				if ((this.Contract.m.Troops == null || this.Contract.m.Troops.isNull() || !this.Contract.m.Troops.isAlive()) && !this.Flags.get("IsTroopsDeadShown"))
				{
					this.Flags.set("IsTroopsDeadShown", true);
					this.World.State.setCampingAllowed(true);
					this.World.State.setEscortedEntity(null);
					this.World.State.getPlayer().setVisible(true);
					this.World.Assets.setUseProvisions(true);

					if (!this.World.State.isPaused())
					{
						this.World.setSpeedMult(1.0);
					}

					this.World.State.m.LastWorldSpeedMult = 1.0;
					this.Contract.setScreen("TroopsHaveDied");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.isPlayerNear(this.Contract.m.Origin, 1200))
				{
					if (this.Contract.m.Troops == null || this.Contract.m.Troops.isNull())
					{
						this.Contract.setScreen("ArrivingAtTheSiegeNoTroops");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.m.Troops.getController().getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(true);
						this.Contract.setScreen("ArrivingAtTheSiege");
						this.World.Contracts.showActiveContract();
					}

					this.World.State.setCampingAllowed(true);
					this.World.State.setEscortedEntity(null);
					this.World.State.getPlayer().setVisible(true);
					this.World.Assets.setUseProvisions(true);

					if (!this.World.State.isPaused())
					{
						this.World.setSpeedMult(1.0);
					}

					this.World.State.m.LastWorldSpeedMult = 1.0;
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.Flags.set("IsContractFailed", true);
			}

		});
		this.m.States.push({
			ID = "Running_BreakSiege",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Уничтожить осадные орудия орды",
					"Уничтожить воинов орды около поселения %objective%"
				];

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = false;
				}

				foreach( id in this.Contract.m.UnitsSpawned )
				{
					local e = this.World.getEntityByID(id);

					if (e != null)
					{
						e.getSprite("selection").Visible = true;

						if (e.getFlags().has("SiegeEngine"))
						{
							e.setOnCombatWithPlayerCallback(this.onCombatWithSiegeEngines.bindenv(this));
						}
					}
				}
			}

			function update()
			{
				if (this.Contract.m.UnitsSpawned.len() == 0)
				{
					this.Contract.setScreen("TheAftermath");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.m.Origin == null || this.Contract.m.Origin.isNull() || !this.Contract.m.Origin.isAlive())
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatWithSiegeEngines( _dest, _isPlayerAttacking = true )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
				local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
				p.Music = this.Const.Music.JinTracks;
				p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Edge;
				p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
				p.EnemyBanners = [
					this.World.getEntityByID(this.Flags.get("JinBase")).getBanner()
				];
				this.World.Contracts.startScriptedCombat(p, this.Contract.m.IsPlayerAttacking, true, true);
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Вернуться в " + this.Contract.m.Home.getName()
				];

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = false;
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer% протягивает вам кубок вина.%SPEECH_ON%Выпьем.%SPEECH_OFF%Вы почти уверены, что ощущаете в его дыхании привкус нехороших новостей. Залпом выпив вино, вы киваете собеседнику. Он кивает вам в ответ.%SPEECH_ON%Окрестности кишат ордой, и, похоже, она хочет взять %objective%.%SPEECH_OFF%Он снова наполняет кубок, выпивает, вновь наливает.%SPEECH_ON%Если поселение падёт, то и все окрестные земли будут потеряны. Говорят, хан учёл ошибки прошлых нашествий — теперь у его воинов и осадные машины, и порох. Мои шпионы докладывают, что осада только началась, орда ещё не собрала основные силы воедино, а это значит, что мы можем ударить и разбить их до того, как будет слишком поздно. Отправляйся туда и сними осаду!%SPEECH_OFF% | %employer% окружён стражниками. Их шлемы сняты, и вы видите угрюмые лица, мокрые от пота. Некоторые дрожат, и даже доспехи не в состоянии это скрыть. %employer%, заметив ваш отряд, подзывает вас взмахом руки.%SPEECH_ON%Наёмник! У меня ужасные новости. Времени мало, расскажу кратко: орда вторглась в эти земли и может захватить %objective%. Они осадили его, но, судя по донесениям, ещё не обладают численным перевесом. Мне нужно, чтобы ты отправился туда и уничтожил их до того, как будет слишком поздно.%SPEECH_OFF% | %employer% стоит в окружении писцов, сменяющих друг друга со свежими донесениями. Наконец он обращает внимание на вас.%SPEECH_ON%Наёмник, тебе раньше приходилось снимать осаду? Орда осадила %objective%. У нас мало времени: они скоро возьмут это проклятое поселение, а затем и все окружающие земли! Тяжёлая пехота, лучники, осадные машины — кто бы мог подумать, что степняки научатся брать города осадой. Снеси их, пока город не пал!%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{%objective%... Сколько же стоит его спасение? | \'%companyname%\' вполне способны снять осаду.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Оно того не стоит. | У нас есть другие обязательства.}",
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
			ID = "PreparingForBattle",
			Title = "%townname%",
			Text = "[img]gfx/ui/events/event_78.png[/img]{Вы выходите от нанимателя и готовите отряд к походу. Вокруг носятся рыцари и солдаты. Некоторые собрались вокруг священника, молча готовясь к смерти.%SPEECH_ON%Надо забивать места.%SPEECH_OFF%Говорит %randombrother%, подходя к вам. Он весело ухмыляется.%SPEECH_ON%Что, слишком мрачно?%SPEECH_OFF% | Во дворе замка, в котором прячется %employer%, суетятся солдаты. Загружают припасы в повозки, точат оружие. Стайка оруженосцев порхает туда-сюда с кипами доспехов и щитов. Вы идёте к своим людям и отдаёте команду к сбору. %randombrother% кивает в сторону солдат.%SPEECH_ON%Полагаю, в этот раз мы будем не одни.%SPEECH_OFF% | %employer% собрал внушительную армию. Залы замка переполнены вооружёнными людьми. Вы пробираетесь сквозь комнаты, набитые старухами, детьми и дряхлыми слепцами, выбираетесь наружу и находите свой отряд.%SPEECH_ON%Давайте выступать. Этим людям нужно ещё подготовиться к битве, но мы-то к ней всегда готовы, так ведь, ребята?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Вперёд!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "TroopsHaveDied",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_22.png[/img]Все солдаты благородного дома погибли, так и не дойдя до осаждённого поселения. Что ж, лучше уж они, чем вы. \'%companyname%\' направляются в %objective%.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Мы должны идти.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ArrivingAtTheSiege",
			Title = "%objective%",
			Text = "[img]gfx/ui/events/event_68.png[/img]{Наконец вы прибываете к осаждённому поселению. Воины орды окружили %objective%, их осадные машины осыпают его пылающими снарядами. Половина города, кажется, уже горит, крошечные фигурки людей носятся туда-сюда, сражаясь с огнём. Капитан благородного дома приказывает вам атаковать осадные машины, а сам ударит по основным силам. | %objective% ныне больше похож на огромный погребальный костёр, чем на город. Осадные орудия орды работают без устали — дымные росчерки зажигательных снарядов, визг камней, падающих на крыши. Капитан благородного дома приказывает вам уничтожить осадные машины: сам он атакует основные силы, а затем, объединившись, вы довершите разгром. | К счастью, %objective% всё ещё держится. Вы подоспели вовремя: ещё пару часов — и осадные машины сровняли бы город с землёй. Капитан благородного дома приказывает вашему отряду напасть с фланга и уничтожить осадные орудия. | Знакомые звуки осады встречают вас на подступах к городу: свист пролетающих камней, грохот обрушивающихся стен, слитный гул тысячи чужих голосов. С вершины ближнего холма вы видите %objective%, со всех сторон окружённый цепями лучников и латников. Осадные машины мечут в город булыжники и зажигательные снаряды.\n\nКапитан благородного дома излагает план: вы заходите с фланга и атакуете осадные машины, он бьёт по центру, затем вы объединяетесь и добиваете остатки.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Приготовиться к бою!",
					function getResult()
					{
						this.Contract.setState("Running_BreakSiege");
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.spawnSiege();
			}

		});
		this.m.Screens.push({
			ID = "ArrivingAtTheSiegeNoTroops",
			Title = "%objective%",
			Text = "[img]gfx/ui/events/event_68.png[/img]{Вы наконец видите %objective% — и тот в отчаянном положении. Поселение подвергается нескончаемому обстрелу осадными машинами орды. Вы приказываете отряду \'%companyname%\' приготовиться: обойдём армию с фланга и ударим по машинам. | Хотя все воины благородного дома пали, вы всё же добрались до осаждённого поселения. Орда по-прежнему осаждает его, осыпая снарядами. Вы решаете обойти их с фланга и ударить по осадным машинам.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Приготовиться к бою!",
					function getResult()
					{
						this.Contract.setState("Running_BreakSiege");
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.spawnSiege();
			}

		});
		this.m.Screens.push({
			ID = "SiegeEquipmentAhead",
			Title = "По мере приближения...",
			Text = "[img]gfx/ui/events/event_68.png[/img]{Орда собрала несколько осадных орудий неподалёку. Вам придётся уничтожить их, чтобы помочь снять осаду! | Ваши люди обнаружили несколько осадных орудий поблизости. Орда, скорее всего, готовит к бою и огнестрел. Уничтожьте машины, дабы помочь снять осаду!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "В атаку!",
					function getResult()
					{
						this.Contract.getActiveState().onCombatWithSiegeEngines(null, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "PowderMaster",
			Title = "По мере приближения...",
			Text = "[img]gfx/ui/events/event_48.png[/img]{Приближаясь к осаждающим воинам орды, вы замечаете в их рядах людей с пороховыми карабинами и бочонками за спиной. Пороховые мастера. Вы велите людям держаться от них подальше и не курить.%SPEECH_ON%Если эти сволочи подожгут свои бочки — от нас мокрого места не останется.%SPEECH_OFF% | Над рядами латников возвышается силуэт человека, увешанного бочонками и трубами. Он раздаёт приказы резкими выкриками, и вы понимаете: это пороховой мастер орды.%SPEECH_ON%Вон тот, с бочками. Пристрелите его первым.%SPEECH_OFF%Говорит %randombrother%, подходя к вам. | %randombrother% вернулся из разведки. Он принёс новость: среди орды есть пороховые мастера.%SPEECH_ON%Я ещё помню, как в прошлый раз один такой разнёс половину моста вместе с нашими ребятами. Прикончим их поскорее.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "В атаку!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Warlord",
			Title = "По мере приближения...",
			Text = "[img]gfx/ui/events/event_49.png[/img]{Приближаясь к осаждающим, вы замечаете среди них фигуру, которую невозможно пропустить: сотника орды в лакированном доспехе, с дорогим именным клинком на поясе. Вокруг него выстраиваются телохранители. Вы велите %randombrother% разнести весть — готовьтесь к тяжёлому бою. | Приближаясь к осаждённому городку, вы узнаёте высокий силуэт полководца орды. Даже на этом расстоянии видно, как охрана расступается перед ним. Предстоящий бой стал немного интереснее. | %randombrother% вернулся из разведки. Он утверждает, что в стане орды присутствует её полководец — сотник или даже генерал. Плохая новость, но лучше знать всё заранее и подготовиться, а затем атаковать и застигнуть врага врасплох.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "В атаку!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "TheAftermath",
			Title = "По пути...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Сражение завершилось, орда разгромлена, %objective% спасён, а %employer% будет доволен. Перешагивая через поле тел — людских и степняцких, — вы собираете наёмников, чтобы отправиться в обратный путь. | Телами усеяно всё поле, уже слетаются полчища мух — у них тут полно работы. Вы созываете людей и готовитесь возвращаться к нанимателю за платой. | %objective% спасён! Ну, то немногое, что от него осталось. Солдаты и воины орды, мёртвые и умирающие — вся земля усеяна ими, насколько хватает глаз. Жестокое зрелище недавней сечи. Вы приказываете отряду \'%companyname%\' готовиться к возвращению: %employer% ждёт. | Битва закончилась победой. Вы смотрите, как люди с пиками осторожно бродят по полю, добивая раненых степняков, притворяющихся мёртвыми. Солдаты благородного дома опускаются на землю, пьют воду. У вас нет времени на отдых — %employer% ждёт вестей.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Победа!",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Вы возвращаетесь к нанимателю в сопровождении его капитанов. Они сообщают новости, и %employer% быстро кивает, вручая вам объёмный кошель, доверху набитый кронами. Его военачальники провожают вас завистливыми взглядами. | Осада снята, и вы сообщаете об этом нанимателю. %employer% кивает и даёт вам кошель с монетами.%SPEECH_ON%Они будут говорить о вас. Я о тех, кто ещё не родился.%SPEECH_OFF% | Вы сообщаете дворянину новости о снятии осады. %employer% встаёт и пожимает вам руку.%SPEECH_ON%Во имя древних богов, ваши деяния будут помнить вечно!%SPEECH_OFF%Про себя вы задаётесь вопросом, не те же ли слова говорили людям, от которых ныне остались лишь кости. Что ж, во всяком случае вы получили награду. | %employer% с готовностью приветствует ваше возвращение, вскакивая на ноги и почти спотыкаясь об собаку.%SPEECH_ON%Наёмник, я уже слышал новости! Осада снята, город стоит, а орда откатилась в степь! Ты заслужил достойную награду!%SPEECH_OFF%Он ставит тяжёлый ларец на стол. Вы принимаете награду, пересчитываете кроны и уходите.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "%objective% спасён.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Осада снята с города " + this.Flags.get("ObjectiveName"));
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
		this.m.Screens.push({
			ID = "Failure1",
			Title = "Неподалёку от города %objective%",
			Text = "[img]gfx/ui/events/event_68.png[/img]{Вы тянули слишком долго... теперь %objective% лежит в руинах. Орда преодолела стены одним решительным приступом. Учитывая запах, разносящийся по ветру, не нужно быть семи пядей во лбу, чтобы понять: все жители были перебиты. | \'%companyname%\' не сняли осаду вовремя, и теперь %objective% являет собой разорённое кладбище. Жители до последнего надеялись на спасение, но вы оставили их умирать. Хорошая новость в том, что живым не ушёл никто — болтать о вашем позоре некому. Плохая — %employer% будет в ярости. | %objective% был захвачен! Воины орды подвели осадные машины к стенам и сровняли укрепления с землёй. Захватчики наводнили город, убивая всех на своём пути, и угнали множество пленных — одни боги знают куда. Ваш наниматель, %employer%, возмущён вашим бездействием! | Из-за вашей нерасторопности %objective% пал под натиском орды! Не ожидайте, что %employer% будет доволен этим результатом.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Защитить %objective% не удалось.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Не удалось снять осаду с города " + this.Flags.get("ObjectiveName"));
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function spawnSiege()
	{
		if (this.m.Flags.get("IsSiegeSpawned"))
		{
			return;
		}

		this.m.SituationID = this.m.Origin.addSituation(this.new("scripts/entity/world/settlements/situations/besieged_situation"));
		local originTile = this.m.Origin.getTile();
		local jinBase = this.World.getEntityByID(this.m.Flags.get("JinBase"));
		local mglBase = this.World.getEntityByID(this.m.Flags.get("MglBase"));
		local numSiegeEngines;

		if (this.m.DifficultyMult >= 1.15)
		{
			numSiegeEngines = this.Math.rand(1, 2);
		}
		else
		{
			numSiegeEngines = 1;
		}

		local numOtherEnemies;

		if (this.m.DifficultyMult >= 1.25)
		{
			numOtherEnemies = this.Math.rand(2, 3);
		}
		else if (this.m.DifficultyMult >= 0.95)
		{
			numOtherEnemies = 2;
		}
		else
		{
			numOtherEnemies = 1;
		}

		for( local i = 0; i < numSiegeEngines; i = i )
		{
			local tile;
			local tries = 0;

			while (tries++ < 500)
			{
				local x = this.Math.rand(originTile.SquareCoords.X - 2, originTile.SquareCoords.X + 2);
				local y = this.Math.rand(originTile.SquareCoords.Y - 2, originTile.SquareCoords.Y + 2);

				if (!this.World.isValidTileSquare(x, y))
				{
					continue;
				}

				tile = this.World.getTileSquare(x, y);

				if (tile.getDistanceTo(originTile) <= 1)
				{
					continue;
				}

				if (tile.Type == this.Const.World.TerrainType.Ocean)
				{
					continue;
				}

				if (tile.IsOccupied)
				{
					continue;
				}

				break;
			}

			local party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Jurchen).spawnEntity(tile, "Осадные орудия", false, this.Const.World.Spawn.HordeRaiders, this.Math.rand(100, 120) * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
			this.m.UnitsSpawned.push(party.getID());
			party.setDescription("Воины Великой Орды и их осадные орудия.");
			local numSiegeUnits = this.Math.rand(3, 4);

			for( local j = 0; j < numSiegeUnits; j = j )
			{
				this.Const.World.Common.addTroop(party, {
					Type = this.Const.World.Spawn.Troops.GreenskinCatapult
				}, false);
				j = ++j;
			}

			party.updateStrength();
			party.getLoot().ArmorParts = this.Math.rand(0, 15);
			party.getLoot().Ammo = this.Math.rand(0, 10);
			party.addToInventory("supplies/rice_item");
			party.getSprite("body").setBrush("figure_siege_01");
			party.getSprite("banner").setBrush(jinBase != null ? jinBase.getBanner() : "banner_jin");
			party.getSprite("banner").Visible = false;
			party.getSprite("base").Visible = false;
			party.setAttackableByAI(false);
			party.getFlags().add("SiegeEngine");
			local c = party.getController();
			c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
			c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
			local wait = this.new("scripts/ai/world/orders/wait_order");
			wait.setTime(9000.0);
			c.addOrder(wait);
			i = ++i;
		}

		local targets = [];

		foreach( l in this.m.Origin.getAttachedLocations() )
		{
			if (l.isActive() && l.isUsable())
			{
				targets.push(l);
			}
		}

		if (targets.len() == 0)
		{
			foreach( l in this.m.Origin.getAttachedLocations() )
			{
				if (l.isUsable())
				{
					targets.push(l);
				}
			}
		}

		for( local i = 0; i < numOtherEnemies; i = i )
		{
			local tile;
			local tries = 0;

			while (tries++ < 500)
			{
				local x = this.Math.rand(originTile.SquareCoords.X - 4, originTile.SquareCoords.X + 4);
				local y = this.Math.rand(originTile.SquareCoords.Y - 4, originTile.SquareCoords.Y + 4);

				if (!this.World.isValidTileSquare(x, y))
				{
					continue;
				}

				tile = this.World.getTileSquare(x, y);

				if (tile.getDistanceTo(originTile) <= 1)
				{
					continue;
				}

				if (tile.Type == this.Const.World.TerrainType.Ocean)
				{
					continue;
				}

				break;
			}

			local party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Mgl).spawnEntity(tile, "Воины орды", false, this.Const.World.Spawn.MglRaiders, this.Math.rand(90, 110) * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
			this.m.UnitsSpawned.push(party.getID());
			party.setDescription("Воины Великой Орды, идущие на войну.");
			party.getLoot().ArmorParts = this.Math.rand(0, 15);
			party.getLoot().Ammo = this.Math.rand(0, 10);
			party.addToInventory("supplies/rice_item");
			party.getSprite("banner").setBrush(mglBase != null ? mglBase.getBanner() : "banner_mgl");
			local c = party.getController();
			local raidTarget = targets[this.Math.rand(0, targets.len() - 1)].getTile();
			c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
			local raid = this.new("scripts/ai/world/orders/raid_order");
			raid.setTime(30.0);
			raid.setTargetTile(raidTarget);
			c.addOrder(raid);
			local destroy = this.new("scripts/ai/world/orders/destroy_order");
			destroy.setTime(60.0);
			destroy.setSafetyOverride(true);
			destroy.setTargetTile(originTile);
			destroy.setTargetID(this.m.Origin.getID());
			c.addOrder(destroy);
			i = ++i;
		}

		if (this.m.Troops != null && !this.m.Troops.isNull())
		{
			local c = this.m.Troops.getController();
			c.clearOrders();
			local intercept = this.new("scripts/ai/world/orders/intercept_order");
			intercept.setTarget(this.World.getEntityByID(this.m.UnitsSpawned[this.m.UnitsSpawned.len() - 1]));
			c.addOrder(intercept);
			local guard = this.new("scripts/ai/world/orders/guard_order");
			guard.setTarget(originTile);
			guard.setTime(120.0);
		}

		this.m.Origin.spawnFireAndSmoke();
		this.m.Origin.setLastSpawnTimeToNow();
		this.m.Flags.set("IsSiegeSpawned", true);
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"objective",
			this.m.Flags.get("ObjectiveName")
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			this.World.State.setCampingAllowed(true);
			this.World.State.setEscortedEntity(null);
			this.World.State.getPlayer().setVisible(true);
			this.World.Assets.setUseProvisions(true);

			if (!this.World.State.isPaused())
			{
				this.World.setSpeedMult(1.0);
			}

			this.World.State.m.LastWorldSpeedMult = 1.0;

			if (!this.m.Flags.get("IsSiegeSpawned"))
			{
				this.spawnSiege();
			}

			foreach( id in this.m.UnitsSpawned )
			{
				local e = this.World.getEntityByID(id);

				if (e != null && e.isAlive())
				{
					e.setAttackableByAI(true);

					if (e.getFlags().has("SiegeEngine"))
					{
						local c = e.getController();
						c.clearOrders();
						local wait = this.new("scripts/ai/world/orders/wait_order");
						wait.setTime(120.0);
						c.addOrder(wait);
					}
				}
			}

			if (this.m.Origin != null && !this.m.Origin.isNull())
			{
				this.m.Origin.getSprite("selection").Visible = false;
			}

			if (this.m.Home != null && !this.m.Home.isNull())
			{
				this.m.Home.getSprite("selection").Visible = false;
			}
		}

		if (this.m.Origin != null && !this.m.Origin.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Origin.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(2);
			}
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isHordeInvasion())
		{
			return false;
		}

		local numAttachments = 0;

		foreach( l in this.m.Origin.getAttachedLocations() )
		{
			if (l.isActive() && l.isUsable())
			{
				numAttachments = ++numAttachments;
				numAttachments = numAttachments;
			}
		}

		if (numAttachments < 2)
		{
			return false;
		}

		return true;
	}

	function onSerialize( _out )
	{
		if (this.m.Troops != null && !this.m.Troops.isNull())
		{
			_out.writeU32(this.m.Troops.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local troops = _in.readU32();

		if (troops != 0)
		{
			this.m.Troops = this.WeakTableRef(this.World.getEntityByID(troops));
		}

		this.contract.onDeserialize(_in);
	}

});
