this.perk_legend_forceful_swing<- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.legend_forceful_swing";
		this.m.Name = "Сильный Взмах";
		this.m.Description = "Используйте силу бёдер и корпуса, чтобы вкладывать больше мощи в свои удары.";
		this.m.Icon = "ui/perks/forceful_swings.png";
		this.m.IconDisabled = "ui/perks/forceful_swings_bw.png"
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
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/days_wounded.png",
				text = "Умения ближнего боя с зоной поражения наносят на [color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] больше урона."
			}
		];
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill.isRanged())
		{
			 return;
		}
		if (_skill.isAOE() && _skill.isAttack())
		{
			_properties.DamageTotalMult *= 1.1;
		}
	}

});

