this.xxmob_cosmictail <- this.inherit("scripts/entity/tactical/actor", {
	m = {
		Parent = null
	},
	function setParent( _p )
	{
		if (_p == null)
		{
			this.m.Parent = null;
		}
		else
		{
			this.m.Parent = this.WeakTableRef(_p);
		}
	}

	function getParent()
	{
		return this.m.Parent;
	}

	function create()
	{
		this.m.Name = this.Const.Strings.FT.M22;
		this.m.Type = this.Const.EntityType.AlpShadow;
		this.m.BloodType = this.Const.BloodType.Dark;
		this.m.XP = this.Const.Tactical.Actor.FlyingSkull.XP;
		this.m.MoraleState = this.Const.MoraleState.Ignore;
		this.m.ConfidentMoraleBrush = "icon_confident_orcs";
		this.actor.create();
		this.m.BloodSplatterOffset = this.createVec(0, 0);
		this.m.DecapitateSplatterOffset = this.createVec(15, -26);
		this.m.DecapitateBloodAmount = 1.0;
		this.m.DeathBloodAmount = 0.0;
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/lindwurm_death_01.wav",
			"sounds/enemies/lindwurm_death_02.wav",
			"sounds/enemies/lindwurm_death_03.wav",
			"sounds/enemies/lindwurm_death_04.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/lindwurm_hurt_01.wav",
			"sounds/enemies/lindwurm_hurt_02.wav",
			"sounds/enemies/lindwurm_hurt_03.wav",
			"sounds/enemies/lindwurm_hurt_04.wav"
		];
		this.m.SoundVolume[this.Const.Sound.ActorEvent.DamageReceived] = 2.0;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/xxmonster_a_agent");
		this.m.AIAgent.setActor(this);
	}

	function onInit()
	{
		this.actor.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.BanditPoacher);
		b.IsAffectedByNight = false;
		b.IsAffectedByInjuries = false;
		b.IsImmuneToDisarm = true;
		b.Hitpoints += this.Math.rand(80, 90);
		b.MeleeSkill += this.Math.rand(10, 30);
		b.MeleeDefense -= 10;
		b.Initiative -= 70;
		b.DamageRegularMin += 30;
		b.DamageRegularMax += 50;
		b.Vision += 2;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.addSprite("socket").setBrush("bust_base_beasts");
		local body = this.addSprite("body");
		body.setBrush("bust_cosmictail_01");
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.54;
		this.setSpriteOffset("status_rooted", this.createVec(0, 0));

		local wtt = this.new("scripts/items/weapons/named/xx_mob_fakeweapon15");
		wtt.m.RangeMax = 5;
		wtt.m.RangeIdeal = 5;
		this.m.Items.equip(wtt);

		this.m.Skills.add(this.new("scripts/skills/actives/ai_punch_cosmictail"));
		this.m.Skills.add(this.new("scripts/skills/actives/ai_bonushit"));
		local stun = this.new("scripts/skills/effects/ai_stun_effect");
		this.m.Skills.add(stun);
		stun.setTurns(1);

		this.Tactical.getTemporaryRoster().add(this);
		local rrr = this.Math.rand(80, 90);
		b.Armor[this.Const.BodyPart.Head] += rrr;
		b.ArmorMax[this.Const.BodyPart.Head] += rrr;
		b.Armor[this.Const.BodyPart.Body] += rrr;
		b.ArmorMax[this.Const.BodyPart.Body] += rrr;
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.m.BloodType = this.Const.BloodType.Ash;
		if (this.m.Parent != null && !this.m.Parent.isNull() && this.m.Parent.isAlive() && !this.m.Parent.isDying())
		{
			this.m.Parent.onTentacleDestroyed();
		}
		this.Tactical.getTemporaryRoster().remove(this);
		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

});

