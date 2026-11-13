this.rf_sword_thrust_skill <- ::inherit("scripts/skills/skill", {
	m = {
		MeleeSkillAdd = -20
	},
	function create()
	{
		this.m.ID = "actives.rf_sword_thrust";
		this.m.Name = "Прорыв с мечом";
		this.m.Description = "Хорошо поставленная атака, направленная на бреши в броне противника. Попасть может быть непросто, но уязвимости есть даже в самой тяжёлой броне.";
		this.m.KilledString = "Пронзён";
		this.m.Icon = "skills/active_30.png";
		this.m.IconDisabled = "skills/active_30_sw.png";
		this.m.Overlay = "active_30";
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
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsAttack = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = ::Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = ::Const.Injury.PiercingHead;
		// this.m.HitChanceBonus = -20; Set to 0 by Modular Vanilla
		this.m.DirectDamageMult = 0.25;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();

		if (this.m.MeleeSkillAdd != 0)
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "" + ::MSU.Text.colorizeValue(this.m.MeleeSkillAdd, {AddSign = true, AddPercent = true}) + " к шансу на попадание"
			});
		}

		return ret;
	}

	function onAfterUpdate( _properties )
	{
		if (_properties.IsSpecializedInSwords)
		{
			this.m.FatigueCostMult *= ::Const.Combat.WeaponSpecFatigueMult;
		}
	}

	function onUse( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, ::Const.Tactical.AttackEffectThrust);
		return this.attackEntity(_user, _targetTile.getEntity());
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			if (!this.getContainer().getActor().isPlayerControlled())
			{
				_properties.MeleeSkill += this.m.MeleeSkillAdd;
			}
			// this.m.HitChanceBonus is set by Modular Vanilla based on changes to _properties.MeleeSkill
		}
	}
});
