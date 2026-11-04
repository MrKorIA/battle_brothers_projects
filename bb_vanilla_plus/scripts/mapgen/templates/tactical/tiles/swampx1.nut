this.swampx1 <- this.inherit("scripts/mapgen/tactical_template", {
	m = {},
	function init()
	{
		this.m.Name = "tactical.tile.swampx1";
		this.m.MinX = 1;
		this.m.MinY = 1;
	}

	function onFirstPass( _rect )
	{
		local tile = this.Tactical.getTileSquare(_rect.X, _rect.Y);

		if (tile.Type != 0)
		{
			return;
		}

		tile.Type = this.Const.Tactical.TerrainType.Swamp;
		tile.Subtype = this.Const.Tactical.TerrainSubtype.MurkyWater;
		tile.BlendPriority = this.Const.Tactical.TileBlendPriority.Forest;
		tile.IsBadTerrain = true;
		tile.setBrush("tile_swamp_05");
		tile.spawnDetail("xxbluewater");
	}

});

