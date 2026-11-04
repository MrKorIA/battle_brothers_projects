this.historian_and_cartographer_pinpoint_famed_event <- this.inherit("scripts/events/event", {
	m = {
		Cartographer = null,
		Historian = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_historian_and_cartographer_pinpoint_famed";
		this.m.Title = "В лагере...";
		this.m.Cooldown = 12.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_45.png[/img][M] Занявшись рутинной инвентаризацией припасов, вы внезапно вздрагиваете от шума: в палатку одновременно влетают %cartographer% и %historian%, наперебой выдавая поток возбуждённого бормотания. Вы свирепо рычите, приказывая им взять себя в руки. Учёные мужи мгновенно умолкают и озадаченно переглядываются. Недолго помедлив, %historian% делает шаг вперёд и говорит первым.%SPEECH_ON%Сэр, нам необходимо сообщить вам нечто чрезвычайной важности! Видите ли, долгое время я тщательно отслеживал трактирные слухи о знаменитом оружии и древних реликвиях, сопоставляя услышанное со своими личными знаниями и архивными свитками. По правде говоря, поначалу это было лишь ради праздного любопытства... К тому же, это всяко лучше, чем общаться с большинством неотёсанных грубиянов из нашего отряда %companyname%. Я и сам не ожидал, что из моих изысканий выйдет какой-то толк, пока своими мыслями со мной не поделился %cartographer%...%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Переходи к делу.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cartographer.getImagePath());
				this.Characters.push(_event.m.Historian.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_45.png[/img][M] Историк %historian% продолжает.%SPEECH_ON%Мой коллега %cartographer% тоже зря времени не терял: он скрупулёзно заносил в походный журнал все древние руины и ориентиры, чтобы определить для нас интересные места. Сопоставив наши записи, мы теперь уверены, что вот в этих краях спрятан знаменитый артефакт!%SPEECH_OFF%В этот момент %cartographer% с сухим шуршанием разворачивает свежую карту, а историк уверенно тычет пальцем в одну из отмеченных точек.%SPEECH_ON%Это может быть что угодно: вековой кованый доспех, грозное оружие, а возможно, редкий щит или шлем. К сожалению, в моих хрониках нет точного описания этой реликвии. Но я готов поставить на кон своё жалованье за полсотни дней, что если мы вырежем всю шваль, засевшую в этих руинах, то добудем нечто воистину невероятное!%SPEECH_OFF%Оба исследователя довольно улыбаются, гордые своей работой. Разглядывая исчерченные пергаменты, вы понимаете, что обретение знаменитого снаряжения - это лучший способ укрепить боевую мощь отряда %companyname% и прославить его знамя.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Чего мы ждём? Идём за ним!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cartographer.getImagePath());
				this.Characters.push(_event.m.Historian.getImagePath());
				local goblinSettlements = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getSettlements();
				local orcSettlements = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getSettlements();
				local zombieSettlements = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getSettlements();
				local undeadSettlements = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getSettlements();
				local banditSettlements = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getSettlements();
				local barbarianSettlements = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).getSettlements();
				local selector = this.Math.rand(0, 5);
				local settlementPool;

				if (selector == 0)
				{
					settlementPool = goblinSettlements;
				}
				else if (selector == 1)
				{
					settlementPool = orcSettlements;
				}
				else if (selector == 2)
				{
					settlementPool = zombieSettlements;
				}
				else if (selector == 3)
				{
					settlementPool = undeadSettlements;
				}
				else if (selector == 4)
				{
					settlementPool = banditSettlements;
				}
				else
				{
					settlementPool = barbarianSettlements;
				}

				local settlement = settlementPool[this.Math.rand(0, settlementPool.len() - 1)];
				local destination = this.WeakTableRef(settlement);
				local destinationName = settlement.getName();
				destination.setDiscovered(true);
				this.World.uncoverFogOfWar(destination.getTile().Pos, 500.0);
				this.World.getCamera().moveTo(destination.get());
				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = "Картограф обнаружил место под названием " + destinationName
				});
				local type = this.Math.rand(20, 100);

				if (type <= 50)
				{
					local weapons = clone this.Const.Items.NamedWeapons;

					if (settlement.m.NamedWeaponsList != null && settlement.m.NamedWeaponsList.len() != 0)
					{
						weapons.extend(settlement.m.NamedWeaponsList);
						weapons.extend(settlement.m.NamedWeaponsList);
					}

					settlement.m.Loot.add(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
				}
				else if (type <= 60)
				{
					local shields = clone this.Const.Items.NamedShields;

					if (settlement.m.NamedShieldsList != null && settlement.m.NamedShieldsList.len() != 0)
					{
						shields.extend(settlement.m.NamedShieldsList);
						shields.extend(settlement.m.NamedShieldsList);
					}

					settlement.m.Loot.add(this.new("scripts/items/" + shields[this.Math.rand(0, shields.len() - 1)]));
				}
				else if (type <= 80)
				{
					local helmets = clone this.Const.Items.NamedHelmets;

					if (settlement.m.NamedHelmetsList != null && settlement.m.NamedHelmetsList.len() != 0)
					{
						helmets.extend(settlement.m.NamedHelmetsList);
						helmets.extend(settlement.m.NamedHelmetsList);
					}

					settlement.m.Loot.add(this.new("scripts/items/" + helmets[this.Math.rand(0, helmets.len() - 1)]));
				}
				else if (type <= 100)
				{
					local armor = clone this.Const.Items.NamedArmors;

					if (settlement.m.NamedArmorsList != null && settlement.m.NamedArmorsList.len() != 0)
					{
						armor.extend(settlement.m.NamedArmorsList);
						armor.extend(settlement.m.NamedArmorsList);
					}

					settlement.m.Loot.add(this.new("scripts/items/" + armor[this.Math.rand(0, armor.len() - 1)]));
				}

				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = "Историк выследил некий знаменитый предмет в этом месте"
				});
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_cartographer = [];
		local candidates_historian = [];
		local scoreMultiplier = 1;

		foreach( b in brothers )
		{
			if (b.getBackground().getID() == "background.historian")
			{
				scoreMultiplier = scoreMultiplier + b.getLevel();
				candidates_historian.push(b);
			}
			else if (b.getBackground().getID() == "background.hackflows_cartographer")
			{
				scoreMultiplier = scoreMultiplier + b.getLevel();
				candidates_cartographer.push(b);
			}
		}

		if (candidates_cartographer.len() == 0 || candidates_historian.len() == 0)
		{
			return;
		}

		this.m.Cartographer = candidates_cartographer[this.Math.rand(0, candidates_cartographer.len() - 1)];
		this.m.Historian = candidates_historian[this.Math.rand(0, candidates_historian.len() - 1)];
		this.m.Score = 20 * scoreMultiplier * (candidates_cartographer.len() + candidates_historian.len());

		if (this.World.Assets.getOrigin().getID() == "scenario.hackflows_treasure_hunters")
		{
			this.m.Score *= 2;
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cartographer",
			this.m.Cartographer.getName()
		]);
		_vars.push([
			"historian",
			this.m.Historian.getName()
		]);
	}

	function onClear()
	{
		this.m.Cartographer = null;
		this.m.Historian = null;
	}

});

