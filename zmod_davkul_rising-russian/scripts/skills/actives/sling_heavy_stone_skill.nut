this.sling_heavy_stone_skill <- this.inherit("scripts/skills/actives/sling_stone_skill", {
	m = {
		AdditionAccuracyBonus = -10,
		ArmorDmgMult = 2.0,
		DamageRegularMin = 20,
		DamageRegularMax = 20
	},
	function create()
	{
		this.sling_stone_skill.create()
		this.m.ID = "actives.sling_heavy_stone";
		this.m.Name = "Праща с тяжёлым камнем";
		this.m.Description = "Направьте тяжёлый камень в цель с помощью пращи, чтобы разрушить броню и выбить из него дух. Повреждает щиты при попадании. Имеет высокий шанс сокрушить врага смертельным ударом.";
		this.m.Icon = "skills/sling_heavy_stone.png";
		this.m.IconDisabled = "skills/sling_heavy_stone_sw.png";
		this.m.Overlay = "active_12";
		this.m.ProjectileTimeScale = 1.5;
		this.m.DirectDamageMult = 0.5;
		this.m.ActionPointCost = 6;
		this.m.MaxRange = 5;
		this.m.ChanceSmash = 75;
	}

	function getTooltip()
	{
		local p = this.getContainer().buildPropertiesForUse(this, null);
		local f = this.m.ArmorDmgMult;
		local damage_regular_min = this.Math.floor(p.DamageRegularMin * p.DamageRegularMult * p.DamageTotalMult * (this.m.IsRanged ? p.RangedDamageMult : p.MeleeDamageMult) * p.DamageTooltipMinMult);
		local damage_regular_max = this.Math.floor(p.DamageRegularMax * p.DamageRegularMult * p.DamageTotalMult * (this.m.IsRanged ? p.RangedDamageMult : p.MeleeDamageMult) * p.DamageTooltipMaxMult);
		local damage_direct_min = this.Math.floor(damage_regular_min * this.Math.minf(1.0, p.DamageDirectMult * (this.m.DirectDamageMult + p.DamageDirectAdd)));
		local damage_direct_max = this.Math.floor(damage_regular_max * this.Math.minf(1.0, p.DamageDirectMult * (this.m.DirectDamageMult + p.DamageDirectAdd)));
		local damage_armor_min = this.Math.floor(p.DamageRegularMin * f * p.DamageArmorMult * p.DamageTotalMult * (this.m.IsRanged ? p.RangedDamageMult : p.MeleeDamageMult) * p.DamageTooltipMinMult);
		local damage_armor_max = this.Math.floor(p.DamageRegularMax * f * p.DamageArmorMult * p.DamageTotalMult * (this.m.IsRanged ? p.RangedDamageMult : p.MeleeDamageMult) * p.DamageTooltipMaxMult);
		local shieldDamage = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).getShieldDamage()
		local ret = this.getDefaultUtilityTooltip();
		local accBonus = this.m.AdditionalAccuracy + this.m.AdditionAccuracyBonus
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/regular_damage.png",
			text = "Наносит [color=" + this.Const.UI.Color.DamageValue + "]" + damage_regular_min + "[/color] - [color=" + this.Const.UI.Color.DamageValue + "]" + damage_regular_max + "[/color] урона ОЗ, из которого [color=" + this.Const.UI.Color.DamageValue + "]0[/color] - [color=" + this.Const.UI.Color.DamageValue + "]" + damage_direct_max + "[/color] игнорируют броню"
		});

		if (damage_armor_max > 0)
		{
			ret.push({
				id = 5,
				type = "text",
				icon = "ui/icons/armor_damage.png",
				text = "Наносит [color=" + this.Const.UI.Color.DamageValue + "]" + damage_armor_min + "[/color] - [color=" + this.Const.UI.Color.DamageValue + "]" + damage_armor_max + "[/color] урона броне"
			});
		}
		ret.push(
			{
				id = 6,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Имеет дальность в [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] клеток на равнине. При стрельбе с возвышенности дальность увеличивается"
			}
		);

		if (accBonus == 0)
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + (-5 + this.m.AdditionalHitChance) + "%[/color] к шансу на попадание за каждую клетку до цели"
			});
		}
		else if (accBonus > 0)
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + accBonus + "%[/color] к шансу на попадание и [color=" + this.Const.UI.Color.NegativeValue + "]" + (-5 + this.m.AdditionalHitChance) + "%[/color] за каждую клетку до цели"
			});
		}
		else
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + accBonus + "%[/color] к шансу на попадание и [color=" + this.Const.UI.Color.NegativeValue + "]" + (-5 + this.m.AdditionalHitChance) + "%[/color] за каждую клетку до цели"
			});
		}

		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Шанс [color=" + this.Const.UI.Color.PositiveValue + "]100%[/color] выбить дух из противника при попадании"
		});
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/shield_damage.png",
			text = "Наносит [color=" + this.Const.UI.Color.DamageValue + "]" + shieldDamage + "[/color] урона щиту"
		});

		
		if (this.Tactical.isActive() && this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Нельзя использовать, пока этот персонаж находится в режиме ближнего боя[/color]"
			});
		}

		return ret;
	}


	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.RangedSkill += this.m.AdditionalAccuracy + this.m.AdditionAccuracyBonus;
			_properties.HitChanceAdditionalWithEachTile += -5 + this.m.AdditionalHitChance;
			_properties.DamageArmorMult *= this.m.ArmorDmgMult;
			_properties.DamageRegularMin += this.m.DamageRegularMin;
			_properties.DamageRegularMax += this.m.DamageRegularMax;
		}
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_skill == this && _targetEntity.isAlive() && !_targetEntity.isDying())
		{
			local targetTile = _targetEntity.getTile();
			local user = this.getContainer().getActor();

			_targetEntity.getSkills().add(this.new("scripts/skills/effects/dazed_effect"));

			if (!user.isHiddenToPlayer() && targetTile.IsVisibleForPlayer)
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(user) + " наносит удар, в результате которого из " + this.Const.UI.getColorizedEntityName(_targetEntity) + " выбит дух");
			}
		}
	}
	function onShieldHit( _info )
	{
		local shield = _info.Shield;
		local user = _info.User;
		local targetEntity = _info.TargetEntity;
		local damage = user.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).getShieldDamage();

		if (_info.Skill.m.SoundOnHitShield.len() != 0)
		{
			this.Sound.play(_info.Skill.m.SoundOnHitShield[this.Math.rand(0, _info.Skill.m.SoundOnHitShield.len() - 1)], this.Const.Sound.Volume.Skill, user.getPos());
		}

		shield.applyShieldDamage(damage, _info.Skill.m.SoundOnHitShield.len() == 0);

		if (shield.getCondition() == 0)
		{
			if (!user.isHiddenToPlayer())
			{
				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(user) + " уничтожил щит противника " + this.Const.UI.getColorizedEntityName(targetEntity) + "");
			}
		}
		else
		{
			if (!user.isHiddenToPlayer())
			{
				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(user) + " наносит [color=#333333]щиту[/color] персонажа " + this.Const.UI.getColorizedEntityName(targetEntity) + " единицу урона.");
			}

			if (!this.Tactical.getNavigator().isTravelling(targetEntity))
			{
				this.Tactical.getShaker().shake(targetEntity, user.getTile(), 2, this.Const.Combat.ShakeEffectSplitShieldColor, this.Const.Combat.ShakeEffectSplitShieldHighlight, this.Const.Combat.ShakeEffectSplitShieldFactor, 1.0, [
					"shield_icon"
				], 1.0);
			}
		}

		_info.TargetEntity.getItems().onShieldHit(_info.User, this);
	}
});

