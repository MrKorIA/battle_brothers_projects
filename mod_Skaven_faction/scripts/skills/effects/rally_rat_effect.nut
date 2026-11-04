this.rally_rat_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.rally_rat";
		this.m.Name = "Сбор крыс";
		this.m.Description = "";
		this.m.Icon = "skills/rat_active_07.png";
		this.m.Overlay = "rat_active_07";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsHidden = true;
		this.m.IsRemovedAfterBattle = true;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		actor.setMoraleState(this.Const.MoraleState.Steady);
		this.spawnIcon(this.m.Overlay, actor.getTile());
	}

	function onTurnEnd()
	{
		this.removeSelf();
	}

});

