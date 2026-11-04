this.vp_ghost_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.vp_ghost_effect";
		this.m.Name = "Призрачный";
		this.m.Description = "Этот персонаж призрак.";
		this.m.Icon = "skills/status_effect_35.png";
		this.m.IconMini = "status_effect_35_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsSerialized = false;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
        actor.getSprite("head").Color = this.createColor("#82fdff");
        actor.getSprite("head").Alpha = 155;
        actor.getSprite("body").Color = this.createColor("#82fdff");
		actor.getSprite("body").Alpha = 155;
		actor.setDirty(true);
		actor.m.MoraleState = this.Const.MoraleState.Ignore;
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
        actor.getSprite("head").Color = this.createColor("#82fdff");
        actor.getSprite("head").Alpha = 155;
        actor.getSprite("body").Color = this.createColor("#82fdff");
		actor.getSprite("body").Alpha = 155;
		actor.setDirty(true);
		actor.m.MoraleState = this.Const.MoraleState.Ignore;
		_properties.IsImmuneToBleeding = true;
		_properties.IsImmuneToPoison = true;
		_properties.IsAffectedByNight = false;
		_properties.IsAffectedByFleeingAllies = false;
		_properties.IsAffectedByDyingAllies = false;
		_properties.IsAffectedByFreshInjuries = false;
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();
		actor.setAlpha(255);
		actor.setDirty(true);
		foreach( i in actor.getItems().getAllItems() )
		{
			i.updateAppearance();
		}
	}

});

