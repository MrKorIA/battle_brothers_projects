this.rf_draugr_restless_effect <- ::inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.rf_draugr_restless";
		this.m.Name = "Неугомонность";
		this.m.Description = "Этот курганник стал неугомонным, двигаясь быстрее и нанося удары с неистовой яростью.";
		this.m.Icon = "skills/rf_draugr_restless_effect.png";
		// this.m.IconMini = "rf_draugr_restless_effect_mini";
		this.m.Overlay = "rf_draugr_restless_effect";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		local mult = this.getMeleeSkillMult();

		if (mult != 1.0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(mult) + " к [навыку ближнего боя|Concept.MeleeSkill]")
			});
		}

		mult = this.getInitiativeMult();
		if (mult != 1.0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = ::ReforgedLite.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(mult) + " к [инициативе|Concept.Initiative]")
			});
		}

		ret.push({
			id = 12,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Получает навык [$ $|Skill+perk_overwhelm]")
		});

		return ret;
	}

	function onAdded()
	{
		this.getContainer().add(this.new("scripts/skills/perks/perk_overwhelm", function(o) {
			o.m.IsSerialized = false;
			o.m.IsRefundable = false;
		}));
	}

	function onRemoved()
	{
		this.getContainer().removeByIDByStack("perk.overwhelm", false);
	}

	function onUpdate( _properties )
	{
		_properties.MeleeSkillMult *= this.getMeleeSkillMult();
		_properties.InitiativeMult *= this.getInitiativeMult();
	}

	function getMeleeSkillMult()
	{
		return 1.1;
	}

	function getInitiativeMult()
	{
		return 1.5;
	}
});
