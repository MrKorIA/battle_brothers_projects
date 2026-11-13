// Хуки конфигов и игровых систем
::includeFiles(::IO.enumerateFiles("mod_reforged_lite/hooks"));

// Хелперы вложенных тултипов и словарь концепций мода (зависимость: mod_nested_tooltips)
::include("mod_reforged_lite/tooltips/nested_helpers");
::include("mod_reforged_lite/tooltips/concepts");

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

// Пересчёт Cost спавн-групп, затронутых модом (через .extend после ванильного calculateCosts —
// ванильный спавнер требует party.Cost; идемпотентно, срабатывает после хуков всех модов)
::MSU.QueueBucket.VeryLate.push(function() {
	foreach (group in [
//		::Const.World.Spawn.RF_DraugrBarrows,
//		::Const.World.Spawn.RF_DraugrCrypt,
//		::Const.World.Spawn.RF_DraugrFane,
		::Const.World.Spawn.Noble,
		::Const.World.Spawn.UndeadScourge,
		::Const.World.Spawn.Necromancer,
		::Const.World.Spawn.NecromancerSouthern
	])
	{
		if (group != null)
			calculateCosts(group);
	}
});

// JS: неймспейс мода
::Hooks.registerJS("ui/mods/mod_reforged_lite/setup.js");

// JS-хук: проброс entityId в тултипы характеров (character screen)
::Hooks.registerJS("ui/mods/mod_reforged_lite/js_hooks/screens/character/modules/character_screen_left_panel/character_screen_stats_module.js");
