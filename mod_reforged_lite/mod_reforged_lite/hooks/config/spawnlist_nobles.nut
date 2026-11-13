// Защитник герольда (Royal Guard) в отрядах благородных домов — через .extend
// (существующие группы не перезаписываются), по аналогии с оригинальным блоком герольда.
local T = ::Const.World.Spawn.Troops;

local function makeParty( _troops )
{
	return {
		MovementSpeedMult = 1.0,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_noble_01",
		Troops = _troops
	};
}

::Const.World.Spawn.Noble.extend([
	makeParty([
		{ Type = T.RF_HeraldsBodyguard, Num = 1 },
		{ Type = T.StandardBearer, Num = 1 },
		{ Type = T.Footman, Num = 5 },
		{ Type = T.Sergeant, Num = 2 }
	]),
	makeParty([
		{ Type = T.RF_HeraldsBodyguard, Num = 2 },
		{ Type = T.StandardBearer, Num = 1 },
		{ Type = T.Knight, Num = 2 },
		{ Type = T.Greatsword, Num = 2 },
		{ Type = T.Footman, Num = 6 },
		{ Type = T.Arbalester, Num = 2 }
	]),
	makeParty([
		{ Type = T.RF_HeraldsBodyguard, Num = 2 },
		{ Type = T.StandardBearer, Num = 2 },
		{ Type = T.Knight, Num = 3 },
		{ Type = T.ManAtArms, Num = 4 },
		{ Type = T.Greatsword, Num = 3 },
		{ Type = T.Footman, Num = 8 },
		{ Type = T.Arbalester, Num = 3 }
	])
]);
