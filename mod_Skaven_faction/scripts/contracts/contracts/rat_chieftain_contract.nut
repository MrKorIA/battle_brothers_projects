this.rat_chieftain_contract <- this.inherit("scripts/contracts/contract", {
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

		this.m.Type = "contract.rat_chieftain";
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
		this.m.Payment.Pool = 1300 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Последний раз его видели в регионе в %region%, к %direction% от вас"
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
				party.setDescription("Мастер использования чужих слабостей. Треч и его банда никогда не там, где их ожидают, и всегда там, где могут нанести наибольший урон.");
				party.getSprite("body").setBrush("figure_rat_07");
				party.setFootprintType(this.Const.World.FootprintsType.Skavens);
				party.setVisibilityMult(2.0);
				this.Contract.addUnitsToEntity(party, this.Const.World.Spawn.RatChef, 100);
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer% стоит у карты на стене, и тычет пальцем в обведённую красным область. Он даже не оборачивается, когда вы входите.%SPEECH_ON%Видишь это место? К %direction% от нас, в землях под названием %region%. Раньше там была тихая долина. Теперь же там гнездо скавенов.%SPEECH_OFF%Он поворачивается и оценивает вас холодным взглядом.%SPEECH_ON%Их вожак называет себя \'Великим Вождём Глубинных Нор\'. Хвастливое имя для крысы, но он собрал под свою лапу несколько кланов. Штурмокрысы, клановые крысы, инженеры — всё, что ползает и грызёт. Если мы не остановим его сейчас, через месяц он выйдет из своих нор и пойдёт к нашим городам.%SPEECH_OFF%Он берёт со стола тяжёлый кошель и бросает его на стол перед вами.%SPEECH_ON%Аванс. Остальное — когда я увижу его голову на своём столе. Ты справишься, наёмник?%SPEECH_OFF% | %employer% сидит в кресле, закинув ногу на ногу, и смотрит на вас сквозь дым от трубки.%SPEECH_ON%Ты слышал о скавенах, которые объединились в землях под названием %region%? Нет? Тогда слушай. Там появился вожак. Не просто какой-то крыс с тесаком — он носит шлем из варп-камня и командует штурмокрысами. Этот скавен уже сжёг три деревни и утащил всех, кто не успел убежать.%SPEECH_OFF%Он делает долгую затяжку и выпускает дым в потолок.%SPEECH_ON%Я хочу, чтобы ты пошёл в земли под названием %region%, нашёл этого \'Верховного вождя\' и отрезал ему башку. Принеси мне её — и я заплачу тебе столько, что ты сможешь купить собственный город. Ну что, идёт?%SPEECH_OFF% | %employer% стоит у окна, но не смотрит на улицу — он смотрит на своё отражение в стекле.%SPEECH_ON%Я боюсь, наёмник. Но я не боюсь признаться в этом. Скавены всегда были просто чумой — надоедливой, но предсказуемой. Но этот вожак, которого они называют \'Великим Вождём Глубинных Нор\', — другой. Умный. Объединил кланы, которых никто не мог объединить.%SPEECH_OFF%Он поворачивается к вам, и в его глазах нет страха — только мрачная решимость.%SPEECH_ON%Убей его, наёмник, пока он не собрал армию, которую мы не сможем остановить. Иди в земли под названием %region% и покончи с ним. Я заплачу.%SPEECH_OFF% | %employer% сидит за столом, заваленным картами и донесениями. Он выглядит уставшим, но голос его твёрд.%SPEECH_ON%Мои разведчики принесли вести. В землях под названием %region% к %direction% от нас — появился скавен, который называет себя \'Великим Вождём Глубинных Нор\'. Он носит доспех, сделанный из варп-камня, и его гвардия — штурмокрысы, которые не знают страха.%SPEECH_OFF%Он пододвигает к вам карту, на которой красным отмечен маршрут.%SPEECH_ON%Сейчас он здесь. Где будет через неделю — не знаю. Иди туда, найди его и убей. И принеси мне доказательство. Я заплачу тебе сполна.%SPEECH_OFF% | %employer% стоит у камина, держа в руках старую, потёртую книгу. Он закрывает её, когда вы входите.%SPEECH_ON%Знаешь, что это? История моего деда. Он писал о временах, когда скавены были просто слухами. Но этот \'Великий Вождь Глубинных Нор\' — уже не слух: он реален и уже в землях известных под названием %region%, где собирает армию.%SPEECH_OFF%Он бросает книгу на стол, и она открывается на странице с картой.%SPEECH_ON%Убей его, наёмник. Не дай ему войти в историю как тот, кто разрушил мои земли. Я заплачу тебе столько, сколько ты попросишь.%SPEECH_OFF%}",
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
			Text = "{[img]gfx/ui/events/event_59.png[/img]Толпа беженцев бредёт по дороге, и вы останавливаете одного из них — старика с пустыми глазами, который тащит на плече узел с пожитками.%SPEECH_ON%Ты куда, наёмник? К %direction% отсюда? Не ходи туда. Там вожак. Огромный, по меркам скавенов, конечно, в доспехе из варп-камня. Он вырезал всю мою деревню за одну ночь. Если ты идёшь туда, молись своим богам.%SPEECH_OFF%Старик уходит, и вы смотрите ему вслед, сжимая рукоять меча. | [img]gfx/ui/events/event_41.png[/img]Вы встречаете торговца с пустой телегой. Он сидит на обочине и смотрит в одну точку. Когда вы подходите, он поднимает голову.%SPEECH_ON%Ты идёшь к %direction% отсюда? В земли под названием %region%? Там скавены. Их вожак — сущий демон. Говорят, он ест своих же, для острастки остальных. Говорят, он носит доспех из варп-камня. Я бы не пошёл туда ни за какие деньги.%SPEECH_OFF%Вы киваете и идёте дальше. | [img]gfx/ui/events/event_94.png[/img]Вы находите полуголого человека, который сидит на обочине и дрожит. Он поднимает на вас мутный взгляд.%SPEECH_ON%Ты идёшь убивать вожака? Я видел его. Прошёл через мою деревню, как нож сквозь масло. У него были такие зубищи... и глаза, как раскалённые докрасна угли. Он где-то там, к %direction% отсюда, в землях под названием %region%. Если ты убьёшь его, ты сделаешь мир лучше. Если нет, ну, ты хотя бы попытаешься.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{Вы стоите на холме и смотрите на долину, где, по слухам, обосновался скавен-вожак. Отряд устал, припасы на исходе, а вожака всё ещё не нашли. Но теперь у вас есть все приметы. Беженцы, торговцы, крестьяне — все говорили одно и то же. \'Великий Вождь Глубинных Нор\' действительно там, в землях под названием %region%, к %direction% отсюда. Осталось только сделать последний рывок.}",
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
			Text = "[img]gfx/ui/events/rat_event_11.png[/img]{Вы выходите на открытое место, и сердце пропускает удар. Внизу, в долине, стоит большой отряд. Штурмокрысы — элитные воины с чёрной шерстью и прочными щитами — выстроились в плотные ряды. Между ними снуют клановые крысы, вооружённые ржавым железом. А в центре, на возвышении из костей и камней, стоит он. \'Великий Вождь Глубинных Нор\'. Властный, в доспехе, который пульсирует зелёным светом варп-камня. Он замечает вас и издаёт низкий, гортанный писк. Его стая приходит в движение. Вы поднимаете меч.}",
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
			Text = "[img]gfx/ui/events/rat_event_08.png[/img]{Битва стихает. Расталкивая ногами груды мёртвых штурмокрыс, вы находите вождя — он лежит на спине, доспех расколот, из груди торчит клинок. Он ещё дышит, но взгляд уже потухший, устремлён в никуда. Вы опускаетесь на колено и отсекаете голову. Она тяжёлая, покрыта шрамами и варп-камнем. %randombrother% подходит с мешком.%SPEECH_ON%Теперь он точно никому не навредит.%SPEECH_OFF%Вы бросаете голову в мешок и приказываете собирать трофеи. Пора возвращаться.}",
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
			Text = "[img]gfx/ui/events/rat_event_12.png[/img]{Вы подходите к лагерю скавенов, готовый к бою, но вместо атаки вас встречает странная процессия. Вождь выходит к вам навстречу, и рядом с ним стоит серый провидец — сгорбленное, покрытое шрамами существо с посохом, увенчанным пульсирующим зелёным камнем. Провидец поднимает руку и говорит писклявым голосом:%SPEECH_ON%Слушай-слушай, человек-наёмник! Мы не враги-недруги тебе, нет-нет! Настоящий враг — тот, кто прёт, топчет земли с запада! Огромный, ужасный чёрный орк-вожак ведёт свою вонючую орду-стаю! Если мы будем грызться, резать друг друга — мы оба умрём, сдохнем-сдохнем под их ножищами! Но если мы объединимся... да-да, сплотим наши силы в хитрый пакт — мы выживем, спасёмся-победим!%SPEECH_OFF%Вы смотрите на вождя. Он стоит неподвижно, его красные глаза не мигают. %randombrother% подходит ближе и шепчет:%SPEECH_ON%Он не врёт про орков, командир. Мы видели следы по пути. Но довериться скавену? Это как доверить кошелёк вору.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Мы нападём на них и избавимся от Великого Вождя Глубинных Нор.",
					function getResult()
					{
						return "AGreaterThreat2";
					}

				},
				{
					Text = "Мы присоединимся к ним, чтобы выступить против вожака чёрных орков.",
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
			Text = "[img]gfx/ui/events/rat_event_12.png[/img]{Вы смотрите на провидца и качаете головой.%SPEECH_ON%Я не верю ни одному вашему слову. Вы резали людей, разрушали их дома. Вы — чума, и я здесь, чтобы выжечь вашу заразу раз и навсегда.%SPEECH_OFF%Провидец переводит ваши слова вождю. Тот медленно опускает лапу на рукоять тесака. Глаза его сужаются. Он пищит что-то на своём языке, и провидец кивает.%SPEECH_ON%Тогда умри, сдохни как глупый человек-мужчина, наёмник-тварь! Мы встретим тебя в бою, разорвём-загрызем в драке, да-да!%SPEECH_OFF%Вы вытаскиваете свой меч, и воздух мгновенно наполняется свирепым крысиным писком.}",
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
			Title = "По мере приближения...",
			Text = "[img]gfx/ui/events/rat_event_12.png[/img]{Вы смотрите на провидца и медленно киваете.%SPEECH_ON%Хорошо. Мы идём с вами против орков. Но если вы предадите нас — я лично отделю голову вашего вождя от тела.%SPEECH_OFF%Провидец переводит. Вождь молчит, потом протягивает вам клинок рукоятью вперёд. Жест, который у людей означает доверие. Вы берёте клинок за рукоять — и мурашки бегут по спине от мысли, что это оружие только что держал \'Великий Вождь Глубинных Нор\'. Затем возвращаете клинок владельцу. Скавен коротко кивает.}",
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
				local party = this.World.FactionManager.getFaction(nearest_orc.getFaction()).spawnEntity(tile, "Вожак чёрных орков", false, this.Const.World.Spawn.OrcRaiders, 260 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				party.getSprite("banner").setBrush(nearest_orc.getBanner());
				party.setDescription("Банда орков, возвышающихся на целую голову над любым человеком.");
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
			Text = "[img]gfx/ui/events/event_93.png[/img]{Вы выходите на гребень холма и видите армию орков. Их десятки. Чёрный орк-вожак сидит на троне из черепов и смотрит на ваше приближение. Рядом с вами стоит вождь скавенов. Он не двигается, но вы слышите его дыхание — низкое, сопящее. Провидец подходит к вам и говорит писклявым голосом.%SPEECH_ON%Человек-наёмник, сегодня мы либо умрём как великие крысы-герои, либо все станем сочным кормом для подземных червей-личинок! Да-да! Но провидец видит... Провидец знает! Вождь рад-доволен, что ты стоишь рядом с ним, хвост к хвосту, плечо к плечу... хотя его гордость-величие никогда, слышишь-знаешь, никогда не позволит признать и сказать это вслух, нет-нет!%SPEECH_OFF%Вы киваете. Сзади раздаётся боевой клич ваших людей.}",
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
			Text = "[img]gfx/ui/events/rat_event_12.png[/img]{Поле боя усеяно телами орков. Ваши люди перевязывают раны, скавены собирают трофеи. Вождь стоит над телом чёрного орка, его клинок всё ещё торчит из груди врага. Провидец подходит к вам со свёртком — в нём скавенская броня, адаптированная под размеры человека.%SPEECH_ON%Слушай-слушай, человек-наёмник, великие слова! Вождь говорит, что запомнит-сбережёт память о тебе! Да-да! Не как о глупом, мерзком враге, нет-нет! А как о том, с кем он стоял бок о бок, плечом к плечу, хвостом к хвосту в этой славной резне!%SPEECH_OFF%Он протягивает свёрток.%SPEECH_ON%Это не глупый подарок-подношение, нет! Это — великий знак, кровный символ! Ты заслужил-вырвал его у смерти!%SPEECH_OFF%Вождь отворачивается и уходит в сторону леса. Его отряд собирается и уходит следом. Вы сжимаете пластины полученной брони и смотрите им вслед.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Прощай, Великий Вождь Глубинных Нор.",
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

				local item = this.new("scripts/items/armor/human_tretch_armor");
				local u = this.new("scripts/items/armor_upgrades/tretch_padding_upgrade");
				item.setUpgrade(u);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/armor/icon_human_tretch_armor.png",
					text = "Вы получаете модифицированную броню Треча Трусливого Хвоста"
				});
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_31.png[/img]{Вы входите в комнату и бросаете мешок на пол. %employer% развязывает его, заглядывает внутрь и отшатывается назад, но на его лице появляется кривая усмешка.%SPEECH_ON%Боги, какой урод. Этот вождь... он даже в смерти выглядит так, будто готов тебя укусить.%SPEECH_OFF%Он закрывает мешок и протягивает вам шкатулку, полную крон.%SPEECH_ON%Плата, как договаривались. Ты сделал больше, чем я мог просить. Ты дал моим людям надежду. А надежда, наёмник, стоит дороже любых крон.%SPEECH_OFF%Вы забираете шкатулку и на пробу встряхиваете её, вслушиваясь в звон монет. Надежда надеждой, а крон в дороге ещё никогда не бывало слишком много. | %employer% стоит у камина, глядя на огонь. Когда вы входите, он медленно поворачивается.%SPEECH_ON%Я слышал, как стихли писклявые крики. Я слышал, как они бежали. Ты сделал это.%SPEECH_OFF%Он подходит к столу и достаёт тяжёлый кожаный кошель.%SPEECH_ON%Плата, как и обещал. Ты заслужил её.%SPEECH_OFF%Вы забираете кошель и выходите, оставляя его стоять в тишине. | %employer% сидит за столом и что-то пишет. Когда вы кладёте голову вождя на угол стола, он не поднимает глаз.%SPEECH_ON%Говорят, ты прошёл через их строй как нож сквозь масло. Говорят, ты дрался с самим вождём лицом к морде.%SPEECH_OFF%Он ставит последнюю точку и поднимает взгляд.%SPEECH_ON%Это именно то, что мне нужно. Ты заслужил каждую крону.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Убит Великий Вождь Глубинных Нор");
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

				local item = this.new("scripts/items/helmets/human_tretch_helmet");
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
			Text = "[img]gfx/ui/events/event_31.png[/img]{В кабинете догорает единственная свеча. %employer% ждёт вашего доклада, и по его лицу сразу видно — врать ему не имеет смысла.%SPEECH_ON%Скавен жив, но он ушёл за пределы твоих земель, и его армия больше не угрожает.%SPEECH_OFF%%employer% хмурится, потом медленно кивает.%SPEECH_ON%Ты пришёл без трофея, но с вестью, которая стоит не меньше. Я не могу повесить его голову на стену, но я могу спокойно спать по ночам. Плата, как и обещал. Ты выполнил свою работу, даже если сделал это не так, как я ожидал.%SPEECH_OFF%Вы забираете кошель и выходите.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Устранена угроза, исходившая от \'Великого Вождя Глубинных Нор\'");
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
				local item = this.new("scripts/items/helmets/human_tretch_helmet");
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

