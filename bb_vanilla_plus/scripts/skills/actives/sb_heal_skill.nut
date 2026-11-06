this.sb_heal_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Skillcharge = 1
	},
	function create()
	{
		this.m.ID = "actives.sb_heal_skill";
		this.m.Name = "Магическое исцеление";
		this.m.Description = "Восстанавливает здоровье, броню тела и шлема дружественной цели.";
		this.m.Icon = "ui/xx8.png";
		this.m.IconDisabled = "ui/xx8_sw.png";
		this.m.SoundOnUse = [
			"sounds/fantasyskills/fantasyskill_heal_01.wav",
			"sounds/fantasyskills/fantasyskill_heal_02.wav",
			"sounds/fantasyskills/fantasyskill_heal_03.wav"
		];
		this.m.SoundVolume = 1.3;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingHitchance = false;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 25;
		this.m.MinRange = 1;
		this.m.MaxRange = 6;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Дальность " + this.getMaxRange() + " клетки"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Восстановить [color=" + this.Const.UI.Color.PositiveValue + "]50 + (Решимость заклинателя x 0.5)[/color] здоровья"
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Восстановить [color=" + this.Const.UI.Color.PositiveValue + "]80 + (Решимость заклинателя x 0.5)[/color] доспехи и шлем"
		});
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Можно использовать 1 раз за бой"
		});
		return ret;
	}

	function getCursorForTile( _tile )
	{
		return this.Const.UI.Cursor.Drink;
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcharge = this.m.Skillcharge - 1
		local target = _targetTile.getEntity();
		local hh = this.Math.floor(_user.getCurrentProperties().getBravery() * 0.5);
		local helmet = target.getItems().getItemAtSlot(this.Const.ItemSlot.Head);
		local armor = target.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
		local effect = {
			Delay = 0,
			Quantity = 60,
			LifeTimeQuantity = 60,
			SpawnRate = 50,
			Brushes = [
			"blood_red_01",
			"blood_red_02",
			"blood_red_03",
			"blood_red_04",
			"blood_red_05",
			"blood_red_06",
			"blood_red_07"
			],
		Stages = [
			{
				LifeTimeMin = 0.2,
				LifeTimeMax = 0.2,
				ColorMin = this.createColor("ffffff00"),
				ColorMax = this.createColor("ffffff00"),
				ScaleMin = 0.5,
				ScaleMax = 0.8,
				RotationMin = 0,
				RotationMax = 359,
				VelocityMin = 30,
				VelocityMax = 50,
				DirectionMin = this.createVec(-0.5, 0.4),
				DirectionMax = this.createVec(0.5, 0.4),
				SpawnOffsetMin = this.createVec(-30, -30),
				SpawnOffsetMax = this.createVec(30, 0)
			},
			{
				LifeTimeMin = 1.4,
				LifeTimeMax = 1.4,
				ColorMin = this.createColor("ffffffff"),
				ColorMax = this.createColor("ffffffff"),
				ScaleMin = 0.5,
				ScaleMax = 0.8,
				RotationMin = 0,
				RotationMax = 359,
				VelocityMin = 70,
				VelocityMax = 140,
				ForceMin = this.createVec(0, 0),
				ForceMax = this.createVec(0, 0)
			},
			{
				LifeTimeMin = 0.2,
				LifeTimeMax = 0.3,
				ColorMin = this.createColor("ffffff00"),
				ColorMax = this.createColor("ffffff00"),
				ScaleMin = 0.5,
				ScaleMax = 0.8,
				VelocityMin = 30,
				VelocityMax = 50,
				ForceMin = this.createVec(0, -60),
				ForceMax = this.createVec(0, -60)
			}
		]
		};
		this.Tactical.spawnParticleEffect(false, effect.Brushes, _targetTile, effect.Delay, effect.Quantity * 0.5, effect.LifeTimeQuantity * 0.5, effect.SpawnRate, effect.Stages, this.createVec(0, 40));

		target.setHitpoints(this.Math.min(target.getHitpoints() + 50 + hh, target.getHitpointsMax()));
		if (helmet != null)
		{
			helmet.setArmor(this.Math.min(helmet.getArmorMax(), helmet.getArmor() + 80 + hh));
		}
		if (armor != null)
		{
			armor.setArmor(this.Math.min(armor.getArmorMax(), armor.getArmor() + 80 + hh));
		}
		local hitInfo = clone this.Const.Tactical.HitInfo;
		hitInfo.DamageRegular = 0.00001;
		hitInfo.DamageDirect = 1.0;
		hitInfo.BodyPart = this.Const.BodyPart.Body;
		hitInfo.BodyDamageMult = 1.0;
		target.onDamageReceived(target, null, hitInfo);
		target.setDirty(true);
		target.onUpdateInjuryLayer();
		return true;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}
		if (!this.m.Container.getActor().isAlliedWith(_targetTile.getEntity()))
		{
			return false;
		}
		return true;
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
		this.m.Skillcharge = 1;
	}

});

