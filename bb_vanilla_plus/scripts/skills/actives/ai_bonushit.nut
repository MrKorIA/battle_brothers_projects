this.ai_bonushit <- this.inherit("scripts/skills/skill", {
	m = {
		Stacks = 0,
		Frame = 0,
		SkillCount = 0
	},
	function create()
	{
		this.m.ID = "effects.ai_bonushit";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsSerialized = false;
		this.m.IsActive = false;
		this.m.IsHidden = true;
		this.m.IsStacking = false;
		this.m.HitChanceBonus = 4;
	}

	function isBonusActive()
	{
		return this.m.Stacks != 0;
	}

	function onUpdate( _properties )
	{
		this.m.IsHidden = this.m.Stacks == 0;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_targetEntity != null && this.isKindOf(_targetEntity, "actor"))
		{
			local dirty = this.m.Stacks != 0;
			this.m.Stacks = 0;
			this.m.Frame = 0;
			this.m.SkillCount = 0;
			this.m.IsHidden = true;
			if (dirty)
			{
				this.getContainer().getActor().setDirty(true);
			}
		}
	}

	function onTargetMissed( _skill, _targetEntity )
	{
		if (this.Time.getFrame() != this.m.Frame && this.m.SkillCount != this.Const.SkillCounter)
		{
			++this.m.Stacks;
			this.m.Frame = this.Time.getFrame();
			this.m.SkillCount = this.Const.SkillCounter;
			this.m.IsHidden = false;
			if (this.m.Stacks == 1)
			{
				this.getContainer().getActor().setDirty(true);
			}
		}
	}

	function onCombatStarted()
	{
		this.m.Stacks = 0;
		this.m.Frame = 0;
		this.m.SkillCount = 0;
		this.m.IsHidden = true;
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.Stacks = 0;
		this.m.Frame = 0;
		this.m.SkillCount = 0;
		this.m.IsHidden = true;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (this.m.Stacks != 0 && _skill.isAttack())
		{
			_properties.MeleeSkill += this.m.HitChanceBonus * this.m.Stacks;
			_properties.RangedSkill += this.m.HitChanceBonus * this.m.Stacks;
		}
	}

});
