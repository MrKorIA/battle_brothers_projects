this.sbp_allrounder_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sbp_allrounder_skill";
		this.m.Name = "80. Трансцендентность";
		this.m.Icon = "ui/xxp23.png";
		this.m.Description = "+2 ко всем характеристикам. (Этот навык можно изучить несколько раз)";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast + 100;
		this.m.IsActive = false;
		this.m.IsStacking = true;
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
		local rr = 2;
		_properties.MeleeSkill += rr;
		_properties.RangedSkill += rr;
		_properties.MeleeDefense += rr;
		_properties.RangedDefense += rr;
		_properties.Stamina += rr;
		_properties.Hitpoints += rr;
		_properties.Initiative += rr;
		_properties.Bravery += rr;
	}

});

