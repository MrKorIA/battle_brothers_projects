this.sacrificed_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 2,
		RoundAdded = null
	},
	function create()
	{
		this.m.ID = "effects.sacrified";
		this.m.Name = "Обезумел";
		this.m.Icon = "skills/trait_icon_66.png";
		this.m.IconMini = "frenzied_effect_mini";
		this.m.Overlay = "frenzied_effect";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Этот персонаж обезумел после того, как стал свидетелем жертвоприношения. Эффект пройдёт через [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] ход(а,ов).";
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
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]10[/color] к урону от ударов в ближнем бою"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]10[/color] к защите в ближнем бою"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "Уменьшает решимость противников в ближнем бою на [color=" + this.Const.UI.Color.PositiveValue + "]10[/color]"
			}
		];
	}

	function onAdded()
	{
		this.m.TurnsLeft = 1
		this.m.RoundAdded = this.Time.getRound()
		this.spawnIcon("frenzied_effect", this.getContainer().getActor().getTile());

	}

	function onRefresh()
	{
		this.m.TurnsLeft += 1
		this.m.RoundAdded = this.Time.getRound()
		this.spawnIcon("frenzied_effect", this.getContainer().getActor().getTile());
	}

	function onUpdate( _properties )
	{
		_properties.MeleeSkill += 10
		_properties.RangedSkill += 10
		_properties.Threat += 10
	}

	function onTurnEnd()
	{
		if (this.m.RoundAdded == this.Time.getRound()) return
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}


});

