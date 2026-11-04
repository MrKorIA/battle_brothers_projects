this.drive_away_wushi_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Dude = null,
		Reward = 0,
		OriginalReward = 0
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.drive_away_wushi";
		this.m.Name = "Прогнать Вокоу";
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
		return this.buildTextFromTemplate(this.Const.Strings.SamuraiLeaderNames[this.Math.rand(0, this.Const.Strings.SamuraiLeaderNames.len() - 1)], vars);
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		local banditcamp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Wushi).getNearestSettlement(this.m.Home.getTile());
		this.m.Destination = this.WeakTableRef(banditcamp);
		this.m.Flags.set("DestinationName", banditcamp.getName());
		this.m.Flags.set("RobberBaronName", this.generateName());
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
					"Изгнать иноземных воинов из местечка " + this.Flags.get("DestinationName") + " к %direction% от поселения %origin%"
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

				this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.WushiDefenders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setLootScaleBasedOnResources(110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Destination.setResources(this.Math.min(this.Contract.m.Destination.getResources(), 70 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult()));
				this.Contract.m.Destination.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);

				if (this.World.Assets.getBusinessReputation() >= 500 && this.Contract.getDifficultyMult() >= 0.95 && this.Math.rand(1, 100) <= 20)
				{
					this.Flags.set("IsRobberBaronPresent", true);

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
					if (this.Flags.get("IsRobberBaronDead"))
					{
						this.Contract.setScreen("RobberBaronDead");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Math.rand(1, 100) <= 10)
					{
						this.Contract.setScreen("Survivors1");
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
				if (this.Flags.get("IsRobberBaronPresent"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("AttackRobberBaron");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.Music = this.Const.Music.WushiTracks;
						properties.Entities.push({
							ID = this.Const.EntityType.Wushi,
							Variant = 200,
							Row = 2,
							Script = "scripts/entity/tactical/humans/wushi",
							Faction = _dest.getFaction(),
							Callback = this.onRobberBaronPlaced.bindenv(this)
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

			function onRobberBaronPlaced( _entity, _tag )
			{
				_entity.getFlags().set("IsRobberBaron", true);
				_entity.setName(this.Flags.get("RobberBaronName"));
			}

			function onActorKilled( _actor, _killer, _combatID )
			{
				if (_actor.getFlags().get("IsRobberBaron") == true)
				{
					this.Flags.set("IsRobberBaronDead", true);
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
					if (this.Flags.get("IsRobberBaronDead"))
					{
						this.Contract.setScreen("Success2");
					}
					else
					{
						this.Contract.setScreen("Success1");
					}

					this.World.Contracts.showActiveContract();
				}

				if (this.Flags.get("IsRobberBaronDead") && this.Flags.get("IsBountyHunterPresent") && !this.TempFlags.get("IsBountyHunterTriggered") && this.World.Events.getLastBattleTime() + 7.0 < this.Time.getVirtualTimeF() && this.Math.rand(1, 1000) <= 2)
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
					this.Flags.set("IsRobberBaronDead", false);
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
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer% сердито качает головой.%SPEECH_ON%Разбойники слишком долго разоряли эти земли. Я отправил лазутчика, чтобы найти их. И знаешь что? Вернулась только его голова. Правда, эти недоумки послали одного из своих, чтобы доставить её, так что мы схватили и допросили этого негодяя... и теперь нам известно, где их логово.%SPEECH_OFF%Он откидывается назад в своём кресле и, скрестив пальцы, погружается в раздумья.%SPEECH_ON%У меня нет воинов, но есть золото. Что скажешь, если моё золото окажется в твоих руках, а твой меч - в их брюхе?%SPEECH_OFF% | %employer% наливает себе вина, смотрит на кубок, доливает ещё. Осушив его одним глотком, он извергает новости.%SPEECH_ON%От рук разбойников пал %randomname%. И вся его семья. Можешь поверить в это? Ты его, разумеется, не знаешь, но их род был уважаем в этих землях. Так что можешь представить, что я хочу сделать с теми разбойниками. Половина моих людей погибла, пытаясь отыскать их лагерь, но зато теперь я готов отдать полови... часть своего золота, чтобы ты убил их. Интересует?%SPEECH_OFF% | %employer% смотрит в окно, водя пальцем по краю кубка, собираясь с мыслями.%SPEECH_ON%Разбойники угоняют наши драгоценные стада! Они приходят ночью и срезают у скотины колокольчики, чтобы не шуметь. Полагаю, тебе наплевать на скот, но телёнок, корова или бык - настоящее сокровище для людей в наших краях.\n\nТак вот, однажды я отправил паренька пройти по следу угнанных стад - и недавно он выяснил, где именно прячутся эти разбойники. Полагаю, ты догадываешься, что людей, способных перебить этих подонков, у меня нет, но вот золота... золота у меня достаточно. Так что, если я познакомлю твои руки с медью, согласишься ли ты познакомить этих разбойников со сталью?%SPEECH_OFF% | %employer% тяжело вздыхает, словно устав от всех этих неприятностей, словно он уже не раз заводил этот разговор.%SPEECH_ON%%randomname%, уважаемый человек в этих землях, заявил, что разбойники наведывались к его дочерям. Он беспокоится, что же они сотворят в следующий раз. К счастью, этот человек довольно богат и с лёгкостью смог выследить этих подонков. Если бы я заплатил тебе приличную сумму, согласился бы ты проткнуть своим мечом пару разбойников?%SPEECH_OFF% | %employer% садится на стул, достаточно большой, чтобы вместить двоих. Он перекатывает кружку по столу.%SPEECH_ON%Разбойники держат в страхе округу уже несколько недель, а вчера они попытались поджечь таверну! Можешь в это поверить?! Да кем надо быть, чтобы сотворить такое?! К счастью, мы вовремя её потушили, но если так и дальше пойдёт... Если уж они угрожают нашему драгоценному напитку, на что они ещё способны? Впрочем, нам удалось узнать, где скрываются эти подонки. И поэтому... да, вижу, ты понимаешь. Это простая задача, наёмник: мы хотим, чтобы ты отправился туда и убил их всех, до последнего бандита. Готов поработать на нас?%SPEECH_OFF% | Когда вы входите в комнату, %employer% допивает чарку вина и выбрасывает её из окна. Вы слышите, как она грохочет где-то вдалеке. Он поворачивается к вам.%SPEECH_ON%На тракте, разбойники налетели на мою повозку и отобрали все товары! Мне осталась лишь моя жизнь, что, разумеется, хорошо, но досада на то, что они сделали, не даёт мне спать по ночам. Я вижу их ухмыляющиеся рожи... слышу их хохот... Думаю, это было их посланием, ведь я отказался платить \'пошлину\'. Что ж, теперь я готов заплатить эту пошлину. Тебе, наёмник. Если ты пойдёшь и убьёшь этих подонков, я немало заплачу. Что скажешь?%SPEECH_OFF% | Едва вы собираетесь присесть, %employer% бросает вам свиток. Как только вы его ловите, он разворачивается. Вы начинаете читать, но %employer% всё равно рассказывает новости.%SPEECH_ON%Торгаши из городка %randomtown% сговорились больше не поставлять в %townname% свои товары, пока наша маленькая проблема с разбойниками не будет устранена. История эта довольно проста, так как, я уверен, ты знаешь методы разбойников: эти проклятые бездельники шастают по дорогам, грабят караваны и убивают торговцев.\n\nЯ точно знаю, где они прячутся, и чтобы пойти и убить их мне нужен лишь человек со стальными яйцами, нуждающийся в славе... или золоте! Так что скажешь, наёмник? Назови свою цену, уверен, мы сможем договориться.%SPEECH_OFF% | %employer% дрожит, когда вы приветствуете его. Он практически кипит от злости, хотя, быть может, он просто в стельку пьян.%SPEECH_ON%Жители этого прекрасного города голодают. Почему? Потому что разбойники пробираются ночами и грабят амбары! А если мы ловим их, они пытаются поджечь город! Ныне терпение не поможет нам защитить себя... теперь... теперь я желаю защититься, убив их всех.%SPEECH_OFF%Он покачнулся на мгновение, едва не рухнув на стол. Но, выпрямившись, продолжил.%SPEECH_ON%Разумеется, я хочу, чтобы ты умертвил этих бродячих псов. Всё, что требуется - твоя заинтересованность и... давай... назови свою цену.%SPEECH_OFF% | %employer% мрачно уставился в землю. Он разворачивает свиток, показывая вам лицо, изображённое на нём.%SPEECH_ON%Это %randomname%, разбойник, которого мы схватили на днях. Он раньше возглавлял банду бродяг, днём и ночью разорявших и грабивших наш город. Проблема в том, что их главари подобны головам гидры, убьёшь одного - на его месте тут же появляется другой. Каково же решение? Что же, ответ прост, нужно убить их ВСЕХ. И именно это мне и нужно от тебя, наёмник. Интересуешься?%SPEECH_OFF% | %employer% поворачивается к вам, когда вы ищете, куда бы присесть.%SPEECH_ON%Эй, наёмник, сколько времени прошло с тех пор, как ты в последний раз обагрял свой меч кровью злых, жестоких людей?%SPEECH_OFF%Он отбрасывает сарказм, а вы решаете, что лучше постоять.%SPEECH_ON%Мы, жители города %townname%, схлестнулись с местными разбойниками. Именно местными, то есть их вонючее логово неподалёку отсюда. Так что я решил, что лучший способ избавиться от этой проблемы - нанять нескольких вооружённых парней, вроде твоего отряда доброделов. Что скажешь, наёмник, возьмёшься решить нашу проблему, или же мне поискать более крутых ребят?%SPEECH_OFF%}",
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
			ID = "AttackRobberBaron",
			Title = "Перед атакой...",
			Text = "[img]gfx/ui/events/event_54.png[/img]{Наблюдая за лагерем разбойников, вы замечаете фигуру человека, которого легко можно узнать по взволнованным описаниям местных жителей: это %robberbaron%, знаменитый главарь разбойников, разоряющих эти земли. За ним повсюду следует целая свита жестоких ублюдков.\n\nВы готовы биться об заклад, что его голова будет стоить немало монет. | Вы и не предполагали его встретить, но в лагере разбойников, без сомнений, %robberbaron%, собственной персоной. Известный убийца по всей видимости посещает одну из своих шаек, внимательно осматривая бандитов, указывая пальцем то на одно, то на другое и делая замечания о качестве и того и этого.\n\nНесколько телохранителей следуют за ним повсюду. Вы оцениваете, что вместе с ним и остальными разбойниками будет около %totalenemy% врагов. | Контракт заключался в том, чтобы уничтожить разбойников, но, похоже, в их полку прибыло ещё одним, гораздо более крупным фруктом: в лагере находится %robberbaron%, известный убийца и грабитель. Сопровождаемый телохранителем, главарь разбойников, похоже, осматривает один из своих преступных филиалов.\n\nВы задаётесь вопросом: сколько же крон будет стоить %robberbaron% без головы... | %robberbaron%. Это он, вы точно знаете. Взглянув через подзорную трубу, вы можете легко различить силуэт пресловутого главаря разбойников, расхаживающего по бандитскому лагерю. Его не было в ваших планах, он не упоминался и в контракте, но нет сомнений в том, что если вы принесёте его голову в город, то получите немного больше деньжат. | Наблюдая за разбойниками, вы насчитываете %totalenemy% человек. А ещё вы замечаете того, кого никак не ожидали увидеть: %robberbaron%, печально известный главарь разбойников. Со своим телохранителем он, видимо, проверяет этот лагерь.\n\nКакая удача! Если вы сможете принести его голову вашему нанимателю, то заслужите дополнительную плату!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Приготовиться к бою!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "RobberBaronDead",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Битва закончена, вы подходите к мёртвому телу того, кто был известен под именем \'%robberbaron%\' и отрезаете голову двумя быстрыми ударами меча, рассекая сначала мясо, а затем и кости. Затем вы через рот вставляете крюк и привязываете верёвку, чтобы прикрепить трофей к поясу. | Когда битва закончилась, вы быстро находите тело главаря разбойников среди мертвецов. С виду %robberbaron% ещё грозен, хотя кожа его уже начинает бледнеть. Он страшен даже после того, как вы отделили голову от тела и, хоть вы и не видите его лица, когда бросаете голову в мешок, но уверены, что оно всё ещё выглядит жутко злым. | %robberbaron% лежит мёртвым у ваших ног. Вы переворачиваете его и выпрямляете шею, чтобы легче было перерубить её мечом. Для отсечения головы, которую вы быстро убираете в мешок, требуется всего два мощных удара. | Теперь, мёртвым, %robberbaron% внезапно напоминает вам многих людей, которых вы знали. Вы не долго предаётесь воспоминаниям, несколькими быстрыми ударами меча вы отрубаете его голову и бросаете её в мешок. | %robberbaron% дал хороший бой, а его шея - ещё один: сухожилия и кости не позволяют голове легко отделиться, когда вы пытаетесь забрать свою награду. | %robberbaron% пожертвовал вам свою голову. %randombrother% указывает на неё, когда вы проходите мимо.%SPEECH_ON%Это кто? %robberbaron%, что ли?%SPEECH_OFF%Вы качаете головой.%SPEECH_ON%Неа, теперь это обычный труп. А вот его голова принесён нам несколько лишних крон.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Мы выдвигаемся!",
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
			Text = "[img]gfx/ui/events/event_07.png[/img]{На обратном пути несколько человек перегораживают вам дорогу. Один из них указывает на голову того, кто раньше был известен как %robberbaron%.%SPEECH_ON%Мы - лучшие охотники за головами в этих краях и, как я понимаю, вы сейчас занялись не своим делом. Отдайте голову нам, и сможете сегодня спокойно спать в своих кроватках.%SPEECH_OFF%Вы смеётесь.%SPEECH_ON%Тебе придётся придумать историю получше. Мёртвый %robberbaron% стоит немало крон, друг мой.%SPEECH_OFF%Командир этих \'охотников за головами\' тоже смеётся. Он поднимает мешок с чем-то круглым внутри.%SPEECH_ON%Это - %randomname%, один из самых разыскиваемых парней в этих краях. А это...%SPEECH_OFF%Он поднимает другой мешок.%SPEECH_ON%А это голова человека, который его убил. Понимаешь, к чему я веду? Итак, отдай голову, и мы все сможем продолжить путь.%SPEECH_OFF% | Незнакомец выходит на дорогу, расправляет плечи и указывает на вас.%SPEECH_ON%Здравствуйте, господа хорошие. Похоже, %robberbaron% отдал вам свою голову.%SPEECH_OFF%Вы киваете. Он улыбается.%SPEECH_ON%Не будете ли вы столь любезны передать её мне?%SPEECH_OFF%Вы смеётесь и качаете головой. Незнакомец больше не улыбается, вместо этого он поднимает руку и щёлкает пальцами. Тотчас отряд вооружённых людей появляется из близлежащих зарослей, выходя на дорогу под тяжёлый металлический лязг. Они словно списаны с мечты смертника в ночь перед казнью. Их лидер озаряет вас золотозубой усмешкой.%SPEECH_ON%Повторять не буду.%SPEECH_OFF% | Вашу беседу с одним из наёмников прерывает громкий крик. Вы переводите взгляд на дорогу, замечая группу людей, преграждающих вам путь. Их главарь выходит вперёд, объявляя, что они - знаменитые охотники за головами.%SPEECH_ON%Наше единственное желание - получить голову того, кто известен под именем \'%robberbaron%\'.%SPEECH_OFF%Вы пожимаете плечами.%SPEECH_ON%Мы убили его, нам же и принадлежит его голова. Убирайся с нашего пути.%SPEECH_OFF%Как только вы шагнули вперёд, охотники за головами поднимают своё оружие. Их командир делает один шаг к вам.%SPEECH_ON%Неверный выбор приведёт к смерти многих хороших людей. Знаю, это непросто, но я предлагаю тебе ещё раз тщательно всё обдумать.%SPEECH_OFF% | Резкий свист привлекает ваше внимание. Вы переводите взгляд на обочину, замечая группу людей, появившихся из кустов. Все обнажают оружие, но незнакомцы останавливаются. Их главарь движется вперёд. Его грудь украшает ожерелье из ушей - символ его свершений.%SPEECH_ON%Привет, ребята. Мы, если вы не знали, охотники за головами и, похоже, у вас наша добыча.%SPEECH_OFF%Вы поднимаете голову, что раньше откликалась на имя %robberbaron%.%SPEECH_ON%Не его ли имеешь в виду?%SPEECH_OFF%Главарь тепло улыбается.%SPEECH_ON%Конечно. Вы очень порадуете меня и моих друзей, если отдадите то, что нам так нужно.%SPEECH_OFF%Он опускает руку на рукоять меча и усмехается.%SPEECH_ON%Просто работа, ничего личного. Уверен, вы понимаете.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Забирай эту проклятую голову и убирайся.",
					function getResult()
					{
						this.Flags.set("IsRobberBaronDead", false);
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
						p.Music = this.Const.Music.BanditTracks;
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "BountyHunters";
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.BountyHunters, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BountyHunters2",
			Title = "По пути...",
			Text = "[img]gfx/ui/events/event_07.png[/img]Для одного дня вы видели слишком много крови, вы отдаёте голову.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Двигаемся дальше. Нам ещё предстоит получить плату.",
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
			Text = "[img]gfx/ui/events/event_07.png[/img]Охотники за головами слишком сильны, отряду \'%companyname%\' не справится с ними. Не желая, чтобы ваши люди были без нужды убиты, вы приказываете спешно отступить. К сожалению, голова мерзавца, коего знали под именем %robberbaron%, была утеряна в суматохе...",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Ну и ладно. Нас всё ещё ждёт плата.",
					function getResult()
					{
						this.Flags.set("IsBountyHunterRetreat", false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Survivors1",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Когда битва заканчивается, несколько противников опускаются на колени и умоляют о пощаде. %randombrother% смотрит на вас, ожидая вашего решения. | После битвы ваши люди окружают выживших разбойников. Бандиты умоляют не забирать их жизни. Тише всех ведёт себя человек, больше похожий на ребёнка, чем на взрослого мужчину. | Признавая своё поражение, несколько оставшихся в живых разбойников бросают оружие и просят пощады. Теперь вы задаётесь вопросом: что делать с этими отбросами? | Бой закончен, но тяжёлый выбор ещё впереди: несколько разбойников пережили битву, их жизнь в ваших руках. %randombrother% стоит над одним из них, держа меч у шеи пленного, и ждёт вашего решения.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Перережьте им глотки.",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-1);
						return "Survivors2";
					}

				},
				{
					Text = "Отберите оружие и прогоните их.",
					function getResult()
					{
						this.World.Assets.addMoralReputation(2);
						return "Survivors3";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Survivors2",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Доброта - удел наивных дураков. Вы безжалостно убиваете пленников. | Вы вспоминаете, как разбойники убивали беззащитных торговцев. Эти кровавые сцены прокручиваются в вашей голове снова и снова. И вы отдаёте приказ казнить пленников. Разбойники пытаются протестовать, но замолкают под ударами мечей и копий. | Вы отворачиваетесь.%SPEECH_ON%Перережьте им глотки. И быстро.%SPEECH_OFF%Наёмники выполняют приказ и вы слышите стоны умирающих людей. Но люди умирают, не так быстро, как хотелось бы. | Вы качаете головой. Пленники кричат, но ваши люди уже наготове, рубя, режа и круша. Некоторые счастливчики лишаются голов прежде, чем успевают осознать близость своей кончины. Те, кто пытается оказать сопротивление, страдают до самого конца. | Милосердие требует времени. Времени оглянуться назад. Времени подумать о правильности своих решений. Но у вас нет этого времени. Вы никого не щадите. Пленных казнят - и времени на это уходит совсем немного.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "У нас есть более важные дела.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Survivors3",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{На сегодня уже достаточно убийств и смертей. Вы отпускаете пленников, забрав их оружие и доспехи. | Воры и бандиты не часто встречаются с милосердием, поэтому, когда вы отпускаете их, они чуть ли не целуют ваши ноги. | Вы недолго думаете, затем киваете.%SPEECH_ON%Помилованы. Отберите у них оружие - и пусть проваливают.%SPEECH_OFF%Пленных отпускают, лишив оружия и доспехов. | Оставив разбойников в одном исподнем - у кого таковое было - вы их отпускаете. %randombrother% роется в куче хлама, оставшегося после них, а вы смотрите, как группа полуобнажённых людей спешит удрать подальше.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Нам не платили за их убийство.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Volunteer1",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Как только битва заканчивается и всё стихает, вы слышите крик. Вы идёте на шум и находите человека, бывшего пленником у этих разбойников. Вы быстро перерезаете верёвки, которыми были связаны его рот и руки. Переведя дыхание, пленник смиренно спрашивает, может ли он присоединиться к вашему отряду. | Вы находите связанного пленника в лагере разбойников. Освободившись от пут, он объясняет, что родом из города %randomtown% и был похищен бродягами всего несколько дней назад. Он спрашивает, можно ли ему присоединиться к вашему отряду. | Перерывая то, что осталось от лагеря разбойников, вы обнаруживаете пленника. Освобождённый мужчина садится и объясняет, что разбойники похитили его, когда он ехал в город %randomtown% в поисках работы. Вы же интересуетесь, почему бы ему не поработать на вас? | После битвы в живых остался лишь один человек. Но не разбойник, а их пленник. Когда вы интересуетесь его прошлым, выясняется, что он из города %randomtown% и ищет работу. Вы спрашиваете, может ли он держать меч. Тот кивает.}",
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
			Text = "[img]gfx/ui/events/event_22.png[/img]{Он вливается в ваши ряды, исчезая в толпе братьев, которые, похоже, принимают его достаточно тепло для группы наёмных убийц. Новичок похваляется, что хорош со всеми видами оружия, но вы полагаете, что сами способны решить, чем он там владеет. | Пленник улыбается от уха до уха, когда вы его приглашаете. Несколько братьев спрашивают, какое оружие ему дать, но вы пожимаете плечами и отвечаете, что решите позже, чем его вооружить.}",
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
			Text = "[img]gfx/ui/events/event_22.png[/img]{Вы качаете головой, незнакомец хмурится.%SPEECH_ON%Ты уверен? Я весьма неплохо управляюсь с...%SPEECH_OFF%Вы прерываете его.%SPEECH_ON%Не сомневаюсь. А теперь иди, наслаждайся новообретённой свободой, незнакомец.%SPEECH_OFF% | Вы присматриваетесь к нему и решаете, что он не годится для наёмной жизни.%SPEECH_ON%Мы ценим твоё предложение, незнакомец, но жизнь наёмника опасна. Иди домой к своей семье, своей работе.%SPEECH_OFF% | У вас сейчас достаточно людей, хотя вы с трудом удерживаетесь от искушения прогнать пару человек, просто чтобы посмотреть на их удивлённые рожи. Вместо этого, вы пожимаете руку освобождённого пленника и желаете ему доброго пути. Несмотря на разочарование, он благодарит вас за освобождение.}",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{Кажется, что не только ваш наниматель, но и весь %townname% находится в предвкушении новостей от вас. Но вы не привыкли много болтать о своих делах, и потому отчёт ваш содержит лишь скупой факт: все разбойники мертвы. %employer% кивает и улыбается, прежде чем передать обещанную плату.%SPEECH_ON%Хорошая работа, наёмник. Эти негодяи доставляли нам немало хлопот.%SPEECH_OFF% | Когда вы подходите к дому нанимателя, %employer% сам открывает перед вами дверь. В руках он держит кошель, иногда подбрасывая его.%SPEECH_ON%Я так понимаю, раз вы вернулись - разбойники мертвы, так?%SPEECH_OFF%Вы киваете. Он протягивает кошель вам. Вы говорите, что могли солгать. %employer% пожимает плечами.%SPEECH_ON%Быть может, но слова быстро летят по миру, особенно если не жалеть на это золота. Хорошая работа, наёмник. Если ты, конечно, не лжёшь. Тогда я найду тебя.%SPEECH_OFF% | %employer% усмехается, когда вы входите в его кабинет и опускаете на стол перед ним голову в мешке.%SPEECH_ON%Не обязательно было пачкать мою мебель, чтобы доказать выполнение задания, наёмник. Я уже получил вести о твоих успехах, ведь птицы в наше время летают быстро, не правда ли? Твоя плата в том углу.%SPEECH_OFF% | Выслушав ваш отчёт, %employer% вытирает лоб платком.%SPEECH_ON%Неужели они все наконец мертвы? Парень... ты понятия не имеешь, какой груз снял с моих плеч. Даже близко не представляешь! Твои кроны, как я и обещал.%SPEECH_OFF%Он опускает на стол кошель, а вы немедленно его забираете. Всё верно, как и было обещано. | %employer% отхлёбывает из кубка и кивает.%SPEECH_ON%Знаешь, я не жалую вашего брата, но ты хорошо поработал, наёмник. %randomname% сообщил мне, ещё до того как ты пришёл, что все разбойники убиты. Это была очень хорошая работа, по его словам. И, как договаривались...%SPEECH_OFF%Он кладёт на стол кошель.%SPEECH_ON%Здесь очень хорошая плата.%SPEECH_OFF% | %employer% откидывается в своём кресле, опустив руки на колени.%SPEECH_ON%Наёмники плохо уживаются с людьми, из-за того, как я полагаю, что по мимолётной прихоти вырезают и сжигают целые деревни, но не могу не признать, что ты хорошо справился с работой.%SPEECH_OFF%Он указывает в угол комнаты, где находится запертый деревянный сундук.%SPEECH_ON%Тут всё, но я не обижусь, если ты вдруг решишь пересчитать.%SPEECH_OFF%Вы пересчитываете, тут действительно всё. | %employer% сидит за столом, покрытым пыльными свитками. Но улыбается он так, словно перед ним лежит груда сокровищ.%SPEECH_ON%Барыш! Торговля процветает! Счастливые фермеры! Счастливые семьи! Все счастливы! Ах, как хорошо быть мной. И, конечно, хорошо быть тобой, наёмник, потому что твои карманы сейчас станут немного тяжелее!%SPEECH_OFF%Он бросает вам под ноги небольшой кошель, затем ещё один и ещё.%SPEECH_ON%Я бы мог сунуть деньги в один большой мешок, но мне просто нравится так делать.%SPEECH_OFF%Он нахально бросает очередной кошелёк, который вы небрежно ловите, приняв вид человека, меч которого всё ещё покрыт тёплой кровью.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Уничтожил лагерь разбойников");
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{Вы бросаете голову бандита на стол нанимателя. С усмешкой указываете на неё.%SPEECH_ON%Это - %robberbaron%.%SPEECH_OFF%%employer% встаёт и раскрывает горловину мешка, скрывающего ваш трофей. Он кивает.%SPEECH_ON%Ага, это и правда он. Полагаю, ты рассчитываешь на прибавку.%SPEECH_OFF%Вам выплачивается сумма в %reward% крон за убийство разбойников, а также уничтожение главаря многих местных банд. | %employer% откидывается назад, когда вы входите в его комнату, неся голову за волосы. К счастью, кровь с неё не капает.%SPEECH_ON%Тут у нас %robberbaron%. Или вернее сказать \'был\'?%SPEECH_OFF%Медленно поднимаясь, %employer% окидывает вас беглым взглядом.%SPEECH_ON%Да, определённо \'был\'... Итак, ты не только уничтожил ту дыру, что служила убежищем разбойникам, но ещё и принёс мне голову их главаря. Это прекрасная работа, наёмник, и твоя плата будет увеличена.%SPEECH_OFF%Он протягивает вам шкатулку, набитую золотом. %original_reward% крон. Затем достаёт свой кошель и бросает вам. | Вы поднимаете за окровавленные волосы голову того, кого раньше звали %robberbaron%, его мёртвые глаза обводят комнату. %employer% улыбается.%SPEECH_ON%Тебе известно, что ты сделал, наёмник? Знаешь ли ты, какой гнёт снял с плеч местных жителей, снеся голову этого человека с его плеч? И ты получишь больше, чем рассчитывал! %original_reward% крон за первоначальную задачу и...%SPEECH_OFF%Он выкладывает на стол увесистый кошелёк.%SPEECH_ON%Немного сверху, за тот... лишний вес, что пришлось тащить.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Уничтожил лагерь разбойников");
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
			"robberbaron",
			this.m.Flags.get("RobberBaronName")
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
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/ambushed_trade_routes_situation"));
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

