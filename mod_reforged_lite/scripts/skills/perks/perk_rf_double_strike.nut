this.perk_rf_double_strike <- ::inherit("scripts/skills/skill", {
	m = {
		IsInEffect = false
		DamageBonus = 20
	},
	function create()
	{
		this.m.ID = "perk.rf_double_strike";
		this.m.Name = ::Const.Strings.PerkName.RF_DoubleStrike;
		this.m.Description = "Этот персонаж только что ударил врага, и он готов ударить ещё сильнее! Следующая атака нанесёт больше урона. После промаха эффект исчезнет.";
		this.m.Icon = "ui/perks/perk_rf_double_strike.png";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	function isHidden()
	{
		return !this.m.IsInEffect;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/regular_damage.png",
			text = "Атаки одиночной цели наносят на " + ::MSU.Text.colorizeValue(this.m.DamageBonus, {AddSign = true, AddPercent = true}) + " больше урона"
		});

		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/warning.png",
			text = ::ReforgedLite.Mod.Tooltips.parseString("Действие эффекта заканчивается при использовании любых умений, кроме атаки по одной цели, промахе, при перемещении, смене любого предмета, после [ожидания|Concept.Wait] или завершения [хода|Concept.Turn]")
		});

		return ret;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (this.m.IsInEffect && this.isSkillValid(_skill))
		{
			_properties.MeleeDamageMult *= 1.0 + this.m.DamageBonus * 0.01;
		}
	}

	function onAnySkillExecuted( _skill, _targetTile, _targetEntity, _forFree )
	{
		if (!this.isSkillValid(_skill))
		{
			this.m.IsInEffect = false;
		}
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		this.m.IsInEffect = this.isSkillValid(_skill);
	}

	function onTargetMissed( _skill, _targetEntity )
	{
		this.m.IsInEffect = false;
	}

	function onTurnEnd()
	{
		this.m.IsInEffect = false;
	}

	function onWaitTurn()
	{
		this.m.IsInEffect = false;
	}

	function onTurnStart()
	{
		this.m.IsInEffect = false;
	}

	function onResumeTurn()
	{
		this.m.IsInEffect = false;
	}

	function onPayForItemAction( _skill, _items )
	{
		this.m.IsInEffect = false;
	}

	function onMovementFinished()
	{
		this.m.IsInEffect = false;
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.IsInEffect = false;
	}

	function isSkillValid( _skill )
	{
		return _skill.isAttack() && !_skill.isRanged() && !_skill.isAOE();
	}
});
