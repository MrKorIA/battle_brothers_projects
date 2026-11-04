local function addEntityType(_id, _name, _namePlural, _icon)
{
	if (!("EntityTypeMax" in ::Const))
	{
		local max = 0;
		foreach(key, value in ::Const.EntityType)
		{
			if (typeof value == "integer" && value > max) max = value;
		}
		::Const.EntityTypeMax <- max;
	}
	::Const.EntityType[_id] <- ++::Const.EntityTypeMax;
	::Const.Strings.EntityName.push(_name);
	::Const.Strings.EntityNamePlural.push(_namePlural);
	::Const.EntityIcon.push(_icon);
}

addEntityType("LegendMummyLight", "Забальзамированный раб", "забальзамированных рабов", "mummy_light_orientation");
addEntityType("LegendMummyMedium", "Забальзамированный воин", "забальзамированных воинов", "mummy_medium_orientation");
addEntityType("LegendMummyHeavy", "Забальзамированный аристократ", "забальзамированных аристократов", "mummy_heavy_orientation");
addEntityType("LegendMummyQueen", "Забальзамированная царица", "забальзамированных цариц", "mummy_queen_orientation");
addEntityType("LegendMummyPriest", "Забальзамированный жрец", "забальзамированных жрецов", "mummy_priest_orientation");

::Const.Tactical.Actor.LegendMummyLight <- {
	XP = 200,
	ActionPoints = 9,
	Hitpoints = 90,
	Bravery = 60,
	Stamina = 100,
	MeleeSkill = 55,
	RangedSkill = 55,
	MeleeDefense = 10,
	RangedDefense = 5,
	Initiative = 65,
	FatigueEffectMult = 0.0,
	MoraleEffectMult = 0.0,
	Armor = [
		20,
		20
	]
};
::Const.Tactical.Actor.LegendMummyMedium <- {
	XP = 350,
	ActionPoints = 9,
	Hitpoints = 110,
	Bravery = 80,
	Stamina = 100,
	MeleeSkill = 65,
	RangedSkill = 0,
	MeleeDefense = 20,
	RangedDefense = 10,
	Initiative = 65,
	FatigueEffectMult = 0.0,
	MoraleEffectMult = 0.0,
	Armor = [
		30,
		30
	]
};
::Const.Tactical.Actor.LegendMummyHeavy <- {
	XP = 500,
	ActionPoints = 9,
	Hitpoints = 120,
	Bravery = 100,
	Stamina = 100,
	MeleeSkill = 75,
	RangedSkill = 0,
	MeleeDefense = 40,
	RangedDefense = 20,
	Initiative = 70,
	FatigueEffectMult = 0.0,
	MoraleEffectMult = 0.0,
	Armor = [
		75,
		75
	]
};
::Const.Tactical.Actor.LegendMummyQueen <- {
	XP = 1500,
	ActionPoints = 9,
	Hitpoints = 200,
	Bravery = 130,
	Stamina = 100,
	MeleeSkill = 90,
	RangedSkill = 0,
	MeleeDefense = 40,
	RangedDefense = 20,
	Initiative = 90,
	FatigueEffectMult = 0.0,
	MoraleEffectMult = 0.0,
	Armor = [
		40,
		40
	],
	DamageTotalMult = 1.35
};

::Const.Tactical.Actor.LegendMummyPriest <- {
	XP = 475,
	ActionPoints = 9,
	Hitpoints = 85,
	Bravery = 100,
	Stamina = 100,
	MeleeSkill = 75,
	RangedSkill = 0,
	MeleeDefense = 25,
	RangedDefense = 10,
	Initiative = 85,
	FatigueEffectMult = 0.0,
	MoraleEffectMult = 0.0,
	Armor = [
		50,
		50
	]
};

::Const.Tactical.Actor.LegendZombieLight <- {
	XP = 100,
	ActionPoints = 6,
	Hitpoints = 100,
	Bravery = 100,
	Stamina = 100,
	MeleeSkill = 55,
	RangedSkill = 5,
	MeleeDefense = 5,
	RangedDefense = 5,
	Initiative = 45,
	FatigueEffectMult = 0.0,
	MoraleEffectMult = 0.0,
	Armor = [
		0,
		0
	]
};

::Const.Tactical.Actor.LegendZombieMedium <- {
	XP = 150,
	ActionPoints = 8,
	Hitpoints = 130,
	Bravery = 100,
	Stamina = 100,
	MeleeSkill = 65,
	RangedSkill = 0,
	MeleeDefense = 10,
	RangedDefense = 10,
	Initiative = 65,
	FatigueEffectMult = 0.0,
	MoraleEffectMult = 0.0,
	Armor = [
		0,
		0
	]
};

::Const.Tactical.Actor.LegendZombieHeavy <- {
	XP = 250,
	ActionPoints = 9,
	Hitpoints = 180,
	Bravery = 100,
	Stamina = 100,
	MeleeSkill = 75,
	RangedSkill = 0,
	MeleeDefense = 5,
	RangedDefense = 15,
	Initiative = 60,
	FatigueEffectMult = 0.0,
	MoraleEffectMult = 0.0,
	Armor = [
		0,
		0
	]
};

::Const.World.Spawn.Troops.LegendMummyLight <- {
	ID = this.Const.EntityType.LegendMummyLight,
	Variant = 0,
	Strength = 21,
	Cost = 21,
	Row = 0,
	Script = "scripts/entity/tactical/enemies/legend_mummy_light"
};

