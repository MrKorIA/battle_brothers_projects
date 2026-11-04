this.ai_blackdragon_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Skillcharge = 0
	},

	function create()
	{
		this.m.ID = "actives.ai_punch";
		this.m.Name = "Атака Черного Дракона";
		this.m.SoundOnUse = [
			"sounds/enemies/lindwurm_gorge_01.wav",
			"sounds/enemies/lindwurm_gorge_02.wav",
			"sounds/enemies/lindwurm_gorge_03.wav"
		];
		this.m.SoundOnHitHitpoints = [
			"sounds/combat/overhead_strike_hit_01.wav",
			"sounds/combat/overhead_strike_hit_02.wav",
			"sounds/combat/overhead_strike_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.DirectDamageMult = 0.3;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			local actor = this.getContainer().getActor();
			actor.getBaseProperties().MeleeSkill += 1;
			_properties.DamageRegularMin += 70;
			_properties.DamageRegularMax += 110;
			_properties.DamageArmorMult *= 1.3;

			if (_targetEntity.getFlags().has("human"))
			{
				if (this.Math.rand(1, 100) <= 15)
				{
					_properties.MeleeSkill += 500;
				}
			}
			else
			{
				actor.getBaseProperties().MeleeSkill += 5;
				_properties.MeleeSkill += 500;
				_properties.DamageRegularMin += 700;
				_properties.DamageRegularMax += 700;
			}
		}
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcharge = this.m.Skillcharge + 1;
		if (this.m.Skillcharge >= 3)
		{
			this.m.Skillcharge = 0;
			this.spawnIcon("perk_25_active", _user.getTile());
			this.Sound.play("sounds/enemies/vampire_takeoff_01.wav", this.Const.Sound.Volume.Skill * 2.25, _targetTile.Pos);
			for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, _user.getTile(), this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity * 0.5, this.Const.Tactical.DustParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages);
			}
		}
		else
		{
			this.spawnIcon("active_21", _user.getTile());
			this.Sound.play("sounds/combat/overhead_strike_01.wav", this.Const.Sound.Volume.Skill * 1.1, _targetTile.Pos);
			this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectClaws);
			return this.attackEntity(_user, _targetTile.getEntity());
		}
		local attempts = 0;
		local nn = 0;
		while (attempts++ < 800)
		{
			local x = this.Math.rand(_targetTile.SquareCoords.X - 10, _targetTile.SquareCoords.X + 10);
			local y = this.Math.rand(_targetTile.SquareCoords.Y - 10, _targetTile.SquareCoords.Y + 10);
			if (!this.Tactical.isValidTileSquare(x, y))
			{
				continue;
			}
			local tile = this.Tactical.getTileSquare(x, y);
			if (tile.IsEmpty && tile.Type != this.Const.Tactical.TerrainType.Impassable && _targetTile.getDistanceTo(tile) > 5 && _targetTile.getDistanceTo(tile) < 9)
			{
				this.Tactical.getNavigator().teleport(_user, tile, null, null, false, 2);
				if (tile.IsVisibleForPlayer)
				{
					this.Tactical.CameraDirector.addMoveToTileEvent(0.5, tile);
				}
				for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, tile, this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity * 0.5, this.Const.Tactical.DustParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages);
				}
				nn = 1;
			}
			if (nn == 1)
			{
				break;
			}
		}
		return true;
	}

	function onCombatFinished()
	{
		this.m.Skillcharge = 0;
	}

});

