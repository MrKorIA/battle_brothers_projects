// Конфиг босса/юнитов и кризисных actions — ДО списков спавна (нужен Troops.HordeGeneral)
::include("mod_horde_invasion/config/units_config");
::include("mod_horde_invasion/config/spawnlist_horde");

// Хуки и конфиг кризиса «Нашествие Железной Орды»
::includeFiles(::IO.enumerateFiles("mod_horde_invasion/hooks"));

// JS-хук: радиокнопка выбора кризиса в меню новой кампании
::Hooks.registerJS("ui/mods/mod_horde_invasion/js_hooks/new_campaign_menu_module.js");
