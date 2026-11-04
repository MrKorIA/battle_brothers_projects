this.ai_psv_slime <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.ai_psv_slime";
		this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsSerialized = false;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (!_targetEntity.isAlive() || _targetEntity.isDying() || _targetEntity.isAlliedWith(this.getContainer().getActor()))
		{
			return;
		}
		if (this.Math.rand(1, 100) <= 35)
		{
			if (_targetEntity.getSkills().hasSkill("effects.dazed"))
			{
				_targetEntity.getSkills().removeByID("effects.dazed");
			}
			if (!_targetEntity.getCurrentProperties().IsImmuneToDaze)
			{
				_targetEntity.getSkills().add(this.new("scripts/skills/effects/dazed_effect"));
				if (!_targetEntity.isHiddenToPlayer())
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_targetEntity) + " is dazed for 2 turns.");
				}
			}
		}
	}

	function onTargetMissed( _skill, _targetEntity )
	{
		if (!_targetEntity.isAlive() || _targetEntity.isDying() || _targetEntity.isAlliedWith(this.getContainer().getActor()))
		{
			return;
		}
		if (this.Math.rand(1, 100) <= 35)
		{
			if (_targetEntity.getSkills().hasSkill("effects.dazed"))
			{
				_targetEntity.getSkills().removeByID("effects.dazed");
			}
			if (!_targetEntity.getCurrentProperties().IsImmuneToDaze)
			{
				_targetEntity.getSkills().add(this.new("scripts/skills/effects/dazed_effect"));
				if (!_targetEntity.isHiddenToPlayer())
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_targetEntity) + " is dazed for 2 turns.");
				}
			}
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill.getID() == "actives.ai_punch")
		{
			if (_targetEntity.getSkills().hasSkill("effects.dazed"))
			{
				_properties.MeleeSkill += 20;
			}
		}
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (_skill == null)
		{
			return;
		}
		if (_skill.m.InjuriesOnHead == this.Const.Injury.BluntHead || _skill.m.InjuriesOnBody == this.Const.Injury.BluntBody || _skill.m.InjuriesOnBody == this.Const.Injury.BluntAndPiercingBody ||
		_skill.m.InjuriesOnBody == this.Const.Injury.BurningBody || _skill.m.InjuriesOnBody == this.Const.Injury.Burning || _skill.m.InjuriesOnBody == null)
		{}
		else 
		{
			if (this.getContainer().getActor().getFlags().has("kingslime"))
			{
				_properties.DamageReceivedRegularMult *= 0.4;
			}
			else
			{
				_properties.DamageReceivedRegularMult *= 0.5;
			}
		}
	}

});

