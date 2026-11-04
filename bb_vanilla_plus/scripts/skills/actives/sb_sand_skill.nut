this.sb_sand_skill <- this.inherit("scripts/skills/skill", {
	m = {
		Cooldown = 1,
		Skillcool = 1
	},
	function create()
	{
		this.m.ID = "actives.sb_sand_skill";
		this.m.Name = "54. Бросать грязью";
		this.m.Description = "Бросает грязь в цель, снижая силу атаки и инициативу.";
		this.m.Icon = "skills/active_215.png";
		this.m.IconDisabled = "skills/active_215_sw.png";
		this.m.Overlay = "active_215";
		this.m.SoundOnUse = [
			"sounds/combat/hand_01.wav",
			"sounds/combat/hand_02.wav",
			"sounds/combat/hand_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsVisibleTileNeeded = true;
		this.m.IsUsingHitchance = false;
		this.m.ActionPointCost = 3;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.MaxLevelDifference = 1;
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		ret.push({
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "При попадании (вероятность 71%): цель получает эффект «Отвлечение» (-35% к урону, -35% к инициативе, 1 ход)."
		});
		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Предатель (перк): Этот навык всегда успешен."
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Перезарядка: 1 ход  \nПерезарядка: [color=#8f1e1e]" + this.Math.max(0, (this.m.Cooldown - this.m.Skillcool)) + "[/color] ход"
		});
		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile))
		{
			return false;
		}

		if (this.m.Container.getActor().isAlliedWith(_targetTile.getEntity()))
		{
			return false;
		}

		return true;
	}

	function onUse( _user, _targetTile )
	{
		this.m.Skillcool = 0;
		if (_targetTile.getEntity().isAlliedWithPlayer())
		{
			local effect = {
				Delay = 0,
				Quantity = 20,
				LifeTimeQuantity = 20,
				SpawnRate = 400,
				Brushes = [
					"sand_dust_01"
				],
				Stages = [
					{
						LifeTimeMin = 0.1,
						LifeTimeMax = 0.2,
						ColorMin = this.createColor("eeeeee00"),
						ColorMax = this.createColor("ffffff00"),
						ScaleMin = 0.5,
						ScaleMax = 0.5,
						RotationMin = 0,
						RotationMax = 359,
						VelocityMin = 60,
						VelocityMax = 100,
						DirectionMin = this.createVec(-0.7, -0.6),
						DirectionMax = this.createVec(-0.6, -0.6),
						SpawnOffsetMin = this.createVec(-35, -15),
						SpawnOffsetMax = this.createVec(35, 20)
					},
					{
						LifeTimeMin = 0.75,
						LifeTimeMax = 1.0,
						ColorMin = this.createColor("eeeeeeee"),
						ColorMax = this.createColor("ffffffff"),
						ScaleMin = 0.5,
						ScaleMax = 0.75,
						VelocityMin = 60,
						VelocityMax = 100,
						ForceMin = this.createVec(0, 0),
						ForceMax = this.createVec(0, 0)
					},
					{
						LifeTimeMin = 0.1,
						LifeTimeMax = 0.2,
						ColorMin = this.createColor("eeeeee00"),
						ColorMax = this.createColor("ffffff00"),
						ScaleMin = 0.75,
						ScaleMax = 1.0,
						VelocityMin = 0,
						VelocityMax = 0,
						ForceMin = this.createVec(0, -100),
						ForceMax = this.createVec(0, -100)
					}
				]
			};
			this.Tactical.spawnParticleEffect(false, effect.Brushes, _targetTile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(30, 70));
		}
		else
		{
			local effect = {
				Delay = 0,
				Quantity = 20,
				LifeTimeQuantity = 20,
				SpawnRate = 400,
				Brushes = [
					"sand_dust_01"
				],
				Stages = [
					{
						LifeTimeMin = 0.1,
						LifeTimeMax = 0.2,
						ColorMin = this.createColor("eeeeee00"),
						ColorMax = this.createColor("ffffff00"),
						ScaleMin = 0.5,
						ScaleMax = 0.5,
						RotationMin = 0,
						RotationMax = 359,
						VelocityMin = 60,
						VelocityMax = 100,
						DirectionMin = this.createVec(0.6, -0.6),
						DirectionMax = this.createVec(0.7, -0.6),
						SpawnOffsetMin = this.createVec(-35, -15),
						SpawnOffsetMax = this.createVec(35, 20)
					},
					{
						LifeTimeMin = 1.0,
						LifeTimeMax = 1.25,
						ColorMin = this.createColor("eeeeeeee"),
						ColorMax = this.createColor("ffffffff"),
						ScaleMin = 0.5,
						ScaleMax = 0.75,
						VelocityMin = 60,
						VelocityMax = 100,
						ForceMin = this.createVec(0, 0),
						ForceMax = this.createVec(0, 0)
					},
					{
						LifeTimeMin = 0.1,
						LifeTimeMax = 0.2,
						ColorMin = this.createColor("eeeeee00"),
						ColorMax = this.createColor("ffffff00"),
						ScaleMin = 0.75,
						ScaleMax = 1.0,
						VelocityMin = 0,
						VelocityMax = 0,
						ForceMin = this.createVec(0, -100),
						ForceMax = this.createVec(0, -100)
					}
				]
			};
			this.Tactical.spawnParticleEffect(false, effect.Brushes, _targetTile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(-30, 70));
		}
		local rr = this.getContainer().getActor().getSkills().hasSkill("perk.backstabber") ? 100 : 71;
		if (this.Math.rand(1, 99) <= rr)
		{
			_targetTile.getEntity().getSkills().add(this.new("scripts/skills/effects/distracted_effect"));
			if (!_user.isHiddenToPlayer() && _targetTile.IsVisibleForPlayer)
			{
				this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " throws dirt in " + this.Const.UI.getColorizedEntityName(_targetTile.getEntity()) + "\'s face to distract them");
			}
		}
		this.Tactical.getShaker().shake(_targetTile.getEntity(), _user.getTile(), 4);
		return true;
	}

	function isUsable()
	{
		if (!this.skill.isUsable())
		{
			return false;
		}
		else
		if (this.m.Skillcool < this.m.Cooldown)
		{
			return false;
		}

		return true;
	}

	function onTurnStart()
	{
		this.m.Skillcool = this.m.Skillcool + 1;
	}

	function onCombatFinished()
	{
		this.m.Skillcool = this.m.Cooldown;
	}

});

