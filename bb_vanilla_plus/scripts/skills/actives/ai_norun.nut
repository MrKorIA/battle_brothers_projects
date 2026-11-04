this.ai_norun <- this.inherit("scripts/skills/skill", {
	//clone, mino
	m = {},
	function create()
	{
		this.m.ID = "effects.ai_norun";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsSerialized = false;
		this.m.IsActive = false;
		this.m.IsHidden = true;
		this.m.IsStacking = false;
	}

	function onTurnStart()
	{
		local actor = this.getContainer().getActor();
		if (this.m.ID == "effects.ai_norun2" && actor.getMoraleState() < this.Const.MoraleState.Wavering)
		{
			actor.setMoraleState(this.Const.MoraleState.Wavering);
		}
		else if (actor.getMoraleState() == this.Const.MoraleState.Fleeing)
		{
			if (this.Math.rand(1, 100) <= 20)
			{
				actor.setMoraleState(this.Const.MoraleState.Wavering);
			}
			else
			{
				actor.setMoraleState(this.Const.MoraleState.Breaking);
			}
		}
	}

});

