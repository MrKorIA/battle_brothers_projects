this.sb_miracle_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Skillcharge = 1
	},
	function create()
	{
		this.m.ID = "actives.sb_miracle_skill";
		this.m.Name = "43. Чудо";
		this.m.Description = "Исцеляет и снижает усталость ближайших союзников. Не действует на себя.";
		this.m.Icon = "ui/xx43.png";
		this.m.IconDisabled = "ui/xx43_sw.png";
		this.m.SoundOnUse = [
			"sounds/enemies/shaman_skill_nightvision_01.wav",
			"sounds/enemies/shaman_skill_nightvision_02.wav",
			"sounds/enemies/shaman_skill_nightvision_03.wav"
		];
		this.m.SoundVolume = 1.1;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.ActionPointCost = 9;
		this.m.FatigueCost = 35;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Этот навык действует на союзников в радиусе 2 клеток."
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Восстановить [color=" + this.Const.UI.Color.PositiveValue + "]20[/color] здоровья и уменьшить усталость"
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Можно использовать 1 раз за бой"
		});
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcharge = this.m.Skillcharge - 1
		local myTile = _user.getTile();
		local actors = this.Tactical.Entities.getInstancesOfFaction(_user.getFaction());
		local effect = {
				Delay = 0,
				Quantity = 10,
				LifeTimeQuantity = 10,
				SpawnRate = 150,
				Brushes = [
					"effect_lightning_03"
				],
				Stages = [
					{
						LifeTimeMin = 0.1,
						LifeTimeMax = 0.2,
						ColorMin = this.createColor("ff0000cc"),
						ColorMax = this.createColor("ff0000ff"),
						ScaleMin = 0.25,
						ScaleMax = 0.5,
						RotationMin = -10,
						RotationMax = 10,
						VelocityMin = 60,
						VelocityMax = 100,
						DirectionMin = this.createVec(-0.5, 0.5),
						DirectionMax = this.createVec(0.5, 0.5),
						SpawnOffsetMin = this.createVec(-50, -40),
						SpawnOffsetMax = this.createVec(50, 20),
						ForceMin = this.createVec(0, -50),
						ForceMax = this.createVec(0, -80)
					},
					{
						LifeTimeMin = 0.1,
						LifeTimeMax = 0.3,
						ColorMin = this.createColor("ff000080"),
						ColorMax = this.createColor("ff0000ff"),
						ScaleMin = 0.5,
						ScaleMax = 0.75,
						RotationMin = -10,
						RotationMax = 10,
						VelocityMin = 60,
						VelocityMax = 100,
						DirectionMin = this.createVec(-0.4, 0.6),
						DirectionMax = this.createVec(0.4, 0.6),
						ForceMin = this.createVec(0, -50),
						ForceMax = this.createVec(0, -80)
					},
					{
						LifeTimeMin = 0.2,
						LifeTimeMax = 0.3,
						ColorMin = this.createColor("ff0000cc"),
						ColorMax = this.createColor("ff0000ff"),
						ScaleMin = 0.5,
						ScaleMax = 0.75,
						RotationMin = -10,
						RotationMax = 10,
						VelocityMin = 60,
						VelocityMax = 100,
						ForceMin = this.createVec(0, -50),
						ForceMax = this.createVec(0, -80)
					}
				]
		};
		foreach( a in actors )
		{
			if (a.getID() == _user.getID())
			{
				continue;
			}

			if (myTile.getDistanceTo(a.getTile()) > 2)
			{
				continue;
			}

			if (a.getFaction() == _user.getFaction())
			{
				a.setHitpoints(this.Math.min(a.getHitpointsMax(), a.getHitpoints() + 20));
				a.setFatigue(this.Math.max(0, a.getFatigue() - 20));
				a.setDirty(true);
				a.onUpdateInjuryLayer();
				this.spawnIcon("status_effect_73", a.getTile());
			}
		}
		this.Tactical.spawnSpriteEffect("effect_pentagram_01", this.createColor("#ffffff"), myTile, 0, 20, 0.5, 2.5, 1, 100, 500);
		this.Tactical.spawnParticleEffect(false, effect.Brushes, myTile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 40));
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

