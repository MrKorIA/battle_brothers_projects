this.hemovore_poison_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 2
	},
	function create()
	{
		this.m.ID = "effects.hemovore_poison";
		this.m.Name = "Отравлен";
		this.m.Icon = "skills/status_effect_54.png";
		this.m.IconMini = "status_effect_54_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = true;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Этот персонаж был отравлен и теперь пытается устоять, едва координируя свои действия. Эффект будет длиться ещё [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] ход(а).";
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
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" * 0.90 * this.m.TurnsLeft + "[/color] к навыку ближнего боя"
			},
			{
				id = 12,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" * 0.90 * this.m.TurnsLeft + "[/color] к навыку дальнего боя"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + 10 * this.m.TurnsLeft + "[/color] к инициативе"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.MeleeSkill *= 0.90 * this.m.TurnsLeft;
		_properties.RangedSkill *= 0.90 * this.m.TurnsLeft;
		_properties.Initiative -= 10 * this.m.TurnsLeft;
	}

	function onTurnEnd()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

});
