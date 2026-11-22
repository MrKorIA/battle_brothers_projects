// Хуки конфигов и игровых систем (функциональные — не про тултипы скиллов)
::includeFiles(::IO.enumerateFiles("mod_reforged_lite/hooks"));

// Хелперы вложенных тултипов и словарь концепций мода (зависимость: mod_nested_tooltips)
::include("mod_reforged_lite/tooltips/nested_helpers");
::include("mod_reforged_lite/tooltips/concepts");

// Движок тултип-хуков скиллов других модов (должен грузиться ДО реестров из tooltips/hooks)
::include("mod_reforged_lite/tooltips/mod_skill_tooltips");

// Тултип-хуки скиллов: ванильный батч (vanilla/) + реестры по модам (<мод>/registry.nut).
// Только вложенные ссылки — тексты скиллов не дублируются (см. tooltips/mod_skill_tooltips.nut).
::includeFiles(::IO.enumerateFiles("mod_reforged_lite/tooltips/hooks"));

// Оверлей линкифайера поверх ванильного батча — ЯВНО после батча: порядок include = порядок
// RawHooks, обёртка линкифайера должна оказаться внешней (закодированные батчем ссылки защищены)
::include("mod_reforged_lite/tooltips/hooks/vanilla/batch_overlay");

// Утилиты мира (имена/баннеры наёмных отрядов — охотники за головами)
::include("mod_reforged_lite/utils");

// Текстовые хелперы (тултип контракта на экране города)
::include("mod_reforged_lite/text/text");

// Тултипы мода: контракт на экране города (Contract.Tooltip — см. JS-хук town screen)
::include("mod_reforged_lite/tooltips/contracts");

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
		::Const.World.Spawn.NecromancerSouthern,
		::Const.World.Spawn.HD_AttachedProduction,
		::Const.World.Spawn.HD_AttachedProductionSouthern
	])
	{
		if (group != null)
			calculateCosts(group);
	}
});

// JS: неймспейс мода
::Hooks.registerJS("ui/mods/mod_reforged_lite/setup.js");

// JS-фикс: «залипание» тултипа тайла в mod_nested_tooltips 0.5.5 (подавленный залоченным
// тултипом показ восстанавливается после его закрытия без движения мыши)
::Hooks.registerJS("ui/mods/mod_reforged_lite/js_hooks/msu/nested_tooltips.js");

// JS-хук: проброс entityId в тултипы характеров (character screen)
::Hooks.registerJS("ui/mods/mod_reforged_lite/js_hooks/screens/character/modules/character_screen_left_panel/character_screen_stats_module.js");

// JS-хуки: тултип контракта на экране города + расторжение по ПКМ, rf_image в тултипах
::Hooks.registerJS("ui/mods/mod_reforged_lite/js_hooks/screens/world/modules/world_town_screen/world_town_screen_main_dialog_module.js");
::Hooks.registerJS("ui/mods/mod_reforged_lite/js_hooks/screens/world/world_town_screen.js");
::Hooks.registerJS("ui/mods/mod_reforged_lite/js_hooks/screens/tooltip/modules/tooltip_module.js");
::Hooks.registerCSS("ui/mods/mod_reforged_lite/css/tooltip_module.css");
