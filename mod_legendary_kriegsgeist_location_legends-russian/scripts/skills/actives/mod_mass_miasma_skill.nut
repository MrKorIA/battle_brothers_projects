this.mod_mass_miasma_skill <- this.inherit("scripts/skills/skill", {
	m = {
		AffectedTiles = [],
		IsSpent = false
		Count = 0
	},
	function isSpent()
	{
		//return this.m.IsSpent;
		return this.m.Count >= 2;
	}

	function create()
	{
		this.m.ID = "actives.mass_miasma";
		this.m.Name = "Миазмы";
		this.m.Description = "";
		this.m.Icon = "skills/active_101.png";
		this.m.IconDisabled = "skills/active_101.png";
		this.m.Overlay = "active_101";
		this.m.SoundOnUse = [
			"sounds/enemies/miasma_spell_01.wav",
			"sounds/enemies/miasma_spell_02.wav",
			"sounds/enemies/miasma_spell_03.wav"
		];
		this.m.SoundOnHitHitpoints = [
			"sounds/humans/human_coughing_01.wav",
			"sounds/humans/human_coughing_02.wav",
			"sounds/humans/human_coughing_03.wav",
			"sounds/humans/human_coughing_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted;
		this.m.Delay = 500;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsUsingHitchance = false;
		this.m.IsDoingForwardMove = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.ActionPointCost = 1;
		this.m.FatigueCost = 0;
		this.m.MinRange = 1;
		this.m.MaxRange = 99;
		this.m.MaxLevelDifference = 4;
	}

	function getAffectedTiles()
	{
		return this.m.AffectedTiles;
	}

	function addAffectedTiles( _array )
	{
		this.m.AffectedTiles.extend(_array);
	}

	function clearAffectTiles()
	{
		this.m.AffectedTiles = [];
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return true;
	}

	function isViableTarget( _user, _target )
	{
		if (_target.getFlags().has("undead"))
		{
			return false;
		}

		if (_target.getCurrentProperties().IsImmuneToPoison)
		{
			return false;
		}

		return true;
	}

	function onTurnStart()
	{
		//this.m.IsSpent = false;
		this.m.Count = 0;
	}

	function onUse( _user, _targetTile )
	{
		++this.m.Count;
		local targets = [];
		targets.push(_targetTile);

		for( local i = 0; i != 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				targets.push(_targetTile.getNextTile(i));
			}
		}


		local defaultTimeout = ::Time.getRound() + 3;
		local p = {
			Type = "miasma",
			Tooltip = "Миазмы скопились здесь, отравляя любое живое создание",
			IsPositive = false,
			IsAppliedAtRoundStart = false,
			IsAppliedAtTurnEnd = true,
			IsAppliedOnMovement = false,
			IsAppliedOnEnter = false,
			IsByPlayer = false,
			Timeout = defaultTimeout,
			Callback = ::Const.Tactical.Common.onApplyMiasma,
			function Applicable( _a )
			{
				return !_a.getFlags().has("undead");
			}

		};

		foreach( tile in targets )
		{
			if (tile.Properties.Effect != null && tile.Properties.Effect.Type == "miasma")
			{
				local currentTimeout = tile.Properties.Effect.Timeout;
				tile.Properties.Effect.Timeout = currentTimeout >= defaultTimeout ? defaultTimeout + 1 : defaultTimeout;

				if (tile.IsOccupiedByActor && tile.getEntity().isAlive() && !tile.getEntity().isDying())
				{
					::Const.Tactical.Common.onApplyMiasma(tile, tile.getEntity());
				}
			}
			else
			{
				if (tile.Properties.Effect != null)
				{
					::Tactical.Entities.removeTileEffect(tile);
				}

				tile.Properties.Effect = clone p;
				local particles = [];

				for( local i = 0; i < ::Const.Tactical.MiasmaParticles.len(); i = ++i )
				{
					particles.push(::Tactical.spawnParticleEffect(true, ::Const.Tactical.MiasmaParticles[i].Brushes, tile, ::Const.Tactical.MiasmaParticles[i].Delay, ::Const.Tactical.MiasmaParticles[i].Quantity, ::Const.Tactical.MiasmaParticles[i].LifeTimeQuantity, ::Const.Tactical.MiasmaParticles[i].SpawnRate, ::Const.Tactical.MiasmaParticles[i].Stages));
				}

				::Tactical.Entities.addTileEffect(tile, tile.Properties.Effect, particles);
			}
		}

		this.clearAffectTiles();
		return true;
	}

});

