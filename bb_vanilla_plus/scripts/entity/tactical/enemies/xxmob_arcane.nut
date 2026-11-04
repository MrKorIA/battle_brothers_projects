this.xxmob_arcane <- this.inherit("scripts/entity/tactical/human", {
	m = {},
	function create()
	{
		this.m.Name = this.Const.Strings.FT.M5;
		this.m.Type = this.Const.EntityType.AlpShadow;
		this.m.BloodType = this.Const.BloodType.None;
		this.m.MoraleState = this.Const.MoraleState.Ignore;
		this.m.XP = this.Const.Tactical.Actor.OrcBerserker.XP;
		this.human.create();
		this.m.Faces = null;
		this.m.Hairs = null;
		this.m.HairColors = null;
		this.m.Beards = null;
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/zombie_hurt_01.wav",
			"sounds/enemies/zombie_hurt_02.wav",
			"sounds/enemies/zombie_hurt_03.wav",
			"sounds/enemies/zombie_hurt_04.wav",
			"sounds/enemies/zombie_hurt_05.wav",
			"sounds/enemies/zombie_hurt_06.wav",
			"sounds/enemies/zombie_hurt_07.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/zombie_death_01.wav",
			"sounds/enemies/zombie_death_02.wav",
			"sounds/enemies/zombie_death_03.wav",
			"sounds/enemies/zombie_death_04.wav",
			"sounds/enemies/zombie_death_05.wav",
			"sounds/enemies/zombie_death_06.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/zombie_idle_01.wav",
			"sounds/enemies/zombie_idle_02.wav",
			"sounds/enemies/zombie_idle_03.wav",
			"sounds/enemies/zombie_idle_04.wav",
			"sounds/enemies/zombie_idle_05.wav",
			"sounds/enemies/zombie_idle_06.wav",
			"sounds/enemies/zombie_idle_07.wav",
			"sounds/enemies/zombie_idle_08.wav",
			"sounds/enemies/zombie_idle_09.wav",
			"sounds/enemies/zombie_idle_10.wav",
			"sounds/enemies/zombie_idle_11.wav",
			"sounds/enemies/zombie_idle_12.wav",
			"sounds/enemies/zombie_idle_13.wav",
			"sounds/enemies/zombie_idle_14.wav",
			"sounds/enemies/zombie_idle_15.wav",
			"sounds/enemies/zombie_idle_16.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Other1] = [
			"sounds/combat/shieldwall_01.wav",
			"sounds/combat/shieldwall_03.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Other2] = [
			"sounds/combat/smash_hit_01.wav",
			"sounds/combat/smash_hit_02.wav",
			"sounds/combat/smash_hit_03.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.NoDamageReceived] = this.m.Sound[this.Const.Sound.ActorEvent.Idle];
		this.getFlags().add("undead");
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/xxmonster_a_agent");
		this.m.AIAgent.setActor(this);
		this.m.ConfidentMoraleBrush = "icon_confident_orcs";
	}

	function onInit()
	{
		this.human.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.BanditPoacher);
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;
		b.IsImmuneToFire = true;
		b.IsImmuneToStun = true,
		b.IsImmuneToDaze = true,
		b.IsImmuneToOverwhelm = true,
		b.IsImmuneToDamageReflection = true,
		b.IsSpecializedInPolearms = true;
		b.IsAffectedByLosingHitpoints = false;
		b.IsAffectedByFleeingAllies = false;
		b.IsAffectedByDyingAllies = false;
		b.IsAffectedByFreshInjuries = false;
		b.IsAffectedByInjuries = false;
		b.IsAffectedByNight = false;
		b.Hitpoints += 145;
		b.Bravery += 200;
		b.Stamina += 200;
		b.MeleeSkill += 23;
		b.MeleeDefense += 5;
		b.Initiative += -90;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.setAppearance();
		this.getSprite("socket").setBrush("bust_base_beasts");
		this.getSprite("body").setBrush("bust_body_69");
		this.getSprite("body").Color = this.createColor("#edeeff");
		this.getSprite("body").Saturation = 0.2;
		this.getSprite("surcoat").setBrush("bust_body_62");
		this.getSprite("surcoat").Color = this.getSprite("body").Color;
		this.getSprite("surcoat").Saturation = this.getSprite("body").Saturation;
		this.getSprite("head").setBrush("bust_helmet_77");
		this.getSprite("head").Scale = 0.9;
		this.getSprite("head").Color = this.getSprite("body").Color;
		this.getSprite("head").Saturation = this.getSprite("body").Saturation;
		this.getSprite("beard").setBrush("zombie_rage_eyes");
		this.getSprite("beard").Color = this.createColor("#82f6ff");
		this.getSprite("hair").setBrush("bust_helmet_69");
		this.getSprite("hair").Color = this.getSprite("body").Color;
		this.getSprite("hair").Saturation = this.getSprite("body").Saturation;
		this.setSpriteOffset("head", this.createVec(0, 10));
		this.setSpriteOffset("beard", this.createVec(2, -2));
		this.getSprite("arms_icon").Color = this.createColor("#919191");
		this.getSprite("arms_icon").Saturation = 0.01;
		this.setAlwaysApplySpriteOffset(true);
		this.m.Items.equip(this.new("scripts/items/weapons/named/named_warscythe"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_battle_forged"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_nine_lives"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_underdog"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_reach_advantage"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_hold_out"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_pathfinder"));
		this.m.Skills.add(this.new("scripts/skills/traits/teamplayer_trait"));
		this.m.Skills.add(this.new("scripts/skills/actives/ai_bonushit"));
		local rrr = 300;
		b.Armor[this.Const.BodyPart.Head] += rrr;
		b.ArmorMax[this.Const.BodyPart.Head] += rrr;
		b.Armor[this.Const.BodyPart.Body] += rrr;
		b.ArmorMax[this.Const.BodyPart.Body] += rrr;
	}

	function onUpdateInjuryLayer()
	{
		local p = this.m.Hitpoints / this.getHitpointsMax();
		if (p < 0.33)
		{
			this.getSprite("body").setBrush("bust_body_69_damaged");
			this.getSprite("surcoat").setBrush("bust_body_62_damaged");
			this.getSprite("head").setBrush("bust_helmet_77_damaged");
			this.getSprite("hair").setBrush("bust_helmet_69_damaged");
		}
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.m.BloodType = this.Const.BloodType.Ash;
		if (_tile != null)
		{
			local effect = {
				Delay = 0,
				Quantity = 80,
				LifeTimeQuantity = 80,
				SpawnRate = 200,
				Brushes = [
					"sparkleflare_1",
					"sparkleflare_2",
					"sparkleflare_1",
					"sparkleflare_2",
					"sparkleflare_1"
				],
				Stages = [
					{
						LifeTimeMin = 0.2,
						LifeTimeMax = 0.6,
						ColorMin = this.createColor("73f1ff40"),
						ColorMax = this.createColor("73f1ff80"),
						ScaleMin = 0.2,
						ScaleMax = 0.4,
						RotationMin = 0,
						RotationMax = 300,
						VelocityMin = 100,
						VelocityMax = 300,
						DirectionMin = this.createVec(-1.0, -1.0),
						DirectionMax = this.createVec(1.0, 1.0),
						SpawnOffsetMin = this.createVec(0, 0),
						SpawnOffsetMax = this.createVec(0, 0),
						ForceMin = this.createVec(0, 0),
						ForceMax = this.createVec(0, 0)
					},
					{
						LifeTimeMin = 0.2,
						LifeTimeMax = 0.4,
						ColorMin = this.createColor("abf7ff40"),
						ColorMax = this.createColor("abf7ff80"),
						ScaleMin = 0.1,
						ScaleMax = 0.2,
						RotationMin = 0,
						RotationMax = 300,
						VelocityMin = 100,
						VelocityMax = 300,
						DirectionMin = this.createVec(-1.0, -1.0),
						DirectionMax = this.createVec(1.0, 1.0),
						ForceMin = this.createVec(0, -100),
						ForceMax = this.createVec(0, -100)
					},
					{
						LifeTimeMin = 0.1,
						LifeTimeMax = 0.1,
						ColorMin = this.createColor("e3e6ffcc"),
						ColorMax = this.createColor("e3e6ffff"),
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
			this.Tactical.spawnParticleEffect(false, effect.Brushes, _tile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 40));

			effect = {
				Delay = 0,
				Quantity = 80,
				LifeTimeQuantity = 80,
				SpawnRate = 400,
				Brushes = [
					"blood_splatter_bones_01",
					"blood_splatter_bones_03",
					"blood_splatter_bones_04",
					"blood_splatter_bones_05",
					"blood_splatter_bones_06"
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
			this.Tactical.spawnParticleEffect(false, effect.Brushes, _tile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 40));

			for( local i = 0; i < this.Const.Tactical.LightningParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.LightningParticles[i].Brushes, _tile, this.Const.Tactical.LightningParticles[i].Delay, this.Const.Tactical.LightningParticles[i].Quantity, this.Const.Tactical.LightningParticles[i].LifeTimeQuantity, this.Const.Tactical.LightningParticles[i].SpawnRate, this.Const.Tactical.LightningParticles[i].Stages);
			}

			local myTile = this.getTile();
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

						if (!target.isAlive() || target.isDying() || this.isAlliedWith(target))
						{
						}
						else
						{
							local hitInfo = clone this.Const.Tactical.HitInfo;
							local dmg = this.Math.rand(10, 50);
							hitInfo.DamageRegular = 0;
							hitInfo.DamageDirect = 0;
							hitInfo.DamageArmor = dmg;
							hitInfo.BodyPart = this.Const.BodyPart.Body;
							target.onDamageReceived(this, null, hitInfo);
							hitInfo.BodyPart = this.Const.BodyPart.Head;
							target.onDamageReceived(this, null, hitInfo);

							target.playSound(this.Const.Sound.ActorEvent.DamageReceived, 0.8);
							this.Tactical.getShaker().shake(target, target.getTile(), 4);

							dmg = 10;
							if (target.getHitpoints() <= dmg)
							{
								target.getSkills().add(this.new("scripts/skills/effects/bleeding_effect"));
								target.getSkills().add(this.new("scripts/skills/effects/ai_stun_effect"));
							}
							target.setHitpoints(this.Math.max(target.getHitpoints() - dmg, 1));

							for( local i = 0; i < this.Const.Tactical.LightningParticles.len(); i = ++i )
							{
								this.Tactical.spawnParticleEffect(false, this.Const.Tactical.LightningParticles[i].Brushes, nextTile, this.Const.Tactical.LightningParticles[i].Delay, this.Const.Tactical.LightningParticles[i].Quantity, this.Const.Tactical.LightningParticles[i].LifeTimeQuantity, this.Const.Tactical.LightningParticles[i].SpawnRate, this.Const.Tactical.LightningParticles[i].Stages);
							}
						}
					}
				}
			}

			this.Sound.play(this.m.Sound[this.Const.Sound.ActorEvent.Other1][this.Math.rand(0, this.m.Sound[this.Const.Sound.ActorEvent.Other1].len() - 1)], this.Const.Sound.Volume.Actor * 0.7, this.getPos());
			this.Sound.play(this.m.Sound[this.Const.Sound.ActorEvent.Other2][this.Math.rand(0, this.m.Sound[this.Const.Sound.ActorEvent.Other2].len() - 1)], this.Const.Sound.Volume.Actor * 0.7, this.getPos());
		}
		if (_killer == null || _killer.getFaction() == this.Const.Faction.Player || _killer.getFaction() == this.Const.Faction.PlayerAnimals)
		{
			local loot;
			if (this.Math.rand(1, 100) <= 30)
			{
				loot = this.new("scripts/items/loot/soul_splinter_item");
				loot.drop(_tile);
			}
			if (this.Math.rand(1, 100) <= 5)
			{
				loot = this.new("scripts/items/loot/ancient_gold_coins_item");
				loot.drop(_tile);
			}
		}
		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
		this.Sound.play("sounds/combat/poison_applied_01.wav", this.Const.Sound.Volume.Skill * 0.7, this.getTile().Pos);
	}

});

