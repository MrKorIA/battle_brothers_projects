this.sb_lute_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.sb_lute_skill";
		this.m.Name = "39. Волшебная песня лютни";
		this.m.Description = "Спойте волшебную песню на лютне, чтобы снять усталость союзников. \n[color=#8f1e1e]Требуется:[/color] Лютня";
		this.m.Icon = "ui/xx14.png";
		this.m.IconDisabled = "ui/xx14_sw.png";
		this.m.Overlay = "active_88";
		this.m.SoundOnUse = [
			"sounds/fantasyskills/fantasyskill_lute_01.wav",
			"sounds/fantasyskills/fantasyskill_lute_02.wav",
			"sounds/fantasyskills/fantasyskill_lute_03.wav",
			"sounds/fantasyskills/fantasyskill_lute_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.ActionPointCost = 8;
		this.m.FatigueCost = 30;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Nearby allies within 3 tiles: -10 fatigue. (50% increased effectiveness if the caster is a \'Minstrel\')"
		});
		return ret;
	}

	function onUse( _user, _targetTile )
	{
		this.Sound.play("sounds/tavern_round_01.wav", this.Const.Sound.Volume.Skill * 3, this.getContainer().getActor().getPos());
		local myTile = _user.getTile();
		local actors = this.Tactical.Entities.getInstancesOfFaction(_user.getFaction());
		local effect = {
				Delay = 0,
				Quantity = 10,
				LifeTimeQuantity = 10,
				SpawnRate = 150,
				Brushes = [
					"sparkleflare_1"
				],
				Stages = [
					{
						LifeTimeMin = 0.2,
						LifeTimeMax = 0.5,
						ColorMin = this.createColor("0099ffcc"),
						ColorMax = this.createColor("0099ffff"),
						ScaleMin = 0.2,
						ScaleMax = 0.5,
						RotationMin = -20,
						RotationMax = 20,
						VelocityMin = 70,
						VelocityMax = 100,
						DirectionMin = this.createVec(-0.5, -0.2),
						DirectionMax = this.createVec(0.5, 0.5),
						SpawnOffsetMin = this.createVec(-25, -30),
						SpawnOffsetMax = this.createVec(25, 30)
					},
					{
						LifeTimeMin = 0.2,
						LifeTimeMax = 0.4,
						ColorMin = this.createColor("19a2fc80"),
						ColorMax = this.createColor("19a2fcff"),
						ScaleMin = 0.2,
						ScaleMax = 0.4,
						RotationMin = -20,
						RotationMax = 20,
						VelocityMin = 0,
						VelocityMax = 0,
						ForceMin = this.createVec(50, 70),
						ForceMax = this.createVec(100, 100)
					},
					{
						LifeTimeMin = 0.2,
						LifeTimeMax = 0.3,
						ColorMin = this.createColor("42b2fc80"),
						ColorMax = this.createColor("42b2fcff"),
						ScaleMin = 0.2,
						ScaleMax = 0.3,
						RotationMin = -20,
						RotationMax = 20,
						VelocityMin = 0,
						VelocityMax = 0,
						ForceMin = this.createVec(-100, 70),
						ForceMax = this.createVec(-150, 100)
					},
					{
						LifeTimeMin = 0.1,
						LifeTimeMax = 0.2,
						ColorMin = this.createColor("61c0ffcc"),
						ColorMax = this.createColor("61c0ffff"),
						ScaleMin = 0.1,
						ScaleMax = 0.2,
						RotationMin = -20,
						RotationMax = 20,
						VelocityMin = 0,
						VelocityMax = 0,
						ForceMin = this.createVec(0, 50),
						ForceMax = this.createVec(50, 80)
					}
				]
		};

		foreach( a in actors )
		{
			if (a.getID() == _user.getID())
			{
				continue;
			}
			if (myTile.getDistanceTo(a.getTile()) > 3)
			{
				continue;
			}
			if (a.getFaction() == _user.getFaction())
			{
				this.spawnIcon("status_effect_73", a.getTile());
				this.Tactical.spawnParticleEffect(false, effect.Brushes, a.getTile(), effect.Delay, effect.Quantity * 0.5, effect.LifeTimeQuantity * 0.5, effect.SpawnRate, effect.Stages, this.createVec(0, 40));
				if (_user.getBackground().getID() == "background.minstrel" )
				{
					a.setFatigue(this.Math.max(0, a.getFatigue() - 15));
				}
				else
				{
					a.setFatigue(this.Math.max(0, a.getFatigue() - 10));
				}
			}
		}
		return true;
	}

	function isHidden()
	{
		if (this.m.Container.getActor().isPlacedOnMap())
		{
			local actor = this.getContainer().getActor();
			local mainh = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
			if (mainh != null && mainh.getID() == "weapon.lute")
			{
				return false;
			}
			return true;
		}
		return false;
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}

		local mainh = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (mainh == null)
		{
			return false;
		}
		else if (mainh.getID() == "weapon.lute")
		{
			return true;
		}

		return false;
	}

});

