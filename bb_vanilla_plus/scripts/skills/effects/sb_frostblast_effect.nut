this.sb_frostblast_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 1
	},
	function create()
	{
		this.m.ID = "effects.chilled";
		this.m.Name = "Охлажденный (Морозный взрыв)";
		this.m.Icon = "skills/status_effect_109.png";
		this.m.IconMini = "status_effect_109_mini";
		this.m.Overlay = "status_effect_109";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Этот персонаж промерз до костей. Его конечности замерзли, и ему требуется приложить огромные усилия, чтобы двигаться скоординированно. Эффект постепенно исчезнет через [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] через ход(ов).";
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
				id = 10,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + 3 + "[/color] Action Points"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + 30 + "[/color] Initiative"
			}
		];
	}

	function onAdded()
	{
		if (this.getContainer().getActor().hasSprite("dirt"))
		{
			local chilled = this.getContainer().getActor().getSprite("dirt");
			chilled.setBrush("bust_frozen");
			chilled.Visible = true;
		}
	}

	function onRemoved()
	{
		if (this.getContainer().getActor().hasSprite("dirt"))
		{
			local chilled = this.getContainer().getActor().getSprite("dirt");
			chilled.resetBrush();
			chilled.Visible = false;
		}
	}

	function onUpdate( _properties )
	{
		_properties.ActionPoints -= 3;
		_properties.Initiative -= 30;
	}

	function onTurnEnd()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

});

