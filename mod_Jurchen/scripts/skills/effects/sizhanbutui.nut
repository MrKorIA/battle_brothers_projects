this.sizhanbutui <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.sizhanbutui";
		this.m.Name = "Крепкое телосложение";
		this.m.Icon = "ui/sizhanbutui.png";
		this.m.IconMini = "sizhanbutui_mini";
		this.m.Overlay = "sizhanbutui_30";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = true;
		this.m.IsRemovedAfterBattle = true;
	}

	function onUpdate( _properties )
	{
		_properties.DamageReceivedTotalMult *= 0.5;
		_properties.TargetAttractionMult *= 0.5;
	}

});

