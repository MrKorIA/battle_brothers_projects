this.sb_beartrap_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Cooldown = 3,
		Skillcool = 3
	},
	function create()
	{
		this.m.ID = "actives.sb_beartrap_skill";
		this.m.Name = "Медвежий Капкан";
		this.m.Description = "Установите медвежий капкан на пустую клетку. Цель, наступившая на капкан, получает 50–90 единиц урона, игнорирующего броню, и ошеломляется. Этот урон не убивает врагов, а делает их необратимо хромыми.";
		this.m.Icon = "ui/xx40.png";
		this.m.IconDisabled = "ui/xx40_sw.png";
		this.m.Overlay = "active_rand";
		this.m.SoundOnUse = [
			"sounds/combat/repel_hit_01.wav",
			"sounds/combat/repel_hit_02.wav",
			"sounds/combat/repel_hit_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/hook_hit_01.wav",
			"sounds/combat/hook_hit_02.wav",
			"sounds/combat/hook_hit_03.wav"
		];
		this.m.SoundVolume = 1.1;
		this.m.SoundOnHitDelay = 0;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.Delay = 0;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = false;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = true;
		this.m.IsUsingHitchance = false;
		this.m.IsDoingForwardMove = true;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
		this.m.MaxLevelDifference = 4;
		this.m.ProjectileType = this.Const.ProjectileType.Bomb1;
		this.m.ProjectileTimeScale = 1.5;
		this.m.IsProjectileRotated = false;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Имеет дальность " + this.getMaxRange() + " клетку"
		});
		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		return _targetTile.IsEmpty;
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcool = 0;
		_user.getItems().unequip(_user.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));
		local p = {
			Type = "bear trap",
			Tooltip = "Установлен Медвежий капкан, он наносит урон и оглушает.",
			IsPositive = this.Math.rand(4, 6) == 4 ? true : false,
			IsAppliedAtRoundStart = true,
			IsAppliedAtTurnEnd = true,
			IsAppliedOnMovement = false,
			IsAppliedOnEnter = true,
			IsByPlayer = _user.isPlayerControlled(),
			Timeout = this.Time.getRound() + 999,
			Callback = onApplyMagicFire,
			function Applicable( _a )
			{
				return true;
			}

		};
		local t = _targetTile;
		if (t.Properties.Effect != null)
		{
			this.Tactical.Entities.removeTileEffect(t);
		}
		t.Properties.Effect = clone p;
		local particles = [];
		for( local i = 0; i < this.Const.Tactical.BeartrapParticles.len(); i = ++i )
		{
			particles.push(this.Tactical.spawnParticleEffect(false, this.Const.Tactical.BeartrapParticles[i].Brushes, t, this.Const.Tactical.BeartrapParticles[i].Delay, this.Const.Tactical.BeartrapParticles[i].Quantity, this.Const.Tactical.BeartrapParticles[i].LifeTimeQuantity, this.Const.Tactical.BeartrapParticles[i].SpawnRate, this.Const.Tactical.BeartrapParticles[i].Stages));
		}
		this.Tactical.Entities.addTileEffect(t, t.Properties.Effect, particles);
		t.clear(this.Const.Tactical.DetailFlag.Scorchmark);
		t.spawnDetail("xxtrap_01", this.Const.Tactical.DetailFlag.Scorchmark, false, true);
		if (t.IsCorpseSpawned)
		{
			this.Tactical.Entities.removeCorpse(t);
			t.clear(this.Const.Tactical.DetailFlag.Corpse);
			t.Properties.remove("Corpse");
			t.Properties.remove("IsSpawningFlies");
		}
		this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill * 1.0, t.Pos);
	}

	function onApplyMagicFire( _tile, _entity )
	{
		this.Tactical.spawnIconEffect("status_effect_119", _tile, this.Const.Tactical.Settings.SkillIconOffsetX, this.Const.Tactical.Settings.SkillIconOffsetY, this.Const.Tactical.Settings.SkillIconScale, this.Const.Tactical.Settings.SkillIconFadeInDuration, this.Const.Tactical.Settings.SkillIconStayDuration, this.Const.Tactical.Settings.SkillIconFadeOutDuration, this.Const.Tactical.Settings.SkillIconMovement);
		local sounds = [
			"sounds/combat/chop_hit_01.wav",
			"sounds/combat/chop_hit_02.wav",
			"sounds/combat/chop_hit_03.wav"
		];
		this.Sound.play(sounds[this.Math.rand(0, sounds.len() - 1)], this.Const.Sound.Volume.Skill * 1.9, _entity.getPos());
		if (_tile.Properties.Effect != null)
		{
			this.Tactical.Entities.removeTileEffect(_tile);
			_tile.clear(this.Const.Tactical.DetailFlag.Scorchmark);
			_tile.spawnDetail("corpse_part_03", this.Const.Tactical.DetailFlag.Scorchmark, false, true);
		}
		if (_entity.getCurrentProperties().DamageReceivedTotalMult > 0)
		{
			local dmg = this.Math.rand(50, 90);
			if (_entity.getHitpoints() <= dmg)
			{
				_entity.getSkills().add(this.new("scripts/skills/effects/ai_stun_effect"));
				_entity.getSkills().add(this.new("scripts/skills/effects/ai_mortalwound_effect"));
			}
			else 
			if (!_entity.getSkills().hasSkill("effects.stunned") && !_entity.getCurrentProperties().IsImmuneToStun)
			{
				_entity.getSkills().add(this.new("scripts/skills/effects/stunned_effect"));
			}
			_entity.setHitpoints(this.Math.max(_entity.getHitpoints() - dmg, 1));
			local fakeb = this.new("scripts/skills/actives/ai_fakebuff");
			fakeb.m.Overlay = "";
			_entity.getSkills().add(fakeb);
		}
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}
		else if (this.m.Skillcool < this.m.Cooldown)
		{
			return false;
		}

		return true;
	}

	function onTurnStart()
	{
		this.m.Skillcool = this.m.Skillcool + 1;
	}

	function onCombatFinished()
	{
		this.m.Skillcool = this.m.Cooldown;
	}

});

