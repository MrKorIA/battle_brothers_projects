this.ai_anti_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 3
	},
	function create()
	{
		this.m.ID = "effects.ai_anti_effect";
		this.m.Name = "Immune to Poison and Bleeding";
		this.m.Icon = "skills/status_effect_118.png";
		this.m.IconMini = "status_effect_118_mini";
		this.m.Overlay = "status_effect_118";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Этот персонаж обладает иммунитетом к любому виду яда и кровотечению для другого [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] ход(ы).";
	}

	function addTurns( _t )
	{
		this.m.TurnsLeft += _t;
	}

	function setTurns( _t )
	{
		if (this.getContainer() != null)
		{
			this.m.TurnsLeft = this.Math.max(1, _t);
		}
	}

	function onUpdate( _properties )
	{
		_properties.IsImmuneToPoison = true;
		_properties.IsImmuneToBleeding = true;
	}

	function onTurnEnd()
	{
		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

});

