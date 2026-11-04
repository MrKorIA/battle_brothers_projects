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

addEntityType("Baihuzhang", "Владыка клана", "владык клана", "baihuzhang_orientation");
addEntityType("Caoyuanzhanshi", "Степной воин", "степных воинов", "caoyuanzhanshi_orientation");
addEntityType("Cunmin", "Мутировавший селянин", "мутировавших селян", "cunmin_orientation");
addEntityType("Guancai", "Осквернённый саркофаг", "осквернённых саркофагов", "");
addEntityType("Kehanweishi", "Кэшик", "кэшиков", "kehanweishi_orientation");
addEntityType("Lingmujiangshi", "Мутировавший воин степи", "мутировавших воинов степи", "lingmujiangshi_orientation");
addEntityType("Lingmuyouling", "Страж гробницы", "стражей гробницы", "");
addEntityType("Mumin", "Степной кочевник", "степных кочевников", "mumin_orientation");
addEntityType("Wang", "Генерал гробницы", "генералов гробницы", "wang_orientation");
addEntityType("Zibaogbl", "Берсерк", "берсерков", "yemanren_01_orientation");

::Const.Strings.MglNames <- ["Барьял", "Багатур", "Амузигала", "Тумен" , "Тэмур", "Табудай", "Джиргадай", "Эркэ", "Илугей", "хара" ];
::Const.Strings.MglTitles <- ["Хадачин", "Ангчин", "Тогчи", "Ужасный", "Хоничин", "Хорчин", "Хшигтэн"];
