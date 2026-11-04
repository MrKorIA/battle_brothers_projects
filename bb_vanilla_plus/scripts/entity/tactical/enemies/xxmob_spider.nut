this.xxmob_spider <- this.inherit("scripts/entity/tactical/actor", {
	m = {
		Size = 1.0,
		DistortTargetA = null,
		DistortTargetPrevA = this.createVec(0, 0),
		DistortTargetB = null,
		DistortTargetPrevB = this.createVec(0, 0),
		DistortTargetC = null,
		DistortTargetPrevC = this.createVec(0, 0),
		DistortAnimationStartTimeA = 0,
		IsFlipping = false
	},
	function create()
	{
		this.m.Name = this.Const.Strings.FT.M66;
		this.m.Type = this.Const.EntityType.AlpShadow;
		this.m.BloodType = this.Const.BloodType.Green;
		this.m.XP = this.Const.Tactical.Actor.FlyingSkull.XP;
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.m.DecapitateSplatterOffset = this.createVec(20, -15);
		this.m.DecapitateBloodAmount = 1.0;
		this.m.ConfidentMoraleBrush = "icon_confident_orcs";
		this.m.ExcludedInjuries = [
			"injury.fractured_hand",
			"injury.crushed_finger",
			"injury.fractured_elbow",
			"injury.smashed_hand",
			"injury.broken_arm",
			"injury.cut_arm_sinew",
			"injury.cut_arm",
			"injury.split_hand",
			"injury.pierced_hand",
			"injury.pierced_arm_muscles",
			"injury.burnt_hands"
		];
		this.actor.create();
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/ghoul_hurt_01.wav",
			"sounds/enemies/ghoul_hurt_02.wav",
			"sounds/enemies/ghoul_hurt_03.wav",
			"sounds/enemies/ghoul_hurt_04.wav",
			"sounds/enemies/ghoul_hurt_05.wav",
			"sounds/enemies/ghoul_hurt_06.wav",
			"sounds/enemies/ghoul_hurt_07.wav",
			"sounds/enemies/ghoul_hurt_08.wav",
			"sounds/enemies/ghoul_hurt_09.wav",
			"sounds/enemies/ghoul_hurt_10.wav",
			"sounds/enemies/ghoul_hurt_11.wav",
			"sounds/enemies/ghoul_hurt_12.wav",
			"sounds/enemies/ghoul_hurt_13.wav",
			"sounds/enemies/ghoul_hurt_14.wav",
			"sounds/enemies/ghoul_hurt_15.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/ghoul_death_01.wav",
			"sounds/enemies/ghoul_death_02.wav",
			"sounds/enemies/ghoul_death_03.wav",
			"sounds/enemies/ghoul_death_04.wav",
			"sounds/enemies/ghoul_death_05.wav",
			"sounds/enemies/ghoul_death_06.wav",
			"sounds/enemies/ghoul_death_07.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/ghoul_flee_01.wav",
			"sounds/enemies/ghoul_flee_02.wav",
			"sounds/enemies/ghoul_flee_03.wav",
			"sounds/enemies/ghoul_flee_04.wav",
			"sounds/enemies/ghoul_flee_05.wav",
			"sounds/enemies/ghoul_flee_06.wav",
			"sounds/enemies/ghoul_flee_07.wav",
			"sounds/enemies/ghoul_flee_08.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/ghoul_idle_01.wav",
			"sounds/enemies/ghoul_idle_02.wav",
			"sounds/enemies/ghoul_idle_03.wav",
			"sounds/enemies/ghoul_idle_04.wav",
			"sounds/enemies/ghoul_idle_05.wav",
			"sounds/enemies/ghoul_idle_06.wav",
			"sounds/enemies/ghoul_idle_07.wav",
			"sounds/enemies/ghoul_idle_08.wav",
			"sounds/enemies/ghoul_idle_09.wav",
			"sounds/enemies/ghoul_idle_10.wav",
			"sounds/enemies/ghoul_idle_11.wav",
			"sounds/enemies/ghoul_idle_12.wav",
			"sounds/enemies/ghoul_idle_13.wav",
			"sounds/enemies/ghoul_idle_14.wav",
			"sounds/enemies/ghoul_idle_15.wav",
			"sounds/enemies/ghoul_idle_16.wav",
			"sounds/enemies/ghoul_idle_17.wav",
			"sounds/enemies/ghoul_idle_18.wav",
			"sounds/enemies/ghoul_idle_19.wav",
			"sounds/enemies/ghoul_idle_20.wav",
			"sounds/enemies/ghoul_idle_21.wav",
			"sounds/enemies/ghoul_idle_22.wav",
			"sounds/enemies/ghoul_idle_23.wav",
			"sounds/enemies/ghoul_idle_24.wav",
			"sounds/enemies/ghoul_idle_25.wav",
			"sounds/enemies/ghoul_idle_26.wav",
			"sounds/enemies/ghoul_idle_27.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Move] = this.m.Sound[this.Const.Sound.ActorEvent.Idle];
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Move] = 0.7;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Idle] = 2.0;
		this.m.SoundPitch = this.Math.rand(95, 105) * 0.01;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/xxmonster_a_agent");
		this.m.AIAgent.setActor(this);
	}

	function playSound( _type, _volume, _pitch = 1.0 )
	{
		if (_type == this.Const.Sound.ActorEvent.Move && this.Math.rand(1, 100) <= 33)
		{
			return;
		}

		this.actor.playSound(_type, _volume, _pitch);
	}

	function onRender()
	{
		this.actor.onRender();

		if (this.m.DistortTargetA == null)
		{
			this.m.DistortTargetA = this.m.IsFlipping ? this.createVec(0, 1.0 * this.m.Size) : this.createVec(0, -1.0 * this.m.Size);
			this.m.DistortTargetB = !this.m.IsFlipping ? this.createVec(-0.5 * this.m.Size, 0) : this.createVec(0.5 * this.m.Size, 0);
			this.m.DistortTargetC = !this.m.IsFlipping ? this.createVec(0.5 * this.m.Size, 0) : this.createVec(-0.5 * this.m.Size, 0);
			this.m.DistortAnimationStartTimeA = this.Time.getVirtualTimeF() - this.Math.rand(10, 100) * 0.01;
		}

		this.moveSpriteOffset("legs_back", this.m.DistortTargetPrevB, this.m.DistortTargetB, 1.0, this.m.DistortAnimationStartTimeA);
		this.moveSpriteOffset("legs_front", this.m.DistortTargetPrevC, this.m.DistortTargetC, 1.0, this.m.DistortAnimationStartTimeA);
		this.moveSpriteOffset("body", this.m.DistortTargetPrevA, this.m.DistortTargetA, 1.0, this.m.DistortAnimationStartTimeA);
		this.moveSpriteOffset("injury", this.m.DistortTargetPrevA, this.m.DistortTargetA, 1.0, this.m.DistortAnimationStartTimeA);

		if (this.moveSpriteOffset("head", this.m.DistortTargetPrevA, this.m.DistortTargetA, 1.0, this.m.DistortAnimationStartTimeA))
		{
			this.m.DistortAnimationStartTimeA = this.Time.getVirtualTimeF();
			this.m.DistortTargetPrevA = this.m.DistortTargetA;
			this.m.DistortTargetA = this.m.IsFlipping ? this.createVec(0, 1.0 * this.m.Size) : this.createVec(0, -1.0 * this.m.Size);
			this.m.DistortTargetPrevB = this.m.DistortTargetB;
			this.m.DistortTargetB = !this.m.IsFlipping ? this.createVec(-0.5 * this.m.Size, 0) : this.createVec(0.5 * this.m.Size, 0);
			this.m.DistortTargetPrevC = this.m.DistortTargetC;
			this.m.DistortTargetC = !this.m.IsFlipping ? this.createVec(0.5 * this.m.Size, 0) : this.createVec(-0.5 * this.m.Size, 0);
			this.m.IsFlipping = !this.m.IsFlipping;
		}
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (_tile != null)
		{
			local flip = this.Math.rand(0, 100) < 50;
			local decal;
			local body_decal;
			local head_decal;
			this.m.IsCorpseFlipped = flip;
			local body = this.getSprite("body");
			local head = this.getSprite("head");
			decal = _tile.spawnDetail("bust_spider_body_01_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = body.Color;
			decal.Saturation = body.Saturation;
			decal.Scale = 0.9 * this.m.Size;
			body_decal = decal;

			if (_fatalityType != this.Const.FatalityType.Decapitated)
			{
				decal = _tile.spawnDetail("bust_spider_head_01_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Color = head.Color;
				decal.Saturation = head.Saturation;
				decal.Scale = 0.9 * this.m.Size;
				head_decal = decal;

				if (_fatalityType == this.Const.FatalityType.None)
				{
					local corpse_data = {
						Body = body_decal,
						Head = head_decal,
						Start = this.Time.getRealTimeF(),
						Vector = this.createVec(0.0, -1.0),
						Iterations = 0,
						function onCorpseEffect( _data )
						{
							if (this.Time.getRealTimeF() - _data.Start > 0.2)
							{
								if (++_data.Iterations > 5)
								{
									return;
								}

								_data.Vector = this.createVec(this.Math.rand(-100, 100) * 0.01, this.Math.rand(-100, 100) * 0.01);
								_data.Start = this.Time.getRealTimeF();
							}

							local f = (this.Time.getRealTimeF() - _data.Start) / 0.2;
							_data.Body.setOffset(this.createVec(0.0 + 0.5 * _data.Vector.X * f, 30.0 + 1.0 * _data.Vector.Y * f));
							_data.Head.setOffset(this.createVec(0.0 + 0.5 * _data.Vector.X * f, 30.0 + 1.0 * _data.Vector.Y * f));
							this.Time.scheduleEvent(this.TimeUnit.Real, 10, _data.onCorpseEffect, _data);
						}

					};
					this.Time.scheduleEvent(this.TimeUnit.Real, 10, corpse_data.onCorpseEffect, corpse_data);
				}
			}
			else if (_fatalityType == this.Const.FatalityType.Decapitated)
			{
				local layers = [
					"bust_spider_head_01_dead"
				];
				local decap = this.Tactical.spawnHeadEffect(this.getTile(), layers, this.createVec(-50, -10), 0.0, "bust_spider_head_01_dead_bloodpool");
				decap[0].Color = head.Color;
				decap[0].Saturation = head.Saturation;
				decap[0].Scale = 0.9 * this.m.Size;
			}

			if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Arrow)
			{
				decal = _tile.spawnDetail("bust_spider_body_01_dead_arrows", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.9 * this.m.Size;
			}

			if (_fatalityType == this.Const.FatalityType.Disemboweled)
			{
				decal = _tile.spawnDetail("bust_spider_gut", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.9 * this.m.Size;
			}
			else if (_fatalityType == this.Const.FatalityType.Smashed)
			{
				decal = _tile.spawnDetail("bust_spider_skull", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.9 * this.m.Size;
			}

			this.spawnTerrainDropdownEffect(_tile);
			this.spawnFlies(_tile);
			local corpse = clone this.Const.Corpse;
			corpse.CorpseName = this.getName();
			corpse.IsHeadAttached = _fatalityType != this.Const.FatalityType.Decapitated;
			corpse.IsConsumable = true;
			_tile.Properties.set("Corpse", corpse);
			this.Tactical.Entities.addCorpse(_tile);
		}
		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function onInit()
	{
		this.actor.onInit();
		this.setRenderCallbackEnabled(true);
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.BanditRaider);
		b.IsAffectedByNight = false;
		b.IsImmuneToDisarm = true;
		b.Vision += 3;
		b.Hitpoints += 100;
		b.RangedSkill += 15;
		b.Bravery += 200;
		b.Stamina += 50;
		b.DamageRegularMin += 70;
		b.DamageRegularMax += 80;
		b.DamageArmorMult *= 0.5;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.m.MaxTraversibleLevels = 3;
		this.addSprite("socket").setBrush("bust_base_beasts");
		local legs_back = this.addSprite("legs_back");
		legs_back.setBrush("bust_spider_legs_back");
		local body = this.addSprite("body");
		body.setBrush("bust_spider_body_0" + this.Math.rand(1, 4));
		if (this.Math.rand(0, 100) < 90)
		{
			body.varySaturation(0.3);
		}
		if (this.Math.rand(0, 100) < 90)
		{
			body.varyColor(0.1, 0.1, 0.1);
		}
		if (this.Math.rand(0, 100) < 90)
		{
			body.varyBrightness(0.1);
		}
		local legs_front = this.addSprite("legs_front");
		legs_front.setBrush("bust_spider_legs_front");
		legs_front.Color = body.Color;
		legs_front.Saturation = body.Saturation;
		legs_back.Color = body.Color;
		legs_back.Saturation = body.Saturation;
		local head = this.addSprite("head");
		head.setBrush("bust_xxspider_head_51");
		head.Color = body.Color;
		head.Saturation = body.Saturation;
		local injury = this.addSprite("injury");
		injury.Visible = false;
		injury.setBrush("bust_spider_01_injured");
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.65;
		this.setSpriteOffset("status_rooted", this.createVec(7, 10));
		this.setSpriteOffset("status_stunned", this.createVec(0, -20));
		this.setSpriteOffset("arrow", this.createVec(0, -20));
		this.setSize(this.Math.rand(70, 90) * 0.01);

		local wtt = this.new("scripts/items/weapons/named/xx_mob_fakeweapon15");
		wtt.m.RangeMax = 3;
		wtt.m.RangeIdeal = 3;
		this.m.Items.equip(wtt);

		this.m.Skills.add(this.new("scripts/skills/perks/perk_pathfinder"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_fast_adaption"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_backstabber"));
		this.m.Skills.add(this.new("scripts/skills/actives/footwork"));
		local sk = this.new("scripts/skills/actives/ai_meleeshoot");
		sk.m.SoundVolume = 1.2;
		sk.m.Overlay = "active_115";
		sk.m.ActionPointCost = 6;
		sk.m.SoundOnUse = [
			"sounds/enemies/goblin_attack_01.wav",
			"sounds/enemies/goblin_attack_02.wav"
		];
		sk.m.SoundOnHit = [
			"sounds/enemies/vampire_life_drain_01.wav"
		];
		sk.m.DirectDamageMult = 0.3;
		sk.m.ActionPointCost = 6;
		sk.m.MaxRange = 4;
		sk.m.ChanceSmash = 4;
		this.m.Skills.add(sk);
		sk = this.new("scripts/skills/actives/ai_poison_passive");
		sk.setDamage(5);
		this.m.Skills.add(sk);
	}

	function setSize( _s )
	{
		this.m.Size = _s;
		this.m.DecapitateBloodAmount = _s * 0.75;
		this.getSprite("body").Scale = _s;
		this.getSprite("head").Scale = _s;
		this.getSprite("injury").Scale = _s;
		this.getSprite("status_rooted").Scale = _s * 0.65;
		this.getSprite("status_rooted_back").Scale = _s * 0.65;
		this.getSprite("legs_back").Scale = _s;
		this.getSprite("legs_front").Scale = _s;
		local offset = this.createVec(0, -10.0 * (1.0 - _s));
		this.setSpriteOffset("body", offset);
		this.setSpriteOffset("head", offset);
		this.setSpriteOffset("injury", offset);
		this.setSpriteOffset("status_rooted", this.createVec(7, 10 - 10.0 * (1.0 - _s)));
		this.setSpriteOffset("status_rooted_back", this.createVec(7, 10 - 10.0 * (1.0 - _s)));
		this.setSpriteOffset("legs_back", offset);
		this.setSpriteOffset("legs_front", offset);
	}

});

