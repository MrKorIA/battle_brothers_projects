this.xxitem_atkringaa_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.xxitem_atkringaa_skill";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsSerialized = false;
		this.m.IsActive = false;
		this.m.IsHidden = true;
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		if (actor.isPlacedOnMap() && actor.getTile().hasZoneOfControlOtherThan(actor.getAlliedFactions()))
		{
			_properties.DamageTotalMult += 0.25;
		}
		_properties.MeleeDefense += -10;
		_properties.RangedDefense += -10;
		_properties.DamageReceivedTotalMult *= 1.1;
	}

});

