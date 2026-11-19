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

addEntityType("Balian", "Орк-мечник", "Орков-мечников", "nomad_09_orientation");
addEntityType("Boerduo", "Боэрдуо", "Боэрдуо", "nomad_09_orientation");
addEntityType("Boerduo2", "Боэрдуо2", "Боэрдуо2", "nomad_09_orientation");
addEntityType("Busiren", "Бусирэн", "Бусирэн", "nomad_09_orientation");
addEntityType("Busiren02", "Бусирэн2", "Бусирэн2", "nomad_09_orientation");
addEntityType("Daqiuzhang", "Блэйк Эндрю", "Блэйк Эндрю", "nomad_09_orientation");
addEntityType("Fengzi", "Гаргарус", "Гаргарус", "nomad_09_orientation");
addEntityType("Guerdan", "Орк-колдун", "Орков-колдунов", "nomad_09_orientation");
addEntityType("Niutoukuangzhanshi", "Бешеный бык", "Бешеных быков", "nomad_09_orientation");
addEntityType("Niutouren", "Нютоурэн", "Нютоурэн", "nomad_09_orientation");
addEntityType("Pochengzhe", "Глен", "Глен", "nomad_09_orientation");
addEntityType("Qiuzhang", "Трудитруди", "Трудитруди", "nomad_09_orientation");
addEntityType("Shourenbusiren", "Жестокий Куга", "Жестокий Куга", "nomad_09_orientation");
addEntityType("Shourenbusiren02", "Воскресший Куга", "Воскресший Куга", "nomad_09_orientation");
addEntityType("Shourenbusiren03", "Воскресший стражник", "Воскресший стражник", "nomad_09_orientation");
addEntityType("Shourenbusiren04", "Воскресший стражник", "Воскресший стражник", "nomad_09_orientation");
addEntityType("Shourendashi", "Владыка орков", "Владыка орков", "nomad_09_orientation");
addEntityType("Shourenlueduozhe", "Калуарес", "Калуарес", "nomad_09_orientation");
addEntityType("Shuren", "Шурэн", "Шурэн", "nomad_09_orientation");
addEntityType("Tiepi", "Тиэпи", "Тиэпи", "nomad_09_orientation");
addEntityType("Xiongshou", "Напарник Трудитруди", "Напарник Трудитруди", "nomad_09_orientation");
addEntityType("Xueren", "Сюэрен", "Сюэрен", "nomad_09_orientation");
addEntityType("Zhanzhengjiqi", "Чжаньчжэнцзици", "Чжаньчжэнцзици", "nomad_09_orientation");
addEntityType("Zuie", "Андре Вуг", "Андре Вуг", "nomad_09_orientation");
addEntityType("Zuie02", "Андре Вуг", "Андре Вуг", "nomad_09_orientation");


