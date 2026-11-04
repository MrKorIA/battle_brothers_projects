this.ai_selfkill_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 5
	},
	function create()
	{
		this.m.ID = "effects.ai_selfkill_effect";
		this.m.Name = "Ограниченный срок жизни";
		this.m.Icon = "skills/status_effect_84.png";
		this.m.IconMini = "status_effect_84_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getName()
	{
		return "Limited Life (" + this.m.TurnsLeft + " turn)";
	}

	function getDescription()
	{
		return "Этот персонаж умирает после [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] ход(ов).";
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

	function onRemoved()
	{
		local actor = this.getContainer().getActor();
		actor.kill();
	}

	function onTurnEnd()
	{
		this.m.TurnsLeft = this.m.TurnsLeft - 1;
		if (this.m.TurnsLeft <= 0)
		{
			local actor = this.getContainer().getActor();
			actor.kill();
			this.removeSelf();
		}
	}

});

