this.xxitem_scytheaa_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "passive.xxitem_scytheaa_skill";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsSerialized = true;
		this.m.IsHidden = true;
	}

	function onTargetKilled( _targetEntity, _skill )
	{
		local actor = this.getContainer().getActor();
		if (!actor.isAlive() || actor.isDying())
		{
			return;
		}
		if (actor.isAlliedWith(_targetEntity))
		{
			return;
		}

		local helmet = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Head);
		local armor = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
		if (helmet != null)
		{
			helmet.setArmor(this.Math.min(helmet.getArmorMax(), helmet.getArmor() + 20));
		}
		if (armor != null)
		{
			armor.setArmor(this.Math.min(armor.getArmorMax(), armor.getArmor() + 20));
		}
		actor.setHitpoints(this.Math.min(actor.getHitpointsMax(), actor.getHitpoints() + 20));
		actor.setFatigue(this.Math.max(0, actor.getFatigue() - 10));
		actor.setDirty(true);
		actor.onUpdateInjuryLayer();
		this.spawnIcon("status_effect_29", actor.getTile());
	}

});

