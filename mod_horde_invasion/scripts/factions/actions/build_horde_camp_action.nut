this.build_horde_camp_action <- this.inherit("scripts/factions/faction_action", {
	m = {},
	function create()
	{
		this.m.ID = "build_horde_camp_action";
		this.faction_action.create();
	}

	function onUpdate( _faction )
	{
		// Лагеря ставятся только на Live-фазе кризиса Орды
		if (!this.World.FactionManager.isHordeInvasion())
		{
			return;
		}

		// Лимит — 10 лагерей орды (TZ §4)
		local hordeCamps = 0;
		foreach (s in _faction.getSettlements())
		{
			local typeID = s.getTypeID();
			if (typeID == "location.horde_camp" || typeID == "location.horde_camp2")
			{
				hordeCamps++;
			}
		}

		if (hordeCamps >= 10)
		{
			return;
		}

		this.m.Score = 5;
	}

	function onExecute( _faction )
	{
		local camp;
		// Кризисное размещение — по мотивам build_orc_camp_action, но ослаблено:
		// снег разрешён, дистанции до поселений/локаций уменьшены, кольцо шире —
		// иначе на заполненной карте кандидатов почти нет (getTileToSpawnLocation
		// молча возвращает null, ослабление подтверждено игровым тестом фазы 2)
		local tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
			this.Const.World.TerrainType.Mountains
		], 6, 30, 20, 5, 5, null, 0.05, 0.95);

		if (tile != null)
		{
			if (this.Math.rand(1, 100) <= 50)
			{
				camp = this.World.spawnLocation("scripts/entity/world/locations/horde_camp_location", tile.Coords);
			}
			else
			{
				camp = this.World.spawnLocation("scripts/entity/world/locations/horde_camp2_location", tile.Coords);
			}
		}

		if (camp != null)
		{
			camp.onSpawned();
			camp.setBanner(camp.getTypeID() == "location.horde_camp" ? "banner_jin" : "banner_mgl");
			_faction.addSettlement(camp, false);
			this.logInfo("HordeInvasion: camp spawned (" + camp.getTypeID() + ")");
		}
	}

});
