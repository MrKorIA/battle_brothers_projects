// Based on the vanilla patch_forest_thick
this.CP_patch_cave_thick <- this.inherit("scripts/mapgen/tactical_template", {
	m = {},
	function init()
	{
		this.m.Name = "tactical.patch.CP_cave_thick";
		this.m.MinX = 10;
		this.m.MinY = 10;
	}

	function fill( _rect, _properties, _pass = 1 )
	{
		local caveWall = ::MapGen.get("tactical.tile.CP_caveWall");

		// Todo: add "second pass" to transform all northern facing cave walls into level=1 walls with a boulder on top, to improve visibility

		for (local x = _rect.X; x < _rect.X + _rect.W; ++x)
		{
			for (local y = _rect.Y; y < _rect.Y + _rect.H; ++y)
			{
				local tile = ::Tactical.getTileSquare(x, y);
				if (tile.Type != 0) continue;
				this.fillTile(tile, _rect, caveWall);
			}
		}
	}

// New Functions
	// Decide the properties of a _tile, given its position in the _rect
	function fillTile( _tile, _rect, _caveWall )
	{
		local isWallWallowed = true;
		local isSmallWall = false;

		// We look at all border-tiles and determine, how those should look
		if (this.isPatchBorder(_tile, _rect))
		{
			if (::Math.rand(1, 100) <= 50)
			{
				isWallWallowed = false;
			}
			else if (::Math.rand(1, 100) <= 50)
			{
				isSmallWall = true;
			}
		}

		_caveWall.onFirstPass({
			X = _tile.SquareCoords.X,
			Y = _tile.SquareCoords.Y,
			W = 1,
			H = 1,
			IsWallWallowed = isWallWallowed,
			IsSmallWall = isSmallWall,
		});
		_tile.IsSpecialTerrain = true;
	}

	// Determine, whether _tile is sitting at the border of _rect
	function isPatchBorder( _tile, _rect )
	{
		if (_tile.SquareCoords.X == _rect.X) return true;
		if (_tile.SquareCoords.X == _rect.X + _rect.W - 1) return true;
		if (_tile.SquareCoords.Y == _rect.Y) return true;
		if (_tile.SquareCoords.Y == _rect.Y + _rect.H - 1) return true;

		return false;
	}
});

