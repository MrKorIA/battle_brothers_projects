this.xxmob_cosmicsummoner <- this.inherit("scripts/entity/tactical/human", {
	m = {
		Rage = 0,
		Info = null
	},
	function create()
	{
		this.m.Name = this.Const.Strings.FT.M21;
		this.m.Type = this.Const.EntityType.AlpShadow;
		this.m.BloodType = this.Const.BloodType.None;
		this.m.MoraleState = this.Const.MoraleState.Ignore;
		this.m.XP = this.Const.Tactical.Actor.FlyingSkull.XP;
		this.human.create();
		this.m.Faces = null;
		this.m.Hairs = null;
		this.m.HairColors = null;
		this.m.Beards = null;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/donkey_agent");
		this.m.AIAgent.setActor(this);
		this.m.ConfidentMoraleBrush = "icon_confident_orcs";
	}

	function onInit()
	{
		this.human.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.BanditLeader);
		b.Hitpoints += 5500;
		b.Initiative += -222;
		b.MeleeDefense += 90;
		b.RangedDefense += 90;
		b.IsAffectedByNight = false;
		b.IsImmuneToKnockBackAndGrab = true;
		b.IsImmuneToStun = true;
		b.IsMovable = false;
		b.IsAffectedByInjuries = false;
		b.IsRooted = true;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.setAppearance();
		this.addSprite("socket").setBrush("bust_base_beasts");
		this.getSprite("body").setBrush("bust_desert_noble_01");
		this.getSprite("head").setBrush("bust_head_787" + this.Math.rand(4, 5));
		this.getSprite("hair").setBrush("helmet_desert_noble_01");
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (_tile != null)
		{
			local effect = {
				Delay = 0,
				Quantity = 80,
				LifeTimeQuantity = 80,
				SpawnRate = 400,
				Brushes = [
					"blood_splatter_green_01",
					"blood_splatter_bones_01",
					"blood_splatter_sand_01",
					"blood_splatter_wood_01",
					"skull_splatter_04"
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
			for( local i = 0; i < this.Const.Tactical.KrakenDevourVictimParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.KrakenDevourVictimParticles[i].Brushes, _tile, this.Const.Tactical.KrakenDevourVictimParticles[i].Delay, this.Const.Tactical.KrakenDevourVictimParticles[i].Quantity, this.Const.Tactical.KrakenDevourVictimParticles[i].LifeTimeQuantity, this.Const.Tactical.KrakenDevourVictimParticles[i].SpawnRate, this.Const.Tactical.KrakenDevourVictimParticles[i].Stages);
			}
			for( local i = 0; i < this.Const.Tactical.GruesomeFeastParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.GruesomeFeastParticles[i].Brushes, _tile, this.Const.Tactical.GruesomeFeastParticles[i].Delay, this.Const.Tactical.GruesomeFeastParticles[i].Quantity, this.Const.Tactical.GruesomeFeastParticles[i].LifeTimeQuantity, this.Const.Tactical.GruesomeFeastParticles[i].SpawnRate, this.Const.Tactical.GruesomeFeastParticles[i].Stages);
			}
		}
		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);

		this.m.Info = {
			Tile = this.getTile(),
			Faction = this.getFaction()
		};
	}

	function onAfterDeath( _tile )
	{
		if (!this.m.Info.Tile.IsEmpty)
		{
			local changed = false;
			for( local i = 0; i != 6; i = ++i )
			{
				if (!this.m.Info.Tile.hasNextTile(i))
				{
				}
				else
				{
					local tile = this.m.Info.Tile.getNextTile(i);

					if (tile.IsEmpty && this.Math.abs(tile.Level - this.m.Info.Tile.Level) <= 1)
					{
						this.m.Info.Tile = tile;
						changed = true;
						break;
					}
				}
			}
			if (!changed)
			{
				return;
			}
		}
		local e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/xxmob_cosmic", this.m.Info.Tile.Coords);
		e.setFaction(this.m.Info.Faction);
	}

	function onTurnEnd()
	{
		this.actor.onTurnEnd();
		if (this.Tactical.Entities.isEnemyRetreating() || this.Tactical.State.isAutoRetreat() || !this.m.IsAlive || this.m.IsDying)
		{
			return;
		}
		this.m.Rage = this.m.Rage + 1;
		if (this.m.Rage == 1)
		{
			local gg = this.Tactical.Entities.getInstancesOfFaction(this.actor.getFaction());
			foreach( a in gg )
			{
				if (a.getID() == this.actor.getID() || !a.isPlacedOnMap())
				{
					continue;
				}
				if (a.isAlive() && !a.isPlayerControlled())
				{
					a.getBaseProperties().Hitpoints = 500;
					a.getBaseProperties().Initiative = 2222;
					a.setMoraleState(this.Const.MoraleState.Fleeing);
					a.getSkills().add(this.new("scripts/skills/actives/ai_fakebuff"));
					a.getSkills().add(this.new("scripts/skills/effects/adrenaline_effect"));
					a.getSkills().add(this.new("scripts/skills/effects/stunned_effect"));
					local effect = this.new("scripts/skills/effects/bleeding_effect");
					effect.setDamage(5000);
					a.getSkills().add(effect);
				}
			}
			this.actor.getSprite("body").Color = this.createColor("#ad0000");
			this.actor.getSprite("head").Color = this.createColor("#ad0000");
			this.actor.getSprite("hair").Color = this.createColor("#ad0000");
			this.actor.getSprite("beard_top").setBrush("zombie_rage_eyes");
			this.actor.getSprite("beard_top").Saturation = 0.3;
			for( local i = 0; i < this.Const.Tactical.DarkflightStartParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DarkflightStartParticles[i].Brushes, this.actor.getTile(), this.Const.Tactical.DarkflightStartParticles[i].Delay, this.Const.Tactical.DarkflightStartParticles[i].Quantity, this.Const.Tactical.DarkflightStartParticles[i].LifeTimeQuantity, this.Const.Tactical.DarkflightStartParticles[i].SpawnRate, this.Const.Tactical.DarkflightStartParticles[i].Stages);
			}
			for( local i = 0; i < this.Const.Tactical.RaiseUndeadParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.RaiseUndeadParticles[i].Brushes, this.actor.getTile(), this.Const.Tactical.RaiseUndeadParticles[i].Delay, this.Const.Tactical.RaiseUndeadParticles[i].Quantity, this.Const.Tactical.RaiseUndeadParticles[i].LifeTimeQuantity, this.Const.Tactical.RaiseUndeadParticles[i].SpawnRate, this.Const.Tactical.RaiseUndeadParticles[i].Stages);
			}
			local sounds = [
				"sounds/combat/rage_01.wav",
				"sounds/combat/rage_02.wav"
			];
			this.Sound.play(sounds[this.Math.rand(0, sounds.len() - 1)], 1.9, this.actor.getTile().Pos);
			this.actor.getBaseProperties().IsImmuneToStun = false;
			this.actor.getSkills().add(this.new("scripts/skills/effects/adrenaline_effect"));
			this.actor.getSkills().add(this.new("scripts/skills/effects/stunned_effect"));
			this.actor.getBaseProperties().Initiative = -2222;
		}
		else
		if (this.m.Rage >= 2)
		{
			local sounds = [
				"sounds/enemies/gruesome_feast_03.wav"
			];
			this.Sound.play(sounds[this.Math.rand(0, sounds.len() - 1)], 1.9, this.actor.getTile().Pos);
			this.actor.kill();
		}
	}

});

