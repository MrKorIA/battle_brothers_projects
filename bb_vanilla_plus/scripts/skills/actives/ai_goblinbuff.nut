this.ai_goblinbuff <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.ai_goblinbuff";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsSerialized = false;
		this.m.IsActive = false;
		this.m.IsHidden = true;
		this.m.IsStacking = false;
	}

	function onBeingAttacked( _attacker, _skill, _properties )
	{
		local dist = _attacker.getTile().getDistanceTo(this.getContainer().getActor().getTile());
		if (dist > 1)
		{
			_properties.MeleeDefense += (dist - 1) * 20;
			_properties.RangedDefense += (dist - 1) * 20;
		}
	}

});

