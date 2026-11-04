this.xxitem_mstaffaa_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function onItemSet()
	{
		this.m.MaxRange = this.m.Item.getRangeMax();
	}

	function create()
	{
		this.m.ID = "actives.xx_a";
		this.m.Name = "Энергетический взрыв";
		this.m.Description = "Выпускает магическую энергию в цель. Пораженная цель теряет защиту, что на 10 снижает ее ближний и дальний бой на 3 хода.";
		this.m.Icon = "ui/xx30.png";
		this.m.IconDisabled = "ui/xx30_sw.png";
		this.m.Overlay = "active_216";
		this.m.SoundOnUse = [
			"sounds/combat/magic_missile_01.wav",
			"sounds/combat/magic_missile_02.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/electricity_01.wav",
			"sounds/combat/electricity_02.wav",
			"sounds/combat/electricity_03.wav",
			"sounds/combat/electricity_04.wav"
		];
		this.m.SoundVolume = 1.5;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.Delay = 200;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsWeaponSkill = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = true;
		this.m.IsDoingForwardMove = false;
		this.m.InjuriesOnBody = this.Const.Injury.BurningBody;
		this.m.InjuriesOnHead = this.Const.Injury.BurningHead;;
		this.m.DirectDamageMult = 0.4;
		this.m.ActionPointCost = 8;
		this.m.FatigueCost = 15;
		this.m.MinRange = 2;
		this.m.MaxRange = 6;
		this.m.MaxLevelDifference = 4;
//		local mmart = "bust_slime_dead";
//		local mmid = -1;
//		foreach(i, s in this.Const.ProjectileSprite)
//		{
//			if (s == mmart)
//			{
//				mmid = i;
//				break;
//			}
//		}
//		if (mmid == -1)
//		{
//			this.Const.ProjectileSprite.push(mmart);
//			mmid = this.Const.ProjectileSprite.len() - 1;
//			this.Const.ProjectileDecals.push([""]);
//		}
		this.m.ProjectileType = this.Const.ProjectileType.xxempty;
//		this.m.ProjectileTimeScale = 0.99;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Дальность " + this.getMaxRange() + " клеток"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = "+25% дополнительный шанс попадания, -1% шанс попадания за каждую клетку до цели, игнорирует препятствия и атакует только выбранную цель."
		});
		if (this.Tactical.isActive() && this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Не может быть использовано, поскольку этот персонаж участвует в ближнем бою.[/color]"
			});
		}
		return ret;
	}

	function isUsable()
	{
		local actor = this.getContainer().getActor();
		return actor.isAlive() && this.skill.isUsable() && !actor.getTile().hasZoneOfControlOtherThan(actor.getAlliedFactions());
	}

	function onBeforeTargetHit( _skill, _targetEntity, _hitInfo )
	{
		if (_skill == this && _targetEntity.isAlive() && !_targetEntity.isDying())
		{
			this.Tactical.spawnSpriteEffect("sparkleflare_2", this.createColor("#ccf1ff"), _targetEntity.getTile(), 0, 40, 1.5, 1.5, -10, 400, 300);
			this.Tactical.spawnSpriteEffect("sparkleflare_1", this.createColor("#ccf1ff"), _targetEntity.getTile(), 0, 40, 1, 0.5, 10, 150, 350);
			local xsk = this.new("scripts/skills/effects/ai_weak_effect");
			xsk.m.TurnsBase = 3;
			for( local i = 0; i < 10; i = ++i )
			{
				_targetEntity.getSkills().add(xsk);
			}
			xsk = this.new("scripts/skills/actives/ai_fakebuff");
			xsk.m.Overlay = "";
			_targetEntity.getSkills().add(xsk);
		}
	}

	function onUse( _user, _targetTile )
	{
		local myTile = _user.getTile();
		local target = _targetTile.getEntity();
		local flip = !this.m.IsProjectileRotated && _targetTile.Pos.X > _user.getPos().X;
		this.m.Container.getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).m.IsBloodied = true;
		this.m.Container.getActor().getSprite("arms_icon").setBrush("icon_xx_weapon_04_bloodied");
		this.Tactical.spawnProjectileEffect("xxprojectile_04", myTile, _targetTile, 2.3, 0.9, true, flip);
		this.Tactical.spawnProjectileEffect("xxprojectile_04", myTile, _targetTile, 1.5, 0.9, true, flip);
		this.Tactical.spawnProjectileEffect("xxprojectile_04", myTile, _targetTile, 0.7, 0.9, true, flip);
		return this.attackEntity(_user, target, false);
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.RangedSkill += 25;
			_properties.HitChanceAdditionalWithEachTile += -1;
			_properties.RangedAttackBlockedChanceMult *= 0;
			if (_targetEntity != null && _targetEntity.getFaction() == this.getContainer().getActor().getFaction())
			{
				_properties.MeleeSkillMult *= 0;
				_properties.RangedSkillMult *= 0;
				_properties.DamageTotalMult *= 0;
			}
		}
	}

});

