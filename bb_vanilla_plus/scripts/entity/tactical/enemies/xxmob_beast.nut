this.xxmob_beast <- this.inherit("scripts/entity/tactical/actor", {
	m = {},
	function create()
	{
		this.m.Name = this.Const.Strings.FT.M13;
		this.m.Type = this.Const.EntityType.AlpShadow;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.OrcBerserker.XP;
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.m.DecapitateSplatterOffset = this.createVec(-10, -25);
		this.m.DecapitateBloodAmount = 1.0;
		this.m.ConfidentMoraleBrush = "icon_confident_orcs";
		this.actor.create();
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/lindwurm_hurt_01.wav",
			"sounds/enemies/lindwurm_hurt_02.wav",
			"sounds/enemies/lindwurm_hurt_03.wav",
			"sounds/enemies/lindwurm_hurt_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/lindwurm_death_01.wav",
			"sounds/enemies/lindwurm_death_02.wav",
			"sounds/enemies/lindwurm_death_03.wav",
			"sounds/enemies/lindwurm_death_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/lindwurm_idle_01.wav",
			"sounds/enemies/lindwurm_idle_02.wav",
			"sounds/enemies/lindwurm_idle_03.wav",
			"sounds/enemies/lindwurm_idle_04.wav",
			"sounds/enemies/lindwurm_idle_05.wav",
			"sounds/enemies/lindwurm_idle_06.wav",
			"sounds/enemies/lindwurm_idle_07.wav",
			"sounds/enemies/lindwurm_idle_08.wav",
			"sounds/enemies/lindwurm_idle_09.wav",
			"sounds/enemies/lindwurm_idle_10.wav",
			"sounds/enemies/lindwurm_idle_11.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Flee] = this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived];
		this.m.Sound[this.Const.Sound.ActorEvent.Move] = this.m.Sound[this.Const.Sound.ActorEvent.Idle];
		this.m.SoundVolume[this.Const.Sound.ActorEvent.DamageReceived] = 1.1;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Death] = 1.1;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Flee] = 1.1;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Idle] = 1.1;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Move] = 1.1;
		this.m.SoundPitch = this.Math.rand(95, 105) * 0.01;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/orc_warlord_agent");
		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Flee);
		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Retreat);
		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Shieldwall);
		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.KnockBack);
		this.m.AIAgent.setActor(this);
	}

	function onInit()
	{
		this.actor.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.OrcBerserker);
		b.IsAffectedByFleeingAllies = false;
		b.IsAffectedByDyingAllies = false;
		b.IsAffectedByNight = false;
		b.IsSpecializedInAxes = true;
		b.Hitpoints += 200;
		b.Bravery += 60;
		b.Initiative += 75;
		local an = 150;
		b.Armor[this.Const.BodyPart.Head] += an;
		b.ArmorMax[this.Const.BodyPart.Head] += an;
		b.Armor[this.Const.BodyPart.Body] += an;
		b.ArmorMax[this.Const.BodyPart.Body] += an;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.addSprite("socket").setBrush("bust_base_beasts");
		local body = this.addSprite("body");
		body.setBrush("bust_bigwolf_0" + this.Math.rand(4, 5));
		body.varyColor(0.03, 0.03, 0.03);
		body.varySaturation(0.2);
		body.Scale = 0.9;
		local surcoat = this.addSprite("surcoat");
		surcoat.setBrush("bust_armored_unhold_body_01");
		surcoat.Scale = 0.95;
		this.setSpriteOffset("surcoat", this.createVec(2, 1));
		local surcoat2 = this.addSprite("surcoat2");
		surcoat2.setBrush("bust_armored_unhold_body_02");
		surcoat2.Scale = 1;
		this.setSpriteOffset("surcoat2", this.createVec(0, 1));
		local helm = this.addSprite("helm");
		if (this.Math.rand(1, 2) == 1)
		{
			helm.setBrush("bust_armored_unhold_head_01");
		}
		else
		{
			helm.setBrush("bust_armored_unhold_head_02");
		}
		helm.Scale = 0.9;
		this.setSpriteOffset("helm", this.createVec(-9, 5));
		local injury_body = this.addSprite("injury");
		injury_body.Visible = false;
		injury_body.setBrush("bust_direwolf_injured");
		injury_body.Scale = 1;
		this.setSpriteOffset("injury", this.createVec(-5, 0));
		this.addDefaultStatusSprites();
		this.setSpriteOffset("arms_icon", this.createVec(-4, 5));
		this.getSprite("status_rooted").Scale = 0.54;
		this.setSpriteOffset("status_rooted", this.createVec(0, 0));
		this.setAlwaysApplySpriteOffset(true);
		local bh = this.new("scripts/skills/actives/warcry");
		bh.m.Name = "Lore";
		bh.m.SoundOnUse = [
			"sounds/enemies/lindwurm_hurt_04.wav"
		];
		bh.m.SoundVolume = 1.2;
		bh.m.Overlay = "active_103";
		this.m.Skills.add(bh);
		bh = this.new("scripts/skills/actives/wolf_bite");
		bh.m.SoundOnUse = ["sounds/enemies/lindwurm_gorge_01.wav"];
		bh.m.Name = "Bite";
		bh.setRestrained(true);
		bh.m.ActionPointCost = 0;
		this.m.Skills.add(bh);
		this.m.Skills.add(this.new("scripts/skills/perks/perk_pathfinder"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_crippling_strikes"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_coup_de_grace"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_berserk"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_killing_frenzy"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_fearsome"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_overwhelm"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_relentless"));
	}

	function assignRandomEquipment()
	{
		local w = this.new("scripts/items/weapons/greenskins/orc_axe_2h");
		w.m.ArmamentIcon = "icon_wildmen_08";
		this.m.Items.equip(w);
		this.getSprite("arms_icon").Scale = 1.15;
	}

	function onUpdateInjuryLayer()
	{
		this.actor.onUpdateInjuryLayer();
		local p = this.m.Hitpoints / this.getHitpointsMax();
		if (p < 0.7)
		{
			this.getSprite("helm").Visible = false;
			this.getSprite("surcoat2").Visible = false;
		}
		if (p < 0.5)
		{
			this.getSprite("surcoat").Visible = false;
		}
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
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
				a.getBaseProperties().MeleeSkill += 5;
				a.getBaseProperties().RangedSkill += 5;
				a.getBaseProperties().Hitpoints += 100;
				if (a.getMoraleState() < this.Const.MoraleState.Steady)
				{
					a.setMoraleState(this.Const.MoraleState.Steady);
				}
				local atile = a.getTile();
				if (atile.IsVisibleForPlayer)
				{
					this.Tactical.spawnIconEffect("status_effect_106", atile, this.Const.Tactical.Settings.SkillIconOffsetX, this.Const.Tactical.Settings.SkillIconOffsetY, this.Const.Tactical.Settings.SkillIconScale, this.Const.Tactical.Settings.SkillIconFadeInDuration, this.Const.Tactical.Settings.SkillIconStayDuration, this.Const.Tactical.Settings.SkillIconFadeOutDuration, this.Const.Tactical.Settings.SkillIconMovement);
				}
			}
		}

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
		if (_killer == null || _killer.getFaction() == this.Const.Faction.Player || _killer.getFaction() == this.Const.Faction.PlayerAnimals)
		{
			local loot;
			if (this.Math.rand(1, 100) <= 30)
			{
				loot = this.new("scripts/items/loot/soul_splinter_item");
				loot.drop(_tile);
			}
			if (this.Math.rand(1, 100) <= 5)
			{
				loot = this.new("scripts/items/loot/ancient_gold_coins_item");
				loot.drop(_tile);
			}
		}
		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

});

