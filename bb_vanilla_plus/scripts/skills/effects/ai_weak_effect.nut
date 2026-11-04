this.ai_weak_effect <- this.inherit("scripts/skills/skill", {
//sb_mark, sbp_agile, sbp_beater, xxitem_meteoraa
	m = {
		Count = 1,
		TurnsLeft = 2,
		TurnsBase = 2
	},
	function create()
	{
		this.m.ID = "effects.ai_weak_effect";
		this.m.Name = "Раскрыть слабость (сила эффекта " + this.m.Count + ")";
		this.m.Icon = "skills/status_effect_53.png";
		this.m.IconMini = "status_effect_53_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Этот персонаж имеет пониженную защиту в ближнем и дальнем бою для [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] ход(ов).";
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
				id = 11,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-" + this.Math.maxf(1, 1 * this.m.Count) + "%[/color] ближнего и дальнего боя."
			}
		];
	}

	function onRefresh()
	{
		++this.m.Count;
		this.m.TurnsLeft = this.m.TurnsBase;
		this.m.Name = "Раскрыть слабость (сила эффекта " + this.m.Count + ")";
	}

	function onUpdate( _properties )
	{
		_properties.MeleeDefense -= this.Math.maxf(1, 1 * this.m.Count);
		_properties.RangedDefense -= this.Math.maxf(1, 1 * this.m.Count);
	}

	function onTurnEnd()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

});

