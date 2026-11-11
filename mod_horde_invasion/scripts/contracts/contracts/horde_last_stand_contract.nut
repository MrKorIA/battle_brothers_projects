this.horde_last_stand_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		IsPlayerAttacking = true
	},
	function create()
	{
		this.contract.create();
		local r = this.Math.rand(1, 100);

		if (r <= 70)
		{
			this.m.DifficultyMult = this.Math.rand(95, 105) * 0.01;
		}
		else
		{
			this.m.DifficultyMult = this.Math.rand(115, 135) * 0.01;
		}

		this.m.Type = "contract.horde_last_stand";
		this.m.Name = "Защитить поселение";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
		this.m.MakeAllSpawnsResetOrdersOnContractEnd = false;
		this.m.MakeAllSpawnsAttackableByAIOnceDiscovered = true;
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
		this.m.Name = "Защитить " + this.m.Origin.getName();
		this.m.Payment.Pool = 1600 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Отправиться в %objective% к %direction% отсюда",
					"Защитить поселение от орды"
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
				local r = this.Math.rand(1, 100);

				if (r <= 40)
				{
					this.Flags.set("IsRaidersAtTheWalls", true);
				}
				else if (r <= 70)
				{
					this.Flags.set("IsAmbush", true);
				}

				this.Flags.set("Wave", 0);
				this.Flags.set("Militia", 7);
				this.Flags.set("MilitiaStart", 7);
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
					this.Contract.m.Origin.setLastSpawnTimeToNow();
				}
			}

			function update()
			{
				if (this.Contract.m.Origin == null || this.Contract.m.Origin.isNull() || !this.Contract.m.Origin.isAlive())
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
					return;
				}
				else if (this.Contract.isPlayerNear(this.Contract.m.Origin, 600) && this.Flags.get("IsRaidersAtTheWalls") && !this.Flags.get("IsRaidersAtTheWallsShown"))
				{
					this.Flags.set("IsRaidersAtTheWallsShown", true);
					this.Contract.setScreen("RaidersAtTheWalls");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.isPlayerAt(this.Contract.m.Origin) && this.Contract.m.UnitsSpawned.len() == 0)
				{
					this.Contract.setScreen("ADireSituation");
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "Running_Wait",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Защитить %objective% от орды"
				];

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = true;
					this.Contract.m.Origin.setLastSpawnTimeToNow();
				}
			}

			function update()
			{
				if (this.Contract.m.Origin == null || this.Contract.m.Origin.isNull() || !this.Contract.m.Origin.isAlive())
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (this.Contract.m.UnitsSpawned.len() != 0)
				{
					local contact = false;

					foreach( id in this.Contract.m.UnitsSpawned )
					{
						local e = this.World.getEntityByID(id);

						if (e.isDiscovered())
						{
							contact = true;
							break;
						}
					}

					if (contact)
					{
						if (this.Flags.get("Wave") == 1)
						{
							this.Contract.setScreen("Wave1");
						}
						else if (this.Flags.get("Wave") == 2)
						{
							this.Contract.setScreen("Wave2");
						}
						else if (this.Flags.get("IsAmbush"))
						{
							this.Contract.setScreen("Ambushers");
						}
						else if (this.Flags.get("Wave") == 3)
						{
							this.Contract.setScreen("Wave3");
						}

						this.World.Contracts.showActiveContract();
					}
				}
				else if (this.Flags.get("TimeWaveHits") <= this.Time.getVirtualTimeF())
				{
					if (this.Flags.get("IsAmbush") && this.Flags.get("Wave") == 3)
					{
						this.Flags.set("IsAmbush", false);
						this.Flags.set("Wave", 2);
						this.Contract.spawnAmbushers();
					}
					else
					{
						this.Contract.spawnWave();
					}
				}
			}

		});
		this.m.States.push({
			ID = "Running_Wave",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Защитить %objective% от орды"
				];

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull())
				{
					this.Contract.m.Origin.getSprite("selection").Visible = true;
					this.Contract.m.Origin.setLastSpawnTimeToNow();
				}

				foreach( id in this.Contract.m.UnitsSpawned )
				{
					local e = this.World.getEntityByID(id);

					if (e != null)
					{
						e.setOnCombatWithPlayerCallback(this.onCombatWithPlayer.bindenv(this));
					}
				}
			}

			function update()
			{
				if (this.Contract.m.Origin == null || this.Contract.m.Origin.isNull() || !this.Contract.m.Origin.isAlive())
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (this.Contract.m.UnitsSpawned.len() == 0)
				{
					if (this.Flags.get("Wave") < 3)
					{
						local militia = this.Flags.get("MilitiaStart") - this.Flags.get("Militia");

						if (militia >= 3)
						{
							this.Contract.setScreen("Militia1");
						}
						else if (militia >= 2)
						{
							this.Contract.setScreen("Militia2");
						}
						else
						{
							this.Contract.setScreen("Militia3");
						}
					}
					else
					{
						this.Contract.setScreen("TheAftermath");
					}

					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatWithPlayer( _dest, _isPlayerAttacking = true )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
				local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
				p.Music = this.Const.Music.JinTracks;
				p.CombatID = "ContractCombat";

				if (this.Contract.m.Origin != null && !this.Contract.m.Origin.isNull() && this.World.State.getPlayer().getTile().getDistanceTo(this.Contract.m.Origin.getTile()) <= 4)
				{
					p.AllyBanners.push("banner_noble_11");

					for( local i = 0; i < this.Flags.get("Militia"); i = i )
					{
						local r = this.Math.rand(1, 100);

						if (r < 60)
						{
							p.Entities.push({
								ID = this.Const.EntityType.Militia,
								Variant = 0,
								Row = -1,
								Script = "scripts/entity/tactical/humans/militia",
								Faction = 2,
								Callback = null
							});
						}
						else if (r < 85)
						{
							p.Entities.push({
								ID = this.Const.EntityType.Militia,
								Variant = 0,
								Row = -1,
								Script = "scripts/entity/tactical/humans/militia_veteran",
								Faction = 2,
								Callback = null
							});
						}
						else
						{
							p.Entities.push({
								ID = this.Const.EntityType.Militia,
								Variant = 0,
								Row = 2,
								Script = "scripts/entity/tactical/humans/militia_ranged",
								Faction = 2,
								Callback = null
							});
						}

						i = ++i;
					}
				}

				this.World.Contracts.startScriptedCombat(p, this.Contract.m.IsPlayerAttacking, true, true);
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_combatID == "ContractCombat" && _actor.getFlags().has("militia"))
				{
					this.Flags.set("Militia", this.Flags.get("Militia") - 1);
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer% рассматривает один из своих мечей. Он вытаскивает его из ножен и изучает своё отражение на отполированной стали.%SPEECH_ON%Когда я учился владеть им, то полагал, что применять его буду против людей. А теперь? Все только и говорят об этой проклятой орде — чурчжэни, степняки, порох и луки дальнобойные. Люди без лица, целые полчища.%SPEECH_OFF%С силой ударив по рукояти, он загоняет меч в ножны и швыряет его на стол.%SPEECH_ON%%objective%, что к %direction% отсюда, вот-вот примут удар. Разведчики докладывают: орда движется именно туда. У меня нет свободных людей, но если ты отправишься туда и удержишь город — вознаграждение будет щедрым!%SPEECH_OFF% | %employer% расположился между летописцем и капитаном стражи, перекрикивающими друг друга хриплыми голосами. Один твердит, что город обречён, другой — что стены выстоят. Дворянин замечает вас и вскакивает на ноги.%SPEECH_ON%Наёмник! Именно ты мне и нужен.%SPEECH_OFF%Он разворачивает перед вами карту, на которой чернилами обведено поселение %objective%.%SPEECH_ON%Орда идёт на него. Тяжёлая пехота, лучники, огнестрел. У меня нет людей, чтобы его прикрыть, — все ушли на границу. Доберись туда и не дай орде войти в город. Плата не обидит.%SPEECH_OFF% | %employer% встречает вас у ворот собственного поместья. За спиной у него — телеги с ранеными, тянущиеся к городу.%SPEECH_ON%Видишь это, наёмник? %objective% теперь в огне — орда обрушилась на него вчера на рассвете. Гарнизон держится, но второй такой ночи он не выдержит.%SPEECH_OFF%Он сжимает вашу руку своими холодными пальцами.%SPEECH_ON%У меня некому больше послать. Только тебе я могу доверить эту оборону. Спаси город — и я щедро заплачу.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Насколько же он ценен для тебя? | Мы можем защитить %objective% — за достойную плату...}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Оно того не стоит. | Боюсь, %objective% теперь сам по себе.}",
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
			ID = "RaidersAtTheWalls",
			Title = "%objective%",
			Text = "[img]gfx/ui/events/event_29.png[/img]{%objective%. Когда вы приблизились к нему, %randombrother%, идущий впереди, внезапно выкрикивает.%SPEECH_ON%Командир, быстрее!%SPEECH_OFF%Вы бросаетесь к нему и смотрите вперёд. Вокруг города ползут цепочки степняков — лучники с дальнобойными луками уже отмеряют дистанцию до стен. Отряду \'%companyname%\' придётся пробиваться сквозь них, чтобы попасть внутрь. | Навстречу отряду \'%companyname%\' бежит мужчина. Он прижимает к себе окровавленную руку и в исступлении кричит.%SPEECH_ON%Прочь, прочь! Здесь нет ничего, кроме смерти!%SPEECH_OFF%%randombrother% сбивает незнакомца с ног, обнажая оружие. Вы же, взглянув вперёд, придерживаете его руку: %objective% уже обложен со всех сторон — зажигательные стрелы, огненные бочки, степные лучники. Отряд должен действовать быстро! | Вы прибыли вовремя: стены %objective% уже осаждают воины орды! | Почти дойдя до цели, вы вынуждены остановиться: впереди, у самых стен %objective%, разворачиваются цепи латников с алебардами. Передовой отряд орды. Отряду \'%companyname%\' предстоит пробиваться в город с боем!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "К оружию!",
					function getResult()
					{
						this.Contract.spawnRaidersAtTheWalls();
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ADireSituation",
			Title = "%objective%",
			Text = "[img]gfx/ui/events/event_79.png[/img]{Пробившись в %objective%, вы видите его защитников, выглядящих так, словно они не спали несколько недель. Но они улыбаются. По-видимому, им было отчего повеселеть, наблюдая, как отряд \'%companyname%\' крошил степняков у самых ворот. | После часа, заполненного неуклюжими попытками \'прокрасться\' в город, отряду \'%companyname%\' всё же удалось добраться до ворот. Войдя внутрь, вы видите стражников, наблюдающих за вами с непередаваемым выражением лиц — с чем-то, что можно описать как \'радостное уныние\'. Один из них хлопает вас по плечу.%SPEECH_ON%За всем этим было ужасно забавно наблюдать, наёмник, а мои люди как раз нуждались в воодушевлении. Спасибо тебе.%SPEECH_OFF% | Оглядевшись, вы замечаете болезненного вида стражников — одна кожа да кости, они из последних сил охраняют горожан. Улицы заполнены мусором и обломками — крыши пробиты зажигательными стрелами. Женщины и дети рыдают подле длинной канавы, рядом с которой закреплён свиток, полный имён. Следы свежих чернил на нём указывают на недавнее обновление скорбного списка. | Пройдя через ворота поселения %objective%, вы встречаете нескольких стражников, сжимающих копья. Голод буквально витает в воздухе, отражаясь в жадных взглядах, которыми вас одаривают лишь из-за того, что вы пребываете в добром здравии. Один из защитников тепло приветствует вас.%SPEECH_ON%Мы устали и истощены, но мы справимся. Мы всё ещё способны сражаться, не сомневайся в этом.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Нам нужно подготовиться к предстоящему нападению...",
					function getResult()
					{
						this.Flags.set("Wave", 1);
						this.Flags.set("TimeWaveHits", this.Time.getVirtualTimeF() + 8.0);
						this.Contract.setState("Running_Wait");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Wave1",
			Title = "%objective%",
			Text = "[img]gfx/ui/events/event_29.png[/img]{Вы уже было смирились с мыслью, что умрёте от ожидания, но убить вас всё же собирается кое-кто другой — орда. Набат звучит со всех концов города %objective%, стражники занимают свои места с какой-то необъяснимой живостью. Вы приказываете отряду \'%companyname%\' готовиться к битве. | Звон набата застаёт вас в самом разгаре карточной игры среди братьев. Взглянув на колокольню, вы замечаете тощую фигуру звонаря. Кто-то кричит из сторожки у ворот.%SPEECH_ON%Они уже здесь, к оружию, к оружию!%SPEECH_OFF% | Дозорный на башне внезапно кричит.%SPEECH_ON%Донесение! Поберегись!%SPEECH_OFF%Подняв взгляд, вы видите стрелу, летящую по небу. Вращаясь, она вонзается в грязь в нескольких шагах от вас. Командир ополчения срывает письмо с древка. По мере чтения его лицо бледнеет.%SPEECH_ON%Готовься, наёмник. Орда идёт — пехота в железе, лучники за ними.%SPEECH_OFF%Он поворачивается к своим людям.%SPEECH_ON%К оружию! Мы должны защитить %objective%!%SPEECH_OFF% | Один из стражников кричит.%SPEECH_ON%Откройте ворота, беженцы приближаются!%SPEECH_OFF%Россыпь ребятишек просачивается через приоткрытые врата. Один из них твердит об орде со степными луками, что скоро будет здесь. Командир ополчения смотрит на вас.%SPEECH_ON%Тебе стоит подготовить своих людей, наёмник.%SPEECH_OFF%Орда движется сюда, готовьтесь к битве!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Защищайте город!",
					function getResult()
					{
						this.Contract.setState("Running_Wave");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Wave2",
			Title = "%objective%",
			Text = "[img]gfx/ui/events/event_73.png[/img]{Как только отряд \'%companyname%\' устроился на отдых, очищая клинки от крови, с колокольни вновь звучит набат. Орда приближается! Снова. | Капитан стражи обходит стены, желая убедиться, что его люди отдыхают. Едва он подходит к вам, как раздаётся набат, а дозорный кричит, что степняки вновь наступают! Усмехнувшись, вы хлопаете командира по плечу.%SPEECH_ON%Сделаем, что должно. Нет ничего проще, верно?%SPEECH_OFF%Капитан кивает и отправляется к своим людям. | Вы наблюдаете, как %randombrother% очищает лезвие меча от чужой крови.%SPEECH_ON%Во имя древних богов, сколько их там ещё?!%SPEECH_OFF%В следующее мгновение дозорный свистит и кричит об очередной атаке. Наёмник сердито стряхивает кровь с оружия.%SPEECH_ON%Я только-только начал замечать своё отражение!%SPEECH_OFF%Вы помогаете бойцу подняться и хлопаете его по плечу.%SPEECH_ON%Поверь мне, ты не многое потерял.%SPEECH_OFF% | Один из стражников разламывает чёрствую лепёшку на мелкие кусочки и раздаёт товарищам. Спрашивают, где достал хлеб, на что он раздражённо отвечает.%SPEECH_ON%Нашёл в котомке у одного степняка.%SPEECH_OFF%Едоки тут же выплёвывают хлеб. Драку прерывает свист дозорного.%SPEECH_ON%Они снова приближаются! К оружию!%SPEECH_OFF%Готовьтесь к битве. | В то время как ваши люди восстанавливают силы, дозорный кричит.%SPEECH_ON%Они снова наступают!%SPEECH_OFF%Война крайне редко даёт время для передышки, особенно война с ордой.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Защищайте город!",
					function getResult()
					{
						this.Contract.setState("Running_Wave");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Wave3",
			Title = "%objective%",
			Text = "[img]gfx/ui/events/event_73.png[/img]{Воины отдыхают, когда один из дозорных хрипло и обречённо кричит.%SPEECH_ON%Снова. Они идут... снова.%SPEECH_OFF%Отряд \'%companyname%\' должен вновь вступить в бой, дабы %objective% уцелел! | Один из стражников, весь дрожа, смотрит в огонь и постепенно начинает кричать.%SPEECH_ON%Ага, так мы и поступим! Мы проведём переговоры! Заключим с ними сделку! Я поговорю!%SPEECH_OFF%Он встаёт, вырывается от удерживающих его товарищей, направляется к стене и перелезает через неё. Выглянув из бойницы, вы видите, как безумец бежит по полю — прямо к цепям латников орды. Их строй, слегка дрогнув, поглощает его и продолжает неумолимое движение, подобно глади пруда, покрывшейся рябью от брошенного камня. Вы кричите своим людям.%SPEECH_ON%К оружию, парни! Нам вновь предстоит окунуться в самое пекло!%SPEECH_OFF% | Дозорный предупреждает об очередном наступлении! Он вопит так, что срывает голос и может лишь беззвучно раскрывать рот. Силы ополчения %objective% уже на пределе — остаётся надеяться, что этот приступ последний! | Дозорный свистит, предупреждая о новой волне. Капитан стражи качает головой.%SPEECH_ON%Во имя древних богов, когда же они закончатся? Сегодня ты действительно заслужил свою плату, наёмник.%SPEECH_OFF%Вы подумываете пошутить, что заслуживаете гораздо большего, но, учитывая обстоятельства, это кажется неуместным. Вместо этого вы киваете и возвращаетесь к людям готовить отряд \'%companyname%\' к новой битве.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Защищайте город!",
					function getResult()
					{
						this.Contract.setState("Running_Wave");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Militia1",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_46.png[/img]{Вы выиграли это сражение, чего не скажешь об ополчении: стражники понесли столь тяжёлые потери, что большинство жителей собираются бежать из города, не желая помогать с её обороной! | Победа! Но какой ценой! В бою пало так много ополченцев, что никто из жителей города %objective%, похоже, не желает восполнять их ряды!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "И всё же это победа.",
					function getResult()
					{
						this.Flags.set("Wave", this.Flags.get("Wave") + 1);
						this.Flags.set("TimeWaveHits", this.Time.getVirtualTimeF() + 3.0);
						this.Flags.set("Militia", 3);
						this.Flags.set("MilitiaStart", 3);
						this.Contract.setState("Running_Wait");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Militia2",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_46.png[/img]{Сражение завершилось победой, однако не обошлось без потерь. Лишь немногие из жителей города %objective% соглашаются помочь с обороной, в то время как остальные предпочитают собрать пожитки и уйти подобру-поздорову. | Сегодня вы одержали победу, однако орда заставила дорого за неё заплатить. Некоторые жители соглашаются пополнить ополчение, значительная же часть предпочитает держаться подальше от стен, готовясь к худшему.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "И всё же это победа.",
					function getResult()
					{
						this.Flags.set("Wave", this.Flags.get("Wave") + 1);
						this.Flags.set("TimeWaveHits", this.Time.getVirtualTimeF() + 3.0);
						this.Flags.set("Militia", 6);
						this.Flags.set("MilitiaStart", 6);
						this.Contract.setState("Running_Wait");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Militia3",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_80.png[/img]{Какая победа! Мало того, что орда получила достойный отпор, так ещё и многие из жителей города %objective%, вдохновлённые вашим успехом, присоединяются к ополчению, чтобы помочь в предстоящих сражениях! | Разгром орды оказался настолько сокрушительным, что многие жители города %objective% сами идут в ополчение, дабы помочь в грядущих битвах!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Победа!",
					function getResult()
					{
						this.Flags.set("Wave", this.Flags.get("Wave") + 1);
						this.Flags.set("TimeWaveHits", this.Time.getVirtualTimeF() + 3.0);
						this.Flags.set("Militia", 8);
						this.Flags.set("MilitiaStart", 8);
						this.Contract.setState("Running_Wait");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Ambushers",
			Title = "%objective%",
			Text = "[img]gfx/ui/events/event_69.png[/img]{Готовясь к грядущему сражению, вы замечаете в тылу основных сил быстрые цепочки лёгких воинов — разведчики орды, степняки-лучники. Они проскальзывают вдоль окраин, обходя город с флангов, словно гиены, обтекающие стадо. | Лёгкая пехота! Цепи степных лучников, пригибающихся к земле, уже окружают окраины. Орда не собирается штурмовать в лоб — она хочет запереть город и задушить его. | Тяжёлая пехота орды держит фронт, но именно сейчас в дело вступают её стремительные лучники — они просачиваются сквозь заброшенные огороды и руины, чтобы ударить со спины. | Как мыши выползают из разворошенной кладовой, так разведчики орды обтекают стены — лёгкие степняки, быстрые и злые.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Защищайте город!",
					function getResult()
					{
						this.Contract.spawnAmbushers();
						this.Contract.setState("Running_Wave");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "TheAftermath",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_46.png[/img]{Вы осматриваете поле брани. Оно усеяно мёртвыми и умирающими — с обеих сторон. Люди отрядами шагают по грязи, добивая раненых степняков и собирая трофеи. С окончанием этой битвы город наконец спасён, а %employer% будет ждать вас. | Бой завершился, город спасён. %employer% ждёт вашего отчёта, вы же — своих кровно заработанных денег. | %objective% ныне напоминает скорее прифронтовой лагерь, нежели город. Тела защитников и степняков лежат вперемешку, земля пропитана кровью и пороховой гарью.\n\nНепрестанные нападения наконец прекратились, %objective%, похоже, отныне в безопасности. А вас ждёт %employer%. К тому же у вас нет ни малейших причин задерживаться в этом месте сколь-нибудь надолго. | Что ж, город спасён. Крестьяне передвигаются по полю боя с длинными палками, ощупывая землю, как пеликаны клювом ощупывают опасные участки на воде. %randombrother% подходит к вам, очищая от грязи клинок, и спрашивает, не пора ли вернуться к нанимателю. Вы киваете: %employer% ждёт ваш доклад. Чем быстрее вы отчитаетесь и получите деньги, тем лучше. | Битва закончена. Над телами погибших крестьян и ополченцев склонились скорбные фигуры выживших. Что же касается степняков — до их тел никому нет дела. Они валяются тут и там, будто явились сюда без цели, но, перед тем как погибнуть, успели разрушить всё, до чего смогли дотянуться. Не желая находиться здесь и лишнего мгновения, вы отдаёте приказ собираться. %employer% ждёт вас. | Вы и отряд \'%companyname%\' одержали победу. Город и его жители будут жить, по крайней мере, до следующей орды. А что до вас — вам пора получать плату. %employer% ждёт.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Мы сделали это!",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{Вы входите в %townname% и видите, что %employer% стоит на балконе. Он подзывает вас, а его страж кидает кошель с кронами в ваши руки.%SPEECH_ON%Наёмник! Рад, что ты вернулся! Мои пташки уже напели мне о твоих свершениях. Надеюсь, ты потратишь эти кроны с умом!%SPEECH_OFF%Затем он поворачивается и уходит, прежде чем вы успеваете ответить. Крестьяне разглядывают вас, словно путевой знак, указывающий на места, в которые они даже и не подумают отправиться. | Ваш наниматель, %employer%, отвешивает несколько пощёчин какому-то подростку, затем пинает его, опрокидывая в грязь. Заметив вас, дворянин вытирает пот со лба и говорит.%SPEECH_ON%Это тебя не касается.%SPEECH_OFF%Парнишка кое-как поднимается на ноги. К нему подходит слуга, но дворянин отнимает тряпку и швыряет её в сторону.%SPEECH_ON%Ты думаешь, так он чему-нибудь научится? Если тебе так хочется кому-то помочь — помоги этому наёмнику. Он удержал город перед лицом орды и заслужил свои %reward_completion% крон. Всё ясно?%SPEECH_OFF%Слуга кивает и быстро уходит. Вы же стоите, наблюдая за продолжающимся избиением. Спустя несколько минут появляется слуга с кошелем. Он передаёт его вам и шепчет, что вам стоит поскорее уйти. | %employer% склонился над своим столом, уперевшись в него руками. Он опустил голову, разглядывая лежащий перед ним степной колчан.%SPEECH_ON%Нашли в овраге неподалёку от города. Пустой. Есть идеи, что это значит?%SPEECH_OFF%Вы предполагаете, что кто-то бросил его в спешке. Дворянин усмехается.%SPEECH_ON%Нет. Сдаётся мне, это как-то связано с тобой, наёмник. Ты разбил их у городских стен, и орда откатилась обратно в степь. Вот твоя плата — %reward_completion% крон. Потрать их на то, чтобы в следующий раз у меня оказалось больше людей вроде тебя.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Защитил " + this.Flags.get("ObjectiveName") + " от Великой Орды");
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
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Origin, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "Около города %objective%",
			Text = "[img]gfx/ui/events/event_30.png[/img]{Орды было слишком много, вам пришлось отступить. К сожалению, %objective% не в силах сделать то же самое — город был взят. Вы не желаете оглядываться, дабы увидеть, что сталось с его жителями: об этом нетрудно догадаться. | Отряд \'%companyname%\' разбит у стен! В результате вашего поражения %objective% пал. Толпа крестьян убегает из города, а те, кто оказался недостаточно расторопен, пополнили колонны угнанных в полон. | Вы не смогли сдержать наступление орды! Степняки, ворвавшись за стены, растекаются по городу %objective%, убивая и грабя всех на своём пути. Отступая с поля брани, вы замечаете, как вспыхивают крыши кварталов у реки.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Не удалось защитить " + this.Flags.get("ObjectiveName") + " от Великой Орды");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function spawnWave()
	{
		local hordeBase = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Jurchen).getNearestSettlement(this.m.Origin.getTile());
		local originTile = this.m.Origin.getTile();
		local tile;

		while (true)
		{
			local x = this.Math.rand(originTile.SquareCoords.X - 5, originTile.SquareCoords.X + 5);
			local y = this.Math.rand(originTile.SquareCoords.Y - 5, originTile.SquareCoords.Y + 5);

			if (!this.World.isValidTileSquare(x, y))
			{
				continue;
			}

			tile = this.World.getTileSquare(x, y);

			if (tile.getDistanceTo(originTile) <= 4)
			{
				continue;
			}

			if (tile.Type == this.Const.World.TerrainType.Ocean)
			{
				continue;
			}

			local navSettings = this.World.getNavigator().createSettings();
			navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;
			local path = this.World.getNavigator().findPath(tile, originTile, navSettings, 0);

			if (!path.isEmpty())
			{
				break;
			}
		}

		local party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Jurchen).spawnEntity(tile, "Воины орды", false, this.Const.World.Spawn.HordeRaiders, (80 + this.m.Flags.get("Wave") * 10) * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
		this.m.UnitsSpawned.push(party.getID());
		party.getLoot().ArmorParts = this.Math.rand(0, 15);
		party.getSprite("banner").setBrush(hordeBase.getBanner());
		party.setDescription("Тяжёлый отряд Великой Орды, идущий сжечь очередной город.");
		party.setFootprintType(this.Const.World.FootprintsType.Nomads);
		party.setSlowerAtNight(false);
		party.setUsingGlobalVision(false);
		party.setLooting(false);
		party.setAttackableByAI(false);
		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
		local move = this.new("scripts/ai/world/orders/move_order");
		move.setDestination(originTile);
		c.addOrder(move);
		local attack = this.new("scripts/ai/world/orders/attack_zone_order");
		attack.setTargetTile(originTile);
		c.addOrder(attack);
		local destroy = this.new("scripts/ai/world/orders/destroy_order");
		destroy.setTime(60.0);
		destroy.setSafetyOverride(true);
		destroy.setTargetTile(originTile);
		destroy.setTargetID(this.m.Origin.getID());
		c.addOrder(destroy);
	}

	function spawnRaidersAtTheWalls()
	{
		local hordeBase = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Mgl).getNearestSettlement(this.m.Origin.getTile());
		local party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Mgl).spawnEntity(this.m.Origin.getTile(), "Воины орды", false, this.Const.World.Spawn.MglRaiders, 100 * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
		party.setPos(this.createVec(party.getPos().X - 50, party.getPos().Y - 50));
		this.m.UnitsSpawned.push(party.getID());
		party.getLoot().ArmorParts = this.Math.rand(0, 15);
		party.getSprite("banner").setBrush(hordeBase.getBanner());
		party.setDescription("Передовой отряд Великой Орды, готовящий штурм города.");
		party.setFootprintType(this.Const.World.FootprintsType.Nomads);
		party.setSlowerAtNight(false);
		party.setUsingGlobalVision(false);
		party.setLooting(false);
		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
		local wait = this.new("scripts/ai/world/orders/wait_order");
		wait.setTime(15.0);
		c.addOrder(wait);
		local destroy = this.new("scripts/ai/world/orders/destroy_order");
		destroy.setTime(90.0);
		destroy.setSafetyOverride(true);
		destroy.setTargetTile(this.m.Origin.getTile());
		destroy.setTargetID(this.m.Origin.getID());
		c.addOrder(destroy);
	}

	function spawnAmbushers()
	{
		local originTile = this.m.Origin.getTile();
		local tile;

		while (true)
		{
			local x = this.Math.rand(originTile.SquareCoords.X - 5, originTile.SquareCoords.X + 5);
			local y = this.Math.rand(originTile.SquareCoords.Y - 5, originTile.SquareCoords.Y + 5);

			if (!this.World.isValidTileSquare(x, y))
			{
				continue;
			}

			tile = this.World.getTileSquare(x, y);

			if (tile.getDistanceTo(originTile) <= 4)
			{
				continue;
			}

			if (tile.Type == this.Const.World.TerrainType.Ocean)
			{
				continue;
			}

			local navSettings = this.World.getNavigator().createSettings();
			navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;
			local path = this.World.getNavigator().findPath(tile, originTile, navSettings, 0);

			if (!path.isEmpty())
			{
				break;
			}
		}

		local hordeBase = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Jurchen).getNearestSettlement(this.m.Origin.getTile());
		local party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Jurchen).spawnEntity(tile, "Разведчики орды", false, this.Const.World.Spawn.HordeRoamers, 110 * this.getDifficultyMult() * this.getScaledDifficultyMult(), this.getMinibossModifier());
		this.m.UnitsSpawned.push(party.getID());
		party.getSprite("banner").setBrush(hordeBase.getBanner());
		party.setDescription("Лёгкие разведчики Великой Орды, обходящие город с флангов.");
		party.setFootprintType(this.Const.World.FootprintsType.Nomads);
		party.setSlowerAtNight(false);
		party.setUsingGlobalVision(false);
		party.setLooting(false);
		party.setAttackableByAI(false);
		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
		local move = this.new("scripts/ai/world/orders/move_order");
		move.setDestination(originTile);
		c.addOrder(move);
		local attack = this.new("scripts/ai/world/orders/attack_zone_order");
		attack.setTargetTile(originTile);
		c.addOrder(attack);
		local destroy = this.new("scripts/ai/world/orders/destroy_order");
		destroy.setTime(60.0);
		destroy.setSafetyOverride(true);
		destroy.setTargetTile(originTile);
		destroy.setTargetID(this.m.Origin.getID());
		c.addOrder(destroy);
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"objective",
			this.m.Flags.get("ObjectiveName")
		]);
		_vars.push([
			"direction",
			this.m.Origin == null || this.m.Origin.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Origin.getTile())]
		]);
	}

	function onOriginSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Origin.addSituation(this.new("scripts/entity/world/settlements/situations/besieged_situation"));
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			foreach( id in this.m.UnitsSpawned )
			{
				local e = this.World.getEntityByID(id);

				if (e != null && e.isAlive())
				{
					e.setAttackableByAI(true);
					e.setOnCombatWithPlayerCallback(null);
				}
			}

			if (this.m.Origin != null && !this.m.Origin.isNull() && this.m.Origin.hasSprite("selection"))
			{
				this.m.Origin.getSprite("selection").Visible = false;
			}

			if (this.m.Home != null && !this.m.Home.isNull() && this.m.Home.hasSprite("selection"))
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

		return true;
	}

	function onSerialize( _out )
	{
		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.contract.onDeserialize(_in);
	}

});
