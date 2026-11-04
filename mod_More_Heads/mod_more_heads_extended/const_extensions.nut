// More Heads Extended - Const table extensions
// Adds the new heads/bodies non-destructively to vanilla Const tables.

local function extendArray(_table, _key, _items) {
	if (!(_key in _table)) {
		_table[_key] <- clone _items;
		return;
	}
	local arr = _table[_key];
	foreach (item in _items) {
		if (arr.find(item) == null) arr.push(item);
	}
}

local function defineArray(_table, _key, _items) {
	if (!(_key in _table)) _table[_key] <- clone _items;
}

// New heads added by More Heads Extended (graphics shipped by the mod).
local NEW_NORTHERN_HEADS = [
	"bust_head_32", "bust_head_33", "bust_head_34", "bust_head_35",
	"bust_head_36", "bust_head_37", "bust_head_38", "bust_head_39",
	"bust_head_40", "bust_head_41", "bust_head_42", "bust_head_43",
	"bust_head_701", "bust_head_703", "bust_head_706"
];
local NEW_AFRICAN_HEADS = [
	"bust_head_500", "bust_head_501", "bust_head_502", "bust_head_503",
	"bust_head_504", "bust_head_505", "bust_head_506", "bust_head_507",
	"bust_head_508", "bust_head_509", "bust_head_510", "bust_head_511"
];
local NEW_ASIAN_HEADS = [
	"bust_head_600", "bust_head_601", "bust_head_602", "bust_head_603",
	"bust_head_604", "bust_head_605", "bust_head_606", "bust_head_607",
	"bust_head_608", "bust_head_609", "bust_head_610", "bust_head_611",
	"bust_head_612", "bust_head_613", "bust_head_614", "bust_head_615",
	"bust_head_616"
];
local NEW_SMART_HEADS = [
	"bust_head_33", "bust_head_39", "bust_head_41", "bust_head_42", "bust_head_706"
];
local NEW_WILD_HEADS = [
	"bust_head_32", "bust_head_34", "bust_head_35", "bust_head_36", "bust_head_37",
	"bust_head_38", "bust_head_40", "bust_head_43", "bust_head_701", "bust_head_703"
];

local NEW_ASIAN_BODIES   = [ "bust_naked_body_04" ];
local NEW_AFRICAN_BODIES = [ "bust_naked_body_southern_03" ];

local NEW_ASIAN_HAIRS = [
	"shaved", "101", "102", "104", "105",
	"106", "107", "108", "109", "110",
	"19"
];
local NEW_AFRICAN_HAIRS = [
	"22"
];

local NEW_ASIAN_BREADS = [
	"08", "10", "11", "101"
];

local NEW_ASIAN_BODY_TATTOOS = [
	"tattoo_01_body_04", "tattoo_02_body_04", "tattoo_03_body_04",
	"tattoo_04_body_04", "tattoo_05_body_04", "tattoo_06_body_04"
];

local NEW_ASIAN_HEAD_TATTOOS = [
	"asian_tattoo_01_head", "asian_tattoo_02_head", "asian_tattoo_03_head",
	"asian_tattoo_04_head", "asian_tattoo_05_head", "asian_tattoo_06_head"
];

local NEW_AFRICAN_LASTNAMES = [
    "ибн Абати",
    "ибн Адегбойе",
    "ибн Акинтими",
    "ибн Амаду",
    "ибн Ба",
    "ибн Байо",
    "ибн Бали",
    "ибн Банда",
    "ибн Бенга",
    "ибн Бива",
    "ибн Буба",
    "ибн Бунди",
    "ибн Габо",
    "ибн Далла",
    "ибн Дарбо",
    "ибн Демба",
    "ибн Джаллох",
    "ибн Джибо",
    "ибн Диалло",
    "ибн Драме",
    "ибн Дубай",
    "ибн Думбия",
    "ибн Закари",
    "ибн Исса",
    "ибн Кабила",
    "ибн Кайта",
    "ибн Камара",
    "ибн Канга",
    "ибн Канте",
    "ибн Кейта",
    "ибн Кинта",
    "ибн Конате",
    "ибн Кулибали",
    "ибн Кума",
    "ибн Куфуор",
    "ибн Луга",
    "ибн Маига",
    "ибн Мане",
    "ибн Маре",
    "ибн Мбенде",
    "ибн Мбога",
    "ибн Мейнга",
    "ибн Менса",
    "ибн Мкози",
    "ибн Мпоко",
    "ибн Мукоко",
    "ибн Мулумба",
    "ибн Мусу",
    "ибн Мфаме",
    "ибн Мфуму",
    "ибн Нгала",
    "ибн Ндойе",
    "ибн Нзе",
    "ибн Нсанга",
    "ибн Нсима",
    "ибн Нтале",
    "ибн Нтембо",
    "ибн Ньянг",
    "ибн Ньяре",
    "ибн Обаси",
    "ибн Одиамбо",
    "ибн Окафор",
    "ибн Окенва",
    "ибн Олува",
    "ибн Опара",
    "ибн Осеи",
    "ибн Осио",
    "ибн Отие",
    "ибн Савадого",
    "ибн Сангаре",
    "ибн Сисе",
    "ибн Сиссе",
    "ибн Сомаре",
    "ибн Сонгай",
    "ибн Сори",
    "ибн Суаре",
    "ибн Сумано",
    "ибн Суму",
    "ибн Тангор",
    "ибн Траоре",
    "ибн Турай",
    "ибн Туре",
    "ибн Умару",
    "ибн Фадига",
    "ибн Фалл",
    "ибн Фара",
    "ибн Фофана",
    "ибн Фуфу",
    "ибн Хама",
    "ибн Чиба",
    "ибн Чинья",
    "ибн Чома"
];

