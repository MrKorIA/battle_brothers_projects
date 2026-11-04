::Const.World.Spawn.Troops.RF_DraugrThrall <-
{
	ID = this.Const.EntityType.RF_DraugrThrall,
	Variant = 0,
	Strength = 25,
	Cost = 18,
	Row = 0,
	Script = "scripts/entity/tactical/enemies/rf_draugr_thrall",
	TitleList = null
}
::Const.World.Spawn.Troops.RF_DraugrThrallBodyguard <-
{
	ID = this.Const.EntityType.RF_DraugrThrallBodyguard,
	Variant = 0,
	Strength = 25,
	Cost = 18,
	Row = 2,
	Script = "scripts/entity/tactical/enemies/rf_draugr_thrall_bodyguard",
	TitleList = null
}
::Const.World.Spawn.Troops.RF_DraugrWarrior <-
{
	ID = this.Const.EntityType.RF_DraugrWarrior,
	Variant = 0,
	Strength = 35,
	Cost = 35,
	Row = 0,
	Script = "scripts/entity/tactical/enemies/rf_draugr_warrior",
	TitleList = null
}
::Const.World.Spawn.Troops.RF_DraugrWarriorBodyguard <-
{
	ID = this.Const.EntityType.RF_DraugrWarriorBodyguard,
	Variant = 0,
	Strength = 35,
	Cost = 35,
	Row = 2,
	Script = "scripts/entity/tactical/enemies/rf_draugr_warrior_bodyguard",
	TitleList = null
}
::Const.World.Spawn.Troops.RF_DraugrHuskarl <-
{
	ID = this.Const.EntityType.RF_DraugrHuskarl,
	Variant = 0,
	Strength = 45,
	Cost = 45,
	Row = 1,
	Script = "scripts/entity/tactical/enemies/rf_draugr_huskarl",
	TitleList = null
}
::Const.World.Spawn.Troops.RF_DraugrHuskarlBodyguard <-
{
	ID = this.Const.EntityType.RF_DraugrHuskarlBodyguard,
	Variant = 0,
	Strength = 45,
	Cost = 45,
	Row = 1,
	Script = "scripts/entity/tactical/enemies/rf_draugr_huskarl_bodyguard",
	TitleList = null
}
::Const.World.Spawn.Troops.RF_DraugrHero <-
{
	ID = this.Const.EntityType.RF_DraugrHero,
	Variant = 1,
	Strength = 60,
	Cost = 60,
	Row = 1,
	Script = "scripts/entity/tactical/enemies/rf_draugr_hero",
    NameList = ::Const.Strings.RF_DraugrNames,
    TitleList = ::Const.Strings.RF_DraugrTitles
}
::Const.World.Spawn.Troops.RF_DraugrHeroChampion <-
{
	ID = this.Const.EntityType.RF_DraugrHeroChampion,
	Variant = 999,
	Strength = 60,
	Cost = 60,
	Row = 1,
	Script = "scripts/entity/tactical/enemies/rf_draugr_hero",
    NameList = ::Const.Strings.RF_DraugrNames,
    TitleList = ::Const.Strings.RF_DraugrTitles
}
::Const.World.Spawn.Troops.RF_DraugrShaman <-
{
	ID = this.Const.EntityType.RF_DraugrShaman,
	Variant = 0,
	Strength = 60,
	Cost = 60,
	Row = 2,
	Script = "scripts/entity/tactical/enemies/rf_draugr_shaman",
    TitleList = null
}