::Const.World.Spawn.Troops.LegendMummyMedium <- {
	ID = this.Const.EntityType.LegendMummyMedium,
	Variant = 0,
	Strength = 30,
	Cost = 30,
	Row = 0,
	Script = "scripts/entity/tactical/enemies/legend_mummy_medium"
};

::Const.World.Spawn.Troops.LegendMummyHeavy <- {
	ID = this.Const.EntityType.LegendMummyHeavy,
	Variant = 1,
	Strength = 45,
	Cost = 45,
	Row = 0,
	Script = "scripts/entity/tactical/enemies/legend_mummy_heavy",
	NameList = this.Const.Strings.AncientSouthernNames,
	TitleList = null
};

::Const.World.Spawn.Troops.LegendMummyQueen <- {
	ID = this.Const.EntityType.LegendMummyQueen,
	Variant = 1,
	Strength = 90,
	Cost = 90,
	Row = 2,
	NameList = this.Const.Strings.SouthernFemaleNames,
	TitleList = this.Const.Strings.FallenHeroTitles,
	Script = "scripts/entity/tactical/enemies/legend_mummy_queen"
};

::Const.World.Spawn.Troops.LegendMummyPriest <- {
	ID = this.Const.EntityType.LegendMummyPriest,
	Variant = 0,
	Strength = 40,
	Cost = 40,
	Row = 2,
	Script = "scripts/entity/tactical/enemies/legend_mummy_priest"
};

local function onCostCompare( _t1, _t2 )
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

local function calculateCosts( _p )
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

	_p.sort(onCostCompare);
}

local function buildLegendSpawnArray( _cfg )
{
	local result = [];

	for (local budget = _cfg.MinR; budget <= _cfg.MaxR; budget += _cfg.Step)
	{
		local troops = [];
		local counts = {};
		local accum = {};

		foreach (u in _cfg.Units)
		{
			counts[u.Type.ID] <- 0;
			accum[u.Type.ID] <- 0;
		}

		local spent = 0;

		while (true)
		{
			local remaining = budget - spent;

			local bestUnit = null;
			local bestScore = -1000000;

			foreach (u in _cfg.Units)
			{
				if (u.Type.Cost > remaining)
					continue;

				if ("MinR" in u && budget < u.MinR)
					continue;

				if ("MaxR" in u && budget > u.MaxR)
					continue;

				if ("MaxCount" in u && counts[u.Type.ID] >= u.MaxCount)
					continue;

				accum[u.Type.ID] += u.Weight;

				if (accum[u.Type.ID] > bestScore)
				{
					bestScore = accum[u.Type.ID];
					bestUnit = u;
				}
			}

			if (bestUnit == null)
				break;

			local totalWeight = 0;

			foreach (u in _cfg.Units)
			{
				if (u.Type.Cost > remaining)
					continue;

				if ("MinR" in u && budget < u.MinR)
					continue;

				if ("MaxR" in u && budget > u.MaxR)
					continue;

				if ("MaxCount" in u && counts[u.Type.ID] >= u.MaxCount)
					continue;

				totalWeight += u.Weight;
			}

			accum[bestUnit.Type.ID] -= totalWeight;

			local found = false;

			foreach (t in troops)
			{
				if (t.Type == bestUnit.Type)
				{
					t.Num++;
					found = true;
					break;
				}
			}

			if (!found)
			{
				troops.push({
					Type = bestUnit.Type,
					Num = 1
				});
			}

			counts[bestUnit.Type.ID]++;

			spent += bestUnit.Type.Cost;

			if (budget - spent < _cfg.Reserve)
				break;
		}

		result.push({
			Body = _cfg.Body,
			Troops = troops
		});
	}

	calculateCosts(result);

	return result;
}

::Const.World.Spawn.Mummies <- buildLegendSpawnArray({
	MinR = 108,
	MaxR = 521,
	Step = 24,
	Reserve = 15,

	Body = "figure_mummy_01",

	Units = [
		{
			Type = this.Const.World.Spawn.Troops.LegendMummyLight,
			Weight = 100,
			MinR = 0
		},
		{
			Type = this.Const.World.Spawn.Troops.LegendMummyMedium,
			Weight = 45,
			MinR = 180
		},
		{
			Type = this.Const.World.Spawn.Troops.LegendMummyHeavy,
			Weight = 20,
			MinR = 320
		},
		{
			Type = this.Const.World.Spawn.Troops.LegendMummyPriest,
			Weight = 3,
			MinR = 420,
			MaxCount = 1
		},
		{
			Type = this.Const.World.Spawn.Troops.LegendMummyQueen,
			Weight = 1,
			MinR = 500,
			MaxCount = 1
		}
	]
});

::Const.World.Spawn.MummiesPatrol <- buildLegendSpawnArray({
	MinR = 100,
	MaxR = 650,
	Step = 24,
	Reserve = 15,

	Body = "figure_mummy_01",

	Units = [
		{
			Type = this.Const.World.Spawn.Troops.LegendMummyLight,
			Weight = 100,
			MinR = 0
		},
		{
			Type = this.Const.World.Spawn.Troops.LegendMummyMedium,
			Weight = 45,
			MinR = 200
		},
		{
			Type = this.Const.World.Spawn.Troops.LegendMummyHeavy,
			Weight = 20,
			MinR = 500
		},
		{
			Type = this.Const.World.Spawn.Troops.LegendMummyPriest,
			Weight = 10,
			MinR = 0,
			MaxCount = 1
		}
	]
});
