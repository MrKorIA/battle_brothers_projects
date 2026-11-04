this.xxmob_wendigo <- this.inherit("scripts/entity/tactical/actor", {
	m = {},
	function create()
	{
		this.m.Name = this.Const.Strings.FT.M75;
		this.m.Type = this.Const.EntityType.AlpShadow;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.Unhold.XP;
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.m.DecapitateSplatterOffset = this.createVec(40, -20);
		this.m.DecapitateBloodAmount = 3.0;
		this.m.ConfidentMoraleBrush = "icon_confident_orcs";
		this.actor.create();
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/unhold_death_01.wav",
			"sounds/enemies/unhold_death_02.wav",
			"sounds/enemies/unhold_death_03.wav",
			"sounds/enemies/unhold_death_04.wav",
			"sounds/enemies/unhold_death_05.wav",
			"sounds/enemies/unhold_death_06.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/unhold_flee_01.wav",
			"sounds/enemies/unhold_flee_02.wav",
			"sounds/enemies/unhold_flee_03.wav",
			"sounds/enemies/unhold_flee_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/unhold_hurt_01.wav",
			"sounds/enemies/unhold_hurt_02.wav",
			"sounds/enemies/unhold_hurt_03.wav",
			"sounds/enemies/unhold_hurt_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/unhold_idle_01.wav",
			"sounds/enemies/unhold_idle_02.wav",
			"sounds/enemies/unhold_idle_03.wav",
			"sounds/enemies/unhold_idle_04.wav",
			"sounds/enemies/unhold_idle_05.wav",
			"sounds/enemies/unhold_idle_06.wav",
			"sounds/enemies/unhold_idle_07.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Other1] = [
			"sounds/enemies/unhold_confused_01.wav",
			"sounds/enemies/unhold_confused_02.wav",
			"sounds/enemies/unhold_confused_03.wav",
			"sounds/enemies/unhold_confused_04.wav"
		];
		this.m.SoundPitch = this.Math.rand(9, 11) * 0.1;
		this.m.SoundVolumeOverall = 1.25;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/unhold_agent");
		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Flee);
		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Retreat);
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

	function onInit()
	{
		this.actor.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.UnholdFrost);
		b.IsImmuneToDisarm = true;
		b.IsImmuneToRotation = true;
		b.Hitpoints += 600;
		b.Bravery += 500;
		b.DamageTotalMult += 0.2;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.addSprite("socket").setBrush("bust_base_beasts");
		local body = this.addSprite("body");
		body.setBrush("bust_wolfking_0" + this.Math.rand(1, 2));
		body.varySaturation(0.1);
		body.varyColor(0.04, 0.04, 0.04);
		local injury_body = this.addSprite("injury");
		injury_body.Visible = false;
		injury_body.setBrush("bust_orc_02_body_bloodied_02");
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.65;
		this.setSpriteOffset("status_rooted", this.createVec(-10, 16));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_pathfinder"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_crippling_strikes"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_coup_de_grace"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_steel_brow"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_battering_ram"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_stalwart"));
		this.m.Skills.add(this.new("scripts/skills/actives/ai_psv_frost"));
		local skilla = this.new("scripts/skills/actives/sweep_skill");
		skilla.m.Overlay = "active_154";
		this.m.Skills.add(skilla);
		skilla = this.new("scripts/skills/actives/sweep_zoc_skill");
		skilla.m.Overlay = "active_154";
		this.m.Skills.add(skilla);
		skilla = this.new("scripts/skills/actives/unstoppable_charge_skill");
		skilla.m.Overlay = "active_166";
		this.m.Skills.add(skilla);
	}

	function onTurnStart()
	{
		this.actor.onTurnStart();
		if (this.Tactical.Entities.isEnemyRetreating() || this.Tactical.State.isAutoRetreat() || !this.m.IsAlive || this.m.IsDying)
		{
			return;
		}
		local mytile = this.actor.getTile();
		local actors = this.Tactical.Entities.getAllInstances();
		foreach( i in actors )
		{
			foreach( a in i )
			{
				if (a.getID() == this.actor.getID())
				{
					continue;
				}
				if (a.getFaction() == this.actor.getFaction() && a.getMoraleState() < this.Const.MoraleState.Steady)
				{
					if (mytile.getDistanceTo(a.getTile()) <= 2)
					{
						a.setMoraleState(this.Const.MoraleState.Steady);
					}
					else if (this.Math.rand(1, 100) <= 50)
					{
						a.setMoraleState(this.Const.MoraleState.Wavering);
					}
				}
				else if (!a.isAlliedWith(this.actor) && mytile.getDistanceTo(a.getTile()) <= 2 && this.Math.rand(1, 100) <= 50)
				{
					a.checkMorale(-1, 0, this.Const.MoraleCheckType.MentalAttack, "status_effect_52");
				}
			}
		}
		if (mytile.IsVisibleForPlayer)
		{
			this.Tactical.spawnIconEffect("status_effect_98", mytile, this.Const.Tactical.Settings.SkillIconOffsetX, this.Const.Tactical.Settings.SkillIconOffsetY, this.Const.Tactical.Settings.SkillIconScale, this.Const.Tactical.Settings.SkillIconFadeInDuration, this.Const.Tactical.Settings.SkillIconStayDuration, this.Const.Tactical.Settings.SkillIconFadeOutDuration, this.Const.Tactical.Settings.SkillIconMovement);
		}
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
			local decal = _tile.spawnDetail("bust_xxcorpse_0" + this.Math.rand(1, 2), this.Const.Tactical.DetailFlag.Corpse, flip, false);
			decal.Scale = this.Math.rand(1, 10) * 0.01 + 1.1;
			decal.varySaturation(0.2);
			decal.varyColor(0.2, 0.2, 0.2);
			this.spawnTerrainDropdownEffect(_tile);
			local corpse = clone this.Const.Corpse;
			corpse.Faction = this.getFaction();
			corpse.CorpseName = this.getName();
			corpse.Tile = _tile;
			corpse.IsHeadAttached = true;
			corpse.IsConsumable = true;
			corpse.IsResurrectable = false;
			_tile.Properties.set("Corpse", corpse);
			this.Tactical.Entities.addCorpse(_tile);
		}
		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

});

