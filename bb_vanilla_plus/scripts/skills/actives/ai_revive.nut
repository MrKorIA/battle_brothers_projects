this.ai_revive <- this.inherit("scripts/skills/skill", {
	m = {
		IsSpent = false,
		Lifetime = 1,
		LifetimeMax = 1,
		LastFrameUsed = 0
	},
	function isSpent()
	{
		return this.m.IsSpent;
	}

	function getLastFrameUsed()
	{
		return this.m.LastFrameUsed;
	}

	function create()
	{
		this.m.ID = "perk.nine_lives";
		this.m.Name = "Воскрешение (" + this.m.Lifetime + " Times)";
		this.m.Description = "Этот персонаж может возродиться из мертвых и полностью восстановиться.";
		this.m.Icon = "ui/perks/perk_07.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
	}

	function setLifetime( _d )
	{
		this.m.Lifetime = _d;
		this.m.LifetimeMax = _d;
		this.m.Name = "Воскрешение (" + this.m.Lifetime + " Times)";
	}

	function setSpent( _f )
	{
		this.m.Lifetime = this.Math.max(0, this.m.Lifetime - 1);
		this.getContainer().removeByType(this.Const.SkillType.DamageOverTime);
		local actor = this.getContainer().getActor();
		actor.setHitpoints(actor.getHitpointsMax());
		if (actor.getMoraleState() == this.Const.MoraleState.Breaking || actor.getMoraleState() == this.Const.MoraleState.Fleeing)
		{
			actor.setMoraleState(this.Const.MoraleState.Wavering);
		}
		this.Sound.play("sounds/combat/perfect_focus_01.wav", 2.1, actor.getPos());
		this.spawnIcon("perk_07", actor.getTile());
		this.m.Name = "Воскрешение (" + this.m.Lifetime + " Times)";
		if (this.m.Lifetime <= 0)
		{
			this.m.IsSpent = _f;
			this.m.LastFrameUsed = this.Time.getFrame();
		}
	}

	function onCombatStarted()
	{
		this.m.IsSpent = false;
		this.m.LastFrameUsed = 0;
		this.m.Lifetime = this.m.LifetimeMax;
	}

	function onCombatFinished()
	{
		this.m.IsSpent = false;
		this.m.LastFrameUsed = 0;
		this.m.Lifetime = this.m.LifetimeMax;
		this.skill.onCombatFinished();
	}

});

