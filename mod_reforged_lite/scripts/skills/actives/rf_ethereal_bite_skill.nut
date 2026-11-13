this.rf_ethereal_bite_skill <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.rf_ethereal_bite";
		this.m.Name = "Эфирный укус";
		this.m.Description = "Прогрызть плоть жертвы, игнорируя любые физические препятствия.";
		this.m.KilledString = "Истерзан";
		this.m.Icon = "skills/rf_ethereal_bite_skill.png";
		this.m.IconDisabled = "skills/rf_ethereal_bite_skill_sw.png";
		this.m.Overlay = "rf_ethereal_bite_skill";
		this.m.SoundOnUse = [
			"sounds/enemies/rf_hollenhund_bite_01.wav"
			"sounds/enemies/rf_hollenhund_bite_02.wav"
			"sounds/enemies/rf_hollenhund_bite_03.wav"
		];
		this.m.Type = ::Const.SkillType.Active;
		this.m.Order = ::Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsAttack = true;
		this.m.IsUsingActorPitch = true;
		this.m.InjuriesOnBody = ::Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = ::Const.Injury.CuttingHead;
		this.m.DirectDamageMult = 1.0;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function getTooltip()
	{
		local ret = this.skill.getDefaultTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Поражённые цели получают эффект [$ $|Skill+rf_grave_chill_effect]")
			children = ::new("scripts/skills/effects/rf_grave_chill_effect").getTooltip().slice(2) // slice 2 to remove name and description
		});
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.DamageRegularMin += 15;
		_properties.DamageRegularMax += 25;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.DamageArmorMult *= 0.0;
			_properties.IsIgnoringArmorOnAttack = true;
		}
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();

		local ret = this.attackEntity(_user, target);
		if (ret)
		{
			target.getSkills().add(::new("scripts/skills/effects/rf_grave_chill_effect"));
		}

		return ret;
	}
});

