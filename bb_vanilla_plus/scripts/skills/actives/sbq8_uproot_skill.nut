this.sbq8_uproot_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Skillcharge = 1,
		SkillchargeMax = 1
	},
	function create()
	{
		this.m.ID = "actives.sbq8_uproot_skill";
		this.m.Name = "Искоренение";
		this.m.Description = "Из земли вырываются огромные корни, нанося урон трем целям по прямой линии и накладывая статус «Ошеломление».";
		this.m.Icon = "ui/xx82.png";
		this.m.IconDisabled = "ui/xx82_sw.png";
		this.m.Overlay = "active_122";
		this.m.KilledString = "Сокрушён";
		if (this.Const.DLC.Unhold)
		{
			this.m.SoundOnUse = [
			"sounds/enemies/dlc2/schrat_uproot_01.wav",
			"sounds/enemies/dlc2/schrat_uproot_02.wav",
			"sounds/enemies/dlc2/schrat_uproot_03.wav",
			"sounds/enemies/dlc2/schrat_uproot_04.wav",
			"sounds/enemies/dlc2/schrat_uproot_05.wav"
			];
			this.m.SoundOnHit = [
			"sounds/enemies/dlc2/schrat_uproot_hit_01.wav",
			"sounds/enemies/dlc2/schrat_uproot_hit_02.wav",
			"sounds/enemies/dlc2/schrat_uproot_hit_03.wav",
			"sounds/enemies/dlc2/schrat_uproot_hit_04.wav"
			];
		}
		else
		{
			this.m.SoundOnUse = [
			"sounds/combat/strike_01.wav",
			"sounds/combat/strike_02.wav",
			"sounds/combat/strike_03.wav"
			];
			this.m.SoundOnHit = [
			"sounds/combat/impale_hit_01.wav",
			"sounds/combat/impale_hit_02.wav",
			"sounds/combat/impale_hit_03.wav"
			];
		}
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.Delay = 750;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsWeaponSkill = false;
		this.m.IsUsingHitchance = false;
		this.m.IsTargetingActor = false;
		this.m.IsAOE = true;
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
		this.m.DirectDamageMult = 0.5;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 30;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 25;
		this.m.ChanceSmash = 25;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Может использоваться лишь [color=#8f1e1e]" + this.m.Skillcharge + "[/color] раз в этой битве."
		});
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcharge = this.m.Skillcharge - 1;
		local myTile = _user.getTile();
		local dir = myTile.getDirectionTo(_targetTile);
		this.Tactical.spawnAttackEffect("uproot", _targetTile, 0, -50, 100, 900, 100, this.createVec(0, 90), 600, this.createVec(0, -30), true);
		this.Tactical.spawnAttackEffect("uproot", _targetTile, 0, -50, 100, 900, 400, this.createVec(0, 90), 700, this.createVec(0, -30), true);
		this.Tactical.spawnAttackEffect("uproot", _targetTile, 0, -50, 100, 900, 700, this.createVec(0, 90), 800, this.createVec(0, -30), true);
		for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, _targetTile, this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity * 0.5, this.Const.Tactical.DustParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages, this.createVec(0, -30));
		}

		if (_targetTile.IsOccupiedByActor && _targetTile.getEntity().isAttackable())
		{
			if (_targetTile.getEntity().m.IsShakingOnHit)
			{
				this.Tactical.getShaker().shake(_targetTile.getEntity(), _targetTile, 7);
				_user.playSound(this.Const.Sound.ActorEvent.Move, 2.0);
			}
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 200, function ( _tag )
			{
				if (this.attackEntity(_user, _targetTile.getEntity(), false) && !_targetTile.IsEmpty)
				{
					this.applyEffectToTarget(_user, _targetTile.getEntity(), _targetTile);
				}
			}.bindenv(this), null);
		}

		if (_targetTile.hasNextTile(dir))
		{
			local forwardTile = _targetTile.getNextTile(dir);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 200, function ( _tag )
			{
				this.Tactical.spawnAttackEffect("uproot", forwardTile, 0, -50, 100, 900, 100, this.createVec(0, 90), 600, this.createVec(0, -30), true);
				this.Tactical.spawnAttackEffect("uproot", forwardTile, 0, -50, 100, 900, 400, this.createVec(0, 90), 700, this.createVec(0, -30), true);
				this.Tactical.spawnAttackEffect("uproot", forwardTile, 0, -50, 100, 900, 700, this.createVec(0, 90), 800, this.createVec(0, -30), true);
				for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, forwardTile, this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity * 0.5, this.Const.Tactical.DustParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages, this.createVec(0, -30));
				}
				if (forwardTile.IsOccupiedByActor && forwardTile.getEntity().m.IsShakingOnHit)
				{
					this.Tactical.getShaker().shake(forwardTile.getEntity(), forwardTile, 7);
					_user.playSound(this.Const.Sound.ActorEvent.Move, 2.0);
				}
			}.bindenv(this), null);
			if (forwardTile.IsOccupiedByActor && forwardTile.getEntity().isAttackable() && this.Math.abs(forwardTile.Level - myTile.Level) <= 1)
			{
				this.Time.scheduleEvent(this.TimeUnit.Virtual, 400, function ( _tag )
				{
					if (this.attackEntity(_user, forwardTile.getEntity(), false) && !forwardTile.IsEmpty)
					{
						this.applyEffectToTarget(_user, forwardTile.getEntity(), forwardTile);
					}
				}.bindenv(this), null);
			}
			if (forwardTile.hasNextTile(dir))
			{
				local furtherForwardTile = forwardTile.getNextTile(dir);
				this.Time.scheduleEvent(this.TimeUnit.Virtual, 400, function ( _tag )
				{
					this.Tactical.spawnAttackEffect("uproot", furtherForwardTile, 0, -50, 100, 900, 100, this.createVec(0, 90), 600, this.createVec(0, -30), true);
					this.Tactical.spawnAttackEffect("uproot", furtherForwardTile, 0, -50, 100, 900, 400, this.createVec(0, 90), 700, this.createVec(0, -30), true);
					this.Tactical.spawnAttackEffect("uproot", furtherForwardTile, 0, -50, 100, 900, 700, this.createVec(0, 90), 800, this.createVec(0, -30), true);
					for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = ++i )
					{
						this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, furtherForwardTile, this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity * 0.5, this.Const.Tactical.DustParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages, this.createVec(0, -30));
					}

					if (furtherForwardTile.IsOccupiedByActor && furtherForwardTile.getEntity().m.IsShakingOnHit)
					{
						this.Tactical.getShaker().shake(furtherForwardTile.getEntity(), furtherForwardTile, 7);
						_user.playSound(this.Const.Sound.ActorEvent.Move, 2.0);
					}
				}.bindenv(this), null);
				if (furtherForwardTile.IsOccupiedByActor && furtherForwardTile.getEntity().isAttackable() && !(furtherForwardTile.getEntity().getType() == this.Const.EntityType.Schrat || furtherForwardTile.getEntity().getType() == this.Const.EntityType.SchratSmall))
				{
					this.Time.scheduleEvent(this.TimeUnit.Virtual, 600, function ( _tag )
					{
						if (this.attackEntity(_user, furtherForwardTile.getEntity(), false) && !furtherForwardTile.IsEmpty)
						{
							this.applyEffectToTarget(_user, furtherForwardTile.getEntity(), furtherForwardTile);
						}
					}.bindenv(this), null);
				}
			}					
		}
		return true;
	}

	function applyEffectToTarget( _user, _target, _targetTile )
	{
		_target.getSkills().add(this.new("scripts/skills/effects/staggered_effect"));
		if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " потрясен " + this.Const.UI.getColorizedEntityName(_target) + " на один ход");
		}
	}

	function onTargetSelected( _targetTile )
	{
		local ownTile = this.m.Container.getActor().getTile();
		local dir = ownTile.getDirectionTo(_targetTile);
		this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, _targetTile, _targetTile.Pos.X, _targetTile.Pos.Y);
		if (_targetTile.hasNextTile(dir))
		{
			local aatile = _targetTile.getNextTile(dir);
			if (aatile.IsOccupiedByActor || aatile.IsEmpty)
			{
				this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, aatile, aatile.Pos.X, aatile.Pos.Y);
			}
			if (aatile.hasNextTile(dir))
			{
				local bbtile = aatile.getNextTile(dir);
				if (bbtile.IsOccupiedByActor || bbtile.IsEmpty)
				{
					this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, bbtile, bbtile.Pos.X, bbtile.Pos.Y);
				}
			}
		}
	}

