this.xxitem_kataraa_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.stab";
		this.m.Name = "Stab and Slash";
		this.m.Description = "Quick and fast stab and slash. Attack twice.";
		this.m.Icon = "skills/active_01.png";
		this.m.IconDisabled = "skills/active_01_sw.png";
		this.m.Overlay = "active_01";
		this.m.SoundOnUse = [
			"sounds/combat/slash_01.wav",
			"sounds/combat/slash_02.wav",
			"sounds/combat/slash_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/slash_hit_01.wav",
			"sounds/combat/slash_hit_02.wav",
			"sounds/combat/slash_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
		this.m.DirectDamageMult = 0.2;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 55;
		this.m.ChanceDisembowel = 54;
		this.m.ChanceSmash = 0;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "When hitting the head: 15 Piercing damage"
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Dagger mastery effect: +8% hit chance, -8 skill fatigue"
		});
		return ret;
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCost = _properties.IsSpecializedInDaggers ? 7 : 15;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		local ret = this.attackEntity(_user, target);
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectChop);
		if (this.Tactical.TurnSequenceBar.getActiveEntity() != null && this.Tactical.TurnSequenceBar.getActiveEntity().isPlayerControlled() && this.Tactical.TurnSequenceBar.getActiveEntity().getID() == _user.getID() && _user.getFaction() == this.Const.Faction.Player)
		{
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 200, function ( _skill )
			{
				if (_user.isAlive() && target.isAlive())
				{
					_skill.attackEntity(_user, target);
				}
				_skill.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSlash);
				this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill * 1.0, this.getContainer().getActor().getPos());
			}.bindenv(this), this);
			return true;
		}
		else
		{
			if (_user.isAlive() && target.isAlive())
			{
				ret = this.attackEntity(_user, target) || ret;
			}
			this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSlash);
			this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Skill * 1.0, this.getContainer().getActor().getPos());
			return ret;
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			if (_properties.IsSpecializedInDaggers)
			{
				_properties.MeleeSkill += 8;
			}
			_properties.DamageRegularMin *= 0.5;
			_properties.DamageRegularMax *= 0.5;
		}
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_skill == this && _targetEntity.isAlive() && !_targetEntity.isDying() && _bodyPart == this.Const.BodyPart.Head)
		{
			local hitInfo = clone this.Const.Tactical.HitInfo;
			hitInfo.DamageRegular = 15;
			hitInfo.DamageDirect = 1.0;
			hitInfo.BodyPart = this.Const.BodyPart.Body;
			hitInfo.BodyDamageMult = 1.0;
			hitInfo.FatalityChanceMult = 0.0;
			_targetEntity.onDamageReceived(this.getContainer().getActor(), this, hitInfo);
		}
	}

});

