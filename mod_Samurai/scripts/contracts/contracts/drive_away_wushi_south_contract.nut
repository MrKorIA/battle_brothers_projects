this.drive_away_wushi_south_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Dude = null,
		Reward = 0
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.drive_away_wushi_south";
		this.m.Name = "Прогнать Вокоу";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		local banditcamp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getNearestSettlement(this.m.Home.getTile());
		this.m.Destination = this.WeakTableRef(banditcamp);
		this.m.Flags.set("DestinationName", banditcamp.getName());
		this.m.Payment.Pool = 600 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Изгнать иноземных воинов из стойбища " + this.Flags.get("DestinationName") + ", что к %direction% от города %origin%"
				];
				this.Contract.setScreen("Task");
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
				this.Contract.m.Destination.resetDefenderSpawnDay();
				this.World.uncoverFogOfWar(this.Contract.m.Destination.getTile().Pos, 500.0);
				local r = this.Math.rand(1, 100);

				if (r <= 10)
				{
					if (this.Contract.getDifficultyMult() >= 0.95 && this.World.Assets.getBusinessReputation() > 700)
					{
						this.Flags.set("IsSandGolems", true);
					}
				}
				else if (r <= 25)
				{
					if (this.Contract.getDifficultyMult() >= 0.95 && this.World.Assets.getBusinessReputation() > 300)
					{
						this.Flags.set("IsTreasure", true);
						this.Contract.m.Destination.clearTroops();
						this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.WushiDefenders, 150 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					}
				}
				else if (r <= 35)
				{
					if (this.World.Assets.getBusinessReputation() > 800)
					{
						this.Flags.set("IsAssassins", true);
					}
				}
				else if (r <= 50)
				{
					this.Flags.set("IsFriendlyNomads", true);
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
					if (this.Flags.get("IsTreasure"))
					{
						this.Flags.set("IsTreasure", false);
						this.Contract.setScreen("Treasure2");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setState("Return");
					}
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				if (this.Flags.get("IsSandGolems"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("SandGolems");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.Music = this.Const.Music.OrientalBanditTracks;
						properties.EnemyBanners.push(this.Contract.m.Destination.getBanner());
						local e = this.Math.max(1, 70 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult() / this.Const.World.Spawn.Troops.SandGolem.Cost);

						for( local i = 0; i < e; i = ++i )
						{
							properties.Entities.push({
								ID = this.Const.EntityType.SandGolem,
								Variant = 0,
								Row = -1,
								Script = "scripts/entity/tactical/enemies/sand_golem",
								Faction = this.Const.Faction.Enemy
							});
						}

						this.World.Contracts.startScriptedCombat(properties, true, true, true);
					}
				}
				else if (this.Flags.get("IsTreasure") && !this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);
					this.Contract.setScreen("Treasure1");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsAssassins"))
				{
					if (!this.Flags.get("IsAttackDialogTriggered"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.setScreen("Assassins");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.Music = this.Const.Music.OrientalBanditTracks;
						properties.EnemyBanners.push(this.Contract.m.Destination.getBanner());
						local e = this.Math.max(1, 30 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult() / this.Const.World.Spawn.Troops.Assassin.Cost);

						for( local i = 0; i < e; i = ++i )
						{
						    if (this.Math.rand(1, 2) == 2)
						    {
                                properties.Entities.push({
                                    ID = this.Const.EntityType.Renzhe,
                                    Variant = 0,
                                    Row = 2,
                                    Script = "scripts/entity/tactical/humans/renzhe",
                                    Faction = this.Contract.m.Destination.getFaction()
                                });
						    }
						    else
						    {
                                properties.Entities.push({
                                    ID = this.Const.EntityType.Renzhe02,
                                    Variant = 0,
                                    Row = 2,
                                    Script = "scripts/entity/tactical/humans/renzhe02",
                                    Faction = this.Contract.m.Destination.getFaction()
                                });
						    }
						}

						this.World.Contracts.startScriptedCombat(properties, true, true, true);
					}
				}
				else
				{
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
			Text = "[img]gfx/ui/events/event_163.png[/img]{Нет ни рёва труб, ни восторженных криков, ни рассыпаемых лепестков роз, но вы всё же чувствуете \'благоухающее\' в воздухе величие, входя в покои нанимателя. Они сияют золотом и серебром, изысканными драгоценностями, созданными умелыми мастерами, украшены гаремом из прекраснейших женщин... и мало кто откажет в любой просьбе владельцу сего великолепия, лишь бы получить возможность ещё раз принять участие в каждодневном празднестве. Сам же %employer% восседает на груде подушек.%SPEECH_ON%А, алчущий крон. Я ждал тебя. Прошу, ближе не подходи, не оскорбляй мои чувства. Тебя ждёт простое задание. Кочевники грабят мои караваны, а потому в моих сундуках убавляется золото. Полагаю, тебе должно быть очень знакомо это состояние - быть ущемлённым в чём-либо, не так ли? О да, ведь ты столь туп. Столь пуст. Столь... годен для своего дела. Я желаю, чтобы эти кочевники были убиты, и готов заплатить за это %reward% крон. Услаждает ли такое предложение то, что находится у тебя между ушами?%SPEECH_OFF% | %employer% расселся на шёлковых подушках своего трона, закинув ноги на спины нескольких женщин из своего гарема. Он поднимает руку.%SPEECH_ON%Ещё один шаг вперёд, алчущий крон - и ты упадёшь в моих глазах, заняв в них больше пространства, понимаешь? Мудрый человек знает своё место. У меня есть простое задание для твоего меча. Кочевники в округе города %townname% погрязли в воровстве и разбое. Ради мира во всём мире я желаю, дабы ты умертвил всех тех, кто вносит неудобство в мою жизнь.%SPEECH_OFF% | %employer% кормит птицу в клетке. Перья её столь многоцветны, что некоторых из этих цветов вы до того и не видывали. Заметив ваше появление - а быть может учуяв его - %employer% поворачивается к вам с гримасой отвращения.%SPEECH_ON%Ты пугаешь мою пташку, алчущий крон, так что ради неё я буду краток. Кочевники рыскают по окраинам моих земель, и я желаю увидеть их мёртвыми. Уверен, человек твоих... достоинств, согласится взяться за столь простую и понятную задачу, не так ли?%SPEECH_OFF% | Войдя в покои визиря, вы застаёте его вкушающим фрукты. Нижняя его половина при этом погружена в море плоти, гарем \'попечителей\', что заняты работой. Надолго застыв в удивлении, вы открываете было рот, но %employer% тут же предупреждающе вскидывает руку. Он указывает на одну из служанок и щёлкает пальцами. Та тут же бросается к вам, шурша по мраморному полу шелковыми подошвами своих сандалий, и отдаёт свиток. Он гласит:%SPEECH_ON%Любому алчущему крон: кочевники нарушили мир с городом %townname%. С ними нужно покончить за награду в %reward% крон. Не принявшим предложение следует немедленно уйти.%SPEECH_OFF%Служанка с немым вопросом смотрит на вас. | %employer% тяжко вздыхает, когда вы входите в залу.%SPEECH_ON%А вот и алчущий крон. Я уж было забыл, что сам просил одного из вас прибыть сюда и окончательно погубить этот день.%SPEECH_OFF%Вы разглядываете визиря, слишком усталого, чтобы выбраться из пучины подушек и моря женщин, желающих взлелеять всё и всех.%SPEECH_ON%Так и быть, полагаю, стоит запятнать час, лишь бы разрешить это дело. Кочевники грабят мои караваны - обычное их занятие - и потому мои купцы испытывают нехватку некоторых товаров, которые я желал бы иметь в достатке. Предлагаю %reward% крон за выслеживание и умерщвление этих песчаных клещей.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Поговорим о плате. | Мы заставим эту проблему исчезнуть.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Не интересует. | У нас есть более важные дела. | Желаю тебе удачи, но мы не станем в этом участвовать.}",
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
			ID = "Treasure1",
			Title = "Перед битвой...",
			Text = "[img]gfx/ui/events/event_54.png[/img]{Здешние кочевники на удивление неподвижны и многочисленны. И на это есть причина: вы замечаете \'землекопов\', сгрудившихся вокруг огромной ямы в песке. Соорудив помосты, они лихорадочно стараются поднять то, что отдала им пустыня. Судя по ухмылке человека, возглавляющего сие сборище - это, несомненно, клад.\n\nВы можете напасть сейчас, столкнувшись с большим сопротивлением, или подождать пока они закончат и уйдут, унеся с собой выкопанное.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Нападаем немедленно!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				},
				{
					Text = "Подождём, пока лагерь останется незащищённым.",
					function getResult()
					{
						return "Treasure1A";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Treasure1A",
			Title = "Перед битвой...",
			Text = "[img]gfx/ui/events/event_54.png[/img]{Вы дожидаетесь, пока кочевники вытащат своё сокровище. Как вы и предполагали, это сундук. После его открытия, лица кочевников расплываются в довольных улыбках. А ещё, как вы и ожидали, они разделяются: отряд из самых сильных воинов увозит сокровище, скорее всего желая продать его где-нибудь подороже. Теперь лагерь кочевников ослаблен и гораздо более уязвим для нападения...}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Готовьтесь к бою!",
					function getResult()
					{
						this.Flags.set("IsTreasure", false);
						this.Contract.m.Destination.clearTroops();
						this.Contract.addUnitsToEntity(this.Contract.m.Destination, this.Const.World.Spawn.WushiDefenders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Treasure2",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_168.png[/img]{Кочевники убиты, а вы, естественно, отправляетесь проверить, что же они выкопали. Застыв над сооружёнными ими помостами, вы вглядываетесь в яму. Виден сундук, уже обвязанный веревками. Вы благодарите мёртвых кочевников за всю проделанную ими работу, затем поворачиваетесь и с лёгкостью вытаскиваете сундук из земли. Открыв его, вы находите...}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Сокровище!",
					function getResult()
					{
						return 0;
					}

				}
			],
			function start()
			{
				local e = 2;

				for( local i = 0; i < e; i = ++i )
				{
					local item;
					local r = this.Math.rand(1, 4);

					switch(r)
					{
					case 1:
						item = this.new("scripts/items/loot/ancient_gold_coins_item");
						break;

					case 2:
						item = this.new("scripts/items/loot/silverware_item");
						break;

					case 3:
						item = this.new("scripts/items/loot/jade_broche_item");
						break;

					case 4:
						item = this.new("scripts/items/loot/white_pearls_item");
						break;
					}

					this.World.Assets.getStash().add(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "Вы получаете " + item.getName()
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "SandGolems",
			Title = "Перед битвой...",
			Text = "[img]gfx/ui/events/event_160.png[/img]{Вы уже было приготовились напасть, но тут из песков появляется незнакомец. Вздрогнув, он отскакивает и с криками убегает к лагерю кочевников. Вы гонитесь за ним с обнажённым клинком. В то же время, кочевники, отталкивая друг друга и опрокидывая шатры, спешат к своему оружию. Когда вы переводите взгляд на лазутчика, тот вдруг исчезает в песке, вырвавшемся из ближайшей дюны. Песчаная рука, поглотив его, вздымается перед вами, осыпаясь пылью и песком.\n\nВы не в силах понять, что видите перед собой, но все кочевники, как один, кричат \'Ифрит! Ифрит! Ифрит!\'. Безликий и бесформенный, этот ифрит настроен враждебно ко всему, что движется. Битва неминуема. | Вы бросаетесь в сторону кочевников, скользя по дюнам. Поражённые, они с криками наперегонки спешат к своему оружию. Когда вы приближаетесь к лагерю, волна песка врывается в его угол, отбрасывая кочевников. Мгновением спустя из облака пыли вылетает валун, перемалывая одному из кочевников все кости. Огромное песчаное чудовище ревёт и с грохотом движется в вашу сторону. \'Ифрит! Ифрит!\', - кричат кочевники, а вы раздумываете, можно ли направить ярость ифрита на ваших врагов.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "К оружию!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Assassins",
			Title = "Перед битвой...",
			Text = "[img]gfx/ui/events/event_165.png[/img]{Вы нападаете на лагерь как раз в тот момент, когда человек в чёрном, выйдя из шатра, пожимает руку вождя кочевников - не слишком добрый знак. Что ещё хуже: они оба, застыв на середине рукопожатия, замечают ваш отряд. Вождь кочевников кричит: \'Пора ассасинам отработать оказанное гостеприимство!\'. Ассасин в чёрном кивает и обнажает клинок, его соратники выходят из шатров, присоединяясь к кочевникам в сражении!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Вперёд!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Слуга преграждает вам путь в покои, где должен ждать %employer%. В одной руке он держит свиток, в другой - кошель. Отдав вам и то и другое, слуга складывает руки за спину и, разглядывая потолок, произносит по памяти содержимое свитка.%SPEECH_ON%Алчущему крон следует выплатить %reward_completion% крон в соответствии с ранее заключённым соглашением. Забрав награду, он должен немедленно удалиться.%SPEECH_OFF%Слуга переводит взгляд на вас и кивает.%SPEECH_ON%Прочь.%SPEECH_OFF% | Попытавшись войти в покои, где вас должен ждать %employer%, вы натыкаетесь на заточенные лезвия алебард, что скрещивают у вас перед носом покрытые шрамами стражи.%SPEECH_ON%Ты не пройдёшь!%SPEECH_OFF%Вы заявляете, что у вас дело к визирю. Страж лишь молча качает головой. Слуга, подошедший к вам сзади, без лишних слов передаёт вам кошель и столь же молча уходит. Стражники берут алебарды на караул, после чего один из них обращается к вам.%SPEECH_ON%Твоё присутствие достаточно оскорбило визиря уже в первую вашу встречу. Не пытайся ещё больше отравить его бытие. Уходи. Сейчас же. Прежде чем ты отравишь и моё.%SPEECH_OFF% | Направляясь к покоям, где вас должен ждать %employer%, вы замечаете, что с другого конца зала к вам приближается женщина. Когда вы оглядываетесь, она уже на полпути к вам. Четыре птицы, усевшиеся ей на плечи, раскачиваются при каждом шаге.%SPEECH_ON%Алчущий крон.%SPEECH_OFF%Она достаёт кошель и протягивает вам.%SPEECH_ON%%employer% не желает более обонять твоё зловоние, что и так уже успело пропитать его дом. Пересчитай, если желаешь ещё более оскорбить нас, или уходи, если желаешь нам угодить.%SPEECH_OFF%Развернувшись на каблуках, женщина уходит, сопровождаемая хлопаньем крыльев её странного \'платья\'. Одна из птиц разворачивается и пронзительно кричит на вас.}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Уничтожил лагерь кочевников");
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
		if (this.m.SituationID == 0 && this.World.getTime().Days > 3 && this.Math.rand(1, 100) <= 50)
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
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		this.contract.onDeserialize(_in);
	}

});

