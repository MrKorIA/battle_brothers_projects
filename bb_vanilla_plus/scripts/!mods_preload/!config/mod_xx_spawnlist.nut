::Const.World.Spawn.Troops.XXMobBoar <-
{
    ID = this.Const.EntityType.XXMobBoar,
    Variant = 0,
    Strength = 30,
    Cost = 30,
    Row = -1,
    Script = "scripts/entity/tactical/enemies/xxmob_boar",
    TitleList = null
}

::Const.World.Spawn.Troops.XXMobAnkheg <-
{
    ID = this.Const.EntityType.XXMobAnkheg,
    Variant = 0,
    Strength = 40,
    Cost = 40,
    Row = -1,
    Script = "scripts/entity/tactical/enemies/xxsum_venomorph",
    TitleList = null
}

::Const.World.Spawn.Troops.XXMobLion <-
{
    ID = this.Const.EntityType.XXMobLion,
    Variant = 0,
    Strength = 30,
    Cost = 30,
    Row = -1,
    Script = "scripts/entity/tactical/enemies/xxmob_lion",
    TitleList = null
}

::Const.World.Spawn.Troops.XXMobTiger <-
{
    ID = this.Const.EntityType.XXMobTiger,
    Variant = 0,
    Strength = 40,
    Cost = 40,
    Row = -1,
    Script = "scripts/entity/tactical/enemies/xxmob_liger",
    TitleList = null
}

::Const.World.Spawn.Troops.XXMobBear <-
{
    ID = this.Const.EntityType.XXMobBear,
    Variant = 0,
    Strength = 40,
    Cost = 40,
    Row = -1,
    Script = "scripts/entity/tactical/enemies/xxmob_bear",
    TitleList = null
}

::Const.World.Spawn.Troops.XXMobBloodsucker <-
{
    ID = this.Const.EntityType.XXMobBloodsucker,
    Variant = 0,
    Strength = 25,
    Cost = 25,
    Row = -1,
    Script = "scripts/entity/tactical/enemies/xxmob_bloodsucker",
    TitleList = null
}

::Const.World.Spawn.Troops.XXMobToad <-
{
    ID = this.Const.EntityType.XXMobToad,
    Variant = 0,
    Strength = 35,
    Cost = 35,
    Row = -1,
    Script = "scripts/entity/tactical/enemies/xxmob_toad",
    TitleList = null
}

::Const.World.Spawn.Troops.XXMobWhiteWolf <-
{
    ID = this.Const.EntityType.XXMobWhiteWolf,
    Variant = 0,
    Strength = 30,
    Cost = 30,
    Row = -1,
    Script = "scripts/entity/tactical/enemies/xxmob_whitewolf",
    TitleList = null
}

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

local function buildLinearSpawnArray( _troopType, _figureBody, _minCount, _maxCount )
{
    local resultArray = [];

    for (local i = _minCount; i <= _maxCount; i = ++i)
    {
        resultArray.push({
            Body = _figureBody,
            Troops = [
                {
                    Type = _troopType,
                    Num = i
                }
            ]
        });
    }
    this.calculateCosts(resultArray);
    return resultArray;
};

::Const.World.Spawn.XXMobBoar <- buildLinearSpawnArray(
    this.Const.World.Spawn.Troops.XXMobBoar,
    "figure_boar",
    1,
    15
);

::Const.World.Spawn.XXMobAnkheg <- buildLinearSpawnArray(
    this.Const.World.Spawn.Troops.XXMobAnkheg,
    "figure_ankheg",
    1,
    10
);

::Const.World.Spawn.XXMobLion <- buildLinearSpawnArray(
    this.Const.World.Spawn.Troops.XXMobLion,
    "figure_lion",
    1,
    17
);

::Const.World.Spawn.XXMobTiger <- buildLinearSpawnArray(
    this.Const.World.Spawn.Troops.XXMobTiger,
    "figure_tiger",
    1,
    15
);

::Const.World.Spawn.XXMobBear <- buildLinearSpawnArray(
    this.Const.World.Spawn.Troops.XXMobBear,
    "figure_bear",
    1,
    12
);

::Const.World.Spawn.XXMobBloodsucker <- buildLinearSpawnArray(
    this.Const.World.Spawn.Troops.XXMobBloodsucker,
    "figure_bloodsucker",
    2,
    20
);

::Const.World.Spawn.XXMobToad <- buildLinearSpawnArray(
    this.Const.World.Spawn.Troops.XXMobToad,
    "figure_toad",
    1,
    12
);

::Const.World.Spawn.XXMobWhiteWolf <- buildLinearSpawnArray(
    this.Const.World.Spawn.Troops.XXMobWhiteWolf,
    "figure_white_wolf",
    1,
    17
);

