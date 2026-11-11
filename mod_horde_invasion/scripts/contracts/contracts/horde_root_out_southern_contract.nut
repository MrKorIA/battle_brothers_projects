this.horde_root_out_southern_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Objective1 = null,
		Objective2 = null,
		Target = null,
		Current = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		local r = this.Math.rand(1, 100);

		if (r <= 70)
		{
			this.m.DifficultyMult = this.Math.rand(95, 105) * 0.01;
		}
		else
		{
			this.m.DifficultyMult = this.Math.rand(115, 135) * 0.01;
		}

		this.m.Type = "contract.horde_root_out_southern";
		this.m.Name = "Искоренить орду";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		if (this.m.Origin == null)
		{
			this.setOrigin(this.World.State.getCurrentTown());
		}

		// Две цели — два ближайших лагеря орды БЕЗ деления по фракциям
		local camps = [];
		foreach (s in this.World.FactionManager.getFactionOfType(this.Const.FactionType.Jurchen).getSettlements())
		{
			if (!s.isLocationType(this.Const.World.LocationType.Unique))
			{
				camps.push(s);
			}
		}
		foreach (s in this.World.FactionManager.getFactionOfType(this.Const.FactionType.Mgl).getSettlements())
		{
			if (!s.isLocationType(this.Const.World.LocationType.Unique))
			{
				camps.push(s);
			}
		}
		local originTile = this.m.Origin.getTile();
		camps.sort(function ( _a, _b )
		{
			if (_a.getTile().getDistanceTo(originTile) > _b.getTile().getDistanceTo(originTile))
			{
				return 1;
			}
			else if (_a.getTile().getDistanceTo(originTile) < _b.getTile().getDistanceTo(originTile))
			{
				return -1;
			}
			return 0;
		});

		if (camps.len() >= 2)
		{
			this.m.Objective1 = this.WeakTableRef(camps[0]);
			this.m.Objective2 = this.WeakTableRef(camps[1]);
		}
		else
		{
			// Запасной вариант при <2 лагерей на карте: ближайший каждой фракции
			local nearest_jin = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Jurchen).getNearestSettlement(this.m.Origin.getTile());
			local nearest_mgl = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Mgl).getNearestSettlement(this.m.Origin.getTile());
			this.m.Objective1 = this.WeakTableRef(nearest_jin);
			this.m.Objective2 = this.WeakTableRef(nearest_mgl);
		}

		this.m.Flags.set("Objective1Name", this.m.Objective1.getName());
		this.m.Flags.set("Objective2Name", this.m.Objective2.getName());
		this.m.Payment.Pool = 1500 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
		local r = this.Math.rand(1, 2);

		if (r == 1)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else if (r == 2)
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
					"Уничтожить %objective1%",
					"Уничтожить %objective2%",
					"Вернуться в город %townname%"
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
				this.Contract.m.Objective1.setLootScaleBasedOnResources(120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Objective1.setResources(120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Objective1.clearTroops();
				this.Contract.addUnitsToEntity(this.Contract.m.Objective1, this.Contract.m.Objective1.getDefenderSpawnList(), 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Objective1.setDiscovered(true);

				if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Objective1.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Objective1.getLoot().clear();
				}

				this.World.uncoverFogOfWar(this.Contract.m.Objective1.getTile().Pos, 500.0);
				this.Contract.m.Objective2.setLootScaleBasedOnResources(120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Objective2.setResources(120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Objective2.clearTroops();
				this.Contract.addUnitsToEntity(this.Contract.m.Objective2, this.Contract.m.Objective2.getDefenderSpawnList(), 120 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
				this.Contract.m.Objective2.setDiscovered(true);

				if (this.Contract.getDifficultyMult() <= 1.15 && !this.Contract.m.Objective2.getFlags().get("IsEventLocation"))
				{
					this.Contract.m.Objective2.getLoot().clear();
				}

				this.World.uncoverFogOfWar(this.Contract.m.Objective2.getTile().Pos, 500.0);
				local r = this.Math.rand(1, 100);

				if (r <= 10)
				{
					this.Flags.set("IsFugitives", true);
				}
				else if (r <= 25)
				{
					this.Flags.set("IsMercs", true);
				}

				this.Flags.set("ObjectivesDestroyed", 0);
				this.Flags.set("Objective1ID", this.Contract.m.Objective1.getID());
				this.Flags.set("Objective2ID", this.Contract.m.Objective2.getID());
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [];

				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull() && this.Contract.m.Target.isAlive())
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
					this.Contract.m.BulletpointsObjectives.push("Перехватить беглецов орды");
				}

				if (this.Contract.m.Objective1 != null && !this.Contract.m.Objective1.isNull() && this.Contract.m.Objective1.isAlive())
				{
					this.Contract.m.Objective1.getSprite("selection").Visible = true;
					this.Contract.m.BulletpointsObjectives.push("Уничтожить %objective1%");
					this.Contract.m.Objective1.setOnCombatWithPlayerCallback(this.onCombatWithPlayer.bindenv(this));
				}

				if (this.Contract.m.Objective2 != null && !this.Contract.m.Objective2.isNull() && this.Contract.m.Objective2.isAlive())
				{
					this.Contract.m.Objective2.getSprite("selection").Visible = true;
					this.Contract.m.BulletpointsObjectives.push("Уничтожить %objective2%");
					this.Contract.m.Objective2.setOnCombatWithPlayerCallback(this.onCombatWithPlayer.bindenv(this));
				}
			}

			function update()
			{
				if (this.Flags.get("ObjectiveDestroyed"))
				{
					this.Flags.set("ObjectiveDestroyed", false);

					if (this.Flags.get("IsMercsCoop"))
					{
						this.Contract.setScreen("MercsAftermathCoop");
					}
					else if (this.Flags.get("IsMercs3Way"))
					{
						this.Contract.setScreen("MercsAftermath3Way");
					}
					else if (this.Flags.get("ObjectivesDestroyed") == 1)
					{
						this.Contract.setScreen("Aftermath1");
					}
					else
					{
						this.Contract.setScreen("Aftermath2");
					}

					this.World.Contracts.showActiveContract();
				}

				if (this.Flags.get("IsFugitivesSpawned"))
				{
					if (this.Contract.m.Target == null || this.Contract.m.Target.isNull())
					{
						this.Contract.setScreen("FugitivesAftermath");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Contract.m.Target.getTile().getDistanceTo(this.World.State.getPlayer().getTile()) >= 9)
					{
						this.Contract.setScreen("FugitivesFail");
						this.World.Contracts.showActiveContract();
					}
				}

				if (!this.Flags.get("IsMercs") || this.Flags.get("ObjectivesDestroyed") != 0)
				{
					if (this.Contract.m.Objective1 != null && !this.Contract.m.Objective1.isNull() && !this.Contract.m.Objective1.getFlags().has("TriggeredContractDialog") && this.Contract.isPlayerNear(this.Contract.m.Objective1, 450))
					{
						this.Contract.m.Objective1.getFlags().add("TriggeredContractDialog");
						this.Contract.setScreen("HordeCampAhead");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Contract.m.Objective2 != null && !this.Contract.m.Objective2.isNull() && !this.Contract.m.Objective2.getFlags().has("TriggeredContractDialog") && this.Contract.isPlayerNear(this.Contract.m.Objective2, 450))
					{
						this.Contract.m.Objective2.getFlags().add("TriggeredContractDialog");

						if (this.Flags.get("IsFugitives"))
						{
							this.Flags.set("IsFugitivesSpawned", true);
							this.Contract.setScreen("Fugitives");
							this.World.Contracts.showActiveContract();
						}
						else
						{
							this.Contract.setScreen("HordeCampAhead");
							this.World.Contracts.showActiveContract();
						}
					}
				}
			}

			function onCombatWithPlayer( _dest, _isPlayerAttacking = true )
			{
				this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
				this.Contract.m.Current = _dest;

				if (_dest != null && !_dest.getFlags().has("TriggeredContractDialog") && this.Flags.get("IsMercs") && this.Flags.get("ObjectivesDestroyed") == 0)
				{
					_dest.getFlags().add("TriggeredContractDialog");
					this.Contract.setScreen("Mercs");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					_dest.m.IsShowingDefenders = true;
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.EnemyBanners.push(_dest.getBanner());

					if (this.Flags.get("IsMercs") && this.Flags.get("ObjectivesDestroyed") == 0)
					{
						if (this.Flags.get("IsMercsCoop"))
						{
							p.AllyBanners.push("banner_noble_05");
							this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Mercenaries, 90 * this.Contract.getScaledDifficultyMult(), this.Const.Faction.PlayerAnimals);
						}
						else
						{
							p.EnemyBanners.push("banner_noble_05");
							this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Mercenaries, 90 * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
						}
					}

					this.World.Contracts.startScriptedCombat(p, this.Contract.m.IsPlayerAttacking, true, true);
				}
			}

			function onLocationDestroyed( _location )
			{
				if (_location.getID() == this.Flags.get("Objective1ID"))
				{
					this.Contract.m.Objective1 = null;
					this.Flags.set("ObjectiveDestroyed", true);
					this.Flags.set("ObjectivesDestroyed", this.Flags.get("ObjectivesDestroyed") + 1);
				}
				else if (_location.getID() == this.Flags.get("Objective2ID"))
				{
					this.Contract.m.Objective2 = null;
					this.Flags.set("ObjectiveDestroyed", true);
					this.Flags.set("ObjectivesDestroyed", this.Flags.get("ObjectivesDestroyed") + 1);
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer% принимает вас в прохладном зале дворца, под сводами, расписанными под цвет рассвета. За окном плещут фонтаны, и этот покой обманчив.%SPEECH_ON%Ты видел дым на севере, наёмник? Видел. Весь свет видит. Благородные дома севера кровоточат — орда жжёт их города одна за другим. Нам, хвала небесам, пока только смотрит в спину... но смотрит.%SPEECH_OFF%Визирь разворачивает карту; две чернильные точки лежат к северу от южных владений.%SPEECH_ON%Мои разведчики нашли два лагеря орды: \'%objective1%\' и \'%objective2%\'. Слишком близко к нашим торговым путям. Сожги их.%SPEECH_OFF%Он поднимает ладонь, предупреждая вопрос.%SPEECH_ON%Наши знамёна там не появятся. Мы не желаем войны с Ордой — пусть северне держат свой фронт. Но и соседства такого мы не терпим. Потому и обратились к людям без гербов.%SPEECH_OFF% | %employer% встречает вас у решётчатого окна с видом на гавань. В порту стоят караваны, груженные под завязку, а наниматель смотрит на них, как на мишени.%SPEECH_ON%Торговля — кровь наших городов, наёмник. А пока север горит, эта кровь стынет: караваны не выходят, страховка растёт, деньги тают. Мои люди насчитали два стойбища орды близ наших дорог: \'%objective1%\' и \'%objective2%\'.%SPEECH_OFF%Он поворачивается к вам, и в глазах читается холодный расчёт.%SPEECH_ON%Наши воины туда не пойдут — не хочу, чтобы Орда увидела в нас врага. Северне пусть благодарят судьбу, что горят не они одни. А ты — ты просто наёмник. Сожги оба лагеря, и гавань вспомнит тебя добрым словом. И я заплачу.%SPEECH_OFF% | %employer% раскладывает на мозаичном столе три свитка: донесение разведчика, счёт от гильдии купцов и карту.%SPEECH_ON%Читай вслух, если хочешь: северне тонут. Орда давит их стеной, и ни одна армия не остановила её. Мы, разумеется, соболезнуем. Мы даже молимся за них — где-то между первым и вторым завтраком.%SPEECH_OFF%Он стучит пальцем по карте, где двумя крестиками отмечены \'%objective1%\' и \'%objective2%\'.%SPEECH_ON%Но молитвы — это северный стиль. У нас практичнее: два лагеря орды стоят слишком близко к нашим землям, и это дурной сон каждого патриция. Сожги их оба. Наших людей рядом не будет — мы не ищем войны, мы покупаем тишину.%SPEECH_OFF% | %employer% принимает вас не в тронном зале, а в тени арки, где никто не услышит.%SPEECH_ON%Скажу прямо, наёмник, — между нами, чужаками. Орда растекается по северу, и все ждут, когда она повернёт на юг. Мы не хотим быть причиной этого поворота. Ни одно наше знамя не должно блеснуть на её границе — понимаешь, о чём я?%SPEECH_OFF%Не дожидаясь ответа, он выкладывает карту с двумя отметками: \'%objective1%\' и \'%objective2%\'.%SPEECH_ON%Два их лагеря у самого нашего порога. Сожги их тихо, без имени, и юг будет должен тебе молчанием.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Какова оплата? | Что мне интересно — так это размер платы.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Оно того не стоит. | Мы нужны в другом месте.}",
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
			ID = "HordeCampAhead",
			Title = "По мере приближения...",
			Text = "[img]gfx/ui/events/event_57.png[/img]{Ветер меняется, и теперь он доносит до отряда запахи дыма, пороха и жженого мяса. %randombrother% прикладывает ладонь ко лбу и кивает вдаль.%SPEECH_ON%Лагерь. Неподалёку.%SPEECH_OFF% | По мере приближения к цели вы всё убеждаетесь, что %employer% не преувеличивал. Подъёмный столб дыма, вытоптанная земля, сушёные туши на жердях — это не временный бивуак, это гнездо, откуда орда сосёт кровь окрестных земель. | Вы находите следы большого отряда: обозные сани, глубокие борозды подкованных сапог, вязкая колея. %randombrother%, присев, кортает грязь пальцем.%SPEECH_ON%Свежие. Прошли не больше пары часов назад. Куда они, туда и лагерь.%SPEECH_OFF% | На придорожном столбе вы находите украшение, которое местные ставят не по доброй воле: три головы, насаженные на колья. Две — мужские, одна — старая женская. Судя по следам, орда прошла этим путём совсем недавно. Лагерь близко. | %randombrother% поднимает с земли обрывок шёлковой ткани, какие носят степняки, и зажимает нос.%SPEECH_ON%Порох, пот и болото. Лагерь орды близко, командир.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Приготовьтесь к худшему!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Aftermath1",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_46.png[/img]{Лагерь горит. Вы стоите в облаке искр и дыма, пока люди обыскивают то, что уцелело. Орда, жившая здесь, больше никому не угрожает. Остаётся лишь %objective2%. | Последний защитник лагеря упал, и с ним упала и его ставка. Вы смахиваете сажу с плаща и смотрите на тлеющие шатры. С этим местом покончено. %objective2% ждёт. | Вы покончили со станом орды — сожгли шатры, разнесли складские сараи, разогнали то немногое, что осталось от гарнизона. Пепел летит в лицо. %randombrother% сплёвывает.%SPEECH_ON%Остаётся %objective2%, верно?%SPEECH_OFF%Вы киваете. | С этим лагерём покончено. Вы приказываете людям собираться: %objective2% ждёт своей очереди.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{Победа! | Пусть горит.}",
					function getResult()
					{
						this.Contract.getActiveState().start();
						this.World.Contracts.updateActiveContract();
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Aftermath2",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_46.png[/img]{%objective2% ныне представляет собой лишь дымящиеся развалины. Пора возвращаться за платой — %employer% ждёт вашего отчёта. | %objective2%. Вы сожгли его дотла, и теперь земля, на которой стоял лагерь, снова принадлежит мёртвым, а не орде. %employer% будет впечатлён — осталось вернуться и получить свою плату. | %objective2%. Последний шатр рухнул в огонь. От ордынского гнезда осталась лишь сажа на траве. Вам же осталось вернуться к нанимателю: %employer% любит хорошие новости и платить за них, как оказалось, тоже любит. | Отряд \'%companyname%\' победно стоит посреди пепелища, некогда бывшего \'%objective2%\'. %randombrother%, размахивающий трофейным степным луком, особенно доволен. Пожалуй, пора возвращаться за платой — наниматель уже заждался.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "{Победа! | Пора возвращаться в %townname%.}",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Fugitives",
			Title = "По мере приближения...",
			Text = "[img]gfx/ui/events/event_76.png[/img]{Вдалеке вы заметили небольшой отряд, поспешно уходящий от лагеря. По степным лукам и кольчугам это явно не крестьяне. Без сомнения, из лагеря бегут вожаки орды — нельзя дать им уйти! | %randombrother% подходит к вам, ручейки пота стекают по его лицу.%SPEECH_ON%Командир, похоже, от лагеря уходит отряд. Щиты с гербами, тяжёлые луки — и с ними кто-то важный.%SPEECH_OFF%Поднеся к глазу подзорную трубу, вы видите охрану, теснящую впереди себя пару людей в дорогих доспехах. Это сотники орды, и они уходят со всех ног.%SPEECH_ON%Зоркий глаз. Собери людей — этих беглецов надо перехватить, пока они не разнесли весть о нас по всей степи.%SPEECH_OFF% | Вы берёте подзорную трубу и осматриваете окрестности. Неожиданно вы замечаете цепочку людей, непрерывно оглядывающихся назад. Вожаки орды — судя по сбруе, важные птицы. Если они уйдут, вскоре на месте сожжённого лагеря вырастет новый. За ними! | %randombrother% докладывает, что от лагеря уходит отряд, а сопровождают его телохранители. Вы же хмуритесь: такие вожаки знают о местных тропах больше любого разведчика. Отряд должен догнать их, прежде чем они смешаются со степью.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "За ними!",
					function getResult()
					{
						local tile = this.Contract.m.Objective2.getTile();
						local banner = this.Contract.m.Objective2.getBanner();
						this.Contract.m.Objective2.die();
						this.Contract.m.Objective2 = null;
						local playerTile = this.World.State.getPlayer().getTile();
						local camp = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Jurchen).getNearestSettlement(playerTile);
						local party = this.World.FactionManager.getFaction(camp.getFaction()).spawnEntity(tile, "Беглецы орды", false, this.Const.World.Spawn.JurchenRaiders, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
						party.getSprite("banner").setBrush(banner);
						party.setFootprintType(this.Const.World.FootprintsType.Nomads);
						party.getSprite("body").setBrush("figure_tiefutu_02");
						party.setSlowerAtNight(false);
						party.setUsingGlobalVision(false);
						party.setLooting(false);
						this.Const.World.Common.addTroop(party, {
							Type = this.Const.World.Spawn.Troops.Kehanweishi
						}, false);
						this.Const.World.Common.addTroop(party, {
							Type = this.Const.World.Spawn.Troops.Kehanweishi
						}, true);
						this.Contract.m.UnitsSpawned.push(party);
						this.Contract.m.Target = this.WeakTableRef(party);
						party.setAttackableByAI(true);
						party.setFootprintSizeOverride(0.75);
						local c = party.getController();
						c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
						local roam = this.new("scripts/ai/world/orders/roam_order");
						roam.setPivot(camp);
						roam.setMinRange(1);
						roam.setMaxRange(10);
						roam.setAllTerrainAvailable();
						roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
						roam.setTerrain(this.Const.World.TerrainType.Shore, false);
						roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
						c.addOrder(roam);
						this.Contract.getActiveState().start();
						this.World.Contracts.updateActiveContract();
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "FugitivesFail",
			Title = "По пути...",
			Text = "[img]gfx/ui/events/event_36.png[/img]{Вы упустили беглецов. Жаль, но в этой степи нет таких следопытов, что могли бы вновь напасть на их след. | Вы не смогли догнать вожаков орды и понятия не имеете, куда они подевались. Плохая новость: люди с такими знаниями и связями у лагеря появятся снова. | Как? Как вы могли дать им уйти?! Теперь орда узнает, кто жжёт её гнёзда, и в следующий раз встретит вас в полной готовности.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Нет, нет, нет!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Не удалось разорить лагеря орды");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "FugitivesAftermath",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_46.png[/img]{Беглецы перехвачены и перебиты. Кем бы они ни были в своей степи, здесь они закончили путь в грязи у дороги, оставив позади и шёлк, и амбиции. Больше никаких вестей не унесут. | Вожаки орды мертвы. Вы смотрите на их дорогие доспехи — теперь это просто трофеи, которые люди с удовольствием снимают с тел. | Вы смотрите на тело сотника орды. Лицо незнакомое, жёсткое, обветренное — человек, проживший в походах полжизни. %randombrother% подходит и сплёвывает прямо на его щиток.%SPEECH_ON%Я вот этих не боюсь. Были бы они так страшны — не бежали бы от нас.%SPEECH_OFF% | Беглецы пойманы. Одна часть отряда довольна лёгкой добычей, другая молча считает потери — степные лучники оказались не из тех, кто сдаётся. Третья часть, та, что у вас в голове, уже думает о том, что орда ответит за сожжённые лагеря.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Одной заботой меньше.",
					function getResult()
					{
						this.Flags.set("IsFugitives", false);
						this.Flags.set("IsFugitivesSpawned", false);
						this.Flags.set("ObjectivesDestroyed", this.Flags.get("ObjectivesDestroyed") + 1);
						this.Contract.m.Target = null;

						if (this.Flags.get("ObjectivesDestroyed") == 2)
						{
							this.Contract.setState("Return");
						}
						else
						{
							this.Contract.getActiveState().start();
							this.World.Contracts.updateActiveContract();
						}

						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Mercs",
			Title = "По мере приближения...",
			Text = "[img]gfx/ui/events/event_07.png[/img]{На подступах к месту, что зовётся \'%objective%\', вы натыкаетесь на чужой отряд — наёмников, судя по знамени и выправке. Их капитан, увидев ваши знамёна, сам поднимает руку, снимая напряжение.%SPEECH_ON%Погодите-ка. Вы ведь тоже по контракту? Нас с горячей головой нанял один благородный дом — мол, вон те степняки достали всех. Неужто и вас послали за той же головой?%SPEECH_OFF%Похоже, контракт у них такой же, как у вас: сжечь лагерь орды. Двум отрядам одна цель — или общий удар, или чужой клинк в спину. Решать нужно быстро: дым лагеря уже виден за холмом. | По дороге к месту, что зовётся \'%objective%\', вас догоняет отряд наёмников — люди в сборной броне, под выцветшим знаменем без герба. Их капитан едет вперёд с открытым забралом и кривится, разглядев вас.%SPEECH_ON%Вот те раз. Другая рота с тем же заказом, да? Нам за этот лагерь платят, так что либо поможете нам его сжечь, либо...%SPEECH_OFF%Он не договаривает, но рука его лежит на эфесе. Похоже, и вправду тот же контракт. Союзники на один удар — или лишние свидетели? | У места, что зовётся \'%objective%\', вы застаёте ещё один отряд: наёмники растянулись у ручья, чистя оружие перед боем. Их старший встаёт навстречу с усталой усмешкой.%SPEECH_ON%Неужели и вас за ним послали? Цены на нашу работу упали, приятель. Ладно, толку-то зря грызться: лагерь-то один. Можем пойти вместе — вдвоём ого-го как веселее будет. Или поспорить, чей контракт честнее.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Один лагерь — на двоих. Идём вместе.",
					function getResult()
					{
						this.Flags.set("IsMercsCoop", true);
						this.Contract.m.Current.getLoot().clear();
						this.Contract.m.Current.setDropLoot(false);
						this.Contract.getActiveState().onCombatWithPlayer(this.Contract.m.Current, false);
						return 0;
					}

				},
				{
					Text = "Контракт наш. Убирайтесь или примите бой.",
					function getResult()
					{
						this.Flags.set("IsMercs3Way", true);
						this.Contract.getActiveState().onCombatWithPlayer(this.Contract.m.Current, false);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "MercsAftermathCoop",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_07.png[/img]{Лагерь орды горит. Наёмники снимают с тел степняков всё, что хоть сколько-то стоит, и при этой работе удивительно похожи на ваших людей. Их капитан подходит, вытирая клинок, и тыкает саблей в сторону дыма.%SPEECH_ON%Даже неплохо сработались. Слушай, а у вас-то в заказе ещё что-нибудь есть?%SPEECH_OFF%Вы рассказываете про второй лагерь — %objective2% — и предлагаете пойти туда сообща: два отряда, одна цель. Капитан внимательно слушает, затем сплёвывает и качает головой.%SPEECH_ON%Мир в огне, приятель. Мы, по сути, благое дело тут делаем — вон, смотри, деревня дышит, крестьяне пашут. Только контракта на второй лагерь у нас нет, а работать за спасибо я своим парням не объясню. Так что вот — удачи. И до свидания.%SPEECH_OFF%Он свистит, и его отряд уходит в сторону заката, оставляя вас с дымящимся пепелищем и вторым контрактным лагерем. | Степняки в этом лагере перебиты, и наёмники радостно делят трофеи — их долю, вашу долю, вообще всякую долю. Вы же подходите к их капитану и предлагаете объединиться дальше: впереди ещё %objective2%.%SPEECH_ON%Хм. Честно? С удовольствием бы. Но у меня бумага — один лагерь, одна сумма. Понимаешь, бизнес. Мир, конечно, в огне, и мы тут, без шуток, спасаем его понемногу — но спасать его дальше за свой счёт как-то не по нашему.%SPEECH_OFF%Он хлопает вас по плечу и уводит своих людей, напевая что-то беззаботное. Второй лагерь, %objective2%, остаётся вашим и только вашим. | Общий удар удался: лагерь сожжён, потери невелики — особенно среди наёмников, которые ухитрились вломиться в бой после того, как ваши люди встретили основной удар. За делёжкой трофеев их капитан подходит к вам довольный, как кот.%SPEECH_ON%Вот так вот, по-божески. А теперь — что дальше?%SPEECH_OFF%Вы предлагаете держать путь вместе до %objective2%. Капитан почёсывает шею и разводит руками.%SPEECH_ON%Нет, приятель. Бумага на один лагерь — значит, один лагерь. Мы тут, можно сказать, служим человечеству — но бесплатно служить не умеем, простите уж.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Деловые люди. Что ж — удачи на дорогах.",
					function getResult()
					{
						this.Flags.set("IsMercsCoop", false);

						if (this.Flags.get("ObjectivesDestroyed") == 2)
						{
							this.Contract.setState("Return");
						}
						else
						{
							this.Contract.getActiveState().start();
							this.World.Contracts.updateActiveContract();
						}

						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "MercsAftermath3Way",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Среди мёртвых вы находите капитана наёмников — человека, с которым ещё час назад можно было договориться. %randombrother% склоняется над его знаменем.%SPEECH_ON%Второй лагерь, командир. Кстати, а кто теперь получит ИХ плату?%SPEECH_OFF%Вы пожимаете плечами. Не вам. | Капитан наёмников лежит среди степняков, не сумев выбрать, на чьей он стороне, — и остался без стороны вообще. Вы приказываете собрать трофеи: %objective2% ждёт. | Наёмники выбрали не те мечи, что ли. Их капитан был неплох, но на плохие решения хорошие капитаны гибнут так же охотно, как плохие. %objective2% ждёт. | Разобравшись с ордой, вы разобрались и с соперниками-наёмниками, решившими, что контракт стоит чужой крови. Пусть их наниматель ищет других исполнителей. %objective2% ждёт.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Поделом им.",
					function getResult()
					{
						this.Flags.set("IsMercs3Way", false);

						if (this.Flags.get("ObjectivesDestroyed") == 2)
						{
							this.Contract.setState("Return");
						}
						else
						{
							this.Contract.getActiveState().start();
							this.World.Contracts.updateActiveContract();
						}

						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% принимает вас в том же зале под расписными сводами, но теперь фонтаны за окном словно журчат громче. Визирь вручает кошель, не глядя вам в глаза.%SPEECH_ON%Сгорели, говоришь? Хорошо. Очень хорошо. Знай: северне будут списывать это на свои победы, а мы... мы предпочитаем, чтобы об этом не спрашивали. Вот твои %reward_completion% крон. Юг помнит своих друзей, наёмник — тихо.%SPEECH_OFF% | Вас встречает не сам наниматель, а его писец: сухой человек с воском на пальцах и взглядом счетовода. Он сверяет ваше имя по списку, кивает и вручает кошель с %reward_completion% крон.%SPEECH_ON%Господин просил передать: работа принята, лагеря сожжены, торговые пути дышат. Он также просил передать, чтобы вы... как он выразился... «не светились». Желаю удачи на северных дорогах, капитан.%SPEECH_OFF%Писец исчезает за дверью так же бесшумно, как появился. | %employer% принимает вас на террасе над гаванью. Караваны в порту стоят нагруженными, и наёмника это не удивляет — после сожжённых лагерей страховка подешевела на треть.%SPEECH_ON%Вот и возвращается кровь к телу, наёмник. Купцы уже пересчитывают прибыль, жрецы — свои молитвы, а я — твою плату. %reward_completion% крон, как договаривались.%SPEECH_OFF%Он протягивает кошель двумя пальцами, по-южному изящно.%SPEECH_ON%Заодно передай, кто спросит: мы здесь ни при чём. Молчание — лучшая плата, которую может дать юг.%SPEECH_OFF% | %employer% встречает вас под аркой, где никто не слышит. Кивок — и в ладонь ложится кошель с %reward_completion% кронами.%SPEECH_ON%Тихо сгорели, говоришь? Прекрасно. Никаких знамён, никаких свидетелей, никаких историй. Так мы и договаривались, наёмник. Двери города для тебя всегда открыты — просто не задерживайся у этой арки: здесь стоят стены, а они, знаешь ли, любят слушать.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Разорил лагеря Великой Орды");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isHordeInvasion())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCriticalContract);
						}

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
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"objective1",
			this.m.Flags.get("Objective1Name")
		]);
		_vars.push([
			"objective2",
			this.m.Flags.get("Objective2Name")
		]);
		local distToObj1 = this.m.Objective1 != null && !this.m.Objective1.isNull() && this.m.Objective1.isAlive() ? this.m.Objective1.getTile().getDistanceTo(this.World.State.getPlayer().getTile()) : 9999;
		local distToObj2 = this.m.Objective2 != null && !this.m.Objective2.isNull() && this.m.Objective2.isAlive() ? this.m.Objective2.getTile().getDistanceTo(this.World.State.getPlayer().getTile()) : 9999;

		if (distToObj1 < distToObj2)
		{
			_vars.push([
				"objective",
				this.m.Flags.get("Objective1Name")
			]);
		}
		else
		{
			_vars.push([
				"objective",
				this.m.Flags.get("Objective2Name")
			]);
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Objective1 != null && !this.m.Objective1.isNull() && this.m.Objective1.isAlive())
			{
				this.m.Objective1.getSprite("selection").Visible = false;
				this.m.Objective1.setOnCombatWithPlayerCallback(null);
			}

			if (this.m.Objective2 != null && !this.m.Objective2.isNull() && this.m.Objective2.isAlive())
			{
				this.m.Objective2.getSprite("selection").Visible = false;
				this.m.Objective2.setOnCombatWithPlayerCallback(null);
			}

			if (this.m.Target != null && !this.m.Target.isNull() && this.m.Target.isAlive())
			{
				this.m.Target.getSprite("selection").Visible = false;
				this.m.Target.setOnCombatWithPlayerCallback(null);
			}

			this.m.Current = null;
			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isHordeInvasion())
		{
			return false;
		}

		if (this.m.IsStarted)
		{
			if (this.m.Objective1 == null || this.m.Objective1.isNull() || !this.m.Objective1.isAlive())
			{
				return false;
			}

			if (this.m.Objective2 == null || this.m.Objective2.isNull() || !this.m.Objective2.isAlive())
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
		if (this.m.Objective1 != null && !this.m.Objective1.isNull())
		{
			_out.writeU32(this.m.Objective1.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		if (this.m.Objective2 != null && !this.m.Objective2.isNull())
		{
			_out.writeU32(this.m.Objective2.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		if (this.m.Target != null && !this.m.Target.isNull())
		{
			_out.writeU32(this.m.Target.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local obj1 = _in.readU32();

		if (obj1 != 0)
		{
			this.m.Objective1 = this.WeakTableRef(this.World.getEntityByID(obj1));
		}

		local obj2 = _in.readU32();

		if (obj2 != 0)
		{
			this.m.Objective2 = this.WeakTableRef(this.World.getEntityByID(obj2));
		}

		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}

		this.contract.onDeserialize(_in);
	}

});
