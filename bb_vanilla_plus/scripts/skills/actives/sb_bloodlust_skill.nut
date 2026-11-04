this.sb_bloodlust_skill <- this.inherit("scripts/skills/skill", {
	m = {
		IsSpent = false
	},
	function create()
	{
		this.m.ID = "actives.sb_bloodlust_skill";
		this.m.Name = "9. Жажда крови";
		this.m.Description = "Увеличивает боевую мощь с помощью жажды крови. Можно использовать на себя или союзников. При применении умения заклинатель теряет [color=" + this.Const.UI.Color.NegativeValue + "]10[/color] Здоровье.";
		this.m.Icon = "ui/xx38.png";
		this.m.IconDisabled = "ui/xx38_sw.png";
		this.m.SoundOnUse = [
			"sounds/combat/cleave_hit_hitpoints_01.wav",
			"sounds/combat/cleave_hit_hitpoints_02.wav",
			"sounds/combat/cleave_hit_hitpoints_03.wav"
		];
		this.m.SoundVolume = 1.2;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 228;
		this.m.IsSerialized = true;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 1;
		this.m.FatigueCost = 5;
		this.m.MinRange = 0;
		this.m.MaxRange = 2;
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 3,
				type = "text",
				text = this.getCostString()
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+20%[/color] Урон в ближнем бою, [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] Навык ближнего боя"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Действует 1 ход."
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Можно использовать только один раз за ход."
			}
		];
		return ret;
	}

	function getCursorForTile( _tile )
	{
		return this.Const.UI.Cursor.Drink;
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.m.IsSpent && this.getContainer().getActor().getHitpoints() > 10;
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

	function onUse( _user, _targetTile )
	{
		this.m.IsSpent = true;
		local effect = {
			Delay = 0,
			Quantity = 20,
			LifeTimeQuantity = 20,
			SpawnRate = 80,
			Brushes = [
				"blood_splatter_red_01",
				"blood_splatter_red_02",
				"blood_splatter_red_05",
				"blood_splatter_red_06",
				"blood_splatter_red_07",
				"blood_splatter_red_08",
				"blood_splatter_red_09"
			],
			Stages = [
				{
					LifeTimeMin = 0.3,
					LifeTimeMax = 0.3,
					ColorMin = this.createColor("ffffff00"),
					ColorMax = this.createColor("ffffff00"),
					ScaleMin = 0.01,
					ScaleMax = 0.01,
					RotationMin = 0,
					RotationMax = 359,
					TorqueMin = 10,
					TorqueMax = 20,
					VelocityMin = 60,
					VelocityMax = 150,
					DirectionMin = this.createVec(-0.1, 0.7),
					DirectionMax = this.createVec(0.1, 0.7),
					SpawnOffsetMin = this.createVec(10, 0),
					SpawnOffsetMax = this.createVec(10, 0)
				},
				{
					LifeTimeMin = 1.5,
					LifeTimeMax = 2.0,
					ColorMin = this.createColor("ffffffff"),
					ColorMax = this.createColor("ffffffff"),
					ScaleMin = 0.5,
					ScaleMax = 0.75,
					VelocityMin = 150,
					VelocityMax = 150,
					ForceMin = this.createVec(-30, 0),
					ForceMax = this.createVec(-10, 0)
				},
				{
					LifeTimeMin = 0.1,
					LifeTimeMax = 0.1,
					ColorMin = this.createColor("ffffff7f"),
					ColorMax = this.createColor("ffffff7f"),
					ScaleMin = 0.75,
					ScaleMax = 1.0,
					VelocityMin = 0,
					VelocityMax = 0,
					ForceMin = this.createVec(0, -180),
					ForceMax = this.createVec(0, -180)
				},
				{
					LifeTimeMin = 0.02,
					LifeTimeMax = 0.04,
					ColorMin = this.createColor("ffffff00"),
					ColorMax = this.createColor("ffffff00"),
					ScaleMin = 0.5,
					ScaleMax = 1.0,
					VelocityMin = 0,
					VelocityMax = 0,
					ForceMin = this.createVec(0, 0),
					ForceMax = this.createVec(0, 0)
				}
			]
		};
		this.Tactical.spawnParticleEffect(false, effect.Brushes, _user.getTile(), effect.Delay, effect.Quantity * 0.5, effect.LifeTimeQuantity * 0.5, effect.SpawnRate, effect.Stages, this.createVec(0, 40));
		this.spawnAttackEffect(_user.getTile(), this.Const.Tactical.AttackEffectSlash);
		_user.setHitpoints(this.Math.max(1, _user.getHitpoints() - 10));
		_targetTile.getEntity().getSkills().add(this.new("scripts/skills/effects/sb_bloodlust_effect"));
		return true;
	}

	function onTurnStart()
	{
		this.m.IsSpent = false;
	}

	function onCombatFinished()
	{
		this.m.IsSpent = false;
	}

});

