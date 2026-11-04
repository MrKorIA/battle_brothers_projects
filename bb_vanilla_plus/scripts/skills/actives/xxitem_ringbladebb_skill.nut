this.xxitem_ringbladebb_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.throw_javelin";
		this.m.Name = "Метательный клинок";
		this.m.Description = "Бросает клинок, нанося урон цели.";
		this.m.Icon = "skills/active_34.png";
		this.m.IconDisabled = "skills/active_34_sw.png";
		this.m.Overlay = "active_34";
		this.m.SoundOnUse = [
			"sounds/combat/pound_01.wav",
			"sounds/combat/pound_02.wav",
			"sounds/combat/pound_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/throw_axe_hit_01.wav",
			"sounds/combat/throw_axe_hit_02.wav",
			"sounds/combat/throw_axe_hit_03.wav"
		];
		this.m.SoundOnHitDelay = -150;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.Delay = 0;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false;
		this.m.IsWeaponSkill = true;
		this.m.IsDoingForwardMove = false;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
		this.m.DirectDamageMult = 0.3;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 15;
		this.m.MinRange = 2;
		this.m.MaxRange = 3;
		this.m.MaxLevelDifference = 4;
		this.m.ProjectileTimeScale = 1.5;
		this.m.IsProjectileRotated = false;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Дальность " + this.getMaxRange() + " плиток"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = "Has +5% chance to hit, and -10% per tile of distance"
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "When melee skill is over 80 : Max damage increases by 40% of melee skill (max : +60)"
		});
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Когда навык ближнего боя превышает 80: максимальный урон увеличивается на 40% от навыка ближнего боя (макс: +50)."
		});
		return ret;
	}

	function onAfterUpdate( _properties )
	{
		local a = 0;
		a += _properties.IsSpecializedInCleavers ? 1 : 0;
		a += _properties.IsSpecializedInThrowing ? 1 : 0;
		this.m.FatigueCost = 15 - (a * 2);
	}

	function onUse( _user, _targetTile )
	{
		if (this.Tactical.TurnSequenceBar.getActiveEntity().getID() == _user.getID() && (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer))
		{
			local target = _targetTile.getEntity();
			_user.getSprite("arms_icon").Visible = false;
			this.m.IsDoingAttackMove = false;
			this.getContainer().setBusy(true);
			local flip = !this.m.IsProjectileRotated && _targetTile.getEntity().getPos().X > _user.getPos().X;	
			local success = this.Tactical.spawnProjectileEffect("xxprojectile_01", _user.getTile(), _targetTile, 1, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, success, function ( _skill )
			{
				_skill.attackEntity(_user, target);
				this.Tactical.spawnProjectileEffect("xxprojectile_01", _targetTile, _user.getTile(), 1, this.m.ProjectileTimeScale, false, !flip);
			}.bindenv(this), this);
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 500, function ( _skill )
			{
				_user.getSprite("arms_icon").Visible = true;
				_skill.m.IsDoingAttackMove = true;
				_skill.getContainer().setBusy(false);
				this.Sound.play("sounds/combat/shieldwall_02.wav", this.Const.Sound.Volume.Skill * 1.0, this.getContainer().getActor().getPos());
			}.bindenv(this), this);
		}
		else
		{
			this.attackEntity(_user, _targetTile.getEntity());
		}
		return true;
	}

	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
		if (_skill == this && _targetEntity.isAlive() && !_targetEntity.isDying())
		{
			local actor = this.getContainer().getActor();
			local item = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
			this.spawnAttackEffect(_targetEntity.getTile(), this.Const.Tactical.AttackEffectSlash);
			item.m.IsBloodied = true;
			actor.getSprite("arms_icon").setBrush("icon_xx_weapon_05_bloodied");
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			local gg = this.getContainer().getActor().getCurrentProperties().getMeleeSkill();
			if (gg >= 80)
			{
				_properties.DamageRegularMax += this.Math.min(gg * 0.4, 60);
			}
			_properties.RangedSkill += 5;
			_properties.HitChanceAdditionalWithEachTile += -10;
		}
	}

});

