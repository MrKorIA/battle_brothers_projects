this.sbp_lifestealer_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sbp_lifestealer_skill";
		this.m.Name = "95. Похититель жизни (пассивный)";
		this.m.Icon = "ui/xxp18.png";
		this.m.Description = "При атаке 30% урона похищает жизнь при попадании";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast + 100;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsSerialized = true;
		this.m.IsHidden = false;
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
		return ret;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_damageInflictedHitpoints <= 0)
		{
			return;
		}
		local actor = this.m.Container.getActor();
		if (actor.getHitpoints() == actor.getHitpointsMax())
		{
			return;
		}
		actor.setHitpoints(this.Math.min(actor.getHitpointsMax(), actor.getHitpoints() + this.Math.round(_damageInflictedHitpoints * 0.3)));
		actor.onUpdateInjuryLayer();
	}

});

