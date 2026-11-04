this.sb_great_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Skillcharge = 1,
		SkillchargeMax = 1
	},
	function create()
	{
		this.m.ID = "actives.sb_great_skill";
		this.m.Name = "31. Великое пробуждение";
		this.m.Description = "51% вероятность того, что заклинатель получит следующие эффекты: наносит урон от навыков дальнего боя ближайшим врагам. Стоимость навыков снижена вдвое на 1 ход.";
		this.m.Icon = "ui/xx42.png";
		this.m.IconDisabled = "ui/xx42_sw.png";
		this.m.SoundOnUse = [
			"sounds/combat/rage_01.wav",
			"sounds/combat/rage_02.wav"
		];
		this.m.SoundOnHit = [
			"sounds/enemies/lindwurm_tail_slam_hit_01.wav",
			"sounds/enemies/lindwurm_tail_slam_hit_03.wav"
		];
		this.m.SoundVolume = 1.1;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsAOE = true;
		this.m.IsRanged = true;
		this.m.IsUsingHitchance = false;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.DirectDamageMult = 0.5;
		this.m.ActionPointCost = 0;
		this.m.FatigueCost = 15;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Одинокий волк (перк): увеличивает лимит использования на +1."
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=#8f1e1e]Предупреждение:[/color] Если это умение не срабатывает, оставшиеся ОД на этот ход становятся равны 0."
		});
		if (this.Tactical.isActive())
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Можно использовать [color=#8f1e1e]" + this.m.Skillcharge + "[/color] еще раз в этом бою."
			});
		}
		else
		{
			local rr = this.getContainer().getActor().getSkills().hasSkill("perk.lone_wolf") ? 2 : 1;
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Можно использовать [color=#8f1e1e]" + rr + "[/color] еще раз в этом бою."
			});
		}
		return ret;
	}

	function onUpdate( _properties )
	{
		this.m.SkillchargeMax = this.getContainer().getActor().getSkills().hasSkill("perk.lone_wolf") ? 2 : 1;
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcharge = this.m.Skillcharge - 1
		if (this.Math.rand(1, 100) > 51)
		{
			this.getContainer().getActor().setActionPoints(0);
			return this.spawnIcon("status_effect_107", _user.getTile());
		}
		this.m.Container.add(this.new("scripts/skills/effects/sb_great_effect"));

		local ret = false;
		local ownTile = this.m.Container.getActor().getTile();
		local soundBackup = [];
		for( local i = 0; i < this.Const.Tactical.MortarImpactParticles2.len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.MortarImpactParticles2[i].Brushes, ownTile, this.Const.Tactical.MortarImpactParticles2[i].Delay, this.Const.Tactical.MortarImpactParticles2[i].Quantity * 0.5, this.Const.Tactical.MortarImpactParticles2[i].LifeTimeQuantity * 0.5, this.Const.Tactical.MortarImpactParticles2[i].SpawnRate, this.Const.Tactical.MortarImpactParticles2[i].Stages, this.createVec(0, 10));
		}
		this.Sound.play("sounds/combat/poison_applied_0" + this.Math.rand(1, 2) + ".wav", 1.5, ownTile.Pos);
		for( local i = 5; i >= 0; i = --i )
		{
			if (!ownTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = ownTile.getNextTile(i);
				for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, tile, this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity * 0.5, this.Const.Tactical.DustParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages, this.createVec(0, -30));
				}
				if (tile.IsOccupiedByActor && tile.getEntity().isAttackable() && !tile.getEntity().isAlliedWith(_user))
				{
					if (ret && soundBackup.len() == 0)
					{
						soundBackup = this.m.SoundOnHit;
						this.m.SoundOnHit = [];
					}
					local success = this.attackEntity(_user, tile.getEntity());
					ret = success || ret;
					if (!_user.isAlive() || _user.isDying())
					{
						break;
					}
				}
			}
		}
		if (ret && this.m.SoundOnHit.len() == 0)
		{
			this.m.SoundOnHit = soundBackup;
		}
		return ret;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.HitChanceMult[this.Const.BodyPart.Head] = 0;
			_properties.HitChanceMult[this.Const.BodyPart.Body] = 1;
			_properties.DamageDirectAdd = 0;
			_properties.DamageDirectMeleeAdd = 0;
			_properties.DamageDirectRangedAdd = 0;
			_properties.DamageDirectMult = 1;
			_properties.DamageRegularMin = 50;
			_properties.DamageRegularMax = 70;
			_properties.DamageArmorMult = 1.0;
		}
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}
		else if (this.m.Skillcharge <= 0)
		{
			return false;
		}
		return true;
	}

	function isHidden()
	{
		if (this.m.Skillcharge > 0)
		{
			return false;
		}

		return true;
	}

	function onCombatStarted()
	{
		this.m.Skillcharge = this.m.SkillchargeMax;
	}

	function onCombatFinished()
	{
		this.m.Skillcharge = this.m.SkillchargeMax;
	}

});

