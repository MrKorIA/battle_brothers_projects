this.sbq16p_bsage_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sbq16p_bsage_skill";
		this.m.Name = "123. Battle Sage (passive)";
		this.m.Icon = "ui/xxp36.png";
		this.m.Description = "When Resolve is 50 or higher, Melee and Ranged Skills gain a bonus. (Max : 30)";
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
		local gg = this.getContainer().getActor().getCurrentProperties().getBravery();
		if (gg >= 50)
		{
			gg = (gg - 48) / 2;
			if (gg > 30)
			{
				gg = 30;
			}
			_properties.MeleeSkill += gg;
			_properties.RangedSkill += gg;
		}
	}

});