//	function onUpdate( _properties )
//	{
//        _properties.HitChanceMult[this.Const.BodyPart.Head] = 0;
//        _properties.HitChanceMult[this.Const.BodyPart.Body] = 1;
//        _properties.DamageDirectAdd = 0;
//        _properties.DamageDirectMeleeAdd = 0;
//        _properties.DamageDirectRangedAdd = 0;
//        _properties.DamageDirectMult = 1;
//        _properties.DamageRegularMin = 10;
//        _properties.DamageRegularMax = 90;
//        _properties.DamageArmorMult = 1.0;
//        _properties.RangedAttackBlockedChanceMult *= 0;
//	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
            _properties.HitChanceMult[this.Const.BodyPart.Head] = 0;
            _properties.HitChanceMult[this.Const.BodyPart.Body] = 1;
            _properties.DamageDirectAdd = 0;
            _properties.DamageDirectMeleeAdd = 0;
            _properties.DamageDirectRangedAdd = 0;
            _properties.DamageDirectMult = 1;
            _properties.DamageRegularMin = 10;
            _properties.DamageRegularMax = 90;
            _properties.DamageArmorMult = 1.0;
            _properties.RangedAttackBlockedChanceMult *= 0;
		}
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}
		else if (this.m.Skillcharge <= 0)
		{
			return false;
		}
		return true;
	}

	function isHidden()
	{
		if (this.m.Skillcharge > 0)
		{
			return false;
		}

		return true;
	}

	function onCombatFinished()
	{
		this.m.Skillcharge = this.m.SkillchargeMax;
	}

});

