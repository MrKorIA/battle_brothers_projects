this.perk_rf_vigilant <- ::inherit("scripts/skills/skill", {
	m = {
		CurrBonus = 0
	},
	function create()
	{
		this.m.ID = "perk.rf_vigilant";
		this.m.Name = "Бдительный";
		this.m.Description = "Этот персонаж обладает зорким взглядом и отточенными движениями. Часть оставшихся у персонажа ОД после завершения хода перейдёт в следующий.";
		this.m.Icon = "ui/perks/perk_rf_vigilant.png";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	function isHidden()
	{
		return this.m.CurrBonus == 0;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = this.m.CurrBonus + " к ОД"
		});

		return ret;
	}

	function onTurnEnd()
	{
		this.m.CurrBonus = this.getContainer().getActor().getActionPoints() / 2;
	}

	function onUpdate( _properties )
	{
		_properties.ActionPoints += this.m.CurrBonus;
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.CurrBonus = 0;
	}
});
