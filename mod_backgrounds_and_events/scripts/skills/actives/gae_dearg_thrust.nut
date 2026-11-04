this.gae_dearg_thrust <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.gae_dearg_thrust";
		this.m.Name = "Проклятый укол";
		this.m.Description = "Проклятый укол, полностью игнорирует броню.";
		this.m.KilledString = "Пронзён";
		this.m.Icon = "skills/active_04.png";
		this.m.IconDisabled = "skills/active_04_sw.png";
		this.m.Overlay = "active_04";
		this.m.SoundOnUse = [
			"sounds/combat/thrust_01.wav",
			"sounds/combat/thrust_02.wav",
			"sounds/combat/thrust_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/thrust_hit_01.wav",
			"sounds/combat/thrust_hit_02.wav",
			"sounds/combat/thrust_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
		this.m.HitChanceBonus = 20;
		this.m.DirectDamageMult = 1.0;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.extend([
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Полностью игнорирует броню"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20%[/color] к шансу на попадание"
			}
		]);
		return ret;
	}

	function onAfterUpdate( _properties )
	{
		if (::mods_getRegisteredMod("mod_msu")) {
			if (_properties.IsSpecializedInSpears) {
				this.m.FatigueCostMult *= ::Const.Combat.WeaponSpecFatigueMult;
			}
		} else {
			this.m.FatigueCostMult = _properties.IsSpecializedInSpears
				? ::Const.Combat.WeaponSpecFatigueMult : 1.0;
		}
	}

	function onUse( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectThrust);
		return this.attackEntity(_user, _targetTile.getEntity());
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.MeleeSkill += 20;
			_properties.DamageArmorMult *= 0.0;
			_properties.IsIgnoringArmorOnAttack = true;
		}
	}

});

