this.xxmob_ogre <- this.inherit("scripts/entity/tactical/actor", {
	m = {
		Rage = 0
	},
	function create()
	{
		this.m.Name = this.Const.Strings.FT.M57;
		this.m.Type = this.Const.EntityType.AlpShadow;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.Kraken.XP;
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.m.DecapitateSplatterOffset = this.createVec(-30, -15);
		this.m.DecapitateBloodAmount = 2.0;
		this.m.ConfidentMoraleBrush = "icon_confident_orcs";
		this.m.RenderAnimationDistanceMult = 3.0;
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
		this.m.Sound[this.Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/lindwurm_flee_01.wav",
			"sounds/enemies/lindwurm_flee_02.wav",
			"sounds/enemies/lindwurm_flee_03.wav",
			"sounds/enemies/lindwurm_flee_04.wav"
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
		this.m.Sound[this.Const.Sound.ActorEvent.Move] = this.m.Sound[this.Const.Sound.ActorEvent.Idle];
		this.m.SoundVolume[this.Const.Sound.ActorEvent.DamageReceived] = 1.5;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Death] = 1.5;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Flee] = 1.5;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Idle] = 2.0;
		this.m.SoundVolume[this.Const.Sound.ActorEvent.Move] = 1.5;
		this.m.SoundPitch = this.Math.rand(95, 105) * 0.01;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/bounty_hunter_melee_agent");
		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Flee);
		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Retreat);
		this.m.AIAgent.setActor(this);
		this.getFlags().add("xxmob_ogre");
	}

	function onInit()
	{
		this.actor.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.BanditPoacher);
		b.Vision = 50;
		b.Hitpoints += 6000;
		b.Bravery += 500;
		b.Stamina += 500;
		b.MeleeSkill += 10;
		b.Initiative -= 300;
		b.DamageRegularMin += 80;
		b.DamageRegularMax += 150;
		b.DamageArmorMult *= 1.1;
		b.MovementAPCostAdditional += 2;
		b.Armor[this.Const.BodyPart.Head] += 1500;
		b.ArmorMax[this.Const.BodyPart.Head] += 1500;
		b.Armor[this.Const.BodyPart.Body] += 1500;
		b.ArmorMax[this.Const.BodyPart.Body] += 1500;
		b.IsAffectedByNight = false;
		b.IsAffectedByFreshInjuries = false;
		b.IsAffectedByInjuries = false;
		b.IsImmuneToKnockBackAndGrab = true;
		b.IsImmuneToStun = true;
		b.IsImmuneToRoot = true;
		b.IsImmuneToDisarm = true;
		b.IsImmuneToDamageReflection = true;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.addSprite("socket").setBrush("bust_base_beasts");

		local body = this.addSprite("body");
		body.setBrush("bust_ogre_01");
		local injury_body = this.addSprite("injury");
		injury_body.Visible = false;
		injury_body.setBrush("bust_ghoul_03_injured");
		injury_body.Scale = 1.1;

		this.addDefaultStatusSprites();
		this.setSpriteOffset("injury", this.createVec(0, 90));
		this.setSpriteOffset("arrow", this.createVec(20, 190));
		this.setAlwaysApplySpriteOffset(true);
		this.m.Skills.add(this.new("scripts/skills/perks/perk_fearsome"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_pathfinder"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_berserk"));
		local bh = this.new("scripts/skills/actives/ai_bonushit");
		bh.m.HitChanceBonus = 5;
		this.m.Skills.add(bh);
		bh = this.new("scripts/skills/actives/ai_punch_swing");
		bh.m.Name = "Overwhelming Strike";
		bh.setStunTime(3);
		bh.setStunChance(55);
		this.m.Skills.add(bh);
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
			local decal = _tile.spawnDetail("bust_body_sunburn_dead", this.Const.Tactical.DetailFlag.Corpse, flip, false);
			decal.Scale = 1.5;
			decal.setBrightness(0.5);
			this.spawnTerrainDropdownEffect(_tile);
			this.spawnBloodPool(_tile, 1);
		}
		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function onTurnStart()
	{
		this.actor.onTurnStart();
		if (this.Tactical.Entities.isEnemyRetreating() || this.Tactical.State.isAutoRetreat() || !this.m.IsAlive || this.m.IsDying)
		{
			return;
		}
		this.m.Rage = this.m.Rage + 1;
		if (this.m.Rage >= 1)
		{
			local mytile = this.actor.getTile();
			local actors = this.Tactical.Entities.getAllInstances();
			local yes = 0;
			foreach( i in actors )
			{
				foreach( a in i )
				{
					if (a.getID() == this.actor.getID())
					{
						continue;
					}
					if (!a.isAlliedWith(this.actor) && mytile.getDistanceTo(a.getTile()) <= 3)
					{
						a.getSkills().add(this.new("scripts/skills/effects/ai_ogre_effect"));
						if (this.m.Rage >= 2)
						{
							yes = 1;
							a.checkMorale(-1, 0, this.Const.MoraleCheckType.MentalAttack);
						}
					}
				}
			}
			if (mytile.IsVisibleForPlayer && yes == 1)
			{
				this.Tactical.spawnIconEffect("status_effect_106", mytile, this.Const.Tactical.Settings.SkillIconOffsetX, this.Const.Tactical.Settings.SkillIconOffsetY, this.Const.Tactical.Settings.SkillIconScale, this.Const.Tactical.Settings.SkillIconFadeInDuration, this.Const.Tactical.Settings.SkillIconStayDuration, this.Const.Tactical.Settings.SkillIconFadeOutDuration, this.Const.Tactical.Settings.SkillIconMovement);
				this.Sound.play("sounds/enemies/orc_idle_0" + this.Math.rand(4, 5) + ".wav", this.Const.Sound.Volume.Skill * 0.8, mytile.Pos);
				this.m.Rage = 0;
			}
		}
	}

});

