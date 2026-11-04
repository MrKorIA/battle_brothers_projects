this.perk_retglad_precise_strikes <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.retglad_precise_strikes";
        local perk = ::Const.Perks.LookupMap[this.m.ID];
        this.m.Name = perk.Name;
        this.m.Description = perk.Tooltip;
        this.m.Icon = perk.Icon;
        this.m.IconDisabled = perk.IconDisabled;
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = true;
		this.m.IsHidden = false;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_targetEntity == null)
		{
			return;
		}

		if (!_targetEntity.isAlliedWith(this.getContainer().getActor()))
		{
			if (_targetEntity.getSkills().hasSkill("effects.net")|| _targetEntity.getSkills().hasSkill("effects.web") || _targetEntity.getSkills().hasSkill("effects.rooted") || _targetEntity.getSkills().hasSkill("effects.distracted"))
			{
				local effect = this.new("scripts/skills/effects/crippled_effect");
			}
		}
	}

});
