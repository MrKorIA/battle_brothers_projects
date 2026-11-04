this.xxitem_bloodringaa_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "passive.xxitem_bloodringaa_skill";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsSerialized = false;
		this.m.IsActive = false;
		this.m.IsHidden = true;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		local actor = this.getContainer().getActor();
		if (_targetEntity != null && _targetEntity.getSkills().hasSkill("effects.bleeding"))
		{
			_properties.DamageTotalMult += 0.15;
			_properties.MeleeSkill += 5;
			_properties.RangedSkill += 5;
		}
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_damageInflictedHitpoints <= 0)
		{
			return;
		}

		if (!_targetEntity.getSkills().hasSkill("effects.bleeding"))
		{
			return;
		}

		local actor = this.m.Container.getActor();

		if (actor.getHitpoints() == actor.getHitpointsMax())
		{
			return;
		}
		this.spawnIcon("status_effect_09", actor.getTile());
		actor.setHitpoints(this.Math.min(actor.getHitpointsMax(), actor.getHitpoints() + this.Math.round(_damageInflictedHitpoints * 0.3)));
		actor.onUpdateInjuryLayer();
	}

});

