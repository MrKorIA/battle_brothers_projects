this.xxtactical_knighttown <- this.inherit("scripts/mapgen/tactical_template", {
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
		this.m.Name = "tactical.xxtactical_knighttown";
		this.m.MinX = 32;
		this.m.MinY = 32;
	}

	function fill( _rect, _properties, _pass = 1 )
	{
		local middleObjects = [
			"entity/tactical/objects/cartwheel",
			"entity/tactical/objects/human_camp_supplies",
			"entity/tactical/objects/human_camp_wood"
		]
		local tile;
		local chosenObject;
		local o;
		local ObjetcLimit = 20;
		for( local x = _rect.X; x < _rect.X + _rect.W; x = ++x )
		{
			for( local y = _rect.Y; y < _rect.Y + _rect.H; y = ++y )
			{
				tile = this.Tactical.getTileSquare(x, y);
				if (this.Math.rand(1, 150) <= 1 && ObjetcLimit > 0)
				{
					tile.removeObject();
					chosenObject = middleObjects[this.Math.rand(0, middleObjects.len()-1)];
					o = tile.spawnObject(chosenObject);
					ObjetcLimit = ObjetcLimit - 1;
				}
				else if (x > _rect.X + 1 && x < _rect.X + _rect.W - 2 && y > _rect.Y + 1 && y < _rect.Y + _rect.H - 2)
				{
					if (this.Math.rand(1, 100) <= 20)
					{
						tile.spawnDetail(this.m.Details[this.Math.rand(0, this.m.Details.len() - 1)]);
					}
				}

			}
		}
	}

});

