this.xxmob_bear <- this.inherit("scripts/entity/tactical/enemies/unhold", {
	m = {},
	function create()
	{
		this.m.Type = this.Const.EntityType.XXMobBear;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.Unhold.XP;
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.m.DecapitateSplatterOffset = this.createVec(40, -20);
		this.m.DecapitateBloodAmount = 3.0;
		this.m.ConfidentMoraleBrush = "icon_confident_orcs";
		this.actor.create();
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/bear_dead.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/unhold_flee_01.wav",
			"sounds/enemies/unhold_flee_02.wav",
			"sounds/enemies/unhold_flee_03.wav",
			"sounds/enemies/unhold_flee_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/bear_hit1.wav",
			"sounds/enemies/bear_hit2.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/bear_idle1.wav",
			"sounds/enemies/bear_idle2.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Other1] = [
			"sounds/enemies/bear_attack1.wav",
			"sounds/enemies/bear_attack2.wav"
		];
		this.m.SoundPitch = this.Math.rand(9, 11) * 0.1;
		this.m.SoundVolumeOverall = 1.25;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/unhold_agent");
		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Flee);
		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Retreat);
		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Charge);
		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.LineBreaker);
		this.m.AIAgent.setActor(this);
	}

	function onInit()
	{
		this.actor.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.Unhold);
		b.IsImmuneToDisarm = true;
		b.IsImmuneToRotation = true;
		local rrr = this.Math.rand(1, 3);
		if (rrr == 2)
		{
			b.MeleeSkill += 10;
			b.DamageTotalMult += 0.1;
		}
		b.Hitpoints += 200;
		b.DamageReceivedMeleeMult *= 0.7;
		b.DamageReceivedRangedMult *= 1.5;
		b.RangedDefense += -10;
		b.MovementAPCostAdditional += 1;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.addSprite("socket").setBrush("bust_base_beasts");
		local body = this.addSprite("body");
		if (rrr == 2)
		{
			body.setBrush("bust_bear_01");
		}
		else
		{
			body.setBrush("bust_bear_02");
		}
		body.varySaturation(0.1);
		body.varyColor(0.04, 0.04, 0.04);
		local injury_body = this.addSprite("injury");
		injury_body.Visible = false;
		injury_body.setBrush("bust_orc_02_body_bloodied_02");
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.65;
		this.setSpriteOffset("status_rooted", this.createVec(-10, 16));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_crippling_strikes"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_pathfinder"));
		local skilla = this.new("scripts/skills/actives/sweep_skill");
		skilla.m.Overlay = "active_154";
		this.m.Skills.add(skilla);
		skilla = this.new("scripts/skills/actives/sweep_zoc_skill");
		skilla.m.Overlay = "active_154";
		this.m.Skills.add(skilla);
	}

	function onFactionChanged()
	{
		this.actor.onFactionChanged();
		local flip = this.isAlliedWithPlayer();
		this.getSprite("body").setHorizontalFlipping(flip);
		this.getSprite("injury").setHorizontalFlipping(flip);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (_tile != null)
		{
			for( local i = 0; i < this.Const.Tactical.KrakenDevourVictimParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.KrakenDevourVictimParticles[i].Brushes, _tile, this.Const.Tactical.KrakenDevourVictimParticles[i].Delay, this.Const.Tactical.KrakenDevourVictimParticles[i].Quantity, this.Const.Tactical.KrakenDevourVictimParticles[i].LifeTimeQuantity, this.Const.Tactical.KrakenDevourVictimParticles[i].SpawnRate, this.Const.Tactical.KrakenDevourVictimParticles[i].Stages);
			}
			for( local i = 0; i < this.Const.Tactical.GruesomeFeastParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.GruesomeFeastParticles[i].Brushes, _tile, this.Const.Tactical.GruesomeFeastParticles[i].Delay, this.Const.Tactical.GruesomeFeastParticles[i].Quantity, this.Const.Tactical.GruesomeFeastParticles[i].LifeTimeQuantity, this.Const.Tactical.GruesomeFeastParticles[i].SpawnRate, this.Const.Tactical.GruesomeFeastParticles[i].Stages);
			}
			local flip = this.Math.rand(0, 100) < 50;
			this.m.IsCorpseFlipped = flip;
			this.spawnBloodPool(_tile, 1);
			local spriteName = this.getSprite("body").getBrush().Name;
			local corpse = clone this.Const.Corpse;
			corpse.Faction = this.getFaction();
			corpse.CorpseName = this.getName();
			corpse.Tile = _tile;
			corpse.IsHeadAttached = true;
			corpse.IsConsumable = true;
			corpse.IsResurrectable = false;
			local decal;

			if (_fatalityType == this.Const.FatalityType.Decapitated)
			{
                decal = _tile.spawnDetail(spriteName + "_body_dead", this.Const.Tactical.DetailFlag.Corpse, flip, false);
                decal.Scale = this.Math.rand(1, 10) * 0.01 + 0.95;
                if (spriteName == "bust_bear_01") decal.Scale += 0.10;
                decal.varySaturation(0.2);
                decal.varyColor(0.2, 0.2, 0.2);
                this.spawnTerrainDropdownEffect(_tile);

				local layers = [
					spriteName + "_head_dead"
				];

				local decap = this.Tactical.spawnHeadEffect(this.getTile(), layers, this.createVec(0, 0), 0.0, "bust_direwolf_head_bloodpool");
				decap[0].Scale = this.Math.rand(1, 10) * 0.01 + 1.3;
			}
			else
			{
                decal = _tile.spawnDetail(spriteName + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip, false);
                decal.Scale = this.Math.rand(1, 10) * 0.01 + 0.95;
                if (spriteName == "bust_bear_01") decal.Scale += 0.10;
                decal.varySaturation(0.2);
                decal.varyColor(0.2, 0.2, 0.2);
                this.spawnTerrainDropdownEffect(_tile);
			}

			if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Arrow)
			{
				decal = _tile.spawnDetail("bust_orc_02_body_dead_arrows", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.95;
			}
			else if (_skill && _skill.getProjectileType() == this.Const.ProjectileType.Javelin)
			{
				decal = _tile.spawnDetail("bust_orc_02_body_dead_javelin", this.Const.Tactical.DetailFlag.Corpse, flip);
				decal.Scale = 0.95;
			}
			_tile.Properties.set("Corpse", corpse);
			this.Tactical.Entities.addCorpse(_tile);
		}
		if (_killer == null || _killer.getFaction() == this.Const.Faction.Player || _killer.getFaction() == this.Const.Faction.PlayerAnimals)
		{
			local loot;
			if (this.Math.rand(1, 100) <= 30)
			{
				loot = this.new("scripts/items/supplies/strange_meat_item");
				loot.randomizeAmount()
				loot.drop(_tile);
			}
			if (this.Math.rand(1, 100) <= 20)
			{
				loot = this.new("scripts/items/misc/mysterious_herbs_item");
				loot.drop(_tile);
			}
			if (this.Math.rand(1, 100) <= 20)
			{
				loot = this.new("scripts/items/loot/sabertooth_item");
				loot.drop(_tile);
			}
			if (this.Math.rand(1, 100) <= 40)
			{
				loot = this.new("scripts/items/misc/bear_hide_item");
				loot.drop(_tile);
			}
		}
		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

});

