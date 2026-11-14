// Vanilla Adjustments
::MSU.Array.removeValues(::Const.Strings.BillNames, [
	"Бердыш",	// There is already a vanilla weapon with this name
	"Вульж"	// There is already a reforged weapon with this name
]);

::MSU.Array.removeValues(::Const.Strings.CrossbowNames, [
	"Предатель"		// moved over to dagger names
]);
::Const.Strings.CrossbowNames.extend([
	"Предатель",
	"Скорпион",
	"Железный взгляд",
	"Раскат грома",
	"Вороний крик",
	"Багряный болт",
	"Мрачнострел",
	"Драконий клык",
	"Терновник",
	"Громобой"
]);

::MSU.Array.removeValues(::Const.Strings.DaggerNames, [
	"Эсток"		// We have our own actual Estoc item
]);
::Const.Strings.DaggerNames.extend([
	"Предатель"		// formerly a crossbow name
]);

::Const.Strings.HandgonneNames.extend([
	"Предатель",
	"Оглушитель",
	"Стальной звон",
	"Вулкан",
	"Железная искра",
	"Громодел",
	"Огненная буря",
	"Инферно"
]);

::Const.Strings.LongaxeNames.extend([
	"Вспышка"
]);

::Const.Strings.SwordlanceNames.extend([	// In Vanilla this has only 2 entries
	"Убойник",
	"Кровавая луна",
	"Упыребойца",
	"Душегуб",
	"Теневой жнец",
	"Рука смерти",
	"Скорбный жнец",
	"Кровавый шторм",
	"Вестник войны"
]);

::MSU.Array.removeValues(::Const.Strings.WarbrandNames, [
	"Гросс-мессер",	// We have our own actual Kriegsmesser item
]);

::Const.Strings.WhipNames.extend([
	"Гросс-мессер",
	"Погонщик рабов",
	"Плеть",
	"Лоза",
	"Кровопускатель",
	"Колючая плеть",
	"Терновый хлыст"
]);

// Reforged Lists
::Const.Strings.RF_KriegsmesserNames <- [
	"Гросс-мессер",
	"Потрошитель",
	"Измельчитель",
	"Резак",
	"Обезглавливатель",
	"Опустошитель",
	"Кровопийца",
	"Кровохлёб",
	"Безумец",
	"Резчик",
	"Фальшион",
	"Раздиратель",
	"Врагодав",
	"Разрезатель",
	"Терзатель",
	"Палач",
	"Мучитель",
	"Воздаватель",
	"Фламберг",
	"Клинок",
	"Длинный меч",
	"Истребитель",
	"Истребитель",
	"Обезглавливатель",
	"Уравнитель",
	"Плотерез",
	"Плотеруб"
];

::Const.Strings.RF_LongswordNames <- [
	"Секач",
	"Измельчитель",
	"Клинок",
	"Резак",
	"Меч",
	"Умертвитель",
	"Произвол",
	"Истребитель",
	"Клинок",
	"Боевой клинок",
	"Длинный меч",
	"Кровопийца",
	"Хранящий клятву",
	"Огонёк",
	"Расчёт",
	"Мститель",
	"Кровопийца",
	"Шинкователь",
	"Проблеск",
	"Резак",
	"Клык",
	"Клинок",
	"Клинок ветра",
	"Верный меч",
	"Резчик",
	"Мститель",
	"Долг",
	"Истребитель"
];
