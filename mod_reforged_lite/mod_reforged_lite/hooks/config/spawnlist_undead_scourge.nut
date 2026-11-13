// Орки-нежить в кризисе нежити (UndeadScourge) — только в партиях с некромантом, малая пропорция.
// Партии добавляются через .extend (существующие группы не перезаписываются).
local T = ::Const.World.Spawn.Troops;

local function makeParty( _troops )
{
	return {
		MovementSpeedMult = 0.9,
		VisibilityMult = 1.0,
		VisionMult = 1.0,
		Body = "figure_zombie_01",
		Troops = _troops
	};
}

::Const.World.Spawn.UndeadScourge.extend([
	makeParty([
		{ Type = T.Necromancer, Num = 1 },
		{ Type = T.ZombieYeomanBodyguard, Num = 1 },
		{ Type = T.RF_ZombieOrcYoung, Num = 2 },
		{ Type = T.Zombie, Num = 8 },
		{ Type = T.ZombieYeoman, Num = 4 }
	]),
	makeParty([
		{ Type = T.Necromancer, Num = 2 },
		{ Type = T.ZombieYeomanBodyguard, Num = 2 },
		{ Type = T.RF_ZombieOrcWarrior, Num = 2 },
		{ Type = T.RF_ZombieOrcYoung, Num = 2 },
		{ Type = T.Zombie, Num = 10 },
		{ Type = T.ZombieYeoman, Num = 6 }
	]),
	makeParty([
		{ Type = T.Necromancer, Num = 2 },
		{ Type = T.ZombieKnightBodyguard, Num = 2 },
		{ Type = T.RF_ZombieOrcWarrior, Num = 2 },
		{ Type = T.RF_ZombieOrcBerserker, Num = 2 },
		{ Type = T.ZombieYeoman, Num = 8 },
		{ Type = T.Zombie, Num = 12 }
	]),
	makeParty([
		{ Type = T.Necromancer, Num = 3 },
		{ Type = T.ZombieKnightBodyguard, Num = 3 },
		{ Type = T.RF_ZombieOrcWarlord, Num = 1 },
		{ Type = T.RF_ZombieOrcWarrior, Num = 3 },
		{ Type = T.RF_ZombieOrcBerserker, Num = 2 },
		{ Type = T.ZombieYeoman, Num = 10 },
		{ Type = T.Zombie, Num = 14 }
	]),
	// --- Элитные юниты Reforged (поздняя стадия кризиса) ---
	// Некрокультист-лорд с вампирами и скелетами
	makeParty([
		{ Type = T.RF_VampireLord, Num = 1 },
		{ Type = T.Vampire, Num = 2 },
		{ Type = T.SkeletonHeavy, Num = 4 },
		{ Type = T.SkeletonMedium, Num = 4 },
		{ Type = T.SkeletonLight, Num = 4 },
		{ Type = T.Necromancer, Num = 1 }
	]),
	makeParty([
		{ Type = T.RF_VampireLord, Num = 1 },
		{ Type = T.Vampire, Num = 3 },
		{ Type = T.SkeletonHeavy, Num = 6 },
		{ Type = T.SkeletonMedium, Num = 6 },
		{ Type = T.Necromancer, Num = 2 }
	]),
	// Скорбные матери (банши) с толпой зомби
	makeParty([
		{ Type = T.RF_Banshee, Num = 1 },
		{ Type = T.Zombie, Num = 12 },
		{ Type = T.ZombieYeoman, Num = 8 },
		{ Type = T.Necromancer, Num = 1 }
	]),
	makeParty([
		{ Type = T.RF_Banshee, Num = 2 },
		{ Type = T.Zombie, Num = 16 },
		{ Type = T.ZombieYeoman, Num = 10 },
		{ Type = T.ZombieKnight, Num = 2 },
		{ Type = T.Necromancer, Num = 2 }
	]),
	// Адские гончие в охотничьих стаях
	makeParty([
		{ Type = T.RF_Hollenhund, Num = 2 },
		{ Type = T.ZombieYeoman, Num = 6 },
		{ Type = T.Zombie, Num = 10 },
		{ Type = T.Necromancer, Num = 1 }
	]),
	makeParty([
		{ Type = T.RF_Hollenhund, Num = 3 },
		{ Type = T.RF_Banshee, Num = 1 },
		{ Type = T.Zombie, Num = 12 },
		{ Type = T.ZombieYeoman, Num = 8 },
		{ Type = T.Necromancer, Num = 2 }
	])
]);
