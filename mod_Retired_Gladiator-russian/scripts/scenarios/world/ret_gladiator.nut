this.ret_gladiator <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.ret_gladiator";
		this.m.Name = "Отставной гладиатор";
		this.m.Description = "[p=c][img]gfx/ui/events/event_163.png[/img][/p][p]Возьмите на себя роль могучего воина, желающего вернуть себе славу, но не имеющего ни гроша.\n\n[color=#bcad8c]Кровь и песок[/color]: Начните игру со стареющим гладиатором. Если он умрёт, то кампания закончится.\n[color=#bcad8c]Связанные тяготами[/color]: Получите способность превращать непрощённых в гладиаторов и смирять сильнейших гладиаторов с помощью особых событий.\n[color=#bcad8c]Путь Златоликого[/color]: Южане получают преимущества, путешествуя с вами и используя южное оружие. Снижена стоимость найма и содержания южан на 25%. Северяне обходятся на 25% дороже в найме и содержании.\n[color=#bcad8c]Грязная борьба[/color]: Все новобранцы получают способность 'Грязь в глаза'[/p].";
		this.m.Difficulty = 3;
		this.m.Order = 102;
		this.m.IsFixedLook = true;
//		this.m.StartingRosterTier = this.Const.Roster.getTierForSize(1);
		// this.m.RosterTierMax = this.Const.Roster.getTierForSize(16);
//		this.m.StartingBusinessReputation = 100;
//		this.setRosterReputationTiers(this.Const.Roster.createReputationTiers(this.m.StartingBusinessReputation));
	}

	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();
		local names = [];

		for( local i = 0; i < 1; i = i )
		{
			local bro;
			bro = roster.create("scripts/entity/tactical/player");
//			bro.getSkills().add(this.new("scripts/skills/perks/perk_legend_throw_sand"));
		    bro.getSkills().add(this.new("scripts/skills/perks/perk_legend_throw_sand"));
			bro.m.HireTime = this.Time.getVirtualTimeF();
			bro.getSkills().add(this.new("scripts/skills/traits/player_character_trait"));
			bro.getFlags().set("IsPlayerCharacter", true);
 			bro.getSprite("socket").setBrush("bust_base_nomads");
			bro.getSprite("miniboss").setBrush("bust_miniboss_gladiators");

			while (names.find(bro.getNameOnly()) != null)
			{
				bro.setName(this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
			}

			names.push(bro.getNameOnly());
			i = ++i;
		}

		local bros = roster.getAll();

		//--- My Boy
		bros[0].setStartValuesEx([
			"retired_gladiator_background"
		]);
		bros[0].getSkills().getAllSkillsOfType(this.Const.SkillType.Background)[0].m.RawDescription = "Приятно снова оказаться под открытым небом - пусть вы уже не тот первоклассный боец, каким были раньше, но вы всё ещё можете поставить на место любого меченосца, будь то в канаве, в пустыне или на виду у беснующейся толпы.";
		bros[0].setPlaceInFormation(4);
//		bros[0].setVeteranPerks(2);
//		bros[0].getSkills().add(this.new("scripts/skills/perks/perk_legend_mastery_nets"));
//		bros[0].getSkills().add(this.new("scripts/skills/perks/perk_legend_net_repair"));
		bros[0].getSkills().add(this.new("scripts/skills/perks/perk_retglad_path"));
		bros[0].m.PerkPointsSpent += 1;
//        bros[0].m.PerkPoints = 1;
		//rep, money and stash
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/dried_lamb_item"));
		this.World.Assets.m.Money = this.World.Assets.m.Money * 0.0;
		//this.World.Assets.getStash().resize(18);
	}

	function onSpawnPlayer() //spawn outside arena in the south
	{
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = ++i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (!randomVillage.isIsolatedFromRoads() && randomVillage.isSouthern() && randomVillage.hasBuilding("building.arena"))
			{
				break;
			}
		}

		local randomVillageTile = randomVillage.getTile();

		do
		{
			local x = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.X - 1), this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 1));
			local y = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.Y - 1), this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 1));

			if (!this.World.isValidTileSquare(x, y))
			{
			}
			else
			{
				local tile = this.World.getTileSquare(x, y);

				if (tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Shore)
				{
				}
				else if (tile.getDistanceTo(randomVillageTile) == 0)
				{
				}
				else if (!tile.HasRoad)
				{
				}
				else
				{
					randomVillageTile = tile;
					break;
				}
			}
		}
		while (1);

		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		this.World.Assets.updateLook(16);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList([
				"music/worldmap_11.ogg"
			], this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.legend_ret_gladiator_intro");
		}, null);
	}
		///--- Pocket sand my beloved
	function onHired( bro )
	{
		bro.improveMood(0.3, "Готов к грязной борьбе!");
        bro.getSkills().add(this.new("scripts/skills/perks/perk_legend_throw_sand"));
//		this.m.Skills.add(this.new("scripts/skills/actives/throw_dirt_skill"));
//		bro.getSkills().add(this.new("scripts/skills/actives/throw_dirt_skill"));
//        if (!bro.getSkills().hasSkill("actives.throw_dirt"))
//        {
//        }
//		bro.getSkills().add(this.new("scripts/skills/perks/perk_legend_throw_sand"));
 		bro.getSprite("socket").setBrush("bust_base_nomads");
 		onGenerateBro(bro);
	}

//Ethnicity table for 17.0.0+ (poss my beloved)
	// 1 = southwest
	// 2 = west
	// 3 = northwest
	// 4 = south
	// 5 = centre
	// 6 = north
	// 7 = southeast
	// 8 = east
	// 9 = northeast

			///--- Знаю, я закодировал расизм.
	function onGenerateBro(bro)
	{
	    if (bro.getEthnicity() == 1 || bro.getEthnicity() == 4 || bro.getEthnicity() == 7 || bro.getEthnicity() == 8)
	    {
			bro.m.HiringCost = this.Math.floor(bro.m.HiringCost * 0.75) //1.0 = default
			bro.getBaseProperties().DailyWageMult *= 0.75; //1.0 = default
			bro.getSkills().add(this.new("scripts/skills/perks/perk_retglad_path"));
//			bro.getSkills().update();
	    }
	    else if (bro.getBackground().getID() == "background.legend_muladi" || bro.getBackground().getID() == "background.gladiator" || bro.getBackground().getID() == "background.beastslayer_gladiator" || bro.getBackground().getID() == "background.slave" || bro.getBackground().getID() == "background.legend_qiyan" || bro.getBackground().getID() == "background.pit_fighter")
	    {
			bro.m.HiringCost = this.Math.floor(bro.m.HiringCost * 0.75) //1.0 = default
			bro.getBaseProperties().DailyWageMult *= 0.75; //1.0 = default
			bro.getSkills().add(this.new("scripts/skills/perks/perk_retglad_path"));
//			bro.getSkills().update();
	    }
	    else //(bro.getEthnicity() == 0)
	    {
			bro.m.HiringCost = this.Math.floor(bro.m.HiringCost * 1.25) //1.0 = default
			bro.getBaseProperties().DailyWageMult *= 1.25; //1.0 = default
//			bro.getSkills().update();
	    }
	}

//function onBuildPerkTree( _background ) //throw sand assignment
//    {
//    	if (_background.m.CustomPerkTree == null)
//    	{
//			return;
//    	}
//
//    	_background.m.CustomPerkTree[0].push(this.Const.Perks.PerkDefs.LegendThrowSand);
//	}

	function onInit()
	{
		this.starting_scenario.onInit();
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
});

