
this.spawn_cultist_ritual_site_action <- this.inherit("scripts/factions/faction_action", {
	m = {},
	function create()
	{
		this.m.ID = "spawn_cultist_ritual_site_action";
		this.faction_action.create();
	}

	function onUpdate( _faction )
	{
		if (!_faction.getFlags().get("addedLegendaryCultistLocation")){
			this.printDebug(format("Нет флага для создания ритуального места"), "mod_cultists");
			return
		}
		if (_faction.getFlags().has("DelayUntilRitualSite") && this.World.getTime().Days < _faction.getFlags().get("DelayUntilRitualSite")) return

		local sites = 0
		foreach (loc in _faction.getSettlements())
		{
			if (loc.m.TypeID == "location.cultist_minor_ritual_site") sites++
		}
		if (sites < this.Const.CultistConfig.MaxRitualSites) this.m.Score = 20
	}

	function onClear()
	{
		
	}

	function onExecute( _faction )
	{
		local camp;
		local tile;
		local avoidTerrain = [
		this.Const.World.TerrainType.Mountains, 
		]
		local legendary = this.getCultists().getLegendary()
		local ritualSites = [];
		foreach (loc in _faction.getSettlements())
		{
			if (loc.m.TypeID == "location.cultist_minor_ritual_site") ritualSites.push(loc)
		}
		if (legendary != null)
		{
			this.printDebug(format("размещена локация культистов возле getLegendary"), "mod_cultists");
	    	tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries * 100, avoidTerrain, 25, 1000, 10, 7, 7, legendary.getTile());
	    }
	    else if (ritualSites.len() > 0)
	    {
	    	this.printDebug(format("размещена локация культистов возле другого ритуального места"), "mod_cultists");
	    	tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries * 100, avoidTerrain, 25, 1000, 10, 7, 7, this.Math.randArray(ritualSites).getTile());
	    }
	    else 
	    {
	    	tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries * 100, avoidTerrain, 35, 1000);
	    }
		if (tile != null)
		{
			camp = this.World.spawnLocation("scripts/entity/world/locations/cultist_ritual_site_location", tile.Coords);
		}
		if (camp != null)
		{
			camp.onSpawned();
			camp.setBanner("banner_13")
			_faction.addSettlement(camp, false);
		}
	}

	function getTileToSpawnLocation( _maxTries = 10, _notOnTerrain = [], _minDistToSettlements = 7, _maxDistToSettlements = 1000, _maxDistanceToAllies = 1000, _minDistToEnemyLocations = 7, _minDistToAlliedLocations = 7, _nearTile = null, _minY = 0.0, _maxY = 1.0 )
	{
		local mapSize = this.World.getMapSize();
		local navSettings = this.World.getNavigator().createSettings();
		navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost;
		navSettings.RoadMult = 1.0;
		local used = [];
		local tries = 0;

		while (tries++ < _maxTries)
		{
			local x;
			local y;

			if (_nearTile != null)
			{
				x = this.Math.rand(this.Math.max(3, _nearTile.SquareCoords.X - 10), this.Math.min(mapSize.X - 3, _nearTile.SquareCoords.X + 10));
				y = this.Math.rand(this.Math.max(3, _nearTile.SquareCoords.Y - 10), this.Math.min(mapSize.Y - 4, _nearTile.SquareCoords.Y + 10));
			}
			else
			{
				x = this.Math.rand(3, mapSize.X - 3);
				y = this.Math.rand(this.Math.max(3, mapSize.Y * _minY), this.Math.min(mapSize.Y - 4, mapSize.Y * _maxY));
			}

			local tile = this.World.getTileSquare(x, y);

			if (used.find(tile.ID) != null)
			{
				continue;
			}

			used.push(tile.ID);

			if (tile.IsOccupied || tile.HasRoad || tile.HasRiver)
			{
				continue;
			}

			if (tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Shore)
			{
				continue;
			}

			if (this.World.State.getPlayer() != null && this.World.State.getPlayer().getTile().getDistanceTo(tile) < 6)
			{
				continue;
			}

			local abort = false;

			foreach( t in _notOnTerrain )
			{
				if (tile.Type == t)
				{
					abort = true;
					break;
				}
			}

			if (abort)
			{
				continue;
			}

			for( local i = 0; i != 6; i = ++i )
			{
				if (!tile.hasNextTile(i))
				{
				}
				else
				{
					local next = tile.getNextTile(i);

					if (next.HasRoad || next.Type == this.Const.World.TerrainType.Ocean || _maxDistanceToAllies > 1000 && next.Type == this.Const.World.TerrainType.Shore)
					{
						abort = true;
						break;
					}
				}
			}

			if (abort)
			{
				continue;
			}

			local settlements = this.World.EntityManager.getSettlements();
			local dist = 1000;

			foreach( s in settlements )
			{
				local d = s.getTile().getDistanceTo(tile);

				if (d < dist)
				{
					dist = d;
				}
			}

			if (dist < _minDistToSettlements || dist > _maxDistToSettlements)
			{
				continue;
			}

			local locations = this.World.EntityManager.getLocations();

			if (_minDistToAlliedLocations != 0 || _minDistToEnemyLocations != 0)
			{
				foreach( v in locations )
				{
					local d = tile.getDistanceTo(v.getTile());

					if (v.getFaction() == this.m.Faction.getID() && d < _minDistToAlliedLocations || v.getFaction() != this.m.Faction.getID() && d < _minDistToEnemyLocations)
					{
						abort = true;
						break;
					}
				}

				if (abort)
				{
					continue;
				}
			}

			if (this.m.Faction.getSettlements().len() != 0 && _maxDistanceToAllies != 0 && _maxDistanceToAllies != 1000)
			{
				local dist = 1000;

				foreach( s in this.m.Faction.getSettlements() )
				{
					if (s.m.TypeID == "location.cultist_camp") continue
					local d = s.getTile().getDistanceTo(tile);

					if (d < dist)
					{
						dist = d;
					}
				}

				if( dist > _maxDistanceToAllies)
				{
					continue
				}
			}

			for( local i = x - 3; i < x + 3; i = ++i )
			{
				for( local j = y - 3; j < y + 3; j = ++j )
				{
					if (!this.World.isValidTileSquare(i, j))
					{
					}
					else if (this.World.getTileSquare(i, j).HasRoad)
					{
						abort = true;
						break;
					}
				}
			}

			if (abort)
			{
				continue;
			}

			abort = true;

			foreach( v in locations )
			{
				if (v.isIsolated())
				{
					continue;
				}

				local path = this.World.getNavigator().findPath(tile, v.getTile(), navSettings, 0);

				if (!path.isEmpty())
				{
					abort = false;
					break;
				}
			}

			if (abort)
			{
				continue;
			}

			return tile;
		}

		return null;
	}
});

