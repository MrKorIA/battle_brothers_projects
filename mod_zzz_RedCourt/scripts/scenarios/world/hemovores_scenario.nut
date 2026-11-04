this.hemovores_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.hemovores";
		this.m.Name = "Багровый суд";
		this.m.Description = "[p=c][img]gfx/ui/events/event_33.png[/img][/p][p]Древние призывают к порядку - но, эти порядки как всегда неизменны. Столетия сменяют друг друга, но время перемен всё ещё не пришло. Возможно, вы и несколько преданных вам людей могли бы изменить это...  \n[color=#bcad8c]Новый порядок:[/color] Начните с отрядом из 4-х молодых некросавантов. Вы можете встретить подобных себе в городах. \n[color=#bcad8c]Хрупкий морок:[/color] Колдовское зелье надёжно скроет вашу истинную сущность от взоров смертных, а любой смертный, примкнувший к отряду, безропотно отдаст за вас жизнь. Но у всего есть своя цена - цены покупки и продажи хуже на 30%.[/p]";
		this.m.Difficulty = 3;
		this.m.Order = 120;
		this.m.IsFixedLook = true;
	}

	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();
		local names = [];
		::TheRedCourt.FemaleSpawn = false;

		for( local i = 0; i < 4; i = ++i ) //4 starters
		{
			local bro;
			bro = roster.create("scripts/entity/tactical/player");
			///---
 			bro.getSprite("socket").setBrush("bust_base_undead");
			///---
			bro.m.HireTime = this.Time.getVirtualTimeF();

			while (names.find(bro.getNameOnly()) != null)
			{
				bro.setName(this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
			}

			names.push(bro.getNameOnly());
		}

		local bros = roster.getAll();
		///---
		bros[0].setStartValuesEx([ // 1
			"hemovore_LOW_background"
		]);
		bros[0].getSkills().add(this.new("scripts/skills/traits/hemovore_trait")); //vampire racial stuff
		bros[0].getSkills().getAllSkillsOfType(this.Const.SkillType.Background)[0].m.RawDescription = "%name% устал от маразма Древних старейшин задолго до того, как вы сами вступили в их проклятые ряды. Веками они вынашивали планы мести тем, кто для большинства остаётся недосягаемой целью. Этот бессмертный с радостью ухватился за возможность бросить вызов Совету Древних и примкнуть к вам - ради былой славы и духа истинных приключений, совсем как много столетий назад, когда он ещё был человеком.";
 		bros[0].unlockPerk("perk.vampire_ancient_wisdom");
        bros[0].m.PerkPoints = 1;
        bros[0].m.LevelUps = 2;
        bros[0].m.Level = 3;
		bros[0].setPlaceInFormation(3);
        ::TheRedCourt.AddRedCourtTalents(bros[0]);
		///---
		bros[1].setStartValuesEx([ // 2
			"hemovore_MED_background"
		]);
		bros[1].getSkills().add(this.new("scripts/skills/traits/hemovore_trait")); //vampire racial stuff
		bros[1].getSkills().getAllSkillsOfType(this.Const.SkillType.Background)[0].m.RawDescription = "До недавнего времени %name% оставался верным псом Древних старейшин. Столетия безупречной службы патрициям и высшей знати были вознаграждены ровно ничем. Окончательно осознав, что его просто использовали как безвольное орудие, %name% бросил унылые интриги имперских склепов и примкнул к вашему отряду. Впрочем, этот бессмертный честно признаётся, что заглядывать в будущее дальше сегодняшней ночи он пока не готов.";
        bros[1].unlockPerk("perk.vampire_ancient_wisdom");
        bros[1].m.PerkPoints = 1;
        bros[1].m.LevelUps = 2;
        bros[1].m.Level = 3;
		bros[1].setPlaceInFormation(4);
        ::TheRedCourt.AddRedCourtTalents(bros[1]);
		///---
		bros[2].setStartValuesEx([ // 3
			"hemovore_LOW_background"
		]);
		bros[2].getSkills().add(this.new("scripts/skills/traits/hemovore_trait")); //vampire racial stuff
		bros[2].getSkills().getAllSkillsOfType(this.Const.SkillType.Background)[0].m.RawDescription = "Когда-то %name% занимал видное место среди имперской знати, но навсегда ожесточился после неудавшегося кровавого переворота. Заговорщики так и не выдали его - даже под пытками, перед тем как им отсекли головы и сбросили безжизненные тела в реку. С тех пор этот бессмертный живёт с грызущим изнутри чувством вины перед мертвецами. Но кто знает... возможно, именно этого Древние старейшины и добивались с самого начала?";
 		bros[2].unlockPerk("perk.vampire_ancient_wisdom");
        bros[2].m.PerkPoints = 1;
        bros[2].m.LevelUps = 2;
        bros[2].m.Level = 3;
		bros[2].setPlaceInFormation(5);
        ::TheRedCourt.AddRedCourtTalents(bros[2]);
		///---
		bros[3].setStartValuesEx([ // 4
			"hemovore_LOW_background"
		]);
		bros[3].getSkills().add(this.new("scripts/skills/traits/hemovore_trait")); //vampire racial stuff
		bros[3].getSkills().getAllSkillsOfType(this.Const.SkillType.Background)[0].m.RawDescription = "%name% - древний, невообразимо древний. То, как существу столь почтенного возраста удаётся сохранять ясный рассудок и волю, не скатываясь в безмолвный маразм Легиона, остаётся загадкой для большинства. На любые расспросы о причинах его долголетия лучший ответ, который вы от него дождётесь, звучит просто: \'Я сделал это ради неё\'. Кем бы ни была эта загадочная женщина, её тень до сих пор хранит его душу от полного угасания.";
 		bros[3].unlockPerk("perk.vampire_ancient_wisdom");
		bros[3].setPlaceInFormation(12);
        bros[3].m.PerkPoints = 1;
        bros[3].m.LevelUps = 2;
        bros[3].m.Level = 3;
        ::TheRedCourt.AddRedCourtTalents(bros[3]);

		//Starting stash
		this.World.Assets.m.Money = this.World.Assets.m.Money / 1;
		this.World.Assets.m.ArmorParts = this.World.Assets.m.ArmorParts / 1;
		this.World.Assets.m.Medicine = this.World.Assets.m.Medicine / 1;
		this.World.Assets.m.Ammo = this.World.Assets.m.Ammo / 1;
	}

	function onSpawnPlayer() // spawn player
	{
		local randomVillage;
		local northernmostY = 0;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = i )
		{
			local v = this.World.EntityManager.getSettlements()[i];

			if (v.getTile().SquareCoords.Y > northernmostY && !v.isMilitary() && !v.isIsolatedFromRoads() && v.getSize() <= 2)
			{
				northernmostY = v.getTile().SquareCoords.Y;
				randomVillage = v;
			}

			i = ++i;
		}

		randomVillage.setLastSpawnTimeToNow();
		local randomVillageTile = randomVillage.getTile();
		local navSettings = this.World.getNavigator().createSettings();
		navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;

		do
		{
			local x = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.X - 2), this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 2));
			local y = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.Y - 2), this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 2));

			if (!this.World.isValidTileSquare(x, y))
			{
			}
			else
			{
				local tile = this.World.getTileSquare(x, y);

				if (tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Shore || tile.IsOccupied)
				{
				}
				else if (tile.getDistanceTo(randomVillageTile) <= 1)
				{
				}
				else
				{
					local path = this.World.getNavigator().findPath(tile, randomVillageTile, navSettings, 0);

					if (!path.isEmpty())
					{
						randomVillageTile = tile;
						break;
					}
				}
			}
		}
		while (1);

		local attachedLocations = randomVillage.getAttachedLocations();
		local closest;
		local dist = 99999;
		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		this.World.State.m.Player.getSprite("body").setBrush("figure_vampire_01");
		this.World.State.m.Player.getSprite("body").setHorizontalFlipping(true); // Flip world map look
		this.World.State.m.Player.setSpriteOffset("body", this.createVec(4, 0)) // x axis, y axis. Postive values move left, negative values move right.
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList([ //Start music
				"music/undead_01.ogg"
			], this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.vampire_scenario_intro");
		}, null);
		::TheRedCourt.FemaleSpawn = true;

		foreach( a in attachedLocations )
		{
			if (a.getTile().getDistanceTo(randomVillageTile) < dist)
			{
				dist = a.getTile().getDistanceTo(randomVillageTile);
				closest = a;
			}
		}
	}

	function onInit() //Price changes
	{
		this.World.Assets.m.BuyPriceMult = 1.3; //+30%
		this.World.Assets.m.SellPriceMult = 0.7; //-30%
		this.World.Assets.m.BrothersMax = 25;
		this.World.Assets.m.BrothersMaxInCombat = 16;
	}

	///TEST
	function onHired( _bro )
	{
		if (_bro.getBackground().getID() == "background.hemovore_LOW" || _bro.getBackground().getID() == "background.hemovore_MED" || _bro.getBackground().getID() == "background.hemovore_HIGH" || _bro.getBackground().getID() == "background.hemovore_magic")
		{
			_bro.improveMood(2.0, "Новый рассвет настал!");
			_bro.getSkills().add(this.new("scripts/skills/traits/hemovore_trait"));
			_bro.getSprite("socket").setBrush("bust_base_undead");
		}
		else if (_bro.getBackground().getID() == "background.cultist" || _bro.getBackground().getID() == "background.hemovore_praetorian" || _bro.getBackground().getID() == "background.legend_legion_legionary" || _bro.getBackground().getID() == "background.legend_legion_gladiator_background")
		{
			_bro.improveMood(2.0, "Нашёл новое призвание...");
			_bro.getSprite("socket").setBrush("bust_base_undead");
		}
		else //everyone else
		{
			_bro.getSkills().add(this.new("scripts/skills/traits/glamoured_trait"));
			_bro.improveMood(3.0, "Не знаю, как это сказать - я чувствую себя великолепно!");
		}
	}

	function onUpdateHiringRoster( _roster )
	{
		local multiplier = _roster.getAll().len() < 8 ? 2 : 1; // Short little change to make these spawns less common in tiny villages

		if (::Math.rand(0, 4 * multiplier) == 0) {
			local bro = _roster.create("scripts/entity/tactical/player");
			bro.setStartValuesEx(["cultist_background"]);
		}
		if (::Math.rand(0, 15 * multiplier) == 0) {
			local bro = _roster.create("scripts/entity/tactical/player");
			bro.setStartValuesEx(["hemovore_LOW_background"]);
		    ::TheRedCourt.AddRedCourtTalents(bro);
		}
		if (::Math.rand(0, 20 * multiplier) == 0) {
			local bro = _roster.create("scripts/entity/tactical/player");
			bro.setStartValuesEx(["hemovore_MED_background"]);
            ::TheRedCourt.AddRedCourtTalents(bro);
		}
		if (::Math.rand(0, 30 * multiplier) == 0) {
			local bro = _roster.create("scripts/entity/tactical/player");
			bro.setStartValuesEx(["hemovore_HIGH_background"]);
		    ::TheRedCourt.AddRedCourtTalents(bro);
		}
	}

});

