// Лёгкий генератор спавн-листов зверей скавенов.
// Паттерн взят из mod_xx_spawnlist.nut (bb_vanilla_plus):
// линейные пресеты от _minCount до _maxCount одного типа войск.

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

local function buildLinearSpawnArray( _troopType, _figureBody, _minCount, _maxCount, _movementSpeedMult = 1.0 )
{
	local resultArray = [];

	for (local i = _minCount; i <= _maxCount; i = ++i)
	{
		resultArray.push({
			Body = _figureBody,
			MovementSpeedMult = _movementSpeedMult,
			Troops = [
				{
					Type = _troopType,
					Num = i
				}
			]
		});
	}
	calculateCosts(resultArray);
	return resultArray;
};

::Const.World.Spawn.HellPit <- buildLinearSpawnArray(
	::Const.World.Spawn.Troops.HellPit,
	"figure_hellpit",
	1,
	10,
	0.75
);

::Const.World.Spawn.RatOrge <- buildLinearSpawnArray(
	::Const.World.Spawn.Troops.RatOrge,
	"figure_ratorge",
	1,
	12
);

::Const.World.Spawn.WolfRat <- buildLinearSpawnArray(
	::Const.World.Spawn.Troops.WolfRat,
	"figure_wolfrat",
	3,
	26
);
