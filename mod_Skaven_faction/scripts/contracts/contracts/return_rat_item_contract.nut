this.return_rat_item_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		IsPlayerAttacking = true
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.return_rat_item";
		this.m.Name = "Подлые похитители";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 400 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		local items = [
			"Церемониальный посох",
			"Идол плодородия",
			"Золотой талисман",
			"Фолиант тайных знаний",
			"Хрустальный череп"
		];
		local r = this.Math.rand(0, items.len() - 1);
		this.m.Flags.set("Item", items[r]);
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Идти по следу возле поселения %townname%",
					"Вернуть %item% в %townname%"
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

				if (r <= 15)
				{
					if (this.Contract.getDifficultyMult() >= 0.95)
					{
						this.Flags.set("IsRatBeast", true);
					}
				}
				else if (r <= 30)
				{
					this.Flags.set("IsCounterOffer", true);
					this.Flags.set("Bribe", this.Contract.beautifyNumber(this.Contract.m.Payment.getOnCompletion() * this.Math.rand(100, 300) * 0.01));
				}
				else
				{
					this.Flags.set("IsRat", true);
				}

				this.Flags.set("StartDay", this.World.getTime().Days);
				local playerTile = this.World.State.getPlayer().getTile();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 5, 10, [
					this.Const.World.TerrainType.Mountains
				]);
				local party;
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Rat).spawnEntity(tile, "Дикие скавены", false, this.Const.World.Spawn.RatRoamers, 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				party.setDescription("Группа диких крыс.");
				party.setFootprintType(this.Const.World.FootprintsType.Skavens);
				party.setAttackableByAI(false);
				party.getController().getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				party.setFootprintSizeOverride(0.75);
				this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.SkavenFootprints, this.Const.World.FootprintsType.Skavens, 0.75);
				this.Contract.m.Target = this.WeakTableRef(party);
				party.getSprite("banner").setBrush("banner_rat_0" + this.Math.rand(1, 12));
				local c = party.getController();
				local wait = this.new("scripts/ai/world/orders/wait_order");
				wait.setTime(9000.0);
				c.addOrder(wait);
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Идти по следу к %direction% от поселения %townname%",
					"Вернуть %item% в %townname%"
				];

				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onTargetAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull())
				{
					if (this.Flags.get("IsCounterOffer"))
					{
						this.Contract.setScreen("CounterOffer1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("BattleDone");
						this.World.Contracts.showActiveContract();
						this.Contract.setState("Return");
					}
				}
				else if (this.World.getTime().Days - this.Flags.get("StartDay") >= 3 && this.Contract.m.Target.isHiddenToPlayer())
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (!this.Flags.get("IsAttackDialogTriggered"))
				{
					if (this.Flags.get("IsRatBeast"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
						this.Contract.setScreen("RatBeast");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
						this.Contract.setScreen("Rat");
						this.World.Contracts.showActiveContract();
					}
				}
				else
				{
					this.World.Contracts.showCombatDialog(_isPlayerAttacking);
				}
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Вернуть %item% в %townname%"
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
		this.importScreens(this.Const.Contracts.NegotiationDefault);
		this.importScreens(this.Const.Contracts.Overview);
		this.m.Screens.push({
			ID = "Task",
			Title = "Переговоры",
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer% мерит шагами комнату, не в силах успокоиться.%SPEECH_ON%Дерзкая кража, наёмник! Мерзкие скавены обчистили мой амбар. Пропал %itemLower% - я не знаю, зачем им сдалась эта старая безделушка, но она моя, и она должна вернуться.%SPEECH_OFF%Он останавливается у стола и вдавливает пальцы в карту.%SPEECH_ON%Ты пойдёшь по их следам, нагонишь крыс и вернёшь мне вещь. Я же заплачу тебе за это.%SPEECH_OFF% | %employer% сидит, опустив голову на руки. Перед ним на столе лежит пустой чехол из плотной кожи.%SPEECH_ON%Здесь лежал %itemLower%. Теперь пусто. Они пришли снизу - прокопали лаз прямо под стеной. Никто ничего не слышал, никто ничего не видел.%SPEECH_OFF%Он поднимает на вас мутный взгляд.%SPEECH_ON%Я знаю, что это сделали скавены. Только они умеют так бесшумно рыться в чужом добре. Найди их нору, вытащи мою вещь и сожги всё, что останется. И побыстрее - у меня не так много времени, мне нужен мой %itemLower%.%SPEECH_OFF% | Вы входите в подвал - %employer% стоит у раскрытого люка, ведущего куда-то во тьму под домом. Он тычет пальцем вниз.%SPEECH_ON%Запах, наёмник. Чуешь?%SPEECH_OFF%Вы принюхиваетесь - тяжёлый мускусный смрад, звериный и едкий, поднимается прямо из-под пола.%SPEECH_ON%Вчера вечером этот лаз был закрыт наглухо. Сегодня утром я обнаружил, что мой %itemLower% исчез, а люк раскрыт настежь. Скавены прорыли ход прямо под мой дом. Пропажу я заметил на рассвете - значит, они не успели уйти далеко, наверняка затаились где-то в норе под нами. Спускаться в эту яму я тебя не прошу - я прошу перехватить их, когда они вылезут и побегут прятать мою вещь.%SPEECH_OFF% | %employer% стоит у окна, но не смотрит на улицу - он смотрит на грязный отпечаток крысиного носа на стекле.%SPEECH_ON%Он был здесь. Прямо у моего окна. Я спал, а этот... этот крыс стоял и смотрел на меня. Мой %itemLower% пропал - стащили его, точно дитя из колыбели.%SPEECH_OFF%Он резко разворачивается.%SPEECH_ON%Мне плевать, как ты это сделаешь. Найди его, найди всех, кто с ним. Верни вещь. И проследи, чтобы ни один из них не ушёл живым.%SPEECH_OFF% | В комнате темно, только свеча на столе даёт немного света. %employer% сидит неподвижно, и вы почти принимаете его за изваяние.%SPEECH_ON%Я думал, это был сон - будто %itemLower% сам исчез, растворился в ночи, как наваждение. Но сегодня утром я нашёл следы под окном - маленькие, длиннопалые, с отпечатками когтей.%SPEECH_OFF%Он пододвигает к вам лист бумаги, где грубо срисован один из этих следов.%SPEECH_ON%Вот, гляди. Это не человек и не зверь, которого я знаю. Скавены. Я не сумасшедший. Моя вещь у них. Верни её, наёмник. И я заплачу столько, сколько скажешь.%SPEECH_OFF% | %employer% хватает вас за рукав, едва вы входите в его комнату, и увлекает за собой к стене, где висит карта.%SPEECH_ON%Вот здесь, на восточной околице - они разорили старую мельницу. Утащили мешки с зерном, а заодно у меня пропал %itemLower%. Я знаю, что это они, потому что один из крестьян видел их - серые тени с хвостами, тащили что-то блестящее.%SPEECH_OFF%Он хлопает ладонью по карте.%SPEECH_ON%Надо спешить, пока ещё видны следы этих наглых грабителей. Иди, убей их, верни вещь. Не возвращайся без неё!%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Какова оплата? | Поговорим о плате.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Мы не берёмся за такую работу. | Нам это не подходит.}",
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
			ID = "Rat",
			Title = "По мере приближения...",
			Text =  "[img]gfx/ui/events/rat_event_07.png[/img]{Вы выходите на поляну, и запах ударяет в нос - кислый, сырой, почти осязаемый. Скавены здесь. Они не ждали вас - заняты делёжкой, пищат и тянут друг у друга какие-то тряпки. Один из них сжимает в лапах %itemLower% и смотрит на него с тупым любопытством. При виде ваших людей шайка замирает. А потом вожак, самый крупный, с рваным ухом, поднимает ржавый тесак и визгливо командует. Они не побегут. Им есть что защищать. | Следы приводят ваш отряд к старому оврагу, заваленному ветками. Внутри - гнездо. Грязное, вонючее, усеянное костями. В центре, на куче тряпья, лежит %itemLower%. Рядом с ним дремлют двое скавенов, третий стоит в карауле. Он замечает вас первым - и в тот же миг его визг поднимает всех крыс на ноги. Скавены готовятся к бою. Унести вещь можно только через их трупы. | Ваш отряд обходит холм и видит их - десяток серых фигур, сгорбленных и косолапых. Они тащат награбленное к старой норе - и в руках одного из них блестит %itemLower%. Значит вещица всё ещё у них. Вожак, покрытый шрамами, чует опасность и резко оборачивается. Скавены бросают поклажу и хватаются за оружие. Они не отдадут добычу без боя. Вы поднимаете руку и приказываете своим людям идти вперёд.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "К оружию!",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "RatBeast",
			Title = "По мере приближения...",
			Text = "[img]gfx/ui/events/event_76.png[/img]{Вы выходите к скавенам - те, ничего не подозревая, пытаются спрятать %itemLower% в нору. Ваше появление застаёт их врасплох, но крысиная стая быстро приходит в себя и бросается в атаку. | Вы замечаете волкокрысов, которые тащат %itemLower% прямо в подземную нору! Эта пещера может вести в скавенблит - и при тусклом свете факела эта мысль совсем не кажется бредовой. Но %employer% платит вам не за размышления. В атаку!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "К оружию!",
					function getResult()
					{
						this.Const.World.Common.addTroop(this.Contract.m.Target, {
							Type = this.Const.World.Spawn.Troops.WolfRat
						});
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CounterOffer1",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_76.png[/img]{Последний скавен падает, пронзённый копьём. Вы подходите к телу вожака и вытаскиваете %itemLower% из его мёртвых лап. Но когда вы поворачиваетесь, за спиной раздаются медленные аплодисменты. Из-за валуна выходит человек в дорогом, но пыльном плаще. Он улыбается, разводя руками.%SPEECH_ON%Браво, наёмник. Ты проделал грязную работу за меня.%SPEECH_OFF%Вы настораживаетесь. Он показывает на %itemLower%.%SPEECH_ON%Этот артефакт нужен мне, а не твоему работодателю. Он даже не знает, что держал в руках. Я заплачу тебе %bribe% крон - больше, чем он тебе даст. Отдай вещь мне, и мы разойдёмся друзьями.%SPEECH_OFF%Мешок в его руке выглядит увесистым. | Битва стихает. Вы наклоняетесь, чтобы поднять %itemLower%, но внезапно из кустов раздаётся шорох. Человек с умными, цепкими глазами выходит на поляну, держа руки поднятыми в знак мирного намерения.%SPEECH_ON%Я не враг, наёмник. Я - покупатель. И я хочу приобрести эту вещь у тебя. За %bribe% крон.%SPEECH_OFF%Он кивает на артефакт.%SPEECH_ON%Твой наниматель не знает истинной ценности этой вещи. Я знаю. И я готов за неё заплатить. Сделка честнее любой, что он тебе предложил.%SPEECH_OFF% | Вы очищаете клинок от вонючей крови скавенов, когда замечаете фигуру у дерева. Незнакомец не прячется - он делает шаг вперёд и говорит спокойно, без эмоций.%SPEECH_ON%Этих тварей нанял я. Я заплатил им, чтобы они принесли мне %itemLower%. Но они не смогли этого сделать. Вопрос теперь в том, захочешь ли ты отдать мне эту вещь за %bribe% крон.%SPEECH_OFF%Он протягивает мешок. Кроны в мешке звенят весомо - такой звон трудно спутать с пустыми обещаниями.%SPEECH_ON%Твой %employer% не в состоянии оценить ценность этого предмета, как и твою. Делай выбор, наёмник.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Я сразу вижу хорошую сделку. Пересыпай монеты.",
					function getResult()
					{
						this.updateAchievement("NeverTrustAMercenary", 1, 1);
						return "CounterOffer2";
					}

				},
				{
					Text = "Нам платят за возвращение артефакта, так что мы выполним обещанное.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CounterOffer2",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_76.png[/img]Вы отдаёте %itemLower%. Незнакомец вручает вам тяжёлый, отвисший мешок. Сделка совершена. Можно с уверенностью сказать, что %employer% будет крайне недоволен.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Хорошая оплата.",
					function getResult()
					{
						this.World.Assets.addMoney(this.Flags.get("Bribe"));
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractBetrayal);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Не удалось вернуть украденный " + this.Flags.get("Item"));
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы получаете [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Flags.get("Bribe") + "[/color] крон"
				});
			}

		});
		this.m.Screens.push({
			ID = "BattleDone",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/rat_event_08.png[/img]{Вы отшвыриваете ногой тело скавена и наклоняетесь над его разжатыми лапами. %itemLower% - здесь. Грязный, но целый. Вы вытираете его о траву и прячете в мешок. Ваши люди ходят по полю боя и ищут, чем можно поживиться. Ветер уносит вонь, и наступает та редкая минута, когда можно вздохнуть полной грудью. Пора возвращаться. | Бой заканчивается так же быстро, как и начался: скавены не умеют долго сопротивляться. Среди разбросанного хлама вы обнаруживаете %itemLower%, завёрнутый в грязную тряпицу. Поднимая его, вы чувствуете тяжесть - не физическую, а ту, что приходит с выполненным долгом. Скоро эта тяжесть обернётся другой, куда более приятной: весом монет в кошеле. %employer% ждёт. | Тела крыс свалены в кучу и уже занимаются огнём - вы распорядились сжечь их, пока чумная зараза не расползлась по округе. А в стороне от костра растёт другая груда - трофеи: всё, что нашлось у скавенов ценного, включая %itemLower%. Он лежал в ворохе тряпья, которое крысы использовали вместо подстилки, - весь в грязи и чужой крови, но цел. Вы киваете своим бойцам, и отряд собирается в обратный путь.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Пора забрать нашу плату.",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{Вы входите в тесный кабинет, заваленный бумагами. За столом, зарывшись в них с головой, сидит %employer% - он не сразу поднимает голову. Но стоит ему заметить %itemLower% у вас в руке, как лицо его меняется - напряжение спадает, словно кто-то перерезал тетиву.%SPEECH_ON%Он здесь. Ты принёс его.%SPEECH_OFF%Забирая %itemLower%, он проводит пальцем по его поверхности, проверяя, не повреждён ли.%SPEECH_ON%Грязный, но целый. Ты справился, наёмник.%SPEECH_OFF%%employer% протягивает вам тяжёлый кошель.%SPEECH_ON%Плата, как договаривались. Хорошая работа.%SPEECH_OFF%Вы забираете плату, пересчитываете монеты и уходите. | В комнате пахнет чернилами и воском - вы кладёте %itemLower% на стол, за которым сидит %employer%. Он смотрит на него, потом на вас, потом снова на вещь.%SPEECH_ON%Я не думал, что ты справишься. Честно говоря, я уже мысленно попрощался с ним.%SPEECH_OFF%Он усмехается и качает головой.%SPEECH_ON%Но ты пришёл. И принёс его. За это ты получишь всё до последней кроны.%SPEECH_OFF%Он выдвигает ящик стола и достаёт увесистый кожаный кисет. Кроны звенят глухо и увесисто. Вы берёте кисет и покидаете комнату. | %employer% встречает вас у дверей, не дав даже шагнуть в комнату.%SPEECH_ON%Где он?%SPEECH_OFF%Вы молча протягиваете %itemLower%. Он хватает его, прижимает к груди и закрывает глаза.%SPEECH_ON%Ты не представляешь, что эта вещь для меня значит.%SPEECH_OFF%Он выдыхает и открывает глаза.%SPEECH_ON%Вот твоя плата. Всё до последней кроны.%SPEECH_OFF%Он вручает вам кошель. Вы взвешиваете его в руках и думаете, что, возможно, продешевили.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Вернул украденный " + this.Flags.get("Item"));
						this.World.Contracts.finishActiveContract();
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
			Title = "По пути...",
			Text = "[img]gfx/ui/events/event_75.png[/img]{Вы стоите на перекрёстке, глядя на землю. Следы обрываются здесь, словно скавены растворились в воздухе. %randombrother% подходит и качает головой.%SPEECH_ON%Мы их потеряли, командир. Вода смыла всё, а дальше - только грязь и камни.%SPEECH_OFF%Вы стискиваете челюсть - погоня закончилась совсем не так, как вы надеялись. %employer% будет в ярости. Вещь ушла в подземелья, и её уже никогда не найти. | Вы поднимаетесь на холм и смотрите вниз - там, где по карте должно быть логово, только старый остов дома и разбросанные кости. Скавены ушли. Они забрали %itemLower% с собой в неизвестность, и даже опытные следопыты разводят руками. Ваш отряд устал, а контракт - провален. Остаётся только вернуться и признать поражение. | Вы идёте по следу, который ведёт в топь. С каждым шагом он становится всё менее явным. Наконец след просто исчезает. Болото вокруг молчит: ни звука, ни движения, ни запаха. Всё, что осталось - это сожаление. %randombrother% стоит рядом и тоже молчит, потому что сказать нечего. Добыча ускользнула у вас из рук.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Будь проклят этот контракт!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Не удалось вернуть украденный " + this.Flags.get("Item"));
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"direction",
			this.m.Target == null || this.m.Target.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Target.getTile())]
		]);
		_vars.push([
			"item",
			this.m.Flags.get("Item")
		]);
		_vars.push([
			"itemLower",
			this.m.Flags.get("Item").tolower()
		]);
		_vars.push([
			"bribe",
			this.m.Flags.get("Bribe")
		]);
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

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		return true;
	}

	function onSerialize( _out )
	{
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
		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}

		this.contract.onDeserialize(_in);
	}

});

