this.marauding_rat_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Objective = null,
		Target = null,
		IsPlayerAttacking = true,
		LastRandomEventShown = 0.0
	},
	function setObjective( _h )
	{
		if (typeof _h == "instance")
		{
			this.m.Objective = _h;
		}
		else
		{
			this.m.Objective = this.WeakTableRef(_h);
		}
	}

	function setRat( _o )
	{
		this.m.Flags.set("IsRat", _o);
	}

	function create()
	{
		this.contract.create();
		this.m.Type = "contract.marauding_rat";
		this.m.Name = "Мародёрствующие скавены";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
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

		local myTile = this.m.Origin.getTile();
		local rat = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Rat).getNearestSettlement(myTile);

		this.m.Flags.set("IsRat", true);

		local bestDist = 9000;
		local best;
		local settlements = this.World.EntityManager.getSettlements();

		foreach( s in settlements )
		{
			if (s.isMilitary() || s.isSouthern() || !s.isDiscovered())
			{
				continue;
			}

			if (s.getID() == this.m.Origin.getID() || s.getID() == this.m.Home.getID())
			{
				continue;
			}

			local d = this.getDistanceOnRoads(s.getTile(), this.m.Origin.getTile());

			if (d < bestDist)
			{
				bestDist = d;
				best = s;
			}
		}

		if (best != null)
		{
			local distance = this.getDistanceOnRoads(best.getTile(), this.m.Origin.getTile());
			this.m.Flags.set("MerchantReward", this.Math.max(150, distance * 5.0 * this.getPaymentMult()));
			this.setObjective(best);
			this.m.Flags.set("MerchantID", best.getFactionOfType(this.Const.FactionType.Settlement).getRandomCharacter().getID());
		}

		this.m.Payment.Pool = 650 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Убить мародёрствующих скавенов в окрестностях %origin%"
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

				if (r <= 5 && this.World.Assets.getBusinessReputation() >= 2250)
				{
					if (this.Flags.get("Rat") == true)
					{
						this.Flags.set("IsWarlord", true);
					}
				}
				else if (r <= 10 && this.Contract.m.Objective != null)
				{
					this.Flags.set("IsMerchant", true);
				}

				local originTile = this.Contract.m.Origin.getTile();
				local tile = this.Contract.getTileToSpawnLocation(originTile, 5, 10);
				local party;

				if (this.Flags.get("IsRat"))
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Rat).spawnEntity(tile, "Мародеры скавенов", false, this.Const.World.Spawn.RatRaiders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					party.setDescription("Банда скавенов.");
				    party.setFootprintType(this.Const.World.FootprintsType.Skavens);
					party.getLoot().ArmorParts = this.Math.rand(0, 25);
					party.getLoot().Ammo = this.Math.rand(0, 10);
					party.addToInventory("supplies/rat_soup_item");
					local enemyBase = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Rat).getNearestSettlement(this.Contract.getOrigin().getTile());
					party.getSprite("banner").setBrush(enemyBase.getBanner());
				}

				this.Contract.m.UnitsSpawned.push(party.getID());
				this.Contract.m.Target = this.WeakTableRef(party);
				party.setAttackableByAI(false);
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setPivot(this.Contract.m.Origin);
				roam.setMinRange(3);
				roam.setMaxRange(8);
				roam.setAllTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
				roam.setTerrain(this.Const.World.TerrainType.Shore, false);
				roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
				c.addOrder(roam);
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onTargetAttacked.bindenv(this));
				}

				this.Contract.m.Origin.getSprite("selection").Visible = true;
			}

			function update()
			{
				local playerTile = this.World.State.getPlayer().getTile();

				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || !this.Contract.m.Target.isAlive())
				{
					if (this.Flags.get("IsMerchant") && this.Contract.m.Objective != null && !this.Contract.m.Objective.isNull())
					{
						this.Contract.setScreen("Merchant");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsRat"))
					{
						this.Contract.setScreen("BattleWonRat");
						this.World.Contracts.showActiveContract();
						this.Contract.setState("Return");
					}
				}
				else if (playerTile.getDistanceTo(this.Contract.m.Target.getTile()) <= 10 && this.Contract.m.Target.isHiddenToPlayer() && this.Time.getVirtualTimeF() - this.Contract.m.LastRandomEventShown >= 30.0 && this.Math.rand(1, 1000) <= 1)
				{
					this.Contract.m.LastRandomEventShown = this.Time.getVirtualTimeF();

					if (!this.Flags.get("IsBurnedFarmsteadShown") && playerTile.Type == this.Const.World.TerrainType.Plains || playerTile.Type == this.Const.World.TerrainType.Hills || playerTile.Type == this.Const.World.TerrainType.Tundra || playerTile.Type == this.Const.World.TerrainType.Steppe)
					{
						this.Flags.set("IsBurnedFarmsteadShown", true);
						this.Contract.setScreen("BurnedFarmstead");
						this.World.Contracts.showActiveContract();
					}
					else if (!this.Flags.get("IsCaravanShown") && playerTile.HasRoad)
					{
						this.Flags.set("IsCaravanShown", true);
						this.Contract.setScreen("DestroyedCaravan");
						this.World.Contracts.showActiveContract();
					}
					else if (!this.Flags.get("IsDeadBodiesRatShown") && this.Flags.get("IsRat") == true)
					{
						this.Flags.set("IsDeadBodiesRatShown", true);
						this.Contract.setScreen("DeadBodiesRat");
						this.World.Contracts.showActiveContract();
					}
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (this.Flags.get("IsWarlord") && !this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);
					this.Const.World.Common.addTroop(this.Contract.m.Target, {
						Type = this.Const.World.Spawn.Troops.RatWarlord
					}, false);
					this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
					this.Contract.setScreen("Warlord");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					this.World.Contracts.showCombatDialog(_isPlayerAttacking);
				}
			}

		});
		this.m.States.push({
			ID = "Running_Merchant",
			function start()
			{
				this.Contract.m.Origin.getSprite("selection").Visible = false;

				if (this.Contract.m.Objective != null && !this.Contract.m.Objective.isNull())
				{
					this.Contract.m.Objective.getSprite("selection").Visible = true;
				}

				this.Contract.m.BulletpointsObjectives = [
					"Безопасно доставить купца к %objective% в направлении %objectivedirection%"
				];
				this.Contract.m.BulletpointsPayment = [];
				this.Contract.m.BulletpointsPayment.push("Получить %reward_merchant% крон по прибытии");
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Objective))
				{
					this.Contract.setScreen("Success2");
					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
			}

			function end()
			{
				if (this.Contract.m.Objective != null && !this.Contract.m.Objective.isNull())
				{
					this.Contract.m.Objective.getSprite("selection").Visible = false;
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
				this.Contract.m.BulletpointsPayment = [];

				if (this.Contract.m.Payment.Advance != 0)
				{
					this.Contract.m.BulletpointsPayment.push("Получить " + this.Contract.m.Payment.getInAdvance() + " крон аванса");
				}

				if (this.Contract.m.Payment.Completion != 0)
				{
					this.Contract.m.BulletpointsPayment.push("Получить " + this.Contract.m.Payment.getOnCompletion() + " крон по завершении");
				}

				this.Contract.m.Home.getSprite("selection").Visible = true;
				this.Contract.m.Origin.getSprite("selection").Visible = false;
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer% сидит, сгорбившись, и массирует виски, будто не спал несколько ночей. Когда вы входите, он поднимает на вас мутный взгляд.%SPEECH_ON%Скавены. Опять. Они появились из ниоткуда и теперь рыскают по окрестностям поселения %origin%, сжигая всё, что не могут съесть, и съедая всё, что не могут сжечь. Мои люди боятся даже выходить за ворота.%SPEECH_OFF%Он встаёт и подходит к окну.%SPEECH_ON%Мне нужен кто-то, кто выследит эту стаю и убьёт их всех до единого. Ты - моя последняя надежда. Сколько хочешь за то, чтобы они перестали быть моей головной болью?%SPEECH_OFF% | %employer% стоит у карты, на которой углём отмечены сожжённые хутора и разорённые деревни. Он не оборачивается, когда вы входите.%SPEECH_ON%Смотри сюда.%SPEECH_OFF%Он обводит рукой область вокруг поселения %origin%.%SPEECH_ON%Вот здесь, вот здесь и вот здесь - скавены. Они оставляют после себя только пепел и обглоданные кости. Я посылал людей - они не вернулись. Теперь я посылаю тебя. Найди их, наёмник. Убей их. И тогда можешь возвращаться за платой.%SPEECH_OFF% | %employer% сидит на корточках у камина и смотрит на огонь, не поднимая головы, когда вы подходите.%SPEECH_ON%Моя дочь. Ей было двенадцать. Я нашёл её вчера утром в двух милях от дома. Я не стану рассказывать тебе, как она выглядела. Скавены сделали это. И они всё ещё рыскают вокруг поселения %origin%.%SPEECH_OFF%Он встаёт и смотрит вам прямо в глаза. В них нет слёз - только холодная, твёрдая ярость.%SPEECH_ON%Я заплачу тебе столько, сколько попросишь. Только убей их всех.%SPEECH_OFF% | Вы входите в комнату, где %employer% сидит за столом, заваленным письмами. Он поднимает одно из них и трясёт им перед вашим лицом.%SPEECH_ON%Двадцать три донесения за неделю. Все из окрестностей поселения %origin%. Все - с одним и тем же сообщением: скавены в округе. Они сожгли мельницу, перерезали скот, утащили людей в свои норы. Я не могу больше ждать.%SPEECH_OFF%Он бросает письмо на стол и откидывается на спинку стула.%SPEECH_ON%Иди туда, найди и вырежь их всех под корень. Заплачу сполна.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Мы могли бы выследить их, если плата будет подходящей. | Борьба со скавенами дёшево не обходится. | Поговорим об оплате.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Это того не стоит. | У нас есть другие обязательства.}",
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
			ID = "DestroyedCaravan",
			Title = "По пути...",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Вы выходите на дорогу и видите на ней - разбитый караван. Телеги перевёрнуты, товары разбросаны по земле, а тела погонщиков и купцов уже начали растаскивать птицы. Подходите ближе и видите следы - не глубокие, с отпечатками когтей, уходящие в поля. Скавены были здесь совсем недавно. Вы киваете своим людям - мы идём по верному следу. | Вы находите остатки каравана на перекрёстке дорог. Телеги разломаны, лошади мертвы, а на одном из колёс висит тело человека, которого разорвали пополам. %randombrother% подходит к вам и молча показывает на отпечатки лап в грязи. Вы сжимаете рукоять меча. Мы близко. | Караван был разграблен, а затем сожжён. Вокруг валяются обгоревшие мешки с зерном, разбитые бочки и обрывки ткани. Вы проходите через это место и замечаете в стороне группу свежих следов. Скавены ушли в сторону от дороги, таща за собой тяжёлые тюки. Они не могли уйти далеко.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Мы, должно быть, близко.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BurnedFarmstead",
			Title = "По пути...",
			Text = "[img]gfx/ui/events/event_71.png[/img]{Вы подходите к фермерскому дому, от которого остались только обугленные стены. На пороге лежит тело - мужчина, сжимающий в руке вилы. Его глаза широко открыты, а на лице застыло выражение ужаса. Вы обходите развалины и видите следы: лапы, хвосты, когти. Скавены. Они прошли здесь не больше дня назад. Вы смотрите в сторону леса, куда ведут следы. | Ферма сожжена дотла. Вы находите тела хозяев в загоне для скота - они пытались спрятаться, но не успели. Рядом валяются несколько туш овец, обглоданных до костей. Ваши люди молча обыскивают окрестности и находят тропу, уходящую в чащу. Скавены обнаглели настолько, что даже не стали заметать следы - их путь ясен. | Вы входите во двор и видите только пепел и обугленные кости. На земле - множество следов. Скавены не торопились. Они прошлись по этому месту как по своей территории. Вы приказываете отряду выдвигаться - мы идём по их следу.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Мы, должно быть, близко.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "DeadBodiesRat",
			Title = "По пути...",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Вы выходите на поляну и останавливаетесь. Тела. Много тел. Их не просто убили - их разорвали на части. Конечности лежат отдельно, внутренности разбросаны по земле, а головы насажены на колья. Ваши люди отворачиваются, но вы смотрите на следы вокруг - те же отпечатки когтей, тот же запах сырой шерсти. Скавены прошли здесь. И они недалеко. | Вы находите группу тел на краю оврага. Они лежат вповалку, словно их сбросили сверху. Мужчины, женщины, дети - все перемешаны, все изуродованы. Вы видите следы укусов на костях. Это дело рук скавенов. Вы поднимаете взгляд и видите дым на горизонте - должно быть, там их лагерь. | Вы идёте по тропе и натыкаетесь на груду тел. Некоторые ещё не остыли. Скавены были здесь совсем недавно. Вы приказываете отряду приготовиться - мы догоним их до заката.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Похоже, мы охотимся на скавенов.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BattleWonRat",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/rat_event_09.png[/img]{Последний скавен падает, пронзённый копьём. Вы осматриваете поле боя - тела крыс лежат грудами, а ваши люди перевязывают раны и собирают трофеи. Вы устали, но в груди - чувство удовлетворения. Работа сделана. Пора возвращаться, %employer% ждёт. | Битва окончена. Скавены мертвы, а их лагерь разорён. Вы проходите через него, собирая всё, что может пригодиться, и приказываете отряду собираться. %employer% ждёт. | Вы вытираете клинок о шкуру мёртвого скавена и смотрите на своих людей. Они неспешно обходят поле боя в поисках чего-нибудь ценного. Вы киваете и поворачиваетесь в сторону поселения %townname%. Настало время получить плату.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Назад в %townname%!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Warlord",
			Title = "Перед атакой...",
			Text = "[img]gfx/ui/events/rat_event_10.png[/img]{Вы подходите к лагерю скавенов и понимаете, что всё сложнее, чем казалось. В центре стаи, на куче костей и хлама, сидит огромный скавен в рваном чёрном плаще. Его шерсть покрыта шрамами, а в руке он сжимает огромный тесак - ржавый и щербатый настолько, что даже неглубокий порез от него сулит смерть: если не от потери крови, то от заражения. Вожак замечает вас и поднимается, медленно, но угрожающе. Ваши люди сжимают оружие. Бой будет тяжёлым. | Скавены не просто стая - это армия. И у неё есть вождь. Вы видите его - чёрную фигуру, возвышающуюся над остальными. Он носит шлем, укреплённый варп-камнем, и его глаза светятся красным. Вы слышите, как %randombrother% тихо выдыхает:%SPEECH_ON%Боги, какой страшный.%SPEECH_OFF%Вы киваете. Это ничего не меняет. Скавены должны умереть.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "К оружию!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Merchant",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/rat_event_09.png[/img]{Битва стихает. Вы обходите поле, проверяя, не осталось ли живых скавенов, и вдруг слышите приглушённый голос. Из-под груды тел вылезает человек - грязный, в порванной одежде, но живой. Он отряхивается и оглядывается по сторонам, а потом бросается к вам.%SPEECH_ON%Слава богам, вы пришли! Я торговец, вёз товар в город %objective%, но эти твари напали на меня на рассвете. Они убили всех моих людей!%SPEECH_OFF%Он хватает вас за руку и смотрит в глаза.%SPEECH_ON%Мне нужно добраться до города. Я заплачу тебе %reward_merchant% крон, если ты проводишь меня. Скажи, что согласен!%SPEECH_OFF% | Вы находите человека, спрятавшегося в старой бочке. Он вылезает, дрожа всем телом, но когда видит ваше лицо, выдыхает с облегчением.%SPEECH_ON%Ты наёмник? Слава небесам! Я купец, направлялся в город %objective%, но скавены перебили мой караван. Я отсиживался здесь, пока не услышал звуки битвы.%SPEECH_OFF%Он протягивает кошель.%SPEECH_ON%Здесь только половина, но я обещаю: если ты доведёшь меня до города, я отдам %reward_merchant% крон. Скажи \'да\', и давай уже быстрее уйдём отсюда.%SPEECH_OFF% | Вы подходите к разбитой телеге и видите человека, который сидит на земле, обхватив голову руками. Он поднимает взгляд, и в его глазах - смесь страха и надежды.%SPEECH_ON%Вы убили их? Всех?%SPEECH_OFF%Вы киваете. Он встаёт и подходит ближе.%SPEECH_ON%Я купец из города %objective%. Я шёл с товаром, но скавены... они вышли из леса, как дьяволы. Я не знаю, как выжил. Но я жив, и мне нужно добраться до города. Я заплачу тебе %reward_merchant% крон, если ты проводишь меня. Скажи, что поможешь мне.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Хорошо, мы доставим тебя в %objective%.",
					function getResult()
					{
						this.Contract.setState("Running_Merchant");
						return 0;
					}

				},
				{
					Text = "Просто иди и не мешайся.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				if (this.Flags.get("IsRat"))
				{
					this.Text = "[img]gfx/ui/events/rat_event_09.png[/img]" + this.Text;
				}
				else
				{
					this.Text = "[img]gfx/ui/events/rat_event_08.png[/img]" + this.Text;
				}

				local merchant = this.Tactical.getEntityByID(this.Flags.get("MerchantID"));
				this.Characters.push(merchant.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Вы входите в комнату, где пахнет воском и сыростью, - %employer% сидит за столом. Вы бросаете ему на стол окровавленный хвост вожака. Он смотрит на него, потом на вас, потом снова на хвост.%SPEECH_ON%Это всё?%SPEECH_OFF%Вы киваете.%SPEECH_ON%Все мертвы. Ни один не ушёл.%SPEECH_OFF%Он медленно выдыхает и достаёт из-под стола тяжёлый кожаный мешок.%SPEECH_ON%Твоя плата. Я знаю, что ты сделал для моих людей. Это того стоит.%SPEECH_OFF%Вы забираете мешок и выходите. | %employer% сидит на крыльце, когда вы подходите. Он встаёт, вытирает руки о штаны и смотрит на вас.%SPEECH_ON%Ты убил этих тварей?%SPEECH_OFF%Вы киваете. Он хлопает вас по плечу и вручает увесистый кошель.%SPEECH_ON%Возьми. Ты заслужил. И если захочешь ещё работы, я всегда здесь.%SPEECH_OFF% | %employer% стоит у карты, висящей на стене. Когда вы входите, он оборачивается и улыбается - впервые за всё время.%SPEECH_ON%Я уже знаю. Мои люди видели, как ты шёл по полю со своими трофеями. Ты сделал невозможное, наёмник.%SPEECH_OFF%Он протягивает вам шкатулку, полную крон.%SPEECH_ON%Плата, как договаривались. Ты снял груз с моих плеч.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Удачная охота.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Избавился от мародерствующих скавенов");
						this.World.Contracts.finishActiveContract();
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
			ID = "Success2",
			Title = "В %objective%...",
			Text = "[img]gfx/ui/events/event_20.png[/img]{Вы входите в город %objective% вместе с купцом. Он выдыхает так, будто до этого не дышал несколько дней.%SPEECH_ON%Мы сделали это! Благослови тебя боги, наёмник.%SPEECH_OFF%Он передаёт вам туго набитый мешок с кронами.%SPEECH_ON%Как обещал. Всё до последней монеты. Я никогда не забуду твою помощь.%SPEECH_OFF%Вы забираете плату и смотрите, как купец исчезает в толпе. | Купец останавливается у ворот города %objective% и поворачивается к вам.%SPEECH_ON%Вот мы и на месте. Я не думал, что увижу этот город снова.%SPEECH_OFF%Он протягивает вам кошель.%SPEECH_ON%Держи. Ты заработал каждую крону. Если будешь в этих краях, заходи, я всегда найду для тебя работу.%SPEECH_OFF%Вы забираете плату и уходите. | Вы доходите до центра города %objective% вместе с купцом. Он останавливается на площади и снимает с пояса кошель.%SPEECH_ON%Спасибо, наёмник. Без тебя я бы не добрался. Возьми это - %reward_merchant% крон, как мы и договаривались.%SPEECH_OFF%Вы забираете плату и киваете ему. Он уходит, а вы остаётесь один на площади и пересчитываете монеты в наступившей тишине.}",
			Image = "",
			List = [],
			Characters = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Лёгкие деньги.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Flags.get("MerchantReward"));
						return 0;
					}

				}
			],
			function start()
			{
				local merchant = this.Tactical.getEntityByID(this.Flags.get("MerchantID"));
				this.Characters.push(merchant.getImagePath());
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы получаете [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Flags.get("MerchantReward") + "[/color] крон"
				});
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"objective",
			this.m.Objective != null ? this.m.Objective.getName() : ""
		]);
		_vars.push([
			"objectivedirection",
			this.m.Objective == null || this.m.Objective.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Objective.getTile())]
		]);
		_vars.push([
			"reward_merchant",
			this.m.Flags.get("MerchantReward")
		]);
	}

	function onOriginSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Origin.addSituation(this.new("scripts/entity/world/settlements/situations/rat_marauding_situation"));
		}
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

			if (this.m.Objective != null && !this.m.Objective.isNull())
			{
				this.m.Objective.getSprite("selection").Visible = false;
			}

			this.m.Origin.getSprite("selection").Visible = false;
			this.m.Home.getSprite("selection").Visible = false;
		}

		if (this.m.Origin != null && !this.m.Origin.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Origin.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(4);
			}
		}
	}

	function onIsValid()
	{
		if (this.m.Origin.getOwner().getID() != this.m.Faction)
		{
			return false;
		}

		return true;
	}

	function onIsTileUsed( _tile )
	{
		if (this.m.Objective != null && !this.m.Objective.isNull() && _tile.ID == this.m.Objective.getTile().ID)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		if (this.m.Target != null && !this.m.Target.isNull() && this.m.Target.isAlive())
		{
			_out.writeU32(this.m.Target.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		if (this.m.Objective != null && !this.m.Objective.isNull() && this.m.Objective.isAlive())
		{
			_out.writeU32(this.m.Objective.getID());
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

		local objective = _in.readU32();

		if (objective != 0)
		{
			this.m.Objective = this.WeakTableRef(this.World.getEntityByID(objective));
		}

		this.contract.onDeserialize(_in);
	}

});

