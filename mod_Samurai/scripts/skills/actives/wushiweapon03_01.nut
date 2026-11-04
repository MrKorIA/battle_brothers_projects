this.wushiweapon03_01 <- this.inherit("scripts/skills/skill", {
	m = {
		AdditionalAccuracy = 0,
		AdditionalHitChance = 0,
		SoundOnMissTarget = [
			"sounds/combat/wushiweapon03_01.wav",
		]
	},
	function create()
	{
		this.m.ID = "actives.wushiweapon03_01";
		this.m.Name = "Метание кунаи";
		this.m.Description = "Метает кунаи в цель. Не может быть использовано в ближнем бою.";
		this.m.KilledString = "Пронзён";
		this.m.Icon = "skills/wushiweapon03_01.png";
		this.m.IconDisabled = "skills/wushiweapon03_01_sw.png";
		this.m.Overlay = "wushiweapon03_01";
		this.m.SoundOnUse = [
			"sounds/combat/wushiweapon03_01.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/javelin_hit_01.wav"
		];
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
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
		this.m.DirectDamageMult = 0.45;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 6;
		this.m.MinRange = 2;
		this.m.MaxRange = 4;
		this.m.MaxLevelDifference = 4;
		this.m.ProjectileType = this.Const.ProjectileType.Shoulijian03;
	}

	function addResources()
	{
		this.skill.addResources();

		foreach( r in this.m.SoundOnMissTarget )
		{
			this.Tactical.addResource(r);
		}
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Имеет дальность в [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] клеток на равнине. При броске с возвышенности дальность увеличивается."
		});

		if (30 + this.m.AdditionalAccuracy >= 0)
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + (30 + this.m.AdditionalAccuracy) + "%[/color] к шансу попадания и [color=" + this.Const.UI.Color.NegativeValue + "]" + (-10 + this.m.AdditionalHitChance) + "%[/color] за каждую клетку до цели"
			});
		}
		else
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + (30 + this.m.AdditionalAccuracy) + "%[/color] к шансу попадания и [color=" + this.Const.UI.Color.NegativeValue + "]" + (-10 + this.m.AdditionalHitChance) + "%[/color] за каждую клетку до цели"
			});
		}

		local ammo = this.getAmmo();

		if (ammo > 0)
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/icons/ammo.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]" + ammo + "[/color] кунаи"
			});
		}
		else
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Кунаи закончились[/color]"
			});
		}

		if (this.Tactical.isActive() && this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Нельзя использовать, пока персонаж вовлечён в ближний бой[/color]"
			});
		}

		return ret;
	}

	function isUsable()
	{
		return !this.Tactical.isActive() || this.skill.isUsable() && this.getAmmo() > 0 && !this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions());
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

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInThrowing ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
		this.m.AdditionalAccuracy = this.m.Item.getAdditionalAccuracy();
	}

	function onUse( _user, _targetTile )
	{
		local ret = this.attackEntity(_user, _targetTile.getEntity());
		this.consumeAmmo();

		if (!ret && this.m.SoundOnMissTarget.len() != 0)
		{
			this.Sound.play(this.m.SoundOnMissTarget[this.Math.rand(0, this.m.SoundOnMissTarget.len() - 1)], this.Const.Sound.Volume.Skill, _targetTile.getEntity().getPos());
		}

		return ret;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.RangedSkill += 20 + this.m.AdditionalAccuracy;
			_properties.HitChanceAdditionalWithEachTile -= 10 + this.m.AdditionalHitChance;
		}
	}

});

