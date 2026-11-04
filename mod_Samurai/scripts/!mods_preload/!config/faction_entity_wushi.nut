::Const.Strings.WushiNames <- [
	"Курики", "Юньлинь", "Нумагучи", "Такеши", "Ёсидзаки", "Масаюки", "Ямао", "Акинари",
	"Нобунага", "Хидэёси", "Иэясу", "Кэнсин", "Сингэн", "Масамунэ", "Ёсицунэ", "Юкимура",
	"Миямото", "Мусаси", "Кодзиро", "Хаттори", "Хандзо", "Кацуро", "Рюносукэ", "Гэндзи",
	"Хироси", "Кадзуо", "Кэндзи", "Такаси", "Киёси", "Дзэнъити", "Куросава", "Сатоси",
	"Хидэаки", "Тэцуя", "Сигэру", "Дайдзиро", "Кагэкацу", "Киёмаса", "Такамори", "Цунаёси",
	"Ясухиро", "Тосиро", "Кацумото", "Дзюнъити", "Синтаро", "Кадзума", "Рэй", "Гинтоки",
	"Хидэтака", "Рюити"
];

::Const.Strings.SamuraiLeaderNames <- [
	"Тадахиса Исикава",
	"Уэда Такеши",
	"Хидэо Ямада",
	"Онимуша"
];

local function addEntityType(_id, _name, _namePlural, _icon)
{
	if (!("EntityTypeMax" in ::Const))
	{
		local max = 0;
		foreach(key, value in ::Const.EntityType)
		{
			if (typeof value == "integer" && value > max) max = value;
		}
		::Const.EntityTypeMax <- max;
	}
	::Const.EntityType[_id] <- ++::Const.EntityTypeMax;
	::Const.Strings.EntityName.push(_name);
	::Const.Strings.EntityNamePlural.push(_namePlural);
	::Const.EntityIcon.push(_icon);
}

addEntityType("Jiangjun", "Сёгун", "сёгунов", "jiangjun_orientation");
addEntityType("Jianhao", "Кэнсэй", "кэнсэйев", "jianhao_orientation");
addEntityType("Langren", "Ронин", "ронининов", "langren_orientation");
addEntityType("Wushidajiang", "Тайкун", "тайкунов", "wushidajiang_orientation");
addEntityType("Renzhe", "Шинобу", "шинобу", "renzhe02_orientation");
addEntityType("Renzhe02", "Ниндзя", "ниндзя", "renzhe_orientation");
addEntityType("Sengbing", "Сохэй", "сохэев", "sengbing_orientation");
addEntityType("Wushi", "Самурай", "самураев", "wushi_orientation");
addEntityType("Wushi02", "Тадахиса Исикава", "Тадахис Исикав", "wushi_orientation");
addEntityType("Wushi03", "Уэда Такеши", "Уэд Такеш", "wushi_orientation");
addEntityType("Wushi04", "Хидэо Ямада", "Хидэо Ямад", "wushi02_orientation");
addEntityType("Wushi05", "Онимуша", "Онимуш", "guiwushi_orientation");
addEntityType("Zuqing", "Асигару", "асигар", "zuqing_orientation");

::Const.SamuraiBanners <- [
	"banner_wushi_01",
	"banner_wushi_02",
	"banner_wushi_03",
	"banner_wushi_04",
	"banner_wushi_05",
	"banner_wushi_06",
	"banner_wushi_07"
];

::Const.World.LocationNames.SamuraiCamp <- [
	"дома Ода",
	"дома Уэсуги",
	"дома Дата",
	"дома Мори",
	"дома Санада",
	"дома Такэда",
	"дома Токугава"
];