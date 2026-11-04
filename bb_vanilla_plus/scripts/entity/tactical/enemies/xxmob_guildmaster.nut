this.xxmob_guildmaster <- this.inherit("scripts/entity/tactical/human", {
	m = {},
	function create()
	{
		this.m.Name = this.Const.Strings.FT.M42;
		this.m.Type = this.Const.EntityType.AlpShadow;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.OrcBerserker.XP;
		this.human.create();
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = null;
		this.m.HairColors = this.Const.HairColors.Old;
		this.m.Beards = null;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/military_standard_bearer_agent");
		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Flee);
		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Retreat);
		this.m.AIAgent.setActor(this);
	}

	function onInit()
	{
		this.human.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.Knight);
		b.IsSpecializedInPolearms = true;
		b.IsAffectedByLosingHitpoints = false;
		b.IsAffectedByFleeingAllies = false;
		b.IsAffectedByDyingAllies = false;
		b.Hitpoints += 400;
		b.MeleeSkill += -10;
		b.MeleeDefense += -10;
		b.Bravery += 500;
		b.Stamina += 200;
		b.FatigueRecoveryRate += 5;
		b.ActionPoints += 3;
		b.MovementAPCostAdditional += 1;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.setAppearance();
		this.getSprite("socket").setBrush("bust_base_military");
		this.m.Skills.add(this.new("scripts/skills/perks/perk_pathfinder"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_captain"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_brawny"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_inspiring_presence"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_steel_brow"));
		this.m.Skills.add(this.new("scripts/skills/actives/rotation"));
		this.m.Skills.add(this.new("scripts/skills/actives/rally_the_troops"));
		this.m.Skills.add(this.new("scripts/skills/actives/recover_skill"));
		this.getSprite("head").setBrush("bust_helmet_219");
		this.getSprite("body").setBrush("bust_body_28");
		this.getSprite("tattoo_body").setBrush("bust_militia_band_01");
		this.addSprite("surcoat").setBrush("surcoat_09");
	}

	function assignRandomEquipment()
	{
		local itt = this.new("scripts/items/armor/named/black_leather_armor");
		itt.m.ShowOnCharacter = false;
		itt.m.Condition = 400;
		itt.m.ConditionMax = itt.m.Condition;
		this.m.Items.equip(itt);
		itt = this.new("scripts/items/helmets/named/wolf_helmet");
		itt.m.ShowOnCharacter = false;
		itt.m.Condition = 400;
		itt.m.ConditionMax = itt.m.Condition;
		this.m.Items.equip(itt);
		itt = this.new("scripts/items/weapons/named/named_pike");
		itt.m.BlockedSlotType = null;
		itt.setVariant(3);
		this.m.Items.equip(itt);
		itt = this.new("scripts/items/shields/kite_shield");
		itt.setVariant(9);
		this.m.Items.equip(itt);
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

