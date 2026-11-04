this.ai_damaged_move <- this.inherit("scripts/skills/skill", {
	m = {
		IsSpent = 0
	},
	function create()
	{
		this.m.ID = "effects.ai_damaged_move";
		this.m.Name = "Экстренное уклонение";
		this.m.Description = "";
		this.m.Icon = "";
		this.m.SoundOnUse = [
			"sounds/enemies/vampire_takeoff_01.wav",
			"sounds/enemies/vampire_takeoff_02.wav",
			"sounds/enemies/vampire_takeoff_03.wav"
		];
		this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsSerialized = false;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		local actor = this.getContainer().getActor();

		if (!actor.isAlive() || actor.isDying() || actor.getCurrentProperties().IsRooted || actor.getCurrentProperties().IsStunned)
		{
			return;
		}

		if (!actor.getSkills().hasSkill("effects.xxitem_horse_skill"))
		{
			return;
		}

		if (_damageHitpoints <= 5)
		{
			return;
		}

		if (_damageHitpoints >= actor.getHitpoints())
		{
			return;
		}

		if (this.m.IsSpent == 1)
		{
			return;
		}

		this.m.IsSpent = 1;
		local tag = {
			Actor = actor,
			Skill = this
		};
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 1, this.onTeleportStart, tag);
	}

	function onTeleportStart( _tag )
	{
		if (!_tag.Actor.isAlive() || _tag.Actor.isDying())
		{
			return;
		}
		local actor = _tag.Actor;
		local skill = _tag.Skill;
		local targetTile = actor.getTile();
		local nono = 0;
		for( local i = 5; i >= 0; i = --i )
		{
			if (targetTile.hasNextTile(i))
			{
				local ptile = targetTile.getNextTile(i);
				if (ptile.IsOccupiedByActor && ptile.getEntity().isAttackable() && this.Math.abs(ptile.Level - targetTile.Level) <= 1 && !ptile.getEntity().isAlliedWith(actor))
				{
					nono = 1;
					break;
				}
			}
		}
		if (nono == 0)
		{
			return;
		}
		local tiles = [];
		this.Tactical.queryTilesInRange(targetTile, 3, 4, false, [], skill.onQueryTargetTile, tiles);
		if (tiles.len() > 0)
		{
			skill.spawnIcon("perk_25_active", targetTile);			
			if (skill.m.SoundOnUse.len() > 0)
			{
				this.Sound.play(skill.m.SoundOnUse[this.Math.rand(0, skill.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill);
			}
			for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, targetTile, this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity * 0.5, this.Const.Tactical.DustParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages);
			}

			local tile = tiles[this.Math.rand(0, tiles.len() - 1)];
			this.Tactical.getNavigator().teleport(actor, tile, null, null, false, 2);
			for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, tile, this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity * 0.5, this.Const.Tactical.DustParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages);
			}
		}
	}

	function onQueryTargetTile(_tile, _tag)
	{
		if (_tile == null)
		{
			return;
		}
		if (!this.Tactical.isValidTileSquare(_tile.Coords.X, _tile.Coords.Y))
		{
			return;
		}
		if (_tile.Type == this.Const.Tactical.TerrainType.Impassable)
		{
			return;
		}
		if (!_tile.IsEmpty)
		{
			return;
		}
		_tag.push(_tile);
	}

	function onCombatFinished()
	{
		this.m.IsSpent = 0;
	}

});

