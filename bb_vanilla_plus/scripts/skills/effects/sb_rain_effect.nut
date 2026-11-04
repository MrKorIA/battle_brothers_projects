this.sb_rain_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.sb_rain_effect";
		this.m.Name = "В экстремальных погодных условиях";
		this.m.Description = "-5 Навыки ближнего боя, навыки дальнего боя, защита в ближнем бою и защита в дальнем бою";
		this.m.Icon = "skills/status_effect_109.png";
		this.m.IconMini = "status_effect_109_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsSerialized = false;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function onUpdate( _properties )
	{
		_properties.MeleeSkill += -5;
		_properties.RangedSkill += -5;
		_properties.MeleeDefense += -5;
		_properties.RangedDefense += -5;
	}

});

