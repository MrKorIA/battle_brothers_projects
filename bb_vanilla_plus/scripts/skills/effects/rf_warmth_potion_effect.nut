this.rf_warmth_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {
		ActionPointsAdd = 1
	},
	function create()
	{
		this.m.ID = "effects.rf_warmth_potion";
		this.m.Name = "Тоник из огненной крови";
		this.m.Description = "Благодаря приёму огненного снадобья этот персонаж полон энергии.";
		this.m.Icon = "skills/rf_warmth_potion_effect.png";
		this.m.IconMini = "rf_warmth_potion_effect_mini";
		this.m.Overlay = "rf_warmth_potion_effect";
		this.m.Type = ::Const.SkillType.StatusEffect | ::Const.SkillType.DrugEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
		this.m.IsSerialized = true;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		if (this.m.ActionPointsAdd != 0)
		{
			ret.push({
				id = 11,	type = "text",	icon = "ui/icons/action_points.png",
				text = ::MSU.Text.colorizeValue(this.m.ActionPointsAdd, {AddSign = true}) + " к ОД"
			});
		}

		ret.push({
			id = 12,	type = "text",	icon = "ui/icons/special.png",
			text = "Невосприимчивость к естественным и неестественным эффектам холода"
		});

		ret.push({
			id = 7,	type = "hint",	icon = "ui/icons/action_points.png",
			text = "Эффект будет действовать на протяжении одной битвы"
		});

		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.ActionPoints += this.m.ActionPointsAdd;
	}
});
