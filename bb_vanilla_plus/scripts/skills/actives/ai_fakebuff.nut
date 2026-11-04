this.ai_fakebuff <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.ai_fakebuff";
		this.m.Overlay = "status_effect_106";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsSerialized = false;
		this.m.IsActive = false;
		this.m.IsHidden = false;
		this.m.IsStacking = true;
	}

	function onAdded()
	{
		this.removeSelf();
	}

	function onTurnEnd()
	{
		this.removeSelf();
	}

});

