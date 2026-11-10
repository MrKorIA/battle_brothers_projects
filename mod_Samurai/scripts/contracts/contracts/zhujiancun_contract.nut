this.zhujiancun_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Stage = 1,
		Destination = null
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.zhujiancun";
		this.m.TimeOut = 0.0;
		this.setStage(this.m.Stage);
	}

	function setStage( _stage )
	{
		this.m.Stage = _stage;
		local names = [
			"Защитить Деревню Меча",
			"Вернуть похищенных",
			"Спасти кузнеца",
			"Онимуша"
		];
		local difficulty = [0.85, 1.0, 1.15, 1.3];
		this.m.Name = names[_stage - 1];
		this.m.DifficultyMult = difficulty[_stage - 1];
	}

	function getBanner()
	{
		return "ui/banners/factions/zhujiancun_01s";
	}

	function onImportIntro()
	{
	}

	function start()
	{
		this.contract.start();
	}

	function getObjective()
	{
		switch(this.m.Stage)
		{
		case 1:
			return "Отразить нападение Тадахисы Исикавы на Деревню Меча";

		case 2:
			return "Зачистить лагерь Уэды Такеши и освободить пленных жителей";

		case 3:
			return "Победить Хидэо Ямаду и вернуть кузнеца";

		default:
			return "Убить Онимушу и уничтожить поднятых его клинком мертвецов";
		}
	}

	function getBattleResources()
	{
		local resources = [70, 110, 140, 165];
		return resources[this.m.Stage - 1] * this.getScaledDifficultyMult();
	}

	function getBossType()
	{
		switch(this.m.Stage)
		{
		case 1:
			return this.Const.World.Spawn.Troops.Wushi02;

		case 2:
			return this.Const.World.Spawn.Troops.Wushi03;

		case 3:
			return this.Const.World.Spawn.Troops.Wushi04;

		default:
			return this.Const.World.Spawn.Troops.Wushi05;
		}
	}

	function setDestination( _destination )
	{
		this.m.Destination = this.WeakTableRef(_destination);
		this.m.Flags.set("DestinationName", _destination.getName());
	}

	function findWushiDestination()
	{
		local faction = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Wushi);
		local best;
		local bestDistance = 9000;

		foreach( location in faction.getSettlements() )
		{
			if (location == null || !location.isAlive())
			{
				continue;
			}

			if (this.m.Stage == 4 && location.getName() != "Онимуша")
			{
				continue;
			}

			local distance = location.getTile().getDistanceTo(this.m.Home.getTile());

			if (distance < bestDistance)
			{
				best = location;
				bestDistance = distance;
			}
		}

		return best;
	}

	function spawnWushiDestination()
	{
		local tile = this.getTileToSpawnLocation(this.m.Home.getTile(), 8, 14, [
			this.Const.World.TerrainType.Mountains,
			this.Const.World.TerrainType.Impassable,
			this.Const.World.TerrainType.Ocean,
			this.Const.World.TerrainType.Shore
		], false);

		if (tile == null)
		{
			return null;
		}

		local script = this.m.Stage == 4 ? "scripts/entity/world/locations/wushi03_camp_location" : "scripts/entity/world/locations/wushi_camp_location";
		local location = this.World.spawnLocation(script, tile.Coords);
		local faction = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Wushi);
		location.setBanner(this.Const.WushiBanners[this.Math.rand(0, this.Const.WushiBanners.len() - 1)]);
		location.onSpawned();
		faction.addSettlement(location, false);
		return location;
	}

	function prepareDestination()
	{
		if (this.m.Destination != null && !this.m.Destination.isNull() && this.m.Destination.isAlive())
		{
			return true;
		}

		local resources = this.getBattleResources();

		if (this.m.Stage == 1)
		{
			local tile = this.getTileToSpawnLocation(this.m.Home.getTile(), 4, 6);

			if (tile == null)
			{
				return false;
			}

			local faction = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Wushi);
			local party = faction.spawnEntity(tile, "Мародёры Тадахисы Исикавы", false, this.Const.World.Spawn.WushiRaiders, resources);
			this.Const.World.Common.addTroop(party, {
				Type = this.getBossType()
			}, false);
			party.updateStrength();
			party.setDescription("Бывшие воины флота Сёгуна, ставшие мародёрами под предводительством Тадахисы Исикавы.");
			party.setFootprintType(this.Const.World.FootprintsType.Brigands);
			party.setAttackableByAI(false);
			party.setAlwaysAttackPlayer(true);
			party.setVisibleInFogOfWar(true);
			party.setImportant(true);
			party.setDiscovered(true);
			this.m.UnitsSpawned.push(party.getID());
			local controller = party.getController();
			controller.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
			local intercept = this.new("scripts/ai/world/orders/intercept_order");
			intercept.setTarget(this.World.State.getPlayer());
			controller.addOrder(intercept);
			this.setDestination(party);
			return true;
		}

		local destination = this.findWushiDestination();

		if (destination == null)
		{
			destination = this.spawnWushiDestination();
		}

		if (destination == null)
		{
			return false;
		}

		destination.clearTroops();
		destination.setLastSpawnTimeToNow();
		destination.setResources(resources);
		destination.setLootScaleBasedOnResources(resources);
		this.addUnitsToEntity(destination, this.Const.World.Spawn.WushiDefenders, resources);
		this.Const.World.Common.addTroop(destination, {
			Type = this.getBossType()
		}, false);

		if (this.m.Stage == 4)
		{
			destination.m.IsSpawningDefenders = false;
			destination.setDefenderSpawnList(this.Const.World.Spawn.WushiDefenders);
			this.m.Flags.set("OnimushaLastGrowthDay", this.World.getTime().Days);
		}

		destination.updateStrength();
		destination.setAttackable(true);
		destination.setAttackableByAI(false);
		destination.setDiscovered(true);
		this.World.uncoverFogOfWar(destination.getTile().Pos, 500.0);
		this.setDestination(destination);
		return true;
	}

	function growOnimushaHorde()
	{
		if (this.m.Stage != 4 || this.m.Destination == null || this.m.Destination.isNull() || !this.m.Destination.isAlive())
		{
			return;
		}

		local currentDay = this.World.getTime().Days;
		local lastGrowthDay = this.m.Flags.getAsInt("OnimushaLastGrowthDay");
		local elapsedDays = currentDay - lastGrowthDay;

		if (elapsedDays <= 0)
		{
			return;
		}

		local growthDays = this.m.Flags.getAsInt("OnimushaGrowthDays");
		local daysToGrow = this.Math.min(elapsedDays, 30 - growthDays);
		this.m.Flags.set("OnimushaLastGrowthDay", currentDay);

		if (daysToGrow <= 0)
		{
			return;
		}

		for( local i = 0; i < daysToGrow; i = ++i )
		{
			this.addUnitsToEntity(this.m.Destination, this.Const.World.Spawn.WushiDefenders, 10 * this.getScaledDifficultyMult());
			this.m.Destination.setResources(this.m.Destination.getResources() + 10);
		}

		this.m.Flags.set("OnimushaGrowthDays", growthDays + daysToGrow);
	}

	function startOnimushaCombat( _isPlayerAttacking )
	{
		local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
		properties.Music = this.Const.Music.WushiTracks;
		properties.AfterDeploymentCallback = this.zombifyOnimushaTroops.bindenv(this);
		this.World.Contracts.startScriptedCombat(properties, _isPlayerAttacking, true, true);
	}

	function zombifyOnimushaTroops()
	{
		if (this.m.Destination == null || this.m.Destination.isNull())
		{
			return;
		}

		local faction = this.m.Destination.getFaction();
		local instances = this.Tactical.Entities.getAllInstances();

		foreach( factionInstances in instances )
		{
			foreach( entity in factionInstances )
			{
				if (entity.getFaction() == faction && entity.getType() != this.Const.EntityType.Wushi05)
				{
					this.zombifyWushi(entity);
				}
			}
		}
	}

	function zombifyWushi( _entity )
	{
		_entity.m.BloodType = this.Const.BloodType.Dark;
		_entity.m.MoraleState = this.Const.MoraleState.Ignore;
		_entity.getFlags().remove("human");
		_entity.getFlags().add("undead");
		_entity.getFlags().add("zombie_minion");
		local properties = _entity.m.BaseProperties;
		properties.IsAffectedByNight = false;
		properties.IsAffectedByInjuries = false;
		properties.IsImmuneToBleeding = true;
		properties.IsImmuneToPoison = true;
		properties.FatigueDealtPerHitMult = 2.0;
		_entity.m.AIAgent = this.new("scripts/ai/tactical/agents/zombie_agent");
		_entity.m.AIAgent.setActor(_entity);
		_entity.m.Sound[this.Const.Sound.ActorEvent.NoDamageReceived] = [];
		_entity.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/zombie_hurt_01.wav",
			"sounds/enemies/zombie_hurt_02.wav",
			"sounds/enemies/zombie_hurt_03.wav",
			"sounds/enemies/zombie_hurt_04.wav"
		];
		_entity.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/zombie_death_01.wav",
			"sounds/enemies/zombie_death_02.wav",
			"sounds/enemies/zombie_death_03.wav"
		];
		_entity.m.Sound[this.Const.Sound.ActorEvent.Resurrect] = [
			"sounds/enemies/zombie_rise_01.wav",
			"sounds/enemies/zombie_rise_02.wav"
		];
		_entity.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/zombie_idle_01.wav",
			"sounds/enemies/zombie_idle_02.wav",
			"sounds/enemies/zombie_idle_03.wav",
			"sounds/enemies/zombie_idle_04.wav"
		];
		_entity.m.Sound[this.Const.Sound.ActorEvent.Move] = _entity.m.Sound[this.Const.Sound.ActorEvent.Idle];
		_entity.m.SoundVolume[this.Const.Sound.ActorEvent.Move] = 0.1;
		_entity.m.SoundPitch = 0.8;
		local head = _entity.getSprite("head");
		local body = _entity.getSprite("body");
		head.Saturation = 0.5;
		head.Color = this.createColor("#c1ddaa");
		body.Color = head.Color;
		body.Saturation = head.Saturation;
		local headInjury = _entity.getSprite("tattoo_head");
		headInjury.setBrush("zombify_01");
		headInjury.Visible = true;
		local bodyInjury = _entity.getSprite("tattoo_body");
		bodyInjury.setBrush("zombify_body_01");
		bodyInjury.Visible = true;

		if (_entity.hasSprite("morale"))
		{
			_entity.getSprite("morale").Visible = false;
		}

		_entity.getSkills().update();
		_entity.setDirty(true);
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					this.Contract.getObjective()
				];
				this.Contract.setScreen("Task");
			}

			function end()
			{
				this.World.Contracts.setActiveContract(this.Contract);
			}
		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					this.Contract.getObjective()
				];

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					if (this.Contract.m.Stage == 4)
					{
						this.Contract.m.Destination.m.IsSpawningDefenders = false;
						this.Contract.m.Destination.setDefenderSpawnList(this.Const.World.Spawn.WushiDefenders);
					}

					this.Contract.m.Destination.getSprite("selection").Visible = true;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onDestinationAttacked.bindenv(this));
				}
			}

			function update()
			{
				this.Contract.growOnimushaHorde();
				local destination = this.Contract.m.Destination;

				if (!this.Flags.get("IsAftermathShown") && (destination == null || destination.isNull() || !destination.isAlive()))
				{
					this.Flags.set("IsAftermathShown", true);
					this.Contract.setScreen("Aftermath");
					this.World.Contracts.showActiveContract();
				}
			}

			function onDestinationAttacked( _dest, _isPlayerAttacking = true )
			{
				this.Flags.set("IsPlayerAttacking", _isPlayerAttacking);

				if (!this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);
					this.Contract.setScreen("Approach");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.m.Stage == 4)
				{
					this.Contract.startOnimushaCombat(_isPlayerAttacking);
				}
				else
				{
					this.World.Contracts.showCombatDialog(_isPlayerAttacking);
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

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(null);
				}

				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success");
					this.World.Contracts.showActiveContract();
				}
			}
		});
	}

	function createScreens()
	{
		this.m.Screens.push({
			ID = "Task",
			Title = this.m.Name,
			Text = "",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			ShowObjectives = true,
			ShowPayment = false,
			Options = [
				{
					Text = "Мы поможем Деревне Меча.",
					function getResult()
					{
						if (!this.Contract.prepareDestination())
						{
							return "NoDestination";
						}

						this.Contract.m.IsNegotiated = true;
						this.Contract.setState("Running");
						return 0;
					}
				},
				{
					Text = "Мы вернёмся к этому разговору позже.",
					function getResult()
					{
						return 0;
					}
				}
			],
			function start()
			{
				this.Title = this.Contract.m.Name;

				switch(this.Contract.m.Stage)
				{
				case 1:
					this.Text = "[img]gfx/ui/events/event_08.png[/img]%employer% проводит вас мимо пустых домов к залу, где над потухшим очагом висит потрёпанное знамя.%SPEECH_ON%Здесь собрались изгнанники, неудачники и путешественники с востока. Мы были заблудшими людьми, пока не нашли эту землю. Потом великий Сёгун объединил сёгунаты и повёл огромный флот за море. Шторм разбил корабли. Одни выжившие пришли к нам и помогли построить \'Деревню меча\', другие забыли про свою честь и стали обычными мародёрами, нарывом на текущих землях.%SPEECH_OFF%Он смотрит в сторону закрытых ворот.%SPEECH_ON%Тадахиса Исикава ведёт таких отступников сюда. Беря всё, мы не можем ему дать отпор, у нас нет сил, потому платим дань. Защити нас, и мы докажем, что умеем быть не только просителями. Ты получишь право торговать с нами.%SPEECH_OFF%";
					break;

				case 2:
					this.Text = "[img]gfx/ui/events/event_45.png[/img]%employer% раскладывает на столе старый список жителей этой деревеньки. Многие имена вычеркнуты.%SPEECH_ON%Раньше нас было больше. Мародёры уводят людей в плен: кто-то нужен им для работы, кого-то ждёт рабский рынок. Разведчики обнаружили лагерь под предводительством Уэда Такеши, который терроризирует наше поселение больше прочих. Там же находятся многие из похищеных жителей.%SPEECH_OFF%Он касается списка.%SPEECH_ON%Разбей охрану и верни пленников. Когда семьи вновь соберутся вместе, среди спасённых найдутся и те, кто захочет встать под твоё знамя.%SPEECH_OFF%";
					break;

				case 3:
					this.Text = "[img]gfx/ui/events/event_16.png[/img]%employer% показывает пустую кузницу. Горн остыл, на наковальне лежит недокованный клинок.%SPEECH_ON%Нашего кузнеца схватили люди Хидэо Ямады. Теперь он куёт оружие для тех самых мародёров, от которых мы строили убежище. Его держат недалеко отсюда.%SPEECH_OFF%%employer% выпрямляется.%SPEECH_ON%Приди туда, победи Хидэо и верни нашего мастера домой. В благодарность за это мы не станем возражать против того, что бы ты и твои люди пользовались его услугами.%SPEECH_OFF%";
					break;

				default:
					this.Text = "[img]gfx/ui/events/event_13.png[/img]%employer% кладёт перед вами пустые ножны с потускневшим орнаментом.%SPEECH_ON%Их нашёл один из наших жителей, а внутри лежала катана «Смерть Самурая-призрака». Сначала он слышал её шёпот, потом перестал узнавать родных, а вскоре принялся убивать всех, кто попадался ему на глаза. Теперь он называет себя Онимушей.%SPEECH_OFF%%employer% проводит пальцем по пустому месту на ножнах.%SPEECH_ON%Каждый человек, павший от этого клинка, поднимается мертвецом и сражается на стороне убийцы. Онимуша засел в склепе, а его войско растёт с каждым днём. Найди его и останови, пока мертвецы не заполонили всю округу. Сделай это, и наши хранители откроют тебе доступ к особым товарам.%SPEECH_OFF%";
					break;
				}
			}
		});
		this.m.Screens.push({
			ID = "NoDestination",
			Title = "Разведчики ждут",
			Text = "Сейчас разведчики не могут указать подходящий путь к лагерю. Вернитесь к этому контракту позже.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Понятно.",
					function getResult()
					{
						return "Task";
					}
				}
			]
		});
		this.m.Screens.push({
			ID = "Approach",
			Title = "Перед боем",
			Text = "",
			Image = "",
			List = [],
			Options = [
				{
					Text = "К оружию!",
					function getResult()
					{
						this.Contract.getActiveState().onDestinationAttacked(this.Contract.m.Destination, this.Flags.get("IsPlayerAttacking"));
						return 0;
					}
				}
			],
			function start()
			{
				switch(this.Contract.m.Stage)
				{
				case 1:
					this.Text = "[img]gfx/ui/events/event_80.png[/img]Отряд иноземных мародёров выходит к поселению, не скрывая намерений. Во главе мародёров виден Тадахиса Исикава: прежняя субординация забыта, теперь он признаёт только звон крон. Вам знакомо это, но всё же между вами есть разницы, поэтому вы и стоите по разные стороны. Воины Деревни Меча отступают за ворота — этот бой придётся принять вам.";
					break;

				case 2:
					this.Text = "[img]gfx/ui/events/event_54.png[/img]За частоколом лагеря %destination% вы замечаете связанных жителей. Уэда Такеши отдаёт приказ, и охрана занимает места среди брешей в частоколе. Пленников нельзя вывести, пока его воины держат лагерь.";
					break;

				case 3:
					this.Text = "[img]gfx/ui/events/event_54.png[/img]В лагере %destination% горн работает под чужим надзором. Кузнец жив, но возле него стоят воины Хидэо Ямады. Заметив ваш отряд, Хидэо берётся за оружие.";
					break;

				default:
					this.Text = "[img]gfx/ui/events/event_29.png[/img]В склепе %destination% не слышно ни приказов, ни живых голосов — только шарканье мертвецов. Между ними стоит Онимуша с катаной «Смерть Самурая-призрака» в руках. При виде вашего отряда он поднимает клинок, и зомби одновременно приходят в движение.";
					break;
				}
			}
		});
		this.m.Screens.push({
			ID = "Aftermath",
			Title = "После битвы",
			Text = "",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Возвращаемся в Деревню Меча.",
					function getResult()
					{
						this.Contract.setState("Return");
						return 0;
					}
				}
			],
			function start()
			{
				switch(this.Contract.m.Stage)
				{
				case 1:
					this.Text = "[img]gfx/ui/events/event_22.png[/img]Тадахиса Исикава повержен, а его мародёры разбиты. На стенах поселения появляются люди — сначала осторожные, затем ликующие. Теперь стоит вернуться и услышать, что скажут те, кто ещё вчера не доверял чужакам.";
					break;

				case 2:
					this.Text = "[img]gfx/ui/events/event_22.png[/img]С гибелью Уэды Такеши сопротивление в лагере прекращается. Вы вскрываете клети, перерезаете путы и собираете всех уцелевших. Среди них — жители Деревни Меча, давно считавшиеся пропавшими. Все освобождены; осталось довести их до дома.";
					break;

				case 3:
					this.Text = "[img]gfx/ui/events/event_22.png[/img]Хидэо Ямада мёртв. Возле импровизированной кузницы вы находите мастера-кузнеца — избитого, но способного идти. Он забирает свои инструменты и через некоторое время готов к переходу. Пора возвращаться";
					break;

				default:
					this.Text = "[img]gfx/ui/events/event_28.png[/img]Онимуша падает, и поднятые им мертвецы один за другим замирают среди каменных плит. Его войско больше не растёт. Катана остаётся лежать рядом с телом — опасный трофей для того, кто рискнёт взять её с собой.";
					break;
				}
			}
		});
		this.m.Screens.push({
			ID = "Success",
			Title = "По возвращении",
			Text = "",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Деревня Меча может рассчитывать на нас.",
					function getResult()
					{
						this.Contract.m.Home.completeContractStage(this.Contract.m.Stage);
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Помог Деревне Меча");
						this.World.Contracts.finishActiveContract();

						if (this.World.State.getCurrentTown() != null)
						{
							this.World.State.getTownScreen().getMainDialogModule().reload();
						}

						return 0;
					}
				}
			],
			function start()
			{
				local building;

				switch(this.Contract.m.Stage)
				{
				case 1:
					this.Text = "[img]gfx/ui/events/event_01.png[/img]%employer% встречает вас у открытых ворот.%SPEECH_ON%Спасибо. Ты защитил не просто дома, а наше право жить здесь. Теперь мы тебе достаточно доверяем что бы разрешить тебе с нами торговать. А теперь ступай, мне предстоит ещё много дел.%SPEECH_OFF%";
					building = " рынок";
					break;

				case 2:
					this.Text = "[img]gfx/ui/events/event_80.png[/img]Освобождённые жители входят в поселение под звон колокольчиков. %employer% долго не может говорить, глядя на встречающиеся семьи.%SPEECH_ON%Ты вернул нам людей. Некоторые хотят отплатить не словами, а службой. Отныне ты можешь пополнять свой отряд в Деревне Меча.%SPEECH_OFF%";
					building = " найм братьев";
					break;

				case 3:
					this.Text = "[img]gfx/ui/events/event_01.png[/img]Кузнец едва переступает порог мастерской, как вновь разжигает горн.%employer% кладёт руку на восстановленную наковальню.%SPEECH_ON%Ты вернул мне моё ремесло. Мастерская снова работает — её клинки и ремонт доступны твоему отряду.%SPEECH_OFF%";
					building = " кузнец";
					break;

				default:
					this.Text = "[img]gfx/ui/events/event_01.png[/img]Весть о падении Онимуши обгоняет ваш отряд. %employer% открывает дверь хранилища, где до этого дня собирали редкие вещи на чёрный день.%SPEECH_ON%Ты сделал эти земли безопаснее. Хранители согласны торговать с тобой особыми предметами — пусть они помогут твоим будущим походам.%SPEECH_OFF%";
					building = "ы тайны самураев";
					break;
				}

				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = "В Деревне Меча открыт" + building
				});
			}
		});
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"destination",
			this.m.Destination == null || this.m.Destination.isNull() ? this.m.Flags.get("DestinationName") : this.m.Destination.getName()
		]);
		_vars.push([
			"direction",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.Const.Strings.Direction8[this.m.Home.getTile().getDirection8To(this.m.Destination.getTile())]
		]);
	}

	function onHomeSet()
	{
	}

	function onClear()
	{
		if (this.m.Destination != null && !this.m.Destination.isNull())
		{
			this.m.Destination.getSprite("selection").Visible = false;
			this.m.Destination.setOnCombatWithPlayerCallback(null);

			if (this.m.Destination.isLocation())
			{
				this.m.Destination.setAttackableByAI(true);
			}
		}

		if (this.m.Home != null && !this.m.Home.isNull())
		{
			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (this.m.Home != null && !this.m.Home.isNull())
		{
			return this.m.Home.getFlags().getAsInt("ZhujiancunStage") + 1 == this.m.Stage;
		}

		return true;
	}

	function onSerialize( _out )
	{
		_out.writeI32(0);
		_out.writeU8(this.m.Stage);

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
		this.setStage(_in.readU8());
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		this.contract.onDeserialize(_in);
	}
});
