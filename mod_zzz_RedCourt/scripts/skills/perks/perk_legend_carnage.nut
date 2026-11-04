this.perk_legend_carnage <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.legend_carnage";
		this.m.Name = "Резня";
		this.m.Description = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] к урону при атаке истекающего кровью противника.";
		this.m.Icon = "ui/perks/slaughter_circle.png";
		this.m.IconDisabled = "ui/perks/slaughter_circle_bw.png"
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function getTooltip()
	{
		local chance = this.getChance();
		return [
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
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_targetEntity == null)
			return;

		if (_targetEntity.getSkills().hasSkill("effects.bleeding") || _targetEntity.getSkills().hasSkill("effects.legend_grazed_effect") && !_targetEntity.isAlliedWith(this.getContainer().getActor()))
		{
			_properties.DamageRegularMin *= 1.1;
			_properties.DamageRegularMax *= 1.1;
		}
	}

});
