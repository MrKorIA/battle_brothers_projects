this.drive_away_mgl_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Dude = null,
		Reward = 0,
		OriginalReward = 0
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.drive_away_mgl";
		this.m.Name = "Разбить становище Железной Орды";
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
		return this.buildTextFromTemplate(this.Const.Strings.MglNames[this.Math.rand(0, this.Const.Strings.MglNames.len() - 1)], vars);
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		local banditcamp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Mgl).getNearestSettlement(this.m.Home.getTile());
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
					"Разбить становище Железной Орды («" + this.Flags.get("DestinationName") + "»), что к %direction% от поселения %origin%"
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

				this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.MglDefenders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
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
						properties.Music = this.Const.Music.MglTracks;
						properties.Entities.push({
							ID = this.Const.EntityType.Baihuzhang,
							Variant = 200,
							Row = 2,
							Script = "scripts/entity/tactical/humans/mgl_baihuzhang",
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
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer% сердито качает головой.%SPEECH_ON%Орда. Железная Орда. Уже само это слово люди произносят шёпотом. Неделю назад на тракте нагнали караван из поселения %randomtown% - не ограбили, а перебили всех до одного. Головы торговцев нашли на кольях у поворота. Крестьяне до сих пор не смеют выйти за ворота без трёх копий в дозоре.%SPEECH_OFF%Он стучит пальцем по столу, словно отбивая счёт убитым.%SPEECH_ON%Лазутчик вышел на их становище - теперь мы знаем где они находятся. Сотри их с лица земли, наёмник, и это золото станет твоим. Весь мешок, до последней кроны.%SPEECH_OFF% | %employer% смотрит в окно на дымку, тянущуюся по горизонту.%SPEECH_ON%Видишь дым? Это мельница. Была. Степняки пришли на рассвете, вырезали мельника и сожгли его дом. А голову оставили на колу у дороги - как предупреждение, видишь ли.%SPEECH_OFF%Он поворачивается к вам; глаза у него усталые и злые.%SPEECH_ON%Мои следопыты выследили их кочевье - в дне пути. Убей их всех, наёмник.%SPEECH_OFF% | %employer% меряет шагами комнату, пока вы стоите в дверях.%SPEECH_ON%Они уводят табуны. Каждую ночь - десятки голов скота, каждое утро - мёртвые пастухи. Ни шума, ни следов: только стрела в шее у собаки да табун, уходящий на восток.%SPEECH_OFF%Он останавливается и смотрит на вас.%SPEECH_ON%Разбойники - те хоть прятались в кустах, делали засады. А эти - стая волков, у которой вместо зубов - сабли и луки. Один пастух наткнулся на их стан, пока они резали наш скот, и успел вернуться - бледный, но живой. Он сказал, где они стоят. Сходи туда, наёмник. Обрушь на них то, чего не ждут от мирных людей, - сталь. Я щедро заплачу.%SPEECH_OFF% | %employer% тяжело вздыхает, словно уже не раз вёл этот разговор.%SPEECH_ON%Прошлой ночью сгорел наш амбар. Весь запас на зиму - дотла. Сторожа нашли с перерезанными глотками, а на золе - следы приземистых коней. Ордынские кочевники, наёмник. Они не грабят ради денег, - они забирают всё. Зерно, скотину, людей.%SPEECH_OFF%Он садится, потирая виски.%SPEECH_ON%Мой лазутчик выследил их становище. Отправь их всех на тот свет, и я отсыплю тебе столько крон, что твой пояс выгнется.%SPEECH_OFF% | %employer% сидит за столом, поигрывая обрубком стрелы.%SPEECH_ON%Знаешь, что это? Стрела с гранёным наконечником. Таких в наших краях не делают. Дозорные нашли её в груди моего человека - тот следил за старой соляной дорогой, когда орда прошла по тракту. А после их прохода, наёмник, на тракте не остаётся никого. Ни торговцев, ни попутчиков. Только колья с головами.%SPEECH_OFF%Он вонзает обрубок в столешницу.%SPEECH_ON%Их стан стоит в дне пути отсюда. Хочу, чтобы после твоего прихода от него остались одни угли да вороньё. Сделаешь - получишь кроны. Много крон.%SPEECH_OFF% | %employer% допивает чарку крепкого напитка и выбрасывает её в очаг.%SPEECH_ON%Молодой %randomname% - сын здешнего лорда - поехал позавчера на травлю оленей со свитой. Сегодня нашли коней. Без всадников. Следы ведут в степь, а степь нынче принадлежит Железной Орде.%SPEECH_OFF%Он поворачивается к вам, и в его голосе звучит страх.%SPEECH_ON%Они берут не только зерно и скот - они уводят людей, моих людей, а стариков режут на месте. Если эта ставка останется, через месяц здесь некому будет собирать урожай. Перебей их всех. За какую плату возьмёшься?%SPEECH_OFF% | Едва вы собираетесь присесть, %employer% бросает вам свиток.%SPEECH_ON%Гильдия купцов из поселения %randomtown% отказалась поставлять нам товары, пока на тракте рыщут степные волки. Их караван нашли у брода - повозки целы, товар на месте, а людей... людей нашли на кольях вдоль дороги. Орда не ворует, наёмник, она истребляет.%SPEECH_OFF%Он разворачивает карту; вы видите нарисованный на ней крест.%SPEECH_ON%Мой человек нашёл их стан. Разгроми его - и купцы вернутся, и золото потечёт рекой. Прямо к тебе. Назови цену.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_54.png[/img]{Наблюдая за лагерем степняков из-за гребня холма, вы замечаете фигуру, что выделяется даже среди этих грозных воинов: закованный в ламеллярный латы, с белым сулде - конским хвостом на древке - за спиной. Это %robberbaron%, сотник этой стаи. Он обходит кострища, и даже зарубцевавшиеся ветераны встают при его приближении. От него не отходит трое стражей. Вы прикидываете: вместе с ними в стане около %totalenemy% врагов. Но голову сотника, скорее всего, наниматель оценит дополнительно. | Вы не ждали застать его здесь, но ошибки быть не может: у большого костра сидит %robberbaron% собственной персоной - тот самый степной волк, о грабежах которого трещит вся округа. Он разделывает на седле добычу - и это не олень, судя по тому, что вы видите. Вокруг него свита и кибитки с пленниками. Всего в стане до %totalenemy% степняков. Если атаковать сейчас и прихватить голову сотника, то наниматель отсыпет кроны сверх обещанной награды. | Контракт предполагал простую зачистку становища, но фортуна подкинула добычу крупнее: среди степняков вы узнаёте сотника по имени %robberbaron% - батюра-грабителя, чьё имя шепчут во всей округе. Он склонился над добычей, перебирая серьги и перстни, снятые с погибших. Охрана дышит ему в спину. Вместе со всем станом - около %totalenemy% голов, но именно голова сотника стоит дороже всех. | %robberbaron%. Это он, вы уверены. Вам удаётся легко различить его шлем с меховой гривой и тяжёлые латы, в которых он расхаживает по стану, тыча пальцем в пленников и распределяя их между воинами. Печально известный грабитель, зарезавший, по слухам, больше мирных, чем воинов в честном бою. Его не было в условиях найма, но если принести нанимателю и его голову - плату, несомненно, удвоят. | Вы считаете врагов: %totalenemy% степняков в юртах и у коновязей. И один из них приковывает взгляд - высокий воин в чеканных доспехах, с косой, увешанной волчьими хвостами. По описаниям местных -  это %robberbaron%, сотник этой волчьей стаи. Он смотрит на восток, в родные земли Железной Орды, и улыбается, видимо, вспоминая что-то из недавних грабежей. Улыбка эта вам не понравилась. Хочется стереть её вместе с головой, а заодно заработать лишних крон.}",
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
			Text = "[img]gfx/ui/events/event_22.png[/img]{Битва закончена, вы подходите к мёртвому телу того, кто был известен под именем \'%robberbaron%\', и отрезаете голову двумя быстрыми ударами меча, рассекая сначала мясо, а затем и кости. Вставляете крюк через рот и привязываете верёвку, чтобы прикрепить трофей к поясу. | Когда битва закончилась, вы быстро находите тело сотника орды среди мертвецов. С виду %robberbaron% ещё грозен, хотя кожа его уже начинает бледнеть. Гримаса застывшая на голове вызывает страх даже после того, как вы отделили голову от тела и, хоть вы и не видите его лица, когда бросаете голову в мешок, но уверены, что она всё ещё выглядит жутко злой. | %robberbaron% лежит мёртвым у ваших ног. Вы переворачиваете его и выпрямляете шею, чтобы легче было перерубить её мечом. Для отсечения головы, которую вы быстро убираете в мешок, требуется всего два мощных удара. | Теперь, мёртвым, %robberbaron% внезапно напоминает вам многих людей, которых вы знали. Вы отбрасываете ненужные воспоминания и несколькими быстрыми ударами меча отрубаете его голову, а затем бросаете её в мешок. | %robberbaron% дал хороший бой, а его шея - ещё один: сухожилия и кости не позволяют голове легко отделиться, когда вы пытаетесь забрать свою награду. | %robberbaron% пожертвовал вам свою голову. %randombrother% указывает на неё, когда вы проходите мимо.%SPEECH_ON%Это кто? %robberbaron%, что ли?%SPEECH_OFF%Вы качаете головой.%SPEECH_ON%Неа, теперь это обычный труп. А вот его голова принесёт нам несколько лишних крон.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_07.png[/img]{На обратном пути несколько человек перегораживают вам дорогу. Один из них указывает на голову того, кто раньше был известен как %robberbaron%.%SPEECH_ON%Мы - лучшие охотники за головами в этих краях и, как я понимаю, вы сейчас занялись не своим делом. Отдайте голову нам, и сможете сегодня спокойно спать в своих кроватках.%SPEECH_OFF%Вы смеётесь.%SPEECH_ON%Тебе придётся придумать историю получше. Мёртвый %robberbaron% стоит немало крон, друг мой.%SPEECH_OFF%Командир этих \'охотников за головами\' тоже смеётся. Он поднимает мешок с чем-то круглым внутри.%SPEECH_ON%Это - %randomname%, один из самых разыскиваемых парней в этих краях. А это...%SPEECH_OFF%Он поднимает другой мешок.%SPEECH_ON%А это голова человека, который его убил. Понимаешь, к чему я веду? Итак, отдай голову, и мы все сможем продолжить путь.%SPEECH_OFF% | Незнакомец выходит на дорогу, расправляет плечи и указывает на вас.%SPEECH_ON%Здравствуйте, господа хорошие. Похоже, %robberbaron% отдал вам свою голову.%SPEECH_OFF%Вы киваете. Он улыбается.%SPEECH_ON%Не будете ли вы столь любезны передать её мне?%SPEECH_OFF%Вы смеётесь и качаете головой. Незнакомец больше не улыбается, вместо этого он поднимает руку и щёлкает пальцами. Тотчас отряд вооружённых людей появляется из близлежащих зарослей, выходя на дорогу под тяжёлый металлический лязг. Они словно списаны с кошмара смертника в ночь перед казнью. Их лидер озаряет вас золотозубой усмешкой.%SPEECH_ON%Повторять не буду.%SPEECH_OFF% | Вашу беседу с одним из наёмников прерывает громкий крик. Вы переводите взгляд на дорогу, замечая группу людей, преграждающих вам путь. Их главарь выходит вперёд, объявляя, что они - знаменитые охотники за головами.%SPEECH_ON%Наше единственное желание - получить голову того, кто известен под именем \'%robberbaron%\'.%SPEECH_OFF%Вы пожимаете плечами.%SPEECH_ON%Мы убили его, нам же и принадлежит его голова. Убирайся с нашего пути.%SPEECH_OFF%Как только вы шагнули вперёд, охотники за головами поднимают своё оружие. Их командир делает один шаг к вам.%SPEECH_ON%Неверный выбор приведёт к смерти многих хороших людей. Знаю, это непросто, но я предлагаю тебе ещё раз тщательно всё обдумать.%SPEECH_OFF% | Резкий свист привлекает ваше внимание. Вы переводите взгляд на обочину, замечая группу людей, появившихся из кустов. Все обнажают оружие, но незнакомцы останавливаются. Их главарь движется вперёд. Его грудь украшает ожерелье из ушей - символ его свершений.%SPEECH_ON%Привет, ребята. Мы, если вы не знали, охотники за головами и, похоже, у вас наша добыча.%SPEECH_OFF%Вы поднимаете голову, что раньше откликалась на имя %robberbaron%.%SPEECH_ON%Не его ли имеешь в виду?%SPEECH_OFF%Главарь тепло улыбается.%SPEECH_ON%Конечно. Вы очень порадуете меня и моих друзей, если отдадите то, что нам так нужно.%SPEECH_OFF%Он опускает руку на рукоять меча и усмехается.%SPEECH_ON%Работа такая - не серчайте. Уверен, вы понимаете.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_07.png[/img]Для одного дня вы видели слишком много крови - вы отдаёте голову.",
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
			Text = "[img]gfx/ui/events/event_07.png[/img]Охотники за головами слишком сильны, отряду \'%companyname%\' не справиться с ними. Не желая, чтобы ваши люди были без нужды убиты, вы приказываете спешно отступить. К сожалению, голова мерзавца, коего знали под именем %robberbaron%, была утеряна в суматохе...",
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
			Text = "[img]gfx/ui/events/event_22.png[/img]{Когда битва стихает, из-за кибиток выползают люди - не воины, а пленные, что служили орде: носили воду, разделывали добычу. Они падают на колени, поднимая связанные руки, и умоляют о пощаде на ломаном языке. %randombrother% стоит над одним из них с мечом наготове и ждёт вашего приказа. |  Признав поражение, последние степняки бросили оружие - но вместе с ними на колени падают и пленные служки: молодые парни, взятые степняками в ясир и приученные к работе за кусок хлеба. Они кланяются вам до земли, бормоча молитвы на чужом наречии. | Бой закончен, и теперь перед вами тяжёлый выбор: несколько пленников пережили резню - бывшие рабы орды. %randombrother% стоит над одним из них, держа клинок у горла, и ждёт решения.}",
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
					Text = "Отпустите их.",
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
			Text = "[img]gfx/ui/events/event_22.png[/img]{Доброта - удел наивных дураков. Вы безжалостно убиваете пленников. | Вы вспоминаете, как степняки вешали крестьян на колья у тракта. Эти кровавые сцены встают перед глазами снова и снова. И вы отдаёте приказ казнить пленников. Те пытаются протестовать, но замолкают под ударами мечей и копий. | Вы отворачиваетесь.%SPEECH_ON%Перережьте им глотки. И быстро.%SPEECH_OFF%Наёмники выполняют приказ, и вы слышите стоны умирающих людей. Но умирают люди не так быстро, как хотелось бы. | Вы качаете головой. Пленники кричат, но ваши люди уже наготове, рубя, режа и круша. Некоторые счастливчики лишаются голов прежде, чем успевают осознать близость своей кончины. Те, кто пытается оказать сопротивление, страдают намного дольше. | Милосердие требует времени. Времени оглянуться назад. Времени подумать о правильности своих решений. Но у вас нет этого времени. Вы никого не щадите. Пленных казнят - и времени на это уходит совсем немного.}",
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
			Text = "[img]gfx/ui/events/event_22.png[/img]{На сегодня крови пролито довольно. Вы жестом велите отпустить пленных, забрав у них всё ценное. Освобождённые не сразу верят своему счастью, затем падают в ноги и целуют землю. | Вы отпускаете пленников. Один из них, ободранный парень, хочет что-то сказать, но вы уже отвернулись к трофеям. | Оставив пленных в одном исподнем - у кого таковое было - вы их отпускаете. %randombrother% роется в куче хлама, оставшегося после них, а вы смотрите, как группа полуобнажённых людей спешит удрать прочь от становища.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Мы пришли убивать ордынцев, не их рабов.",
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
			Text = "[img]gfx/ui/events/event_22.png[/img]{Когда пыль оседает, вы слышите глухие удары из-за перевернутой кибитки. Под обломками оказывается связанный мужчина - пленник, судя по всему. Вы перерезаете верёвки, вырываете кляп.%SPEECH_ON%Благодарю... благодарю вас, господин. Я из поселения %randomtown%. Эти псы вытащили меня из постели две ночи назад - гнали табун и взяли жителей из пригорода, кто не успел убежать. Я знаю эти места, как свои пять пальцев, и умею держать копьё. Возьмите меня с собой - я больше не хочу быть добычей.%SPEECH_OFF% | Ваши люди обыскивают становище и находят под навесом человека на привязи - парня с вздувшимися от побоев боками. Освобождённый, он потирает запястья и кланяется вам до земли.%SPEECH_ON%Я пас их коней, - говорит он сипло. - Ел с собаками и спал под кибиткой. А прежде... прежде я работал в кузнице в городе %randomtown%. Мне некуда идти, наёмник. Прими меня в отряд - я отработаю каждую крону.%SPEECH_OFF% | Перерывая завалы в стане степняков, вы находите глубокую яму, затянутую жердью и шкурами. Внизу - живой человек. Вы вытаскиваете его; он стоит на коленях, хватая ртом воздух.%SPEECH_ON%Они держали там тех, кого вели на продажу, - выдавливает он. - Я из %randomtown%, схвачен в поле... Если тебе нужны руки - я силён и готов сражаться против любого из этих степных псов.%SPEECH_OFF% | После битвы в живых остаётся один человек - не степняк. Он выбирается из-под кибитки с поднятыми руками. %randombrother% хватает его за ворот, но тот лишь качает головой.%SPEECH_ON%Я простолюдин, господин! Они выжгли мою деревню и всех вырезали, а меня оставили табун пасти... Мне негде взять хлеб и не у кого просить защиты. Возьми меня в отряд - хуже, чем было, уже не будет.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_22.png[/img]{Он вливается в ваши ряды, исчезая в толпе братьев, которые принимают его достаточно тепло для группы наёмных убийц. Новичок хвастается, что хорош со всеми видами оружия, но вы сами решите, чем он будет владеть. | Пленник улыбается от уха до уха, когда вы его принимаете. Несколько братьев спрашивают, какое оружие ему дать. Вы пожимаете плечами — разберётесь позже.}",
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
			Text = "[img]gfx/ui/events/event_22.png[/img]{Вы качаете головой. Мужчина хмурится.%SPEECH_ON%Вы уверены? Я довольно хорош в...%SPEECH_OFF%Вы перебиваете.%SPEECH_ON%Уверен. А теперь наслаждайся своей свободой, незнакомец.%SPEECH_OFF% | Вы оцениваете мужчину и понимаете, что он не подходит для жизни наёмника.%SPEECH_ON%Мы ценим предложение, но жизнь наёмника опасна. Возвращайся домой, к семье, к работе.%SPEECH_OFF% | У вас достаточно людей, новички не нужны. Однако вам интересно: как отреагирует %randombrother%, если вы заговорите о его замене? Вместо этого вы пожимаете руку пленнику и отправляете его восвояси. Он разочарован, но благодарит за освобождение.}",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{Кажется, не только ваш наниматель, но и весь %townname% ждёт вестей от вас. Вы не привыкли много болтать о своей работе, и потому отчёт ваш скуп: становища больше нет. %employer% кивает и улыбается, прежде чем передать обещанную плату.%SPEECH_ON%Хорошая работа, наёмник. Скот наконец можно пускать на пастбище без охраны, а купцы уже спрашивают, когда откроется тракт. Орда запомнит этот урок.%SPEECH_OFF% | Когда вы подходите к дому нанимателя, сам %employer% выходит к вам навстречу. В руке он держит кошель, то и дело подбрасывая его.%SPEECH_ON%Я так понимаю, раз ты вернулся - становища больше нет?%SPEECH_OFF%Вы киваете. Он протягивает кошель.%SPEECH_ON%Слухи по миру летят быстро, особенно если не жалеть на них золота. Но пусть уж лучше летят слухи о тебе, чем копыта ордынских коней. Хорошая работа, наёмник.%SPEECH_OFF% | %employer% усмехается, когда вы входите и опускаете на стол сулде - конский хвост на древке, знамя их лагеря.%SPEECH_ON%Не обязательно было тащить это через пол-степи, наёмник. Я уже получил весть: юрты горят до сих пор. Твоя плата - в том углу.%SPEECH_OFF% | Выслушав ваш отчёт, %employer% вытирает лоб платком.%SPEECH_ON%Значит, их нет. Всех до одного. Наёмник... ты не представляешь, какой груз свалился с моих плеч. Весной мы снова засеем поля у тракта. Твои кроны - как я и обещал.%SPEECH_OFF%Он опускает на стол кошель, и вы тут же его забираете и пересчитываете. Всё верно, до последней монеты. | %employer% встречает вас у ворот; в глазах у него ещё тень страха.%SPEECH_ON%Знаешь, я каждую ночь просыпался - мерещилось ржание их коней у стены. А теперь говорят, вороньё каркает над их станом. Ты вернул людям сон, наёмник, а это дорогого стоит.%SPEECH_OFF%Он вручает вам мешок, туго стянутый ремнём.%SPEECH_ON%Плата. Вся. И приходи ещё, если степь снова поднимет голову.%SPEECH_OFF% | %employer% отхлёбывает из кубка и кивает.%SPEECH_ON%Не жалую вашего брата - умеете только резать да жечь. Но коли резать - так орду. Мой человек побывал на том месте: угли, кости, порванные шатры. Хорошая работа, по его словам.%SPEECH_OFF%Он кладёт на стол кошель.%SPEECH_ON%А это - очень хорошая плата.%SPEECH_OFF% | В комнате нанимателя чужак - купец, судя по одежде. %employer% представляет вас. Купец говорит.%SPEECH_ON%Это тот человек, что отворил нам тракт? Гильдия прислала меня передать благодарность и напомнить: пока орда топчет степь, ни один караван не тронется с места. Теперь эе мы двинемся уже завтра.%SPEECH_OFF%%employer% усмехается и пододвигает к вам сундучок.%SPEECH_ON%Плата по найму. Пересчитывай, я не обижусь.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Уничтожил становище Железной Орды");
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{Вы бросаете голову сотника на стол нанимателя. С усмешкой указываете на неё.%SPEECH_ON%Это - %robberbaron%.%SPEECH_OFF%%employer% встаёт и развязывает горловину мешка, скрывающего ваш трофей. Он кивает.%SPEECH_ON%Ага, это и правда он. Полагаю, ты рассчитываешь на прибавку.%SPEECH_OFF%Он даёт вам %reward% крон за разгром становища и голову его сотника. | %employer% откидывается назад, когда вы входите, неся голову за волосы. К счастью, кровь с неё не капает.%SPEECH_ON%Тут у нас %robberbaron%. Или вернее сказать \'был\'?%SPEECH_OFF%Интересуется %employer%, медленно поднимаясь и окидывает вас беглым взглядом.%SPEECH_ON%Да, определённо \'был\'... Итак, ты не только сжёг их ставку, но и принёс мне голову зверя, что разорял всю округу. Прекрасная работа, наёмник, и твоя плата будет увеличена.%SPEECH_OFF%Он протягивает вам шкатулку, набитую золотом. %original_reward% крон. Затем достаёт кошель и добавляет сверху. | Вы поднимаете за окровавленные волосы голову того, кого раньше звали %robberbaron%; мёртвые глаза обводят комнату. %employer% улыбается.%SPEECH_ON%Знаешь, что ты сделал, наёмник? Тот, кто водил их в грабежи, тот, кто вешал головы крестьян на колья, сам украсит кол у тракта. Пусть степняки увидят: здесь им не рады.%SPEECH_OFF%Он выкладывает на стол увесистый кошель.%SPEECH_ON%Плата, как договаривались, и добавка за эту голову.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Уничтожил становище Железной Орды");
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
