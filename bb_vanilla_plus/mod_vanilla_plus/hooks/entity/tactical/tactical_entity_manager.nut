::VanillaPlus.HooksMod.hook("scripts/entity/tactical/tactical_entity_manager", function(q) {
	q.placePlayersAtBorder = @(__original) function( _players )
	{
		// We make sure that the player spawn area contains no isolated super high cave wall tiles by removing the level of those tiles to 1
		for (local x = 9; x <= 23; ++x)
		{
			for (local y = 2; y <= 4; ++y)
			{
				this.downsizeTile(::Tactical.getTile(x, y - x / 2));
			}
		}

		__original(_players);
	}

	q.placePlayersInFormation = @(__original) function( _players, _offsetX = 0, _offsetY = 0 )
	{
		// We make sure that the player spawn area contains no isolated super high cave wall tiles by removing the level of those tiles to 1
		for (local x = 11 + _offsetX; x <= 14 + _offsetX; ++x)
		{
			for (local y = 10 + _offsetY; y <= 20 + _offsetY; ++y)
			{
				this.downsizeTile(::Tactical.getTile(x, y - x / 2));
			}
		}

		__original(_players, _offsetX, _offsetY);
	}

	q.setupAmbience = @(__original) function( _worldTile )
	{
		foreach (entity in ::World.getAllEntitiesAtPos(_worldTile.Pos, 10))
		{
			if (!entity.isLocation()) continue;

			if (entity.m.CP_TacticalTypeOverwrite == "tactical.CP_cave")
			{
				this.CP_setupAmbienceCave();
				return;
			}
		}

		__original(_worldTile);
	}

// New Functions
	// Prepare a tile for a player spawn by making sure its not isolated (presumably because of its Level)
	q.downsizeTile <- function( _tile )
	{
		if (_tile.Level > 3 || this.isTileIsolated(_tile))
		{
			_tile.Level = 1;
		}
	}

	q.CP_setupAmbienceCave <- function()
	{
		local weather = ::Tactical.getWeather();
		weather.setAmbientLightingColor(::createColor(::Const.Tactical.AmbientLightingColor.CP_Cave));
		weather.setAmbientLightingSaturation(::Const.Tactical.AmbientLightingSaturation.CP_Cave);
	}
});
