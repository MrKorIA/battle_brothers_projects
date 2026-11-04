this.tactical_cultist_camp <- this.inherit("scripts/mapgen/tactical_template", {
	m = {},
	function init()
	{
		this.m.Name = "tactical.cultist_camp";
		this.m.MinX = 32;
		this.m.MinY = 32;
	}
	function fill( _rect, _properties, _pass = 1 )
	{
		local centerTile = this.Tactical.getTileSquare(_rect.W / 2 + _properties.ShiftX, _rect.H / 2 + _properties.ShiftY);
		local minDist = 0;
		local isOnHill = centerTile.Level == 3;
		local hasPalisade = _properties.Fortification != 0;
		local lairSize = this.getLairProperties() == null? 3 : this.getLairProperties()
		local radius = this.Const.Tactical.Settings.CampRadius - 3 + _properties.AdditionalRadius + lairSize;
		local nithingPoles = this.Math.rand(1, 2);
		local cooking_pot = false;



		for( local x = _rect.X; x < _rect.X + _rect.W; x = ++x )
		{
			for( local y = _rect.Y; y < _rect.Y + _rect.H; y = ++y )
			{
				local tile = this.Tactical.getTileSquare(x, y);
				local d = centerTile.getDistanceTo(tile);
				local secondD = this.Tactical.getTileSquare(centerTile.SquareCoords.X+1, centerTile.SquareCoords.Y).getDistanceTo(tile)
				if (d < 7) tile.removeObject();
				if (this.Math.rand(0, 100) <= this.Math.max(2, (100 - d* d)))
				{

					local pools = ["01", "02", "03", "04", "05", "06", "08", "09", "10", "11", "12", "13"]
					local  pool = tile.spawnDetail("big_fuckoff_splatter_" + this.Math.randArray(pools));
					local alpha = this.Math.max(0, 230 * (12-this.Math.rand(d-1, d+1)) /12) * lairSize/3 //tapering off at distance with a random component
					pool.Alpha = alpha
					if (d == 1 || secondD == 1) {
					   local pools = ["01", "02", "03", "04", "05", "06"];
					   tile.spawnDetail("bone_fuckoff_splatter_" + this.Math.randArray(pools));
					}
					else if (this.Math.rand(0, 100) <= this.Math.max(2, 75 - d* d))
					{
						local pools = ["01", "02", "03", "04", "05", "06"];
						if (this.Math.rand(1, 2) == 1){
							tile.spawnDetail("bone_fuckoff_splatter_" + this.Math.randArray(pools));
						}
						else{							
							tile.spawnDetail("bloodbone_fuckoff_splatter_" + this.Math.randArray(pools));
						}
					}
				}

				if (d < minDist || d > radius)
				{
				}
				else
				{
					if (this.Math.rand(1, 100) <= (hasPalisade ? 50 : 75))
					{
						tile.removeObject();
					}

					if ((hasPalisade && d < radius || !hasPalisade && d < 6) && tile.IsEmpty && d > 2)
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

						if (this.Math.rand(1, 100) <= 3 + n * 2)
						{
							tile.clear();

							if (this.Math.rand(1, 100) <= 50)
							{
								tile.spawnObject("entity/tactical/objects/human_camp_supplies");
							}
							else
							{
								tile.spawnObject("entity/tactical/objects/orc_camp_supplies");
							}
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
/*
				if (nithingPoles > 0 && d > radius && d < 15 && this.Math.rand(1, 100) <= 1)
				{
					nithingPoles = --nithingPoles;
					tile.removeObject();
					local o = tile.spawnObject("entity/tactical/objects/cultist_entrails");
}*/

				if (d < minDist || d > radius)
				{
				}
				else if (hasPalisade && d == radius && y != centerTile.SquareCoords.Y && x != centerTile.SquareCoords.X - 4)
				{
					tile.clear();

					if ((!isOnHill || tile.Level >= 2) && (this.Math.rand(1, 100) < 40 + (isOnHill ? -10 : 0) || y == centerTile.SquareCoords.Y + 2 || y == centerTile.SquareCoords.Y - 2))
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
				else if ((hasPalisade && d < radius - 1 || !hasPalisade && d < 12) && tile.IsEmpty)
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

					if (d == 0)
					{
						tile.clear();
						tile.spawnObject("entity/tactical/objects/cultist_altar");
						this.Tactical.getTileSquare(x+1, y).spawnObject("entity/tactical/objects/cultist_altar_small");

					}
					else if ((d == 3) && this.Math.rand(1, 100) <= 10 && !cooking_pot)
					{
						tile.clear();
						tile.spawnObject("entity/tactical/objects/cultist_cooking_pot");
						cooking_pot = true;
					}
					else if (d >= 3 && this.Math.rand(1, 100) <= 3)
					{
						tile.clear();
						if (this.Math.rand(0, 1) == 1) tile.spawnObject("entity/tactical/objects/" + this.Math.randArray(["cultist_cage", "cultist_totem"]));
						else{
							local o = tile.spawnObject("entity/tactical/objects/orc_camp_head");
							o.setVariant(this.Math.rand(0, 1));
							o.setFlipped(x < (_rect.X + _rect.W) / 2);
						}
						
					}
					else if (d <= 7 && this.Math.rand(1, 100) <= 3)
					{
						tile.clear();
						local r = this.Math.rand(1, 100);

						if (d <= 5 && r <= 20)
						{
							local deco = [
								"07"
							];
							tile.spawnDetail("cultists_" + deco[this.Math.rand(0, deco.len() - 1)]);
						}
						else
						{
							local deco = [
								"07"
							];
							tile.spawnDetail("orcs_" + deco[this.Math.rand(0, deco.len() - 1)]);
						}
					}
				}
			}
		}
	}

	function spawnDetail( _tile, _distance, _hasPalisade, _isOnHill )
	{
		if (_distance <= 7 && this.Math.rand(1, 100) <= (_hasPalisade ? 14 : 6))
		{
			_tile.clear();
			local r = this.Math.rand(1, 100);

			if (_distance <= 5 && r <= 20)
			{
				local deco = [
					"07", "07a"
				];
				_tile.spawnDetail("cultists_" + deco[this.Math.rand(0, deco.len() - 1)]);
			}
			else if (r <= 60)
			{
				local deco = [
					"07"
				];
				_tile.spawnDetail("orcs_" + deco[this.Math.rand(0, deco.len() - 1)]);
			}
			else
			{
				local deco = [
					"01",
					"01",
					"01",
					"02"
				];
				_tile.spawnDetail("camp_" + deco[this.Math.rand(0, deco.len() - 1)]);
			}
		}
	}
	function getLairProperties()
	{
		local size;
		local tile = this.World.State.getPlayer().getTile()
		// local entities = this.World.getAllEntitiesAndOneLocationAtPos(tile, 3.0);
		// foreach(entity in entities){
		// 	if (entity.m.TypeID == "location.cultist_camp"){
		// 		this.printDebug("Найден лагерь на тактической карте, от которого нужно выдержать расстояние", "mod_cultists")
		// 		return entity.m.Size
		// 	}
		// }
		if (this.World.State.getLastLocation() != null && this.World.State.getLastLocation().m.TypeID == "location.cultist_camp"){
	 		this.printDebug("Найден лагерь на тактической карте, от которого нужно выдержать расстояние ", "mod_cultists")
	 		return this.World.State.getLastLocation().m.Size
	 	}
		this.printDebug("НЕ найден лагерь на тактической карте, от которого нужно выдержать расстояние", "mod_cultists")
	}

});

