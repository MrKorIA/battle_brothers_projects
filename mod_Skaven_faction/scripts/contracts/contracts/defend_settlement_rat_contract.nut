this.defend_settlement_rat_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Reward = 0,
		Kidnapper = null,
		Militia = null
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.defend_settlement_rat";
		this.m.Name = "Защитить поселение от скавенов";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 5.0;
		this.m.MakeAllSpawnsResetOrdersOnContractEnd = false;
		this.m.MakeAllSpawnsAttackableByAIOnceDiscovered = true;
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
					"Защитить %townname% и его окраины от орд скавенов"
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
				local nearestRat = this.Contract.getNearestLocationTo(this.Contract.m.Home, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Rat).getSettlements());
//				local nearestRatBeast = this.Contract.getNearestLocationTo(this.Contract.m.Home, this.World.FactionManager.getFactionOfType(this.Const.FactionType.RatBeast).getSettlements());

//				if (nearestRatBeast.getTile().getDistanceTo(this.Contract.m.Home.getTile()) <= 20 && nearestRat.getTile().getDistanceTo(this.Contract.m.Home.getTile()) > 20)
				if (nearestRat.getTile().getDistanceTo(this.Contract.m.Home.getTile()) > 20)
				{
					this.Flags.set("IsRatBeast", true);
				}
				else
				{
					local r = this.Math.rand(1, 100);

					if (r <= 20)
					{
						this.Flags.set("IsKidnapping", true);
					}
					else if (r <= 40)
					{
						if (this.Contract.getDifficultyMult() >= 0.95)
						{
							this.Flags.set("IsMilitia", true);
						}
					}
				}

				local number = 1;

				if (this.Contract.getDifficultyMult() >= 0.95)
				{
					number = number + this.Math.rand(0, 1);
				}

				if (this.Contract.getDifficultyMult() >= 1.1)
				{
					number = number + 1;
				}

				local locations = this.Contract.m.Home.getAttachedLocations();
				local targets = [];

				foreach( l in locations )
				{
					if (l.isActive() && !l.isMilitary() && l.isUsable())
					{
						targets.push(l);
					}
				}

				number = this.Math.min(number, targets.len());
				this.Flags.set("ActiveLocations", targets.len());
		        local myTile = this.World.State.getPlayer().getTile();
		        local enemyBase = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Rat).getNearestSettlement(myTile);

				for( local i = 0; i != number; i = ++i )
				{
					local party;

					if (this.Flags.get("IsRatBeast"))
					{
			            party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.RatBeast).spawnEntity(enemyBase.getTile(), "Стая волкокрысов", false, this.Const.World.Spawn.WolfRat, this.Math.rand(80, 110) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
			            party.setDescription("Стая волкокрысов, пожирающая всё вокруг.");
					}
					else
					{
			            party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Rat).spawnEntity(enemyBase.getTile(), "Мародеры скавенов", false, this.Const.World.Spawn.RatRaiders, this.Math.rand(80, 110) * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
			            party.setDescription("Банда скавенов, тревожащих местное поселение.");
					}

		            this.Contract.m.UnitsSpawned.push(party.getID());
					party.getLoot().ArmorParts = this.Math.rand(0, 25);
					party.getLoot().Ammo = this.Math.rand(0, 10);
					party.addToInventory("supplies/rat_soup_item");

					party.setAttackableByAI(false);
				    party.setFootprintType(this.Const.World.FootprintsType.Skavens);
					local c = party.getController();
					c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
					c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
					local t = this.Math.rand(0, targets.len() - 1);

					if (i > 0)
					{
						local wait = this.new("scripts/ai/world/orders/wait_order");
						wait.setTime(4.0 * i);
						c.addOrder(wait);
					}

					local move = this.new("scripts/ai/world/orders/move_order");
					move.setDestination(targets[t].getTile());
					c.addOrder(move);
					local raid = this.new("scripts/ai/world/orders/raid_order");
					raid.setTime(40.0);
					raid.setTargetTile(targets[t].getTile());
					c.addOrder(raid);
					targets.remove(t);
				}

				this.Contract.m.Home.setLastSpawnTimeToNow();
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.Home.getSprite("selection").Visible = true;
				this.World.FactionManager.getFaction(this.Contract.getFaction()).setActive(false);
			}

			function update()
			{
				if (this.Contract.m.UnitsSpawned.len() == 0 || this.Flags.get("IsEnemyHereDialogShown"))
				{
					local isEnemyGone = true;

					foreach( id in this.Contract.m.UnitsSpawned )
					{
						local p = this.World.getEntityByID(id);

						if (p != null && p.isAlive() && p.getDistanceTo(this.Contract.m.Home) <= 1200.0)
						{
							isEnemyGone = false;
							break;
						}
					}

					if (isEnemyGone)
					{
						if (this.Flags.get("HadCombat"))
						{
							this.Contract.setScreen("ItsOver");
							this.World.Contracts.showActiveContract();
						}

						this.Contract.setState("Return");
						return;
					}
				}

				if (!this.Flags.get("IsEnemyHereDialogShown"))
				{
					local isEnemyHere = false;

					foreach( id in this.Contract.m.UnitsSpawned )
					{
						local p = this.World.getEntityByID(id);

						if (p != null && p.isAlive() && p.getDistanceTo(this.Contract.m.Home) <= 700.0)
						{
							isEnemyHere = true;
							break;
						}
					}

					if (isEnemyHere)
					{
						this.Flags.set("IsEnemyHereDialogShown", true);

						foreach( id in this.Contract.m.UnitsSpawned )
						{
							local p = this.World.getEntityByID(id);

							if (p != null && p.isAlive())
							{
							}
						}

						if (this.Flags.get("IsRatBeast"))
						{
							this.Contract.setScreen("RatBeastAttack");
						}
						else
						{
							this.Contract.setScreen("DefaultAttack");
						}

						this.World.Contracts.showActiveContract();
					}
				}
				else if (this.Flags.get("IsKidnapping") && !this.Flags.get("IsKidnappingInProgress") && this.Contract.m.UnitsSpawned.len() == 1)
				{
					local p = this.World.getEntityByID(this.Contract.m.UnitsSpawned[0]);

					if (p != null && p.isAlive() && !p.isHiddenToPlayer() && !p.getController().hasOrders())
					{
						local c = p.getController();
						c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(true);
						c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(true);
						this.Contract.m.Kidnapper = this.WeakTableRef(p);
						this.Flags.set("IsKidnappingInProgress", true);
						this.Flags.set("KidnappingTooLate", this.Time.getVirtualTimeF() + 60.0);
						this.Contract.setScreen("Kidnapping1");
						this.World.Contracts.showActiveContract();
						this.Contract.setState("Kidnapping");
					}
				}

				if (this.Flags.get("IsMilitia") && !this.Flags.get("IsMilitiaDialogShown"))
				{
					this.Flags.set("IsMilitiaDialogShown", true);
					this.Contract.setScreen("Militia1");
					this.World.Contracts.showActiveContract();
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.Flags.set("HadCombat", true);
			}

			function onCombatVictory( _combatID )
			{
				this.Flags.set("HadCombat", true);
			}

		});
		this.m.States.push({
			ID = "Kidnapping",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Спасите пленных, которых уводят",
					"Вернитесь в " + this.Contract.m.Home.getName()
				];
				this.Contract.m.Home.getSprite("selection").Visible = false;
				this.World.FactionManager.getFaction(this.Contract.getFaction()).setActive(false);

				if (this.Contract.m.Kidnapper != null && !this.Contract.m.Kidnapper.isNull())
				{
					this.Contract.m.Kidnapper.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.m.Kidnapper == null || this.Contract.m.Kidnapper.isNull() || !this.Contract.m.Kidnapper.isAlive())
				{
					if (this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() <= 5.0)
					{
						this.Flags.set("IsKidnapping", false);
						this.Contract.setScreen("Kidnapping2");
					}
					else
					{
						this.Contract.setScreen("Kidnapping3");
					}

					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
				else if (this.Contract.m.Kidnapper.isHiddenToPlayer() && this.Time.getVirtualTimeF() > this.Flags.get("KidnappingTooLate"))
				{
					this.Contract.setScreen("Kidnapping3");
					this.World.Contracts.showActiveContract();
					this.Contract.setState("Return");
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.Flags.set("HadCombat", true);
			}

			function onCombatVictory( _combatID )
			{
				this.Flags.set("HadCombat", true);
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Вернитесь в " + this.Contract.m.Home.getName()
				];
				this.Contract.m.Home.getSprite("selection").Visible = true;
				this.World.FactionManager.getFaction(this.Contract.getFaction()).setActive(true);

				if (this.Contract.m.Kidnapper != null && !this.Contract.m.Kidnapper.isNull())
				{
					this.Contract.m.Kidnapper.getSprite("selection").Visible = false;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					local locations = this.Contract.m.Home.getAttachedLocations();
					local numLocations = 0;

					foreach( l in locations )
					{
						if (l.isActive() && !l.isMilitary() && l.isUsable())
						{
							numLocations = ++numLocations;
						}
					}

					if (numLocations == 0 || this.Flags.get("ActiveLocations") - numLocations >= 2)
					{
						if (this.Flags.get("IsKidnapping") && this.Flags.get("IsKidnappingInProgress"))
						{
							this.Contract.setScreen("Failure2");
						}
						else
						{
							this.Contract.setScreen("Failure1");
						}
					}
					else if (this.Flags.get("ActiveLocations") - numLocations >= 1)
					{
						if (this.Flags.get("IsKidnapping") && this.Flags.get("IsKidnappingInProgress"))
						{
							this.Contract.setScreen("Success4");
						}
						else
						{
							this.Contract.setScreen("Success2");
						}
					}
					else if (this.Flags.get("IsKidnapping") && this.Flags.get("IsKidnappingInProgress"))
					{
						this.Contract.setScreen("Success3");
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
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer% стоит у карты, разложенной на столе, и водит пальцем по едва заметным тропам. Он поднимает взгляд, когда вы входите.%SPEECH_ON%Смотри сюда, наёмник.%SPEECH_OFF%Он тычет в грязное пятно у южной околицы.%SPEECH_ON%Три дня назад здесь нашли крестьянина. Крови в нём почти не осталось, а рядом с ним — следы, каких не оставляет ни один зверь. Длинные когти, след раздвоенного хвоста, мерзкий запах. Скавены прощупывают почву.%SPEECH_OFF%Он выпрямляется и скрещивает руки.%SPEECH_ON%Я не нанимал бы тебя для прогулок. Эти твари не придут открытым полем — они вылезут из нор, из старых погребов, из канав, оттуда, где никто их не ждёт. Ты же должен быть там, где они появятся. И остановить их, пока они не сожрали весь урожай и половину жителей в придачу. Говори, берёшься?%SPEECH_OFF% | В комнате тяжело пахнет воском и потом. %employer% сидит у открытого окна, но не смотрит на улицу — он прислушивается.%SPEECH_ON%Слышишь?%SPEECH_OFF%Вы молчите, а он качает головой.%SPEECH_ON%Тишина — вот что я слышу. А должна быть ругань пьяниц, скрип телег, детский плач. Скавены вырезали целый хутор в паре лиг отсюда. Никто не ушёл. Теперь они наверняка придут сюда.%SPEECH_OFF%Он поворачивается к вам — во взгляде не страх, а злая решимость.%SPEECH_ON%Мне нужно, чтобы ты встретил их до того, как они доберутся до нашего поселения. Убей каждого, кто сунет нос в мои поля. Заплачу сполна. Что скажешь?%SPEECH_OFF% | На столе давно остыл ужин — %employer% так и не притронулся к нему. Он отодвигает тарелку в сторону и кладёт перед вами грязную тряпицу.%SPEECH_ON%Это сняли с тела мельника. Он был ещё жив, когда его нашли. Правда, рассказывать уже не мог.%SPEECH_OFF%Вы разворачиваете тряпку — на ней нацарапаны какие-то знаки, похожие на крысиные хвосты.%SPEECH_ON%Я знаю, что это значит. Скавены собирают силы. Не просто шайка — целый выводок. Нам нужен не сторож у ворот, а тот, кто выйдет в поля и перебьёт их всех.%SPEECH_OFF%Он протягивает руку с тяжёлым кошелём.%SPEECH_ON%Кроны есть. И люди, которые их заработают. Ты будешь этим человеком?%SPEECH_OFF% | Едва вы переступаете порог, как %employer% поднимает ладонь, призывая помолчать, и застывает в ожидании. Через мгновение из-под пола доносится слабый скребущий звук — кто-то или что-то копается под домом. Он смотрит на вас в упор.%SPEECH_ON%Каждую ночь. Сначала мы думали: крысы. Обычные. Но крысы не утаскивают овец целиком и не оставляют следов от когтей на камнях. Скавены уже под нами. Они ждут команды. Или голода.%SPEECH_OFF%Он кивает на люк в углу.%SPEECH_ON%Этот ход ведёт к старой канаве. Если они полезут оттуда, мы не успеем даже закричать. Я заплачу тебе за то, чтобы ты нашёл их прежде, чем это случится. Ну что, берёшь этот контракт?%SPEECH_OFF% | %employer% стоит, прислонившись к столбу на крыльце. Вокруг суетятся горожане, но никто не подходит ближе, чем на десять шагов.%SPEECH_ON%Я не люблю говорить при чужих, наёмник. Скажу коротко.%SPEECH_OFF%Он кивает в сторону поля, где чернеют выжженные круги.%SPEECH_ON%Там были дома. Там были люди. Сейчас там только пепел и запах, от которого воротит. Скавены приходят не за едой — им нужна земля для нового логова, и этот город приглянулся им больше прочих. Я хочу, чтобы ты доказал им, что это место уже занято.%SPEECH_OFF%Он протягивает туго набитый мешочек.%SPEECH_ON%Он может стать твоим, когда я увижу их черепа на кольях. Ты в деле?%SPEECH_OFF% | За дверью слышен шум, но %employer% закрывает окно и задвигает засов.%SPEECH_ON%Не хочу, чтобы эти крики отвлекали тебя от сути.%SPEECH_OFF%Он подходит к столу, где лежат обрывки карт и окровавленный нож.%SPEECH_ON%Вчера скавены прорвали оборону на восточном пастбище. Два десятка голов — и ни одного тела, которое можно было бы опознать. Они не грабят. Они собирают... материал.%SPEECH_OFF%Он смотрит вам прямо в глаза.%SPEECH_ON%Я не попрошу тебя убить их всех. Я прошу тебя сделать так, чтобы они больше к нам не возвращались. За это готов заплатить больше обычного. Ты согласен?%SPEECH_OFF% | Огарок свечи на столе оплыл до самого основания — %employer% не спал всю ночь. Навалившись грудью на стол, он растирает виски.%SPEECH_ON%У меня было три дозорных. Два мертвы. Третий не говорит, а только смеётся и грызёт пальцы.%SPEECH_OFF%Он поднимает голову.%SPEECH_ON%Скавены уже здесь. Не в городе — вокруг. Они ждут, когда мы выдохнемся. Но я не собираюсь сидеть сложа руки, пока они придут. Отправляю тебя на охоту. Найди их гнездо, разори его, убей всех, кто носит шерсть и имеет хвост.%SPEECH_OFF%Он открывает шкатулку с кронами.%SPEECH_ON%Мне есть чем заплатить. Только скажи \'да\', и можешь начинать.%SPEECH_OFF% | В комнате тишина. %employer% стоит у стены, на которой углём начерчены какие-то руны. Оборачиваясь, он показывает перевязанную руку.%SPEECH_ON%Это я вчера проверил подвал. Ошибся.%SPEECH_OFF%Он приподнимает край повязки, обнажая рваную рану.%SPEECH_ON%Скавен успел меня цапнуть. Но и я успел отрубить ему башку. Вопрос в том, сколько их ещё сидит в норах вокруг города.%SPEECH_OFF%Он подходит ближе, и в его голосе появляется сталь.%SPEECH_ON%Мне нужен тот, кто пойдёт не в мой подвал, а в поля. Кто найдёт их норы и выкурит их огнём и железом. Ты умеешь делать это, наёмник? Ответь сейчас.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Сколько же %townname% готов заплатить за свою безопасность? | Это должно стоить немало крон, верно?}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Боюсь, вам придётся справляться самим. | Сейчас у нас есть более важные дела. | Желаю вам удачи, мы не будем в этом участвовать.}",
					function getResult()
					{
						if (this.Math.rand(1, 100) <= 60)
						{
							this.World.Contracts.removeContract(this.Contract);
							return 0;
						}
						else
						{
							return "Plea";
						}
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "Plea",
			Title = "Переговоры",
			Text = "[img]gfx/ui/events/event_43.png[/img]{%employer% идёт к чёрту со своим предложением. Но на улице вас встречает толпа крестьян. Каждый из них держит в руках какую-то \'ценность\', вернее то, что эти простолюдины считают таковым: курицы, дешёвые ожерелья, изношенную одежду, ржавые кузнечные инструменты... Один из крестьян, держа подмышкой пару куриц, выходит вперёд.%SPEECH_ON%Пожалуйста! Вы не можете уйти! Вы должны помочь нам!%SPEECH_OFF%%randombrother% смеётся, но вы вынуждены признать — бедняки умеют задеть за живое. Может, стоит остаться и помочь? | Выходя от несостоявшегося нанимателя, вы сталкиваетесь с женщиной, ожидающей вас. Её окружает толпа детей, носящихся вокруг, ползающих меж её ног. На руках она держит младенца, сосущего грудь.%SPEECH_ON%Наёмник, прошу, ты не можешь оставить нас! Этот город нуждается в тебе! Дети нуждаются в тебе!%SPEECH_OFF%Она задумывается, затем распахивает другую полу своей рубахи. Это распутно и соблазнительно одновременно.%SPEECH_ON%Я нуждаюсь в тебе...%SPEECH_OFF%Вы вскидываете руку, останавливая её, а заодно вытирая внезапно вспотевший лоб. Быть может, помочь этим... решительным людям — не такая уж плохая идея? | Вы уже собираетесь покидать %townname%, когда замечаете маленького щенка, который с лаем подбегает к вам и лижет ваши сапоги. За ним во весь дух мчится паренёк. Он садится и обнимает щенка, прижимаясь к нему.%SPEECH_ON%Ох, {Марли | Бумка | Джо-джо}, я так тебя люблю!%SPEECH_OFF%Перед глазами проносится картина — скавены убивают ребёнка и его питомца. У вас есть дела поважнее, чем изображать из себя сыщика или городового, но щенок просто лижет лицо малыша, а тот выглядит таким счастливым...%SPEECH_ON%Ха-ха-ха! Мы ведь всегда будем вместе, правда? Всегда!%SPEECH_OFF%Проклятье. | Выходя из особняка несостоявшегося нанимателя, вы сталкиваетесь с незнакомцем.%SPEECH_ON%Господин, я слышал, что ты отклонил его предложение. Это позор, вот что я хочу сказать. Я думал, в этом мире достаточно хороших людей, но видимо ошибался. Что же, удачи в твоих путешествиях... хотя бы помолись за нас.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = false,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Проклятье, мы не бросим этих людей на погибель. | Ладно, ладно, мы не бросим %townname%. По крайней мере, поговорим об оплате.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Уверен, вы выкрутитесь. Прочь с дороги. | Я не собираюсь рисковать отрядом \'%companyname%\' ради каких-то недокормленных крестьян!}",
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
			ID = "RatBeastAttack",
			Title = "Неподалёку от поселения %townname%",
			Text = "[img]gfx/ui/events/rat_event_05.png[/img]{Когда вы стоите на страже, к вам подбегает обезумевший крестьянин. Он запыхался так, что едва выговаривает слова.%SPEECH_ON%Мёртвые... мёртвые идут!%SPEECH_OFF%Взглянув вдаль, вы действительно замечаете толпу неестественно бледных существ, бредущих в вашем направлении... | Стон, донёсшийся из-за холма, совсем не похож на возню грызунов. Здесь нет крыс, лишь нежить! Вы ждали нападения подлых грызунов, но вместо них к вам приближается толпа ковыляющих существ. К несчастью, смена врага не отменяет контракта — готовьтесь к бою! | Из городской часовни раздаётся звон колокола. Вы слушаете его, осматривая горизонт. Колокол не умолкает. Один из местных жителей стоит рядом с вами.%SPEECH_ON%Первый удар, второй, третий... четвёртый?!%SPEECH_OFF%На его лбу выступает испарина. Когда колокол бьёт последний раз, его глаза вылезают из орбит.%SPEECH_ON%Это... это невозможно!%SPEECH_OFF%Вы спрашиваете, чего он так испугался. Он пятится.%SPEECH_ON%Мёртвые снова ходят по земле!%SPEECH_OFF%Прекрасно, а вы уж было подумали, что этот контракт будет лёгким. | Вы слышите стоны, бессвязное ворчание... а затем замечаете ковыляющую к вам нежить! Здесь нет скавенов, возможно, они специально навели на поселение этих нечестивых тварей... но контракт не отменён — защищайте город!}",
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
			ID = "DefaultAttack",
			Title = "Неподалёку от поселения %townname%",
			Text = "[img]gfx/ui/events/rat_event_07.png[/img]Скавены уже близко! Приготовьтесь к битве, защищайте город!",
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
			ID = "ItsOver",
			Title = "Неподалёку от поселения %townname%",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Битва окончена, ваши люди отдыхают, воспользовавшись долгожданной передышкой. %employer% будет ждать вас в городе. | Вы осматриваете мертвецов, разбросанных по полю боя. Это жуткое зрелище, но по какой-то причине оно придаёт вам бодрости. Ужасающие холмы мёртвых тел напоминают вам о всех тех жизнях, что вам ещё предстоит пожать, принеся в жертву этому жестокому миру. Таким людям как %employer%, стоило бы посмотреть на это, но они никогда такого не сделают. Наоборот, это вам предстоит отправиться на встречу с ним. | Поле усеяно плотью, костями и залито кровью... и сложно понять, где заканчивается один их владелец и начинается другой. Вороны кружат в небесах, оперённые тени скользят по мёртвым телам, птицы ждут своей трапезы. %randombrother% подходит к вам и спрашивает, не пора ли возвращаться к нанимателю. %employer% ждёт. Вы отворачиваетесь от поля битвы и киваете. | Поле боя выглядит будто причудливые руины, сложенные из мёртвых тел. Словно бы это и есть их настоящая форма, окоченевшая и спокойная, словно бы вся жизнь чередой непрерывных ошибок вела их к этому уделу. %randombrother% подходит и спрашивает, всё ли с вами в порядке. Честно говоря, вы не уверены, но отвечаете, что пришла пора возвращаться. %employer% ждёт вас. | Земля заполнена искорёженными, окоченевшими телами, ведь сражение само решает, какая участь ждёт каждого. Отрубленные головы выглядят почти умиротворённо. Вы надеетесь, что когда-нибудь обретёте столь же быструю смерть... хотя другая ваша часть надеется, что подобная участь уготована вашим врагам.\n\n %randombrother% подходит к вам, интересуясь, какие будут приказы. Вы отводите взгляд от поля боя и говорите, что отряду \'%companyname%\' пора готовиться к возвращению. %employer% ждёт вас.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Мы возвращаемся в город!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ItsOverDidNothing",
			Title = "Неподалёку от поселения %townname%",
			Text = "[img]gfx/ui/events/event_30.png[/img]Воздух наполнен дымом, едким запахом горящего дерева и, что ещё хуже, пеплом сгоревших надежд. %townname% вручил свою судьбу в руки отряда \'%companyname%\' — и это стало ужасной ошибкой.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Всё пошло не по плану...",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Militia1",
			Title = "%townname%",
			Text = "[img]gfx/ui/events/event_80.png[/img]{Вы готовитесь оборонять поселение %townname% - и поэтому в ваше подчинение переходит местное ополчение. Они готовы выполнять ваши приказы, спрашивают у вас лишь где их место в строю. | Местное ополчение присоединилось к битве! Это не бойцы, а сброд, но, тем не менее, и они будут полезны. Вопрос в том, куда их отправить? | Ополчение поселения %townname% присоединяется к вам! И хотя они представляют из себя лишь толпу плохо вооружённых неумёх, их решимость защищать свои дома и лачуги велика. Они готовы выполнять ваши приказы, полагая, что вы отправите их туда, где они наиболее необходимы. | Вы не одиноки в этой битве! Ополчение поселения %townname% присоединяется к вам. Они хотят драться и спрашивают вас, где более всего нужны.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Встать в строй, слушай мою команду!",
					function getResult()
					{
						return "Militia2";
					}

				},
				{
					Text = "Защищайте сам город %townname%.",
					function getResult()
					{
						local home = this.Contract.m.Home;
						local party = this.World.FactionManager.getFaction(this.Contract.getFaction()).spawnEntity(home.getTile(), "Ополчение поселения " + home.getName(), false, this.Const.World.Spawn.Militia, home.getResources() * 0.7);
						party.getSprite("banner").setBrush(home.getBanner());
						party.setDescription("Храбрые люди, готовые отдать жизнь, дабы защитить свои дома. Крестьяне, ремесленники, мастеровые — но ни одного настоящего воина.");
						party.setFootprintType(this.Const.World.FootprintsType.Militia);
						this.Contract.m.Militia = this.WeakTableRef(party);
						local c = party.getController();
						local guard = this.new("scripts/ai/world/orders/guard_order");
						guard.setTarget(home.getTile());
						guard.setTime(300.0);
						local despawn = this.new("scripts/ai/world/orders/despawn_order");
						c.addOrder(guard);
						c.addOrder(despawn);
						return 0;
					}

				},
				{
					Text = "Защищайте окраины города %townname%.",
					function getResult()
					{
						local home = this.Contract.m.Home;
						local party = this.World.FactionManager.getFaction(this.Contract.getFaction()).spawnEntity(home.getTile(), "Ополчение поселения " + home.getName(), false, this.Const.World.Spawn.Militia, home.getResources() * 0.7);
						party.getSprite("banner").setBrush(home.getBanner());
						party.setDescription("Храбрые люди, готовые отдать жизнь, дабы защитить свои дома. Крестьяне, ремесленники, мастеровые — но ни одного настоящего воина.");
						party.setFootprintType(this.Const.World.FootprintsType.Militia);
						this.Contract.m.Militia = this.WeakTableRef(party);
						local c = party.getController();
						local locations = home.getAttachedLocations();
						local targets = [];

						foreach( l in locations )
						{
							if (l.isActive() && !l.isMilitary() && l.isUsable())
							{
								targets.push(l);
							}
						}

						local guard = this.new("scripts/ai/world/orders/guard_order");
						guard.setTarget(targets[this.Math.rand(0, targets.len() - 1)].getTile());
						guard.setTime(300.0);
						local despawn = this.new("scripts/ai/world/orders/despawn_order");
						c.addOrder(guard);
						c.addOrder(despawn);
						return 0;
					}

				},
				{
					Text = "Спрячьтесь где-нибудь и не мешайте нам.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Militia2",
			Title = "В %townname%",
			Text = "[img]gfx/ui/events/event_80.png[/img]После того, как вы решили принять руководство над ополченцами, они спрашивают, какое оружие им стоит выбрать для предстоящего сражения.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Возьмите луки и стреляйте из-за наших спин.",
					function getResult()
					{
						for( local i = 0; i != 4; i = ++i )
						{
							local militia = this.World.getGuestRoster().create("scripts/entity/tactical/humans/militia_guest_ranged");
							militia.setFaction(1);
							militia.setPlaceInFormation(19 + i);
							militia.assignRandomEquipment();
						}

						return 0;
					}

				},
				{
					Text = "Возьмите мечи и щиты, вы будете сражаться в первых рядах.",
					function getResult()
					{
						for( local i = 0; i != 4; i = ++i )
						{
							local militia = this.World.getGuestRoster().create("scripts/entity/tactical/humans/militia_guest");
							militia.setFaction(1);
							militia.setPlaceInFormation(19 + i);
							militia.assignRandomEquipment();
						}

						return 0;
					}

				},
				{
					Text = "Берите что хотите.",
					function getResult()
					{
						for( local i = 0; i != 4; i = ++i )
						{
							local militia;

							if (this.Math.rand(0, 1) == 0)
							{
								militia = this.World.getGuestRoster().create("scripts/entity/tactical/humans/militia_guest");
							}
							else
							{
								militia = this.World.getGuestRoster().create("scripts/entity/tactical/humans/militia_guest_ranged");
							}

							militia.setFaction(1);
							militia.setPlaceInFormation(19 + i);
							militia.assignRandomEquipment();
						}

						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "MilitiaVolunteer",
			Title = "Неподалёку от поселения %townname%",
			Text = "[img]gfx/ui/events/event_80.png[/img]{После сражения к вам подходит один из ополченцев и, кланяясь, просит принять его в отряд.%SPEECH_ON%Господин, мои дела в городе %townname% закончены. А доблесть отряда \'%companyname%\' воистину велика! Потому, если позволишь, я бы хотел сражаться рядом с тобой и твоими людьми.%SPEECH_OFF% | После битвы к вам подходит один из ополченцев поселения %townname%, заявляющий, что с радостью будет и дальше сражаться вместе с отрядом \'%companyname%\' — отчасти потому, что был поражён умениями ваших бойцов, отчасти потому, что его служба в городском ополчении не была должным образом оплачена.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Добро пожаловать в \'%companyname%\'!",
					function getResult()
					{
						return 0;
					}

				},
				{
					Text = "В отряде нет места для тебя.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Kidnapping1",
			Title = "Неподалёку от поселения %townname%",
			Text = "[img]gfx/ui/events/event_30.png[/img]{Пока вы ищете скавенов, подходит крестьянин и говорит, что поблизости напала группа крыс и захватила с собой нескольких человек. Вы в неверии качаете головой. Как им удалось пробраться незамеченными? Простолюдин лишь беспомощно разводит руками.%SPEECH_ON%Я думал, вы должны нам помогать. Почему вы ничего не сделали?%SPEECH_OFF%Вы спрашиваете, далеко ли они ушли. Крестьянин лишь пожимает плечами. Нельзя терять время — если поторопиться, шанс вернуть их ещё есть. | Человек в лохмотьях, держащий сломанные вилы, бежит к вашему отряду. Он падает и рыдает у ваших ног.%SPEECH_ON%Скавены напали! Где вы были? Они убивают людей... жгут дома... и... и они взяли пленных! Пожалуйста, спасите их!%SPEECH_OFF%Вы и %randombrother% смотрите друг на друга. Вы киваете.%SPEECH_ON%Готовь людей. Нам нужно догнать этих крыс, пока они не скрылись.%SPEECH_OFF% | Вы всматриваетесь в горизонт в поисках любых признаков скавенов. Внезапно %randombrother% подходит к вам с женщиной. Она рассказывает, что крысы уже напали, убили множество крестьян, а тех, кого не убили, угнали с собой. Наёмник кивает.%SPEECH_ON%Похоже, они пробрались мимо нас, сэр.%SPEECH_OFF%Теперь у вас только один выход — вернуть этих людей! | Устроившись недалеко от поселения под названием %townname%, вы ожидаете нападения скавенов. Вы думали, что это будет легко, но внезапное появление обезумевшего простолюдина говорит об обратном. Крестьянин объясняет, что мародёры устроили засаду на окраинах. Они перебили всех, кого смогли, а затем забрали с собой несколько мужчин, женщин и детей. Мужчина, то ли пьяный, то ли в шоке, невнятно умоляет.%SPEECH_ON%Верни... верни их, а?%SPEECH_OFF% | Несколько разгневанных крестьян выходят на дорогу, перекрытую вашим караулом, и бурлящей толпой несутся к вам.%SPEECH_ON%Я думал, мы платим вам, чтобы вы защищали нас! Где вы были!%SPEECH_OFF%Они покрыты кровью. Некоторые полураздеты. Одна женщина с оголённой грудью, слишком злая, чтобы заботиться о неприличии. Вы спрашиваете группу, о чём они говорят. Мужчина, прижимающий трость к груди, объясняет, что скавены уже напали, дойдя до ближайшей деревушки. Они перебили всех, кого смогли, а затем, утолив жажду крови, увели остальных в плен. Вы киваете.\n\nМы вернём их.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Вперёд, найдём их!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Kidnapping2",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/rat_event_08.png[/img]{Вложив меч в ножны, вы даёте приказ освободить пленных. Вереница ошеломлённых крестьян освобождается от кожаных поводков, цепей и собачьих клеток. Они благодарят вас за своевременное прибытие и за жестокость, которую вы обрушили на скавенов. | Скавены перебиты все до единого. Вы отправляете своих людей на поиски и спасение каждого крестьянина, которого они смогут найти. Все невольники собираются вместе, обнимаются и плачут, обезумев от счастья, что пережили это ужасное испытание. | Убив последних крыс, вы велите отряду освободить невольников, которых увели скавены. Они подходят к вам по очереди: некоторые целуют ваши руки, другие — ваши ноги. Вы лишь говорите им возвращаться в поселение %townname%, как и собираетесь сделать сами.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Похоже, всё кончено.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Kidnapping3",
			Title = "Неподалёку от поселения %townname%",
			Text = "[img]gfx/ui/events/event_53.png[/img]{К сожалению, скавены скрылись с невольниками. Да пребудут с этими несчастными душами боги. | У вас не получилось — вы не смогли спасти этих бедных крестьян. Теперь только боги знают, что с ними станет. | К сожалению, крысы-мародёры скрылись со своим человеческим грузом. Теперь этим беднягам придётся выживать самим. Однако истории, которые вы слышали, говорят о том, что им совсем не долго осталось. | Скавены ушли, а вместе с ними и их пленники. Вы понятия не имеете, что теперь с ними станет, но знаете, что ничего хорошего. Рабство. Пытки. Смерть. Сложно сказать, что из этого хуже.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{%townname% и его жители этого не оценят... | Быть может, их удастся выкупить...}",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Приветствуя вас, %employer% выглядит весьма самодовольно.%SPEECH_ON%Дело сделано.%SPEECH_OFF%Он кивает, опрокидывая в себя кубок вина, не считая нужным предложить его вам.%SPEECH_ON%Да. Город будет вечно благодарен тебе за помощь. Эта благодарность имеет и... денежное выражение.%SPEECH_OFF%Он показывает на угол комнаты, где стоит шкатулка с кронами.%SPEECH_ON%%reward% крон, как мы и договаривались. Ещё раз спасибо, наёмник.%SPEECH_OFF% | %employer% приветствует вас по возвращении, предлагая кубок вина.%SPEECH_ON%Выпей, наёмник, ты заслужил.%SPEECH_OFF%У вина особенный вкус... горделивый, если подобное определение вообще применимо к такому. Ваш наниматель ходит вокруг своего стола, не находя себе места от радости.%SPEECH_ON%Ты смог защитить город, как и обещал! Я весьма впечатлён!%SPEECH_OFF%Он кивает и указывает кубком на деревянный сундучок.%SPEECH_ON%Более чем впечатлён.%SPEECH_OFF%Открыв сундучок, вы видите приятную горку золотых монет. | %employer% приглашает вас в свой кабинет.%SPEECH_ON%Знаешь, я смотрел из окна и видел всё, что происходило... ну, большую часть. Лучшую часть, я полагаю.%SPEECH_OFF%Вы поднимаете бровь.%SPEECH_ON%О, не смотри на меня так. Не думаю, что это плохо — наслаждаться подобным. Мы ведь живы, верно? Хорошие парни победили.%SPEECH_OFF%Вы поднимаете другую бровь.%SPEECH_ON%Ну... в любом случае, твоя плата, как и было обещано.%SPEECH_OFF%Он вручает вам сундучок. %reward% крон. | Возвратившись к нанимателю, вы обнаруживаете, что почти все его вещи собраны и всё готово к отъезду. Шутя, вы принимаете обеспокоенный вид.%SPEECH_ON%Куда-то торопишься?%SPEECH_OFF%%employer% опускается в своё кресло.%SPEECH_ON%У меня были... сомнения, наёмник. Осуждаешь меня? Дело твоё, но не стоит сомневаться в моей платёжеспособности.%SPEECH_OFF%Он проводит рукой по столу. На его краю лежит кошель, полный золота.%SPEECH_ON%%reward% крон, как и договаривались.%SPEECH_OFF% | %employer% поднимается со своего кресла, приветствуя вас. Он неловко, но искренне кланяется. Кивает головой на окно, из которого доносится восторженный гул крестьянских голосов.%SPEECH_ON%Слышишь? Ты заслужил это, наёмник. Люди полюбили тебя.%SPEECH_OFF%Вы киваете, но пришли вы сюда не ради любви простого народа.%SPEECH_ON%Кажется, я заслужил кое-что ещё?%SPEECH_OFF%%employer% улыбается.%SPEECH_ON%Человек дела. Готов поспорить, именно это обеспечивает тебе... превосходство. Разумеется, ты заслужил ещё и это.%SPEECH_OFF%Он поднимает деревянный сундучок, ставит на стол и открывает крышку. Сияние золотых монет наполняет ваше сердце радостью. | %employer% глядел в окно, когда вы вошли. Он витал в мечтах, подперев голову рукой. Вы прервали его раздумья.%SPEECH_ON%Обо мне думаешь?%SPEECH_OFF%Он усмехнулся и игриво положил руку на сердце.%SPEECH_ON%Ты воистину мужчина моей мечты, наёмник.%SPEECH_OFF%Он пересёк комнату, взял шкатулку с книжной полки, поставил её на стол и отпер. Славная горка золотых монет предстала перед вашим взором. %employer% ухмыльнулся.%SPEECH_ON%А о чём мечтаешь ты?%SPEECH_OFF% | %employer% расположился за своим столом.%SPEECH_ON%Я видел многое. Смерть, убийства...%SPEECH_OFF%Вы присаживаетесь.%SPEECH_ON%Надеюсь, тебе понравилось представление. Просмотр платный, разумеется.%SPEECH_OFF%%employer% кивает, берёт увесистый кошель и передаёт его вам.%SPEECH_ON%Я бы заплатил чуть больше за выход на бис, но не уверен, что казна нашего городка выдержит это.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{Отряд \'%companyname%\' найдёт этому применение. | Оплата за трудную работу.}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Защитил город от скавенов");
						this.World.Contracts.finishActiveContract();

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
		this.m.Screens.push({
			ID = "Success2",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_30.png[/img]{%employer% стоит у распахнутого окна и, приветствуя вас по возвращении, сразу указывает на что-то вдалеке.%SPEECH_ON%Видишь это? Там, вдалеке.%SPEECH_OFF%Вы встаёте рядом с ним. Он спрашивает.%SPEECH_ON%Что ты видишь?%SPEECH_OFF%Горизонт затянут дымом. Об этом вы и говорите.%SPEECH_ON%Верно, дым. Я нанял тебя, чтобы скавены не смогли... дымить, верно? Впрочем... большая часть города всё ещё цела.%SPEECH_OFF%Он бросает вам кошель.%SPEECH_ON%Хорошая работа, наёмник. Просто... недостаточно качественная.%SPEECH_OFF% | Когда вы вернулись, %employer% выглядит одновременно счастливым и грустным, пьяным и трезвым. В общем, не таким, каким вы хотели бы его видеть.%SPEECH_ON%Хорошая работа, наёмник. Ты уложил этих крыс в землю. Но должен заметить, что они сожгли часть построек на окраине.%SPEECH_OFF%Вы киваете. Не стоит лгать о том, что вы не можете скрыть.%SPEECH_ON%Вот твоя плата, но ты должен понимать, что для восстановления поселения нужны деньги. И, очевидно, они будут взяты из твоего кошелька...%SPEECH_OFF% | Вернувшись, вы видите, что %employer% ссутулился в своём кресле.%SPEECH_ON%Большинство жителей славного города %townname% счастливы, но всё же не все. Думаю, ты и сам догадываешься, о ком я говорю — вопрос, разумеется, риторический.%SPEECH_OFF%Скавенам удалось уничтожить часть строений на окраине.%SPEECH_ON%Мне нужны средства на восстановление тех частей поселения, что были разорены крысами. Так что, уверен, ты поймёшь, почему в твоём кошельке будет меньше монет...%SPEECH_OFF%Вы пожимаете плечами. Ничего не поделаешь. | %employer% стоит у книжной полки, берёт оттуда книгу и раскрывает её на столе.%SPEECH_ON%Здесь подсчёты. Уверен, ты не сможешь понять их, но говорят они вот о чём: скавенам удалось уничтожить часть города, и теперь мне нужно золото, чтобы отстроить всё заново. К сожалению, у меня нет такого количества крон. Уверен, ты понимаешь, к чему я веду.%SPEECH_OFF%Вы киваете, соглашаясь с очевидным. %employer% продолжает.%SPEECH_ON%Я вычту их из твоей платы.%SPEECH_OFF%%employer% взмахом руки указывает на кошель, стоящий на краю стола. Нет смысла спорить об оплате. Вы берёте его и уходите.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{Но это лишь половина того, о чём мы договаривались! | Ничего не поделаешь...}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() / 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractPoor, "Защитил город от скавенов");
						this.World.Contracts.finishActiveContract();

					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion() / 2;
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы получаете [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] крон"
				});
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/rat_raided_situation"), 3, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success3",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Приветствуя вас, %employer% выглядит весьма самодовольно.%SPEECH_ON%Дело сделано.%SPEECH_OFF%Он кивает, опрокидывая в себя кубок вина, не считая нужным предложить его вам.%SPEECH_ON%Да. Город будет вечно благодарен тебе за помощь. Эта благодарность имеет и... денежное выражение.%SPEECH_OFF%Он показывает на угол комнаты, где стоит шкатулка с кронами.%SPEECH_ON%%reward% крон, как мы и договаривались. Ещё раз спасибо, наёмник. Ах да, какой позор, что ты не вызволил этих крестьян...%SPEECH_OFF% | %employer% приветствует вас по возвращении, предлагая кубок вина.%SPEECH_ON%Выпей, наёмник, ты заслужил.%SPEECH_OFF%У вина особенный вкус... горделивый, если подобное определение вообще применимо к такому. Ваш наниматель ходит вокруг своего стола, не находя себе места от радости.%SPEECH_ON%Ты смог защитить город, как и обещал! Я весьма впечатлён!%SPEECH_OFF%Он кивает и указывает кубком на деревянный сундучок.%SPEECH_ON%Более чем впечатлён.%SPEECH_OFF%Открыв сундучок, вы видите приятную горку золотых монет.%SPEECH_ON%Какой позор, что эти крестьяне были пленены. Я вычел соответствующую сумму из твоей платы...%SPEECH_OFF% | %employer% приглашает вас в свой кабинет.%SPEECH_ON%Знаешь, я смотрел из окна и видел всё, что происходило... ну, большую часть. Лучшую часть, я полагаю.%SPEECH_OFF%Вы поднимаете бровь.%SPEECH_ON%О, не смотри на меня так. Не думаю, что это плохо — наслаждаться подобным. Мы ведь живы, верно? Хорошие парни победили.%SPEECH_OFF%Вы поднимаете другую бровь.%SPEECH_ON%Ну... в любом случае, твоя плата, как и было обещано. Да, я слышал, что несколько крестьян были пленены. Так что часть денег отойдёт их семьям.%SPEECH_OFF%Он вручает вам шкатулку. %reward% крон. | Возвратившись к нанимателю, вы обнаруживаете, что почти все его вещи собраны и всё готово к отъезду. Шутя, вы принимаете обеспокоенный вид.%SPEECH_ON%Куда-то торопишься?%SPEECH_OFF%%employer% опускается в своё кресло.%SPEECH_ON%У меня были... сомнения, наёмник. Осуждаешь меня? Дело твоё, но не стоит сомневаться в моей платёжеспособности.%SPEECH_OFF%Он проводит рукой по столу. На его краю лежит кошель, полный золота.%SPEECH_ON%Я урезал плату. Тебе известно, какая судьба ждёт тех крестьян, захваченных скавенами? Да, у меня точно были на то причины.%SPEECH_OFF% | %employer% поднимается со своего кресла, приветствуя вас. Он неловко, но искренне кланяется. Кивает головой на окно, из которого доносится восторженный гул крестьянских голосов.%SPEECH_ON%Слышишь? Ты заслужил это, наёмник. Люди полюбили тебя.%SPEECH_OFF%Вы киваете, но пришли вы сюда не ради любви простого народа.%SPEECH_ON%Кажется, я заслужил кое-что ещё?%SPEECH_OFF%%employer% улыбается.%SPEECH_ON%Человек дела. Готов поспорить, именно это обеспечивает тебе... превосходство. Разумеется, ты заслужил и это. Вернее, немного меньшую сумму. Из-за... неприятности с теми крестьянами, что были захвачены скавенами, понимаешь?%SPEECH_OFF%Он поднимает деревянный сундук, ставит его на стол и открывает крышку. Сияние золотых монет наполняет ваше сердце радостью. | %employer% глядел в окно, когда вы вошли. Он витал в мечтах, подперев голову рукой. Вы прервали его раздумья.%SPEECH_ON%Обо мне думаешь?%SPEECH_OFF%Он усмехнулся и игриво положил руку на сердце.%SPEECH_ON%Ты воистину мужчина моей мечты, наёмник.%SPEECH_OFF%Он пересёк комнату, взял шкатулку с книжной полки, поставил её на стол и отпер. Славная горка золотых монет предстала перед вашим взором. %employer% ухмыльнулся.%SPEECH_ON%Немного меньше, чем ты ожидал? Эти деньги получат семьи тех крестьян, которые были пленены скавенами по твоему попущению. Уверен, ты понимаешь.%SPEECH_OFF% | %employer% расположился за своим столом.%SPEECH_ON%Я видел почти всё. Смерть, убийства...%SPEECH_OFF%Вы садитесь.%SPEECH_ON%Надеюсь, тебе понравилось представление. Просмотр платный, разумеется.%SPEECH_OFF%%employer% кивает, берёт увесистый кошель и передаёт его вам.%SPEECH_ON%Я бы заплатил и за ещё одно, но не уверен, что казна нашего городка выдержит это. А уж те бедняги, что были захвачены скавенами, точно повторения не захотят.%SPEECH_OFF%Заглянув в кошель, вы замечаете, что в нём меньше денег, чем вы ожидали.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{Но это лишь половина того, о чём мы договаривались! | Ничего не поделаешь...}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() / 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractPoor, "Защитил город от скавенов");
						this.World.Contracts.finishActiveContract();

					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion() / 2;
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы получаете [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] крон"
				});
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/rat_raided_situation"), 3, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success4",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_30.png[/img]{%employer% стоит у распахнутого окна и, приветствуя вас по возвращении, сразу указывает на что-то вдалеке.%SPEECH_ON%Видишь это? Там, вдалеке.%SPEECH_OFF%Вы встаёте рядом с ним. Он спрашивает.%SPEECH_ON%Что ты видишь?%SPEECH_OFF%Горизонт затянут дымом. Об этом вы и говорите.%SPEECH_ON%Верно, дым. Я нанял тебя, чтобы скавены не смогли... дымить, верно? Впрочем... большая часть города всё ещё цела.%SPEECH_OFF%Он бросает вам кошель.%SPEECH_ON%Хорошая работа, наёмник. Просто... недостаточно качественная.%SPEECH_OFF% | Когда вы вернулись, %employer% выглядит одновременно счастливым и грустным, пьяным и трезвым. В общем, не таким, каким вы хотели бы его видеть.%SPEECH_ON%Хорошая работа, наёмник. Ты уложил этих крыс в землю. Но должен заметить, что они сожгли часть построек на окраине.%SPEECH_OFF%Вы киваете. Не стоит лгать о том, что вы не можете скрыть.%SPEECH_ON%Вот твоя плата, но ты должен понимать, что для восстановления поселения нужны деньги. И, очевидно, они будут взяты из твоего кошелька...%SPEECH_OFF% | Вернувшись, вы видите, что %employer% ссутулился в своём кресле.%SPEECH_ON%Большинство жителей славного города %townname% счастливы, но всё же не все. Думаю, ты и сам догадываешься, о ком я говорю — вопрос, разумеется, риторический.%SPEECH_OFF%Скавенам удалось уничтожить часть строений на окраине.%SPEECH_ON%Мне нужны средства на восстановление тех частей поселения, что были разорены крысами. Так что, уверен, ты поймёшь, почему в твоём кошельке будет меньше монет...%SPEECH_OFF%Вы пожимаете плечами. Ничего не поделаешь. | %employer% стоит у книжной полки, берёт оттуда книгу и раскрывает её на столе.%SPEECH_ON%Здесь подсчёты. Уверен, ты не сможешь понять их, но говорят они вот о чём: скавенам удалось уничтожить часть города, и теперь мне нужно золото, чтобы отстроить всё заново. К сожалению, у меня нет такого количества крон. Уверен, ты понимаешь, к чему я веду.%SPEECH_OFF%Вы киваете, соглашаясь с очевидным. %employer% продолжает.%SPEECH_ON%Я вычту их из твоей платы.%SPEECH_OFF%%employer% взмахом руки указывает на кошель, стоящий на краю стола. Нет смысла спорить об оплате. Вы берёте его и уходите.}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{Но это лишь половина того, о чём мы договаривались! | Ничего не поделаешь...}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion() / 2);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(0);
						this.World.Contracts.finishActiveContract();

					}

				}
			],
			function start()
			{
				this.Contract.m.Reward = this.Contract.m.Payment.getOnCompletion() / 2;
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы получаете [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Reward + "[/color] крон"
				});
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/rat_raided_situation"), 3, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_30.png[/img]{Когда вы входите в кабинет, %employer% просит закрыть за собой дверь. Со щелчком засова на вас обрушивается поток ругательств и непристойностей, которых вам не приходилось ещё слышать. Спустя некоторое время ругань, как и громкость голоса, затихает.%SPEECH_ON%Все окраины города уничтожены. За что, по твоему, ты должен получить плату? Убирайся отсюда.%SPEECH_OFF% | Завидев вас, %employer% со стуком опускает на стол кубок вина. Из окна слышен гомон разъярённых крестьян.%SPEECH_ON%Слышишь? Они оторвут мне голову, если я заплачу тебе хоть крону, наёмник. У тебя была одна задача, одна! Защитить этот город. И ты этого не сделал. Теперь ты можешь сделать лишь одну правильную вещь, причём бесплатно: убраться отсюда!%SPEECH_OFF% | %employer% опирается руками о стол.%SPEECH_ON%Что именно ты ожидал получить? Я удивлён, что ты вообще вернулся ко мне. Половина города горит, а вторая половина уже превратилась в золу. Я нанял тебя для защиты, не для того, чтобы мой город равняли с землёй, наёмник. Убирайся отсюда.%SPEECH_OFF% | Когда вы возвращаетесь, %employer% держит в руках кружку эля. Его рука дрожит, а лицо раскраснелось.%SPEECH_ON%Мне стоит огромных усилий не швырнуть в тебя этим.%SPEECH_OFF%На всякий случай, он одним глотком выпивает содержимое и бьёт кружкой по столу.%SPEECH_ON%Этот город ожидал, что нанял защитников. Вместо этого крысы шныряют по окрестностями, как на прогулке! Ты даёшь мародёрам время и ждёшь, пока мой город не будет уничтожен? Убирайся отсюда!%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{Проклятые деревенщины! | Надо было просить предоплату... | Чёрт возьми!}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Не удалось защитить город от скавенов");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/rat_raided_situation"), 3, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Failure2",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_30.png[/img]{Когда вы входите в кабинет, %employer% просит закрыть за собой дверь. Со щелчком засова на вас обрушивается поток ругательств и непристойностей, которых вам не приходилось ещё слышать. Спустя некоторое время ругань, как и громкость голоса, затихает.%SPEECH_ON%Все окраины города уничтожены. За что, по твоему, ты должен получить плату? Убирайся отсюда.%SPEECH_OFF% | Завидев вас, %employer% со стуком опускает на стол кубок вина. Из окна слышен гомон разъярённых крестьян.%SPEECH_ON%Слышишь? Они оторвут мне голову, если я заплачу тебе хоть крону, наёмник. У тебя была одна задача, одна! Защитить этот город. И ты этого не сделал. Теперь ты можешь сделать лишь одну правильную вещь, причём бесплатно: убраться отсюда!%SPEECH_OFF% | %employer% опирается руками о стол.%SPEECH_ON%Что именно ты ожидал получить? Я удивлён, что ты вообще вернулся ко мне. Половина города горит, а вторая половина уже превратилась в золу. И больше того, выжившие поведали мне, что их родичей похитили! Я нанял тебя для защиты, не для того, чтобы мой город равняли с землёй, наёмник. Убирайся отсюда.%SPEECH_OFF% | Когда вы возвращаетесь, %employer% держит в руках кружку эля. Его рука дрожит, а лицо раскраснелось.%SPEECH_ON%Мне стоит огромных усилий не швырнуть в тебя этим.%SPEECH_OFF%На всякий случай, он одним глотком выпивает содержимое и бьёт кружкой по столу.%SPEECH_ON%Этот город ожидал, что нанял защитников. Вместо этого крысы шныряют по окрестностями, как на прогулке! Ты даёшь мародёрам время и ждёшь, пока мой город не будет уничтожен? Убирайся отсюда!%SPEECH_OFF% | %employer% смеётся, когда вы входите в его комнату.%SPEECH_ON%Окраины славного города %townname% разрушены, а его жители разъярены... по крайней мере те, кто ещё жив и способен искать виновных. А что ещё хуже, ты позволил этим чудовищам захватить наших родичей!%SPEECH_OFF%Он качает головой и указывает рукой на дверь.%SPEECH_ON%Я не знаю, чего ты ждал от меня, но платить я точно не намерен.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "{Проклятые деревенщины! | Надо было просить предоплату... | Чёрт возьми!}",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Не удалось защитить город от скавенов");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			],
			function start()
			{
				this.Contract.addSituation(this.new("scripts/entity/world/settlements/situations/rat_raided_situation"), 3, this.Contract.m.Home, this.List);
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"reward",
			this.m.Reward
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			local s = this.new("scripts/entity/world/settlements/situations/rat_raided_situation");
			s.setValidForDays(4);
			this.m.SituationID = this.m.Home.addSituation(s);
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			this.World.FactionManager.getFaction(this.getFaction()).setActive(true);
			this.m.Home.getSprite("selection").Visible = false;

			if (this.m.Kidnapper != null && !this.m.Kidnapper.isNull())
			{
				this.m.Kidnapper.getSprite("selection").Visible = false;
			}

			if (this.m.Militia != null && !this.m.Militia.isNull())
			{
				this.m.Militia.getController().clearOrders();
			}

			this.World.getGuestRoster().clear();
		}
	}

	function onIsValid()
	{
		local nearestRat = this.getNearestLocationTo(this.m.Home, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Rat).getSettlements());
