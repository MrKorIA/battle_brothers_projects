this.xxmob_wrider_wolf <- this.inherit("scripts/entity/tactical/goblin", {
	m = {
		Variant = 1,
		LastBodyPartHit = false,
		Info = null
	},
	function create()
	{
		this.m.Name = this.Const.Strings.FT.M80;
		this.m.Type = this.Const.EntityType.GoblinWolfrider;
		this.m.XP = this.Const.Tactical.Actor.GoblinWolfrider.XP;
		this.goblin.create();
		this.m.ShakeLayers = [
			[
				"wolf",
				"wolf_head",
				"wolf_head_tattoo",
				"wolf_injury"
			],
			[
				"body",
				"head",
				"injury",
				"helmet",
				"helmet_damage"
			]
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Other1] = [
			"sounds/enemies/wolf_death_00.wav",
			"sounds/enemies/wolf_death_01.wav",
			"sounds/enemies/wolf_death_02.wav",
			"sounds/enemies/wolf_death_03.wav",
			"sounds/enemies/wolf_death_04.wav",
			"sounds/enemies/wolf_death_05.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/wolf_hurt_00.wav",
			"sounds/enemies/wolf_hurt_01.wav",
			"sounds/enemies/wolf_hurt_02.wav",
			"sounds/enemies/wolf_hurt_03.wav",
			"sounds/enemies/goblin_hurt_00.wav",
			"sounds/enemies/goblin_hurt_01.wav",
			"sounds/enemies/goblin_hurt_02.wav",
			"sounds/enemies/goblin_hurt_03.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/wolf_idle_00.wav",
			"sounds/enemies/wolf_idle_01.wav",
			"sounds/enemies/wolf_idle_02.wav",
			"sounds/enemies/wolf_idle_03.wav",
			"sounds/enemies/wolf_idle_04.wav",
			"sounds/enemies/wolf_idle_06.wav",
			"sounds/enemies/wolf_idle_07.wav",
			"sounds/enemies/wolf_idle_08.wav",
			"sounds/enemies/wolf_idle_09.wav"
		];
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Idle] = 0.6;
		this.m.Sound[this.Const.Sound.ActorEvent.Move] = [
			"sounds/enemies/goblin_wolfrider_move_00.wav",
			"sounds/enemies/goblin_wolfrider_move_01.wav",
			"sounds/enemies/goblin_wolfrider_move_02.wav",
			"sounds/enemies/goblin_wolfrider_move_03.wav",
			"sounds/enemies/goblin_wolfrider_move_04.wav",
			"sounds/enemies/goblin_wolfrider_move_05.wav",
			"sounds/enemies/goblin_wolfrider_move_06.wav",
			"sounds/enemies/goblin_wolfrider_move_07.wav",
			"sounds/enemies/goblin_wolfrider_move_08.wav",
			"sounds/enemies/goblin_wolfrider_move_09.wav",
			"sounds/enemies/goblin_wolfrider_move_10.wav",
			"sounds/enemies/goblin_wolfrider_move_11.wav",
			"sounds/enemies/goblin_wolfrider_move_12.wav",
			"sounds/enemies/goblin_wolfrider_move_13.wav"
		];
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/xxmonster_a_agent");
		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.KnockBack);
		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Disengage);
		this.m.AIAgent.setActor(this);
	}

	function onInit()
	{
		this.goblin.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.GoblinFighter);
		b.IsSpecializedInPolearms = true;
		b.Hitpoints += 40;
		b.Bravery += 20;
		b.ActionPoints += 4;
		b.AdditionalActionPointCost = 2;
		b.MovementFatigueCostMult *= 0;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.getSprite("head").setBrush("bust_goblin_0"  + this.Math.rand(1, 3) + "_head_01");
		local offset = this.createVec(5, 25);
		this.setSpriteOffset("body", offset);
		this.setSpriteOffset("armor", offset);
		this.setSpriteOffset("head", offset);
		this.setSpriteOffset("injury", offset);
		this.setSpriteOffset("helmet", offset);
		this.setSpriteOffset("helmet_damage", offset);
		this.setSpriteOffset("body_blood", offset);
		local variant = this.Math.rand(1, 3);
		local wolf = this.addSprite("wolf");
		wolf.setBrush("bust_direwolf_0" + variant);
		wolf.varySaturation(0.15);
		wolf.varyColor(0.07, 0.07, 0.07);
		wolf = this.addSprite("wolf_head");
		wolf.setBrush("bust_direwolf_0" + variant + "_head");
		wolf.Saturation = wolf.Saturation;
		wolf.Color = wolf.Color;
		wolf = this.addSprite("wolf_head_tattoo");
		wolf.setBrush("bust_direwolf_0" + variant + "_head_frenzy");
		wolf.Saturation = wolf.Saturation;
		wolf.Color = wolf.Color;
		this.removeSprite("injury_body");
		local wolf_injury = this.addSprite("injury_body");
		wolf_injury.setBrush("bust_wolf_01_injured");
		wolf_injury.Visible = false;
		local wolf_armor = this.addSprite("wolf_armor");
		wolf_armor.setBrush("bust_wolf_02_armor_01");
		offset = this.createVec(-10, -7);
		this.setSpriteOffset("wolf", offset);
		this.setSpriteOffset("wolf_head", offset);
		this.setSpriteOffset("wolf_head_tattoo", offset);
		this.setSpriteOffset("wolf_armor", offset);
		this.setSpriteOffset("injury_body", offset);
		this.addSprite("arms_icon").Color = this.createColor("#e0e0e0");
		this.getSprite("arms_icon").Saturation = 0.3;
		this.getSprite("arms_icon").Scale = 0.95;
		this.setSpriteOffset("arms_icon", this.createVec(5, 15));
		this.addDefaultStatusSprites();
		this.setAlwaysApplySpriteOffset(true);
		local xsk = this.new("scripts/skills/actives/wolf_bite");
		xsk.setRestrained(true);
		xsk.m.ActionPointCost = 0;
		this.m.Skills.add(xsk);
		this.m.Skills.add(this.new("scripts/skills/actives/split"));
		this.m.Skills.removeByID("perk.footwork");
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.m.Info = {
			Tile = this.getTile(),
			Faction = this.getFaction(),
			Body = this.getSprite("body").getBrush().Name,
			Head = this.getSprite("head").getBrush().Name,
			Color = this.getSprite("body").Color,
			Saturation = this.getSprite("body").Saturation
		};

		if (this.Math.rand(1, 100) <= 55)
		{
			this.m.LastBodyPartHit = true;
			this.spawnDeadWolf(_killer, _skill, _tile, _fatalityType);
		}
		else
		{
			this.goblin.onDeath(_killer, _skill, _tile, _fatalityType);
		}

		if (_killer == null || _killer.getFaction() == this.Const.Faction.Player || _killer.getFaction() == this.Const.Faction.PlayerAnimals)
		{
			local loot;
			if (this.Math.rand(1, 100) <= 20)
			{
				loot = this.new("scripts/items/loot/growth_pearls_item");
				loot.drop(_tile);
			}
		}
	}

	function onAfterDeath( _tile )
	{
		if (this.Tactical.Entities.getHostilesNum() == 0)
		{
			return;
		}

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

		if (this.m.LastBodyPartHit)
		{
			this.spawnGoblin(this.m.Info);
		}
		else
		{
			this.spawnWolf(this.m.Info);
		}
	}

	function spawnDeadWolf( _killer, _skill, _tile, _fatalityType )
	{
		if (_tile == null)
		{
			return;
		}

		local flip = this.Math.rand(0, 100) < 50;
		local decal;
		this.m.IsCorpseFlipped = flip;
		decal = _tile.spawnDetail("bust_direwolf_01_body_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
		decal.setBrightness(0.9);
		decal.Scale = 0.95;
		decal = _tile.spawnDetail("bust_wolf_02_armor_01_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
		decal.setBrightness(0.9);
		decal.Scale = 0.95;

		if (_fatalityType != this.Const.FatalityType.Decapitated)
		{
			decal = _tile.spawnDetail(this.getSprite("wolf_head").getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.setBrightness(0.9);
			decal.Scale = 0.95;
		}
		else if (_fatalityType == this.Const.FatalityType.Decapitated)
		{
			local layers = [
				this.getSprite("wolf_head").getBrush().Name + "_dead"
			];
			local decap = this.Tactical.spawnHeadEffect(this.getTile(), layers, this.createVec(-20, 15), 0.0, "bust_wolf_head_bloodpool");
			decap[0].setBrightness(0.9);
			decap[0].Scale = 0.95;
		}
		else if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Arrow)
		{
			decal = _tile.spawnDetail(this.getSprite("wolf").getBrush().Name + "_dead_arrows", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.Scale = 0.95;
		}
		else if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Javelin)
		{
			decal = _tile.spawnDetail(this.getSprite("wolf").getBrush().Name + "_dead_javelin", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.Scale = 0.95;
		}

		this.spawnTerrainDropdownEffect(_tile);
		local corpse = clone this.Const.Corpse;
		corpse.CorpseName = "A Frenzied Dire Wolf";
		corpse.IsHeadAttached = _fatalityType != this.Const.FatalityType.Decapitated;
		corpse.IsResurrectable = false;
		_tile.Properties.set("Corpse", corpse);
		this.Tactical.Entities.addCorpse(_tile);
	}

	function spawnWolf( _info )
	{
		this.Sound.play(this.m.Sound[this.Const.Sound.ActorEvent.Death][this.Math.rand(0, this.m.Sound[this.Const.Sound.ActorEvent.Death].len() - 1)], this.Const.Sound.Volume.Actor * this.m.SoundVolume[this.Const.Sound.ActorEvent.Death], _info.Tile.Pos, 1.0);
		local entity = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/direwolf_high", _info.Tile.Coords.X, _info.Tile.Coords.Y);
		if (entity != null)
		{
			entity.setFaction(_info.Faction);
			entity.setMoraleState(this.Const.MoraleState.Steady);
		}
	}

	function spawnGoblin( _info )
	{
		this.Sound.play(this.m.Sound[this.Const.Sound.ActorEvent.Other1][this.Math.rand(0, this.m.Sound[this.Const.Sound.ActorEvent.Other1].len() - 1)], this.Const.Sound.Volume.Actor * this.m.SoundVolume[this.Const.Sound.ActorEvent.Other1], _info.Tile.Pos, 1.0);
		local entity = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/xxmob_wrider_goblin", _info.Tile.Coords.X, _info.Tile.Coords.Y);
		if (entity != null)
		{
			local newBody = entity.getSprite("body");
			newBody.setBrush(_info.Body);
			newBody.Color = _info.Color;
			newBody.Saturation = _info.Saturation;
			local newHead = entity.getSprite("head");
			newHead.setBrush(_info.Head);
			newHead.Color = _info.Color;
			newHead.Saturation = _info.Saturation;
			entity.setFaction(_info.Faction);
			entity.getItems().clear();
			this.m.Items.transferTo(entity.getItems());
			entity.setMoraleState(this.Const.MoraleState.Steady);
			entity.setHitpoints(entity.getHitpointsMax() * 1);
			entity.onUpdateInjuryLayer();
		}
	}

	function assignRandomEquipment()
	{
		if (this.Math.rand(1, 100) <= 50)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/greenskins/goblin_heavy_helmet"));
		}
		else
		{
			this.m.Items.equip(this.new("scripts/items/helmets/greenskins/goblin_light_helmet"));
		}
		this.m.Items.equip(this.new("scripts/items/armor/greenskins/goblin_leader_armor"));
		this.m.Items.equip(this.new("scripts/items/weapons/named/xx_mob_goblinpike"));
	}

	function onTurnStart()
	{
		this.actor.onTurnStart();
		if (this.Tactical.Entities.isEnemyRetreating() || this.Tactical.State.isAutoRetreat() || !this.m.IsAlive || this.m.IsDying)
		{
			return;
		}
		if (this.Time.getRound() == 1 && this.Math.rand(1, 100) <= 50)
		{
			local mytile = this.actor.getTile();
			this.actor.checkMorale(1, 0, this.Const.MoraleCheckType.Default);
		}
	}

});

