this.mod_ai_mass_root <- ::inherit("scripts/ai/tactical/behavior", {
	m = {
		TargetTiles = [],
		BonusScore = 0,
		PossibleSkills = [
			"actives.mass_root"
		],
		Skill = null
	},
	function create()
	{
		this.m.ID = ::Const.AI.Behavior.ID.Root;
		this.m.Order = ::Const.AI.Behavior.Order.Root;
		//this.m.IsThreaded = true;
		this.behavior.create();
	}

	function onEvaluate( _entity )
	{
		// Function is a generator.
		this.m.Skill = null;
		this.m.TargetTiles = [];
		this.m.BonusScore = 0;
		local score = this.getProperties().BehaviorMult[this.m.ID];

		if (_entity.getActionPoints() < ::Const.Movement.AutoEndTurnBelowAP)
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

		score *= this.getFatigueScoreMult(this.m.Skill);
		local opponents = this.getAgent().getKnownOpponents();
		/*local func = this.findBestTarget(_entity, opponents);

		while (resume func == null)
		{
			yield null;
		}*/

		this.findBestTarget(_entity, opponents);

		if (this.m.TargetTiles.len() == 0)
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		local hasCombo = _entity.getSkills().getSkillByID("actives.mass_miasma").isSpent();
		return ::Const.AI.Behavior.Score.Root * (hasCombo ? 2.0 : 1.0) * score + this.m.BonusScore;
	}

	function onExecute( _entity )
	{
		if (this.m.IsFirstExecuted)
		{
			this.getAgent().adjustCameraToTarget(this.m.TargetTiles[0]);
			this.m.IsFirstExecuted = false;

			if (this.m.TargetTiles[0].IsVisibleForPlayer && _entity.isHiddenToPlayer())
			{
				_entity.setDiscovered(true);
				_entity.getTile().addVisibilityForFaction(::Const.Faction.Player);
			}

			return false;
		}

		this.m.Skill.addAffectedTiles(this.m.TargetTiles);
		this.m.Skill.use(this.m.TargetTiles[0]);

		if (!_entity.isHiddenToPlayer())
		{
			this.getAgent().declareAction();
			this.getAgent().declareEvaluationDelay(this.m.Skill.getDelay() + 500);
		}

		this.m.Skill = null;
		this.m.TargetTiles = [];
		return true;
	}

	function findBestTarget( _entity, _targets )
	{
		// Function is a generator.
		local list = [];
		local myTile = _entity.getTile();
		local knownAllies = this.getAgent().getKnownAllies();
		local num = ::Math.rand(::Math.round(_targets.len() / 4), ::Math.round(_targets.len() / 2));
		//local time = ::Time.getExactTime();

		foreach( o in _targets )
		{
			local opponentTile = o.Actor.getTile();
			local opponent = o.Actor;

			if (opponent.getCurrentProperties().IsRooted || opponent.getCurrentProperties().IsImmuneToRoot)
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

			local d = myTile.getDistanceTo(opponentTile);
			potential.Score += d >= 8 ? 0.0 : 8 - d;

			if (opponent.getMoraleState() == ::Const.MoraleState.Fleeing)
			{
				potential.Score += ::Const.AI.Behavior.RootFleeingBonus;
			}

			if (opponent.getCurrentProperties().IsImmuneToPoison || opponent.getCurrentProperties().IsStunned)
			{
				potential.Score += 5.0;
			}

			if (opponent.getHitpoints() <= 10)
			{
				potential.Score += 4.0;
			}

			if (!opponent.hasRangedWeapon())
			{
				potential.Score += ::Const.AI.Behavior.RootNoRangedWeaponBonus;
			}

			if (!opponent.getTile().hasZoneOfControlOtherThan(opponent.getAlliedFactions()))
			{
				potential.Score += ::Const.AI.Behavior.RootNotEngagedBonus;

				if (this.queryActorTurnsNearTarget(opponent, myTile, _entity).Turns <= 1.0)
				{
					potential.Score += ::Const.AI.Behavior.RootDangerBonus;
				}

				local canHit = false;

				foreach( ally in knownAllies )
				{
					if (opponent.getTile().getDistanceTo(ally.getTile()) <= opponent.getIdealRange())
					{
						canHit = true;
						break;
					}
				}

				if (!canHit)
				{
					potential.Score += ::Const.AI.Behavior.RootCantAttackAnyoneBonus;
				}

				if (!canHit && opponent.isTurnDone() && opponent.getSkills().hasSkill("effects.adrenaline"))
				{
					potential.Score += ::Const.AI.Behavior.RootAdrenalineBonus;
				}
			}

			if (opponentTile.IsBadTerrain)
			{
				potential.Score += ::Const.AI.Behavior.RootBadTerrain;
			}

			if (opponentTile.Properties.Effect != null)
			{
				if (opponentTile.Properties.Effect.Type == "miasma" && !opponent.getCurrentProperties().IsImmuneToPoison && !opponent.getFlags().has("undead"))
				{
					potential.Score += ::Const.AI.Behavior.RootBadTerrain * 2;
				}
				else if (!opponentTile.Properties.Effect.IsPositive && opponentTile.Properties.Effect.Applicable(opponent))
				{
					potential.Score += ::Const.AI.Behavior.RootBadTerrain;
				}
			}

			potential.Score *= opponent.getCurrentProperties().TargetAttractionMult;
			list.push(potential);
		}

		if (list.len() == 0)
		{
			this.m.TargetTiles = [];
			this.m.BonusScore = 0.0;
			return true;
		}

		list.sort(this.onSortByScore);
		this.m.TargetTiles = [];
		this.m.BonusScore = 0.0;

		foreach (p in list)
		{
			this.m.TargetTiles.push(p.Tile);
			this.m.BonusScore += p.Score;

			if (this.m.TargetTiles.len() == num)
			{
				break;
			}
		}
		
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

