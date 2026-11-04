this.wushiweapon32_02 <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.wushiweapon32_02";
		this.m.Name = "Укол";
		this.m.Description = "Колющий удар катаной.";
		this.m.KilledString = "Пронзён";
		this.m.Icon = "skills/wushiweapon32_02.png";
		this.m.IconDisabled = "skills/wushiweapon32_02_sw.png";
		this.m.Overlay = "wushiweapon32_02";
		this.m.SoundOnUse = [
			"sounds/combat/impale_01.wav",
			"sounds/combat/impale_02.wav",
			"sounds/combat/impale_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/impale_hit_01.wav",
			"sounds/combat/impale_hit_02.wav",
			"sounds/combat/impale_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = false;
		this.m.IsTooCloseShown = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
		this.m.DirectDamageMult = 0.3;
		this.m.HitChanceBonus = 10;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 12;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Наносит на [color=" + this.Const.UI.Color.DamageValue + "]33%[/color] больше урона и дополнительно игнорирует [color=" + this.Const.UI.Color.DamageValue + "]20%[/color] брони для целей, получивших эффекты \'Выбит дух\', \'Оглушение\' или \'Пойман в сеть\'."
		});

		return ret;
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInSwords ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	function onUse( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectImpale);
		return this.attackEntity(_user, _targetTile.getEntity());
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_targetEntity == null)
		{
			return;
		}

		local targetStatus = _targetEntity.getSkills();

		if (_skill == this && (targetStatus.hasSkill("effects.dazed") || targetStatus.hasSkill("effects.stunned") || targetStatus.hasSkill("effects.sleeping") || targetStatus.hasSkill("effects.net") || targetStatus.hasSkill("effects.web") || targetStatus.hasSkill("effects.rooted")))
		{
			_properties.DamageTotalMult *= 1.2;
			_properties.DamageDirectAdd += 0.1;
		}
	}

});