local NEW_AFRICAN_NAMES = [
	"Адегбола",
	"Айо",
	"Амади",
	"Бабатунде",
	"Бакри",
	"Бамба",
	"Бола",
	"Бучи",
	"Габор",
	"Дада",
	"Джабари",
	"Джамаль",
	"Джоб",
	"Джун",
	"Ифе",
	"Ишмаэль",
	"Кайоде",
	"Кваме",
	"Келечи",
	"Кибо",
	"Кунле",
	"Куфо",
	"Куэйси",
	"Ладари",
	"Манде",
	"Мбайе",
	"Мбия",
	"Мвана",
	"Мвару",
	"Нгози",
	"Нди",
	"Ндугу",
	"Нкуру",
	"Нома",
	"Оби",
	"Ойе",
	"Оке",
	"Ола",
	"Олу",
	"Олува",
	"Омари",
	"Опа",
	"Осеи",
	"Отея",
	"Самуэль",
	"Симба",
	"Сулу",
	"Табо",
	"Тайе",
	"Тендай",
	"Туре",
	"Уче",
	"Феми",
	"Фола",
	"Функе",
	"Чиди",
	"Чике",
	"Чима",
	"Чинве",
	"Шанга"
];

// ----------------------------------------------------------------------------
// Faces — extend vanilla pools
// ----------------------------------------------------------------------------
// IMPORTANT: AllMale must NOT contain African heads. The original More Heads mod
// kept AllMale as "northern + asian" (matching the AllMale BODY pool, which is
// also "northern + asian", no african body). If we put African heads in AllMale,
// vanilla backgrounds that use AllMale (peasant_background etc.) would roll an
// African face on a northern/asian body — exactly the bug v2.0 had.
extendArray(::Const.Faces, "AllMale",      NEW_NORTHERN_HEADS);
//extendArray(::Const.Faces, "AllMale",      NEW_ASIAN_HEADS);
// (NEW_AFRICAN_HEADS intentionally NOT added to AllMale — see comment above.)
extendArray(::Const.Faces, "NorthernMale", NEW_NORTHERN_HEADS);
//extendArray(::Const.Faces, "SouthernMale", NEW_AFRICAN_HEADS);
extendArray(::Const.Faces, "SmartMale",    NEW_SMART_HEADS);
extendArray(::Const.Faces, "WildMale",     NEW_WILD_HEADS);

if ("Barber" in ::Const.Faces) {
	extendArray(::Const.Faces, "Barber", NEW_NORTHERN_HEADS);
	extendArray(::Const.Faces, "Barber", NEW_ASIAN_HEADS);
	// African heads ARE included in Barber so player can choose them manually.
	extendArray(::Const.Faces, "Barber", NEW_AFRICAN_HEADS);
}

// Ethnic-specific pools that the original mod created.
defineArray(::Const.Faces, "AsianMale", NEW_ASIAN_HEADS);
defineArray(::Const.Faces, "African",   NEW_AFRICAN_HEADS);


