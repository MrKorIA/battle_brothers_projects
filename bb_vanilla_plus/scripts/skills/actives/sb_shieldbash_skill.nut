this.sb_shieldbash_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sb_shieldbash_skill";
		this.m.Name = "58. Удар щитом";
		this.m.Description = "Атакуйте цель с помощью щита. \n[color=#8f1e1e]Требование:[/color] Щит";
		this.m.Icon = "ui/xx10.png";
		this.m.IconDisabled = "ui/xx10_sw.png";
		this.m.SoundOnUse = [
			"sounds/combat/bash_01.wav",
			"sounds/combat/bash_02.wav",
			"sounds/combat/bash_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/strike_down_hit_01.wav",
			"sounds/combat/strike_down_hit_02.wav",
			"sounds/combat/strike_down_hit_03.wav",
			"sounds/combat/strike_down_hit_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.DirectDamageMult = 0.3;
		this.m.ActionPointCost = 8;
		this.m.FatigueCost = 25;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
		this.m.MaxLevelDifference = 4;
		this.m.ProjectileTimeScale = 1.6;
		this.m.IsProjectileRotated = true;
		this.m.IsUsingHitchance = false;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 33;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Has a range of " + this.getMaxRange() + " tiles"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = "Attack hit chance is always fixed at 65%"
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Damage: [color=" + this.Const.UI.Color.PositiveValue + "]50% Max HP + 30[/color]"
		});
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Removes Shieldwall, Spearwall and Riposte (100% chance to trigger)"
		});
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		local actor = this.getContainer().getActor();
		local myTile = actor.getTile();
		local target = _targetTile.getEntity();
		local hchc = 65;
		target.getSkills().removeByID("effects.shieldwall");
		target.getSkills().removeByID("effects.spearwall");
		target.getSkills().removeByID("effects.riposte");

		if (this.Tactical.TurnSequenceBar.getActiveEntity().getID() == _user.getID() && (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer))
		{
			if (_user.getTile().getDistanceTo(_targetTile) == 1)
			{
				this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSwing);
				if (this.Math.rand(1, 99) <= hchc)
				{
					this.attackEntity(_user, target);
				}
				else
				{
					this.Tactical.getShaker().shake(target, _user.getTile(), 4);
				}
			}
			else
			{
				_user.getSprite("shield_icon").Visible = false;
				local flip = !this.m.IsProjectileRotated && target.getPos().X > _user.getPos().X;	
				local success = this.Tactical.spawnProjectileEffect(_user.getSprite("shield_icon").getBrush().Name, _user.getTile(), _targetTile, 1, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
				this.Time.scheduleEvent(this.TimeUnit.Virtual, success, function ( _skill )
				{
					if (target.isAlive() && this.Math.rand(1, 99) <= hchc)
					{
						_skill.attackEntity(_user, target);
					}
					this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSlash);
					this.Tactical.spawnProjectileEffect(_user.getSprite("shield_icon").getBrush().Name, _targetTile, _user.getTile(), 1, this.m.ProjectileTimeScale, false, !flip);
				}.bindenv(this), this);

				this.Time.scheduleEvent(this.TimeUnit.Virtual, 500, function ( _skill )
				{
					_user.getSprite("shield_icon").Visible = true;
					this.Sound.play("sounds/combat/shieldwall_02.wav", this.Const.Sound.Volume.Skill * 1.0, actor.getPos());
				}.bindenv(this), this);
			}
		}
		else
		{
			if (this.Math.rand(1, 99) <= hchc)
			{
				this.attackEntity(_user, target);
			}
		}
		return true;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.HitChance[this.Const.BodyPart.Head] += 100.0;
			_properties.DamageDirectAdd = 0;
			_properties.DamageDirectMeleeAdd = 0;
			_properties.DamageDirectRangedAdd = 0;
			_properties.DamageDirectMult = 1;
			local actor = this.getContainer().getActor();
			local sdmg = this.Math.min(999, this.Math.floor(actor.getHitpointsMax() * 0.5 + 30))
			_properties.DamageRegularMin = sdmg;
			_properties.DamageRegularMax = sdmg;
			_properties.DamageArmorMult = 1.0;
		}
	}

	function isHidden()
	{
		if (this.m.Container.getActor().isPlacedOnMap())
		{
			local actorsk = this.getContainer();
			if (!actorsk.hasSkill("actives.knock_back") && !actorsk.hasSkill("actives.shieldwall"))
			{
				return true;
			}
			return false;
		}
		return false;
	}

	function isUsable()
	{
		local actorsk = this.getContainer().getActor().getSkills();
		if (!this.skill.isUsable())
		{
			return false;
		}
		if (actorsk.hasSkill("actives.knock_back"))
		{
			return true;
		}
		if (actorsk.hasSkill("actives.shieldwall"))
		{
			return true;
		}
		return false;
	}

});

