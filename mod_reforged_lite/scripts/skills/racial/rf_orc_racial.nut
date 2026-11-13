this.rf_orc_racial <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "racial.rf_orc";
		this.m.Name = "Орк";
		this.m.Description = "Этот персонаж - орк.";
		this.m.Icon = "ui/orientation/orc_02_orientation.png";
		this.m.Type = ::Const.SkillType.Racial | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Last;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("[Порог|Concept.InjuryThreshold] получения [травм|Concept.InjuryTemporary] у этого персонажа выше на " + ::MSU.Text.colorPositive("25%"))
		});
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.ThresholdToReceiveInjuryMult *= 1.25;
	}
});
