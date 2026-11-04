this.rat_warlord_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Threat = null,
		LastHelpTime = 0.0,
		IsPlayerAttacking = false,
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

		this.m.Type = "contract.rat_warlord";
		this.m.Name = "Вождь скавенов";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 5.0;
		this.m.MakeAllSpawnsAttackableByAIOnceDiscovered = true;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
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
					"Выследить вождя скавенов и его банду",
					"Последний раз его видели в регионе %region%, к %direction% от вас"
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
				local f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Rat);
				local nearest_base = f.getNearestSettlement(this.World.State.getPlayer().getTile());
				local party = f.spawnEntity(nearest_base.getTile(), "Вождь скавенов", false, this.Const.World.Spawn.RatRaiders, 125 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				party.setDescription("Легендарный и всеми почитаемый вождь скавенов, также известный как \'Повелитель Города Столпов\' и \'Великий Вождь Клана Морс\'.");
				party.getSprite("body").setBrush("figure_rat_08");
				party.setVisibilityMult(2.0);
				party.setFootprintType(this.Const.World.FootprintsType.Skavens);
				this.Contract.addUnitsToEntity(party, this.Const.World.Spawn.RatLord, 100);
				this.Contract.m.Destination = this.WeakTableRef(party);
				party.getLoot().Money = this.Math.rand(150, 250);
				party.getLoot().ArmorParts = this.Math.rand(10, 30);
				party.getLoot().Medicine = this.Math.rand(3, 6);
				party.getLoot().Ammo = this.Math.rand(10, 30);
				party.addToInventory("supplies/rat_meat_item");
				party.addToInventory("supplies/rat_soup_item");
				party.addToInventory("supplies/rat_soup_item");
				party.getSprite("banner").setBrush(nearest_base.getBanner());
				party.setAttackableByAI(false);
				local c = party.getController();
				local patrol = this.new("scripts/ai/world/orders/patrol_order");
				patrol.setWaitTime(20.0);
				c.addOrder(patrol);
				this.Contract.m.UnitsSpawned.push(party.getID());
				this.Contract.m.LastHelpTime = this.Time.getVirtualTimeF() + this.Math.rand(10, 40);
				this.Flags.set("HelpReceived", 0);
				local r = this.Math.rand(1, 100);

				if (r <= 15)
				{
					this.Flags.set("IsAGreaterThreat", true);
					c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				}

				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.BulletpointsObjectives.clear();
				this.Contract.m.BulletpointsObjectives = [
					"Выследить вождя скавенов и его банду",
					"Его банду последний раз видели в районе %region%, %terrain% к %direction% от вас, недалеко от %nearest_town%"
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onCombatWithKing.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					this.Contract.setState("Return");
				}
				else if (!this.Contract.isPlayerNear(this.Contract.m.Destination, 600) && this.Flags.get("HelpReceived") < 4 && this.Time.getVirtualTimeF() >= this.Contract.m.LastHelpTime + 70.0)
				{
					this.Contract.m.LastHelpTime = this.Time.getVirtualTimeF() + this.Math.rand(0, 30);
					this.Contract.setScreen("Directions");
					this.World.Contracts.showActiveContract();
				}
				else if (!this.Contract.isPlayerNear(this.Contract.m.Destination, 600) && this.Flags.get("HelpReceived") == 4)
				{
					this.Contract.setScreen("GiveUp");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatWithKing( _dest, _isPlayerAttacking = true )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;

				if (!_dest.isInCombat() && !this.Flags.get("IsKingEncountered"))
				{
					this.Flags.set("IsKingEncountered", true);

					if (this.Flags.get("IsAGreaterThreat"))
					{
						this.Contract.setScreen("AGreaterThreat1");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("Approach");
						this.World.Contracts.showActiveContract();
					}
				}
				else
				{
					this.Flags.set("IsAGreaterThreat", false);
					_dest.getController().getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(true);
					local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					properties.Music = this.Const.Music.RatTracks;
					this.World.Contracts.startScriptedCombat(properties, this.Contract.m.IsPlayerAttacking, true, true);
				}
			}

		});
		this.m.States.push({
			ID = "Running_GreaterThreat",
			function start()
			{
				this.Contract.m.BulletpointsObjectives.clear();
				this.Contract.m.BulletpointsObjectives = [
					"Отправиться с вождём скавенов, чтобы вместе встретить большую угрозу"
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.setFaction(2);
					this.World.State.setEscortedEntity(this.Contract.m.Destination);
				}
			}

			function update()
			{
				if (this.Flags.get("IsContractFailed"))
				{
					if (this.Contract.m.Threat != null && !this.Contract.m.Threat.isNull())
					{
						this.Contract.m.Threat.getController().clearOrders();
					}

					if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
					{
						this.Contract.m.Destination.getController().clearOrders();
						this.Contract.m.Destination.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Rat).getID());
					}

					this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
					this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Отряд разорвал контракт");
					this.World.Contracts.finishActiveContract(true);
					return;
				}

				if (this.Contract.m.Threat == null || this.Contract.m.Threat.isNull() || !this.Contract.m.Threat.isAlive())
				{
					this.Contract.setScreen("AGreaterThreat5");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					if (!this.Contract.m.IsEscortUpdated)
					{
						this.World.State.setEscortedEntity(this.Contract.m.Destination);
						this.Contract.m.IsEscortUpdated = true;
					}

					this.World.State.setCampingAllowed(false);
					this.World.State.getPlayer().setPos(this.Contract.m.Destination.getPos());
					this.World.State.getPlayer().setVisible(false);
					this.World.Assets.setUseProvisions(false);
					this.World.getCamera().moveTo(this.World.State.getPlayer());

					if (!this.World.State.isPaused())
					{
						this.World.setSpeedMult(this.Const.World.SpeedSettings.FastMult);
					}

					this.World.State.m.LastWorldSpeedMult = this.Const.World.SpeedSettings.FastMult;
				}

				if (this.Contract.isPlayerAt(this.Contract.m.Threat))
				{
					this.Contract.setScreen("AGreaterThreat4");
					this.World.Contracts.showActiveContract();
				}
			}

			function end()
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
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.Flags.set("IsContractFailed", true);
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
					if (this.Flags.get("IsAGreaterThreat"))
					{
						this.Contract.setScreen("Success2");
					}
					else
					{
						this.Contract.setScreen("Success1");
					}

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
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer% сидит в кресле, положив ноги на стол. На коленях у него лежит карта, вся в пометках и жирных пятнах. Он поднимает на вас тяжёлый взгляд.%SPEECH_ON%Ты знаешь, что такое страх, наёмник? Настоящий, когда не знаешь, увидишь ли ты рассвет?%SPEECH_OFF%Он не ждёт ответа, просто тычет пальцем в карту.%SPEECH_ON%Вот здесь, в регионе %region%, что находится к %direction% от нас, объявился скавен, который называет себя \'Повелителем Города Тысячи Столпов\'. Глупое имя, да? Но он не глуп. Он собрал под свои знамёна целую армию - клан Морс, элитных штурмокрыс и всё, что ползает и грызёт. Если мы не остановим его сейчас, через месяц он будет стоять у наших ворот.%SPEECH_OFF%Он откидывается на спинку кресла и смотрит вам в глаза.%SPEECH_ON%Я плачу тебе не за то, чтобы ты прогнал его. Я заплачу тебе за то, чтобы ты отрубил ему башку и принёс мне. Желательно в мешке, но я не привередлив. Ты справишься?%SPEECH_OFF% | %employer% стоит у стены, на которой висит огромный череп какого-то зверя. Он гладит его, как любимую собаку.%SPEECH_ON%Этот череп - мой талисман. Он напоминает мне, что даже самые страшные твари смертны. И скавен, который собрал свою армию в регионе %region%, что находится к %direction% от нас, - не исключение.%SPEECH_OFF%Он резко поворачивается к вам.%SPEECH_ON%Мне нужен его череп, наёмник. Чтобы повесить рядом с этим. И нужна твоя сталь. Сколько возьмёшь за то, чтобы пройти сквозь его элиту и повалить вождя в землю?%SPEECH_OFF% | %employer% сидит за столом, заваленным донесениями. Он читает одно из них, потом сминает и бросает в угол.%SPEECH_ON%Три деревни за неделю. Скавены не просто грабят - они методично вырезают всё живое, чтобы заселить эти земли своими выводками. И во главе этой чумы - крыс, называющий себя \'Повелителем Города Тысячи Столпов\'. Он объединил кланы под своей лапой.%SPEECH_OFF%Он пододвигает к вам карту с отмеченным маршрутом.%SPEECH_ON%Он где-то в регионе %region%, что находится к %direction% отсюда. Найди его, убей и развей его войско, как дым. Я заплачу тебе столько, сколько не платил ещё никому.%SPEECH_OFF% | В комнате пахнет сыростью и старым пергаментом. %employer% смотрит в окно, хотя за ним уже давно ночь.%SPEECH_ON%Говорят, этот скавен - не просто вожак: он носит на себе куски варп-камня, и даже его собственная гвардия боится к нему приближаться. Он пришёл издалека в регион %region% и теперь сидит там и замышляет свои мерзкие планы.%SPEECH_OFF%Он оборачивается, и в его глазах - сталь.%SPEECH_ON%Я хочу, чтобы ты нашёл его. И закончил то, что не смогли сделать армии трёх баронов.%SPEECH_OFF% | %employer% стоит посреди комнаты, раскинув руки, словно обнимает невидимую толпу.%SPEECH_ON%Представь: тысячи скавенов, штурмокрысы в доспехах, инженеры с огневыми пушками, а над ними - он. \'Повелитель Города Тысячи Столпов\'. Он уже подчинил себе все мелкие кланы в регионе %region%. И теперь его взгляд обращён на нас.%SPEECH_OFF%Он опускает руки и указывает на вас.%SPEECH_ON%Но у него есть слабость. Он верит в свою непобедимость. Покажи ему, что он ошибается. Иди в регион %region%, что находится к %direction% отсюда, и принеси мне его голову. Я заплачу столько, что твои внуки будут пить за моё здоровье.%SPEECH_OFF% | %employer% сидит на полу, раскинув перед собой карты. Он похож на ребёнка, который играет в войну, но глаза у него - взрослые и тяжёлые.%SPEECH_ON%Я проигрывал в стратегии всю свою жизнь, наёмник. Но я выигрывал в том, чтобы нанимать нужных людей.%SPEECH_OFF%Он поднимает на вас взгляд.%SPEECH_ON%Скавен, который называет себя \'Повелителем Города Тысячи Столпов\', - он угроза не только моим землям, но и всем землям вокруг. Он собирает армию в регионе %region%, что находится к %direction% от нас. Ты должен остановить его. Я не прошу тебя убивать каждого крыса в том краю - я прошу тебя срубить голову вожаку.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{О какой сумме мы говорим? | Это непростая задача. | Меня можно убедить за соответствующую цену. | За такое задание надо хорошо платить.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Мы не собираемся сражаться с армией. | Это не та работа, которую мы ищем. | Я не буду рисковать отрядом в бою с таким врагом.}",
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
			ID = "Directions",
			Title = "По пути...",
			Text = "{[img]gfx/ui/events/event_59.png[/img]Толпа беженцев проходит мимо отряда. Они несут на спинах детей и узлы с пожитками, лица их серы от страха. Один из стариков останавливается и хватает вас за рукав.%SPEECH_ON%Ты идёшь туда, к %direction% отсюда? Там скавены. Много. Их вожак - огромный, ростом с человека, с красными глазами. Говорят, он ест своих же, для острастки. Он где-то в землях %region%, за местностью %terrain%. Если у тебя есть боги - молись им, наёмник.%SPEECH_OFF%Старик уходит, и его слова повисают в воздухе. | [img]gfx/ui/events/event_41.png[/img]У дороги стоит торговец с пустой телегой. На вопрос, почему он без товара, тот сплёвывает на землю.%SPEECH_ON%Раньше там, к %direction% от нас, был рынок. Теперь там только запах шерсти и крови. Скавены пришли из земель %region%, - их вожак, этот проклятый \'Повелителем Города Тысячи Столпов\', сжёг всё, что не мог утащить.%SPEECH_OFF%Он качает головой.%SPEECH_ON%Я бы не советовал тебе туда соваться, но вижу по твоим людям - ты идёшь именно туда. Хочешь совет? Держись открытых мест. В норах их не одолеть.%SPEECH_OFF% | [img]gfx/ui/events/event_94.png[/img]У дороги сидит человек - голый по пояс, весь в грязи и ссадинах. Он поднимает на вас мутный взгляд.%SPEECH_ON%Они пришли ночью. Вылезли из земли, как черви. Я спрятался в навозной куче, дышал через тряпку. Слышал, как они говорили о своём вожаке - тот ждёт их в землях %region%, к %direction% отселе. Он собирает армию. Идёшь туда - так убей вожака.%SPEECH_OFF%Вы киваете и даёте ему флягу. Он жадно пьёт и бормочет слова благодарности.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Мы идём по его следу.",
					function getResult()
					{
						this.Flags.increment("HelpReceived", 1);
						this.Contract.getActiveState().start();
						this.World.Contracts.updateActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "GiveUp",
			Title = "По пути...",
			Text = "[img]gfx/ui/events/event_45.png[/img]{Вы стоите на холме и смотрите на следы, которые ведут в долину. Беженцы, торговцы, крестьяне - все они говорили одно и то же. Скавен-Повелитель действительно в землях %region%, к %direction% отсюда. Его армия набирает нешуточную силу. Вы чувствуете тяжесть в груди - не страх, а предчувствие. Остался последний шаг: найти его и встретиться с ним лицом к морде.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Нам нужно поторопиться.",
					function getResult()
					{
						this.Flags.increment("HelpReceived", 1);
						this.Contract.m.Destination.setVisibleInFogOfWar(true);
						this.World.getCamera().moveTo(this.Contract.m.Destination);
						this.Contract.getActiveState().start();
						this.World.Contracts.updateActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Approach",
			Title = "По мере приближения...",
			Text = "[img]gfx/ui/events/rat_event_07.png[/img]{Вы выходите на равнину, и сердце пропускает удар. Внизу, у подножия холма, стоит армия. Десятки скавенов. Штурмокрысы с огромными щитами и копьями выстроены в плотные ряды. Между ними снуют крысы клана с кинжалами и ржавыми мечами. А в центре - он. \'Повелитель Города Тысячи Столпов\'. Сгорбленный, покрытый шрамами, в доспехе из варп-камня, с двумя клинками в лапах. Он замечает вас и издаёт низкий, вибрирующий писк. Армия оживает. К битве готовятся с обеих сторон.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "К оружию!",
					function getResult()
					{
						this.Contract.getActiveState().onCombatWithKing(this.Contract.m.Destination, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Victory",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/rat_event_08.png[/img]{Битва стихает. Последний штурмокрыс падает, пронзённый клинками ваших людей. Вы идёте сквозь груды серых тел, пока не находите его. Повелитель лежит на спине, глаза его открыты, но в них уже нет жизни. Вы опускаетесь на одно колено и отсекаете ему голову - это занимает два удара, потому что шкура на загривке задубела от наростов варп-камня, - и поднимаете трофей за шерсть на загривке. %randombrother% подходит и протягивает мешок.%SPEECH_ON%Вот теперь он точно никому не навредит.%SPEECH_OFF%Вы киваете и приказываете собирать трофеи. Пора возвращаться.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{Отряд \'%companyname%\' победил! | Победа!}",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.setState("Return");
			}

		});
		this.m.Screens.push({
			ID = "AGreaterThreat1",
			Title = "По мере приближения...",
			Text = "[img]gfx/ui/events/rat_event_14.png[/img]{Вы выходите к лагерю скавенов, но вместо битвы получаете неожиданную встречу. Повелитель выходит из рядов крыс, и рядом с ним стоит серый провидец - горбатое, морщинистое существо с посохом, увенчанным варп-камнем. Провидец поднимает лапу и говорит писклявым голосом:%SPEECH_ON%Мы не враги-недруги тебе, наёмник. Нет-нет! Настоящий враг - тот, кто грядёт, ползёт с запада! Огромный, страшный чёрный орк-вожак ведёт свою зелёную орду-стаю! Безумные зеленокожие! Если мы будем грызться, драться друг с другом - мы оба умрём, сдохнем-сдохнем! Пустая трата ценных жизней! Но если мы объединимся... да-да, заключим хитрый-умный пакт! Если сплотим наши силы - мы выживем, победим-победим!%SPEECH_OFF%Вы смотрите на \'Повелителя Города Тысячи Столпов\'. Он не шевелится, только смотрит на вас красными глазами. %randombrother% подходит ближе и шепчет:%SPEECH_ON%Они не врут про орков, командир. Мы видели следы на подходе. Но верить скавену? Это как доверить кошелёк вору.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Мы нападём на них и избавимся от Повелителя Города Столпов.",
					function getResult()
					{
						return "AGreaterThreat2";
					}

				},
				{
					Text = "Мы присоединимся к ним, чтобы выступить против вождя чёрных орков.",
					function getResult()
					{
						return "AGreaterThreat3";
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "AGreaterThreat2",
			Title = "По мере приближения...",
			Text = "[img]gfx/ui/events/rat_event_14.png[/img]{Вы смотрите на провидца и качаете головой.%SPEECH_ON%Я видел, что вы сделали с деревнями по пути сюда. Вы резали женщин и детей. Вы не союзники, вы - чума. И я пришёл не договариваться.%SPEECH_OFF%Провидец переводит ваши слова Повелителю. Тот медленно опускает лапу на рукоять тесака. Глаза его сужаются. Он пищит что-то на своём языке, и провидец кивает.%SPEECH_ON%Тогда умри, сдохни как глупый человек-мужчина, наёмник-тварь! Твоя гордость - твоя смерть, да-да! Без союза с нами, без нашей великой крысиной помощи ты не сможешь остановить никого из нас! Мы - орда, мы - подземное воинство! Ты захлебнёшься в нашей крови-плоти, захлебнёшься-утонешь!%SPEECH_OFF%Вы вытаскиваете меч и делаете шаг вперёд.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Готовьтесь к битве.",
					function getResult()
					{
						this.Flags.set("IsAGreaterThreat", false);
						this.Contract.getActiveState().onCombatWithKing(this.Contract.m.Destination, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "AGreaterThreat3",
			Title = "[img]gfx/ui/events/rat_event_14.png[/img]{Вы смотрите на провидца и медленно киваете.%SPEECH_ON%Хорошо. Мы идём с вами против орков. Но если вы предадите нас - я лично отделю голову вашего вождя от тела.%SPEECH_OFF%Провидец переводит. Повелитель молчит, потом протягивает вам один из своих клинков рукоятью вперёд - жест, который у людей означает доверие. Вы берёте его за рукоять и возвращаете. Повелитель коротко кивает. Так начинается странный союз, от которого у вас мурашки бегут по спине.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Приготовьтесь к походу.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				local playerTile = this.World.State.getPlayer().getTile();
				local nearest_orc = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getNearestSettlement(playerTile);
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 9, 15);
				local party = this.World.FactionManager.getFaction(nearest_orc.getFaction()).spawnEntity(tile, "Вожак Черных Орков", false, this.Const.World.Spawn.OrcRaiders, 260 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				party.getSprite("banner").setBrush(nearest_orc.getBanner());
				party.setDescription("Орда зеленокожих орков, возвышающихся над любым человеком на целую голову");
				party.setSlowerAtNight(false);
				party.setUsingGlobalVision(false);
				party.setLooting(false);
				this.Contract.m.UnitsSpawned.push(party);
				this.Contract.m.Threat = this.WeakTableRef(party);
				party.setAttackableByAI(false);
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local wait = this.new("scripts/ai/world/orders/wait_order");
				wait.setTime(99999);
				c.addOrder(wait);
				this.Contract.m.Destination.setFaction(2);
				this.Contract.m.Destination.getSprite("selection").Visible = false;
				this.Contract.m.Destination.setOnCombatWithPlayerCallback(null);
				c = this.Contract.m.Destination.getController();
				c.clearOrders();
				local move = this.new("scripts/ai/world/orders/move_order");
				move.setDestination(party.getTile());
				c.addOrder(move);
				this.Contract.setState("Running_GreaterThreat");
			}

		});
		this.m.Screens.push({
			ID = "AGreaterThreat4",
			Title = "По мере приближения...",
			Text = "[img]gfx/ui/events/event_93.png[/img]{Вы выходите на гребень холма и сжимаете рукоять меча. Внизу, в широкой долине, стоит большой отряд орков. Их много десятков. Чёрный орк-вожак, огромный, как гора мышц, сидит на троне из черепов и наблюдает за вашими движениями. Рядом с вами стоит Повелитель. Он смотрит на орка и пищит - низко и раскатисто. Провидец переводит:%SPEECH_ON%Великий Повелитель говорит, да-да: сегодня мы либо умрём как великие крысы-герои, либо все станем сочным кормом для подземных червей-личинок! Хозяин рад-доволен, что ты с ним, наёмник-человек!%SPEECH_OFF%Вы киваете. Сзади раздаётся боевой клич ваших людей.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Готовьтесь к битве.",
					function getResult()
					{
						this.World.Contracts.showCombatDialog(false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "AGreaterThreat5",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/rat_event_14.png[/img]{Поле битвы усеяно телами орков. Ваши люди перевязывают раны, скавены собирают трофеи. Повелитель стоит над телом чёрного орка, его клинок всё ещё торчит из груди врага. Провидец подходит к вам и кладёт свою лапу на плечо.%SPEECH_ON%Он говорит, шипит, что запомнит тебя, наёмник-человек. Да-да! Запомнит надолго! Не как глупого врага-недруга, нет-нет! А как того, с кем он стоял бок о бок, плечом к плечу, проливая кровь-жидкость в жестоком бою! Это... нечто большее, чем просто союз ради выгоды, да-да! Это - крысиное уважение, великое, честное уважение-признание!%SPEECH_OFF%Повелитель отворачивается и уходит в сторону леса. Его отряд собирается и уходит следом. Провидец протягивает вам доспех - он сделан из странного металла, укреплён варп-камнем и украшен костяными пластинами.%SPEECH_ON%Это не подарок, нет-нет! Мы не дарим подарки кому попало! Это - знак, великий-важный символ! Ты заслужил его, вырвал зубами-когтями в бою! Носи его, да-да! А теперь уходи-убирайся... Прощай, наёмник-человек!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Прощай, Повелитель Города Столпов.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			],
			function start()
			{
				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull() && this.Contract.m.Destination.isAlive())
				{
					this.Contract.m.Destination.die();
					this.Contract.m.Destination = null;
				}

				local item = this.new("scripts/items/armor/warp_shard_armor_05");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Вы получаете " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_31.png[/img]{%employer% сидит за столом, заваленным свечными огарками - судя по всему, не спал всю ночь. Вы входите и с глухим стуком опускаете мешок ему на стол. Он развязывает его, заглядывает внутрь и отшатывается, но на лице его появляется кривая усмешка.%SPEECH_ON%Боги, какой урод. Я думал, они все такие, но этот... он даже в смерти выглядит злым.%SPEECH_OFF%Он закрывает мешок и пододвигает к вам шкатулку.%SPEECH_ON%Плата, как договаривались. Ты сделал больше, чем я мог просить. Ты дал моим людям надежду. А надежда, наёмник, стоит дороже любых крон.%SPEECH_OFF%Вы забираете шкатулку и на пробу встряхиваете её, вслушиваясь в звон монет. Надежда надеждой, а крон в дороге ещё никогда не бывало слишком много. | %employer% стоит спиной к вам, глядя в окно. Когда вы входите, он медленно поворачивается.%SPEECH_ON%Я слышал слухи. Слышал, что говорят крестьяне и путешественники из тех мест. Ты сделал это, наёмник.%SPEECH_OFF%Он смотрит на мешок, который вы кладёте на пол, и кивает.%SPEECH_ON%Убери эту гадость с моих глаз. Плата - на столе. Возьми её и уходи, пока я не передумал.%SPEECH_OFF%Вы забираете деньги и выходите. На улице ветер, и он впервые за много дней пахнет не чумной шерстью, а просто свежестью. | %employer% сидит за столом и что-то пишет. Когда вы кладёте мешок с головой на угол стола, он не поднимает глаз.%SPEECH_ON%Я слышал, как ты прошёл через их строй. Говорят, ты дрался как одержимый.%SPEECH_OFF%Он ставит последнюю точку и поднимает взгляд.%SPEECH_ON%Это именно то, что мне нужно. Ты заслужил каждую крону.%SPEECH_OFF%Он выдвигает ящик и достаёт кошель, который бросает вам в руки. Вы ловите его на лету и без слов выходите на улицу.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Заслужено.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Убит Вожак Города Столпов");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				local money = this.Contract.m.Payment.getOnCompletion();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы получаете [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] крон"
				});

				local item = this.new("scripts/items/helmets/warp_shard_helmet");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Вы получаете " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_31.png[/img]{В кабинете догорает единственная свеча. %employer% ждёт вашего доклада, и по его лицу сразу видно - врать ему не имеет смысла.%SPEECH_ON%Скавен жив, но он ушёл за пределы твоих земель, и его армия больше вам не угрожает.%SPEECH_OFF%%employer% хмурится, потом медленно кивает.%SPEECH_ON%Ты пришёл без трофея, но с вестью, которая стоит не меньше. Я не могу повесить его голову на стену, но я могу спокойно спать по ночам. Плата, как и обещал. Ты выполнил свою работу, даже если сделал это не так, как я ожидал.%SPEECH_OFF%Вы забираете кошель и выходите.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Заслужено.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Устранена угроза от Вожака Города Столпов");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				local money = this.Contract.m.Payment.getOnCompletion();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы получаете [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] крон"
				});
				local item = this.new("scripts/items/helmets/warp_shard_helmet");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Вы получаете " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		if (this.m.Destination != null && !this.m.Destination.isNull() && this.m.Destination.isAlive())
		{
			local distance = this.World.State.getPlayer().getTile().getDistanceTo(this.m.Destination.getTile());
			distance = this.Const.Strings.Distance[this.Math.min(this.Const.Strings.Distance.len() - 1, distance / 30.0 * (this.Const.Strings.Distance.len() - 1))];
			local region = this.World.State.getRegion(this.m.Destination.getTile().Region);
			local settlements = this.World.EntityManager.getSettlements();
			local nearest;
			local nearest_dist = 9999;

			foreach( s in settlements )
			{
				local d = s.getTile().getDistanceTo(this.m.Destination.getTile());

				if (d < nearest_dist)
				{
					nearest = s;
					nearest_dist = d;
				}
			}

			_vars.push([
				"region",
				region.Name
			]);
			_vars.push([
				"nearest_town",
				nearest.getName()
			]);
			_vars.push([
				"distance",
				distance
			]);
			_vars.push([
				"direction",
				this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Destination.getTile())]
			]);
			_vars.push([
				"terrain",
				this.Const.Strings.Terrain[this.m.Destination.getTile().Type]
			]);
		}
		else
		{
			local nearest_base = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Rat).getNearestSettlement(this.World.State.getPlayer().getTile());
			local region = this.World.State.getRegion(nearest_base.getTile().Region);
			_vars.push([
				"region",
				region.Name
			]);
			_vars.push([
				"nearest_town",
				""
			]);
			_vars.push([
				"distance",
				""
			]);
			_vars.push([
				"direction",
				this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(region.Center)]
			]);
			_vars.push([
				"terrain",
				this.Const.Strings.Terrain[region.Type]
			]);
		}
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
			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		return true;
	}

	function onIsTileUsed( _tile )
	{
		return false;
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

		if (this.m.Threat != null && !this.m.Threat.isNull())
		{
			_out.writeU32(this.m.Threat.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local obj = _in.readU32();

		if (obj != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(obj));
		}

		obj = _in.readU32();

		if (obj != 0)
		{
			this.m.Threat = this.WeakTableRef(this.World.getEntityByID(obj));
		}

		this.contract.onDeserialize(_in);
	}

});

