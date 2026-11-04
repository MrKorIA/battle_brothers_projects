this.CP_caveWall <- this.inherit("scripts/mapgen/tactical_template", {
	m = {
		Details = [
			"tundra_grass_01",
			"tundra_grass_02",
			"tundra_grass_03",
			"tundra_grass_04",
			"tundra_grass_05",
			"rocks_01",
			"rocks_02",
			"rocks_03",
			"rocks_04",
			"rocks_05",
			"rocks_06"
		],
		DetailsStones = [
			"tundra_stone_detail_01",
			"tundra_stone_detail_02",
			"tundra_stone_detail_11",
			"tundra_stone_detail_12",
			"rocks_01",
			"rocks_02",
			"rocks_03",
			"rocks_04",
			"rocks_05",
			"rocks_06"
		],
		ChanceToSpawnDetails = 40,
		LimitOfSpawnedDetails = 4,
		Objects = [
			"entity/tactical/objects/tundra_boulder1",
			"entity/tactical/objects/autumn_boulder1",
			"entity/tactical/objects/autumn_boulder2"
		],

		WallHeight = 8,		// This needs to be at least 4 higher than 3 to prevent Entities with wall-climp ability (Spiders, Ghosts) to move up there
	},
	function init()
	{
		this.m.Name = "tactical.tile.CP_caveWall";
		this.m.MinX = 1;
		this.m.MinY = 1;
		local t = this.createTileTransition();
		t.setBlendIntoSockets(false);
		t.setBrush(::Const.Direction.N, "transition_autumn_05_N");
		t.setBrush(::Const.Direction.NE, "transition_autumn_05_NE");
		t.setBrush(::Const.Direction.SE, "transition_autumn_05_SE");
		t.setBrush(::Const.Direction.S, "transition_autumn_05_S");
		t.setBrush(::Const.Direction.SW, "transition_autumn_05_SW");
		t.setBrush(::Const.Direction.NW, "transition_autumn_05_NW");
		t.setSocket("socket_stone");
		::Tactical.setTransitions("tile_stone_02", t);
	}

	function onFirstPass( _rect )
	{
		local tile = ::Tactical.getTileSquare(_rect.X, _rect.Y);
		if (tile.Type != 0) return;

		tile.Type = ::Const.Tactical.TerrainType.FlatGround;
		tile.Subtype = ::Const.Tactical.TerrainSubtype.FlatStone;
		tile.BlendPriority = ::Const.Tactical.TileBlendPriority.Stone2;
		tile.IsBadTerrain = false;
		tile.setBrush("tile_stone_02");

		// Details
		if (::Math.rand(1, 100) <= this.m.ChanceToSpawnDetails)
		{
			if (::Math.rand(1, 100) <= 20)
			{
				tile.spawnDetail(::MSU.Array.rand(this.m.DetailsStones));
			}
			else if (::Math.rand(1, 100) <= 50)
			{
				tile.spawnDetail(::MSU.Array.rand(this.m.Details));
			}
			else
			{
				for (local n = 0; ::Math.rand(0, 100) < this.m.ChanceToSpawnDetails && n++ < this.m.LimitOfSpawnedDetails;)
				{
					local i = ::Math.rand(0, this.m.Details.len() - 1);
					tile.spawnDetail(this.m.Details[i]);
				}
			}
		}

		if (_rect.IsWallWallowed)
		{
			if (!_rect.IsSmallWall)
			{
				tile.Level = this.m.WallHeight;

				// We spawn an obstacle on these objects, so that AI or some skills will never consider them as valid tiles
				// Todo: spawn objects that block vision instead
				// tile.spawnObject(::MSU.Array.rand(this.m.Objects));

				// No details needed, because we never don't see these tiles anyways
			}
			else
			{
				tile.Level = ::Math.rand(2, 3);
			}
		}
		else
		{
			tile.Level = ::Math.rand(0, 1);
		}
	}
});

