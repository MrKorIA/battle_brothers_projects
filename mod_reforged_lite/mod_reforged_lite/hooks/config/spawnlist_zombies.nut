// Орки-нежить в ванильных группах спавна — только в отрядах с некромантом, малая пропорция.
// Партии добавляются через .extend (существующие группы не перезаписываются).
local T = ::Const.World.Spawn.Troops;

local function makeParty( _troops )
{
	return {
		MovementSpeedMult = 0.8,
		VisibilityMult = 1.0,
		VisionMult = 0.8,
		Body = "figure_zombie_01",
		Troops = _troops
	};
}

// --- Группа Necromancer (некромант + бодигард + зомби): вариации с орками-нежитью ---
::Const.World.Spawn.Necromancer.extend([
	makeParty([
		{ Type = T.Necromancer, Num = 1 },
		{ Type = T.ZombieYeomanBodyguard, Num = 1 },
		{ Type = T.RF_ZombieOrcYoung, Num = 2 },
		{ Type = T.Zombie, Num = 6 }
	]),
	makeParty([
		{ Type = T.Necromancer, Num = 1 },
		{ Type = T.ZombieYeomanBodyguard, Num = 1 },
		{ Type = T.RF_ZombieOrcYoung, Num = 3 },
		{ Type = T.ZombieYeoman, Num = 3 },
		{ Type = T.Zombie, Num = 6 }
	]),
	makeParty([
		{ Type = T.Necromancer, Num = 1 },
		{ Type = T.ZombieKnightBodyguard, Num = 1 },
		{ Type = T.RF_ZombieOrcWarrior, Num = 1 },
		{ Type = T.RF_ZombieOrcYoung, Num = 2 },
		{ Type = T.ZombieYeoman, Num = 4 },
		{ Type = T.Zombie, Num = 7 }
	]),
	makeParty([
		{ Type = T.Necromancer, Num = 2 },
		{ Type = T.ZombieYeomanBodyguard, Num = 2 },
		{ Type = T.RF_ZombieOrcWarrior, Num = 2 },
		{ Type = T.RF_ZombieOrcBerserker, Num = 1 },
		{ Type = T.ZombieYeoman, Num = 5 },
		{ Type = T.Zombie, Num = 8 }
	]),
	makeParty([
		{ Type = T.Necromancer, Num = 2 },
		{ Type = T.ZombieKnightBodyguard, Num = 2 },
		{ Type = T.RF_ZombieOrcWarrior, Num = 2 },
		{ Type = T.RF_ZombieOrcBerserker, Num = 2 },
		{ Type = T.RF_ZombieOrcWarlord, Num = 1 },
		{ Type = T.ZombieYeoman, Num = 6 },
		{ Type = T.Zombie, Num = 10 }
	])
]);

// --- Группа NecromancerSouthern (южный вариант; ваниль использует тот же troop Necromancer + ZombieNomad) ---
::Const.World.Spawn.NecromancerSouthern.extend([
	makeParty([
		{ Type = T.Necromancer, Num = 1 },
		{ Type = T.ZombieNomad, Num = 3 },
		{ Type = T.RF_ZombieOrcYoung, Num = 2 }
	]),
	makeParty([
		{ Type = T.Necromancer, Num = 2 },
		{ Type = T.ZombieNomad, Num = 5 },
		{ Type = T.RF_ZombieOrcWarrior, Num = 2 },
		{ Type = T.RF_ZombieOrcYoung, Num = 2 }
	])
]);
