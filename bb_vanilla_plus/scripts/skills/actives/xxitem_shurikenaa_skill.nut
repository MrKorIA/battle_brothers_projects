this.xxitem_shurikenaa_skill <- this.inherit("scripts/skills/skill", {
	m = {
		AdditionalAccuracy = 0,
		AdditionalHitChance = 0
	},
	function create()
	{
		this.m.ID = "actives.xx_a";
		this.m.Name = "Бросить сюрикен";
		this.m.Description = "Бросает сюрикен в цель. Не может быть использовано во время ближнего боя.";
		this.m.Icon = "ui/xx39.png";
		this.m.IconDisabled = "ui/xx39_sw.png";
		this.m.SoundOnUse = [
			"sounds/combat/javelin_throw_01.wav",
			"sounds/combat/javelin_throw_02.wav",
			"sounds/combat/javelin_throw_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/javelin_hit_01.wav",
			"sounds/combat/javelin_hit_03.wav"
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
		this.m.IsShowingProjectile = true;
		this.m.IsWeaponSkill = true;
		this.m.IsDoingForwardMove = false;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
		this.m.DirectDamageMult = 0.2;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 10;
		this.m.MinRange = 2;
		this.m.MaxRange = 4;
		this.m.MaxLevelDifference = 4;
		local mmart = "xxprojectile_03";
		local mmid = -1;
		foreach(i, s in this.Const.ProjectileSprite)
		{
			if (s == mmart)
			{
				mmid = i;
				break;
			}
		}
		if (mmid == -1)
		{
			this.Const.ProjectileSprite.push(mmart);
			mmid = this.Const.ProjectileSprite.len() - 1;
			this.Const.ProjectileDecals.push([""]);
		}
		this.m.ProjectileType = mmid;
		this.m.ProjectileTimeScale = 1.5;
		this.m.IsProjectileRotated = false;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Дальность " + this.getMaxRange() + " плиток"
		});
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = "Имеет " + (20 + this.m.AdditionalAccuracy) + "% шанс поразить цель и " + (-10 + this.m.AdditionalHitChance) + "% за каждую клетку расстояния"
		});
		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Эффект мастерства «Кинжал/Метание»: -20% к затратам на усталость. -1 к затратам на очки действия."
		});

		local ammo = this.getAmmo();

		if (ammo > 0)
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/icons/ammo.png",
				text = "Осталось  [color=" + this.Const.UI.Color.PositiveValue + "]" + ammo + "[/color] сюрикен"
			});
		}
		else
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Сюрикенов не осталось[/color]"
			});
		}

		if (this.Tactical.isActive() && this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Не может быть использован, поскольку этот персонаж участвует в ближнем бою.[/color]"
			});
		}

		return ret;
	}

	function onAfterUpdate( _properties )
	{
		local aa = 0;
		if (_properties.IsSpecializedInThrowing)
		{
			aa = aa + 1;
		}
		if (_properties.IsSpecializedInDaggers)
		{
			aa = aa + 1;
		}
		this.m.FatigueCostMult = 1 - (aa * 0.2);
		this.m.ActionPointCost = 4 - aa;
		this.m.AdditionalAccuracy = this.m.Item.getAdditionalAccuracy();
	}

	function isUsable()
	{
		local actor = this.getContainer().getActor();
		return actor.isAlive() && this.skill.isUsable() && this.getAmmo() > 0 && !actor.getTile().hasZoneOfControlOtherThan(actor.getAlliedFactions());
	}

	function getAmmo()
	{
		local item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

		if (item == null)
		{
			return 0;
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

	function onUse( _user, _targetTile )
	{
		local ret = this.attackEntity(_user, _targetTile.getEntity());
		this.consumeAmmo();
		return ret;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.RangedSkill += 20 + this.m.AdditionalAccuracy;
			_properties.HitChanceAdditionalWithEachTile += -10 + this.m.AdditionalHitChance;
		}
	}

});

