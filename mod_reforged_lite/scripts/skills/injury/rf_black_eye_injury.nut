this.rf_black_eye_injury <- ::inherit("scripts/skills/injury/injury", {
	m = {
		VisionModifier = -1,
		MeleeSkillMult = 0.9,
		RangedSkillMult = 0.9
	},
	function create()
	{
		this.injury.create();
		this.m.ID = "injury.rf_black_eye";
		this.m.Name = "Чёрный глаз";
		this.m.Description = "После сильного удара по глазнице остались синяк и припухлость.";
		this.m.Type = this.m.Type | ::Const.SkillType.TemporaryInjury;
		this.m.DropIcon = "rf_black_eye_injury";
		this.m.Icon = "ui/injury/rf_black_eye_injury.png";
		this.m.IconMini = "rf_black_eye_injury_mini";
		this.m.HealingTimeMin = 1;
		this.m.HealingTimeMax = 3;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		if (this.m.VisionModifier != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/vision.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorNegative(this.m.VisionModifier) + " к [обзору|Concept.SightDistance]")
			});
		}

		if (this.m.MeleeSkillMult != 1.0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorizeMult(this.m.MeleeSkillMult) + " к [навыку ближнего боя|Concept.MeleeSkill]")
			});
		}

		if (this.m.RangedSkillMult != 1.0)
		{
			ret.push({
				id = 12,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorizeMult(this.m.RangedSkillMult) + " к [навыку дальнего боя|Concept.RangeSkill]")
			});
		}

		this.addTooltipHint(ret);	// Injury Specific additional tooltips

		return ret;
	}

	function onUpdate( _properties )
	{
		this.injury.onUpdate(_properties);

		if (!_properties.IsAffectedByInjuries || this.m.IsFresh && !_properties.IsAffectedByFreshInjuries)
		{
			return;
		}

		_properties.Vision += this.m.VisionModifier;
		_properties.MeleeSkillMult *= this.m.MeleeSkillMult;
		_properties.RangedSkillMult *= this.m.RangedSkillMult;
	}
});
