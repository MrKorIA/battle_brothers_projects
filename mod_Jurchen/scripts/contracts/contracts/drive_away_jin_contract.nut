this.drive_away_jin_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Dude = null,
		Reward = 0,
		OriginalReward = 0
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.drive_away_jin";
		this.m.Name = "Изгнать иноземных разведчиков";
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
		return this.buildTextFromTemplate(this.Const.Strings.jinNames[this.Math.rand(0, this.Const.Strings.jinNames.len() - 1)], vars);
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		local banditcamp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Jurchen).getNearestSettlement(this.m.Home.getTile());
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
					"Изгнать иноземных разведчиков из местечка " + this.Flags.get("DestinationName") + " к %direction% от поселения %origin%"
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

				this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.JurchenDefenders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
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
						properties.Music = this.Const.Music.JinTracks;
						properties.Entities.push({
							ID = this.Const.EntityType.NomadCenturion,
							Variant = 200,
							Row = 2,
							Script = "scripts/entity/tactical/humans/nomad_centurion",
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
			Text = "[img]gfx/ui/events/event_20.png[/img]{Когда вы входите, %employer% не поднимает глаз от карты, разложенной на столе, - водит пальцем по изгибам рек, очертаниям холмов. Не отрываясь от неё, он глухо говорит.%SPEECH_ON%Чжурчжэни. Уже третью седмицу их дозоры рыщут по северному тракту - не жгут, не грабят, а присматриваются: считают копья на дворах, примечают, где частокол прохудился, где колодец обмелел. Но стоит кому-то заметить лишнее - трактирщику, пастуху, - того находят после в канаве, вспоротым от горла до пояса. Не разбойники балуют, наёмник, - чужая армия готовит поход, и цену своей скрытности они знают. Только не всё у них вышло гладко: мы нашли их становище.%SPEECH_OFF%Он наконец поднимает голову и смотрит вам в глаза.%SPEECH_ON%Мой лазутчик нашёл их за три дня. Вернулся едва живым, весь в крови - но лагерь на карте отметить смог.%SPEECH_OFF%Он отодвигает свиток, и вы видите аккуратно нанесённый крест у старого бродского тракта.%SPEECH_ON%Эти псы не бандиты. Они - глаза чужой орды. Если их не стереть сейчас, через месяц сюда войдёт тысяча воинов по их следу. Мне нужен не меч, мне нужен ночной нож. Ты и твои люди зайдёте в их лагерь и перережете всех. Ни одного выжившего - ни одного следа. И тогда я заплачу тебе так, как не платят за убийство шайки оборванцев. Ты услышал меня, наёмник?%SPEECH_OFF% | %employer% стоит у окна, глядя на дорогу. Он поворачивается к вам - судя по тёмным кругам под глазами, не спал уже дня два.%SPEECH_ON%Эти чжурчжэни не польстятся на скотину и не станут жечь амбар ради потехи - им это без надобности. Но горе тому, кто увидит их за работой: моего дозорного нашли на рассвете у брода со вспоротым горлом. Он успел зарыть в придорожных кустах кожаную сумку с их схемами - там были планы всех трёх окольных сёл. Ты понимаешь, что это значит?%SPEECH_OFF%Он ударяет кулаком по столу.%SPEECH_ON%Они готовят вторжение, наёмник. И их лагерь стоит в дне пути от нас. Я дам тебе проводника - он доведёт до оврага, оттуда ты пойдёшь сам. Убей их всех. Сотри это гнездо, чтобы даже ворон не нашёл там поживы. А я заплачу тебе щедро - вдвое больше против обычного контракта.%SPEECH_OFF% | %employer% сидит на корточках возле очага и вертит в руках обрывок пороховницы с вырезанным на боку знаком. Голос его тих и сух, как зола.%SPEECH_ON%Эти люди не из ближней степи. Этот знак - клановая метка, я таких раньше не видел. Пастух, что наткнулся на их дозор прошлой седмицей, назад не вернулся - нашли только вожжи да кровь на земле у брода. Это дозорные, наёмник. Они смотрят на нас, как волки смотрят на загнанного оленя. Я хочу, чтобы ни один из них не вернулся обратно в свою землю.%SPEECH_OFF%Он поднимается и идёт к сундуку, достаёт мешочек с кронами и небрежно кладёт на стол перед вами.%SPEECH_ON%Это задаток. Остальное - когда в лагере не останется ни одного живого чжурчжэня. Мне нужно, чтобы следующий отряд лазутчиков наткнулся на голые пепелища там, где был лагерь, - и убрался восвояси, не рискнув идти дальше. Что скажешь, ты готов поработать?%SPEECH_OFF% | %employer% сидит за столом, поигрывая ножом - клинок время от времени глухо стучит по столешнице.%SPEECH_ON%Чжурчжэни. Следопыты. Они уже пометили на своей карте все лесные тропы от поселения %town% до самого леса. Мои люди дважды находили тела тех, кто пробовал проследить за их разъездами - без языков, чтобы неповадно было болтать. Если эта карта попадёт к их старшему брату на востоке, мы не удержим ни одного хутора. Поэтому я хочу, чтобы ты пошёл и забрал у них не только жизнь, но и все их записи о наших землях, до последнего листа.%SPEECH_OFF%Он делает паузу, оскаливается.%SPEECH_ON%Контракт простой: ты приходишь, ты режешь, ты уходишь. Никаких факелов, никакого шума. Мои люди расскажут, где у них стоят часовые. Ну что, наёмник, возьмёшься за настоящую работу, а не за драку с пьяными мужиками?%SPEECH_OFF% | %employer% не предлагает вам сесть. Он стоит, скрестив руки на груди, и смотрит на вас как на инструмент, который нужно проверить перед покупкой.%SPEECH_ON%Слухи дошли до меня ещё неделю назад. Чжурчжэни собирают данные - кто из купцов ездит с охраной, где ремонтируют городскую стену, сколько у нас старых ветеранов. Один купец имел неосторожность приметить их у брода - с тех пор его никто не видел. Они пока не нападают в открытую, они ждут. Но я не хочу ждать вместе с ними. Мой человек проследил их до старого острога на северной пустоши. Там их лагерь, там они хранят свои записи.%SPEECH_OFF%Он резко подаётся вперёд.%SPEECH_ON%Мне не нужны доказательства. Мне нужен пепел и мёртвая трава на том месте. Сделай это - и я дам тебе столько крон, что ты сможешь купить себе целый отряд новых наёмников. Откажешься - я найду другого. Решай сейчас.%SPEECH_OFF% | Когда вы заходите, %employer% стоит перед алтарём с опущенной головой. Он оборачивается, и становится видно, что он молился.%SPEECH_ON%Чжурчжэни не грабят храмы, наёмник - приходят послушать, а не поживиться утварью да подношениями. Встанут у входа, послушают, о чём просят у алтаря перепуганные бабы, и уйдут, не тронув ни единой безделицы: такая у них выучка. А чего не расслышат сами, перескажет толмач - их человек, что знает наш язык и вертится среди крестьян. Отказался с ним говорить один упрямец - нашли его повешенным на воротах собственного двора. Так они и плетут свою паутину, нитка за нитью, по всей округе. Хочу, чтобы ты оборвал её разом. Приди ночью, убей всех в шатрах и принеси мне их записи - я должен знать, что они уже вызнали о нас. За это я заплачу тебе. Сколько хочешь? Называй цену, только соглашайся.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_54.png[/img]{Вглядываясь в чжурчжэньский стан из-за гребня холма, вы замечаете фигуру, которая выделяется даже среди этих иноземных воинов. Широкие плечи, чёрная бурка с серебряной нитью - у них только один человек носит такую: %robberbaron%, их сотник-разведчик. Он обходит костры, останавливается у каждого десятка, что-то чертит палкой на земле. Свита из четырёх телохранителей не отстаёт от него ни на шаг. Вы мысленно прикидываете: если взять его, остальные рассыпятся, как стая без вожака. Но вместе с ним и остальными чжурчжэнями будет около %totalenemy% врагов. | Вы не ждали встретить его здесь, но ошибки быть не может: %robberbaron% собственной персоной обходит дозорный лагерь, тыкая пальцем в упряжь лошадей и в подсумки с зарядами. Его голос, глухой и властный, долетает даже до вашего укрытия. Двое телохранителей стоят сзади, держа руки на саблях. Всего в стане - %totalenemy% воинов, но именно этот человек превращает их из шайки в армию. | Контракт обещал быть простым. Но, похоже, судьба решила подбросить вам добычу покрупнее. На площади перед главным шатром стоит %robberbaron%, известный убийца и охотник за головами на службе чжурчжэньского хана. Он склонился над картой, которую держат двое его подручных, и водит пальцем по линиям - прокладывает маршруты для следующей разведки. Вы видите, как все %totalenemy% чжурчжэней ждут его приказа. Убьёте его сейчас, и вся их разведка ослепнет. За такую голову наниматель, пожалуй, не поскупится. | Вы всматриваетесь в лагерь. Чжурчжэни суетятся у повозок, кто-то чистит седло, кто-то проверяет мешки с порохом. И тут среди них вы видите сотника. %robberbaron% не в боевом доспехе, только кожаный кафтан, но в руке держит длинный нож, которым размечает колышки для нового шатра. Его лицо вы помните по описаниям: шрам через всю скулу, левое ухо обрублено. Этот человек водил лазутчиков к замку знати, вырезав по пути аристократов, возвращавшихся с охоты. С тех пор за его голову назначена награда. Это большая удача встретить его здесь, среди %totalenemy% голов. И каждая из них - ваша добыча. | Вы считаете врагов: %totalenemy% чжурчжэней. Вы считаете врагов: %totalenemy% чжурчжэней. Но один из них приковывает внимание: %robberbaron% сидит у огня, поджав под себя ноги, и негромко диктует, а рядом, склонившись над бумагой, скрипит пером писарь. Вы понимаете, что это не простой сотник: это тот, кто отправляет донесения хану. Если перехватить эти донесения, можно узнать все их планы. Но для этого сначала нужно снести ему голову. Ваши пальцы сжимают рукоять меча. Сегодня вы ударите первым.}",
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
			Text = "[img]gfx/ui/events/event_22.png[/img]{Битва закончена, вы подходите к мёртвому телу того, кто был известен под именем \'%robberbaron%\' и отрезаете голову двумя быстрыми ударами меча, рассекая сначала мясо, а затем и кости. Затем вы через рот вставляете крюк и привязываете верёвку, чтобы прикрепить трофей к поясу. | Когда битва закончилась, вы быстро находите тело главаря чжурчжэней среди мертвецов. С виду %robberbaron% ещё грозен, хотя кожа его уже начинает бледнеть. Он страшен даже после того, как вы отделили голову от тела и, хоть вы и не видите его лица, когда бросаете голову в мешок, но уверены, что оно всё ещё выглядит жутко злым. | %robberbaron% лежит мёртвым у ваших ног. Вы переворачиваете его и выпрямляете шею, чтобы легче было перерубить её мечом. Для отсечения головы, которую вы быстро убираете в мешок, требуется всего два мощных удара. | Теперь, мёртвым, %robberbaron% внезапно напоминает вам многих людей, которых вы знали. Вы не долго предаётесь воспоминаниям, несколькими быстрыми ударами меча вы отрубаете его голову и бросаете её в мешок. | %robberbaron% дал хороший бой, а его шея - ещё один: сухожилия и кости не позволяют голове легко отделиться, когда вы пытаетесь забрать свою награду. | %robberbaron% пожертвовал вам свою голову. %randombrother% указывает на неё, когда вы проходите мимо.%SPEECH_ON%Это кто? %robberbaron%, что ли?%SPEECH_OFF%Вы качаете головой.%SPEECH_ON%Неа, теперь это обычный труп. А вот его голова принесён нам несколько лишних крон.%SPEECH_OFF%}",
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
						p.Music = this.Const.Music.JinTracks;
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "BountyHunters";
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.BountyHunters, 130 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Jurchen).getID());
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
			Text = "[img]gfx/ui/events/event_22.png[/img]{Когда последний чжурчжэньский воин падает, из-за опрокинутых повозок выходят несколько фигур в серых халатах и поднимают руки. Это не воины, а писцы и конюхи, которых разведчики привели с собой. Они кланяются, бормочут на ломаном языке, умоляя пощадить. %randombrother% стоит над одним из них с поднятым мечом и ждёт вашего знака. Пленные не знают, что их ждёт, - на лицах только страх и желание выжить. | Чжурчжэньский лагерь дымится, догорают последние костры. Вы проходите мимо шатров, когда из-под повозки выползает один из чжурчжэней. Это не боец: оружия нет, руки дрожат. Он торопливо говорит, на ломаном языке, но вы разбираете: \'Слуга, я слуга, не воин\'. Остальные пленники, которых ваши люди вытаскивают из-за мешков с кормом, смотрят на вас с такой же покорной надеждой, и решать их судьбу предстоит вам. | Бой стих, и тишина леса становится почти оглушительной. Пока ваши люди собирают трофеи, один из них замечает у реки движение: двое чжурчжэней пытаются уйти вброд. Их ловят и волокут обратно. Один из них совсем мальчишка, второй старик с седой косой. Они падают на колени, пряча лица в грязь. Вы смотрите на них сверху и чувствуете, как тяжесть решения ложится на плечи. Сами они уже никого не убьют. Но если вы отпустите их, они пойдут к своим и приведут новых.}",
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
			Text = "[img]gfx/ui/events/event_22.png[/img]{Доброта - удел наивных дураков. Вы безжалостно убиваете пленников. | Вы отворачиваетесь.%SPEECH_ON%Перережьте им глотки. И быстро.%SPEECH_OFF%Наёмники выполняют приказ и вы слышите стоны умирающих людей. Но люди умирают, не так быстро, как хотелось бы. | Вы качаете головой. Пленники кричат, но ваши люди уже наготове, рубя, режа и круша. Некоторые счастливчики лишаются голов прежде, чем успевают осознать близость своей кончины. Те, кто пытается оказать сопротивление, страдают до самого конца. | Милосердие требует времени. Времени оглянуться назад. Времени подумать о правильности своих решений. Но у вас нет этого времени. Вы никого не щадите. Пленных казнят - и времени на это уходит совсем немного.}",
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
			Text = "[img]gfx/ui/events/event_22.png[/img]{В повисшей тишине вы долго смотрите на пленников, затем отводите взгляд.%SPEECH_ON%Хватит крови. Отберите у них всё, чем можно ударить, - ножи, ремни. И пусть идут.%SPEECH_OFF%Ваши люди переглядываются, но подчиняются. Чжурчжэни сначала не верят и ждут удара, сжавшись в комки. Но когда им велят встать и идти, они пятятся, разворачиваются и бегут, низко пригнувшись, словно боятся, что вы передумаете. %randombrother% качает головой.%SPEECH_ON%Пожалеешь, командир.%SPEECH_OFF%Вы провожаете беглецов взглядом.%SPEECH_ON%Может быть. Очень может быть.%SPEECH_OFF% | В сырой вязкой тишине вы даёте знак не трогать пленных. Те не сразу понимают, затем падают на колени и кланяются, упираясь лбами в землю. Напряжение, что держало вас весь бой, отпускает.%SPEECH_ON%Встаньте. Вы свободны. Но если я увижу вас снова, разговора не будет.%SPEECH_OFF%Пленники поднимаются, один тянется схватить вашу руку, но вы отдёргиваете её. Они убегают, бросая пожитки. Ваши наёмники собирают брошенное добро, пока вы молча смотрите им вслед.}",
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
			Text = "[img]gfx/ui/events/event_22.png[/img]{Когда пыль от битвы оседает, вы слышите глухое мычание из-под груды тряпья. Ваши люди разгребают остатки шатра и находят человека: он связан по рукам и ногам, во рту кляп. Глаза у него круглые, дикие. Вы вырываете кляп, и он хватает ртом воздух.%SPEECH_ON%Спасибо... спасибо... я из поселения %randomtown%, меня схватили эти волки две ночи назад... они хотели, чтобы я переводил речи деревенских... я не помогал им, клянусь!%SPEECH_OFF%Он вскидывает на вас взгляд, и в нём уже не страх, а отчаянная надежда.%SPEECH_ON%Возьми меня с собой. Я умею держать нож, я знаю дороги, я не буду обузой. Пожалуйста.%SPEECH_OFF% | Ваш взгляд падает на человека, что сидит под деревом, прижавшись к стволу. Он не пытается бежать, просто ждёт, пока вы его заметите. Вы подходите ближе, и он поднимает руки, показывая, что безоружен.%SPEECH_ON%Я был их переводчиком, - говорит он, и голос его дрожит. - Не по своей воле. Они держали меня на привязи и кормили раз в день. Я видел, как твои люди с ними расправились, наёмник. Возьми меня к себе, одному мне на этих дорогах не выжить. Дай шанс - я докажу, что могу быть полезным.%SPEECH_OFF% | В остатках чжурчжэньского лагеря вы находите глубокую яму, затянутую ветками. Вы сбрасываете их, и из ямы поднимается потное, испуганное лицо. Мужчина лет тридцати, в грязной рубахе.%SPEECH_ON%Они держали меня здесь и заставляли переводить, что говорят на рынке... я не хотел, но они сказали, что убьют мою семью...%SPEECH_OFF%Он выбирается из ямы, шатаясь и опираясь на её край.%SPEECH_ON%Я знаю эти места, как свои пять пальцев. Дай мне меч, и я пойду с тобой до конца.%SPEECH_OFF%Вы смотрите на него и видите, что воля в нём не сломлена.}",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{Когда вы входите в палату, %employer% не поднимает глаз от бумаг. Вы бросаете ему на стол окровавленный ремень с насечками - по одной на каждого убитого чжурчжэня. Он считает их молча, затем поднимает голову и медленно кивает.%SPEECH_ON%Число насечек сходится с тем, что докладывали мои люди. Ты сделал всё чисто: я проверял следы - ни одного дозора на дорогах. Ты профессионал, наёмник.%SPEECH_OFF%Он толкает к вам тяжёлый кожаный мешок.%SPEECH_ON%Твои кроны. Все до единой, как договаривались. Если когда-нибудь ещё понадобится убрать чжурчжэньское гнездо - я знаю, к кому обратиться.%SPEECH_OFF% | Когда вы переступаете порог, %employer% стоит у камина и сжигает свиток. Он оборачивается с улыбкой, которую вы не видели у него раньше - спокойной и даже счастливой.%SPEECH_ON%Я сжёг все записи чжурчжэней, что нашли в их шатре. Твои люди принесли их охапками. Теперь сведения о наших бродах и стенах не уйдут к их хану. Ты сохранил этот город, наёмник. Деньги на столе - пересчитывай, если хочешь, я не обижусь: я честен с тобой так же, как ты был честен со мной.%SPEECH_OFF% | %employer% сидит в кресле, лицо его осунулось - похоже, он не спал все эти дни. Увидев вас, он встаёт и протягивает вам кубок с вином.%SPEECH_ON%Пей со мной. За то, что чжурчжэни больше не увидят наш город. Мой человек был на том месте - лагерь сровнен с землёй, кони разбежались, живых не осталось. Ты сделал это быстро и жестоко. Ты - монстр, наёмник. Но теперь ты мой монстр.%SPEECH_OFF%Он смеётся, доливает вам вина и достаёт из-под стола увесистый мешок.%SPEECH_ON%Вот твоя плата, монстр. Всё до последней кроны.%SPEECH_OFF% | Вы не говорите ни слова, просто кладёте на стол чжурчжэньский шлем. %employer% берёт его в руки и выдыхает - как человек, который наконец смог вздохнуть полной грудью.%SPEECH_ON%Всё. Их охота на нас закончилась здесь.%SPEECH_OFF%Он убирает шлем под стол и достаёт два кошеля.%SPEECH_ON%Первый - за контракт. Второй - тоже за контракт. Просто кроны в один кошель не влезли.%SPEECH_OFF%Он пожимает плечами и улыбается.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Уничтожил лагерь иноземных захватчиков");
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{Вы заходите, неся перед собой мешок, из которого сочится кровь. Ставите его на стол, за которым сидит %employer%, и развязываете горловину. Тот наклоняется, вглядывается в мёртвое лицо, затем выпрямляется с мрачной усмешкой.%SPEECH_ON%Тот самый сотник, который водил лазутчиков в глубь наших земель. Я узнал его по описаниям свидетелей. Теперь он просто кусок мяса в твоём мешке. Ты не просто очистил лагерь - ты обезглавил их, наёмник. В прямом и переносном смысле.%SPEECH_OFF%Он отсчитывает перед вами две стопки крон.%SPEECH_ON%Первая - за работу. Вторая - за эту самую голову. Бери всё. Ты заслужил.%SPEECH_OFF% | Когда вы входите, %employer% уже смотрит на дверь. Вы бросаете голову сотника на ковёр, и она катится, оставляя тёмную полосу. Он подходит, смотрит, затем поднимает её за волосы и разглядывает лицо со всех сторон.%SPEECH_ON%Шрам через скулу, левое ухо срезано. Да, это он. Мои люди не могли к нему подобраться, а ты достал его так быстро.%SPEECH_OFF%Он брезгливо отставляет голову к стене, затем подходит к сундуку и вынимает два туго набитых кошеля.%SPEECH_ON%Один - плата за лагерь. Второй - за голову: мы насадим её на кол перед городом, чтобы все знали: чжурчжэни не пройдут через эту землю.%SPEECH_OFF% | Вы входите и в наступившей тишине поднимаете за волосы голову сотника. %employer% морщится, но не отворачивается. Он вглядывается в застывшее лицо, потом переводит взгляд на вас.%SPEECH_ON%Сотник руководил их разведкой во всей округе. Без него чжурчжэни ослепнут минимум на месяц. За это время мы успеем подготовить стены и собрать людей.%SPEECH_OFF%Он протягивает вам увесистую шкатулку, а сверху кладёт тяжёлый мешок.%SPEECH_ON%Шкатулка - плата по контракту. Мешок - сверх уговора. Такая голова стоит дорого, наёмник, и я готов за неё заплатить.%SPEECH_OFF%Вы принимаете и то, и другое, чувствуя приятную тяжесть монет.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Уничтожил лагерь иноземных захватчиков");
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
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/terrified_villagers_situation"));
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

