this.mod_ghost_mage_boss_illusion <- ::inherit("scripts/entity/tactical/actor", {
	m = {
		TrueBody = null,
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
	function setTrueBody( _e )
	{
		if (typeof _e == "instance")
		{
			this.m.TrueBody = _e;
		}
		else
		{
			if (_e == null)
			{
				this.m.TrueBody = null;
			}
			else
			{
				this.m.TrueBody = ::WeakTableRef(_e);
			}
		}
	}

	function getTrueBody()
	{
		if (this.m.TrueBody != null && !this.m.TrueBody.isNull())
		{
			return this.m.TrueBody;
		}

		return this;
	}

	function getActionPoints()
	{
		return this.m.TrueBody != null && !this.m.TrueBody.isNull() ? this.m.TrueBody.getActionPoints() : this.actor.getActionPoints();
	}

	function copyAppearance()
	{
		local ghost_sprite = "bust_mod_ghost_boss_mage_0" + this.m.TrueBody.m.Variant;
		this.m.Name = this.m.TrueBody.getName();
		this.m.Items.getAppearance().Body = ghost_sprite;
		this.getSprite("body").setBrush(ghost_sprite);
		this.getSprite("head").setBrush(ghost_sprite);
		this.getSprite("blur_1").setBrush(ghost_sprite);
		this.getSprite("blur_2").setBrush(ghost_sprite);
		this.setDirty(true);
	}

	function create()
	{
		this.m.Type = ::Const.EntityType.SkeletonLichMirrorImage;
		this.m.BloodType = ::Const.BloodType.None;
		this.m.MoraleState = ::Const.MoraleState.Ignore;
		this.m.IsEmittingMovementSounds = false;
		this.actor.create();
		this.customHookForSkillContainer();
		this.m.Sound[::Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/miasma_spell_01.wav",
			"sounds/enemies/miasma_spell_02.wav",
			"sounds/enemies/miasma_spell_03.wav"
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
		this.m.SoundPitch = 80 * 0.01;
		this.getFlags().add("undetectable", true);
		this.getFlags().add("illusion");
		this.getFlags().add("undead");
		this.getFlags().add("ghost");
		this.m.AIAgent = ::new("scripts/ai/tactical/agents/mod_illusion_agent");
		this.m.AIAgent.setActor(this);
	}

	function getGhostSprite()
	{
		return this.getSprite("body").getBrush().Name;
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (_fatalityType != ::Const.FatalityType.Suicide)
		{
			local tile = this.getTile();
			this.m.TrueBody.spawnMiasmaOn(tile, true);
			for( local i = 0; i != 6; i = ++i )
			{
				if (!tile.hasNextTile(i))
				{
				}
				else
				{
					this.m.TrueBody.spawnMiasmaOn(tile.getNextTile(i), true);
				}
			}

			::Tactical.EventLog.logEx("Оказалось, что это всего лишь [b]иллюзия[/b]");

			if (_killer != null && !_killer.getFlags().has("undead") && ::Math.rand(1, 18) <= ::Tactical.Entities.getFlags().getAsInt("ghost_illusion_difficulty"))
			{
				_killer.getSkills().add(::new("scripts/skills/effects/withered_effect"));

				if (!this.isHiddenToPlayer())
				{
					::Tactical.spawnSpriteEffect("active_217", ::createColor("#ffffff"), this.getTile(), ::Const.Tactical.Settings.SkillOverlayOffsetX, ::Const.Tactical.Settings.SkillOverlayOffsetY, ::Const.Tactical.Settings.SkillOverlayScale, ::Const.Tactical.Settings.SkillOverlayScale, ::Const.Tactical.Settings.SkillOverlayStayDuration + 750, 0, ::Const.Tactical.Settings.SkillOverlayFadeDuration);

					if (!_killer.isHiddenToPlayer())
					{
						::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_killer) + " увядает");
					}
				}
			}
		}

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
			local corpse = _tile.Properties.get("Corpse");
			corpse.Faction = this.getFaction();
			corpse.Hitpoints = 0.7;
			corpse.Items = _actor.getItems();
			corpse.IsConsumable = false;
			corpse.IsResurrectable = false;

			if (_actor.getFlags().has("human") && _actor.getLevel() >= 11)
			{
				corpse.Type = "scripts/entity/tactical/enemies/zombie_knight";
			}

			::Time.scheduleEvent(::TimeUnit.Rounds, 1, ::Tactical.Entities.resurrect, corpse);
		}
	}

	function onDamageReceived( _attacker, _skill, _hitInfo )
	{
		this.kill(_attacker);
		return 0;
	}

	function onRoundEnd()
	{
		this.m.BaseProperties.InitiativeForTurnOrderAdditional = ::Math.rand(-50, 25);
		this.actor.onRoundEnd();
	}

	function onInit()
	{
		this.actor.onInit();
		this.setRenderCallbackEnabled(true);
		local b = this.m.BaseProperties;

		// minimum base stats
		b.ActionPoints = 12;
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
		
		this.addSprite("socket").setBrush("bust_base_undead");
		this.addSprite("fog").setBrush("bust_ghost_fog_02");
		local body = this.addSprite("body");
		body.varySaturation(0.25);
		body.varyColor(0.2, 0.2, 0.2);
		local head = this.addSprite("head");
		head.varySaturation(0.25);
		head.varyColor(0.2, 0.2, 0.2);
		local blur_1 = this.addSprite("blur_1");
		blur_1.varySaturation(0.25);
		blur_1.varyColor(0.2, 0.2, 0.2);
		local blur_2 = this.addSprite("blur_2");
		blur_2.varySaturation(0.25);
		blur_2.varyColor(0.2, 0.2, 0.2);
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.55;
		this.setSpriteOffset("status_rooted", ::createVec(-5, -5));

		this.m.Skills.add(::new("scripts/skills/actives/ghastly_touch"));
		this.m.Skills.add(::new("scripts/skills/actives/mod_ghost_teleport_skill"));
		this.m.Skills.add(::new("scripts/skills/racial/mod_ghastly_touch_racial"));
		this.m.Skills.add(::new("scripts/skills/racial/mod_illusion_racial"));
		this.m.Skills.add(::new("scripts/skills/racial/ghost_racial"));

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

	function spawnTeleportEffect()
	{
		local effect1 = {
			Delay = 0,
			Quantity = 4,
			LifeTimeQuantity = 4,
			SpawnRate = 100,
			Brushes = [
				this.getGhostSprite()
			],
			Stages = [
				{
					LifeTimeMin = 0.4,
					LifeTimeMax = 0.4,
					ColorMax = ::createColor("ffffff5f"),
					ColorMin = ::createColor("ffffff5f"),
					ScaleMin = 1.0,
					ScaleMax = 1.0,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = ::createVec(0.0, -1.0),
					DirectionMax = ::createVec(0.0, -1.0),
					SpawnOffsetMin = ::createVec(-10, 40),
					SpawnOffsetMax = ::createVec(10, 50),
					ForceMin = ::createVec(0, 0),
					ForceMax = ::createVec(0, 0)
				},
				{
					LifeTimeMin = 0.4,
					LifeTimeMax = 0.4,
					ColorMin = ::createColor("ffffff2f"),
					ColorMax = ::createColor("ffffff2f"),
					ScaleMin = 1.0,
					ScaleMax = 1.0,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = ::createVec(0.0, -1.0),
					DirectionMax = ::createVec(0.0, -1.0),
					ForceMin = ::createVec(0, 0),
					ForceMax = ::createVec(0, 0)
				},
				{
					LifeTimeMin = 0.1,
					LifeTimeMax = 0.1,
					ColorMin = ::createColor("ffffff00"),
					ColorMax = ::createColor("ffffff00"),
					ScaleMin = 1.0,
					ScaleMax = 1.0,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = ::createVec(0.0, -1.0),
					DirectionMax = ::createVec(0.0, -1.0),
					ForceMin = ::createVec(0, 0),
					ForceMax = ::createVec(0, 0)
				}
			]
		};
		local effect2 = {
			Delay = 0,
			Quantity = 4,
			LifeTimeQuantity = 4,
			SpawnRate = 100,
			Brushes = [
				this.getGhostSprite()
			],
			Stages = [
				{
					LifeTimeMin = 0.4,
					LifeTimeMax = 0.4,
					ColorMin = ::createColor("ffffff5f"),
					ColorMax = ::createColor("ffffff5f"),
					ScaleMin = 1.0,
					ScaleMax = 1.0,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = ::createVec(1.0, 0.0),
					DirectionMax = ::createVec(1.0, 0.0),
					SpawnOffsetMin = ::createVec(-40, -10),
					SpawnOffsetMax = ::createVec(-50, 10),
					ForceMin = ::createVec(0, 0),
					ForceMax = ::createVec(0, 0)
				},
				{
					LifeTimeMin = 0.4,
					LifeTimeMax = 0.4,
					ColorMin = ::createColor("ffffff2f"),
					ColorMax = ::createColor("ffffff2f"),
					ScaleMin = 1.0,
					ScaleMax = 1.0,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = ::createVec(1.0, 0.0),
					DirectionMax = ::createVec(1.0, 0.0),
					ForceMin = ::createVec(0, 0),
					ForceMax = ::createVec(0, 0)
				},
				{
					LifeTimeMin = 0.1,
					LifeTimeMax = 0.1,
					ColorMin = ::createColor("ffffff00"),
					ColorMax = ::createColor("ffffff00"),
					ScaleMin = 1.0,
					ScaleMax = 1.0,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = ::createVec(1.0, 0.0),
					DirectionMax = ::createVec(1.0, 0.0),
					ForceMin = ::createVec(0, 0),
					ForceMax = ::createVec(0, 0)
				}
			]
		};
		local effect3 = {
			Delay = 0,
			Quantity = 4,
			LifeTimeQuantity = 4,
			SpawnRate = 100,
			Brushes = [
				this.getGhostSprite()
			],
			Stages = [
				{
					LifeTimeMin = 0.4,
					LifeTimeMax = 0.4,
					ColorMin = ::createColor("ffffff5f"),
					ColorMax = ::createColor("ffffff5f"),
					ScaleMin = 1.0,
					ScaleMax = 1.0,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = ::createVec(-1.0, 0.0),
					DirectionMax = ::createVec(-1.0, 0.0),
					SpawnOffsetMin = ::createVec(40, 10),
					SpawnOffsetMax = ::createVec(50, 10),
					ForceMin = ::createVec(0, 0),
					ForceMax = ::createVec(0, 0)
				},
				{
					LifeTimeMin = 0.4,
					LifeTimeMax = 0.4,
					ColorMin = ::createColor("ffffff2f"),
					ColorMax = ::createColor("ffffff2f"),
					ScaleMin = 1.0,
					ScaleMax = 1.0,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = ::createVec(-1.0, 0.0),
					DirectionMax = ::createVec(-1.0, 0.0),
					ForceMin = ::createVec(0, 0),
					ForceMax = ::createVec(0, 0)
				},
				{
					LifeTimeMin = 0.1,
					LifeTimeMax = 0.1,
					ColorMin = ::createColor("ffffff00"),
					ColorMax = ::createColor("ffffff00"),
					ScaleMin = 1.0,
					ScaleMax = 1.0,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = ::createVec(-1.0, 0.0),
					DirectionMax = ::createVec(-1.0, 0.0),
					ForceMin = ::createVec(0, 0),
					ForceMax = ::createVec(0, 0)
				}
			]
		};
		::Tactical.spawnParticleEffect(false, effect1.Brushes, this.getTile(), effect1.Delay, effect1.Quantity, effect1.LifeTimeQuantity, effect1.SpawnRate, effect1.Stages, ::createVec(0, 40));
		::Tactical.spawnParticleEffect(false, effect2.Brushes, this.getTile(), effect2.Delay, effect2.Quantity, effect2.LifeTimeQuantity, effect2.SpawnRate, effect2.Stages, ::createVec(0, 40));
		::Tactical.spawnParticleEffect(false, effect3.Brushes, this.getTile(), effect3.Delay, effect3.Quantity, effect3.LifeTimeQuantity, effect3.SpawnRate, effect3.Stages, ::createVec(0, 40));
	}

	function onDiscovered()
	{
		::Const.Movement.AnnounceDiscoveredEntities = false;
		this.actor.onDiscovered();
		::Const.Movement.AnnounceDiscoveredEntities = true;
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
		ret.insert(_highest + 1, {
			id = _id + 1,
			type = "text",
			icon = "skills/status_effect_107.png",
			text = "Я иллюзия?"
		});

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

