this.cunmin01 <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.cunmin01";
		this.m.Name = "Укус";
		this.m.Description = "";
		this.m.KilledString = "Загрызен";
		this.m.Icon = "skills/active_24.png";
		this.m.IconDisabled = "skills/active_24_sw.png";
		this.m.Overlay = "active_24";
		this.m.SoundOnUse = [
			"sounds/enemies/zombie_bite_01.wav",
			"sounds/enemies/zombie_bite_02.wav",
			"sounds/enemies/zombie_bite_03.wav",
			"sounds/enemies/zombie_bite_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
		this.m.DirectDamageMult = 0.1;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 5;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function isUsable()
	{
		local mainhand = this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		return (mainhand == null || this.getContainer().hasSkill("effects.disarmed")) && this.skill.isUsable();
	}

	function onUpdate( _properties )
	{
		_properties.DamageRegularMin += 25;
		_properties.DamageRegularMax += 40;
		_properties.DamageArmorMult *= 0.75;
		local size = this.getContainer().getActor().getSize();
		this.m.ChanceDecapitate = 25 * size;
		this.m.ChanceDisembowel = 25 * size;
	}

	function onUse( _user, _targetTile )
    {
		local target = _targetTile.getEntity();
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectBash);
		local success = this.attackEntity(_user, target);

		if (!_user.isAlive() || _user.isDying())
		{
			return success;
		}

		if (success && target.isAlive())
		{
			target.getSkills().add(this.new("scripts/skills/effects/horrified_effect"));

			if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " наносит удар, который приводит " + this.Const.UI.getColorizedEntityName(_targetTile.getEntity()) + " в ужас");
			}
		}

		return success;
	}
});
