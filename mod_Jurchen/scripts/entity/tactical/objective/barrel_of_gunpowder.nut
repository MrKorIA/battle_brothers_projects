this.barrel_of_gunpowder <- this.inherit("scripts/entity/tactical/actor", {
	m = {},
	function create()
	{
		this.m.IsActingEachTurn = false;
		this.m.IsNonCombatant = true;
		this.m.IsShakingOnHit = false;
		this.m.Type = this.Const.EntityType.CaravanDonkey;
		this.m.BloodType = this.Const.BloodType.Wood;
		this.m.MoraleState = this.Const.MoraleState.Ignore;
		this.m.XP = this.Const.Tactical.Actor.Donkey.XP;
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.actor.create();
		this.m.Name = "Бочки с порохом";
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/dlc2/schrat_shield_damage_01.wav",
			"sounds/enemies/dlc2/schrat_shield_damage_02.wav",
			"sounds/enemies/dlc2/schrat_shield_damage_03.wav",
			"sounds/enemies/dlc2/schrat_shield_damage_04.wav",
			"sounds/enemies/dlc2/schrat_shield_damage_05.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
            "sounds/combat/dlc6/fire_mortar_impact_01.wav",
            "sounds/combat/dlc6/fire_mortar_impact_01.wav",
            "sounds/combat/dlc6/fire_mortar_impact_01.wav",
            "sounds/combat/dlc6/fire_mortar_impact_01.wav"
        ];
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/donkey_agent");
		this.m.AIAgent.setActor(this);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (_tile != null && (_killer != null || _skill != null))
		{
            local affectedTiles = this.getAffectedTiles(_tile);
            for( local i = 0; i < this.Const.Tactical.BurnParticles.len(); i = ++i )
            {
                this.Tactical.spawnParticleEffect(false, this.Const.Tactical.BurnParticles[i].Brushes, _tile, this.Const.Tactical.BurnParticles[i].Delay, this.Const.Tactical.BurnParticles[i].Quantity * 0.5, this.Const.Tactical.BurnParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.BurnParticles[i].SpawnRate, this.Const.Tactical.BurnParticles[i].Stages, this.createVec(0, -30));
            }
            for( local i = 0; i < this.Const.Tactical.MortarImpactParticles.len(); i = ++i )
            {
                this.Tactical.spawnParticleEffect(false, this.Const.Tactical.MortarImpactParticles[i].Brushes, _tile, this.Const.Tactical.MortarImpactParticles[i].Delay, this.Const.Tactical.MortarImpactParticles[i].Quantity * 0.5, this.Const.Tactical.MortarImpactParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.MortarImpactParticles[i].SpawnRate, this.Const.Tactical.MortarImpactParticles[i].Stages, this.createVec(0, -30));
            }
            this.Sound.play("sounds/combat/poison_applied_0" + this.Math.rand(1, 2) + ".wav", this.Const.Sound.Volume.Skill * 1.6, _tile);
            local tag = {
                User = _killer,
                Actor = _tile.getEntity(),
                Targets = affectedTiles
            };
            local decal = _tile.spawnDetail("jin_camp_gunpowder_dead", this.Const.Tactical.DetailFlag.Corpse, false, false);
            decal.Scale = this.Math.rand(1, 10) * 0.01 + 0.95;
            decal.varySaturation(0.2);
            decal.varyColor(0.2, 0.2, 0.2);
            this.spawnTerrainDropdownEffect(_tile);

            local layers = [
                "jin_camp_gunpowder_decal_01",
                "jin_camp_gunpowder_decal_01",
                "jin_camp_gunpowder_decal_01",
                "jin_camp_gunpowder_decal_02",
                "jin_camp_gunpowder_decal_02",
                "jin_camp_gunpowder_decal_03",
                "jin_camp_gunpowder_decal_04"
            ];

            foreach( layer in layers )
            {
                local decap = this.Tactical.spawnHeadEffect(this.getTile(), [ layer ], this.createVec(0, 0), 0.0, "");
                decap[0].Scale = this.Math.rand(1, 10) * 0.01 + 0.7;
            }

            this.Time.scheduleEvent(this.TimeUnit.Virtual, 200, this.applyEffectToTargets.bindenv(this), tag);
		}

		local corpse = this.generateCorpse(_tile, _fatalityType, _killer);

		if (_tile == null)
		{
			this.Tactical.Entities.addUnplacedCorpse(corpse);
		}
		else
		{
			_tile.Properties.set("Corpse", corpse);
			this.Tactical.Entities.addCorpse(_tile);
		}

		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function applyEffectToTargets( _tag )
	{
		local user = _tag.User;
		local targets = _tag.Targets;
		local actor = _tag.Actor;
		local update = false;
		local p = {
			Type = "fire",
			Tooltip = "Здесь бушует огонь, раскаляя доспехи и обугливая плоть",
			IsPositive = false,
			IsAppliedAtRoundStart = false,
			IsAppliedAtTurnEnd = true,
			IsAppliedOnMovement = false,
			IsAppliedOnEnter = false,
			IsByPlayer = false,
			Timeout = this.Time.getRound() + 2,
			Callback = this.Const.Tactical.Common.onApplyFire,
			function Applicable( _a )
			{
				return true;
			}

		};

		foreach( t in targets )
		{
			for( local i = 0; i < this.Const.Tactical.MortarFireRightParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.MortarFireRightParticles[i].Brushes, t, this.Const.Tactical.MortarFireRightParticles[i].Delay, this.Const.Tactical.MortarFireRightParticles[i].Quantity * 0.5, this.Const.Tactical.MortarFireRightParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.MortarFireRightParticles[i].SpawnRate, this.Const.Tactical.MortarFireRightParticles[i].Stages, this.createVec(0, -30));
			}
			for( local i = 0; i < this.Const.Tactical.BurnParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.BurnParticles[i].Brushes, t, this.Const.Tactical.BurnParticles[i].Delay, this.Const.Tactical.BurnParticles[i].Quantity * 0.5, this.Const.Tactical.BurnParticles[i].LifeTimeQuantity * 0.5, this.Const.Tactical.BurnParticles[i].SpawnRate, this.Const.Tactical.BurnParticles[i].Stages, this.createVec(0, -30));
			}
			if (t.Subtype != this.Const.Tactical.TerrainSubtype.Snow && t.Subtype != this.Const.Tactical.TerrainSubtype.LightSnow && t.Type != this.Const.Tactical.TerrainType.ShallowWater && t.Type != this.Const.Tactical.TerrainType.DeepWater)
			{
				if (t.Properties.Effect != null && t.Properties.Effect.Type == "fire")
				{
					t.Properties.Effect.Timeout = this.Time.getRound() + 2;
				}
				else
				{
					if (t.Properties.Effect != null)
					{
						this.Tactical.Entities.removeTileEffect(t);
					}

					t.Properties.Effect = clone p;
					local particles = [];

					for( local i = 0; i < this.Const.Tactical.FireParticles.len(); i = ++i )
					{
						particles.push(this.Tactical.spawnParticleEffect(true, this.Const.Tactical.FireParticles[i].Brushes, t, this.Const.Tactical.FireParticles[i].Delay, this.Const.Tactical.FireParticles[i].Quantity, this.Const.Tactical.FireParticles[i].LifeTimeQuantity, this.Const.Tactical.FireParticles[i].SpawnRate, this.Const.Tactical.FireParticles[i].Stages));
					}

					this.Tactical.Entities.addTileEffect(t, t.Properties.Effect, particles);
					t.clear(this.Const.Tactical.DetailFlag.Scorchmark);
					t.spawnDetail("impact_decal", this.Const.Tactical.DetailFlag.Scorchmark, false, true);

                    if (t.IsOccupiedByActor)
                    {
                        this.Const.Tactical.Common.onApplyFire(t, t.getEntity());
                    }
				}
			}
			if (!t.IsOccupiedByActor)
			{
			    if (t.getEntity() != null)
			    {
                    t.removeObject();
                    update = true;
			    }
				continue;
			}
			local target = t.getEntity();
            local isAttackable = target.isAttackable() || (("ClassName" in target) && target.ClassName == "barrel_of_gunpowder");

			if (isAttackable && target.isAlive() && !target.isDying())
			{
                local shellshocked_effect = this.new("scripts/skills/effects/shellshocked_effect");
                shellshocked_effect.getDescription = function()
                {
                    return "Этот персонаж контужен близким взрывом пороховой бочки. В его ушах звенит, зрение расплывается, а сам он плохо понимает, что происходит. Эффект будет постепенно рассеиваться в течение [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] ход(а,ов).";
                }
				if (user != null && user.getPos().X <= target.getPos().X)
				{
					for( local i = 0; i < this.Const.Tactical.ShrapnelLeftParticles.len(); i = ++i )
					{
						local effect = this.Const.Tactical.ShrapnelLeftParticles[i];
						this.Tactical.spawnParticleEffect(false, effect.Brushes, t, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 0));
					}
				}
				else
				{
					for( local i = 0; i < this.Const.Tactical.ShrapnelRightParticles.len(); i = ++i )
					{
						local effect = this.Const.Tactical.ShrapnelRightParticles[i];
						this.Tactical.spawnParticleEffect(false, effect.Brushes, t, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 0));
					}
				}

				if (target.getMoraleState() != this.Const.MoraleState.Ignore)
				{
					target.checkMorale(-1, 0);
					target.getSkills().add(shellshocked_effect);
				}
                local hitInfo = clone this.Const.Tactical.HitInfo;
                hitInfo.DamageRegular = this.Math.rand(50, 150);
                hitInfo.DamageArmor = hitInfo.DamageRegular * 2;
                hitInfo.DamageDirect = 0.4;
                hitInfo.BodyPart = this.Const.BodyPart.Body;
                hitInfo.FatalityChanceMult = 0.0;
                hitInfo.Injuries = this.Const.Injury.BurningAndPiercingBody;
                hitInfo.DamageType = this.Const.Damage.DamageType.Burning;
                target.onDamageReceived(actor, shellshocked_effect, hitInfo);
                if (t.IsVisibleForPlayer)
                {
                    this.Tactical.EventLog.log("[color=#ff9d00]Бочка с порохом[/color] в результате взрыва наносит " + hitInfo.DamageRegular + " урона персонажу " + this.Const.UI.getColorizedEntityName(target));
                }
			}
		}

		if (update)
		{
			::Tactical.clearBlockedTileHighlights();
			::Tactical.createBlockedTileHighlights();
		}
	}

	function getAffectedTiles( _targetTile )
	{
		local targets = [
			_targetTile
		];

		for( local i = 0; i != 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local tile = _targetTile.getNextTile(i);
				targets.push(tile);
			}
		}

		return targets;
	}

	function generateCorpse( _tile, _fatalityType, _killer )
	{
		local corpse = clone this.Const.Corpse;
		corpse.CorpseName = "Всё что осталось от бочек с порохом";
		corpse.Value = 1.0;
		corpse.IsResurrectable = false;
		corpse.IsConsumable = true;
		corpse.IsHeadAttached = true;

		if (_tile != null)
		{
			corpse.Tile = _tile;
		}

		return corpse;
	}

	function onDamageReceived( _attacker, _skill, _hitInfo )
	{
	    this.logInfo("_hitInfo.DamageType " + _hitInfo.DamageType );
	    this.logInfo("_hitInfo.Injuries " + _hitInfo.Injuries );
		_hitInfo.BodyPart = this.Const.BodyPart.Body;
		if (_hitInfo.DamageType == this.Const.Damage.DamageType.Burning || _hitInfo.Injuries == this.Const.Injury.BurningBody || _hitInfo.Injuries == this.Const.Injury.Burning || this.Math.rand(1, 3) == 1)
		{
			_hitInfo.DamageRegular = this.actor.getHitpoints() + 10;
			_hitInfo.DamageDirect = 1.0;
		}
		return this.actor.onDamageReceived(_attacker, _skill, _hitInfo);
	}

	function getTooltip( _targetedWithSkill = null )
	{
		if (!this.isPlacedOnMap() || !this.isAlive() || this.isDying())
		{
			return [];
		}

		local tooltip = [
			{
				id = 1,
				type = "title",
				text = this.getName(),
				icon = this.getLevelImagePath()
			},
			{
                id = 2,
                type = "headerText",
                icon = "ui/tooltips/warning.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]Любая случайная искра, вызванная при попадании по бочке, приведёт к возгоранию и взрыву![/color]"
            },
            {
                id = 3,
                type = "text",
                icon = "ui/icons/cancel.png",
                text = "Блокирует движение"
            }
		];

		return tooltip;
	}

	function onInit()
	{
		this.actor.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.Donkey);
		b.IsImmuneToKnockBackAndGrab = true;
		b.IsImmuneToStun = true;
		b.IsImmuneToRoot = true;
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;
		b.IsImmuneToDisarm = true;
		b.IsImmuneToHeadshots = true;
		b.IsAffectedByInjuries = false;
		b.IsAffectedByNight = false;
		b.IsMovable = false;
		b.TargetAttractionMult = 5.0;
		this.m.IsAttackable = false;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		local body = this.addSprite("body");
		body.setBrush("jin_camp_gunpowder");
		body.varySaturation(0.4);
		body.varyColor(0.035, 0.035, 0.035);
		this.addDefaultStatusSprites();
		this.m.Skills.update();
	}

});