::Const.Tactical.Actor.RF_DraugrThrall <- {
    XP = 200,
    ActionPoints = 9,
    Hitpoints = 120,
    Bravery = 100,
    Stamina = 100,
    MeleeSkill = 65,
    RangedSkill = 0,
    MeleeDefense = 10,
    RangedDefense = 0,
    Initiative = 55,
    FatigueEffectMult = 0.0,
    MoraleEffectMult = 0.0,
    Armor = [
        0,
        0
    ]
};
::Const.Tactical.Actor.RF_DraugrThrallBodyguard <- {
    XP = 200,
    ActionPoints = 9,
    Hitpoints = 120,
    Bravery = 100,
    Stamina = 100,
    MeleeSkill = 65,
    RangedSkill = 0,
    MeleeDefense = 10,
    RangedDefense = 0,
    Initiative = 55,
    FatigueEffectMult = 0.0,
    MoraleEffectMult = 0.0,
    Armor = [
        0,
        0
    ]
};
::Const.Tactical.Actor.RF_DraugrWarrior <- {
    XP = 350,
    ActionPoints = 9,
    Hitpoints = 160,
    Bravery = 100,
    Stamina = 100,
    MeleeSkill = 75,
    RangedSkill = 0,
    MeleeDefense = 15,
    RangedDefense = 0,
    Initiative = 60,
    FatigueEffectMult = 0.0,
    MoraleEffectMult = 0.0,
    Armor = [
        0,
        0
    ]
};
::Const.Tactical.Actor.RF_DraugrWarriorBodyguard <- {
    XP = 350,
    ActionPoints = 9,
    Hitpoints = 160,
    Bravery = 100,
    Stamina = 100,
    MeleeSkill = 75,
    RangedSkill = 0,
    MeleeDefense = 15,
    RangedDefense = 0,
    Initiative = 60,
    FatigueEffectMult = 0.0,
    MoraleEffectMult = 0.0,
    Armor = [
        0,
        0
    ]
};
::Const.Tactical.Actor.RF_DraugrHuskarl <- {
    XP = 450,
    ActionPoints = 9,
    Hitpoints = 200,
    Bravery = 100,
    Stamina = 100,
    MeleeSkill = 85,
    RangedSkill = 0,
    MeleeDefense = 25,
    RangedDefense = 0,
    Initiative = 65,
    FatigueEffectMult = 0.0,
    MoraleEffectMult = 0.0,
    Armor = [
        0,
        0
    ]
};
::Const.Tactical.Actor.RF_DraugrHuskarlBodyguard <- {
    XP = 450,
    ActionPoints = 9,
    Hitpoints = 200,
    Bravery = 100,
    Stamina = 100,
    MeleeSkill = 85,
    RangedSkill = 0,
    MeleeDefense = 25,
    RangedDefense = 0,
    Initiative = 65,
    FatigueEffectMult = 0.0,
    MoraleEffectMult = 0.0,
    Armor = [
        0,
        0
    ]
};
::Const.Tactical.Actor.RF_DraugrHero <- {
    XP = 650,
    ActionPoints = 9,
    Hitpoints = 220,
    Bravery = 100,
    Stamina = 100,
    MeleeSkill = 95,
    RangedSkill = 0,
    MeleeDefense = 35,
    RangedDefense = 0,
    Initiative = 70,
    FatigueEffectMult = 0.0,
    MoraleEffectMult = 0.0,
    Armor = [
        0,
        0
    ]
};
::Const.Tactical.Actor.RF_DraugrHeroChampion <- {
    XP = 650,
    ActionPoints = 9,
    Hitpoints = 220,
    Bravery = 100,
    Stamina = 100,
    MeleeSkill = 95,
    RangedSkill = 0,
    MeleeDefense = 35,
    RangedDefense = 0,
    Initiative = 70,
    FatigueEffectMult = 0.0,
    MoraleEffectMult = 0.0,
    Armor = [
        0,
        0
    ]
};
::Const.Tactical.Actor.RF_DraugrShaman <- {
    XP = 500,
    ActionPoints = 9,
    Hitpoints = 150,
    Bravery = 100,
    Stamina = 100,
    MeleeSkill = 60,
    RangedSkill = 0,
    MeleeDefense = 10,
    RangedDefense = 20,
    Initiative = 75,
    FatigueEffectMult = 0.0,
    MoraleEffectMult = 0.0,
    Armor = [
        0,
        0
    ]
};


function onCostCompare( _t1, _t2 )
{
	if (_t1.Cost < _t2.Cost)
	{
		return -1;
	}
	else if (_t1.Cost > _t2.Cost)
	{
		return 1;
	}

	return 0;
}

function calculateCosts( _p )
{
	foreach( p in _p )
	{
		p.Cost <- 0;

		foreach( t in p.Troops )
		{
			p.Cost += t.Type.Cost * t.Num;
		}

		if (!("MovementSpeedMult" in p))
		{
			p.MovementSpeedMult <- 1.0;
		}

		if (!("VisibilityMult" in p))
		{
			p.VisibilityMult <- 1.0;
		}

		if (!("VisionMult" in p))
		{
			p.VisionMult <- 1.0;
		}
	}

	_p.sort(this.onCostCompare);
}

