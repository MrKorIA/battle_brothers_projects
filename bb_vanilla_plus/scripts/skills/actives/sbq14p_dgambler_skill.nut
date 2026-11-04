this.sbq14p_dgambler_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sbq14p_dgambler_skill";
		this.m.Name = "121. Deadly Gambler (passive)";
		this.m.Icon = "ui/xxp34.png";
		this.m.Description = "+25% Damage. -10 Melee and Ranged Skill.";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast + 100;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsSerialized = true;
		this.m.IsHidden = false;
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

	function onUpdate( _properties )
	{
		_properties.MeleeSkill += -10;
		_properties.RangedSkill += -10;
		_properties.DamageTotalMult += 0.25;
	}

});

