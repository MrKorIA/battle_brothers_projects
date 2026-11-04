this.tactical_mgl_camp <- this.inherit("scripts/mapgen/tactical_template", {
	m = {},
	function init()
	{
		this.m.Name = "tactical.mgl_camp";
		this.m.MinX = 32;
		this.m.MinY = 32;
	}

	function fill( _rect, _properties, _pass = 1 )
	{
		local centerTile = this.Tactical.getTileSquare(_rect.W / 2 + _properties.ShiftX, _rect.H / 2 + _properties.ShiftY);
		local minDist = 0;
		local isOnHill = centerTile.Level == 3;
		local hasPalisade = _properties.Fortification != 0;
		local radius = this.Const.Tactical.Settings.CampRadius + _properties.AdditionalRadius;

		for( local x = _rect.X; x < _rect.X + _rect.W; x = ++x )
		{
			for( local y = _rect.Y; y < _rect.Y + _rect.H; y = ++y )
			{
				local tile = this.Tactical.getTileSquare(x, y);
				local d = centerTile.getDistanceTo(tile);

				if (d < minDist || d > radius)
				{
				}
				else
				{
					if (this.Math.rand(1, 100) <= (hasPalisade ? 50 : 75))
					{
						tile.removeObject();
					}

					if ((!hasPalisade && d < radius || !hasPalisade && d < 6) && tile.IsEmpty)
					{
						local n = 0;

						for( local i = 0; i < 6; i = ++i )
						{
							if (!tile.hasNextTile(i))
							{
							}
							else if (!tile.getNextTile(i).IsEmpty)
							{
								n = ++n;
							}
						}

						if (this.Math.rand(1, 100) <= 3 + n * 3)
						{
							tile.clear();
							tile.spawnObject("entity/tactical/objects/mgl_camp_supplies");
						}
					}
				}
			}
		}

		for( local x = _rect.X; x < _rect.X + _rect.W; x = ++x )
		{
			for( local y = _rect.Y; y < _rect.Y + _rect.H; y = ++y )
			{
				local tile = this.Tactical.getTileSquare(x, y);
				local d = centerTile.getDistanceTo(tile);

				if (d < minDist || d > radius)
				{
				}
				else if (hasPalisade && d == radius && y != centerTile.SquareCoords.Y && x != centerTile.SquareCoords.X - 4)
				{
					tile.clear();

					if ((!isOnHill || tile.Level >= 2) && (this.Math.rand(1, 100) < 60 + (isOnHill ? -10 : 0) || y == centerTile.SquareCoords.Y + 2 || y == centerTile.SquareCoords.Y - 2))
					{
						tile.removeObject();
						local o;

						if (_properties.Fortification == this.Const.Tactical.FortificationType.Palisade)
						{
							o = tile.spawnObject("entity/tactical/objects/human_camp_wall");
						}
						else if (_properties.Fortification == this.Const.Tactical.FortificationType.Walls)
						{
							o = tile.spawnObject("entity/tactical/objects/graveyard_wall");
						}
						else if (this.Math.rand(1, 100) <= 50)
						{
							o = tile.spawnObject("entity/tactical/objects/human_camp_wall");
						}
						else
						{
							o = tile.spawnObject("entity/tactical/objects/graveyard_wall");
						}

						o.setDirBasedOnCenter(centerTile, radius);

						for( local i = 0; i < 6; i = ++i )
						{
							if (!tile.hasNextTile(i))
							{
							}
							else if (tile.getNextTile(i).getDistanceTo(centerTile) > d && tile.getNextTile(i).Level > tile.Level)
							{
								tile.getNextTile(i).Level = tile.Level;
							}
							else if (tile.getNextTile(i).getDistanceTo(centerTile) == d)
							{
								tile.IsDefensibleTerrain = true;
							}
						}
					}
				}
				else if ((hasPalisade && d < radius - 1 || !hasPalisade && d < 5) && tile.IsEmpty)
				{
					local n = 0;

					for( local i = 0; i < 6; i = ++i )
					{
						if (!tile.hasNextTile(i))
						{
						}
						else if (!tile.getNextTile(i).IsEmpty)
						{
							n = ++n;
						}
					}

					if (d == 0 || n == 0 && this.Math.rand(1, 100) <= 1)
					{
						tile.clear();
						local r = this.Math.rand(1, 3);

						if (r == 1)
						{
							tile.spawnObject("entity/tactical/objects/human_camp_small_fireplace");
						}
						else
						{
							tile.spawnObject("entity/tactical/objects/human_camp_large_fireplace");
						}
					}
					else if (this.Math.rand(1, 100) <= 12)
					{
						tile.clear();
                        local r = this.Math.rand(1, 4);
						if (r == 1)
						{
							tile.spawnObject("entity/tactical/objects/orc_camp_head");
						}
						else if (r == 2)
						{
							tile.spawnObject("entity/tactical/objects/mgl_camp_sulde");
						}
						else if (r == 3)
						{
							tile.spawnObject("entity/tactical/objects/mgl_camp_idol");
						}
						else
						{
							tile.spawnObject("entity/tactical/objects/mgl_camp_small_idol");
						}
					}
					else if (d <= 7 && this.Math.rand(1, 100) <= (hasPalisade ? 14 : 6))
					{
                        local deco = ::MSU.Class.WeightedContainer([
                            [2, "camp_01"],
                            [1, "camp_02"],
                            [1, "orcs_07"],
                            [2, "desert_camp_03"]
                        ]);
						tile.clear();
						tile.spawnDetail(deco.roll());
					}
				}
			}
		}
	}

	function spawnDetail( _tile, _distance, _hasPalisade, _isOnHill )
	{
		if (_distance == 0 || this.Math.rand(1, 100) <= 1)
		{
			_tile.clear();
			local r = this.Math.rand(1, 3);

			if (r == 1)
			{
				_tile.spawnObject("entity/tactical/objects/human_camp_small_fireplace");
			}
			else
			{
				_tile.spawnObject("entity/tactical/objects/human_camp_large_fireplace");
			}
		}
        else if (this.Math.rand(1, 100) <= 12)
        {
            _tile.clear();
            local r = this.Math.rand(1, 4);
            if (r == 1)
            {
                _tile.spawnObject("entity/tactical/objects/orc_camp_head");
            }
            else if (r == 2)
            {
                _tile.spawnObject("entity/tactical/objects/mgl_camp_sulde");
            }
            else if (r == 3)
            {
                _tile.spawnObject("entity/tactical/objects/mgl_camp_idol");
            }
            else
            {
                _tile.spawnObject("entity/tactical/objects/mgl_camp_small_idol");
            }
        }
		else if (_distance <= 7 && this.Math.rand(1, 100) <= (_hasPalisade ? 14 : 6))
		{
            local deco = ::MSU.Class.WeightedContainer([
                [2, "camp_01"],
                [1, "camp_02"],
                [1, "orcs_07"],
                [2, "desert_camp_03"]
            ]);
            _tile.clear();
            _tile.spawnDetail(deco.roll());
		}
	}

});

