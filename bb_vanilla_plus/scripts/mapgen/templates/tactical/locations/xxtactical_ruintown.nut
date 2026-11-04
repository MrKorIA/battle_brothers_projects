this.xxtactical_ruintown <- this.inherit("scripts/mapgen/tactical_template", {
	m = {
		Details = [
			"arrow_missed_01",
			"arrow_missed_02",
			"arrow_missed_03",
			"arrow_missed_04",
			"arrow_missed_05",
			"arrow_missed_06",
			"arrow_missed_07",
			"arrow_missed_08",
			"blood_red_01",
			"blood_red_02",
			"blood_red_03",
			"blood_red_04",
			"blood_red_05",
			"blood_red_06",
			"blood_red_07",
			"blood_red_08",
			"blood_red_09",
			"blood_red_10",
			"blood_red_01",
			"blood_red_02",
			"blood_red_03",
			"blood_red_04",
			"blood_red_05",
			"blood_red_06",
			"blood_red_07",
			"blood_red_08",
			"blood_red_09",
			"blood_red_10",
			"corpse_part_01",
			"corpse_part_02",
			"corpse_part_03",
			"corpse_part_04",
			"corpse_part_05",
			"javelin_missed_10",
			"javelin_missed_11",
			"javelin_missed_12",
			"blood_dark_06",
			"blood_dark_07",
			"blood_bones_02",
			"blood_bones_03",
			"blood_bones_07",
			"autumn_leaves_12",
			"autumn_leaves_13",
			"autumn_leaves_14",
			"autumn_leaves_04",
			"desert_stone_detail_03",
			"desert_stone_detail_05",
			"desert_stone_detail_08",
			"steppe_stone_detail_11",
			"steppe_stone_detail_12",
			"detail_grass_02",
			"detail_grass_03",
			"detail_mushrooms_01",
			"detail_mushrooms_03",
			"detail_swamp_02",
			"detail_swamp_02",
			"detail_stone_00",
			"detail_stone_01",
			"detail_stone_02",
			"detail_stone_03",
			"detail_stone_04",
			"detail_grass_02",
			"detail_grass_03",
			"tundra_flowers_03"
		]
	},
	function init()
	{
		this.m.Name = "tactical.xxtactical_ruintown";
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
		local bonus = _properties.Template[1] != null ? this.MapGen.get(_properties.Template[1]) : null;
		local statue = this.Math.rand(0, 1);

		for( local x = _rect.X; x < _rect.X + _rect.W; x = ++x )
		{
			for( local y = _rect.Y; y < _rect.Y + _rect.H; y = ++y )
			{
				local tile = this.Tactical.getTileSquare(x, y);
				local d = centerTile.getDistanceTo(tile);

				tile.Type = this.Const.Tactical.TerrainType.FlatGround;
				tile.Subtype = this.Const.Tactical.TerrainSubtype.Grassland;
				tile.BlendPriority = this.Const.Tactical.TileBlendPriority.Grass1;
				tile.setBrush("tile_road");
				tile.Level = this.Math.min(1, tile.Level);

				if (d < minDist || d > radius)
				{
				}
				else
				{
					if (this.Math.rand(1, 100) <= 90)
					{
						tile.removeObject();
					}

					if (hasPalisade && d == radius && y != centerTile.SquareCoords.Y)
					{
						tile.clear();
						tile.removeObject();
					}
					else if (d < radius - 1 && tile.IsEmpty)
					{
						if (this.Math.rand(1, 100) <= 5)
						{
							tile.clear();
							local r = this.Math.rand(1, 3);
							local middleObjects = [
								"entity/tactical/objects/graveyard_ruins",
								"entity/tactical/objects/cartwheel",
								"entity/tactical/objects/cartwheel",
								"entity/tactical/objects/human_camp_supplies",
								"entity/tactical/objects/human_camp_wood"
							];
							tile.spawnObject(middleObjects[this.Math.rand(0, middleObjects.len()-1)]);
						}
						if (statue > 0 && this.Math.rand(1, 100) <= 1)
						{
							statue = --statue;
							tile.clear();
							tile.spawnObject("entity/tactical/objects/graveyard_ruins_statue");
						}
						else if (this.Math.rand(1, 100) <= 10)
						{
							local deco = [
								"05",
								"06"
							];
							tile.clear();
							tile.spawnDetail("graveyard_" + deco[this.Math.rand(0, deco.len() - 1)]);
						}
						else if (bonus != null)
						{
							bonus.spawnDetail(tile, d, hasPalisade, isOnHill);
						}
					}
				}
			}
		}
	}

});

