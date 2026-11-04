this.hemovores_avatar_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.hemovores_avatar";
		this.m.Name = "Первородная кровь"; //contains avatar
		this.m.Description = "[p=c][img]gfx/ui/events/event_101.png[/img][/p][p]Вы уже прожили тысячу жизней, но те, кому повезло меньше, чем вам, нуждаются в вашем исправлении. \n[color=#bcad8c]Высокие ставки:[/color] Начните могущественным древним некросавантом, ненадёжным слугой и тремя неудачливыми наёмниками. Цены покупки и продажи хуже на 30%. \n[color=#bcad8c]Контроль сознания:[/color] Вы достаточно сильны, чтобы скрыть себя и свой род от глаз смертных. Любой смертный, присоединившийся к вам, готов умереть за вас - но если вы умрёте, ваш контроль над их разумом спадёт, и всё закончится.[/p]";
		this.m.Difficulty = 2;
		this.m.Order = 50;
		this.m.IsFixedLook = true;
	}

    function isValid()
    {
        return true;
    }

	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();
		local names = [];
		::TheRedCourt.FemaleSpawn = false;

		for( local i = 0; i < 5; i = ++i ) //5 starters
		{
			local bro;
			bro = roster.create("scripts/entity/tactical/player");
			///---
			bro.m.HireTime = this.Time.getVirtualTimeF();

			while (names.find(bro.getNameOnly()) != null)
			{
				bro.setName(this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
			}

			names.push(bro.getNameOnly());
		}

		local bros = roster.getAll(); //-
		///---
		bros[0].setStartValuesEx([ // 1
			"manhunter_background",
			"nomad_background",
			"slave_background",
			"tailor_background",
			"daytaler_background",
			"gravedigger_background",
			"graverobber_background",
			"apprentice_background"
		]);
		bros[0].getSkills().add(this.new("scripts/skills/traits/enthralled_trait")); //merc
		bros[0].getSkills().getAllSkillsOfType(this.Const.SkillType.Background)[0].m.RawDescription = "Даже в свои лучшие времена %name% едва ли мог называться бойцом - его жалкое поведение во время вашей первой встречи убедило вас в этом. При должной дозе \'храбрости\' из него мог бы выйти сносный боец... или сносное отвлечение.";
		bros[0].setPlaceInFormation(3);
        bros[0].m.PerkPoints = 2;
        bros[0].m.LevelUps = 2;
        bros[0].m.Level = 3;
		///---
		bros[1].setStartValuesEx([ // 2
			"disowned_noble_background",
			"adventurous_noble_background",
			"retired_soldier_background",
			"swordmaster_background",
			"sellsword_background",
			"militia_background",
			"bastard_background",
			"hunter_background",
			"beast_hunter_background",
			"raider_background"
		]);
		bros[1].getSkills().add(this.new("scripts/skills/traits/enthralled_trait")); //merc
		bros[1].getSkills().getAllSkillsOfType(this.Const.SkillType.Background)[0].m.RawDescription = "%name% был одним из самых сложных новобранцев в вашей коллекции, он яростно проклинал всё на свете, пока вы не заглянули в самые потаённые уголки его сознания. Там вы нащупали то, от чего этот смертный просто не смог отказаться.";
		bros[1].setPlaceInFormation(4);
        bros[1].m.PerkPoints = 2;
        bros[1].m.LevelUps = 2;
        bros[1].m.Level = 3;
		///---
		bros[2].setStartValuesEx([ //3
			"butcher_background",
			"hedge_knight_background",
			"hunter_background",
			"sellsword_background",
			"militia_background",
			"bastard_background",
			"poacher_background",
			"retired_soldier_background"
		]);
		bros[2].getSkills().add(this.new("scripts/skills/traits/enthralled_trait")); //merc
		bros[2].getSkills().getAllSkillsOfType(this.Const.SkillType.Background)[0].m.RawDescription = "На поле боя он выделялся недюжинной силой, но гибель командира заставила его в числе первых пойти на сделку с вами, к полному ужасу бывших товарищей. Поначалу вы обсуждали золото, затем тонкие вина, а после разговор зашёл о женщинах. Об одной конкретной женщине. Вы вполне намерены сдержать своё слово, но сильно сомневаетесь, что %name% останется доволен тем, насколько буквально вы собираетесь выполнить условия вашего уговора.";
		bros[2].setPlaceInFormation(5);
        bros[2].m.PerkPoints = 2;
        bros[2].m.LevelUps = 2;
        bros[2].m.Level = 3;
		///---
		bros[3].setStartValuesEx([ // 4
			"hemovore_MED_background"
		]);
		bros[3].getSkills().add(this.new("scripts/skills/traits/hemovore_trait")); //vampire racial stuff
 		bros[3].getSprite("socket").setBrush("bust_base_undead");
		bros[3].getSkills().getAllSkillsOfType(this.Const.SkillType.Background)[0].m.RawDescription = "%name% уже некоторое время служит вам, когда-то давно будучи рабом вашей семьи, он поднялся по иерархии как в статусе, так и в мастерстве. Остаётся только вопрос, превзойдут ли его амбиции нынешнюю верность вам.";
        bros[3].unlockPerk("perk.vampire_ancient_wisdom");
		bros[3].setPlaceInFormation(12);
        bros[3].m.LevelUps = 1;
        bros[3].m.PerkPoints = 0;
        bros[3].m.Level = 2;
		::TheRedCourt.AddRedCourtTalents(bros[3]);
		///---
		bros[4].setStartValuesEx([ // 5
			"hemovore_avatar_background"
		]);
		bros[4].getSkills().add(this.new("scripts/skills/traits/hemovore_trait")); //vampire racial stuff
 		bros[4].getSprite("socket").setBrush("bust_base_undead");
 		bros[4].getSprite("miniboss").setBrush("bust_miniboss_undead"); //AVATAR
 		bros[4].getFlags().set("IsPlayerCharacter", true); //AVATAR
 		bros[4].getSkills().add(this.new("scripts/skills/traits/player_character_trait")); //AVATAR
        bros[4].unlockPerk("perk.vampire_ancient_wisdom");
        bros[4].unlockPerk("perk.vampire_darkflight");
		bros[4].setPlaceInFormation(13);
		::TheRedCourt.AddRedCourtTalents(bros[4]);

		//Starting stash & mortality
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/cured_rations_item"));
		this.World.Assets.m.Money = this.World.Assets.m.Money * 1;
		this.World.Assets.m.ArmorParts = this.World.Assets.m.ArmorParts * 1;
		this.World.Assets.m.Medicine = this.World.Assets.m.Medicine / 1;
		this.World.Assets.m.Ammo = this.World.Assets.m.Ammo / 1;
		this.World.Assets.addMoralReputation(-30.0);
	}

	function onSpawnPlayer() // spawn player
	{

		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = ++i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (!randomVillage.isMilitary() && !randomVillage.isIsolatedFromRoads() && randomVillage.getSize() >= 3 && !randomVillage.isSouthern())
			{
				break;
			}
		}

		local randomVillageTile = randomVillage.getTile();
		local navSettings = this.World.getNavigator().createSettings();
		navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;

		do
		{
			local x = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.X - 4), this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 4));
			local y = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.Y - 4), this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 4));

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

		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		this.World.State.m.Player.getSprite("body").setBrush("figure_vampire_02");
		this.World.State.m.Player.getSprite("body").setHorizontalFlipping(true); // Flip world map look
		this.World.State.m.Player.setSpriteOffset("body", this.createVec(4, 0)) // x axis, y axis. Postive values move left, negative values move right.
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList([ //Start music
				"music/undead_01.ogg"
			], this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.vampire_avatar_scenario_intro"); 
		}, null);
		::TheRedCourt.FemaleSpawn = true;

	}

	function onInit() //Price changes
	{
		this.World.Assets.m.BuyPriceMult = 1.3; //+30%
		this.World.Assets.m.SellPriceMult = 0.7; //-30%
		this.World.Assets.m.BrothersMax = 25;
		this.World.Assets.m.BrothersMaxInCombat = 16;
	}

	function onCombatFinished()
	{
		local roster = this.World.getPlayerRoster().getAll();

		foreach( bro in roster )
		{
			if (bro.getFlags().get("IsPlayerCharacter"))
			{
				return true;
			}
		}

		return false;
	}

	function onHired( _bro )
	{
//		if (_bro.getBackground().getID() != "background.slave")
//		{
//			_bro.getSkills().add(this.new("scripts/skills/actives/whip_slave_skill"));
//		}
//		else
//		{
//			_bro.getSprite("miniboss").setBrush("bust_miniboss_indebted");
//		}
		if (_bro.getBackground().getID() == "background.hemovore_LOW" || _bro.getBackground().getID() == "background.hemovore_MED" || _bro.getBackground().getID() == "background.hemovore_HIGH" || _bro.getBackground().getID() == "background.hemovore_magic")
		{
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
			_bro.getSkills().add(this.new("scripts/skills/traits/enthralled_trait"));
			_bro.improveMood(3.0, "Всё, что я хочу, может быть моим... и даже больше!");
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