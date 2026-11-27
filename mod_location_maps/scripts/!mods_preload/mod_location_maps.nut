::LocationMaps <- {
	ID = "mod_location_maps",
	Name = "Location maps",
	Version = "1.0.0",
	// Rarity-поле записи магазина: больше = реже (шанс ~ (100-R)% при RarityMult 1.0)
	LegendaryShopRarity = 92,
	CampShopRarity = 85,
	// Высокий шанс в магазинах «Деревни Меча» (mod_Samurai)
	SamuraiShopRarity = 55,
	// Лагерь считается «большим», если его ресурсы не ниже порога.
	// Ванильное разделение по тирм: обычные лагеря <= 200, большие >= 220
	// (убежище варваров 325, города гоблинов/крепости орков 500, шайки-города 300,
	// юрты кочевников 300, раскопанный замок 350; у модов: лагеря джурчжэней/mgl 300,
	// большой лагерь скавенов 220, лагеря ушу 300/500, лагеря орды 350).
	CampMinResources = 220
}

::LocationMaps.HooksMod <- ::Hooks.register(::LocationMaps.ID, ::LocationMaps.Version, ::LocationMaps.Name);
::LocationMaps.HooksMod.require(["mod_modern_hooks"]);

// Неразведанные легендарные локации (Type.Unique). Локации из модов
// (RedCourt, kriegsgeist и пр.) попадают сюда автоматически по флагу Unique.
::LocationMaps.getLegendaryCandidates <- function()
{
	local ret = [];

	if (!("EntityManager" in ::World))
		return ret;

	foreach (location in ::World.EntityManager.getLocations())
	{
		if (location.isDiscovered() || location.getVisibilityMult() <= 0.0)
			continue;

		if (!location.isLocationType(::Const.World.LocationType.Unique))
			continue;

		ret.push(location);
	}

	return ret;
}

// Неразведанные большие вражеские лагеря: Lair, не Unique, ресурсы >= порога.
::LocationMaps.getCampCandidates <- function()
{
	local ret = [];

	if (!("EntityManager" in ::World))
		return ret;

	foreach (location in ::World.EntityManager.getLocations())
	{
		if (location.isDiscovered() || location.getVisibilityMult() <= 0.0)
			continue;

		if (!location.isLocationType(::Const.World.LocationType.Lair))
			continue;

		if (location.isLocationType(::Const.World.LocationType.Unique))
			continue;

		if (location.getResources() < ::LocationMaps.CampMinResources)
			continue;

		ret.push(location);
	}

	return ret;
}

::LocationMaps.rollLocation <- function( _candidates )
{
	if (_candidates.len() == 0)
		return null;

	return _candidates[::Math.rand(0, _candidates.len() - 1)];
}

// Открывает локацию: пометка разведанной + снятие тумана вокруг + прыжок камеры.
::LocationMaps.revealLocation <- function( _location )
{
	_location.setDiscovered(true);
	::World.uncoverFogOfWar(_location.getPos(), 250.0);
	::Settings.getTempGameplaySettings().CameraLocked = false;
	::World.State.getMenuStack().popAll(true);
	::World.getCamera().Zoom = 1.0;
	::World.getCamera().setPos(_location.getPos());
}

::LocationMaps.HooksMod.queue(">mod_modern_hooks", function() {
	// settlement.updateShop() для каждого здания со стешем вызывает building.onUpdateShopList(),
	// поэтому одного хука на базовый класс хватает для рынков замков/поселений/южных
	// городов и для магазинов «Деревни Меча» (mod_Samurai) — они идут через тот же метод.
	::LocationMaps.HooksMod.hook("scripts/entity/world/settlements/buildings/building", function(q) {
		q.onUpdateShopList = @(__original) { function onUpdateShopList( _list = [] )
		{
			local list = __original(_list);
			local settlement = this.m.Settlement;

			if (settlement == null || settlement.isNull())
				return list;

			// Замки, большие поселения и южные города; в деревнях карт нет.
			if (!(settlement.isMilitary() || settlement.getSize() >= 3 || settlement.isSouthern()))
				return list;

			list.push({ R = ::LocationMaps.CampShopRarity, P = 1.0, S = "misc/location_map_camp_item" });

			// Легендарные локации за игру не появляются: как только все разведаны,
			// легендарные карты перестают попадать в магазины мира.
			if (::LocationMaps.getLegendaryCandidates().len() > 0)
				list.push({ R = ::LocationMaps.LegendaryShopRarity, P = 1.0, S = "misc/location_map_legendary_item" });

			return list;
		}}.onUpdateShopList;
	});
});
