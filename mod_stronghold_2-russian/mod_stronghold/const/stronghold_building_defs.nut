
::Stronghold.BuildingDefs <-
{
	Alchemist = {
		Name = "Алхимик",
		Description = "Алхимик, создающий чудные и опасные приспособления за немалые деньги.",
		ID = "building.alchemist",
		Path = "alchemist_building",
		SouthPath = "",
		Requirements = [],
		ImagePath = "ui/settlements/desert_building_14.png",
	},
	Arena = {
		Name = "Арена",
		Description = "Арена позволяет заработать золото и славу в смертельных боях на глазах у ликующей толпы, услаждая её ужасным кровопролитием.",
		ID = "building.arena",
		Path = "arena_building",
		SouthPath = "",
		Requirements =
		[{
			Text = "Требуемый размер базы: Крепость (4/4).",
			IsValid = @(_town) _town.getSize() == 4
		}]
		ImagePath = "ui/settlements/desert_building_05.png",
	},
	Armorsmith = {
		Name = "Бронница",
		Description = "Мастерская брони - лучшее место чтобы разжиться надёжной защитой. Также, за определённую плату, здесь можно починить свои повреждённые доспехи.",
		ID = "building.armorsmith",
		SouthID = "building.armorsmith_oriental",
		Path = "armorsmith_building",
		SouthPath = "armorsmith_oriental_building",
		Requirements = [],
		ImagePath = "ui/settlements/building_01.png",
	},
	Tavern = {
		Name = "Таверна",
		ID = "building.tavern",
		Path = "tavern_building",
		SouthPath = "",
		Description = "Большая таверна, наполненная посетителями со всех краёв света, предлагает напитки, кушанья и приятную компанию для обмена новостями и слухами.",
		Requirements = []
		ImagePath = "ui/settlements/building_02.png",
	},
	Kennel = {
		Name = "Псарня",
		Description = "На псарне выводят сильных и быстрых боевых псов.",
		ID = "building.kennel",
		Path = "kennel_building",
		SouthPath = "",
		Requirements = []
		ImagePath = "ui/settlements/building_10.png",
	},
	Taxidermist = {
		Name = "Скорняк",
		Description = "Мастерская скорняка, где он может создать полезные предметы из добытых вами трофеев.",
		ID = "building.taxidermist",
		SouthID = "building.taxidermist_oriental",
		Path = "taxidermist_building",
		SouthPath = "taxidermist_oriental_building",
		Requirements = []
		ImagePath = "ui/settlements/building_13.png",
	},
	Temple = {
		Name = "Храм",
		Description = "Убежище от окружающего жестокого мира. Вы найдёте здесь исцеление для своих раненых и покой для спасения своей души.",
		ID = "building.temple",
		SouthID = "building.temple",
		Path = "temple_building",
		SouthPath = "temple_oriental_building",
		Requirements = []
		ImagePath = "ui/settlements/building_03.png",
	},
	Training_Hall = {
		Name = "Тренировочный зал",
		Description = "Место где воины обмениваются боевым опытом. Здесь ваши люди могут тренироваться и учиться под началом закалённых в бою ветеранов, позволяя вам быстрее превратить их в опытных наёмников.",
		ID = "building.training_hall",
		Path = "training_hall_building",
		SouthPath = "",
		Requirements = []
		ImagePath = "ui/settlements/building_07.png",
	},
	Weaponsmith = {
		Name = "Кузница",
		Description = "Оружейная мастерская, предлагающая все возможные виды искусно сделанного оружия. За определённую плату здесь можно починить своё снаряжение.",
		ID = "building.weaponsmith",
		SouthID = "building.weaponsmith_oriental",
		Path = "weaponsmith_building",
		SouthPath = "weaponsmith_oriental_building",
		Requirements = [],
		ImagePath = "ui/settlements/building_04.png",
	},
	Fletcher = {
		Name = "Мастерская луков и арбалетов",
		Description = "Мастерская предлагает все виды искусно сделанного дальнобойного и метательного оружия.",
		ID = "building.fletcher",
		Path = "fletcher_building",
		SouthPath = "",
		Requirements = []
		ImagePath = "ui/settlements/building_11.png",
	},
	Port = {
		Name = "Порт",
		Description = "Порт, который служит как иностранным торговым судам, так и местным рыбакам. Вы наверняка сможете найти здесь корабль, чтобы добраться до другого порта.",
		ID = "building.port",
		Path = "port_building",
		SouthPath = "",
		Requirements =
		[{
			Text = "Жизнь рядом с морем.",
			IsValid = @(_town) _town.isCoastal()
		}]
		ImagePath = "ui/settlements/building_09.png",
	},
	Barber = {
		Name = "Цирюльник",
		Description = "Измените внешний вид своих людей у цирюльника. Постригите волосы и бороды или прикупите сомнительных зелий для изменения внешнего вида.",
		ID = "building.barber",
		Path = "barber_building",
		SouthPath = "",
		Requirements = []
		ImagePath = "ui/settlements/building_12.png",
	},
	Crowd = {
		Name = "Новобранцы",
		Description = "Нанять более или менее перспективных новобранцев.",
		ID = "building.crowd",
		Path = "crowd_building",
		SouthPath = "crowd_oriental_building",
		Requirements =
		[{
			Text = "Связь с другими населёнными пунктами по дороге.",
			IsValid = @(_town) !_town.isIsolatedFromRoads()
		}]
		ImagePath = "ui/settlements/crowd_03.png",
	}
}
