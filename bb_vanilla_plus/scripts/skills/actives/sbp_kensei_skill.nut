this.sbp_kensei_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sbp_kensei_skill";
		this.m.Name = "Кенсай";
		this.m.Icon = "ui/xxp7.png";
		this.m.Description = "Усиливает базовый навык атаки при использовании меча. +20% к урону, +10% к пробиванию брони.";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast + 100;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsSerialized = true;
		this.m.IsHidden = true;
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
		return ret;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill.getID() == "actives.slash" || _skill.getID() == "actives.overhead_strike")
		{
			_properties.DamageTotalMult += 0.2;
			_properties.DamageDirectAdd += 0.1;
		}
	}

});