// ----------------------------------------------------------------------------
// Bodies
// ----------------------------------------------------------------------------
// NOTE (v2.0.4): we DON'T extend Const.Bodies.AllMale or SouthernMale.
// Vanilla human.nut composes the injury brush name as
//   "bust_naked_body_0" + m.Body + "_injured"
// using m.Body as a numeric index. If we extend AllMale (3 entries) by the
// Asian body, m.Body can reach 3, so vanilla composes "bust_naked_body_03_injured"
// — a brush that doesn't exist (Asian body is _04, southern uses a different
// scheme). Vanilla's setBrush call logs "Unknown Brush requested" before our
// post-__original() override fixes the sprite. Cosmetically harmless but
// annoying in the log.
//
// Asian and African bodies are still available via the dedicated pools below
// (Const.Bodies.AsianMale and Const.Bodies.African) — More Heads' background
// hooks assign these pools explicitly when they want a phenotype-matched body,
// so the feature still works exactly as designed.
//
// Barber: keeping the new bodies available in the barber UI is desirable, but
// the barber composes brushes the same way, so for now we don't add them
// there either. Players can still get the new bodies by re-hiring (the
// background hooks place them correctly).
//
// RE-ENABLED: the injury-sprite log warning these guarded against is already
// fixed by hooks/human.nut (it rebuilds injury_body by brush name + doesBrushExist
// after __original), so it's safe to expose the new bodies again.
//extendArray(::Const.Bodies, "AllMale",      NEW_ASIAN_BODIES);      // random asian recruits
//extendArray(::Const.Bodies, "SouthernMale", NEW_AFRICAN_BODIES);    // random african recruits
if ("Barber" in ::Const.Bodies) {
    extendArray(::Const.Bodies, "Barber", NEW_ASIAN_BODIES);        // bust_naked_body_04
    extendArray(::Const.Bodies, "Barber", NEW_AFRICAN_BODIES);      // bust_naked_body_southern_03
}

defineArray(::Const.Bodies, "AsianMale", NEW_ASIAN_BODIES);
defineArray(::Const.Bodies, "African",   NEW_AFRICAN_BODIES);


// ----------------------------------------------------------------------------
// HairColors
// ----------------------------------------------------------------------------
defineArray(::Const.HairColors, "Asian",   [ "black", "grey", "black", "black", "black" ]);
defineArray(::Const.HairColors, "African", [ "black", "grey", "black", "black", "black" ]);
//defineArray(::Const.HairColors, "Southern",      [ "brown", "grey", "brown", "brown", "brown" ]);
//defineArray(::Const.HairColors, "SouthernYoung", [ "brown" ]);

// ----------------------------------------------------------------------------
// Hair
// ----------------------------------------------------------------------------
defineArray(::Const.Hair, "AsianMale", NEW_ASIAN_HAIRS);
defineArray(::Const.Hair, "African",   NEW_AFRICAN_HAIRS);
extendArray(::Const.Hair, "African",   ::Const.Hair.SouthernMale);
//defineArray(::Const.Hair, "SouthernMaleOnly", [
//	"southern_01", "southern_02", "southern_03", "southern_04",
//	"southern_05", "southern_06", "southern_07", "southern_08"
//]);
//defineArray(::Const.Hair, "SouthernMale", [
//	"southern_01", "southern_02", "southern_03", "southern_04",
//	"southern_05", "southern_06", "southern_07", "southern_08",
//	"10", "15", "16", "19"
//]);

// ----------------------------------------------------------------------------
// Beards
// ----------------------------------------------------------------------------
defineArray(::Const.Beards, "AsianMale", NEW_ASIAN_BREADS);
//defineArray(::Const.Beards, "WildExtended", [
//	"12", "13", "14", "15", "17"
//]);
//defineArray(::Const.Beards, "ZombieExtended", [
//	"zombie_01", "zombie_02", "zombie_03", "zombie_04",
//	"01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11",
//	"12", "13", "14", "15"
//]);
//defineArray(::Const.Beards, "SouthernUntidy", [
//	"southern_01", "southern_02", "southern_01", "southern_02",
//	"01", "05", "07", "09", "14", "17"
//]);
//defineArray(::Const.Beards, "Southern", [
//	"southern_01", "southern_02", "southern_01", "southern_02",
//	"01", "06", "07", "09"
//]);
//defineArray(::Const.Beards, "SouthernOnly", [ "southern_01", "southern_02" ]);
// ----------------------------------------------------------------------------
// Names
// ----------------------------------------------------------------------------
defineArray(::Const.Strings, "AfricanNames", NEW_AFRICAN_NAMES);
defineArray(::Const.Strings, "AfricanLastNames", NEW_AFRICAN_LASTNAMES);

// ----------------------------------------------------------------------------
// Tattoos
// ----------------------------------------------------------------------------
defineArray(::Const.Tattoos, "AsianBody", NEW_ASIAN_BODY_TATTOOS);
defineArray(::Const.Tattoos, "AsianHead", NEW_ASIAN_HEAD_TATTOOS);
