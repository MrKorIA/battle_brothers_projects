this.xxmob_cosmic <- this.inherit("scripts/entity/tactical/actor", {
	m = {
		Tentacles = []
	},
	function create()
	{
		this.m.Name = this.Const.Strings.FT.M20;
		this.m.Type = this.Const.EntityType.AlpShadow;
		this.m.BloodType = this.Const.BloodType.Dark;
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
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/bounty_hunter_melee_agent");
		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Flee);
		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Retreat);
		this.m.AIAgent.setActor(this);
	}

	function onInit()
	{
		this.actor.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.BanditPoacher);
		b.Vision += 50;
		b.Hitpoints += 3000;
		b.Bravery += 500;
		b.Stamina += 500;
		b.MeleeSkill += 20;
		b.RangedSkill += 20;
		b.Initiative += -300;
		b.MovementAPCostAdditional += 1;
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

		local wtt = this.new("scripts/items/weapons/named/xx_mob_fakeweapon15");
		wtt.m.RangeMax = 5;
		wtt.m.RangeIdeal = 5;
		this.m.Items.equip(wtt);
		local body = this.addSprite("body");
		body.setBrush("bust_cosmic_01");
		this.addDefaultStatusSprites();
		this.setSpriteOffset("arrow", this.createVec(20, 190));

		local myTile = this.getTile();
		for( local i = 0; i < 8; i = ++i )
		{
			local mapSize = this.Tactical.getMapSize();

			for( local attempts = 0; attempts < 500; attempts = ++attempts )
			{
				local x = this.Math.rand(this.Math.max(0, myTile.SquareCoords.X - 2), this.Math.min(mapSize.X - 1, myTile.SquareCoords.X + 8));
				local y = this.Math.rand(this.Math.max(0, myTile.SquareCoords.Y - 8), this.Math.min(mapSize.Y - 1, myTile.SquareCoords.Y + 8));
				local tile = this.Tactical.getTileSquare(x, y);

				if (!tile.IsEmpty)
				{
				}
				else
				{
					local tentacle = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/xxmob_cosmictail", tile.Coords);
					tentacle.setParent(this);
					tentacle.setFaction(this.getFaction());
					this.m.Tentacles.push(this.WeakTableRef(tentacle));
					break;
				}
			}
		}
		this.m.Skills.add(this.new("scripts/skills/actives/ai_deathwind_skill"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_pathfinder"));
		local rrr = this.Math.rand(1800, 1900);
		b.Armor[this.Const.BodyPart.Head] += rrr;
		b.ArmorMax[this.Const.BodyPart.Head] += rrr;
		b.Armor[this.Const.BodyPart.Body] += rrr;
		b.ArmorMax[this.Const.BodyPart.Body] += rrr;
	}

	function onTentacleDestroyed()
	{
		if (!this.isAlive() || this.isDying())
		{
			return;
		}

		foreach( i, t in this.m.Tentacles )
		{
			if (t.isNull() || t.isDying() || !t.isAlive())
			{
				this.m.Tentacles.remove(i);
				break;
			}
		}

		local hitInfo = clone this.Const.Tactical.HitInfo;
		hitInfo.DamageRegular = 100;
		hitInfo.DamageDirect = 1.0;
		hitInfo.BodyPart = this.Const.BodyPart.Head;
		hitInfo.BodyDamageMult = 1.0;
		hitInfo.FatalityChanceMult = 0.0;
		this.onDamageReceived(this, null, hitInfo);

		if (!this.isAlive() || this.isDying())
		{
			return;
		}

		for( local numTentacles = 8; this.m.Tentacles.len() < numTentacles;  )
		{
			local mapSize = this.Tactical.getMapSize();
			local myTile = this.getTile();

			for( local attempts = 0; attempts < 500; attempts = ++attempts )
			{
				local x = this.Math.rand(this.Math.max(0, myTile.SquareCoords.X - 8), this.Math.min(mapSize.X - 1, myTile.SquareCoords.X + 8));
				local y = this.Math.rand(this.Math.max(0, myTile.SquareCoords.Y - 8), this.Math.min(mapSize.Y - 1, myTile.SquareCoords.Y + 8));
				local tile = this.Tactical.getTileSquare(x, y);

				if (!tile.IsEmpty)
				{
				}
				else
				{
					local tentacle = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/xxmob_cosmictail", tile.Coords);
					tentacle.setParent(this);
					tentacle.setFaction(this.getFaction());
					tentacle.riseFromGround();
					this.m.Tentacles.push(this.WeakTableRef(tentacle));
					break;
				}
			}
		}
	}

	function setFaction( _f )
	{
		this.actor.setFaction(_f);

		foreach( t in this.m.Tentacles )
		{
			if (!t.isNull() && t.isAlive())
			{
				t.setFaction(_f);
			}
		}
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (_tile != null)
		{
			foreach( t in this.m.Tentacles )
			{
				if (t.isNull())
				{
					continue;
				}

				t.setParent(null);

				if (t.isPlacedOnMap())
				{
					t.killSilently();
				}
			}
			this.m.Tentacles = [];
		}
		this.m.BloodType = this.Const.BloodType.Ash;
		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

});

