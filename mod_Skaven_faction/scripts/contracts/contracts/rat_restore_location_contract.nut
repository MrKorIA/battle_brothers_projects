this.rat_restore_location_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Caravan = null,
		Location = null,
		IsEscortUpdated = false
	},
	function setLocation( _l )
	{
		this.m.Location = this.WeakTableRef(_l);
	}

	function create()
	{
		this.contract.create();
		this.m.DifficultyMult = this.Math.rand(70, 90) * 0.01;
		this.m.Type = "contract.rat_restore_location";
		this.m.Name = "Восстановительные работы";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 300 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

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
					"Обезопасить развалины местечка %location% возле города %townname%"
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

				if (r <= 15)
				{
					this.Flags.set("IsEmpty", true);
				}
				else if (r <= 30)
				{
					this.Flags.set("IsRefugees", true);
				}
				else if (r <= 60)
				{
					this.Flags.set("IsWolfRat", true);
				}
				else
				{
					this.Flags.set("IsRat", true);
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
				this.Contract.m.BulletpointsObjectives = [
					"Обезопасить развалины местечка %location% возле города %townname%"
				];
				this.Contract.m.Location.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Location))
				{
					if (this.Flags.get("IsVictory"))
					{
						this.Contract.setScreen("Victory");
						this.World.Contracts.showActiveContract();
						this.Contract.setState("ReturnForEscort");
					}
					else if (this.Flags.get("IsFleeing"))
					{
						this.Contract.setScreen("Failure2");
						this.World.Contracts.showActiveContract();
						return;
					}
					else if (this.Flags.get("IsEmpty"))
					{
						this.Contract.setScreen("Empty");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsRefugees"))
					{
						this.Contract.setScreen("Refugees1");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsWolfRat"))
					{
						this.Contract.setScreen("WolfRat");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsRat"))
					{
						this.Contract.setScreen("Rat");
						this.World.Contracts.showActiveContract();
					}
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "RestoreLocationContract")
				{
					this.Flags.set("IsVictory", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "RestoreLocationContract")
				{
					this.Flags.set("IsFleeing", true);
				}
			}

		});
		this.m.States.push({
			ID = "ReturnForEscort",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Вернуться в %townname%"
				];
				this.Contract.m.Location.getSprite("selection").Visible = false;
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
		this.m.States.push({
			ID = "Escort",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Сопроводить рабочих до %location% недалеко от %townname%"
				];
				this.Contract.m.Location.getSprite("selection").Visible = true;
				this.Contract.m.Home.getSprite("selection").Visible = false;
			}

			function update()
			{
				if (this.Contract.m.Caravan == null || this.Contract.m.Caravan.isNull() || !this.Contract.m.Caravan.isAlive() || this.Contract.m.Caravan.getTroops().len() == 0)
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
					return;
				}

				if (!this.Contract.m.IsEscortUpdated)
				{
					this.World.State.setEscortedEntity(this.Contract.m.Caravan);
					this.Contract.m.IsEscortUpdated = true;
				}

				this.World.State.setCampingAllowed(false);
				this.World.State.getPlayer().setPos(this.Contract.m.Caravan.getPos());
				this.World.State.getPlayer().setVisible(false);
				this.World.Assets.setUseProvisions(false);
				this.World.getCamera().moveTo(this.World.State.getPlayer());

				if (!this.World.State.isPaused())
				{
					this.World.setSpeedMult(this.Const.World.SpeedSettings.EscortMult);
				}

				this.World.State.m.LastWorldSpeedMult = this.Const.World.SpeedSettings.EscortMult;

				if (this.Flags.get("IsFleeing"))
				{
					this.Contract.setScreen("Failure1");
					this.World.Contracts.showActiveContract();
					return;
				}
				else if (this.Contract.isPlayerAt(this.Contract.m.Location))
				{
					this.Contract.setScreen("RebuildingLocation");
					this.World.Contracts.showActiveContract();
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				this.Flags.set("IsFleeing", true);

				if (this.Contract.m.Caravan != null && !this.Contract.m.Caravan.isNull())
				{
					this.Contract.m.Caravan.die();
					this.Contract.m.Caravan = null;
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
				this.Contract.clearSpawnedUnits();
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Вернуться в %townname%"
				];
				this.Contract.m.Location.getSprite("selection").Visible = false;
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success2");
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
			Text = "[img]gfx/ui/events/event_20.png[/img]{%employer% сидит за столом, заваленным чертежами и списками. Он поднимает на вас усталый взгляд и жестом приглашает подойти.%SPEECH_ON%Ты знаешь место %location% за околицей города %townname%? Раньше там была мельница и пара крепких домов. Теперь там только обгоревшие брёвна и чумной запах скавенов, от которого воротит.%SPEECH_OFF%Он проводит рукой по карте, стирая грязь.%SPEECH_ON%Я хочу, чтобы ты пошёл туда, вычистил всё, что там гнездится, и доложил мне. Если там всё ещё скавены — убей их. Если там кто-то ещё — разберись с ними. Мне нужно, чтобы это место стало безопасным для строителей.%SPEECH_OFF% | %employer% стоит у окна и смотрит на дым, поднимающийся со стороны места, которое называется %location%. Он не оборачивается, когда вы входите.%SPEECH_ON%Раньше я ездил туда по воскресеньям. Хорошее было место. Теперь там, по слухам, обосновались скавены. Или кто-то похуже.%SPEECH_OFF%Он поворачивается, и в его глазах — жёсткая решимость.%SPEECH_ON%Иди туда, наёмник. Выжги эту заразу. Если там пусто — возвращайся и скажи мне. Если там есть что-то живое — сделай так, чтобы оно перестало быть живым. Потом я отправлю туда людей. Ты понял?%SPEECH_OFF% | Вы входите, а %employer% сидит на полу, раскинув перед собой обрывки карт и старые письма.%SPEECH_ON%%location% — дело рук моего отца. Он был упрямым стариком — вбил себе в голову, что это место станет центром торговли. Он ошибся. Но я не хочу, чтобы оно сгнило окончательно.%SPEECH_OFF%Он поднимает на вас взгляд.%SPEECH_ON%Там сейчас кто-то живёт. Скавены, судя по следам, но я не уверен. Иди, проверь. Если они там — вышвырни их. Я заплачу.%SPEECH_OFF% | %employer% сжимает в руке старый ржавый ключ, вертит его, словно пытается вспомнить, от какой двери он был.%SPEECH_ON%Этот ключ от амбара в местечке %location%. Он лежал у меня в ящике десять лет. А теперь туда никто не может войти, потому что там поселились скавены.%SPEECH_OFF%Он бросает ключ вам, и вы ловите его на лету.%SPEECH_ON%Иди туда, наёмник. Если там кто-то есть — убей их. Если никого нет — верни мне ключ. А потом я пошлю людей, чтобы они всё отстроили заново.%SPEECH_OFF% | %employer% сидит за столом, перед ним стоит пустая кружка и недоеденный хлеб. Он выглядит уставшим, но голос его твёрд.%SPEECH_ON%Мои люди боятся подходить к месту %location%. Говорят, по ночам оттуда доносится скрежет и писк. Я не верю в призраков, наёмник. Я верю в крыс, которые слишком сильно расплодились.%SPEECH_OFF%Он пододвигает к вам карту с отмеченным маршрутом.%SPEECH_ON%Иди туда, проверь. Если там скавены — убей их. Если там кто-то ещё — разберись с ними. Если там никого нет — возвращайся и скажи мне. Я заплачу за любую из этих новостей, но заплачу по-разному.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Звучит достаточно просто | Поговорим о вознаграждении.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Мы не берёмся за такую работу. | Нам это не подходит.}",
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
			ID = "Empty",
			Title = "По мере приближения...",
			Text = "[img]gfx/ui/events/event_71.png[/img]{Вы проходите по местечку %location%, и каждый шаг отдаётся пустотой. Двери домов открыты, но внутри — только пыль, паутина и следы, которые вели сюда, но не вели обратно. Ваши люди обыскивают каждый угол, но находят только старые кости и обрывки ткани. Скавены ушли отсюда давно — возможно, недели или месяцы назад. Вы сжимаете челюсть. Ничего. Ни одной твари. Вы приказываете отряду собраться — пора возвращаться и сообщить, что место пустует. | Вы входите в главный дом в местечке %location% и останавливаетесь. Внутри — никого. На столе лежит кружка, в которой уже засохла какая-то жидкость. На полу — следы, но они старые, присыпанные пылью. Вы обходите все строения. Пусто. Только ветер гуляет между досок и завывает в щелях. Ваши люди переглядываются. Ни скавенов, ни людей, ни даже собак. Вы киваете самому себе — пора докладывать. | %location% встречает вас тишиной. Слишком тихо даже для разрушенного места. Вы заглядываете в амбар — там пусто, только сгнившая солома и старый хомут, висящий на гвозде. В доме мельника — перевёрнутый стол и разбитая миска, но ни одной крысы, ни одного следа, который нельзя было бы объяснить ветром. Вы выдыхаете. Здесь никого нет. Пора возвращаться. | Вы идёте по местечку %location% и чувствуете, как ветер шевелит волосы. Дома стоят пустые, окна зияют чернотой. Вы заглядываете в один из них — внутри только тени. Ни звука, ни движения. Ваши люди уже закончили обыск и ждут вашего решения. Вы качаете головой. Никого. Возвращаемся, %employer% будет рад этой новости.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Не то, что я ожидал.",
					function getResult()
					{
						this.Contract.setState("ReturnForEscort");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Rat",
			Title = "По мере приближения...",
			Text = "[img]gfx/ui/events/event_71.png[/img]{Вы подходите к местечку %location%, и запах ударяет в нос — кислый, влажный, с примесью гнили. Ваши люди уже достали оружие, не дожидаясь приказа. Вы обходите угол дома и видите их — несколько скавенов сидят вокруг и что-то увлечённо обсуждают. Один из них поднимает голову и, заметив вас, что-то роняет из своей лапы. Визг, звон металла, и они уже бегут на вас с ржавыми клинками. Времени на подготовку к бою нет. | %location% кажется пустым, но вы слышите звуки. Скрежет, шорох, писк. Вы поднимаете руку, и отряд замирает. Из разбитого окна выглядывает морда — узкая, с длинными усами и красными глазами. Она исчезает, и через мгновение из всех щелей начинают вылезать серые тела. Скавены. Они не ждали гостей, но готовы защищать своё логово. Вы достаёте меч. | Вы подходите к старой мельнице и видите, что дверь распахнута настежь. Внутри — движение. Тени мелькают между балок. Вы даёте знак, и ваши люди окружают здание. Изнутри доносится резкий, писклявый говор — скавены делят добычу. Вы бросаете камень в дверной проём, и внутри всё затихает. А потом они вылетают наружу — злые, голодные и вооружённые до зубов. Бой неизбежен.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "К оружию!",
					function getResult()
					{
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.Music = this.Const.Music.RatTracks;
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "RestoreLocationContract";
						p.TerrainTemplate = "tactical.plains";
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						p.LocationTemplate.Template[0] = "tactical.rat_camp";
						p.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.None;
						p.LocationTemplate.CutDownTrees = true;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.RatRoamers, 90 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Rat).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "WolfRat",
			Title = "По мере приближения...",
			Text = "[img]gfx/ui/events/rat_event_05.png[/img]{Вы приближаетесь к местечку %location%, и воздух вокруг становится тягучим, словно его напитали чем-то липким и холодным. На стенах домов — белый, паутинный налёт, который колышется от ветра. Вы касаетесь его кончиком меча — он тянется, как слизь. Внезапно из тени вылетает тварь — длинная, тощая, с пастью, полной игольчатых зубов. Волкокрыс. За ним — второй, третий. Они не пищат, они шипят, и их глаза горят красным в полумраке. Вы отдаёте приказ, и отряд встаёт в строй. | Вы идёте по дороге к развалинам %location%, и вдруг замечаете, что земля под ногами покрыта странными следами — длинными, с когтями, которые уходят в разрыхлённую почву. Вы подаёте знак остановиться. Из темноты домов доносится писк — низкий, вибрирующий, от которого по спине бегут мурашки. И тут они появляются — волкокрысы, целая стая, выходят из теней и окружают вас, щёлкая челюстями. Они не боятся. Они голодны.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "К оружию!",
					function getResult()
					{
						local tile = this.World.State.getPlayer().getTile();
						local p = this.Const.Tactical.CombatInfo.getClone();
						p.Music = this.Const.Music.RatTracks;
						p.TerrainTemplate = this.Const.World.TerrainTacticalTemplate[tile.TacticalType];
						p.Tile = tile;
						p.CombatID = "RestoreLocationContract";
						p.TerrainTemplate = "tactical.plains";
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.WolfRat, 90 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.RatBeast).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Refugees1",
			Title = "По мере приближения...",
			Text = "[img]gfx/ui/events/event_59.png[/img]{Вы подходите к местечку %location% и видите, что здесь уже кто-то обосновался. Но не скавены. Люди. Десятки людей, грязных, худых, оборванных — они сидят вокруг костров, спят под открытым небом, укрывая детей своими телами. Один из них, старик с пустыми глазами, поднимает голову, когда вы подходите.%SPEECH_ON%С нас нечего взять, наёмник. Мы просто ждём, пока нас не сожрут или не прогонят. Если ты пришёл прогонять, прогоняй. Мы привыкли.%SPEECH_OFF%То, что обещал %employer%, не перевешивает жалости к беженцам, но выгнать их — значит отправить на верную смерть. | Вы заходите в местечко %location% и видите, что здесь полно людей. Они смотрят на вас с надеждой и страхом. Женщины прижимают к себе детей, мужчины сжимают кулаки, но никто не угрожает — они слишком слабы для этого. Один из них делает шаг вперёд.%SPEECH_ON%Мы не знали, что это место кому-то нужно. Мы просто прячемся. Если хочешь, мы уйдём. Только скажи, куда.%SPEECH_OFF%Вы молчите. В вашей голове борются жажда крон и жалость к этим людям. | Вы останавливаетесь на холме и смотрите вниз, на местечко %location%. Там, среди развалин, живут люди. Они поставили шатры из тряпок, развели костры, пытаются жить. Вы видите детей, которые играют в пыли, и стариков, которые сидят у огня и смотрят в одну точку. Ваш отряд ждёт приказа. %randombrother% подходит и тихо говорит:%SPEECH_ON%Командир, если мы их выгоним, мы их убьём. Они не переживут ещё один переход.%SPEECH_OFF%Вы знаете, что он прав.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Выгоним этих оборванцев.",
					function getResult()
					{
						return "Refugees2";
					}

				},
				{
					Text = "Этим людям некуда идти. Просто... оставим их в покое.",
					function getResult()
					{
						return "Refugees3";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Refugees2",
			Title = "По мере приближения...",
			Text = "[img]gfx/ui/events/event_59.png[/img]{Вы делаете шаг вперёд и поднимаете руку.%SPEECH_ON%Слушайте сюда. Это место принадлежит городу %townname%. У вас есть час, чтобы собрать свои вещи и уйти.%SPEECH_OFF%Тишина. Потом старик поднимается — медленно, с трудом.%SPEECH_ON%Мы уйдём. Но ты знаешь, что мы умрём, да?%SPEECH_OFF%Вы не отвечаете. Люди начинают собирать свои пожитки, молча, без слёз. Они уже выплакали всё, что могли. Вы отворачиваетесь и даёте знак своим людям ждать. | Вы приказываете отряду выстроиться в линию и идти вперёд, тесня беженцев. Они отступают, как стадо напуганных овец, не сопротивляясь, не крича. Одна женщина роняет узел с вещами, и её ребёнок начинает плакать. Вы сжимаете зубы. Вы делаете свою работу. Это просто работа. Когда %location% пустеет, вы выдыхаете и приказываете отряду отдыхать. | Вы подходите к ним и говорите коротко и жёстко:%SPEECH_ON%Вам нужно уйти. Сейчас.%SPEECH_OFF%Они смотрят на вас, и вы видите в их глазах не гнев, а обречённость. Они не спорят. Они просто встают и начинают брести прочь, как живые тени. Один из них, мальчик лет двенадцати, задерживается на мгновение и смотрит на вас.%SPEECH_ON%Ты тоже умрёшь, наёмник. Все мы умрём.%SPEECH_OFF%Он уходит, и вы прогоняете его слова из головы.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Пошли прочь, сброд!",
					function getResult()
					{
						this.World.Assets.addMoralReputation(-2);
						this.Contract.setState("ReturnForEscort");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Refugees3",
			Title = "По мере приближения...",
			Text = "[img]gfx/ui/events/event_59.png[/img]{Вы оставляете беженцев в облюбованном ими местечке. %employer% явно не похвалит вас за это, можете даже не возвращаться. | Мужчины, женщины и дети выглядят как уставшие от тягот жизни люди, вручившие свои судьбы в руки богов. Вы решаете оставить их в покое. | Этим людям уже изрядно досталось. Вы уверены, что они не переживут ещё одно путешествие в дикие земли, а потому решаете оставить их там, где они поселились. | Натерпевшиеся и измождённые люди не заслуживают того, чтобы их прогнали ещё и отсюда. Вы решаете оставить их в покое. Благодаря им это место наверняка вновь обретёт былую славу и расцветёт по-новому. Хотя %employer% будет явно недоволен тем, что его собственные люди к этому процветанию не будут иметь никакого отношения. | %employer% хочет, чтобы здесь поселились его собственные люди, но, во-первых, беженцы добрались до этого места первыми. А во-вторых, они вряд ли переживут ещё одно изгнание в дикие земли.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Мы найдём работу в другом месте...",
					function getResult()
					{
						this.World.Assets.addMoralReputation(2);
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Не удалось зачистить развалины местечка " + this.Contract.m.Location.getRealName());
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Victory",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_71.png[/img]{Последний скавен падает, пронзённый клинком вашего бойца. Вы осматриваете местечко %location% — дым, трупы, но больше ни одной живой твари. Вы приказываете обыскать дома — чисто. Вы выдыхаете. Место свободно. Пора возвращаться, %employer% будет рад. | Битва закончена. Ваши люди перевязывают раны и собирают трофеи, пока вы проходите по местечку %location%, проверяя каждый угол. Везде — только мёртвые скавены. Вы киваете. Работа сделана. Возвращаемся. | Вы смотрите на поле боя и чувствуете усталость, но в то же время и удовлетворение. %location% снова принадлежит людям. Вы приказываете отряду собираться и берёте курс на поселение %townname%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Тут, похоже, разобрались.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "RebuildingLocation",
			Title = "По мере приближения...",
			Text = "[img]gfx/ui/events/event_71.png[/img]{Вы возвращаетесь в местечко %location% и смотрите, как рабочие расходятся по зданиям. Они приступают к работе, выгружают доски, ставят опорные балки, а несколько мужиков начинают рыть колодец. Похоже, теперь вы со спокойной душой можете возвращаться, %employer% получил, что хотел. | Строители благодарят вас за то, что вы доставили их в местечко %location% в целости и сохранности. Затем все расходятся по посёлку, приступая к работе. Каждый берётся за своё дело: стук молотков и скрип пил эхом раздаются позади вас, когда вы уходите. %employer% будет рад, что всё вышло как он хотел. | Большинство строителей направляются в местечко %location% и начинают подготовку к его восстановлению. Артельщик благодарит вас за то, что доставили их целыми, — он знает, какие опасности таит в себе этот мир. К тому же он признателен, что вы не предали нанимателя и не свели их всех в могилу раньше времени. Вы принимаете эту благодарность с ухмылкой, %employer% должным образом оценит вашу верность. Пора выдвигаться в обратный путь. | Ну что ж, рабочие прибыли в целости и сохранности. Вы поворачиваете назад, возвращаясь к нанимателю, чтобы получить деньги, которые вы честно заработали. | Это было долгое путешествие, туда и обратно, и снова туда, но, похоже, благодаря вам местечко %location% теперь снова встанет на ноги. Убедившись, что работники в безопасности, вы отправляетесь в обратный путь. %employer% должен вам немало золота за все эти мотания.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Время получить оплату.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_98.png[/img]{Вы входите в комнату, и %employer% внимательно смотрит на вас.%SPEECH_ON%Говори.%SPEECH_OFF%Вы коротко докладываете: место чисто, скавенов нет, можно отправлять людей. %employer% кивает и достаёт из ящика свиток.%SPEECH_ON%Хорошо. Тогда вот что: я собрал караван строителей. Они ждут у южных ворот. Ты проводишь их до местечка %location% и убедишься, что они дошли целыми. Потом возвращаешься и получаешь остаток платы.%SPEECH_OFF%Вы киваете и выходите. | %employer% слушает ваш доклад, не перебивая. Когда вы заканчиваете, он выдыхает.%SPEECH_ON%Хорошо. Я распорядился, чтобы строителей собрали в караван. Ты отведёшь их к местечку %location%. Это не займёт много времени, но я хочу, чтобы их довезли в целости. Потом — возвращайся, я заплачу.%SPEECH_OFF%Вы забираете карту с маршрутом и выходите. | %employer% одобрительно кивает, когда вы говорите ему, что место чисто.%SPEECH_ON%Отлично. Значит, пришло время для второго этапа. У меня есть караван с деревом, камнями и рабочими. Ты их сопроводишь до местечка %location% и убедишься, что они приступили к работе. После этого — возвращайся за платой.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Это не займёт много времени.",
					function getResult()
					{
						this.Contract.spawnCaravan();
						this.Contract.setState("Escort");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_63.png[/img]{%employer% приветствует вас по возвращении, протягивая кошель, туго набитый кронами. А затем выпроваживает вас, даже не поблагодарив за работу. Да плевать на него и на все эти церемонии. Тяжёлый кошель важнее любых славословий. | %employer% взмахом руки приглашает вас в свой дом. Один из его людей вручает кошель, туго набитый кронами. Вы переводите взгляд на нанимателя.%SPEECH_ON%Как ты узнал, что работники добрались до места?%SPEECH_OFF%%employer% застенчиво улыбается.%SPEECH_ON%У меня много глаз и ушей в этих краях. Даже птицы разговаривают со мной...%SPEECH_OFF%Неплохо сказано. | Вернувшись к нанимателю, вы рассказываете, что в местечке %location% уже полным ходом идут восстановительные работы. %employer% благодарит вас.%SPEECH_ON%Вы только посмотрите на это? Наёмник, который держит своё слово и выполняет свою работу. Редкость в наши дни. Держи свою награду.%SPEECH_OFF%Один из его людей протягивает вам тяжёлый, наполненный кронами, мешок. %employer% пожимает вам руку.%SPEECH_ON%Увидимся, наёмник.%SPEECH_OFF% | %employer% находится в своём кабинете, когда вы возвращаетесь. Он показывает вам свиток и спрашивает, знаете ли вы, что это такое. Вы пожимаете плечами.%SPEECH_ON%Я не учёный. Не человек писанного слова, во всяком случае.%SPEECH_OFF%%employer% в ответ тоже пожимает плечами.%SPEECH_ON%Какая жалость. Но всё же ты — человек слова. Ты ведь исполнил своё обещание, а это редкость в наши дни, уж поверь. Твоя плата вон в том углу.%SPEECH_OFF%Награда стоит там, где он и сказал. Вы, не церемонясь, берёте её и уходите. | %employer% расслабленно откидывается в кресле, самодовольно ухмыляясь.%SPEECH_ON%Я знаю, как их выбирать. Наёмников, то есть. Большинство моих соотечественников нанимают людей, промышляющих тем же, что и ты, но всё идёт наперекосяк, потому что они не знают, как отличить хорошего человека от трепла. Но ты... Я знал, что ты сдержишь слово, как только увидел тебя. Твоя награда, наёмник...%SPEECH_OFF%Он бросает на стол кошель золота.%SPEECH_ON%Здесь всё, но я пойму, если ты захочешь пересчитать.%SPEECH_OFF%Вы пересчитываете — всё на месте.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Лёгкие деньги.",
					function getResult()
					{
						this.Contract.m.Location.setActive(true);
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Помог восстановить " + this.Contract.m.Location.getRealName());
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
			}

		});
		this.m.Screens.push({
			ID = "Failure1",
			Title = "После битвы",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Караван с материалами разграблен, а всякая надежда на то, что местечко %location% однажды восстановится, потеряна. По крайней мере, на некоторое время.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Проклятье!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Не удалось защитить караван рабочих");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Failure2",
			Title = "После битвы",
			Text = "[img]gfx/ui/events/event_71.png[/img]{Вашему отряду не удалось обезопасить местечко %location%, так что на плату рассчитывать не стоит.}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "Проклятье!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractFail, "Не удалось обезопасить " + this.Contract.m.Location.getName());
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
	}

	function spawnCaravan()
	{
		local faction = this.World.FactionManager.getFaction(this.getFaction());
		local party = faction.spawnEntity(this.m.Home.getTile(), "Караван с рабочими", false, this.Const.World.Spawn.CaravanEscort, this.m.Home.getResources() * 0.4);
		party.getSprite("banner").Visible = false;
		party.getSprite("base").Visible = false;
		party.setMirrored(true);
		party.setDescription("Караван рабочих и строительных материалов из поселения " + this.m.Home.getName() + ".");
		party.setFootprintType(this.Const.World.FootprintsType.Caravan);
		party.setMovementSpeed(this.Const.World.MovementSettings.Speed * 0.5);
		party.setLeaveFootprints(false);
		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		local move = this.new("scripts/ai/world/orders/move_order");
		move.setDestination(this.m.Location.getTile());
		move.setRoadsOnly(false);
		local despawn = this.new("scripts/ai/world/orders/despawn_order");
		c.addOrder(move);
		c.addOrder(despawn);
		this.m.Caravan = this.WeakTableRef(party);
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"location",
			this.m.Location.getRealName()
		]);
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

			if (this.m.Location != null && !this.m.Location.isNull())
			{
				this.m.Location.getSprite("selection").Visible = false;
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (this.m.Location == null || this.m.Location.isActive() || !this.m.Location.isUsable())
		{
			return false;
		}

		return true;
	}

	function onSerialize( _out )
	{
		if (this.m.Caravan != null && !this.m.Caravan.isNull())
		{
			_out.writeU32(this.m.Caravan.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		if (this.m.Location != null && !this.m.Location.isNull())
		{
			_out.writeU32(this.m.Location.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local caravan = _in.readU32();

		if (caravan != 0)
		{
			this.m.Caravan = this.WeakTableRef(this.World.getEntityByID(caravan));
		}

		local location = _in.readU32();

		if (location != 0)
		{
			this.m.Location = this.WeakTableRef(this.World.getEntityByID(location));
		}

		this.contract.onDeserialize(_in);
	}

});

