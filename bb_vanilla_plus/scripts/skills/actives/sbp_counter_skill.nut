this.sbp_counter_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sbp_counter_skill";
		this.m.Name = "Адаптивный преобразователь";
		this.m.Icon = "ui/xxp15.png";
		this.m.Description = "Получите бонус к максимальной выносливости, навыку ближнего боя и навыку дальнего боя пропорционально защите от дальних атак.";
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
		local q = this.Math.floor(this.getContainer().getActor().getBaseProperties().RangedDefense * 0.6);
		if (q >= 1)
		{
			_properties.MeleeSkill += q;
			_properties.RangedSkill += q;
		}
	}

});

