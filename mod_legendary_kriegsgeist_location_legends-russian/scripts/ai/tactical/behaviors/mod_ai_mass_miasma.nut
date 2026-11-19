this.mod_ai_mass_miasma <- this.inherit("scripts/ai/tactical/behavior", {
	m = {
		TargetTile = [],
		BonusScore = 0,
		PossibleSkills = [
			"actives.mass_miasma"
		],
		Skill = null
	},
	function create()
	{
		this.m.ID = ::Const.AI.Behavior.ID.Miasma;
		this.m.Order = ::Const.AI.Behavior.Order.Miasma;
		//this.m.IsThreaded = true;
		this.behavior.create();
	}

	function onEvaluate( _entity )
	{
		// Function is a generator.
		this.m.Skill = null;
		this.m.TargetTile = null;
		this.m.BonusScore = 0;
		local score = this.getProperties().BehaviorMult[this.m.ID];

		if (_entity.getActionPoints() == 0)
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		if (_entity.getMoraleState() == ::Const.MoraleState.Fleeing)
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		if (!this.getAgent().hasKnownOpponent())
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		if (_entity.isEngagedInMelee())
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		this.m.Skill = this.selectSkill(this.m.PossibleSkills);

		if (this.m.Skill == null)
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		score = score * this.getFatigueScoreMult(this.m.Skill);
		local opponents = this.getAgent().getKnownOpponents();
		/*local func = this.findBestTarget(_entity, opponents);

		while (resume func == null)
		{
			yield null;
		}*/

		this.findBestTarget(_entity, opponents);

		if (this.m.TargetTile == null)
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		local hasCombo = _entity.getSkills().getSkillByID("actives.mass_root").isSpent();
		return ::Const.AI.Behavior.Score.Miasma * (hasCombo ? 4.0 : 1.0) * score + this.m.BonusScore;
	}

	function onExecute( _entity )
	{
		if (this.m.IsFirstExecuted)
		{
			this.getAgent().adjustCameraToTarget(this.m.TargetTile);
			this.m.IsFirstExecuted = false;

			if (this.m.TargetTile.IsVisibleForPlayer && _entity.isHiddenToPlayer())
			{
				_entity.setDiscovered(true);
				_entity.getTile().addVisibilityForFaction(::Const.Faction.Player);
			}

			return false;
		}

		this.m.Skill.use(this.m.TargetTile);

		if (!_entity.isHiddenToPlayer())
		{
			this.getAgent().declareAction();
			this.getAgent().declareEvaluationDelay(this.m.Skill.getDelay() + 500);
		}

		this.m.Skill = null;
		this.m.TargetTile = null;
		return true;
	}

	function findBestTarget( _entity, _targets )
	{
		// Function is a generator.
		local list = [];
		local myTile = _entity.getTile();
		local knownAllies = this.getAgent().getKnownAllies();
		//local time = ::Time.getExactTime();

		foreach( o in _targets )
		{
			local opponentTile = o.Actor.getTile();
			local opponents = o.Actor;

			if (opponentTile.Properties.Effect != null && opponentTile.Properties.Effect.Type == "miasma" && opponentTile.Properties.Effect.Timeout - ::Time.getRound() > 3)
			{
				continue;
			}

			/*if (this.isAllottedTimeReached(time))
			{
				yield null;
				time = ::Time.getExactTime();
			}*/

			local potential = {
				Tile = opponentTile,
				Score = 0.0
			};
			local targets = [
				opponents
			];

			for( local i = 0; i < 6; i = ++i )
			{
				if (!opponentTile.hasNextTile(i))
				{
				}
				else
				{
					local adjacentTile = opponentTile.getNextTile(i);

					if (!adjacentTile.IsOccupiedByActor)
					{
					}
					else
					{
						local entity = adjacentTile.getEntity();

						if (entity.isAlliedWith(_entity) || (adjacentTile.Properties.Effect != null && adjacentTile.Properties.Effect.Type == "miasma" && adjacentTile.Properties.Effect.Timeout - ::Time.getRound() > 3))
						{
						}
						else
						{
							targets.push(entity);
						}
					}
				}
			}

			local numAffected = 0;

			foreach( target in targets )
			{
				if (target.getCurrentProperties().IsImmuneToPoison || target.getFlags().has("undead"))
				{
					continue;
				}

				local targetTile = target.getTile();
				local d = myTile.getDistanceTo(targetTile);
				local target_score = d >= 8 ? 0.0 : 8 - d;
				target_score += ::Const.AI.Behavior.MiasmaZOCBonus * targetTile.getZoneOfControlCountOtherThan(target.getAlliedFactions());

				if (target.getHitpoints() <= 10)
				{
					target_score += ::Const.AI.Behavior.MiasmaAlmostDeadBonus;
				}

				if (target.getCurrentProperties().IsStunned)
				{
					target_score += ::Const.AI.Behavior.MiasmaStunnedBonus * 2.0;
				}

				if (target.getCurrentProperties().IsRooted)
				{
					target_score += ::Const.AI.Behavior.MiasmaStunnedBonus * 2.0;
				}

				if (targetTile.Properties.Effect != null && targetTile.Properties.Effect.Type != "miasma" && targetTile.Properties.Effect.Type != "fire")
				{
					target_score += 5.0; // want to overdrive other tile effect 
				}

				if (targetTile.Properties.Effect != null && targetTile.Properties.Effect.Type == "miasma" && targetTile.Properties.Effect.Timeout - ::Time.getRound() <= 1)
				{
					target_score += 2.0;
				}

				if (!target.getCurrentProperties().IsStunned && !target.getCurrentProperties().IsRooted && !target.getTile().hasZoneOfControlOtherThan(target.getAlliedFactions()) && !target.isAbleToWait())
				{
					target_score *= ::Const.AI.Behavior.MiasmaVSWaitMult;
				}

				if (target.getCurrentProperties().DamageReceivedMiasmaMult < 1.0)
				{
					target_score *= 0.67;
				}

				if (targetTile.Properties.Effect != null && targetTile.Properties.Effect.Type == "miasma" && targetTile.Properties.Effect.Timeout - ::Time.getRound() == 3)
				{
					target_score *= 0.67;
				}

				target_score *= target.getCurrentProperties().TargetAttractionMult;
				potential.Score += target_score;
				numAffected = ++numAffected;
			}

			if (numAffected > 1)
			{
				potential.Score *= ::Math.pow(::Const.AI.Behavior.RootNumAffectedPOW, numAffected - 1);
			}

			list.push(potential);
		}

		if (list.len() == 0)
		{
			this.m.TargetTile = null;
			this.m.BonusScore = 0.0;
			return true;
		}

		list.sort(this.onSortByScore);
		this.m.TargetTile = list[0].Tile;
		this.m.BonusScore = list[0].Score;
		return true;
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

