this.xxmob_skull <- this.inherit("scripts/entity/tactical/actor", {
	m = {
		DistortTargetA = null,
		DistortTargetPrevA = this.createVec(0, 0),
		DistortAnimationStartTimeA = 0,
		IsFlippingA = false,
		DistortAnimationStartTimeB = 0,
		DurationB = 0.5,
		IsFlippingB = false,
		DistortAnimationStartTimeC = 0,
		DurationC = 0.2,
		IsFlippingC = false
	},
	function create()
	{
		this.m.Name = this.Const.Strings.FT.M84;
		this.m.Type = this.Const.EntityType.FlyingSkull;
		this.m.BloodType = this.Const.BloodType.None;
		this.m.XP = this.Const.Tactical.Actor.FlyingSkull.XP;
		this.m.BloodType = this.Const.BloodType.None;
		this.m.MoraleState = this.Const.MoraleState.Ignore;
		this.m.IsUsingZoneOfControl = false;
		this.actor.create();
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/skeleton_hurt_01.wav",
			"sounds/enemies/skeleton_hurt_02.wav",
			"sounds/enemies/skeleton_hurt_03.wav",
			"sounds/enemies/skeleton_hurt_04.wav",
			"sounds/enemies/skeleton_hurt_06.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/skeleton_death_04.wav",
			"sounds/enemies/skeleton_death_05.wav",
			"sounds/enemies/skeleton_death_06.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/skeleton_idle_01.wav",
			"sounds/enemies/skeleton_idle_02.wav",
			"sounds/enemies/skeleton_idle_03.wav",
			"sounds/enemies/skeleton_idle_04.wav",
			"sounds/enemies/skeleton_idle_05.wav",
			"sounds/enemies/skeleton_idle_06.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Other1] = [
			"sounds/combat/shieldwall_01.wav",
			"sounds/combat/shieldwall_03.wav"
		];
		this.m.SoundPitch = this.Math.rand(70, 110) * 0.01;
		this.m.Sound[this.Const.Sound.ActorEvent.Move] = this.m.Sound[this.Const.Sound.ActorEvent.Idle];
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Move] = this.Math.rand(60, 100) * 0.01;
		this.getFlags().add("undead");
		this.getFlags().add("skeleton");
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/flying_skull_agent");
		this.m.AIAgent.setActor(this);
		this.m.ConfidentMoraleBrush = "icon_confident_orcs";
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

	function onRender()
	{
		this.actor.onRender();

		if (this.m.DistortTargetA == null)
		{
			this.m.DistortTargetA = this.m.IsFlippingA ? this.createVec(0, 2.0) : this.createVec(0, -2.0);
			this.m.DistortAnimationStartTimeA = this.Time.getVirtualTimeF();
		}

		this.moveSpriteOffset("glow", this.m.DistortTargetPrevA, this.m.DistortTargetA, 1.0, this.m.DistortAnimationStartTimeA);
		this.moveSpriteOffset("flames1", this.m.DistortTargetPrevA, this.m.DistortTargetA, 1.0, this.m.DistortAnimationStartTimeA);
		this.moveSpriteOffset("flames2", this.m.DistortTargetPrevA, this.m.DistortTargetA, 1.0, this.m.DistortAnimationStartTimeA);

		if (this.moveSpriteOffset("body", this.m.DistortTargetPrevA, this.m.DistortTargetA, 1.0, this.m.DistortAnimationStartTimeA))
		{
			this.m.DistortAnimationStartTimeA = this.Time.getVirtualTimeF();
			this.m.DistortTargetPrevA = this.m.DistortTargetA;
			this.m.DistortTargetA = this.m.IsFlippingA ? this.createVec(0, 2.0) : this.createVec(0, -2.0);
			this.m.IsFlippingA = !this.m.IsFlippingA;
		}

		if (this.m.DistortAnimationStartTimeB == 0)
		{
			this.m.DistortAnimationStartTimeB = this.Time.getVirtualTimeF();
		}

		if (!this.m.IsFlippingB)
		{
			this.getSprite("flames1").Scale = this.Math.minf(1.05, 0.95 + 0.1 * ((this.Time.getVirtualTimeF() - this.m.DistortAnimationStartTimeB) / this.m.DurationB));
		}
		else
		{
			this.getSprite("flames1").Scale = this.Math.maxf(0.95, 1.05 - 0.1 * ((this.Time.getVirtualTimeF() - this.m.DistortAnimationStartTimeB) / this.m.DurationB));
		}

		if (this.Time.getVirtualTimeF() - this.m.DistortAnimationStartTimeB >= this.m.DurationB)
		{
			this.m.DistortAnimationStartTimeB = this.Time.getVirtualTimeF();
			this.m.IsFlippingB = !this.m.IsFlippingB;
			this.m.DurationB = this.Math.rand(25, 60) * 0.01;

			if (this.m.IsFlippingB)
			{
				this.getSprite("flames1").fadeToAlpha(this.Math.rand(50, 255), this.m.DurationB * 1000);
			}
		}

		if (this.m.DistortAnimationStartTimeC == 0)
		{
			this.m.DistortAnimationStartTimeC = this.Time.getVirtualTimeF();
		}

		if (!this.m.IsFlippingC)
		{
			this.getSprite("flames2").Scale = this.Math.minf(1.04, 0.96 + 0.08 * ((this.Time.getVirtualTimeF() - this.m.DistortAnimationStartTimeC) / this.m.DurationC));
		}
		else
		{
			this.getSprite("flames2").Scale = this.Math.maxf(0.96, 1.04 - 0.08 * ((this.Time.getVirtualTimeF() - this.m.DistortAnimationStartTimeC) / this.m.DurationC));
		}

		if (this.Time.getVirtualTimeF() - this.m.DistortAnimationStartTimeC >= this.m.DurationC)
		{
			this.m.DistortAnimationStartTimeC = this.Time.getVirtualTimeF();
			this.m.IsFlippingC = !this.m.IsFlippingC;
			this.m.DurationC = this.Math.rand(25, 40) * 0.01;

			if (this.m.IsFlippingC)
			{
				this.getSprite("flames2").fadeToAlpha(this.Math.rand(50, 255), this.m.DurationC * 1000);
			}
		}
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		local myTile = this.getTile();
		if (this.Tactical.TurnSequenceBar.getActiveEntity().getID() == this.actor.getID())
		{
			local effect = {
				Delay = 0,
				Quantity = 80,
				LifeTimeQuantity = 80,
				SpawnRate = 400,
				Brushes = [
					"blood_splatter_bones_01",
					"blood_splatter_bones_03",
					"blood_splatter_red_01",
					"blood_splatter_red_03",
					"blood_splatter_red_06"
				],
				Stages = [
					{
						LifeTimeMin = 1.0,
						LifeTimeMax = 1.0,
						ColorMin = this.createColor("ffffffff"),
						ColorMax = this.createColor("ffffffff"),
						ScaleMin = 1.0,
						ScaleMax = 1.5,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 200,
						VelocityMax = 300,
						DirectionMin = this.createVec(-1.0, -1.0),
						DirectionMax = this.createVec(1.0, 1.0),
						SpawnOffsetMin = this.createVec(0, 0),
						SpawnOffsetMax = this.createVec(0, 0),
						ForceMin = this.createVec(0, 0),
						ForceMax = this.createVec(0, 0)
					},
					{
						LifeTimeMin = 0.75,
						LifeTimeMax = 1.0,
						ColorMin = this.createColor("ffffff8f"),
						ColorMax = this.createColor("ffffff8f"),
						ScaleMin = 0.9,
						ScaleMax = 0.9,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 200,
						VelocityMax = 300,
						DirectionMin = this.createVec(-1.0, -1.0),
						DirectionMax = this.createVec(1.0, 1.0),
						ForceMin = this.createVec(0, -100),
						ForceMax = this.createVec(0, -100)
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
						VelocityMin = 200,
						VelocityMax = 300,
						DirectionMin = this.createVec(-1.0, -1.0),
						DirectionMax = this.createVec(1.0, 1.0),
						ForceMin = this.createVec(0, -100),
						ForceMax = this.createVec(0, -100)
					}
				]
			};
			this.Tactical.spawnParticleEffect(false, effect.Brushes, myTile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 50));
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 50, this.onTriggerExplosionDamage.bindenv(this), {
				Tile = myTile,
				User = this
			});
			this.Sound.play(this.m.Sound[this.Const.Sound.ActorEvent.Other1][this.Math.rand(0, this.m.Sound[this.Const.Sound.ActorEvent.Other1].len() - 1)], this.Const.Sound.Volume.Actor, this.getPos());
			this.Sound.play(this.m.Sound[this.Const.Sound.ActorEvent.Death][this.Math.rand(0, this.m.Sound[this.Const.Sound.ActorEvent.Death].len() - 1)], this.Const.Sound.Volume.Actor, this.getPos());
		}
		else
		{
			for( local i = 0; i < this.Const.Tactical.KrakenDevourVictimParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.KrakenDevourVictimParticles[i].Brushes, _tile, this.Const.Tactical.KrakenDevourVictimParticles[i].Delay, this.Const.Tactical.KrakenDevourVictimParticles[i].Quantity, this.Const.Tactical.KrakenDevourVictimParticles[i].LifeTimeQuantity, this.Const.Tactical.KrakenDevourVictimParticles[i].SpawnRate, this.Const.Tactical.KrakenDevourVictimParticles[i].Stages);
			}
		}
		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function onTriggerExplosionDamage( _data )
	{
		local tile = _data.Tile;
		for( local i = 0; i < 6; i = ++i )
		{
			if (!tile.hasNextTile(i))
			{
			}
			else
			{
				local nextTile = tile.getNextTile(i);

				if (this.Math.abs(tile.Level - nextTile.Level) <= 1 && nextTile.IsOccupiedByActor)
				{
					local target = nextTile.getEntity();
					if (!target.isAlive() || target.isDying() || _data.User.isAlliedWith(target))
					{
					}
					else
					{
						local hitInfo = clone this.Const.Tactical.HitInfo;
						local r = this.Math.rand(70, 90);
						if (_data.User.getActionPoints() >= 2)
						{
							r = 300;
						}
						hitInfo.DamageRegular = r;
						hitInfo.DamageArmor = hitInfo.DamageRegular;
						hitInfo.DamageDirect = 0.5;
						hitInfo.BodyPart = 0;
						hitInfo.FatalityChanceMult = 0.0;
						hitInfo.Injuries = this.Const.Injury.PiercingBody;
						target.onDamageReceived(_data.User, null, hitInfo);
					}
				}
			}
		}
	}

	function onFactionChanged()
	{
		this.actor.onFactionChanged();
		local flip = !this.isAlliedWithPlayer();
		this.getSprite("body").setHorizontalFlipping(flip);
		this.getSprite("glow").setHorizontalFlipping(flip);
		this.getSprite("flames1").setHorizontalFlipping(flip);
		this.getSprite("flames2").setHorizontalFlipping(flip);
	}

	function onInit()
	{
		this.actor.onInit();
		this.setRenderCallbackEnabled(true);
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.FlyingSkull);
		b.TargetAttractionMult = 0.5;
		b.IsAffectedByNight = false;
		b.IsAffectedByInjuries = false;
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;
		b.IsImmuneToStun = true;
		b.IsImmuneToDisarm = true;
		b.IsImmuneToFire = true;
		b.IsImmuneToRoot = true;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.SameMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.m.MaxTraversibleLevels = 3;
		this.addSprite("socket").setBrush("bust_base_undead");
		local body = this.addSprite("body");
		body.setBrush("bust_skeleton_flying_head_0" + this.Math.rand(1, 2));
		body.Color = this.createColor("#990000");

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
		flames1.setBrush("bust_skeleton_flying_head_flames" + this.Math.rand(1, 2));
		flames1.Saturation = 0.1;
		local flames2 = this.addSprite("flames2");
		flames2.setBrush("bust_skeleton_flying_head_flames3");
		flames1.Saturation = 0.1;
		local glow = this.addSprite("glow");
		glow.setBrush("bust_skeleton_flying_head_glow");
		glow.Saturation = 0.1;
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.65;
		this.setSpriteOffset("status_rooted", this.createVec(7, 10));
		this.setSpriteOffset("status_stunned", this.createVec(0, -20));
		this.setSpriteOffset("arrow", this.createVec(0, -20));
		local sk = this.new("scripts/skills/actives/explode_skill");
		sk.m.SoundOnUse = [
			"sounds/combat/overhead_strike_hit_01.wav",
			"sounds/combat/overhead_strike_hit_02.wav",
			"sounds/combat/overhead_strike_hit_03.wav"
		];
		sk.m.ActionPointCost = 4;
		this.m.Skills.add(sk);
		this.spawnEffect();
	}

	function onMovementStep( _tile, _levelDifference )
	{
		for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, _tile, this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity * 0.15, this.Const.Tactical.DustParticles[i].LifeTimeQuantity * 0.15, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages);
		}
		return this.actor.onMovementStep(_tile, _levelDifference);
	}

});

