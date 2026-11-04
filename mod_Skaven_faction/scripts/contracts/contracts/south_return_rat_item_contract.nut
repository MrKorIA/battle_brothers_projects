this.south_return_rat_item_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		IsPlayerAttacking = true
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.south_return_rat_item";
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
				party.setDescription("Группа диких скавенов.");
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
			Text = "[img]gfx/ui/events/event_162.png[/img]{%employer% сидит на подушках, вертит в руках пустой футляр, инкрустированный бирюзой, поднимает его на свет и бросает вам под ноги.%SPEECH_ON%Видишь это? Пустота. Мой %itemLower% был внутри этого футляра, пока проклятые скавены не прорыли ход под моей спальней: пол провалился в их нору, и артефакт исчез вместе с грудой земли - слуги обнаружили в погребе крысиные следы, ведущие вглубь тоннеля. Мои стражники не слышали ни звука, а утром вместо артефакта - только нора в полу. Я послал людей по следу - никто не вернулся. Теперь ты пойдёшь по их следам, найдёшь логово этих тварей, заберёшь мою вещь и принесёшь её обратно. Если она будет повреждена, я вычту из твоей платы. Сколько? Я думаю, %reward% крон - более чем щедро для такой работы.%SPEECH_OFF%Он смотрит на вас с ожиданием ответа. | %employer% стоит у пролома в стене - земля осыпалась, и виден туннель, уходящий вниз. Он указывает на него пальцем.%SPEECH_ON%Они приходят уже третью неделю. Сначала пропал скот, потом слуги начали видеть тени в подвалах. А вчера они забрали мой %itemLower% - прямо из-под моей подушки. Они не могли уйти далеко. Я дам тебе %reward% крон, если ты вернёшь мне мою вещь и убьёшь каждого скавена, который посмел прикоснуться к ней. Если хочешь больше - назови цену, но помни: я всегда могу найти кого-то дешевле.%SPEECH_OFF%Он скрещивает руки на груди и ждёт вашего ответа. | %employer% сидит за столом, заваленным пергаментами с изображениями крысиных следов. Он разворачивает один из них и показывает вам.%SPEECH_ON%Я нанял лучшего следопыта в городе %townname%. Он проследил путь крыс от моего дворца до пустыни. Они не просто украли мой %itemLower% - они тащат его в своё логово, где собирают награбленное. Догони их, прекрати их жалкое существование и верни мне мою собственность. Я заплачу %reward% крон.%SPEECH_OFF%Он откидывается на спинку стула и смотрит на вас изучающе. | Вы входите в покои: %employer% сидит с повязкой на глазу и злобно смотрит на вас единственным глазом.%SPEECH_ON%Ты видишь, что они сделали? Крыса выпрыгнула из тени и поцарапала мне глаз, когда я пытался защитить свой %itemLower%. Она унесла его в пустыню, но мои люди нашли следы у старого храма. Я хочу, чтобы ты выследил эту тварь и всю её стаю, забрал мою вещь и принёс мне голову этого наглого скавена в доказательство. Я даю тебе %reward% крон. Если хочешь больше - мы поговорим, но не задерживай меня, алчущий крон.%SPEECH_OFF%Он снимает повязку, и вы видите свежую рану - вздувшуюся, с запёкшейся кровью по краям. | %employer% стоит на крыше своего дворца и показывает рукой на дым, поднимающийся над пустыней.%SPEECH_ON%Видишь этот дым? Это горит мой склад. Крысы подожгли его прошлой ночью и, пока мои люди боролись с огнём, выкрали мой %itemLower% из сокровищницы. Догони их, верни мне мою вещь и перебей их всех - тогда, алчущий крон, получишь %reward% крон.%SPEECH_OFF%Он поворачивается и меряет вас холодным, расчётливым взглядом.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Поговорим о плате.}",
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
			Text =  "[img]gfx/ui/events/rat_event_07.png[/img]{Вы замечаете скавенов у старого русла реки. Группа крыс тащит что-то тяжёлое - судя по очертаниям в мешке, это %itemLower%. Они не замечают вас, слишком увлечены своим грузом. Вы отдаёте приказ атаковать, пока скавены не разбежались во все стороны. | Скавены сидят у камня и ссорятся из-за добычи. У одного в лапах - %itemLower%: он потрясает находкой, будто трофеем. Они даже не слышат ваших шагов - песок глушит звуки. Вы поднимаете меч готовясь к атаке. | Вы находите скавенов в тени скалы - они отдыхают после долгого пути. Рядом с ними лежит что-то, завёрнутое в грязную ткань, - это %itemLower%. Они замечают вас и начинают быстро собираться. Вы отдаёте приказ атаковать, пока они не разбежались, как крысы.}",
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
			Text = "[img]gfx/ui/events/rat_event_05.png[/img]{Вы идёте по следу и выходите к глубокой расселине, из которой доносится запах гнили и шерсти. Внутри вы видите крыс, но одна из них отличается - огромная тварь, которую они явно для чего-то раскармливают. Рядом с ней в слизи валяется какая-то вещь - это %itemLower%. Крысы замечают вас и с визгом бросаются в вашу сторону. | Вы подходите к пещере и слышите чавканье. Внутри - крысы, которые жуют что-то, напоминающее человеческую ногу. Рядом с ними лежит %itemLower% - на вещи видны следы крысиных зубов. Вы вынимаете меч и идёте вперёд, понимая, что времени на раздумья нет.}",
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
			Text = "[img]gfx/ui/events/event_76.png[/img]{Вы стираете кровь с клинка и наклоняетесь, чтобы поднять %itemLower%. В этот момент из тени появляется человек в длинной робе - его лицо скрыто капюшоном.%SPEECH_ON%Я вижу, ты отнял мою собственность у этих неуклюжих тварей. Они были лишь курьерами, но, как видишь, они своё отработали. Я заплачу тебе %bribe% крон за этот предмет. Ты отдашь его мне, и мы разойдёмся с миром. Твой наниматель, конечно, будет недоволен, но %bribe% крон - хорошая цена за небольшое неудобство, не так ли?%SPEECH_OFF%Вы смотрите на него - в его голосе слышится нечто большее, чем обычная жадность. | После боя вы поднимаете %itemLower%. Через мгновение раздаются шаги за спиной. Обернувшись, вы видите человека, который стоит в нескольких шагах, скрестив руки на груди.%SPEECH_ON%Твой наниматель просил тебя вернуть эту вещь, но я предлагаю тебе сделку. Я дам тебе %bribe% крон, ты отдашь мне предмет. Он не должен попасть в руки визиря, иначе кое-что всплывёт наружу. Подумай, алчущий крон: хочешь ли ты быть слепым орудием в чужой игре, или предпочтёшь уйти с деньгами и знанием, что ты сделал правильный выбор?%SPEECH_OFF% | Вы вытираете пот со лба и забираете %itemLower%. В этот момент раздаётся тихий смех. Из-за валуна выходит старик с седой бородой - его глаз не видно за чёрным капюшоном.%SPEECH_ON%Хорошая работа, наёмник. Ты убил моих слуг, но это даже к лучшему - они были слишком ненадёжны. Я дам тебе %bribe% крон за этот предмет. Он не должен попасть в руки визиря: тот использует подобные вещи для целей, которых даже сам не понимает. Ты хочешь быть частью этого безумия? Или ты хочешь денег и чистой совести?%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_76.png[/img]Вы смотрите на мешок с кронами, потом на %itemLower%. Взвешиваете всё и протягиваете предмет незнакомцу. Он улыбается, забирает его и быстро скрывается в дали, оставляя вас с туго набитым кошельком. Вы знаете, что %employer% не будет доволен, но что сделано, то сделано.}",
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
			Text = "[img]gfx/ui/events/rat_event_08.png[/img]{Вы поднимаете %itemLower% из пыли и стряхиваете с него песок. Вещь целая, хоть и немного грязная. Ваши люди уже обыскивают тела скавенов в поисках чего-то ценного. Вы отдаёте им приказ собираться в путь - визирь ждёт вас. | Бой окончен, и вы с облегчением видите, что %itemLower% не пострадал. Вы убираете его в мешок и даёте сигнал отряду выдвигаться. Задание выполнено, осталось только забрать плату. | Вы забираете %itemLower% из рук мёртвой крысы и осматриваете его. На нём нет трещин - только царапины от зубов. Вы прячете его в рюкзак и идёте к своим людям. Пора возвращаться.}",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{Вы возвращаетесь в город %townname% и пытаетесь войти в покои визиря, но ваш путь преграждает стражник с алебардой.%SPEECH_ON%Стой. %employer% не желает видеть твою грязную физиономию. Отдай мне то, что ты нёс, и жди здесь.%SPEECH_OFF%Вы протягиваете %itemLower% стражнику. Он уходит и через несколько минут возвращается с кошельком, который бросает на пол перед вами.%SPEECH_ON%Возьми свои кроны и убирайся.%SPEECH_OFF%Стражник разворачивается и уходит, оставляя вас стоять с кошельком у ваших ног. | Вы ждёте у входа в покои визиря несколько минут, прежде чем появляется слуга с кошельком в руках. Он не смотрит вам в глаза.%SPEECH_ON%%employer% осмотрел вашу находку и подтвердил, что это его %itemLower%. Он велел передать тебе плату и сказать, что ты разочаровал его своей медлительностью. Вот твои кроны. Теперь уходи.%SPEECH_OFF%Слуга бросает кошелёк вам под ноги и уходит, не сказав больше ни слова. | Вы пытаетесь войти, но двери захлопываются прямо перед вашим носом. Из-за двери доносится голос - это %employer%.%SPEECH_ON%Оставь мою вещь у двери и убирайся. Я не хочу смотреть на твоё лицо. Твоя плата лежит рядом с сундуком. Если ты украдёшь хотя бы одну монету, я прикажу перерезать тебе глотку. Выбирай: жизнь или жадность.%SPEECH_OFF%Вы слышите его удаляющиеся шаги. Взгляд на мгновение задерживается на сундуке - но вы забираете ровно то, что причитается, и уходите. | Слуга выносит вам кошелёк и швыряет его под ноги.%SPEECH_ON%Визирь сказал: \'Этот алчущий крон едва не провалил задание. Но вещь цела, и я, как щедрый человек, плачу ему. Передай, что я запомнил этот запах и надеюсь больше никогда его не учуять. Вот кроны. А теперь убирайся, пока я не пожалел о своей щедрости\'.%SPEECH_OFF%Слуга разворачивается и уходит, оставляя вас с кошельком в пыли у ваших ног.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Ну, плату-то мы получили...",
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
			Text = "[img]gfx/ui/events/event_161.png[/img]{Ваш отряд уже несколько дней идёт по следу скавенов, но песок заметает его всё сильнее. Наконец следы обрываются у старого колодца - дальше только пустая равнина. Вы отправляете людей в разные стороны, но они возвращаются ни с чем. Похоже, %itemLower% исчез в пустыне навсегда. %employer% будет в ярости, но с этим уже ничего не сделать. | Вы обыскиваете все окрестности, но вместо следа находите лишь старые кости и обрывки ткани. Скавены умело замели следы - преследовать уже некого. Отряд устал, и вы приказываете возвращаться с пустыми руками. | Вы сидите на бархане и смотрите на бескрайний песок. Следы исчезли, как будто их и не было. Вы посылаете разведчиков вперёд, но они возвращаются ни с чем. Остаётся только признать поражение. %employer% не простит вам этого, но что сделано, то сделано.}",
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

