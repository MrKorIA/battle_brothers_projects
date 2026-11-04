this.xxmob_cultqueen <- this.inherit("scripts/entity/tactical/human", {
	m = {
		Info = null
	},
	function create()
	{
		this.m.Name = this.Const.Strings.FT.M25;
		this.m.Type = this.Const.EntityType.AlpShadow;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.MoraleState = this.Const.MoraleState.Ignore;
		this.m.XP = this.Const.Tactical.Actor.OrcBerserker.XP;
		this.human.create();
		this.m.Faces = null;
		this.m.Hairs = null;
		this.m.HairColors = null;
		this.m.Beards = null;
		this.m.ConfidentMoraleBrush = "icon_confident_undead";
		this.m.SoundPitch = 0.9;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/skeleton_melee_agent");
		this.m.AIAgent.setActor(this);
		this.m.ConfidentMoraleBrush = "icon_confident_orcs";
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/ghost_death_01.wav",
			"sounds/enemies/ghost_death_02.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/ghastly_touch_01.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Flee] = this.m.Sound[this.Const.Sound.ActorEvent.Death];
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = this.m.Sound[this.Const.Sound.ActorEvent.Death];
		this.m.Sound[this.Const.Sound.ActorEvent.NoDamageReceived] = this.m.Sound[this.Const.Sound.ActorEvent.Idle];
		this.m.Sound[this.Const.Sound.ActorEvent.Fatigue] = this.m.Sound[this.Const.Sound.ActorEvent.Idle];
	}

	function onInit()
	{
		this.human.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.BanditPoacher);
		b.IsAffectedByNight = false;
		b.IsAffectedByInjuries = false;
		b.IsSpecializedInPolearms = true;
		b.ActionPoints += 1;
		b.Hitpoints += 300;
		b.MeleeSkill += 20;
		b.MeleeDefense += 15;
		b.Bravery += 500;
		b.Stamina += 200;
		b.DamageTotalMult *= 2;
		b.TargetAttractionMult = 3;
		b.Vision = 15;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.setAppearance();
		this.addSprite("socket").setBrush("bust_base_beasts");
		this.getSprite("head").Color = this.createColor("#ffffff");
		this.getSprite("head").Saturation = 0.5;
		this.getSprite("body").Saturation = 0.5;
		this.m.Skills.add(this.new("scripts/skills/perks/perk_fearsome"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_nimble"));
		this.m.Skills.add(this.new("scripts/skills/actives/ai_bonushit"));
		this.getSprite("head").setBrush("bust_head_7870");
		this.getSprite("hair").setBrush("bust_helmet_36");
		this.getSprite("beard").setBrush("hair_red_21");
		this.setSpriteOffset("beard", this.createVec(-1, 3.5));
		this.getSprite("beard").Scale = 0.9;
		this.addSprite("permanent_injury_x5").setHorizontalFlipping(true);
		this.getSprite("permanent_injury_x5").setBrush("zombie_rage_eyes");
		this.getSprite("permanent_injury_x5").Visible = true;
		this.getSprite("permanent_injury_x5").Color = this.createColor("#fff200");
		this.getSprite("permanent_injury_x5").Saturation = 1.1;
		this.setSpriteOffset("permanent_injury_x5", this.createVec(-1.5, -3));
		this.setAlwaysApplySpriteOffset(true);
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
			this.spawnTerrainDropdownEffect(_tile);
			this.spawnBloodPool(_tile, 1);
		}
		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function assignRandomEquipment()
	{
		this.m.Items.equip(this.new("scripts/items/weapons/named/xx_mob_scythe"));
		this.m.Items.equip(this.new("scripts/items/armor/thick_tunic"));
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
			if (a.isAlive() && !a.isPlayerControlled() && a.getFlags().has("human"))
			{
				a.getBaseProperties().MeleeSkill += 20;
				a.getBaseProperties().RangedSkill += 20;
				a.getBaseProperties().MeleeDefense += 10;
				a.getBaseProperties().Hitpoints += 200;
				a.getBaseProperties().IsAffectedByLosingHitpoints = false;
				a.getBaseProperties().IsAffectedByFleeingAllies = false;
				a.getBaseProperties().IsAffectedByDyingAllies = false;
				a.getBaseProperties().IsAffectedByFreshInjuries = false;
				a.getBaseProperties().IsAffectedByInjuries = false;
				a.addSprite("permanent_injury_7").setHorizontalFlipping(true);
				a.getSprite("permanent_injury_7").setBrush("zombify_04_injured");
				a.getSprite("permanent_injury_7").Visible = true;
				a.getSprite("permanent_injury_7").Color = this.createColor("#c9ff87");
				a.getSprite("permanent_injury_7").Saturation = 0.7;
				a.addSprite("permanent_injury_8").setHorizontalFlipping(true);
				a.getSprite("permanent_injury_8").setBrush("zombie_rage_eyes");
				a.getSprite("permanent_injury_8").Visible = true;
				a.getSprite("permanent_injury_8").Color = this.createColor("#b0ff4f");
				a.getSprite("permanent_injury_8").Saturation = 0.7;
				a.getSprite("head").Saturation = 0.2;
				a.getSprite("body").Saturation = 0.2;
				a.checkMorale(9999, 9999);
			}
		}
/////////////////
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
/////////////////
		local xxinfo = {
			Tile = this.getTile(),
			Faction = this.getFaction()
		};
		this.Sound.play("sounds/enemies/horrific_scream_01.wav", this.Const.Sound.Volume.Skill * 2.25, xxinfo.Tile.Pos);
		local mapSize = this.Tactical.getMapSize();
		local attempts = 0;
		local nn = 0;
		while (attempts++ < 250)
		{
			local x = this.Math.rand(this.Math.max(0, xxinfo.Tile.SquareCoords.X - 5), this.Math.min(mapSize.X - 1, xxinfo.Tile.SquareCoords.X + 5));
			local y = this.Math.rand(this.Math.max(0, xxinfo.Tile.SquareCoords.Y - 5), this.Math.min(mapSize.Y - 1, xxinfo.Tile.SquareCoords.Y + 5));
			if (!this.Tactical.isValidTileSquare(x, y))
			{
				continue;
			}
			local tile = this.Tactical.getTileSquare(x, y);
			if (!tile.IsEmpty || tile.ID == xxinfo.Tile.ID)
			{
				continue;
			}
			for( local i = 0; i < this.Const.Tactical.KrakenDevourVictimParticles.len(); i = ++i )
			{
				this.Tactical.spawnParticleEffect(false, this.Const.Tactical.KrakenDevourVictimParticles[i].Brushes, tile, this.Const.Tactical.KrakenDevourVictimParticles[i].Delay, this.Const.Tactical.KrakenDevourVictimParticles[i].Quantity, this.Const.Tactical.KrakenDevourVictimParticles[i].LifeTimeQuantity, this.Const.Tactical.KrakenDevourVictimParticles[i].SpawnRate, this.Const.Tactical.KrakenDevourVictimParticles[i].Stages);
			}
			local ee 
			ee = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/xxmob_finger", tile.Coords);
			ee.setFaction(xxinfo.Faction);
			ee.riseFromGround(0.7);
			nn = ++nn;
			if (nn >= 7)
			{
				break;
			}
		}
	}

});

