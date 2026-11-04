this.xxitem_magicstaffaa_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.bash";
		this.m.Name = "Арканический удар";
		this.m.Description = "Атака тайной силой, которая наносит дополнительную усталость с каждым ударом.";
		this.m.Icon = "skills/active_02.png";
		this.m.IconDisabled = "skills/active_02_sw.png";
		this.m.Overlay = "active_02";
		this.m.SoundOnUse = [
			"sounds/combat/bash_01.wav",
			"sounds/combat/bash_02.wav",
			"sounds/combat/bash_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/bash_hit_01.wav",
			"sounds/combat/bash_hit_02.wav",
			"sounds/combat/bash_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.DirectDamageMult = 0.6;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 12;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 75;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Наносит [color=" + this.Const.UI.Color.DamageValue + "]" + this.Const.Combat.FatigueReceivedPerHit * 3 + "[/color] дополнительных единиц усталости"
		});
		return ret;
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInMaces ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	function onUse( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectBash);
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectBash);
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectBash);
		return this.attackEntity(_user, _targetTile.getEntity());
	}

	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
		if (_skill == this && _targetEntity.isAlive() && !_targetEntity.isDying())
		{
			this.Tactical.spawnSpriteEffect("effect_lightning_03", this.createColor("#ffffff"), _targetEntity.getTile(), 0, 10, 0.5, 1.2, 10, 350, 150);
			this.Tactical.spawnSpriteEffect("effect_lightning_03", this.createColor("#ffffff"), _targetEntity.getTile(), 0, 10, 1.2, 0.5, 10, 150, 350);
			this.Tactical.spawnSpriteEffect("effect_lightning_03", this.createColor("#ffffff"), _targetEntity.getTile(), 0, 10, 0.2, 1.5, 10, 150, 350);
			this.Tactical.spawnSpriteEffect("effect_lightning_03", this.createColor("#ffffff"), _targetEntity.getTile(), 0, 10, 1.5, 0.2, 10, 350, 150);
			for( local i = 0; i < this.Const.Tactical.LightningParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.LightningParticles[i].Brushes, _targetEntity.getTile(), this.Const.Tactical.LightningParticles[i].Delay, this.Const.Tactical.LightningParticles[i].Quantity, this.Const.Tactical.LightningParticles[i].LifeTimeQuantity, this.Const.Tactical.LightningParticles[i].SpawnRate, this.Const.Tactical.LightningParticles[i].Stages);
			}
			this.Sound.play("sounds/combat/poison_applied_0" + this.Math.rand(1, 2) + ".wav", this.Const.Sound.Volume.Skill * 0.5, _targetEntity.getPos());
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.FatigueDealtPerHitMult += 3.0;
		}
	}

});

