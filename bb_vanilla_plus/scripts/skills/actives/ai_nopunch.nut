this.ai_nopunch <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.ai_nopunch";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsSerialized = false;
		this.m.IsHidden = true;
		this.m.IsStacking = false;
	}

	function onAdded()
	{
		if (this.m.Container.hasSkill("actives.hand_to_hand"))
		{
			this.m.Container.removeByID("actives.hand_to_hand");
		}
	}

});

