this.ai_frost_passive <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.ai_frost_passive";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsSerialized = true;
		this.m.IsHidden = true;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (!_targetEntity.isAlive() || _targetEntity.isDying() || _targetEntity.isAlliedWith(this.getContainer().getActor()))
		{
			return;
		}

		local xacid = _targetEntity.getSkills().getSkillByID("effects.chilled");
		if (xacid == null)
		{
			_targetEntity.getSkills().add(this.new("scripts/skills/effects/chilled_effect"));
		}
		else
		{
			xacid.resetTime();
		}
	}

	function onTargetMissed( _skill, _targetEntity )
	{
		if (!_targetEntity.isAlive() || _targetEntity.isDying() || _targetEntity.isAlliedWith(this.getContainer().getActor()))
		{
			return;
		}
		if (this.getContainer().getActor().getFlags().has("froster"))
		{
			return;
		}

		local xacid = _targetEntity.getSkills().getSkillByID("effects.chilled");
		if (xacid == null)
		{
			_targetEntity.getSkills().add(this.new("scripts/skills/effects/chilled_effect"));
		}
		else
		{
			xacid.resetTime();
		}
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		if (_damageHitpoints <= 10)
		{
			return;
		}
		if (_attacker == null || !_attacker.isAlive())
		{
			return;
		}
		if (_attacker.getTile().getDistanceTo(this.getContainer().getActor().getTile()) > 1)
		{
			return;
		}
		if (this.getContainer().getActor().getFlags().has("froster"))
		{
			return;
		}

		local poison = _attacker.getSkills().getSkillByID("effects.chilled");
		if (poison == null)
		{
			_attacker.getSkills().add(this.new("scripts/skills/effects/chilled_effect"));
		}
		else
		{
			poison.resetTime();
		}
	}

});

