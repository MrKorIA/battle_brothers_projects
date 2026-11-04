this.sbq18_mend_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Skillcharge = 1
	},
	function create()
	{
		this.m.ID = "actives.sbq18_mend_skill";
		this.m.Name = "125. Arcane Mend";
		this.m.Description = "Restores a friendly target\'s equp";
		this.m.Icon = "ui/xx85.png";
		this.m.IconDisabled = "ui/xx85_sw.png";
		this.m.SoundOnUse = [
			"sounds/ambience/buildings/blacksmith_hammering_03.wav"
		];
		this.m.SoundVolume = 1.5;
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
		this.m.MaxRange = 3;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Has a range of " + this.getMaxRange() + " tiles"
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Restores 150 Armor, 150 Helmet, 10 Weapon, and 10 Shield durability "
		});
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Can be used [color=#8f1e1e]" + this.m.Skillcharge + "[/color] more times in this battle."
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
		local helmet = target.getItems().getItemAtSlot(this.Const.ItemSlot.Head);
		local armor = target.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
		local mainhand = target.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		local offhand = target.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
		local effect = {
			Delay = 0,
			Quantity = 40,
			LifeTimeQuantity = 40,
			SpawnRate = 200,
			Brushes = [
			"sparkleflare_1",
			"ice_crystal"
			],
		Stages = [
			{
				LifeTimeMin = 0.8,
				LifeTimeMax = 1.2,
				ColorMin = this.createColor("fff4d9ff"),
				ColorMax = this.createColor("ffe091ff"),
				ScaleMin = 0.3,
				ScaleMax = 0.5,
				RotationMin = 0,
				RotationMax = 300,
				VelocityMin = 40,
				VelocityMax = 80,
				DirectionMin = this.createVec(-0.3, -0.6),
				DirectionMax = this.createVec(0.3, -0.9),
				SpawnOffsetMin = this.createVec(-35, 30),
				SpawnOffsetMax = this.createVec(35, 90),
				ForceMin = this.createVec(0, -100),
				ForceMax = this.createVec(0, -100)
			},
			{
				LifeTimeMin = 0.6,
				LifeTimeMax = 0.9,
				ColorMin = this.createColor("ffe091aa"),
				ColorMax = this.createColor("ffe09100"),
				ScaleMin = 0.3,
				ScaleMax = 0.5,
				VelocityMin = 5,
				VelocityMax = 15,
				DirectionMin = this.createVec(-0.2, -0.2),
				DirectionMax = this.createVec(0.2, 0.2),
				ForceMin = this.createVec(0, 0),
				ForceMax = this.createVec(0, 0)
			}
		]
		};
		this.Tactical.spawnParticleEffect(false, effect.Brushes, _targetTile, effect.Delay, effect.Quantity * 0.5, effect.LifeTimeQuantity * 0.5, effect.SpawnRate, effect.Stages, this.createVec(0, 40));

		effect = {
			Delay = 0,
			Quantity = 40,
			LifeTimeQuantity = 40,
			SpawnRate = 100,
			Brushes = [
				"sparkleflare_1",
				"sparkleflare_2"
			],
			Stages = [
				{
					LifeTimeMin = 0.9,
					LifeTimeMax = 1.1,
					ColorMin = this.createColor("fff4d9ff"),
					ColorMax = this.createColor("ffe091ff"),
					ScaleMin = 0.1,
					ScaleMax = 0.3,
					RotationMin = 0,
					RotationMax = 300,
					VelocityMin = 0,
					VelocityMax = 5,
					DirectionMin = this.createVec(-0.1, -0.1),
					DirectionMax = this.createVec(0.1, 0.1),
					SpawnOffsetMin = this.createVec(-50, -50),
					SpawnOffsetMax = this.createVec(50, 50),
					ForceMin = this.createVec(-20, -20), 
					ForceMax = this.createVec(20, 20)
				},
				{
					LifeTimeMin = 0.7,
					LifeTimeMax = 0.8,
					ColorMin = this.createColor("ffe091aa"),
					ColorMax = this.createColor("ffe09100"),
					ScaleMin = 0.05,
					ScaleMax = 0.1,
					VelocityMin = 0,
					VelocityMax = 0,
					ForceMin = this.createVec(0, 0),
					ForceMax = this.createVec(0, 0)
				}
			]
		};
		this.Tactical.spawnParticleEffect(false, effect.Brushes, _targetTile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 40));

		if (helmet != null)
		{
			helmet.setArmor(this.Math.min(helmet.getArmorMax(), helmet.getArmor() + 150));
		}
		if (armor != null)
		{
			armor.setArmor(this.Math.min(armor.getArmorMax(), armor.getArmor() + 150));
		}
		if (mainhand != null && mainhand.getConditionMax() > 1) 
		{
			mainhand.setCondition(this.Math.min(mainhand.getConditionMax(), mainhand.getCondition() + 10));
		}
		if (offhand != null && offhand.isItemType(this.Const.Items.ItemType.Shield)) 
		{
			offhand.setCondition(this.Math.min(offhand.getConditionMax(), offhand.getCondition() + 10));
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

