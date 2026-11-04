this.xxmob_dragon <- this.inherit("scripts/entity/tactical/actor", {
	m = {
		Rage = 0
	},
	function create()
	{
		this.m.Name = this.Const.Strings.FT.M29;
		this.m.Type = this.Const.EntityType.AlpShadow;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.Kraken.XP;
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.m.DecapitateSplatterOffset = this.createVec(-30, -15);
		this.m.DecapitateBloodAmount = 2.0;
		this.m.ConfidentMoraleBrush = "icon_confident_orcs";
		this.m.IsUsingZoneOfControl = false;
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
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/military_gunner_agent");
		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Flee);
		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Retreat);
		this.m.AIAgent.setActor(this);
	}

	function onInit()
	{
		this.actor.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.BanditPoacher);
		b.Vision = 50;
		b.Hitpoints += 5000;
		b.Bravery += 500;
		b.Stamina += 500;
		b.MeleeSkill += 20;
		b.RangedSkill += 20;
		b.Initiative -= 300;
		b.IsAffectedByNight = false;
		b.IsAffectedByFreshInjuries = false;
		b.IsAffectedByInjuries = false;
		b.IsImmuneToKnockBackAndGrab = true;
		b.IsImmuneToStun = true;
		b.IsImmuneToPoison = true;
		b.IsImmuneToRoot = true;
		b.IsMovable = false;
		b.IsRooted = true;
		b.IsImmuneToDisarm = true;
		b.IsImmuneToDamageReflection = true;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.addSprite("socket").setBrush("bust_base_beasts");

		local body = this.addSprite("body");
		body.setBrush("bust_reddragon_01");
		local injury_body = this.addSprite("injury");
		injury_body.Visible = false;
		injury_body.setBrush("bust_ghoul_03_injured");

		this.addDefaultStatusSprites();
		this.setSpriteOffset("arrow", this.createVec(20, 190));
		this.m.Skills.add(this.new("scripts/skills/actives/ai_dragontail_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/ai_dragonbreath_skill"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_hold_out"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_fearsome"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_fast_adaption"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_berserk"));
	}

	function assignRandomEquipment()
	{
		local itt = this.new("scripts/items/armor/named/black_leather_armor");
		itt.m.ShowOnCharacter = false;
		itt.m.Condition = this.Math.rand(2000, 2200);
		itt.m.ConditionMax = itt.m.Condition;
		this.m.Items.equip(itt);
		local htt = this.new("scripts/items/helmets/named/wolf_helmet");
		htt.m.ShowOnCharacter = false;
		htt.m.Condition = this.Math.rand(1500, 1700);
		htt.m.ConditionMax = htt.m.Condition;
		this.m.Items.equip(htt);
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
			local decal = _tile.spawnDetail(this.Const.BloodDecals[this.m.BloodType][this.Math.rand(0, this.Const.BloodDecals[this.m.BloodType].len() - 1)], this.Math.rand(0, 1) == 0, false, 0);
			decal.Scale = this.Math.rand(1, 10) * 0.01 + 1.1;
			decal.varySaturation(0.2);
			decal.varyColor(0.2, 0.2, 0.2);
			this.spawnTerrainDropdownEffect(_tile);
			this.spawnBloodPool(_tile, 1);
		}
		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function onTurnEnd()
	{
		this.actor.onTurnEnd();
		if (this.Tactical.Entities.isEnemyRetreating() || this.Tactical.State.isAutoRetreat() || !this.m.IsAlive || this.m.IsDying)
		{
			return;
		}
		this.m.Rage = this.m.Rage + 1;
		if (this.m.Rage == 3)
		{
			local b = this.m.BaseProperties;
			b.MeleeSkill += 5000;
			b.MeleeDefense += 5000;
			b.MeleeDamageMult = 5.0;
			b.DamageReceivedTotalMult = 0.5;
			this.actor.getSkills().add(this.new("scripts/skills/actives/ai_fakebuff"));
			this.actor.getSprite("body").Color = this.createColor("#eb7373");
			local sounds = [
				"sounds/enemies/warcry_01.wav"
			];
			this.Sound.play(sounds[this.Math.rand(0, sounds.len() - 1)], 1.5, this.actor.getTile().Pos);
		}
		if (this.m.Rage >= 4)
		{
			local b = this.m.BaseProperties;
			b.MeleeSkill -= 5000;
			b.MeleeDefense -= 5000;
			b.MeleeDamageMult = 1.0;
			b.DamageReceivedTotalMult = 1.0;
			this.actor.getSprite("body").Color = this.createColor("#ffffff");
			this.m.Rage = 0;
		}
	}

});

