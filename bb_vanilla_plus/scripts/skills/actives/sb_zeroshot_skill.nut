this.sb_zeroshot_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sb_zeroshot_skill";
		this.m.Name = "78. Выстрел в упор";
		this.m.Description = "Атакует врагов чрезвычайно мощным огнем на близком расстоянии. Сильная отдача может отбросить цели и вас самих. Овладение арбалетом и огнестрельным оружием снижает утомляемость при их использовании. (Навык дальнего боя)\n[color=#8f1e1e]Требование:[/color] Ручной пистолет / Винтовка Hextech";
		this.m.Icon = "skills/active_202.png";
		this.m.IconDisabled = "skills/active_202_sw.png";
		this.m.Overlay = "active_202";
		this.m.SoundOnUse = [
			"sounds/enemies/catapult_death_01.wav",
			"sounds/enemies/catapult_death_02.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/bash_hit_01.wav",
			"sounds/combat/bash_hit_02.wav",
			"sounds/combat/bash_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.Delay = 200;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsWeaponSkill = true;
		this.m.IsDoingForwardMove = false;
		this.m.InjuriesOnBody = this.Const.Injury.BurningAndPiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.BurningAndPiercingHead;
		this.m.DirectDamageMult = 0.5;
		this.m.ActionPointCost = 8;
		this.m.FatigueCost = 20;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.MaxLevelDifference = 4;
		this.m.ProjectileTimeScale = 1.1;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Дальность " + this.getMaxRange() + " плитка"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = "+35% Дополнительный шанс попадания"
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "+50% к урону"
		});
		local ammo = this.getAmmo();
		if (ammo > 0)
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/icons/ammo.png",
				text = "Имеет [color=" + this.Const.UI.Color.PositiveValue + "]" + ammo + "[/color] оставшиеся выстрелы"
			});
		}
		else
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Требуется непустой мешок для порошка[/color]"
			});
		}
		return ret;
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInCrossbows ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	function onUse( _user, _targetTile )
	{
		this.consumeAmmo();
		local target = _targetTile.getEntity();
		local knockToTile = this.findTileToKnockBackToUser(_user.getTile(), _targetTile);
		local flip = !this.m.IsProjectileRotated && target.getPos().X > _user.getPos().X;
		this.Tactical.spawnProjectileEffect("explosion_03", _user.getTile(), _targetTile, 0.5, 1, true, flip);
		this.Tactical.spawnProjectileEffect("explosion_03", _user.getTile(), _targetTile, 0.4, 2, true, flip);
		this.Tactical.spawnProjectileEffect("explosion_03", _user.getTile(), _targetTile, 0.3, 3, true, flip);
		this.attackEntity(_user, target);
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 100, function ( _skill )
		{
			if (knockToTile != null && _user.isAlive() && !_user.getCurrentProperties().IsImmuneToKnockBackAndGrab && !_user.getCurrentProperties().IsRooted)
			{
				_user.setCurrentMovementType(this.Const.Tactical.MovementType.Default);
				this.Tactical.getNavigator().teleport(_user, knockToTile, null, null, false, 1.5);
			}
		}.bindenv(this), this);
		return true;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			local actor = this.getContainer().getActor();
			local mainh = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
			if (mainh != null && mainh.isItemType(this.Const.Items.ItemType.MeleeWeapon))
			{
				this.m.DirectDamageMult = mainh.m.DirectDamageMult;
			}
			_properties.RangedSkill += 35;
			_properties.DamageTotalMult += 0.5;
		}
	}

	function findTileToKnockBackTo( _userTile, _targetTile )
	{
		local dir = _userTile.getDirectionTo(_targetTile);
		if (_targetTile.hasNextTile(dir))
		{
			local knockToTile = _targetTile.getNextTile(dir);
			if (knockToTile.IsEmpty && knockToTile.Level - _userTile.Level <= 1)
			{
				return knockToTile;
			}
		}
		return null;
	}

	function findTileToKnockBackToUser( _userTile, _targetTile )
	{
		local dir = _targetTile.getDirectionTo(_userTile);
		if (_userTile.hasNextTile(dir))
		{
			local knockToTile = _userTile.getNextTile(dir);
			if (knockToTile.IsEmpty && knockToTile.Level - _userTile.Level <= 1)
			{
				return knockToTile;
			}
		}
		return null;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_skill == this && _targetEntity.isAlive() && !_targetEntity.isDying())
		{
			local targetTile = _targetEntity.getTile();
			local user = this.getContainer().getActor();
			if (_targetEntity.getCurrentProperties().IsImmuneToKnockBackAndGrab || _targetEntity.getCurrentProperties().IsRooted)
			{
				return false;
			}
			local knockToTile = this.findTileToKnockBackTo(user.getTile(), targetTile);
			if (knockToTile == null)
			{
				return;
			}
			if (!user.isHiddenToPlayer() && (targetTile.IsVisibleForPlayer || knockToTile.IsVisibleForPlayer))
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(user) + " has knocked back " + this.Const.UI.getColorizedEntityName(_targetEntity));
			}
			local skills = _targetEntity.getSkills();
			skills.removeByID("effects.shieldwall");
			skills.removeByID("effects.spearwall");
			skills.removeByID("effects.riposte");
			local damage = this.Math.max(0, this.Math.abs(knockToTile.Level - targetTile.Level) - 1) * this.Const.Combat.FallingDamage;
			if (damage == 0)
			{
				this.Tactical.getNavigator().teleport(_targetEntity, knockToTile, null, null, true);
			}
			else
			{
				local p = this.getContainer().getActor().getCurrentProperties();
				local tag = {
					Attacker = user,
					Skill = this,
					HitInfo = clone this.Const.Tactical.HitInfo,
					HitInfoBash = null
				};
				tag.HitInfo.DamageRegular = damage;
				tag.HitInfo.DamageFatigue = this.Const.Combat.FatigueReceivedPerHit;
				tag.HitInfo.DamageDirect = 1.0;
				tag.HitInfo.BodyPart = this.Const.BodyPart.Body;
				tag.HitInfo.BodyDamageMult = 1.0;
				tag.HitInfo.FatalityChanceMult = 1.0;
				this.Tactical.getNavigator().teleport(_targetEntity, knockToTile, this.onKnockedDown, tag, true, 1.5);
			}
		}
		function onKnockedDown( _entity, _tag )
		{
			if (_tag.HitInfo.DamageRegular != 0)
			{
				_entity.onDamageReceived(_tag.Attacker, _tag.Skill, _tag.HitInfo);
			}
		}
	}

	function getAmmo()
	{
		local item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Ammo);
		if (item == null)
		{
			return 0;
		}
		if (item.getAmmoType() == this.Const.Items.AmmoType.Powder)
		{
			return item.getAmmo();
		}
	}

	function consumeAmmo()
	{
		local item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Ammo);
		if (item != null)
		{
			item.consumeAmmo();
		}
	}

	function isHidden()
	{
		if (this.m.Container.getActor().isPlacedOnMap())
		{
			local actorsk = this.getContainer();
			if (!actorsk.hasSkill("actives.fire_handgonne") && !actorsk.hasSkill("actives.xxitem_rifleaa_skill"))
			{
				return true;
			}
			return false;
		}
		return false;
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}

		if (this.getAmmo() <= 0)
		{
			return false;
		}

		if (this.getContainer().hasSkill("actives.fire_handgonne"))
		{
			return true;
		}
		else if (this.getContainer().hasSkill("actives.xxitem_rifleaa_skill"))
		{
			return true;
		}

		return false;
	}

});

