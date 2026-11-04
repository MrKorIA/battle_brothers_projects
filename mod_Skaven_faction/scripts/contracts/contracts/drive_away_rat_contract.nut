this.drive_away_rat_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Dude = null,
		Reward = 0,
		OriginalReward = 0
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.drive_away_rat";
		this.m.Name = "Прогнать скавенов";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function generateName()
	{
		local vars = [
			[
				"randomname",
				this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]
			],
			[
				"randomtown",
				this.Const.World.LocationNames.VillageWestern[this.Math.rand(0, this.Const.World.LocationNames.VillageWestern.len() - 1)]
			]
		];
		return this.buildTextFromTemplate(this.Const.Strings.RatGreyseerNames[this.Math.rand(0, this.Const.Strings.RatGreyseerNames.len() - 1)], vars);
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		local ratcamp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Rat).getNearestSettlement(this.m.Home.getTile());
		this.m.Destination = this.WeakTableRef(ratcamp);
		this.m.Flags.set("DestinationName", ratcamp.getName());
		this.m.Flags.set("RatGreyseerName", this.generateName());
		this.m.Payment.Pool = 550 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Изгнать скавенов из местечка " + this.Flags.get("DestinationName") + " к %direction% от поселения %origin%"
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
				this.Contract.m.Destination.clearTroops();
				this.Contract.m.Destination.setLastSpawnTimeToNow();

				if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Destination.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Destination.getLoot().clear();
				}

				this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.RatDefenders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setLootScaleBasedOnResources(110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 70 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);

				if (this.World.Assets.getBusinessReputation() >= 500 && this.Contract.getDifficultyMult() >= 0.95 && this.Math.rand(1, 100) <= 20)
				{
					this.Flags.set("IsRatGreyseerPresent", true);

					if (this.World.Assets.getBusinessReputation() > 600 && this.Math.rand(1, 100) <= 50)
					{
						this.Flags.set("IsBountyHunterPresent", true);
					}
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
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					if (this.Flags.get("IsRatGreyseerDead"))
					{
						this.Contract.setScreen("RatGreyseerDead");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Math.rand(1, 100) <= 10 && this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
					{
						this.Contract.setScreen("Volunteer1");
						this.World.Contracts.showActiveContract();
					}

					this.Contract.setState("Return");
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				if (this.Flags.get("IsRatGreyseerPresent"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("AttackRatGreyseer");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.Music = this.Const.Music.RatTracks;
						properties.Entities.push({
							ID = this.Const.EntityType.RatGreyseer,
							Variant = 0,
							Row = 2,
							Script = "scripts/entity/tactical/enemies/rat_greyseer",
							Faction = _dest.getFaction(),
							Callback = this.onRatGreyseerPlaced.bindenv(this)
						});
						properties.EnemyBanners.push(this.Contract.m.Destination.getBanner());
						this.World.Contracts.startScriptedCombat(properties, true, true, true);
					}
				}
				else
				{
					this.World.Contracts.showCombatDialog();
				}
			}

			function onRatGreyseerPlaced( _entity, _tag )
			{
				_entity.getFlags().set("IsRatGreyseer", true);
				_entity.setName(this.Flags.get("RatGreyseerName"));
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_actor.getFlags().get("IsRatGreyseer") == true)
				{
					this.Flags.set("IsRatGreyseerDead", true);
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
					if (this.Flags.get("IsRatGreyseerDead"))
					{
						this.Contract.setScreen("Success2");
					}
					else
					{
						this.Contract.setScreen("Success1");
					}

					this.World.Contracts.showActiveContract();
				}

				if (this.Flags.get("IsRatGreyseerDead") && this.Flags.get("IsBountyHunterPresent") && !this.TempFlags.get("IsBountyHunterTriggered") && this.World.Events.getLastBattleTime() + 7.0 < this.Time.getVirtualTimeF() && this.Math.rand(1, 1000) <= 2)
				{
					this.Contract.setScreen("BountyHunters1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsBountyHunterRetreat"))
				{
					this.Contract.setScreen("BountyHunters3");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "BountyHunters")
				{
					this.Flags.set("IsBountyHunterPresent", false);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "BountyHunters")
				{
					this.Flags.set("IsBountyHunterPresent", false);
					this.Flags.set("IsBountyHunterRetreat", true);
					this.Flags.set("IsRatGreyseerDead", false);
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
			Text = "[img]gfx/ui/events/event_20.png[/img]{Стол завален трофеями недавней вылазки - черепками и ржавым железом. %employer% сидит на его краю и крутит в руках обломок зубчатого клинка. По ржавчине и зеленоватому налёту видно - оружие не человеческое.%SPEECH_ON%Мы нашли их лагерь. Не просто стоянку - настоящий укреплённый выводок. Там есть навесы из кож, клетки, кострища и запах, от которого у людей кружится голова.%SPEECH_OFF%Он бросает клинок на стол, и тот звенит глухим металлом.%SPEECH_ON%Они явно замышляют что-то крупное. Мои лазутчики видели подобие осадной башни из обломков телег и человеческих костей. Я хочу, чтобы ты пошёл в этот лагерь и вырезал там всех. Что скажешь, наёмник, задушишь эту проблему на корню, или же мне поискать более крутых ребят?%SPEECH_OFF% | %employer% стоит у карты, на которой обведена большая территория. Он тычет пальцем в центр.%SPEECH_ON%Здесь. Мы нашли их лагерь. Не просто нора - целый скавенский форпост. Они притащили туда ящики с неизвестным грузом, и каждую ночь оттуда доносится лязг металла и писк.%SPEECH_OFF%Он поднимает глаза на вас.%SPEECH_ON%Я не знаю, что они замышляют, но знаю одно - если они что-то строят, нам это не понравится. Иди туда, разрушь всё, убей всех. Я заплачу тебе столько, сколько скажешь.%SPEECH_OFF% | Вы входите в тёмную комнату и видите, как %employer% стоит, прислонившись к стене. Он смотрит на обрывок пергамента. На нём - грубый набросок лагеря, окружённого рвами и частоколами.%SPEECH_ON%Мы нашли их логово. Оно далеко от города, но не настолько, чтобы мы могли спать спокойно. Мои люди видели там не просто скавенов - они видели инженеров. Они что-то строят, наёмник. Что-то с колёсами с острыми краями.%SPEECH_OFF%Он отдаёт вам пергамент.%SPEECH_ON%Я не хочу знать, что это. Я хочу, чтобы ты пошёл туда, уничтожил всё что увидишь и принёс мне доказательство. Ты справишься?%SPEECH_OFF% | %employer% сидит за столом, заваленным осколками керамики, ржавыми гвоздями и обломком зубчатого клинка.%SPEECH_ON%Мои люди наткнулись на их лагерь случайно. Они шли через лес и вышли на поляну, где стояли палатки из шкур и клетки с чем-то живым. Скавены не просто прячутся - они собираются.%SPEECH_OFF%Он поднимает обломок клинка и показывает его вам.%SPEECH_ON%Скоро их станет столько, что они начнут представлять серьёзную угрозу. Придут к нам и начнут резать нас этими штуками. Я хочу, чтобы ты пошёл в их лагерь и не дал им шанса. Убей всех. Я заплачу тебе столько, сколько попросишь.%SPEECH_OFF% | Вы заходите в комнату и видите, как %employer% стоит на коленях перед раскрытым сундуком. Он достаёт оттуда карту, свёрнутую в трубку, и разворачивает её на столе.%SPEECH_ON%Мы нашли их лагерь. Он расположен так, что оттуда можно контролировать все дороги к городу. Это не случайность - они выбрали это место специально.%SPEECH_OFF%Он проводит пальцем над картой, не касаясь её, - словно боится оставить на ней грязный след.%SPEECH_ON%Я не знаю, что они планируют. Но я знаю, что они не просто прячутся - они готовятся. Я хочу, чтобы ты пошёл туда и уничтожил этот лагерь. Всех, кто там есть. До последнего. Ты согласен?%SPEECH_OFF% | %employer% сидит на корточках у камина, вертя в пальцах кусок зеленоватого кристалла, который слабо пульсирует изнутри, и смотрит на огонь. Он не оборачивается, когда вы входите.%SPEECH_ON%Мы нашли их. Лагерь в старой каменоломне. Там есть что-то вроде алтаря из варп-камня и клетки с существами, которых я не могу описать. Они не просто живут там - они поклоняются чему-то.%SPEECH_OFF%Он встаёт и поворачивается к вам, по-прежнему сжимая кристалл в ладони.%SPEECH_ON%Я хочу, чтобы ты пошёл туда, разрушил их капище и перебил всех. Так что скажешь, наёмник? Ты сделаешь это для меня? Назови свою цену, уверен, мы сможем договориться.%SPEECH_OFF% | %employer% стоит у раскрытого окна, и ветер играет с бумагами на его столе. Он не обращает на них внимания.%SPEECH_ON%Лазутчики вернулись. Лагерь скавенов найден. Там - не просто стая. Там - собирается армия. Небольшая, но организованная. Очевидно, что крысы замышляют какое-то крупное дело.%SPEECH_OFF%Он смотрит на вас в упор.%SPEECH_ON%Я хочу, чтобы ты пошёл туда и нарушил их планы. Разрушь их склады, убей их вожаков, сожги их припасы. Убей всех, кого успеешь, остальные пускай разбегаются, меня это устроит. Не волнуйся, наёмник, за эту работу я заплачу тебе по справедливости.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{О какой сумме мы говорим? | Сколько же %townname% готов заплатить за свою безопасность? | Поговорим об оплате.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Не интересует. | У нас есть более важные дела. | Желаю удачи, но мы не будем в этом участвовать.}",
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
			ID = "AttackRatGreyseer",
			Title = "Перед атакой...",
			Text = "[img]gfx/ui/events/rat_event_13.png[/img]{Вы разглядываете скавенский лагерь и замираете. В центре, окружённый штурмокрысами, стоит серый провидец. Горбатый, покрытый шрамами, в плаще из варп-шёлка - его фигуру не спутать ни с кем. %ratgreyseer%. Тот самый, о котором шепчутся в трактирах и на рынках. Его голова стоит целого состояния - и она уже почти в руках вашего отряда. Вы поворачиваетесь к своим людям.%SPEECH_ON%Видели? Это наша надбавка. Готовьте оружие.%SPEECH_OFF% | Лагерь скавенов кишит тенями, но среди них выделяется одна - она движется не как остальные. %ratgreyseer%. Он ходит между лежанками, тычет пальцем в сторону наваленных тюков, что-то шипит своим подручным. Несколько телохранителей следуют за ним по пятам. Вы считаете врагов - около %totalenemy% крыс. Поднимаете руку и даёте знак отряду к атаке. Необходимо действовать тихо, быстро и без пощады. | Зеленоватое свечение варп-камня стелется над лагерем, и в его призрачном свете вы не ожидали увидеть именно его. %ratgreyseer% стоит у одной из жаровен, его посох пульсирует тем же болезненным светом. Похоже, он проверяет боеготовность лагеря. Телохранителей рядом с ним не больше трёх - внезапная атака может застать их врасплох. Вы сжимаете рукоять меча и шепчете.%SPEECH_ON%Сегодня удача на нашей стороне.%SPEECH_OFF% | В лагере суета - скавены таскают тюки, чинят оружие, грызут кости. Но среди всей этой серой массы выделяется одна фигура. %ratgreyseer%. Он стоит на возвышении из ящиков и смотрит на горизонт, словно ждёт кого-то. Вы всматриваетесь в его морду - узкую, с длинными усами и горящими красными глазами. Затем поднимаете меч.%SPEECH_ON%Мы идём за ним!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Готовьтесь к атаке!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "RatGreyseerDead",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/rat_event_08.png[/img]{После битвы вы подходите к телу убитого крыса, ранее известного как %ratgreyseer%, и двумя быстрыми ударами меча отрубаете ему голову: первый рассекает плоть, второй - кость. Вонзив крюк в край шеи и продев верёвку, вы прикрепляете голову к поясу. | С окончанием боя вы быстро обыскиваете местность и находите среди мёртвых крыс тело. Да, это %ratgreyseer%. Даже когда жизнь покинула его тело, он всё ещё выглядит на удивление злым - и остаётся таким, пока вы отделяете голову. Морды вам больше не видно, когда она отправляется в мешок из-под муки, но вы готовы поспорить: там, внутри, он по-прежнему выглядит невероятно злым. | %ratgreyseer% лежит мёртвый у ваших ног. Вы переворачиваете тело и выпрямляете шею, раскрывая мечу лучшую цель. Требуется два хороших удара, чтобы отрубить голову, которую вы быстро кладёте в мешок. | Даже мёртвый, %ratgreyseer% сопротивлялся до последнего - наросты и вросший под шерсть зелёный камень не желали легко отдавать голову, пока вы добывали свою награду. | Вы опускаетесь на колено рядом с телом серого провидца и отсекаете голову одним движением. Она оказывается тяжелее, чем выглядит, когда вы наконец берёте её в руки. %ratgreyseer% смотрит на вас пустыми глазами, в которых, кажется, застыл укор. %randombrother% указывает на неё, когда вы проходите мимо.%SPEECH_ON%Что это? Это %ratgreyseer%...?%SPEECH_OFF%Вы качаете головой.%SPEECH_ON%Нет, этот крыс мёртв. Это просто бонус к нашей оплате.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Выступаем!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BountyHunters1",
			Title = "По пути...",
			Text = "[img]gfx/ui/events/event_07.png[/img]{На обратном пути несколько человек перегораживают вам дорогу. Один из них указывает на голову того, кто раньше был известен как %ratgreyseer%.%SPEECH_ON%Мы - лучшие охотники за головами в этих краях и, как я понимаю, вы сейчас занялись не своим делом. Отдайте голову нам, и сможете сегодня спокойно спать в своих кроватках.%SPEECH_OFF%Вы смеётесь.%SPEECH_ON%Тебе придётся придумать историю получше. Мёртвый %ratgreyseer% стоит немало крон, друг мой.%SPEECH_OFF%Командир этих \'охотников за головами\' тоже смеётся. Он поднимает мешок с чем-то круглым внутри.%SPEECH_ON%Это - %randomname%, один из самых разыскиваемых парней в этих краях. А это...%SPEECH_OFF%Он поднимает другой мешок.%SPEECH_ON%А это голова человека, который его убил. Понимаешь, к чему я веду? Итак, отдай голову, и мы все сможем продолжить путь.%SPEECH_OFF% | Незнакомец выходит на дорогу, расправляет плечи и указывает на вас.%SPEECH_ON%Здравствуйте, господа хорошие. Похоже, %ratgreyseer% отдал вам свою голову.%SPEECH_OFF%Вы киваете. Он улыбается.%SPEECH_ON%Не будете ли вы столь любезны передать её мне?%SPEECH_OFF%Вы смеётесь и качаете головой. Незнакомец больше не улыбается, вместо этого он поднимает руку и щёлкает пальцами. Тотчас отряд вооружённых людей появляется из близлежащих зарослей, выходя на дорогу под тяжёлый металлический лязг. Они словно списаны с мечты смертника в ночь перед казнью. Их лидер озаряет вас золотозубой усмешкой.%SPEECH_ON%Повторять не буду.%SPEECH_OFF% | Вашу беседу с одним из наёмников прерывает громкий крик. Вы переводите взгляд на дорогу, замечая группу людей, преграждающих вам путь. Их главарь выходит вперёд, объявляя, что они - знаменитые охотники за головами.%SPEECH_ON%Наше единственное желание - получить голову скавена, известного под именем \'%ratgreyseer%\'.%SPEECH_OFF%Вы пожимаете плечами.%SPEECH_ON%Мы убили его, нам же и принадлежит его голова. Убирайся с нашего пути.%SPEECH_OFF%Как только вы шагнули вперёд, охотники за головами поднимают своё оружие. Их командир делает один шаг к вам.%SPEECH_ON%Неверный выбор приведёт к смерти многих хороших людей. Знаю, это непросто, но я предлагаю тебе ещё раз тщательно всё обдумать.%SPEECH_OFF% | Резкий свист привлекает ваше внимание. Вы переводите взгляд на обочину, замечая группу людей, появившихся из кустов. Все обнажают оружие, но незнакомцы останавливаются. Их главарь движется вперёд. Его грудь украшает ожерелье из ушей - символ его свершений.%SPEECH_ON%Привет, ребята. Мы, если вы не знали, охотники за головами и, похоже, у вас наша добыча.%SPEECH_OFF%Вы поднимаете голову, %ratgreyseer% смотрит на всех присутствующих безжизненным, но от этого не менее злым взглядом.%SPEECH_ON%Не его ли имеешь в виду?%SPEECH_OFF%Главарь тепло улыбается.%SPEECH_ON%Конечно. Вы очень порадуете меня и моих друзей, если отдадите то, что нам так нужно.%SPEECH_OFF%Он опускает руку на рукоять меча и усмехается.%SPEECH_ON%Просто работа, ничего личного. Уверен, вы понимаете.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Забирай эту проклятую голову и убирайся.",
					function getResult()
					{
						this.Flags.set("IsRatGreyseerDead", false);
						this.Flags.set("IsBountyHunterPresent", false);
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractPoor);
						return "BountyHunters2";
					}

				},
				{
					Text = "{Хочешь забрать её - заплати кровью! | Если ты хочешь, чтобы твоя голова присоединилась к этой - давай, рискни!}",
					function getResult()
					{
						this.TempFlags.set("IsBountyHunterTriggered", true);
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.Music = this.Const.Music.RatTracks;
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "BountyHunters";
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.BountyHunters, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Rat).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BountyHunters2",
			Title = "По пути...",
			Text = "[img]gfx/ui/events/event_07.png[/img]Вы видели достаточно кровопролития на сегодня. Вы отдаёте голову.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Пойдём дальше. Нам ещё нужно получить плату.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BountyHunters3",
			Title = "По пути...",
			Text = "[img]gfx/ui/events/event_07.png[/img]Охотники за головами оказались не по зубам отряду \'%companyname%\'! Не желая, чтобы ваших людей убивали напрасно, вы приказываете отступить. К сожалению, голова скавена, коего знали под именем %ratgreyseer%, была утеряна в суматохе...",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Ну что ж. Нам всё ещё нужно получить плату.",
					function getResult()
					{
						this.Flags.set("IsBountyHunterRetreat", false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Volunteer1",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/rat_event_08.png[/img]{Бой стихает, и отряд начинает собирать трофеи. Вдруг из груды тел доносится стон. Вы подходите ближе и оттаскиваете в сторону мёртвого скавена - под ним лежит человек. Он грязный, избитый, руки перетянуты верёвкой, но живой. Вы разрезаете путы и помогаете ему сесть. Затем интересуетесь, кто он такой. Человек кашляет и вытирает кровь с губ.%SPEECH_ON%Я из поселения %randomtown%. Скавены схватили меня три дня назад. Хотели сделать меня рабом... или съесть - я не понял. Спасибо, что освободил.%SPEECH_OFF%Он поднимает на вас глаза и с надеждой спрашивает.%SPEECH_ON%У вас есть место для ещё одного меча?%SPEECH_OFF% | Отряд обыскивает лагерь и находит запертую клетку. Внутри - человек. Он смотрит на вас с надеждой и страхом. Вы взламываете замок и помогаете ему выбраться. Затем интересуетесь, кто он такой. Человек жмётся и оглядывается по сторонам.%SPEECH_ON%Я был в караване. Скавены напали, всех убили, а меня оставили - для забавы. Спасибо, что пришли.%SPEECH_OFF%Он встаёт на ноги и расправляет плечи.%SPEECH_ON%Я умею драться. Возьмите меня с собой.%SPEECH_OFF% | После боя вы замечаете, что в куче мешков кто-то шевелится. Подходите, отбрасываете тряпку и видите человека - оборванного, исхудавшего, но живого. Он смотрит на вас и начинает медленно улыбаться.%SPEECH_ON%Я думал, пришли твари пострашнее и спрятался здесь. Спасибо, что перебили эту мерзость.%SPEECH_OFF%Вы протягиваете ему руку и помогаете встать.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Можешь присоединиться к нам.",
					function getResult()
					{
						return "Volunteer2";
					}

				},
				{
					Text = "Иди домой.",
					function getResult()
					{
						return "Volunteer3";
					}

				}
			],
			function start()
			{
				local roster = this.World.getTemporaryRoster();
				this.Contract.m.Dude = roster.create("scripts/entity/tactical/player");
				this.Contract.m.Dude.setStartValuesEx(this.Const.CharacterLaborerBackgrounds);

				if (this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					this.Contract.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Volunteer2",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/rat_event_08.png[/img]{Он вливается в ваши ряды, исчезая в толпе братьев, которые принимают его достаточно тепло для группы наёмных убийц. Новичок хвастается, что хорош со всеми видами оружия, но вы сами решите, чем он будет владеть. | Пленник улыбается от уха до уха, когда вы его принимаете. Несколько братьев спрашивают, какое оружие ему дать, но вы пожимаете плечами - решите позже.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Давай-ка подберём тебе оружие.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Contract.m.Dude.getImagePath());
				this.World.getPlayerRoster().add(this.Contract.m.Dude);
				this.World.getTemporaryRoster().clear();
				this.Contract.m.Dude.onHired();
				this.Contract.m.Dude = null;
			}

		});
		this.m.Screens.push({
			ID = "Volunteer3",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/rat_event_08.png[/img]{Вы качаете головой. Мужчина хмурится.%SPEECH_ON%Вы уверены? Я довольно хорош в...%SPEECH_OFF%Вы перебиваете.%SPEECH_ON%Уверен. А теперь наслаждайся своей свободой, незнакомец.%SPEECH_OFF% | Вы оцениваете мужчину и понимаете, что он не подходит для жизни наёмника.%SPEECH_ON%Мы ценим предложение, но жизнь наёмника опасна. Возвращайся домой, к семье, к работе.%SPEECH_OFF% | У вас достаточно людей, новички не нужны. Однако вам интересно: как отреагирует %randombrother%, если вы заговорите о его замене? Вместо этого вы пожимаете руку пленнику и отправляете его восвояси. Он разочарован, но благодарит за освобождение.}",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Иди.",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				this.Characters.push(this.Contract.m.Dude.getImagePath());
				this.World.getTemporaryRoster().clear();
				this.Contract.m.Dude = null;
			}

		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Вы возвращаетесь в поселение %townname%. %employer% слушает ваш краткий доклад: скавены мертвы. Он кивает, сдержанно улыбается и передаёт плату.%SPEECH_ON%Хорошая работа, наёмник. Эти скавены доставляли нам много хлопот.%SPEECH_OFF% | %employer% открывает дверь, когда вы подходите к его дому. В руке у него мешок, который он поднимает.%SPEECH_ON%Судя по твоему возвращению, скавены мертвы?%SPEECH_OFF%Вы киваете. Он швыряет мешок в вашу сторону. Вы ловко ловите его и говорите, что могли бы лгать. %employer% пожимает плечами.%SPEECH_ON%Может быть, но слухи быстро распространяются о тех, кто кусает руку, которая их кормит. Хорошая работа, наёмник. Если не врёшь, конечно. Если врёшь, тогда я сам тебя найду.%SPEECH_OFF% | Вы находите %employer% в его кабинете, заваленном бумагами, и коротко докладываете об исходе дела. Когда вы заканчиваете, он вытирает лоб платком.%SPEECH_ON%Значит, все мертвы? Наёмник... ты понятия не имеешь, какой груз снял с моих плеч. Понятия не имеешь! Твои кроны, как обещал.%SPEECH_OFF%Он кладёт мешок на стол. Вы развязываете горловину и пересчитываете кроны - всё до последней монеты на месте. | Вы застаёте нанимателя в его кабинете, за столом, заставленным пустыми бутылками. %employer% отпивает из бокала и кивает.%SPEECH_ON%Знаешь, я не очень жалую вашего брата, но ты хорошо поработал. %randomname% доложил мне ещё до того, как ты сюда добрался, что все скавены перебиты. Это была чертовски хорошая работа. И, ну...%SPEECH_OFF%Он взваливает мешок на стол.%SPEECH_ON%Вот чертовски хорошая плата, как и обещал.%SPEECH_OFF% | Старый стул жалобно скрипит, когда %employer% откидывается на его спинку и складывает руки на коленях.%SPEECH_ON%Многие недолюбливают наёмников - убиваете, разрушаете деревни по малейшей прихоти. Но я признаю, ты сделал доброе дело.%SPEECH_OFF%Он кивает в угол, где стоит неоткрытый деревянный сундучок.%SPEECH_ON%Там всё. Не обижусь, если захочешь пересчитать.%SPEECH_OFF%Вы пересчитываете - всё сходится. | %employer% сосредоточенно рассматривает стол, заваленный грязными развёрнутыми свитками. Он тепло улыбается им, как будто воркует над кучей сокровищ.%SPEECH_ON%Торговые сделки повсюду! Счастливые фермеры! Счастливые семьи! Все счастливы! Ах, как хорошо быть мной. И, конечно, хорошо быть тобой, наёмник, потому что твои карманы стали тяжелее!%SPEECH_OFF%Он бросает вам небольшой кошелёк, затем другой и третий.%SPEECH_ON%Я бы заплатил одним большим мешком, но мне просто нравится так делать.%SPEECH_OFF%Он озорно бросает ещё один, который вы лениво ловите с невозмутимым видом человека, на мече которого ещё не засохла кровь.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Уничтожен лагерь скавенов");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы получаете [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] крон"
				});
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% поднимает взгляд от бумаг, когда вы входите в его кабинет. Вы бросаете на стол мешок с головой скавена и, усмехнувшись, указываете на него.%SPEECH_ON%Это - %ratgreyseer%.%SPEECH_OFF%%employer% встаёт и раскрывает горловину мешка, скрывающего ваш трофей. Он кивает.%SPEECH_ON%Ага, это и правда он. Полагаю, ты рассчитываешь на прибавку.%SPEECH_OFF%Он отсчитывает %reward% крон - обычную плату за уничтожение лагеря, да ещё щедро сверху за голову провидца, - и пересыпает монеты в кисет, который передает вам. | %employer% откидывается назад, когда вы входите в его комнату, держа голову серого провидца за шерсть. К счастью, кровь с неё не капает.%SPEECH_ON%Тут у нас %ratgreyseer%. Или вернее сказать \'был\'?%SPEECH_OFF%Медленно поднимаясь, %employer% окидывает вас беглым взглядом.%SPEECH_ON%Да, определённо \'был\'... Итак, ты не только уничтожил ту дыру, что служила убежищем скавенам, но ещё и принёс мне голову их провидца. Это прекрасная работа, наёмник, и твоя плата будет увеличена.%SPEECH_OFF%Он протягивает вам шкатулку, набитую золотом. %reward% крон. Затем достаёт свой кошель и бросает вам. | Вы поднимаете голову за окровавленную шерсть. %ratgreyseer% мёртв, но его глаза по-прежнему безучастно смотрят на комнату, пока вы держите его голову. %employer% улыбается.%SPEECH_ON%Тебе известно, что ты сделал, наёмник? Знаешь ли ты, какой гнёт снял с плеч местных жителей, снеся голову этого крыса с его плеч? И ты получишь больше, чем рассчитывал! %reward% крон за первоначальную задачу и...%SPEECH_OFF%Он выкладывает на стол увесистый кошелёк.%SPEECH_ON%Немного сверху, за тот... лишний вес, что пришлось тащить.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Заслуженная награда.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() * 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Уничтожен лагерь скавенов");
						this.World.Contracts.finishActiveContract();
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion() * 2;
				this.Contract.m.OriginalReward = this.Contract.m.Payment.getOnCompletion();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы получаете [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] крон"
				});
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"reward",
			this.m.Reward
		]);
		_vars.push([
			"original_reward",
			this.m.OriginalReward
		]);
		_vars.push([
			"ratgreyseer",
			this.m.Flags.get("RatGreyseerName")
		]);
		_vars.push([
			"totalenemy",
			this.m.Destination != null && !this.m.Destination.isNull() ? this.beautifyNumber(this.m.Destination.getTroops().len()) : 0
		]);
		_vars.push([
			"direction",
			this.m.Destination == null || this.m.Destination.isNull() || !this.m.Destination.isAlive() ? "" : this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Destination.getTile())]
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/rat_plague_outbreak_situation"));
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

		if (this.m.Home != null && !this.m.Home.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Home.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(4);
			}
		}
	}

	function onIsValid()
	{
		if (this.m.IsStarted)
		{
			if (this.m.Destination == null || this.m.Destination.isNull() || !this.m.Destination.isAlive())
			{
				return false;
			}

			return true;
		}
		else
		{
			return true;
		}
	}

	function onSerialize( _out )
	{
		_out.writeI32(0);

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
		_in.readI32();
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		this.contract.onDeserialize(_in);
	}

});