function buildDraugrSpawnArray( _cfg )
{
	local result = [];

	local T = this.Const.World.Spawn.Troops;

	for (local budget = 60; budget <= _cfg.MaxResources; budget += 10)
	{
		local troops = [];
		local spent = 0;

		local remain;
		local progress;

		local thrallWeight;
		local warriorWeight;
		local huskarlWeight;
		local weightSum;

		local thralls;
		local warriors;
		local huskarls;

		//-----------------------------------------------------
		// helper
		//-----------------------------------------------------

		local function addTroop( _type, _num )
		{
			if (_num <= 0)
				return;

			troops.push({
				Type = _type,
				Num = _num
			});

			spent += _type.Cost * _num;
		}

		//-----------------------------------------------------
		// mandatory units
		//-----------------------------------------------------

		if ("Champion" in _cfg)
			addTroop(T.RF_DraugrHeroChampion, _cfg.Champion);

		if ("Hero" in _cfg)
			addTroop(T.RF_DraugrHero, _cfg.Hero);

		if ("Huskarl" in _cfg)
			addTroop(T.RF_DraugrHuskarl, _cfg.Huskarl);

		if ("Shaman" in _cfg)
		{
			if (("AllowBodyguards" in _cfg) && budget >= 300)
			{
				addTroop(T.RF_DraugrShaman, _cfg.Shaman);

				local bgBudget = budget * 0.12;

				local bgWarriors = bgBudget / T.RF_DraugrWarriorBodyguard.Cost;
				bgWarriors = bgWarriors.tointeger();

				bgBudget -= bgWarriors * T.RF_DraugrWarriorBodyguard.Cost;

				local bgThralls = bgBudget / T.RF_DraugrThrallBodyguard.Cost;
				bgThralls = bgThralls.tointeger();

				addTroop(T.RF_DraugrWarriorBodyguard, bgWarriors);
				addTroop(T.RF_DraugrThrallBodyguard, bgThralls);
			}
			else
			{
				addTroop(T.RF_DraugrShaman, _cfg.Shaman);
			}
		}

		//-----------------------------------------------------
		// extras (Barrows)
		//-----------------------------------------------------

		if ("ExtraThralls" in _cfg)
			addTroop(T.RF_DraugrThrall, _cfg.ExtraThralls(budget));

		if ("ExtraWarriors" in _cfg && budget >= 150)
			addTroop(T.RF_DraugrWarrior, _cfg.ExtraWarriors(budget));

		//-----------------------------------------------------
		// remaining budget
		//-----------------------------------------------------

		remain = budget - spent;

		if (remain <= 0)
		{
			result.push({
				Body = "figure_bandit_01",
				Troops = troops
			});

			continue;
		}

		//-----------------------------------------------------
		// standard block
		//-----------------------------------------------------

		progress = (budget - 350).tofloat() / (990.0 - 350.0);

		if (progress < 0.0)
			progress = 0.0;

		if (progress > 1.0)
			progress = 1.0;

		// постепенно уменьшается
		thrallWeight = 0.60 - progress * 0.30;

		// почти постоянен
		warriorWeight = 0.40 + progress * 0.05;

		// постепенно появляется
		huskarlWeight = progress * 0.25;

		weightSum = thrallWeight + warriorWeight + huskarlWeight;

		thrallWeight /= weightSum;
		warriorWeight /= weightSum;
		huskarlWeight /= weightSum;

		thralls = ((remain * thrallWeight) / T.RF_DraugrThrall.Cost).tointeger();

        if (budget >= 150)
        {
            warriors = ((remain * warriorWeight) / T.RF_DraugrWarrior.Cost).tointeger();

            huskarls = ((remain * huskarlWeight) / T.RF_DraugrHuskarl.Cost).tointeger();
        }

		addTroop(T.RF_DraugrThrall, thralls);
		addTroop(T.RF_DraugrWarrior, warriors);
		addTroop(T.RF_DraugrHuskarl, huskarls);

		//-----------------------------------------------------
		// fill remaining budget greedily
		//-----------------------------------------------------

		remain = budget - spent;

		while (remain >= T.RF_DraugrThrall.Cost)
		{
			if (remain >= T.RF_DraugrHuskarl.Cost && progress > 0.60)
			{
				addTroop(T.RF_DraugrHuskarl, 1);
			}
			else if (remain >= T.RF_DraugrWarrior.Cost)
			{
				addTroop(T.RF_DraugrWarrior, 1);
			}
			else
			{
				addTroop(T.RF_DraugrThrall, 1);
			}

			remain = budget - spent;
		}

		result.push({
			Body = "figure_bandit_01",
			Troops = troops
		});
	}

	this.calculateCosts(result);

	return result;
}

::Const.World.Spawn.RF_DraugrBarrows <- buildDraugrSpawnArray({
    MaxResources = 600,
	Huskarl = 1,
	Shaman = 1,

	ExtraThralls = function( budget )
	{
		return ::Math.min(5, 1 + budget / 180);
	},

	ExtraWarriors = function( budget )
	{
		return ::Math.min(3, 1 + budget / 300);
	}
});

::Const.World.Spawn.RF_DraugrCrypt <- buildDraugrSpawnArray({
	MaxResources = 900,
	Shaman = 1,
	Hero = 1
});

::Const.World.Spawn.RF_DraugrFane <- buildDraugrSpawnArray({
	MaxResources = 900,
	Shaman = 1,
	Champion = 1,
    AllowBodyguards = true
});

::Const.Injury.DraugrExcludedInjuries <- [
    // Blunt
    "injury.rf_black_eye",
    "injury.broken_nose",
    "injury.broken_ribs",
    "injury.bruised_leg",
    "injury.crushed_windpipe",
    "injury.fractured_ribs",
    "injury.severe_concussion",
    // Burning
    "injury.rf_heat_stroke",
    "injury.inhaled_flames",
    // Cutting
    "injury.cut_artery",
    "injury.cut_throat",
    "injury.exposed_ribs",
    "injury.grazed_neck",
    "injury.ripped_ear",
    "injury.split_nose",
    // Piercing
    "injury.grazed_kidney",
    "injury.pierced_cheek",
    "injury.pierced_lung",
    "injury.pierced_side"
];