this.ai_riposte_effect <- this.inherit("scripts/skills/skill", {
	m = {
		RiposteCounter = 0
	},
	function create()
	{
		this.m.ID = "effects.riposte";
		this.m.Name = "Advanced Riposte";
		this.m.Icon = "skills/status_effect_33.png";
		this.m.IconMini = "status_effect_33_mini";
		this.m.Overlay = "status_effect_33";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Ripostes upon dodging a melee attack. Will still riposte once even if hit.";
	}

	function onUpdate( _properties )
	{
		_properties.IsRiposting = true;
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		local actor = this.getContainer().getActor();
		if (actor.isAlive() && !actor.isDying() && _attacker != null && !_attacker.isAlliedWith(actor) && !actor.getCurrentProperties().IsStunned)
		{
			local myTile = actor.getTile();
			local attackerTile = _attacker.getTile();			
			if (myTile.getDistanceTo(attackerTile) == 1)
			{
				local skill = actor.getSkills().getAttackOfOpportunity();
				if (skill != null && skill.isUsable() && this.m.RiposteCounter == 0)
				{
					this.m.RiposteCounter = 1;
					local info = {
						User = actor,
						Skill = skill,
						TargetTile = attackerTile
					};						
					this.Time.scheduleEvent(this.TimeUnit.Virtual, this.Const.Combat.RiposteDelay, this.onRiposte.bindenv(this), info);
				}
			}
		}
	}

	function onRiposte( _info )
	{
		if (_info.User == null || typeof _info.User == "instance" && _info.User.isNull() || !_info.User.isAlive() || _info.User.isDying())
		{
			return;
		}
		_info.Skill.useForFree(_info.TargetTile);
	}

	function onTurnStart()
	{
		this.m.RiposteCounter = 0;
		this.removeSelf();
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (this.Tactical.TurnSequenceBar.getActiveEntity() == null || this.Tactical.TurnSequenceBar.getActiveEntity().getID() != this.getContainer().getActor().getID())
		{
			_properties.MeleeSkill -= 10;
		}
	}

});

