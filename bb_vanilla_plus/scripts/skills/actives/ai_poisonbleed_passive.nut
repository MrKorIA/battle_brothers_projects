this.ai_poisonbleed_passive <- this.inherit("scripts/skills/skill", {
	//venomorph9 basiliskNtail9 bat9 bloodsucker9 finger9 spiderdemon9
	m = {
		Damage = 5
	},
	function getDamage()
	{
		return this.m.Damage;
	}

	function setDamage( _d )
	{
		this.m.Damage = _d;
	}

	function create()
	{
		this.m.ID = "effects.ai_poisonbleed_passive";
		this.m.Name = "Bleeding Poison";
		this.m.Description = "TODO";
		this.m.Icon = "";
		this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsSerialized = false;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_targetEntity.getCurrentProperties().IsImmuneToBleeding || _damageInflictedHitpoints < this.Const.Combat.MinDamageToApplyBleeding || _targetEntity.getHitpoints() <= 0)
		{
			return;
		}

		if (!_targetEntity.isAlive())
		{
			return;
		}

		if (_targetEntity.getFlags().has("undead"))
		{
			return;
		}

		local effect = this.new("scripts/skills/effects/bleeding_effect");
		effect.setDamage(this.m.Damage);
		_targetEntity.getSkills().add(effect);
	}

});

