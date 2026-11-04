//contract by village to destroy the closeby cultist base
this.drive_away_cultists_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		DestinationName = "",
		Dude = null,
		Reward = 0,
		OriginalReward = 0,
		Difficulty = 1.0
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.drive_away_cultists";
		this.m.Name = "Прогнать культистов";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}


	function setDifficultyBasedOnSize()
	{
		local size = this.m.Destination.m.Size
		if (size == 1) return this.Math.rand(70, 85) * 0.01
		else if (size == 2) return this.Math.rand(95, 105) * 0.01
		else return this.Math.rand(115, 135) * 0.01
	}

	function setDestination()
	{
	 	local settlements = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Cultists).getSettlements();
		foreach( settlement in settlements )
		{
			if ("TargetSettlement" in settlement.m && settlement.m.TargetSettlement != null && settlement.m.TargetSettlement.getID() == this.m.Home.getID())
			{
				this.m.Destination = this.WeakTableRef(settlement);
				this.m.DestinationName = this.m.Destination.getName()
				this.m.DifficultyMult = this.setDifficultyBasedOnSize()
				return
			}
		}
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
		return this.buildTextFromTemplate(this.Const.Strings.BanditLeaderNames[this.Math.rand(0, this.Const.Strings.BanditLeaderNames.len() - 1)], vars);
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.setDestination()
		this.m.Payment.Pool = (500 + (this.m.Destination.getSize()-1) * 200) * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Прогнать культистов из " + this.Contract.m.DestinationName + ", что %direction% от %origin%"
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
				this.Contract.m.Destination.m.Flags.set("ContractLocation", true)
				this.Contract.m.Destination.setLastSpawnTimeToNow();
				this.getCultists().recomputeFanatics(this.Const.World.Spawn.CultistDefenders)
				local resources = (90 + (this.Contract.m.Destination.getSize() - 1)  * 20) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult();
				this.printDebug(format("Ресурсы лагеря по контракту: %f масштабируемая разница: %f", resources.tofloat(), this.Contract.getScaledDifficultyMult().tofloat()), "mod_cultists");
				
				this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.CultistDefenders, resources);
				this.Contract.m.Destination.setLootScaleBasedOnResources(resources);
				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);

				local currentTile = this.World.State.getPlayer().getTile();
				//scale barbchance with how far north you are
				local barbChance = this.Math.floor(30  * (currentTile.SquareCoords.Y / this.World.getMapSize().Y) * (currentTile.SquareCoords.Y / this.World.getMapSize().Y))
				if (barbChance <= 5) barbChance = 0
				this.printDebug("шанс появления варваров" + barbChance, "mod_cultists")
				if (this.isDebug("mod_cultists")) barbChance = 100

				if (this.Math.rand(0, 100) < barbChance)
				{
					this.Flags.set("IsBarbarian", true);
					this.printDebug("установка варваров", "mod_cultists")
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
					if (this.Math.rand(1, 100) <= 5 && this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
					{
						this.Contract.setScreen("Volunteer1");
						this.World.Contracts.showActiveContract();
					}

					this.Contract.setState("Return");
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				if (this.Flags.get("IsBarbarian"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.printDebug("сквозь варваров", "mod_cultists")
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("Barbarian");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("BarbsHelping"))
					{
						local barbNum = 2 + this.Contract.m.Destination.m.Size
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "BarbariansHelp";
						p.IsAutoAssigningBases = false;
						for (local i = 0; i < 4; i++) {
							local unit = clone this.Const.World.Spawn.Troops.BarbarianMarauder
							unit.Faction <- this.Const.Faction.PlayerAnimals;
							unit.Name <- ""
							p.Entities.push(unit)
						}
						this.World.Contracts.startScriptedCombat(p, true, true, true);
						
					}
					else{
						this.World.Contracts.showCombatDialog();
					}
				}
				else {
				    this.World.Contracts.showCombatDialog();
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
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer% гневно расхаживает по комнате.%SPEECH_ON%Недавно культисты совершили набег на мои земли и увели немало хороших людей с собой в плен. %randomname%, сын местного охотника, пообещал мне найти их убежище, но, как оказалось, попался им и был принесён в жертву. Свидетелями убийства стали королевские егеря, перебившие всех культистов. Всех, кроме одного. Ублюдок долго молчал, но в конце-концов мы его раскололи. Так что теперь мы хотя бы знаем, откуда эти нелюди приходят.%SPEECH_OFF%Он усаживается в кресло и, скрестив пальцы, погружается в раздумья.%SPEECH_ON%Не буду тянуть, наёмник... У меня нет людей, но есть золото. А у тебя - наоборот. Как на счёт того, чтобы ты немного почистил мир от зла... заработав при этом денег?%SPEECH_OFF% | %employer% наливает себе немного вина. Он смотрит мгновение на чашу, после чего, устало хмыкнув, наполняет кубок до краёв. Так и не отпив, он обращается к вам.%SPEECH_ON%От рук фанатиков пал %randomname% и вся его семья. Вернее их не просто убили... Когда мы прибыли на пепелище, то обнаружили груду человеческих конечностей, сложенных в пирамиду. Вокруг были зажжены свечи и благовония... Веришь или нет, наёмник, но я тогда проблевался на всю жизнь... Не буду тянуть - я хочу, чтобы ты положил конец этому безумию. Отомстил за погибшую семью. Отомстил за мой желудок. Я уже потратил немало крон, чтобы найти их логово, и я готов потратить всё, что имею, чтобы это логово опустело.%SPEECH_OFF%Закончив свою речь, мужчина залпом осушает бокал вина и с выжидающим, уже плывущим взглядом, глядит на вас.%SPEECH_ON%Так что, возьмёшься за это дело?..%SPEECH_OFF% | %employer% смотрит в окно, водя пальцем по краю кубка, собираясь с мыслями.%SPEECH_ON%Разбойники угоняют наши драгоценные стада! Они приходят ночью и срезают у скотины колокольчики, чтобы не шуметь. Полагаю, тебе наплевать на скот, но телёнок, корова или бык - настоящее сокровище для людей в наших краях.\n\nТак вот, однажды я отправил паренька пройти по следу угнанных стад - и недавно он выяснил, где именно прячутся эти разбойники. Полагаю, ты догадываешься, что людей, способных перебить этих подонков, у меня нет, но вот золота... золота у меня достаточно. Так что, если я познакомлю твои руки с медью, согласишься ли ты познакомить этих разбойников со сталью?%SPEECH_OFF% | %employer% приветствует вас тяжелым вздохом. Судя по синякам под глазами, этот человек уже несколько дней не спал. Плеснув вам вина, мужчина заводит беседу. %SPEECH_ON%%randomname%, уважаемый человек в этих землях, заявил, что культисты наведывались к нему во двор. Говорили о тьме, что грядет. О мраке, что пожрёт недостойных. Разумеется, этих идиотов выгнали, но слова, сказанные ими, засели у него в голове. Не знаю, что он увидел, но с тех пор он ходит ко мне каждый день с требованиями избавить его от возможного визита этих безумцев. Он беспокоится, что же они сотворят в следующий раз. К счастью, этот человек довольно богат и с лёгкостью смог выследить этих подонков. Наёмник, я мало о чём прошу... Но не мог бы ты взяться за этих ублюдков? Денег у меня не много, но я отдам тебе всё, лишь бы эта история с культистами...закончилась счастливо.%SPEECH_OFF% | %employer% садится на стул, достаточно большой, чтобы его можно было считать троном. Не смотря на то, что человек явно пытается сохранить самообладание, дрожание рук с лихвой выдаёт охвативший его ужас.%SPEECH_ON%Фанатики держат в страхе округу уже несколько недель, а вчера они попытались поджечь храм! Можешь в это поверить?! Да кем надо быть, чтобы сотворить такое?! К счастью, мы вовремя его потушили, но если так и дальше пойдёт... Если они способны выступить против самого святого, то на что они ещё могут быть способны!? Впрочем, нам удалось узнать, где скрываются эти подонки. И поэтому... да, вижу, ты понимаешь. Это простая задача, наёмник: мы хотим, чтобы ты отправился туда и убил их всех, до последнего культиста. Готов поработать на нас?%SPEECH_OFF% | Когда вы входите в комнату, %employer% допивает чарку вина и выбрасывает её из окна. Вы слышите, как она грохочет где-то вдалеке. Он поворачивается к вам.%SPEECH_ON%Недавно на тракте мы нашли останки каравана одного купца. Его семья долго не могла понять, почему он задерживается, но когда наши разведчики нашли сломанные телеги с нетронутым добром, то сразу поняли, что это не простые бандиты. А после мне сказали, что наш купец - не единственный, кто пропадает на этих дорогах. И лишь Боги знают, сколько бы ещё людей пропало, но недавно %randomname%, сын кузнеца, тоже попался в руки этих ублюдков. Это были культисты. Хотели его принести в жертву той чертовщине, которой молятся. Но парень не из робких - побил ублюдков и смог убежать. И смог рассказать, где они обитают. Что ж, наёмник, я думаю ты уже понял, что я от тебя хочу. У %randomname% были только кулаки и желание жить. А у тебя есть меч и желание заработать - тоже неслабый стимул. Отправляйся к ним в логово и покажи этим безумцам, что золото, а не какой-то там Давкул, правит миром. %SPEECH_OFF% | Едва вы собираетесь присесть, %employer% бросает вам свиток. Как только вы его ловите, он разворачивается. Вы начинаете читать, но %employer% всё равно рассказывает новости.%SPEECH_ON%Торгаши из городка %randomtown% сговорились больше не поставлять в %townname% свои товары, пока наша маленькая проблема с фанатиками не будет устранена. Знаешь ли, торговлю немного губит распятые вдоль дороги освежёванные люди. Да и в целом, эти богохульные собаки должны умереть за свои злодеяния. Ладно там бродяги или нищета - их всегда хватает, они ведь как крысы. Но если в руки безумцев попадёт кто-то более влиятельный, то у меня могут начаться проблемы.\n\nЯ точно знаю, где они прячутся, и чтобы пойти и убить их мне нужен лишь человек со стальными яйцами, нуждающийся в славе... или золоте! Так что скажешь, наёмник? Назови свою цену, уверен, мы сможем договориться.%SPEECH_OFF% | %employer% вздрагивает, когда вы приветствуете его. Он практически кипит от злости, хотя, быть может, он просто в стельку пьян.%SPEECH_ON%Жители этого прекрасного города в ужасе! Почему? Потому что проклятые фанатики облюбовали наш дивный край! За свою жизнь я знавал войны, бунты, разбойничьи налёты... Но никогда не видел такой жестокости, какую несут эти ублюдки. Я человек смиренный и терпеливый, как и хотел мой покойный батюшка. Но сейчас я понял, что терпение не поможет нам защитить себя... теперь... теперь я желаю защититься, убив их всех.%SPEECH_OFF%Он покачнулся на мгновение, едва не рухнув на стол. Но, выпрямившись, продолжил.%SPEECH_ON%Разумеется, я хочу, чтобы ты умертвил этих бродячих псов. Всё, что требуется - твоя заинтересованность и... давай... назови свою цену.%SPEECH_OFF% | %employer% мрачно уставился в пол. Он разворачивает свиток, показывая вам лицо, изображённое на нём.%SPEECH_ON%Это %randomname%, безумец, которого мы схватили на днях. Он жестоко расправился с сиротами из местного приюта. Пытал их, после чего запер в сарае и сжёг заживо. И знаешь, что он ответил нам, когда мы спросили его, зачем же он это сделал? Он сказал, что это был приказ. Голос в его голове. Он сказал, что это только начало тех событий, что должны скоро обрушиться на наш многострадальный городок. Но знаешь что? Я не хочу, чтобы тут случилось что-то подобное ещё раз. Я нанял пару зрячих ребят, которые выяснили, откуда пришёл этот ублюдок. Теперь мне нужно, чтобы отправился туда и убил всех, кто, на твой взгляд, имеет нездоровые голоса в голове. Ну так что, по рукам?%SPEECH_OFF% | %employer% вежливо пододвигает вам свой стул когда вы ищите, куда бы присесть.%SPEECH_ON%Наёмник, позволь узнать, сколько времени прошло с тех пор, как ты в последний раз обагрял свой меч кровью злых, жестоких людей?%SPEECH_OFF%Он отбрасывает сарказм, а вы решаете, что лучше постоять.%SPEECH_ON%Мы, жители города %townname%, схлестнулись с местным культом, который внезапно стал похищать людей и проповедовать скорый приход неких тёмных сил. Конечно, культ этот существует здесь уже не первый год, так что для нас стала неожиданностью их внезапная агрессия. Они создали городку немалую проблему, наёмник. Ну а я решил, что лучший способ избавиться от этой проблемы - нанять нескольких вооружённых парней, вроде твоего отряда. Что скажешь, наёмник, возьмёшься решить нашу проблему, или же мне поискать более крутых ребят?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{О какой сумме мы говорим? | Сколько %townname% готов заплатить за свою безопасность? | Поговорим об оплате.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Не интересно. | У нас есть более важные дела. | Желаю вам удачи, но мы не будем в этом участвовать.}",
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
			ID = "Barbarian",
			Title = "В логове",
			Text = "[img]gfx/ui/events/event_54.png[/img]{Вы пробираетесь к краю рощи, чтобы разведать обстановку. Как вы и ожидали, культисты вовсю занимаются укреплением своего лагеря, закапывая деревянные колышки и рисуя на них нечестивые обереги. Чего вы не ожидали - так это того, что рядом с вами вдруг возникнет невысокий варвар, всего лишь в два метра ростом. Позади него замерли ещё несколько воинов, однако, судя по всему, они пришли сюда не по вашу душу.%SPEECH_ON%Наш король направил нас на охоту за слугами зла, но, как я вижу, загонять их мы будем не в одиночку. Наёмник, будешь ли ты сражаться вместе с нами?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Почту за честь сражаться бок о бок с вами!",
					function getResult()
					{
					    this.Flags.set("BarbsHelping", true)
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
					}

				},
			    {
			        Text = "Лучше не высовывайтесь, мы справимся и без вашей помощи!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
					}
                }
			],
			function start( )
			{
			}
		});



		this.m.Screens.push({
			ID = "Volunteer1",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Как только шум битвы стихает, вы замечаете культиста, пытающегося сбежать.  Ваши бойцы быстро преграждают ему дорогу, но тот, вместо того, чтобы кинуться в бой просто сбрасывает свой капюшон и тесак наземь, а после падает к вашим ногам.%SPEECH_ON%Пощады! Я не с этими фанатиками! Я попал к ним в плен после того, как они перебили мою секту! Мы были прогрессивными последователями Давкула, следовали новым учениям, в которых пытки людей заменены на пытки животных. Кошечки там, собачки...  Пожалуйста, позвольте мне присоединиться к вам, дабы наказать этих еретиков!%SPEECH_OFF%",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Твои слова безумны, но ты всё же лучше их. Можешь пойти с нами.",
					function getResult()
					{
						return "Volunteer2";
					}

				},
				{
					Text = "Пошёл прочь, безумец, пока я не передумал.",
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
				this.Contract.m.Dude.setStartValuesEx([
					"cultist_background"
				]);
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
			Text = "[img]gfx/ui/events/event_22.png[/img]{Он вливается в ваши ряды, исчезая в толпе братьев, которые, принимают его достаточно тепло для группы наёмных убийц. Новичок похваляется, что хорошо обращается со всеми видами оружия, но вы полагаете, что сами способны решить, чем он там владеет. | Пленник улыбается от уха до уха, когда вы его приглашаете. Несколько братьев спрашивают, какое оружие ему дать, но вы пожимаете плечами и отвечаете, что решите позже, чем его вооружить.}",
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
			Text = "[img]gfx/ui/events/event_22.png[/img]{Вы качаете головой, незнакомец хмурится.%SPEECH_ON%Ты уверен? Я весьма неплохо управляюсь с...%SPEECH_OFF%Вы прерываете его.%SPEECH_ON%Не сомневаюсь. А теперь уходи. И оставь животных в покое.%SPEECH_OFF%",
			Image = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Можешь идти.",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{Кажется, что не только ваш наниматель, но и весь %townname% находится в предвкушении новостей от вас. Но вы не привыкли много болтать о своих делах, и потому отчёт ваш содержит лишь скупой факт: все культисты мертвы, оставшиеся в живых пленники освобождены. %employer% кивает и улыбается, прежде чем передать обещанную плату.%SPEECH_ON%Хорошая работа, наёмник. Эти негодяи доставляли нам немало хлопот.%SPEECH_OFF% | Когда вы подходите к дому нанимателя, %employer% сам открывает перед вами дверь. В руках он держит кошель, иногда подбрасывая его.%SPEECH_ON%Я так понимаю, раз вы вернулись - культисты мертвы, так?%SPEECH_OFF%Вы киваете. Он протягивает кошель вам. Вы говорите, что могли солгать. %employer% пожимает плечами.%SPEECH_ON%Быть может, но слова быстро летят по миру, особенно если не жалеть на это золота. Хорошая работа, наёмник. Если ты, конечно, не лжёшь. Тогда я найду тебя.%SPEECH_OFF% | %employer% усмехается, когда вы входите в его кабинет и опускаете на стол перед ним голову в мешке.%SPEECH_ON%Не обязательно было пачкать мою мебель, чтобы доказать выполнение задания, наёмник. Я уже получил вести о твоих успехах, ведь птицы в наше время летают быстро, не правда ли? Твоя плата в том углу.%SPEECH_OFF% | Выслушав ваш отчёт, %employer% вытирает лоб платком.%SPEECH_ON%Неужели они все наконец мертвы? Парень... ты понятия не имеешь, какой груз снял с моих плеч. Даже близко не представляешь! Твои кроны, как я и обещал.%SPEECH_OFF%Он опускает на стол кошель, а вы немедленно его забираете. Всё верно, как и было обещано. | %employer% отхлёбывает из кубка и кивает.%SPEECH_ON%Знаешь, я не жалую вашего брата, но ты хорошо поработал, наёмник. %randomname% сообщил мне, ещё до того как ты пришёл, что все культисты убиты. Это была очень хорошая работа, по его словам. И, как договаривались...%SPEECH_OFF%Он кладёт на стол кошель.%SPEECH_ON%Здесь очень хорошая плата.%SPEECH_OFF% | %employer% откидывается в своём кресле, опустив руки на колени.%SPEECH_ON%Наёмники плохо уживаются с людьми, из-за того, как я полагаю, что по мимолётной прихоти вырезают и сжигают целые деревни, но не могу не признать, что ты хорошо справился с работой.%SPEECH_OFF%Он указывает в угол комнаты, где находится запертый деревянный сундук.%SPEECH_ON%Тут всё, но я не обижусь, если ты вдруг решишь пересчитать.%SPEECH_OFF%Вы пересчитываете, тут действительно всё. | %employer% сидит за столом, покрытым пыльными свитками. Но улыбается он так, словно перед ним лежит груда сокровищ.%SPEECH_ON%Барыш! Торговля процветает! Счастливые фермеры! Счастливые семьи! Все счастливы! Ах, как хорошо быть мной. И, конечно, хорошо быть тобой, наёмник, потому что твои карманы сейчас станут немного тяжелее!%SPEECH_OFF%Он бросает вам под ноги небольшой кошель, затем ещё один и ещё.%SPEECH_ON%Я бы мог сунуть деньги в один большой мешок, но мне просто нравится так делать.%SPEECH_OFF%Он нахально бросает очередной кошелёк, который вы небрежно ловите, приняв вид человека, меч которого всё ещё покрыт тёплой кровью.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Уничтожил лагерь культистов");
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
			"totalenemy",
			this.m.Destination != null && !this.m.Destination.isNull() ? this.beautifyNumber(this.m.Destination.getTroops().len()) : 0
		]);
		_vars.push([
			"direction",
			this.m.Destination == null || this.m.Destination.isNull() || !this.m.Destination.isAlive() ? "" : this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Destination.getTile())]
		]);
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.m.Flags.set("ContractLocation", false)
				this.m.Destination.getSprite("selection").Visible = false;
				this.m.Destination.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
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
		 	local settlements = this.getCultists().getLairs();
		 	local index = 1;
			foreach( settlement in settlements )
			{
				if ("TargetSettlement" in settlement.m && settlement.m.TargetSettlement != null && settlement.m.TargetSettlement.getID() == this.m.Home.getID())
				{
					this.setDestination()
					return true
				}
			}
			return false
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
			this.m.DestinationName = this.m.Destination.getName()
		}

		this.contract.onDeserialize(_in);
	}

});