//		local nearestRatBeast = this.getNearestLocationTo(this.m.Home, this.World.FactionManager.getFactionOfType(this.Const.FactionType.RatBeast).getSettlements());

//		if (nearestRatBeast.getTile().getDistanceTo(this.m.Home.getTile()) > 20 && nearestRat.getTile().getDistanceTo(this.m.Home.getTile()) > 20)
		if (nearestRat.getTile().getDistanceTo(this.m.Home.getTile()) > 20)
		{
			return false;
		}

		local locations = this.m.Home.getAttachedLocations();

		foreach( l in locations )
		{
			if (l.isUsable() && l.isActive() && !l.isMilitary())
			{
				return true;
			}
		}

		return false;
	}

	function onSerialize( _out )
	{
		this.m.Flags.set("KidnapperID", this.m.Kidnapper != null && !this.m.Kidnapper.isNull() ? this.m.Kidnapper.getID() : 0);
		this.m.Flags.set("MilitiaID", this.m.Militia != null && !this.m.Militia.isNull() ? this.m.Militia.getID() : 0);
		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.contract.onDeserialize(_in);
		this.m.Kidnapper = this.WeakTableRef(this.World.getEntityByID(this.m.Flags.get("KidnapperID")));
		this.m.Militia = this.WeakTableRef(this.World.getEntityByID(this.m.Flags.get("MilitiaID")));
	}

});

