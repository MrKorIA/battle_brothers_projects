this.lingmujiangshi <- this.inherit("scripts/entity/tactical/actor", {
	m = {
		Info = null
	},
	function create()
	{
		this.m.Type = this.Const.EntityType.Lingmujiangshi;
		this.m.BloodType = this.Const.BloodType.None;
		this.m.MoraleState = this.Const.MoraleState.Ignore;
		this.m.XP = this.Const.Tactical.Actor.Lingmujiangshi.XP;
		this.actor.create();
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/zombie_hurt_01.wav",
			"sounds/enemies/zombie_hurt_02.wav",
			"sounds/enemies/zombie_hurt_03.wav",
			"sounds/enemies/zombie_hurt_04.wav",
			"sounds/enemies/zombie_hurt_05.wav",
			"sounds/enemies/zombie_hurt_06.wav",
			"sounds/enemies/zombie_hurt_07.wav"
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
			"sounds/enemies/ghastly_touch_01.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Move] = this.m.Sound[this.Const.Sound.ActorEvent.Idle];
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Move] = 0.1;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.DamageReceived] = 0.5;
		this.m.SoundPitch = 80 * 0.01;
		this.getFlags().add("undead");
		this.getFlags().add("zombie_minion");
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/zombie_agent");
		this.m.AIAgent.setActor(this);
	}

	function playSound( _type, _volume, _pitch = 1.0 )
	{
		if (_type == this.Const.Sound.ActorEvent.Move && this.Math.rand(1, 100) <= 50)
		{
			return;
		}

		this.actor.playSound(_type, _volume, _pitch);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		local flip = this.Math.rand(1, 100) < 50;

		if (_tile != null)
		{
			this.m.IsCorpseFlipped = flip;
			local decal;
			decal = _tile.spawnDetail("bust_lingmu_body_02_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.Scale = 0.9;
			decal.setBrightness(0.9);
			decal = _tile.spawnDetail("bust_lingmu_02_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.Scale = 0.9;
			decal.setBrightness(0.9);
			this.spawnTerrainDropdownEffect(_tile);
			local corpse = clone this.Const.Corpse;
			corpse.CorpseName = this.getName();
			corpse.Tile = _tile;
			corpse.IsResurrectable = false;
			corpse.IsConsumable = false;
			corpse.IsHeadAttached = _fatalityType != this.Const.FatalityType.Decapitated;
			_tile.Properties.set("Corpse", corpse);
			this.Tactical.Entities.addCorpse(_tile);
		}

		this.m.Info = {
			Tile = this.getTile(),
			Faction = this.getFaction()
		};
		this.Sound.play("sounds/enemies/zombie_death_01.wav", this.Const.Sound.Volume.Skill * 2.25, this.m.Info.Tile.Pos);
		local mapSize = this.Tactical.getMapSize();
		local attempts = 0;
		local n = 0;

		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	

	function spawnSpawnEffect( _tile )
	{
		local effect = {
			Delay = 0,
			Quantity = 12,
			LifeTimeQuantity = 12,
			SpawnRate = 100,
			Brushes = [
				"bust_ghost_01"
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
		this.Tactical.spawnParticleEffect(false, effect.Brushes, _tile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 40));
	}

	function onUpdateInjuryLayer()
	{
		local body = this.getSprite("body");
		local head = this.getSprite("head");
		local p = this.m.Hitpoints / this.getHitpointsMax();

		if (p > 0.5)
		{
			body.setBrush("bust_lingmu_body_02");
			head.setBrush("bust_lingmu_02");
		}
		else
		{
			body.setBrush("bust_lingmu_body_02_damaged");
			head.setBrush("bust_lingmu_02_damaged");
		}

		this.setDirty(true);
	}

	function onFactionChanged()
	{
		this.actor.onFactionChanged();
		local flip = !this.isAlliedWithPlayer();
		this.getSprite("body").setHorizontalFlipping(flip);
		this.getSprite("head").setHorizontalFlipping(flip);
	}

	function onInit()
	{
		this.actor.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.Lingmujiangshi);
		b.SurroundedBonus = 10;
		b.IsAffectedByNight = false;
		b.IsAffectedByInjuries = false;
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;
		b.FatigueDealtPerHitMult = 2.0;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.addSprite("socket").setBrush("bust_base_undead");
		local body = this.addSprite("body");
		body.setBrush("bust_lingmu_body_02");
		local head = this.addSprite("head");
		head.setBrush("bust_lingmu_02");
		this.addDefaultStatusSprites();
		this.setSpriteOffset("status_stunned", this.createVec(0, 10));
		this.setSpriteOffset("arrow", this.createVec(0, 10));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_crippling_strikes"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_steel_brow"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_stalwart"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_hold_out"));
		this.m.Skills.add(this.new("scripts/skills/racial/skeleton_racial"));
		this.assignRandomEquipment();
	}

	function assignRandomEquipment()
	{
		if (this.m.Items.hasEmptySlot(this.Const.ItemSlot.Mainhand))
		{
			local weapons = [
				"weapons/mgl_01",
			    "weapons/mgl_02",
			    "weapons/mgl_07",
			    "weapons/mgl_11",
				"weapons/mgl_03",
			    "weapons/mgl_04",
			    "weapons/mgl_08",
			    "weapons/mgl_10",
			    "weapons/mgl_12"
			];

			this.m.Items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
		}
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

