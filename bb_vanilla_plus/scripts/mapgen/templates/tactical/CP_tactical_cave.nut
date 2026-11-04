this.CP_tactical_cave <- this.inherit("scripts/mapgen/tactical_template", {
	m = {},
	function init()
	{
		this.m.Name = "tactical.CP_cave";
		this.m.MinX = 32;
		this.m.MinY = 32;
	}

	function fill( _rect, _properties, _pass = 1 )
	{
		local caveWallThickPatch = ::MapGen.get("tactical.patch.CP_cave_thick");

		local thickPatches = 100;
		local thickAttempts = 0;

		// Place hundreds of cave wall clumps
		while (thickPatches != 0 && thickAttempts < 5000)
		{
			thickAttempts = ++thickAttempts;
			local sizeX = ::Math.rand(3, 5);
			local sizeY = ::Math.rand(3, 5);
			local rect = {
				X = 0,
				Y = 0,
				W = sizeX,
				H = sizeY,
				IsEmpty = false
			};
			rect.X = ::Math.rand(1, _rect.W - sizeX);
			rect.Y = ::Math.rand(1, _rect.H - sizeY);
			local skip = false;

			for (local x = rect.X - 1; x != rect.X + sizeX + 1; ++x)
			{
				for (local y = rect.Y - 1; y != rect.Y + sizeY + 1; ++y)
				{
					if (!::Tactical.isValidTileSquare(x, y)) continue;

					local tile = ::Tactical.getTileSquare(x, y);
					if (tile.IsSpecialTerrain)
					{
						skip = true;
						break;
					}
				}
				if (skip) break;
			}
			if (skip) continue;

			caveWallThickPatch.fill(rect, _properties);
			thickPatches = --thickPatches;
		}

		local tile1 = ::MapGen.get("tactical.tile.stone1");
		local tile2 = ::MapGen.get("tactical.tile.stone2");

		// Create Bumps and brush everything into stony
		for( local x = _rect.X; x < _rect.X + _rect.W; x = ++x )
		{
			for( local y = _rect.Y; y < _rect.Y + _rect.H; y = ++y )
			{
				local tile = ::Tactical.getTileSquare(x, y);
				if (tile.Type != 0) continue;

				{	// Create multiple hills
					local n = 0;
					if (::Tactical.isValidTileSquare(x - 1, y) && ::Tactical.getTileSquare(x - 1, y).Level == 1)
					{
						n = ++n;
					}

					if (::Tactical.isValidTileSquare(x - 1, y + 1) && ::Tactical.getTileSquare(x - 1, y + 1).Level == 1)
					{
						n = ++n;
					}

					if (::Tactical.isValidTileSquare(x, y - 1) && ::Tactical.getTileSquare(x, y - 1).Level == 1)
					{
						n = ++n;
					}

					tile.Level = 0;
					local bumpyBaseChance = 100;
					if (::Math.rand(1, 100) > bumpyBaseChance - n * 25)
					{
						tile.Level = 1;
					}
				}

				if (::Math.rand(1, 100) < 60)		// Same chance as Vanilla tactical_mountain.nut
				{
					tile1.fill({
						X = x,
						Y = y,
						W = 1,
						H = 1,
					}, _properties);
				}
				else
				{
					tile2.fill({
						X = x,
						Y = y,
						W = 1,
						H = 1,
					}, _properties);
				}
			}
		}

		this.makeBordersImpassable(_rect);
	}

	function campify( _rect, _properties )
	{
		local tile1 = ::MapGen.get("tactical.tile.stone1");
		local tile2 = ::MapGen.get("tactical.tile.stone2");
		local centerTile = ::Tactical.getTileSquare(_rect.X + _rect.W / 2 + _properties.ShiftX, _rect.Y + _rect.H / 2 + _properties.ShiftY);
		local radius = ::Const.Tactical.Settings.CampRadius + _properties.AdditionalRadius;

		for (local x = _rect.X; x < _rect.X + _rect.W; ++x)
		{
			for (local y = _rect.Y; y < _rect.Y + _rect.H; ++y)
			{
				local tile = ::Tactical.getTileSquare(x, y);
				local d = centerTile.getDistanceTo(tile);

				if (d <= radius + 3)
				{
					if (d <= radius)
					{
						tile.Level = 0;
					}

					if (::Math.rand(1, 100) <= 80 + (7 - d) * 7)
					{
						tile.Type = 0;
						tile.clear();

						local tileProp = {
							X = x,
							Y = y,
							W = 1,
							H = 1,
						};

						if (::Math.rand(1, 100) < 60)		// Same chance as Vanilla tactical_mountain.nut
						{
							tile1.fill(tileProp, null);
						}
						else
						{
							tile2.fill(tileProp, null);
						}
					}

					if (tile.IsHidingEntity)
					{
						tile.clear();
					}

					if (!tile.IsEmpty && ::Math.rand(1, 100) <= 66)
					{
						tile.removeObject();
					}
				}

				if (d > 10 && x < centerTile.SquareCoords.X && x > 4 && y > 10 && y < 30 && ::Math.rand(1, 100) <= 66)
				{
					tile.removeObject();
				}
			}
		}
	}

});

