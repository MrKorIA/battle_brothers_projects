this.mod_ai_spawn_ghost_illusion <- ::inherit("scripts/ai/tactical/behavior", {
	m = {
		TargetTile = null,
	},
	function create()
	{
		this.m.ID = 85;
		this.m.Order = 39;
		this.behavior.create();
	}

	function onEvaluate( _entity, _isForce = false )
	{
		local score = this.getProperties().BehaviorMult[this.m.ID];
		this.m.TargetTile = null;

		if (!_isForce)
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		local myTile = _entity.getTile();
		local potentialDestinations = [];

		if (::Const.Tactical.Actor.Alp.TeleportTargets.len() == 0 || ::Const.Tactical.Actor.Alp.TeleportFrame != ::Time.getFrame())
		{
			::Const.Tactical.Actor.Alp.TeleportTargets = [];
			::Const.Tactical.Actor.Alp.TeleportFrame = ::Time.getFrame();
			this.getStrategy().cleanUpKnownOpponents();
			this.getStrategy().compileKnownOpponents();
			local targets = this.getAgent().getKnownOpponents();
			local maxRange = ::Math.rand(1, 4) == 1 ? 4 : 3;

			foreach( t in targets )
			{
				if (t.Actor.isNull())
				{
					continue;
				}

				local targetValue = this.queryTargetValue(_entity, t.Actor);

				if (t.Actor.getSkills().hasSkill("effects.mod_hallucinated"))
				{
					targetValue /= 3;
				}

				if (t.Actor.getCurrentProperties().IsStunned)
				{
					targetValue *= 1.5;
				}

				if (t.Actor.getCurrentProperties().MoraleCheckBraveryMult[1] > 0.0)
				{
					targetValue = targetValue / t.Actor.getCurrentProperties().MoraleCheckBraveryMult[1];
				}

				local potentialTiles = this.queryDestinationsInRange(t.Actor.getTile(), 3, maxRange);

				foreach( tile in potentialTiles )
				{
					if (!tile.IsEmpty || tile.Type == ::Const.Tactical.TerrainType.Impassable)
					{
						continue;
					}

					local score = 60.0 + 40.0 * targetValue;
					score = score - tile.getZoneOfOccupationCountOtherThan(_entity.getAlliedFactions()) * 30.0;
					score = score + tile.TVTotal;
					score = (tile.Properties.Effect != null && tile.Properties.Effect.Type != "miasma" && !tile.Properties.Effect.IsPositive ? 40.0 : 0.0);

					foreach( o in targets )
					{
						if (o.Actor.isNull() || o.Actor.getID() == t.Actor.getID())
						{
							continue;
						}

						if (o.Actor.getMoraleState() == ::Const.MoraleState.Fleeing || o.Actor.getCurrentProperties().IsStunned)
						{
							continue;
						}

						local d = o.Actor.getTile().getDistanceTo(tile);

						if (d <= 2)
						{
							score = score - 10.0;
						}
					}

					::Const.Tactical.Actor.Alp.TeleportTargets.push({
						Tile = tile,
						Score = score
					});
				}
			}
		}

		foreach( pd in ::Const.Tactical.Actor.Alp.TeleportTargets )
		{
			if (!pd.Tile.IsEmpty || pd.Tile.Type == ::Const.Tactical.TerrainType.Impassable)
			{
				continue;
			}

			local score = pd.Score;

			for( local i = 0; i < 6; i = ++i )
			{
				if (!pd.Tile.hasNextTile(i))
				{
				}
				else
				{
					local nextTile = pd.Tile.getNextTile(i);

					if (nextTile.IsOccupiedByActor && (nextTile.getEntity().getFlags().has("illusion") || nextTile.getEntity().getFlags().has("ghost_mage")))
					{
						score = score - 40.0;
					}
				}
			}

			potentialDestinations.push({
				Tile = pd.Tile,
				Score = score
			});
		}

		if (potentialDestinations.len() == 0)
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		potentialDestinations.sort(this.onSortByScore);
		this.m.TargetTile = potentialDestinations[0].Tile;
		return ::Const.AI.Behavior.Score.AlpTeleport * score;
	}

	function onExecute( _entity )
	{
		if (this.m.TargetTile != null)
		{
			local illusion = ::Tactical.spawnEntity("scripts/entity/tactical/enemies/mod_ghost_mage_boss_illusion", this.m.TargetTile.Coords);
			illusion.setTrueBody(_entity);
			illusion.copyAppearance();
			illusion.setFaction(_entity.getFaction());
			illusion.spawnTeleportEffect();
			local b = illusion.m.BaseProperties;
			b.MeleeSkill = _entity.getBaseProperties().getMeleeSkill();
			b.MeleeDefense = _entity.getBaseProperties().getMeleeDefense();
			b.Bravery = _entity.getBaseProperties().getBravery();
			b.Hitpoints = _entity.getBaseProperties().Hitpoints;
			illusion.getSkills().update();
			illusion.setHitpoints(_entity.getHitpoints());
			this.m.TargetTile = null;
		}

		return false;
	}

	function onSortByScore( _a, _b )
	{
		if (_a.Score > _b.Score)
		{
			return -1;
		}
		else if (_a.Score < _b.Score)
		{
			return 1;
		}

		return 0;
	}

});

