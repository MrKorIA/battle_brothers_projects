this.sb_cqcthrowing_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sb_cqcthrowing_skill";
		this.m.Name = "15. Идеальный прицельный бросок";
		this.m.Description = "Наносит мощный урон врагу, находящемуся на расстоянии 3 клеток. (Дистанционный навык)\n[color=#8f1e1e]Требования:[/color] Копье / Метательный топор / Метательное копье / Праща посоха / Шипастые боласы";
		this.m.Icon = "skills/active_86.png";
		this.m.IconDisabled = "skills/active_86_sw.png";
		this.m.Overlay = "active_86";
		this.m.SoundOnUse = [
			"sounds/combat/overhead_strike_01.wav",
			"sounds/combat/overhead_strike_02.wav",
			"sounds/combat/overhead_strike_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/overhead_strike_hit_01.wav",
			"sounds/combat/overhead_strike_hit_02.wav",
			"sounds/combat/overhead_strike_hit_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 221;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsWeaponSkill = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = true;
		this.m.IsDoingForwardMove = false;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
		this.m.DirectDamageMult = 0.1;
		this.m.ActionPointCost = 8;
		this.m.FatigueCost = 25;
		this.m.MinRange = 3;
		this.m.MaxRange = 3;
		this.m.ProjectileType = this.Const.ProjectileType.Axe;
		this.m.IsProjectileRotated = false;
		this.m.ProjectileTimeScale = 1.2;
		this.m.ChanceDecapitate = 44;
		this.m.ChanceDisembowel = 33;
		this.m.ChanceSmash = 11;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "+5 к защите в ближнем и дальнем бою при выполнении требований"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Мастерство броска: +20% к шансу попадания"
		});
		local ammo = this.getAmmo();
		if (ammo > 0)
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/ammo.png",
				text = "Осталось [color=#135213]" + ammo + "[/color] метательное оружие"
			});
		}
		else
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=#8f1e1e]Метательного оружия не осталось[/color]"
			});
		}
		return ret;
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		local ak = actor.getSkills();
		local item = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null)
		{
			local rr = 0; 
			if (ak.hasSkill("actives.throw_balls"))
			{
				this.m.ProjectileType = this.Const.ProjectileType.Bola;
				this.m.ProjectileTimeScale = 1.5;
				this.m.IsProjectileRotated = false;
				rr = 1;
			}
			else if (ak.hasSkill("actives.sling_stone"))
			{
				this.m.ProjectileType = this.Const.ProjectileType.Stone;
				this.m.ProjectileTimeScale = 1.2;
				this.m.IsProjectileRotated = true;
				rr = 1;
			}
			else if (ak.hasSkill("actives.throw_axe"))
			{
				this.m.ProjectileType = this.Const.ProjectileType.Axe;
				this.m.ProjectileTimeScale = 1.5;
				this.m.IsProjectileRotated = false;
				rr = 1;
			}
			else if (ak.hasSkill("actives.throw_javelin") || item.getID() == "weapon.throwing_spear")
			{
				this.m.ProjectileType = this.Const.ProjectileType.Javelin;
				this.m.ProjectileTimeScale = 1.0;
				this.m.IsProjectileRotated = true;
				rr = 1;
			}
			if (rr == 1)
			{
				_properties.MeleeDefense += 5;
				_properties.RangedDefense += 5;
			}
		}
	}

	function onUse( _user, _targetTile )
	{
		local mainh = _user.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (mainh != null)
		{
			if (_user.getSkills().hasSkill("actives.throw_spear"))
			{
				_user.getItems().unequip(mainh);
			}
			else if (!_user.getSkills().hasSkill("actives.sling_stone"))
			{
				this.consumeAmmo();
			}
		}
		return this.attackEntity(_user, _targetTile.getEntity());
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			local actor = this.getContainer().getActor();
			local mainh = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
			if (mainh != null && mainh.isItemType(this.Const.Items.ItemType.RangedWeapon))
			{
				this.m.DirectDamageMult = mainh.m.DirectDamageMult;
			}
			_properties.RangedSkill += _properties.IsSpecializedInThrowing ? 20 : 0;
			_properties.DamageRegularMin += actor.getLevel() * 1;
			_properties.DamageRegularMax += actor.getLevel() * 1;
			_properties.RangedDamageMult += 2;
			if (_targetEntity != null)
			{
				if (actor.getTile().getDistanceTo(_targetEntity.getTile()) > 3)
				{
					_properties.DamageTotalMult *= 0.4;
				}
			}
		}
	}

	function getAmmo()
	{
		local item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item == null)
		{
			return 0;
		}
		if (this.getContainer().hasSkill("actives.sling_stone") || this.getContainer().hasSkill("actives.throw_spear"))
		{
			return 1;
		}
		return item.getAmmo();
	}

	function consumeAmmo()
	{
		local item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null)
		{
			item.consumeAmmo();
		}
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

		if (this.getContainer().hasSkill("actives.throw_axe"))
		{
			return true;
		}
		else if (this.getContainer().hasSkill("actives.throw_javelin"))
		{
			return true;
		}
		else if (this.getContainer().hasSkill("actives.throw_spear"))
		{
			return true;
		}
		else if (this.getContainer().hasSkill("actives.sling_stone"))
		{
			return true;
		}
		else if (this.getContainer().hasSkill("actives.throw_balls"))
		{
			return true;
		}

		return false;
	}

	function isHidden()
	{
		if (this.m.Container.getActor().isPlacedOnMap())
		{
			local actorsk = this.getContainer();
			if (!actorsk.hasSkill("actives.throw_axe") && !actorsk.hasSkill("actives.throw_javelin") && !actorsk.hasSkill("actives.throw_spear") && !actorsk.hasSkill("actives.sling_stone") && !actorsk.hasSkill("actives.throw_balls"))
			{
				return true;
			}
			return false;
		}
		return false;
	}

});

