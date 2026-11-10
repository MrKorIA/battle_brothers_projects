this.hunting_wolfrat_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		Dude = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.hunting_wolfrat";
		this.m.Name = "Охота на волкокрысов";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
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
					"Выследить убийц в лесах около " + this.Contract.m.Home.getName()
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

				if (r <= 25)
				{
					this.Flags.set("IsGlade", true);
				}
				else if (r <= 30)
				{
					this.Flags.set("IsWoodcutter", true);
				}

				this.Flags.set("StartTime", this.Time.getVirtualTimeF());
				local disallowedTerrain = [];

				for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
				{
					if (i == this.Const.World.TerrainType.Forest || i == this.Const.World.TerrainType.LeaveForest || i == this.Const.World.TerrainType.AutumnForest)
					{
					}
					else
					{
						disallowedTerrain.push(i);
					}
				}

				local playerTile = this.World.State.getPlayer().getTile();
				local mapSize = this.World.getMapSize();
				local x = this.Math.max(3, playerTile.SquareCoords.X - 11);
				local x_max = this.Math.min(mapSize.X - 3, playerTile.SquareCoords.X + 11);
				local y = this.Math.max(3, playerTile.SquareCoords.Y - 11);
				local y_max = this.Math.min(mapSize.Y - 3, playerTile.SquareCoords.Y + 11);
				local numWoods = 0;

				while (x <= x_max)
				{
					while (y <= y_max)
					{
						local tile = this.World.getTileSquare(x, y);

						if (tile.Type == this.Const.World.TerrainType.Forest || tile.Type == this.Const.World.TerrainType.LeaveForest || tile.Type == this.Const.World.TerrainType.AutumnForest)
						{
							numWoods = ++numWoods;
						}

						y = ++y;
					}

					x = ++x;
				}

				local tile = this.Contract.getTileToSpawnLocation(playerTile, numWoods >= 12 ? 6 : 3, 11, disallowedTerrain);
				local party;
				party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.RatBeast).spawnEntity(tile, "Волкокрысы", false, this.Const.World.Spawn.WolfRat, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				party.setDescription("Стая снующих вокруг волкокрысов.");
				party.setFootprintType(this.Const.World.FootprintsType.Skavens);
				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);

				for( local i = 0; i < 2; i = ++i )
				{
					local nearTile = this.Contract.getTileToSpawnLocation(playerTile, 4, 7, disallowedTerrain);

					if (nearTile != null)
					{
						this.Const.World.Common.addFootprintsFromTo(nearTile, party.getTile(), this.Const.SkavenFootprints, this.Const.World.FootprintsType.Skavens, 0.75);
					}
				}

				this.Contract.m.Target = this.WeakTableRef(party);
				party.getSprite("banner").setBrush("banner_beasts_01");
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setPivot(this.Contract.m.Home);
				roam.setMinRange(5);
				roam.setMaxRange(10);
				roam.setNoTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Forest, true);
				roam.setTerrain(this.Const.World.TerrainType.SnowyForest, true);
				roam.setTerrain(this.Const.World.TerrainType.LeaveForest, true);
				roam.setTerrain(this.Const.World.TerrainType.AutumnForest, true);
				c.addOrder(roam);
				this.Contract.m.Home.setLastSpawnTimeToNow();
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
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || !this.Contract.m.Target.isAlive())
				{
					this.Contract.setScreen("Victory");
					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
				else if (!this.Flags.get("IsBanterShown") && this.Contract.m.Target.isHiddenToPlayer() && this.Math.rand(1, 1000) <= 1 && this.Flags.get("StartTime") + 10.0 <= this.Time.getVirtualTimeF())
				{
					local tileType = this.World.State.getPlayer().getTile().Type;

					if (tileType == this.Const.World.TerrainType.Forest || tileType == this.Const.World.TerrainType.LeaveForest || tileType == this.Const.World.TerrainType.AutumnForest)
					{
						this.Flags.set("IsBanterShown", true);
						this.Contract.setScreen("Banter");
						this.World.Contracts.showActiveContract();
					}
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (!this.Flags.get("IsEncounterShown"))
				{
					this.Flags.set("IsEncounterShown", true);
					this.Contract.setScreen("WolfRat");
					this.World.Contracts.showActiveContract();
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
					"Вернуться в " + this.Contract.m.Home.getName()
				];
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success");
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
			Text = "[img]gfx/ui/events/event_62.png[/img]{Вы стоите у доски объявлений в центре поселения %townname%, изучая обрывки бумаги с просьбами о помощи. %employer% подходит к вам сзади и негромко кашляет.%SPEECH_ON%Я вижу, ты изучаешь наши беды, наёмник. Позволь мне объяснить, что именно здесь происходит.%SPEECH_OFF%Он протягивает руку и снимает с доски самый старый листок.%SPEECH_ON%Три недели назад начали пропадать лесорубы. Сначала по одному, потом целыми группами. Кто-то находил их тела — разорванные, обглоданные. Очевидцы говорят о тварях, которые бегают на четырёх лапах и имеют пасти, полные игл.%SPEECH_OFF%Он сжимает листок в кулаке и смотрит на вас в упор.%SPEECH_ON%Мне нужно, чтобы ты пошёл в лес, нашёл этих тварей и уничтожил их. Я заплачу тебе за каждую голову. Ну что, идёт?%SPEECH_OFF% | %employer% сидит на бревне у въезда в город и точит нож о камень. Он поднимает взгляд, когда вы подходите.%SPEECH_ON%Ты слышал о том, что творится в лесу?%SPEECH_OFF%Вы качаете головой. Он усмехается и снова проводит ножом по камню.%SPEECH_ON%Люди пропадают. Лесорубы, охотники, даже один монах, который пошёл собирать травы. Находят только клочья одежды и кости. Мои люди говорят, что это волкокрысы — огромные, голодные, быстрые.%SPEECH_OFF%Он встаёт и прячет нож в ножны.%SPEECH_ON%Я хочу, чтобы ты пошёл в лес и истребил их. Всех. Я заплачу тебе столько, сколько попросишь. Ты согласен?%SPEECH_OFF% | Вы входите в комнату, когда %employer% стоит у карты и водит пальцем по лесистой местности вокруг поселения %townname%.%SPEECH_ON%Смотри сюда. Вот здесь, на северо-востоке, густой лес. Там всегда было тихо. Но последние две недели оттуда доносятся странные звуки, не похожие ни на что. Люди говорят о тварях, которые бегают быстрее волков и кусают так, что отрывают конечности.%SPEECH_OFF%Он поворачивается к вам, и его лицо бледно.%SPEECH_ON%Я не знаю, что это за твари. Но я знаю, что они убивают моих людей. Иди туда, наёмник. Найди их логово и уничтожь их. Я заплачу тебе.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Давай поговорим о плате. | Давай поговорим о монетах. | Это тебе дорого обойдётся. | Бешеная погоня по лесу, значит? Я с вами. | %companyname% может помочь, за соответствующую цену.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Это не похоже на нашу работу. | Я так не думаю. | Я говорю нет. Люди предпочитают известных врагов из плоти и крови.}",
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
			ID = "Banter",
			Title = "По пути...",
			Text = "[img]gfx/ui/events/event_25.png[/img]{Ваши люди идут по лесу, и напряжение висит в воздухе, как туман. Каждый хруст ветки — и чья-то рука тянется к оружию. Один из новичков слышит шорох в кустах, выхватывает меч и чуть не рубит товарища — а в кустах всего лишь заяц.%SPEECH_ON%Боги, я думал, это та самая тварь!%SPEECH_OFF%Кто-то нервно усмехается, но смех быстро затихает. Лес давит на психику. Вы и сами чувствуете, как по спине пробегает холодок. Они близко. Вы знаете это по тишине. Лес затих. И звери, и птицы — всё замолчало.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Смотри, куда ступаешь.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "WolfRat",
			Title = "По мере приближения...",
			Text = "[img]gfx/ui/events/rat_event_05.png[/img]{Вы выходите на поляну и замираете. В центре, у старого поваленного дуба, лежат туши оленей — разорванные, обглоданные. Вокруг них, принюхиваясь к земле, кружат твари. Волкокрысы. Их много — длинные, тощие, с серо-зелёной шерстью и пастями, полными игольчатых зубов. Они не замечают вас — пока вы не наступаете на сухую ветку. Хруст разносится по поляне, и все головы разом поворачиваются на звук. Десятки красных глаз смотрят на вас — прищуренные, изучающие. Кто-то из ваших людей сглатывает. Медленно вытаскивая меч, вы отдаёте команду.%SPEECH_ON%Всем приготовиться!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Вперёд!",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Victory",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/rat_event_06.png[/img]{Поляна усеяна телами. Последний волкокрыс падает, пронзённый копьём. Вы обходите поляну, проверяя, не осталось ли кого-то живого. Тела тварей лежат грудами, некоторые ещё дёргаются в предсмертных конвульсиях. Вы вытираете клинок о траву и приказываете отряду собрать трофеи. Волкокрысы мертвы. Лес снова принадлежит людям. Пора возвращаться — %employer% ждёт вас. | Битва окончена. Ваши люди молча перевязывают раны и собирают то, что можно продать. Вы стоите над телом вожака стаи — он был самым крупным, с чёрной шерстью и шрамом через всю морду. Вы отрубаете ему голову и бросаете её в мешок. %employer% будет доволен. | На поляне повисает тишина. Вы проходите по ней и считаете тела. Среди них — несколько крупных самцов, остальные — помельче. Это была целая стая. Вы приказываете отряду поджечь их тела, чтобы запах смерти отпугнул других хищников. Пламя взметается вверх, и вы чувствуете, как усталость отпускает вас. Работа выполнена.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Дело сделано.",
					function getResult()
					{
						if (this.Flags.get("IsGlade") && this.World.Assets.getStash().hasEmptySlot())
						{
							return "Glade";
						}
						else if (this.Flags.get("IsWoodcutter") && this.World.Assets.getStash().hasEmptySlot())
						{
							return "DeadWoodcutter";
						}
						else
						{
							return 0;
						}
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Glade",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/rat_event_06.png[/img]{Вы проходите вглубь поляны и замечаете небольшую пещеру под корнями старого дуба. Внутри — куча костей и веток, а среди них, в углублении, лежат странные зелёные кристаллы. Вы поднимаете один из них и чувствуете странное тепло. Варп-камень. Маленький, но настоящий. Вы прячете его в мешок и находите ещё несколько. Ваши люди смотрят с любопытством, но вы, не объясняя ничего, просто приказываете идти дальше. Это добро пригодится. | Блеск в траве привлекает ваше внимание, и вы подходите ближе. В гнезде волкокрысов, среди грязи и костей, лежит несколько зелёных осколков. Подняв их к свету, вы видите, как они слабо пульсируют. Что это — вы не знаете, но чувствуете: эти камни стоят целое состояние. Спрятав находку в карман, вы делаете вид, что ничего не случилось.}",
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
			],
			function start()
			{
				local item = this.new("scripts/items/loot/rat_fragment_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Вы получаете " + item.getName()
				});
				item = this.new("scripts/items/loot/rat_fragment_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Вы получаете " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "DeadWoodcutter",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/rat_event_06.png[/img]{Вы замечаете в кустах что-то металлическое. Подходите ближе и видите старый топор, воткнутый в ствол дерева. Рядом — рваная одежда, обглоданные кости и остатки обуви. Похоже, это был лесоруб, который не успел убежать. Вы выдёргиваете топор из дерева — тяжёлый, с лезвием в хорошем состоянии. Что ж, его можно взять с собой — ещё послужит. | Вы находите тело лесоруба у корней старой сосны — он лежит на спине, лицо искажено предсмертным криком, а в руке зажат топор. Наклонившись, вы забираете оружие: оно хорошее, крепкое. Такой топор не должен ржаветь на трупе — он отправится с вами.}",
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
			],
			function start()
			{
				local item;
				local r = this.Math.rand(1, 4);

				if (r == 1)
				{
					item = this.new("scripts/items/weapons/woodcutters_axe");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/weapons/hand_axe");
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/weapons/fighting_axe");
				}
				else if (r == 4)
				{
					item = this.new("scripts/items/weapons/greataxe");
				}

				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Вы получаете " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Success",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_62.png[/img]{Кабинет нанимателя тесен и завален бумагами. Вы входите и бросаете на пол голову вожака волкокрысов. Она катится по доскам и останавливается у его ног. Он смотрит на неё, потом на вас, потом снова на неё.%SPEECH_ON%Так вот как они выглядели. Уродливые твари.%SPEECH_OFF%Он поднимает голову за шкирку и рассматривает её под светом лампы.%SPEECH_ON%Огромные зубы. Сильные челюсти. Я не удивлён, что они убили так много людей.%SPEECH_OFF%Он отбрасывает голову в сторону и протягивает вам кошель с кронами.%SPEECH_ON%Твоя плата. Ты сделал то, о чём я просил. Лес снова безопасен. Спасибо, наёмник.%SPEECH_OFF% | %employer% сидит на крыльце. Когда вы подходите, он встаёт и смотрит на вас с надеждой.%SPEECH_ON%Ты нашёл их?%SPEECH_OFF%Вы киваете и бросаете перед ним окровавленный хвост. Он смотрит на хвост с минуту, потом выдыхает.%SPEECH_ON%Хорошо. Хорошо. Я не спал уже три ночи, думая о том, что эти твари могут прийти в наше поселение. Теперь я смогу уснуть спокойно.%SPEECH_OFF%Он протягивает вам мешок с платой.%SPEECH_ON%Бери. Ты заслужил каждую крону.%SPEECH_OFF% | Вы наконец нашли его: %employer% был в конюшне вместе с молодой крестьянкой. Он выскакивает из-за стога сена, так напугав лошадей, что те начинают ржать и вставать на дыбы. Полуодетый, он заявляет, что ваше вознаграждение при нём и сейчас он отдаст его. Переводя взгляд то на вас, то на девушку, он хватает всё, что плохо лежит, включая и содержимое ближайших седельных сумок, а затем передаёт все собранные ценности вам.%SPEECH_ON%Это... от горожан! Они тоже захотели принять участие. Хотели отблагодарить тебя. Вот.%SPEECH_OFF%Ну да. Вы предлагаете ему в следующий раз попробовать почерпнуть благодарность из его собственного кошелька.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Избавил город от волкокрысов");
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
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"direction",
			this.m.Target == null || this.m.Target.isNull() ? "" : this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Target.getTile())]
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/wolfrat_attacks_situation"));
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Target != null && !this.m.Target.isNull())
			{
				this.m.Target.setAttackableByAI(true);
				this.m.Target.getSprite("selection").Visible = false;
				this.m.Target.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}

		if (this.m.Home != null && !this.m.Home.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Home.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(3);
			}
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

