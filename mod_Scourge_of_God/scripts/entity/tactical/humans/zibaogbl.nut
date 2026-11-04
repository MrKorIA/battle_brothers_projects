this.zibaogbl <- this.inherit("scripts/entity/tactical/actor", {
	m = {
		IsExploded = false
	},
	function create()
	{
		this.m.Type = this.Const.EntityType.Zibaogbl;
		this.m.BloodType = this.Const.BloodType.None;
		this.m.XP = this.Const.Tactical.Actor.Zibaogbl.XP;
		this.m.BloodType = this.Const.BloodType.None;
		this.m.MoraleState = this.Const.MoraleState.Ignore;
		this.m.IsUsingZoneOfControl = false;
		this.actor.create();
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/goblin_hurt_00.wav",
			"sounds/enemies/goblin_hurt_01.wav",
			"sounds/enemies/goblin_hurt_02.wav",
			"sounds/enemies/goblin_hurt_03.wav",
			"sounds/enemies/goblin_hurt_04.wav",
			"sounds/enemies/goblin_hurt_05.wav",
			"sounds/enemies/goblin_hurt_06.wav",
			"sounds/enemies/goblin_hurt_07.wav",
			"sounds/enemies/goblin_hurt_08.wav",
			"sounds/enemies/goblin_hurt_09.wav",
			"sounds/enemies/goblin_hurt_10.wav",
			"sounds/enemies/goblin_hurt_11.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/combat/dlc6/fire_gonne_01.wav",
			"sounds/combat/dlc6/fire_gonne_02.wav",
			"sounds/combat/dlc6/fire_gonne_03.wav",
			"sounds/combat/dlc6/fire_gonne_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/goblin_idle_00.wav",
			"sounds/enemies/goblin_idle_01.wav",
			"sounds/enemies/goblin_idle_02.wav",
			"sounds/enemies/goblin_idle_03.wav",
			"sounds/enemies/goblin_idle_04.wav",
			"sounds/enemies/goblin_idle_05.wav",
			"sounds/enemies/goblin_idle_06.wav",
			"sounds/enemies/goblin_idle_07.wav",
			"sounds/enemies/goblin_idle_08.wav",
			"sounds/enemies/goblin_idle_09.wav",
			"sounds/enemies/goblin_idle_10.wav",
			"sounds/enemies/goblin_idle_11.wav",
			"sounds/enemies/goblin_idle_12.wav",
			"sounds/enemies/goblin_idle_13.wav",
			"sounds/enemies/goblin_idle_14.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Move] = [
			"sounds/enemies/goblin_idle_00.wav",
			"sounds/enemies/goblin_idle_01.wav",
			"sounds/enemies/goblin_idle_02.wav",
			"sounds/enemies/goblin_idle_03.wav",
			"sounds/enemies/goblin_idle_04.wav",
			"sounds/enemies/goblin_idle_05.wav",
			"sounds/enemies/goblin_idle_06.wav",
			"sounds/enemies/goblin_idle_07.wav",
			"sounds/enemies/goblin_idle_08.wav",
			"sounds/enemies/goblin_idle_09.wav",
			"sounds/enemies/goblin_idle_10.wav",
			"sounds/enemies/goblin_idle_11.wav",
			"sounds/enemies/goblin_idle_12.wav",
			"sounds/enemies/goblin_idle_13.wav",
			"sounds/enemies/goblin_idle_14.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Other1] = [
			"sounds/enemies/goblin_idle_00.wav",
			"sounds/enemies/goblin_idle_01.wav",
			"sounds/enemies/goblin_idle_02.wav",
			"sounds/enemies/goblin_idle_03.wav",
			"sounds/enemies/goblin_idle_04.wav",
			"sounds/enemies/goblin_idle_05.wav",
			"sounds/enemies/goblin_idle_06.wav",
			"sounds/enemies/goblin_idle_07.wav",
			"sounds/enemies/goblin_idle_08.wav",
			"sounds/enemies/goblin_idle_09.wav",
			"sounds/enemies/goblin_idle_10.wav",
			"sounds/enemies/goblin_idle_11.wav",
			"sounds/enemies/goblin_idle_12.wav",
			"sounds/enemies/goblin_idle_13.wav",
			"sounds/enemies/goblin_idle_14.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Other2] = [
			"sounds/enemies/goblin_idle_00.wav",
			"sounds/enemies/goblin_idle_01.wav",
			"sounds/enemies/goblin_idle_02.wav",
			"sounds/enemies/goblin_idle_03.wav",
			"sounds/enemies/goblin_idle_04.wav",
			"sounds/enemies/goblin_idle_05.wav",
			"sounds/enemies/goblin_idle_06.wav",
			"sounds/enemies/goblin_idle_07.wav",
			"sounds/enemies/goblin_idle_08.wav",
			"sounds/enemies/goblin_idle_09.wav",
			"sounds/enemies/goblin_idle_10.wav",
			"sounds/enemies/goblin_idle_11.wav",
			"sounds/enemies/goblin_idle_12.wav",
			"sounds/enemies/goblin_idle_13.wav",
			"sounds/enemies/goblin_idle_14.wav"
		];
		this.m.SoundPitch = this.Math.rand(70, 110) * 0.01;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Move] = this.Math.rand(60, 100) * 0.01;
		this.getFlags().add("undead");
		this.getFlags().add("skeleton");
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/flying_skull_agent");
		this.m.AIAgent.setActor(this);
	}

	function spawnEffect()
	{
		if (this.isHiddenToPlayer())
		{
			return;
		}

		local effect = {
			Delay = 0,
			Quantity = 12,
			LifeTimeQuantity = 12,
			SpawnRate = 100,
			Brushes = [
				"bust_lich_aura_01"
			],
			Stages = [
				{
					LifeTimeMin = 1.0,
					LifeTimeMax = 1.0,
					ColorMin = this.createColor("ffffff5f"),
					ColorMax = this.createColor("ffffff5f"),
					ScaleMin = 1.0,
					ScaleMax = 1.0,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = this.createVec(-1.0, -1.0),
					DirectionMax = this.createVec(1.0, 1.0),
					SpawnOffsetMin = this.createVec(-10, -10),
					SpawnOffsetMax = this.createVec(10, 10),
					ForceMin = this.createVec(0, 0),
					ForceMax = this.createVec(0, 0)
				},
				{
					LifeTimeMin = 1.0,
					LifeTimeMax = 1.0,
					ColorMin = this.createColor("ffffff2f"),
					ColorMax = this.createColor("ffffff2f"),
					ScaleMin = 0.9,
					ScaleMax = 0.9,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = this.createVec(-1.0, -1.0),
					DirectionMax = this.createVec(1.0, 1.0),
					ForceMin = this.createVec(0, 0),
					ForceMax = this.createVec(0, 0)
				},
				{
					LifeTimeMin = 0.1,
					LifeTimeMax = 0.1,
					ColorMin = this.createColor("ffffff00"),
					ColorMax = this.createColor("ffffff00"),
					ScaleMin = 0.1,
					ScaleMax = 0.1,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = this.createVec(-1.0, -1.0),
					DirectionMax = this.createVec(1.0, 1.0),
					ForceMin = this.createVec(0, 0),
					ForceMax = this.createVec(0, 0)
				}
			]
		};

		this.Tactical.spawnParticleEffect(false, effect.Brushes, this.getTile(), effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 40));
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		local myTile = this.getTile();

		if (!this.m.IsExploded)
		{
			this.m.IsExploded = true;
			local effect =
	    {
            Delay = 0,
            Quantity = 75,
            LifeTimeQuantity = 75,
            SpawnRate = 512,
            Brushes = [
                "blood_splatter_sand_01",
                "blood_splatter_sand_02",
                "blood_splatter_bones_01",
                "blood_splatter_bones_01",
                "blood_splatter_red_08",
                "blood_splatter_red_09"
            ],
            Stages = [
                {
                    LifeTimeMin = 0.1,
                    LifeTimeMax = 0.2,
                    ColorMin = this.createColor("fffffff00"),
                    ColorMax = this.createColor("fffffff00"),
                    ScaleMin = 0.5,
                    ScaleMax = 0.75,
                    RotationMin = 0,
                    RotationMax = 359,
                    VelocityMin = 500,
                    VelocityMax = 600,
                    DirectionMin = this.createVec(-1.0, 0.25),
                    DirectionMax = this.createVec(1.0, 1.0),
                    SpawnOffsetMin = this.createVec(-20, -60),
                    SpawnOffsetMax = this.createVec(20, -20),
                    ForceMin = this.createVec(0, 90),
                    ForceMax = this.createVec(0, 90)
                },
                {
                    LifeTimeMin = 0.1,
                    LifeTimeMax = 0.2,
                    ColorMin = this.createColor("ffffffff"),
                    ColorMax = this.createColor("ffffffff"),
                    ScaleMin = 0.75,
                    ScaleMax = 1.0,
                    RotationMin = 0,
                    RotationMax = 359,
                    VelocityMin = 500,
                    VelocityMax = 600,
                    DirectionMin = this.createVec(-1.0, 0.25),
                    DirectionMax = this.createVec(1.0, 1.0),
                    ForceMin = this.createVec(0, 90),
                    ForceMax = this.createVec(0, 90)
                },
                {
                    LifeTimeMin = 0.1,
                    LifeTimeMax = 0.2,
                    ColorMin = this.createColor("fffffff0"),
                    ColorMax = this.createColor("fffffff0"),
                    ScaleMin = 1.0,
                    ScaleMax = 1.0,
                    RotationMin = 0,
                    RotationMax = 359,
                    VelocityMin = 500,
                    VelocityMax = 600,
                    ForceMin = this.createVec(0, -90),
                    ForceMax = this.createVec(0, -90)
                },
                {
                    LifeTimeMin = 0.2,
                    LifeTimeMax = 0.3,
                    ColorMin = this.createColor("ffffff00"),
                    ColorMax = this.createColor("ffffff00"),
                    ScaleMin = 1.0,
                    ScaleMax = 1.0,
                    RotationMin = 0,
                    RotationMax = 359,
                    VelocityMin = 500,
                    VelocityMax = 600,
                    ForceMin = this.createVec(0, -90),
                    ForceMax = this.createVec(0, -90)
                }
            ]
	    };
			this.Tactical.spawnParticleEffect(false, effect.Brushes, myTile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 50));

			for( local i = 0; i < 6; i = ++i )
			{
				if (!myTile.hasNextTile(i))
				{
				}
				else
				{
					local nextTile = myTile.getNextTile(i);

					if (this.Math.abs(myTile.Level - nextTile.Level) <= 1 && nextTile.IsOccupiedByActor)
					{
						local target = nextTile.getEntity();

						if (!target.isAlive() || target.isDying())
						{
						}
						else
						{
							local f = this.isAlliedWith(target) ? 0.5 : 1.0;
							local hitInfo = clone this.Const.Tactical.HitInfo;
							hitInfo.DamageRegular = this.Math.rand(20, 40) * f;
							hitInfo.DamageArmor = hitInfo.DamageRegular * 0.75;
							hitInfo.DamageDirect = 0.3;
							hitInfo.BodyPart = 0;
							hitInfo.FatalityChanceMult = 0.0;
							hitInfo.Injuries = this.Const.Injury.PiercingBody;
							target.onDamageReceived(this, null, hitInfo);
						}
					}
				}
			}
		
		}

		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}
	
	function onInit()
	{
		this.actor.onInit();
		this.setRenderCallbackEnabled(true);
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.Zibaogbl);
		b.TargetAttractionMult = 0.5;
		b.IsAffectedByNight = false;
		b.IsAffectedByInjuries = false;
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;
		b.IsImmuneToStun = true;
		b.IsImmuneToDisarm = true;
		b.IsImmuneToFire = true;
		b.IsImmuneToRoot = true;

		if (!this.Tactical.State.isScenarioMode() && this.World.getTime().Days >= 25)
		{
			b.DamageDirectAdd += 0.05;

			if (this.World.getTime().Days >= 50)
			{
				b.DamageDirectAdd += 0.05;
			}
		}

		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.SameMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.m.MaxTraversibleLevels = 3;
		this.addSprite("socket").setBrush("bust_base_undead");
		local body = this.addSprite("body");
		body.setBrush("bust_goblin_01_armor_02");
		local head = this.addSprite("head");
		head.setBrush("bust_cunmin_01_head_01");

		if (this.Math.rand(0, 100) < 90)
		{
			body.varySaturation(0.1);
		}

		if (this.Math.rand(0, 100) < 90)
		{
			body.varyColor(0.1, 0.1, 0.1);
		}

		if (this.Math.rand(0, 100) < 90)
		{
			body.varyBrightness(0.1);
		}

		local flames1 = this.addSprite("flames1");
		flames1.setBrush("");
		flames1.varyColor(0.1, 0.1, 0.1);
		local flames2 = this.addSprite("flames2");
		flames2.setBrush("");
		flames2.varyColor(0.1, 0.1, 0.1);
		local glow = this.addSprite("glow");
		glow.setBrush("");
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.65;
		this.setSpriteOffset("status_rooted", this.createVec(7, 10));
		this.setSpriteOffset("status_stunned", this.createVec(0, -20));
		this.setSpriteOffset("arrow", this.createVec(0, -20));
		this.m.Skills.add(this.new("scripts/skills/actives/explode_skill"));
		this.spawnEffect();
	}

});

