::Const.World.Settlements.VP_Medium_Southern_Villages <- [
	{
		Script = "scripts/entity/world/settlements/vp_medium_southern_village",
		function isSuitable( _terrain )
		{
			if (_terrain.Local != ::Const.World.TerrainType.Oasis && _terrain.Local != ::Const.World.TerrainType.Desert)
			{
				return false;
			}

			local disallowedTerrainTypes = [
				::Const.World.TerrainType.Steppe,
				::Const.World.TerrainType.Plains,
			];

			foreach (terrainType in disallowedTerrainTypes)
			{
				if (_terrain.Adjacent[terrainType] > 0) return false;
				if (_terrain.Region[terrainType] > 0) return false;
			}

			return true;
		}
	}
];

::Const.World.Settlements.Master.push({
	Amount = 3,
	List = ::Const.World.Settlements.VP_Medium_Southern_Villages,
	AdditionalSpace = 3,
	IgnoreSide = true,
})
