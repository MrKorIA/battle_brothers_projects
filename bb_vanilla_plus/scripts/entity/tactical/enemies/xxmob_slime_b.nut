this.xxmob_slime_b <- this.inherit("scripts/entity/tactical/actor", {
	m = {
		BackupFaction = 0,
		IsSpawningOnTile = false
	},
	function create()
	{
		this.m.Name = this.Const.Strings.FT.M63;
		this.m.Type = this.Const.EntityType.AlpShadow;
		this.m.BloodType = this.Const.BloodType.Green;
		this.m.MoraleState = this.Const.MoraleState.Ignore;
		this.m.XP = this.Const.Tactical.Actor.OrcBerserker.XP;
		this.m.ConfidentMoraleBrush = "icon_confident_orcs";
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
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/movement/movement_muddy_earth_01.wav",
			"sounds/movement/movement_muddy_earth_02.wav",
			"sounds/movement/movement_muddy_earth_03.wav",
			"sounds/movement/movement_muddy_earth_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Move] = this.m.Sound[this.Const.Sound.ActorEvent.Idle];
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Move] = 1.2;
		this.m.SoundPitch = this.Math.rand(70, 120) * 0.01;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/skeleton_melee_agent");
		this.m.AIAgent.setActor(this);
	}

	function playSound( _type, _volume, _pitch = 1.0 )
	{
		if (_type == this.Const.Sound.ActorEvent.Move && this.Math.rand(1, 100) <= 20)
		{
			return;
		}

		this.actor.playSound(_type, _volume, _pitch);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.m.BackupFaction = this.getFaction();
		if (_tile != null)
		{
			local effect = {
				Delay = 0,
				Quantity = 80,
				LifeTimeQuantity = 80,
				SpawnRate = 50,
				Brushes = [
					"blood_splatter_green_01",
					"blood_splatter_green_02",
					"blood_splatter_green_05",
					"blood_splatter_green_06",
					"blood_splatter_green_07",
					"blood_splatter_green_08",
					"blood_splatter_green_09"
				],
				Stages = [
					{
				LifeTimeMin = 0.1,
				LifeTimeMax = 0.1,
				ColorMin = this.createColor("ffffff00"),
				ColorMax = this.createColor("ffffff00"),
				ScaleMin = 1.0,
				ScaleMax = 1.0,
				RotationMin = 0,
				RotationMax = 359,
				VelocityMin = 150,
				VelocityMax = 300,
				DirectionMin = this.createVec(-0.2, 0.3),
				DirectionMax = this.createVec(0.0, 0.7),
				SpawnOffsetMin = this.createVec(-50, 15),
				SpawnOffsetMax = this.createVec(-20, 30)
					},
					{
				LifeTimeMin = 1.5,
				LifeTimeMax = 1.5,
				ColorMin = this.createColor("ffffffff"),
				ColorMax = this.createColor("ffffffff"),
				ScaleMin = 0.5,
				ScaleMax = 0.75,
				RotationMin = 0,
				RotationMax = 359,
				VelocityMin = 100,
				VelocityMax = 200,
				ForceMin = this.createVec(0, -80),
				ForceMax = this.createVec(0, -80)
					},
					{
				LifeTimeMin = 0.1,
				LifeTimeMax = 0.2,
				ColorMin = this.createColor("ffffff00"),
				ColorMax = this.createColor("ffffff00"),
				ScaleMin = 0.5,
				ScaleMax = 0.75,
				RotationMin = 0,
				RotationMax = 359,
				VelocityMin = 100,
				VelocityMax = 200,
				ForceMin = this.createVec(0, -160),
				ForceMax = this.createVec(0, -160)
					}
				]
			};
			this.Tactical.spawnParticleEffect(false, effect.Brushes, _tile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 40));
			local flip = this.Math.rand(0, 100) < 50;
			this.m.IsCorpseFlipped = flip;
			local decal = _tile.spawnDetail("bust_lindwurm_head_01_bloodpool", this.Const.Tactical.DetailFlag.Corpse, flip, false);
			this.spawnTerrainDropdownEffect(_tile);

			local freeTiles = [];
			for( local i = 0; i < 6; i = ++i )
			{
				if (!_tile.hasNextTile(i))
				{
				}
				else
				{
					local nextTile = _tile.getNextTile(i);

					if (nextTile.Level > _tile.Level + 1)
					{
					}
					else if (nextTile.IsEmpty)
					{
						freeTiles.push(nextTile);
					}
				}
			}
			if (freeTiles.len() != 0)
			{
				local spawnmax = 1;
				local n = 2;
				n = --n;
				while (n >= 0 && freeTiles.len() >= 1 && spawnmax > 0)
				{
					spawnmax = spawnmax - 1;
					local r = this.Math.rand(0, freeTiles.len() - 1);
					local tile = freeTiles[r];
					freeTiles.remove(r);
					local rock = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/xxmob_slime_a", tile.Coords.X, tile.Coords.Y);
					rock.setFaction(this.getFaction());
					if (tile.IsVisibleForPlayer)
					{
						for( local i = 0; i < this.Const.Tactical.SandGolemParticles.len(); i = ++i )
						{
							this.Tactical.spawnParticleEffect(false, this.Const.Tactical.SandGolemParticles[i].Brushes, tile, this.Const.Tactical.SandGolemParticles[i].Delay, this.Const.Tactical.SandGolemParticles[i].Quantity, this.Const.Tactical.SandGolemParticles[i].LifeTimeQuantity, this.Const.Tactical.SandGolemParticles[i].SpawnRate, this.Const.Tactical.SandGolemParticles[i].Stages);
						}
					}
				}
				if (n > 0)
				{
					this.m.IsSpawningOnTile = true;
				}
			}
			else
			{
				this.m.IsSpawningOnTile = true;
			}
		}
		else
		{
			this.m.IsSpawningOnTile = true;
		}
		if (_killer == null || _killer.getFaction() == this.Const.Faction.Player || _killer.getFaction() == this.Const.Faction.PlayerAnimals)
		{
			local loot;
			if (this.Math.rand(1, 100) <= 30)
			{
				loot = this.new("scripts/items/loot/webbed_valuables_item");
				loot.drop(_tile);
			}
		}
		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function onAfterDeath( _tile )
	{
		if (!this.m.IsSpawningOnTile)
		{
			return;
		}
		local rock;
		if (this.Math.rand(1, 100) <= 20)
		{
			if (this.Math.rand(1, 100) <= 50)
			{
				rock = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/orc_young_low", _tile.Coords.X, _tile.Coords.Y);
				rock.assignRandomEquipment();
				rock.getSprite("body_blood").setBrush("bust_slime");
				rock.getSprite("body_blood").Visible = true;
				rock.getSprite("body_blood").setHorizontalFlipping(true);
			}
			else
			{
				rock = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/xxsum_skeleton", _tile.Coords.X, _tile.Coords.Y);
				rock.setFaction(this.m.BackupFaction);
				rock.getSprite("hair").setBrush("bust_slime");
			}
		}
		else
		{
			rock = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/xxmob_slime_a", _tile.Coords.X, _tile.Coords.Y);
		}
		rock.setFaction(this.m.BackupFaction);
	}

	function onInit()
	{
		this.actor.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.BanditPoacher);
		b.IsAffectedByNight = false;
		b.IsImmuneToDisarm = true;
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;
		b.IsAffectedByInjuries = false;
		b.Hitpoints += 245;
		b.MeleeSkill += 10;
		b.Initiative += -55;
		b.DamageRegularMin += 30;
		b.DamageRegularMax += 50;
		b.DamageArmorMult *= 3;
		b.MovementAPCostAdditional += 1;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.addSprite("socket").setBrush("bust_base_beasts");
		local body = this.addSprite("body");
		body.setBrush("bust_slime" + this.Math.rand(1, 3));
		body.varySaturation(0.25);
		body.varyColor(0.11, 0.11, 0.11);
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.54;
		this.setSpriteOffset("status_rooted", this.createVec(0, 0));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_steel_brow"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_hold_out"));
		this.m.Skills.add(this.new("scripts/skills/actives/ai_psv_slime"));
		local skilla = this.new("scripts/skills/actives/ai_punch");
		skilla.m.ActionPointCost = 7;
		skilla.m.DirectDamageMult = 0.2;
		skilla.m.Overlay = "active_217";
		skilla.m.SoundOnUse = [
			"sounds/combat/hand_01.wav",
			"sounds/combat/hand_02.wav",
			"sounds/combat/hand_03.wav"
		];
		skilla.m.SoundOnHit = [
			"sounds/combat/hand_hit_01.wav",
			"sounds/combat/hand_hit_02.wav",
			"sounds/combat/hand_hit_03.wav"
		];
		this.m.Skills.add(skilla);
	}

});

