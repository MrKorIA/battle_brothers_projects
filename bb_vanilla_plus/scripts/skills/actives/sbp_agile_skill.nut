this.sbp_agile_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sbp_agile_skill";
		this.m.Name = "Ловкий убийца";
		this.m.Icon = "ui/xxp28.png";
		this.m.Description = "Если вы быстрее цели при атаке, вы получаете +9 к навыкам ближнего и дальнего боя. Если вы быстрее атакующего при атаке, вы получаете +9 к защите в ближнем и дальнем бою.";
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
		if (_targetEntity != null && _skill.isAttack())
		{
			if (this.getContainer().getActor().getInitiative() > _targetEntity.getInitiative())
			{
				_properties.MeleeSkill += 9;
				_properties.RangedSkill += 9;
			}
		}
	}

	function onBeingAttacked( _attacker, _skill, _properties )
	{
		if (_skill.isAttack() && this.getContainer().getActor().getInitiative() > _attacker.getInitiative())
		{
			_properties.MeleeDefense += 9;
			_properties.RangedDefense += 9;
		}
	}

});

