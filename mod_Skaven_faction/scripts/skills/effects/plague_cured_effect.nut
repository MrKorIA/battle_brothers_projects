this.plague_cured_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 3
	},
	function create()
	{
		this.m.ID = "effects.immune_to_plague";
		this.m.Name = "Невосприимчив к чуме";
		this.m.Icon = "skills/rat_status_effect_03.png";
		this.m.IconMini = "rat_status_effect_03_mini";
		this.m.Overlay = "rat_status_effect_03";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Этот персонаж принял лекарство от чумы и невосприимчив к любым видам чумы ещё [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] ход(ов).";
	}

	function onAdded()
	{
		this.m.TurnsLeft = 3;
	}

	function onRefresh()
	{
		this.m.TurnsLeft = 3;
		this.spawnIcon("rat_status_effect_03", this.getContainer().getActor().getTile());
	}

	function onUpdate( _properties )
	{
		_properties.IsImmuneToPlague = true;
	}

	function onTurnEnd()
	{

		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

});

