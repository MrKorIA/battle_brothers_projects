this.sb2_wolfride_skill <- this.inherit("scripts/skills/skill", {
	m = {
		IsSpent = false
	},
	function create()
	{
		this.m.ID = "actives.sb2_wolfride_skill";
		this.m.Name = "77. Укус";
		this.m.Description = "Волк кусает врага (навык ближнего боя)";
		this.m.KilledString = "Mangled";
		this.m.Icon = "skills/active_164.png";
		this.m.IconDisabled = "skills/active_164_sw.png";
		this.m.Overlay = "active_164";
		this.m.SoundOnUse = [
			"sounds/enemies/wolf_bite_01.wav",
			"sounds/enemies/wolf_bite_02.wav",
			"sounds/enemies/wolf_bite_03.wav",
			"sounds/enemies/wolf_bite_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 229;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsWeaponSkill = false;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
		this.m.DirectDamageMult = 0.2;
		this.m.ActionPointCost = 0;
		this.m.FatigueCost = 5;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 33;
		this.m.ChanceSmash = 0;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Перезарядка: 1 ход"
		});
		return ret;
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.m.IsSpent;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageRegularMin = 20;
			_properties.DamageRegularMax = 40;
			_properties.DamageArmorMult = 0.7;
		}
	}

	function onUse( _user, _targetTile )
	{
		this.m.IsSpent = true;
		return this.attackEntity(_user, _targetTile.getEntity());
	}

	function onTurnStart()
	{
		this.m.IsSpent = false;
	}

	function onCombatFinished()
	{
		this.m.IsSpent = false;
	}

	function isHidden()
	{
		if (this.getContainer().getActor().getSkills().hasSkill("effects.sb_wolfride_effect"))
		{
			return false;
		}
		return true;
	}

});

