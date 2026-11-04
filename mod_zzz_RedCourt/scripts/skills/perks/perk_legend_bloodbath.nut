this.perk_legend_bloodbath <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.legend_bloodbath";
		this.m.Name = "Кровавая баня";
		this.m.Description = "Постоянно сохраняйте бдительность, изучайте окружение и обращайте внимание на каждую деталь в поисках подсказок.";
		this.m.Icon = "ui/perks/bloodbath_circle.png";
		this.m.IconDisabled = "ui/perks/bloodbath_circle_bw.png"
		this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function isHidden()
	{
		local bleeders = this.getBleeders();
		return bleeders == 0;
	}

	function getTooltip()
	{
		local chance = this.getChance();
		local tooltip = [
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
				text = "Даёт [color=" + this.Const.UI.Color.PositiveValue + "]+20%[/color] к инициативе."
			}
		];
		local bleeders = this.getBleeders();
		local resolveBonus = bleeders * 100;
		local fatigueRegen = this.getFatigueRegen();
		if (bleeders > 0)
		{
			tooltip.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + resolveBonus + "%[/color] к решимости"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + fatigueRegen + "%[/color] к восстановлению выносливости за ход"
			}]);
		}

		return tooltip;
	}

	function getBleeders()
	{
		if (!("Entities" in this.Tactical))
		{
			return 0;
		}
		if (this.Tactical.Entities == null)
		{
			return 0;
		}

		if (!this.Tactical.isActive())
		{
			return 0;
		}
		local count = 0.0;
		local bleeders = 0.0;

		local actors = this.Tactical.Entities.getAllInstancesAsArray();

		foreach( a in actors )
		{
			if (a.getSkills().hasSkill("effects.bleeding") || a.getSkills().hasSkill("effects.legend_grazed_effect") || a.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				bleeders += 1.0;

			}
			count += 1.0;
		}

		return (count == 0) ? 0 : bleeders / count;
	}

	function getFatigueRegen()
	{
		return this.Math.max(5, this.Math.floor(this.getBleeders() * 20));
	}

	function onUpdate( _properties )
	{
		_properties.BraveryMult += this.getBleeders();
		_properties.FatigueRecoveryRate += this.getFatigueRegen(); // up to 5 extra fatigue regen, can be achieved if at least 1/4 of all characters on the map are bleeding or have temp injuries
	}

});

