this.mod_ghost_mage_boss <- ::inherit("scripts/entity/tactical/actor", {
	m = {
		Variant = 1,
		DistortTargetA = null,
		DistortTargetPrevA = ::createVec(0, 0),
		DistortAnimationStartTimeA = 0,
		DistortTargetB = null,
		DistortTargetPrevB = ::createVec(0, 0),
		DistortAnimationStartTimeB = 0,
		DistortTargetC = null,
		DistortTargetPrevC = ::createVec(0, 0),
		DistortAnimationStartTimeC = 0,
		DistortTargetD = null,
		DistortTargetPrevD = ::createVec(0, 0),
		DistortAnimationStartTimeD = 0
	},
	function create()
	{
		this.m.Type = ::Const.EntityType.SkeletonLichMirrorImage;
		this.m.BloodType = ::Const.BloodType.None;
		this.m.MoraleState = ::Const.MoraleState.Ignore;
		this.m.IsEmittingMovementSounds = false;
		this.m.XP = 3000;
		this.actor.create();
		this.m.Name = "Кригсгейст";
		this.customHookForSkillContainer();
		this.m.Sound[::Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/dlc6/lich_death_01.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/geist_idle_01.wav",
			"sounds/enemies/geist_idle_02.wav",
			"sounds/enemies/geist_idle_03.wav",
			"sounds/enemies/geist_idle_04.wav",
			"sounds/enemies/geist_idle_05.wav",
			"sounds/enemies/geist_idle_06.wav",
			"sounds/enemies/geist_idle_07.wav",
			"sounds/enemies/geist_idle_08.wav",
			"sounds/enemies/geist_idle_09.wav",
			"sounds/enemies/geist_idle_10.wav",
			"sounds/enemies/geist_idle_11.wav",
			"sounds/enemies/geist_idle_12.wav",
			"sounds/enemies/geist_idle_13.wav",
			"sounds/enemies/geist_idle_14.wav",
			"sounds/enemies/geist_idle_15.wav",
			"sounds/enemies/geist_idle_16.wav",
			"sounds/enemies/geist_idle_17.wav"
		];
		this.m.Sound[::Const.Sound.ActorEvent.DamageReceived] = this.m.Sound[::Const.Sound.ActorEvent.Death];
		this.m.SoundVolume[::Const.Sound.ActorEvent.DamageReceived] = 0.5;
		this.m.SoundPitch = 80 * 0.01;
		this.getFlags().add("undetectable", true);
		this.getFlags().add("ghost_boss");
		this.getFlags().add("ghost_mage");
		this.getFlags().add("undead");
		this.getFlags().add("ghost");
		this.m.AIAgent = ::new("scripts/ai/tactical/agents/mod_ghost_mage_boss_agent");
		this.m.AIAgent.setActor(this);
	}

	function getGhostSprite()
	{
		return this.getSprite("body").getBrush().Name;
	}

	function hasIllusion()
	{
		foreach (a in ::Tactical.Entities.getInstancesOfFaction(this.getFaction()))
		{
			if (a.getFlags().has("illusion")) return true;
		}

		return false;
	}

	function getGhostIllusionNum()
	{
		local ret = 0;

		foreach (a in ::Tactical.Entities.getInstancesOfFaction(this.getFaction()))
		{
			if (a.getFlags().has("illusion")) ++ret;
		}

		return ret;
	}

	function getGhostIllusionNumMax()
	{
		return ::Tactical.Entities.getFlags().getAsInt("ghost_illusion_max");
	}

	function getGhostIllusionCanAdd()
	{
		return ::Math.max(0, this.getGhostIllusionNumMax() - this.getGhostIllusionNum());
	}

	function hasEnoughIllusion()
	{
		return this.getGhostIllusionCanAdd() == 0;
	}

	function updateIllusionHP()
	{
		local hp = this.getHitpoints();

		if (hp <= 0) return;

		foreach (a in ::Tactical.Entities.getInstancesOfFaction(this.getFaction()))
		{
			if (!a.getFlags().has("illusion"))
			{
				continue;
			}

			a.setHitpoints(hp);
		}
	}

	function kill( _killer = null, _skill = null, _fatalityType = ::Const.FatalityType.None, _silent = false )
	{
		this.m.IsDying = true;

		foreach (a in ::Tactical.Entities.getInstancesOfFaction(this.getFaction()))
		{
			if (!a.getFlags().has("illusion"))
			{
				continue;
			}

			a.kill(null, null, ::Const.FatalityType.Suicide, true);
		}

		this.actor.kill(_killer, _skill, _fatalityType, _silent);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (_tile != null)
		{
			local effect = {
				Delay = 0,
				Quantity = 12,
				LifeTimeQuantity = 12,
				SpawnRate = 100,
				Brushes = [
					this.getGhostSprite()
				],
				Stages = [
					{
						LifeTimeMin = 1.0,
						LifeTimeMax = 1.0,
						ColorMin = ::createColor("ffffff5f"),
						ColorMax = ::createColor("ffffff5f"),
						ScaleMin = 1.0,
						ScaleMax = 1.0,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = ::createVec(-1.0, -1.0),
						DirectionMax = ::createVec(1.0, 1.0),
						SpawnOffsetMin = ::createVec(-10, -10),
						SpawnOffsetMax = ::createVec(10, 10),
						ForceMin = ::createVec(0, 0),
						ForceMax = ::createVec(0, 0)
					},
					{
						LifeTimeMin = 1.0,
						LifeTimeMax = 1.0,
						ColorMin = ::createColor("ffffff2f"),
						ColorMax = ::createColor("ffffff2f"),
						ScaleMin = 0.9,
						ScaleMax = 0.9,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = ::createVec(-1.0, -1.0),
						DirectionMax = ::createVec(1.0, 1.0),
						ForceMin = ::createVec(0, 0),
						ForceMax = ::createVec(0, 0)
					},
					{
						LifeTimeMin = 0.1,
						LifeTimeMax = 0.1,
						ColorMin = ::createColor("ffffff00"),
						ColorMax = ::createColor("ffffff00"),
						ScaleMin = 0.1,
						ScaleMax = 0.1,
						RotationMin = 0,
						RotationMax = 0,
						VelocityMin = 80,
						VelocityMax = 100,
						DirectionMin = ::createVec(-1.0, -1.0),
						DirectionMax = ::createVec(1.0, 1.0),
						ForceMin = ::createVec(0, 0),
						ForceMax = ::createVec(0, 0)
					}
				]
			};
			::Tactical.spawnParticleEffect(false, effect.Brushes, _tile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, ::createVec(0, 40));
			local loot = ::new("scripts/items/tools/legendary/mod_ghost_skull_item");
			loot.m.XP = 1000;
			loot.drop(_tile);
		}

		this.getItems().dropAll(_tile, _killer, false);
		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function onActorKilled( _actor, _tile, _skill )
	{
		if (_tile == null)
		{
			return;
		}

		if (_tile.IsCorpseSpawned && _tile.Properties.get("Corpse").IsResurrectable)
		{
			local lv = _actor.getLevel();
			local corpse = _tile.Properties.get("Corpse");
			corpse.Faction = this.getFaction();
			corpse.Hitpoints = 1.0;
			corpse.Items = _actor.getItems();
			corpse.IsConsumable = false;
			corpse.IsResurrectable = false;

			if (_actor.getFlags().has("human"))
			{
				if (lv >= 21)
				{
					corpse.Type = "scripts/entity/tactical/enemies/zombie_betrayer";
				}
				else if (lv >= 11)
				{
					corpse.Type = "scripts/entity/tactical/enemies/zombie_knight";
				}
			}

			::Time.scheduleEvent(::TimeUnit.Rounds, ::Math.rand(1, 2), ::Tactical.Entities.resurrect, corpse);
		}
	}

	function onRoundStart()
	{
		//this.updateIllusionHP();
		this.actor.onRoundStart();
	}

	function onRoundEnd()
	{
		this.m.BaseProperties.InitiativeForTurnOrderAdditional = ::Math.rand(-50, 25);
		this.actor.onRoundEnd();
	}

	function onTurnStart()
	{
		this.actor.onTurnStart();
	}

	function recalculateStatsBasedOnPlayerParty()
	{
		local players = [];
		players.extend(::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player));
		players.extend(::Tactical.Entities.getInstancesOfFaction(::Const.Faction.PlayerAnimals));
		local levels = 0;
		local hitpoints = 0;
		local meleeSkill = 65; // min
		local meleeDefense = 25; // min

		foreach ( a in players )
		{
			local p = a.getCurrentProperties();
			hitpoints += a.getHitpointsMax();
			levels += a.getLevel();

			if (meleeSkill < p.getMeleeSkill()) meleeSkill = p.getMeleeSkill();

			if (meleeDefense < p.getMeleeDefense() - 20) meleeDefense = p.getMeleeDefense() - 20;
		}

		local average_level = ::Math.floor(levels / players.len());
		local b = this.m.BaseProperties;
		b.Hitpoints = ::Math.max(250, hitpoints);
		b.MeleeSkill = meleeSkill;
		b.MeleeDefense = meleeDefense;
		b.Bravery += average_level * 5;

		this.m.Skills.update();
		this.setHitpointsPct(1.0);
		::Tactical.Entities.getFlags().set("ghost_illusion_max", ::Math.max(5, players.len() + 3 + (average_level >= 20 ? 5 : 0)));
		::Tactical.Entities.getFlags().set("ghost_illusion_difficulty", average_level);
	}

	function onInit()
	{
		this.actor.onInit();
		this.setRenderCallbackEnabled(true);
		local b = this.m.BaseProperties;

		// minimum base stats
		b.ActionPoints = 9;
		b.Hitpoints = 250;
		b.Bravery = 90;
		b.Stamina = 150;
		b.MeleeSkill = 65;
		b.RangedSkill = 0;
		b.MeleeDefense = 25;
		b.RangedDefense = 999;
		b.Initiative = 90;
		b.FatigueEffectMult = 0.0;
		b.MoraleEffectMult = 0.0;

		// resistance
		b.IsImmuneToStun = true;
		b.IsImmuneToDaze = true;
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;
		b.IsImmuneToRoot = true;
		b.IsImmuneToDisarm = true;
		b.IsImmuneToFire = true;
		b.IsImmuneToRotation = true;
		b.IsImmuneToDamageReflection = true;
		b.IsAffectedByNight = false;
		b.IsAffectedByInjuries = false;
//		b.IsAffectedByRain = false;
		b.IsResistantToPhysicalStatuses = true;
		b.DamageReceivedMiasmaMult *= 0.5;

		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = ::Const.SameMovementAPCost;
		this.m.FatigueCosts = ::Const.DefaultMovementFatigueCost;
		this.m.MaxTraversibleLevels = 4;

		this.m.Variant = ::Math.rand(1, 3);
		local ghost_sprite = "bust_mod_ghost_boss_mage_0" + this.m.Variant;
		this.m.Items.getAppearance().Body = ghost_sprite;
		this.addSprite("socket").setBrush("bust_base_undead");
		this.addSprite("fog").setBrush("bust_ghost_fog_02");
		local body = this.addSprite("body");
		body.setBrush(ghost_sprite);
		body.varySaturation(0.25);
		body.varyColor(0.2, 0.2, 0.2);
		local head = this.addSprite("head");
		head.setBrush(ghost_sprite);
		head.varySaturation(0.25);
		head.varyColor(0.2, 0.2, 0.2);
		local blur_1 = this.addSprite("blur_1");
		blur_1.setBrush(ghost_sprite);
		blur_1.varySaturation(0.25);
		blur_1.varyColor(0.2, 0.2, 0.2);
		local blur_2 = this.addSprite("blur_2");
		blur_2.setBrush(ghost_sprite);
		blur_2.varySaturation(0.25);
		blur_2.varyColor(0.2, 0.2, 0.2);
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.55;
		this.setSpriteOffset("status_rooted", ::createVec(-5, -5));

		this.m.Skills.add(::new("scripts/skills/actives/ghastly_touch"));
		this.m.Skills.add(::new("scripts/skills/actives/mod_hallucinate_skill"));
		this.m.Skills.add(::new("scripts/skills/actives/mod_mass_miasma_skill"));
		this.m.Skills.add(::new("scripts/skills/actives/mod_mass_root_skill"));
		this.m.Skills.add(::new("scripts/skills/actives/mod_mass_spawn_ghost_skill"));
		this.m.Skills.add(::new("scripts/skills/actives/mod_ghost_teleport_skill"));
		this.m.Skills.add(::new("scripts/skills/racial/mod_ghost_boss_stats_changer"));
		this.m.Skills.add(::new("scripts/skills/racial/mod_ghost_mage_boss_racial"));
		this.m.Skills.add(::new("scripts/skills/racial/mod_ghastly_touch_racial"));
		this.m.Skills.add(::new("scripts/skills/racial/ghost_racial"));

		// need to change perks
		this.m.Skills.add(::new("scripts/skills/perks/perk_fast_adaption"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_anticipation"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_steel_brow"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_underdog"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_fearsome"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_footwork"));
		this.m.Skills.add(::new("scripts/skills/perks/perk_rotation"));
		
		if ("Assets" in ::World && ::World.Assets != null  && this.World.getTime().Days >= 150)
		{
			b.Threat += 15;
			b.InitiativeMult *= 1.2;
		}
	}

	function onRender()
	{
		this.actor.onRender();

		if (this.m.DistortTargetA == null)
		{
			this.m.DistortTargetA = ::createVec(::Math.rand(0, 8) - 4, ::Math.rand(0, 8) - 4);
			this.m.DistortAnimationStartTimeA = ::Time.getVirtualTimeF();
		}

		if (this.moveSpriteOffset("head", this.m.DistortTargetPrevA, this.m.DistortTargetA, 3.8, this.m.DistortAnimationStartTimeA))
		{
			this.m.DistortAnimationStartTimeA = ::Time.getVirtualTimeF();
			this.m.DistortTargetPrevA = this.m.DistortTargetA;
			this.m.DistortTargetA = ::createVec(::Math.rand(0, 8) - 4, ::Math.rand(0, 8) - 4);
		}

		if (this.m.DistortTargetB == null)
		{
			this.m.DistortTargetB = ::createVec(::Math.rand(0, 8) - 4, ::Math.rand(0, 8) - 4);
			this.m.DistortAnimationStartTimeB = ::Time.getVirtualTimeF();
		}

		if (this.moveSpriteOffset("blur_1", this.m.DistortTargetPrevB, this.m.DistortTargetB, 4.9000001, this.m.DistortAnimationStartTimeB))
		{
			this.m.DistortAnimationStartTimeB = ::Time.getVirtualTimeF();
			this.m.DistortTargetPrevB = this.m.DistortTargetB;
			this.m.DistortTargetB = ::createVec(::Math.rand(0, 8) - 4, ::Math.rand(0, 8) - 4);
		}

		if (this.m.DistortTargetC == null)
		{
			this.m.DistortTargetC = ::createVec(::Math.rand(0, 8) - 4, ::Math.rand(0, 8) - 4);
			this.m.DistortAnimationStartTimeC = ::Time.getVirtualTimeF();
		}

		if (this.moveSpriteOffset("body", this.m.DistortTargetPrevC, this.m.DistortTargetC, 4.3, this.m.DistortAnimationStartTimeC))
		{
			this.m.DistortAnimationStartTimeC = ::Time.getVirtualTimeF();
			this.m.DistortTargetPrevC = this.m.DistortTargetC;
			this.m.DistortTargetC = ::createVec(::Math.rand(0, 8) - 4, ::Math.rand(0, 8) - 4);
		}

		if (this.m.DistortTargetD == null)
		{
			this.m.DistortTargetD = ::createVec(::Math.rand(0, 8) - 4, ::Math.rand(0, 8) - 4);
			this.m.DistortAnimationStartTimeD = ::Time.getVirtualTimeF();
		}

		if (this.moveSpriteOffset("blur_2", this.m.DistortTargetPrevD, this.m.DistortTargetD, 5.5999999, this.m.DistortAnimationStartTimeD))
		{
			this.m.DistortAnimationStartTimeD = ::Time.getVirtualTimeF();
			this.m.DistortTargetPrevD = this.m.DistortTargetD;
			this.m.DistortTargetD = ::createVec(::Math.rand(0, 8) - 4, ::Math.rand(0, 8) - 4);
		}
	}

	function spawnMiasmaOn( _tile , _applyDamage = false )
	{
		local p = {
			Type = "miasma",
			Tooltip = "Миазмы, вредные для любого живого существа",
			IsPositive = false,
			IsAppliedAtRoundStart = false,
			IsAppliedAtTurnEnd = true,
			IsAppliedOnMovement = false,
			IsAppliedOnEnter = false,
			IsByPlayer = false,
			Timeout = ::Time.getRound() + 3,
			Callback = ::Const.Tactical.Common.onApplyMiasma,
			function Applicable( _a )
			{
				return !_a.getFlags().has("undead");
			}
		};

		if (_tile.Properties.Effect != null && _tile.Properties.Effect.Type == "miasma")
		{
			_tile.Properties.Effect.Timeout = ::Time.getRound() + 3;

			if (_tile.IsOccupiedByActor && _tile.getEntity().isAlive() && !_tile.getEntity().isDying())
			{
				::Const.Tactical.Common.onApplyMiasma(_tile, _tile.getEntity());
			}
		}
		else
		{
			if (_tile.Properties.Effect != null)
			{
				::Tactical.Entities.removeTileEffect(_tile);
			}

			_tile.Properties.Effect = clone p;
			local particles = [];

			for( local i = 0; i < ::Const.Tactical.MiasmaParticles.len(); i = ++i )
			{
				particles.push(::Tactical.spawnParticleEffect(true, ::Const.Tactical.MiasmaParticles[i].Brushes, _tile, ::Const.Tactical.MiasmaParticles[i].Delay, ::Const.Tactical.MiasmaParticles[i].Quantity, ::Const.Tactical.MiasmaParticles[i].LifeTimeQuantity, ::Const.Tactical.MiasmaParticles[i].SpawnRate, ::Const.Tactical.MiasmaParticles[i].Stages));
			}

			::Tactical.Entities.addTileEffect(_tile, _tile.Properties.Effect, particles);

			if (_applyDamage && _tile.IsOccupiedByActor && _tile.getEntity().isAlive() && !_tile.getEntity().isDying())
			{
				::Const.Tactical.Common.onApplyMiasma(_tile, _tile.getEntity());
			}
		}
	}

	// allow the illusion to confuse player with fake arrow icon XD
	function showArrow( _v )
	{
		foreach (a in ::Tactical.Entities.getInstancesOfFaction(this.getFaction()))
		{
			if (a.getFlags().has("ghost"))
			{
				a.actor.showArrow(_v);
			}
		}
	}

	// add a troll face to tell player that they can really trust the tooltip
	function getTooltip( _targetedWithSkill = null )
	{
		local ret = this.actor.getTooltip(_targetedWithSkill);
		local _highest = 0;
		local _id = 1;
		local _find = false;

		foreach (i, tooltip in ret)
		{
			if (tooltip.type == "progressbar" && tooltip.id >= _id)
			{
				_highest = i;
				_id = tooltip.id;
				continue;
			}

			if (!_find && tooltip.id == 4 && tooltip.icon == "ui/icons/initiative.png")
			{
				_find = true;
				tooltip.text = "Настала моя очередь?";
			}
		}

		ret.insert(_highest + 1, {
			id = _id + 1,
			type = "text",
			icon = "skills/perk_troll_face.png",
			text = "Я скрыл свои статусные эффекты"
		});

		if (this.hasIllusion())
		{
			ret.insert(_highest + 1, {
				id = _id + 1,
				type = "text",
				icon = "skills/status_effect_107.png",
				text = "Я иллюзия?"
			});
		}

		return ret;
	}

	// allow the boss to hide its status effects, no way to see the different now lmao
	function customHookForSkillContainer()
	{
		local ws_query = this.m.Skills.query;
		this.m.Skills.query = function( _filter, _includeHidden = false, _ordered = false )
		{
			if ((::Const.SkillType.StatusEffect & _filter) != 0)
			{
				return [];
			}

			return ws_query(_filter, _includeHidden, _ordered);
		};

		local ws_querySortedByItems = this.m.Skills.querySortedByItems;
		this.m.Skills.querySortedByItems = function( _filter, _notFilter = 0 )
		{
			if ((::Const.SkillType.StatusEffect & _filter) != 0)
			{
				local ret = [];

				for( local i = 0; i < ::Const.ItemSlot.COUNT; i = ++i )
				{
					ret.push([]);
				}

				return ret;
			}

			return ws_querySortedByItems(_filter, _notFilter);
		};
	}

});

