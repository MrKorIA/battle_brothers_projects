this.enthralled_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.enthralled"; //— 
		this.m.Name = "Порабощён";
		this.m.Icon = "ui/traits/enthralled_trait.png"; 
		this.m.Description = "Старые вампиры точно знают, чего хотят смертные, и как воплотить эти желания в реальность.";
		this.m.Order = this.Const.SkillOrder.Trait - 1;	// back of the line, buddy
	}

	function getTooltip()
	{
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
				id = 12,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "Не реагирует ни на изменения боевого духа, ни на бегство или гибель союзников. Имеет повышенную устойчивость к ментальным атакам"
			},
			{
				id = 14,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+1[/color] к обзору"
			},
			{
				id = 16,
				type = "text",
				icon = "ui/icons/xp_received.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color] к получаемому опыту"
			},
			{
				id = 16,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]-10%[/color] к суточному жалованию"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.MoraleEffectMult *= 0.1;
		_properties.IsAffectedByFleeingAllies = false;
		_properties.IsAffectedByDyingAllies = false;
		_properties.Vision += 1;
		_properties.XPGainMult *= 0.90;
		_properties.MoraleCheckBravery[1] += 20;
		_properties.DailyWageMult *= 0.90;
	}

});

