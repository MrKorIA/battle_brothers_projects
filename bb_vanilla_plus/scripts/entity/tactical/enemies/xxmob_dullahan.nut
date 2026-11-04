this.xxmob_dullahan <- this.inherit("scripts/entity/tactical/human", {
	m = {
		Info = null
	},
	function create()
	{
		this.m.Name = this.Const.Strings.FT.M30;
		this.m.Type = this.Const.EntityType.AlpShadow;
		this.m.BloodType = this.Const.BloodType.None;
		this.m.MoraleState = this.Const.MoraleState.Ignore;
		this.m.XP = this.Const.Tactical.Actor.OrcBerserker.XP;
		this.human.create();
		this.m.Faces = null;
		this.m.Hairs = null;
		this.m.HairColors = null;
		this.m.Beards = null;
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/zombie_hurt_01.wav",
			"sounds/enemies/zombie_hurt_02.wav",
			"sounds/enemies/zombie_hurt_03.wav",
			"sounds/enemies/zombie_hurt_04.wav",
			"sounds/enemies/zombie_hurt_05.wav",
			"sounds/enemies/zombie_hurt_06.wav",
			"sounds/enemies/zombie_hurt_07.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/zombie_death_01.wav",
			"sounds/enemies/zombie_death_02.wav",
			"sounds/enemies/zombie_death_03.wav",
			"sounds/enemies/zombie_death_04.wav",
			"sounds/enemies/zombie_death_05.wav",
			"sounds/enemies/zombie_death_06.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/zombie_idle_01.wav",
			"sounds/enemies/zombie_idle_02.wav",
			"sounds/enemies/zombie_idle_03.wav",
			"sounds/enemies/zombie_idle_04.wav",
			"sounds/enemies/zombie_idle_05.wav",
			"sounds/enemies/zombie_idle_06.wav",
			"sounds/enemies/zombie_idle_07.wav",
			"sounds/enemies/zombie_idle_08.wav",
			"sounds/enemies/zombie_idle_09.wav",
			"sounds/enemies/zombie_idle_10.wav",
			"sounds/enemies/zombie_idle_11.wav",
			"sounds/enemies/zombie_idle_12.wav",
			"sounds/enemies/zombie_idle_13.wav",
			"sounds/enemies/zombie_idle_14.wav",
			"sounds/enemies/zombie_idle_15.wav",
			"sounds/enemies/zombie_idle_16.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.NoDamageReceived] = this.m.Sound[this.Const.Sound.ActorEvent.Idle];
		this.getFlags().add("undead");
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/bounty_hunter_melee_agent");
		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Flee);
		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Retreat);
		this.m.AIAgent.setActor(this);
		this.m.ConfidentMoraleBrush = "icon_confident_orcs";
	}

	function onInit()
	{
		this.human.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.BanditPoacher);
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;
		b.IsImmuneToFire = true;
		b.IsSpecializedInSwords = true;
		b.IsSpecializedInAxes = true;
		b.IsSpecializedInMaces = true;
		b.IsSpecializedInFlails = true;
		b.IsSpecializedInThrowing = true;
		b.IsSpecializedInHammers = true;
		b.IsSpecializedInSpears = true;
		b.IsSpecializedInCleavers = true;
		b.IsAffectedByLosingHitpoints = false;
		b.IsAffectedByFleeingAllies = false;
		b.IsAffectedByDyingAllies = false;
		b.IsAffectedByFreshInjuries = false;
		b.IsAffectedByInjuries = false;
		b.IsAffectedByNight = false;
		b.Hitpoints += 145;
		b.Bravery += 100;
		b.Stamina += 200;
		b.MeleeSkill += 20;
		b.MeleeDefense += 5;
		b.Initiative += -50;
		b.Armor[this.Const.BodyPart.Body] += 200;
		b.ArmorMax[this.Const.BodyPart.Body] += 200;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.setAppearance();
		this.getSprite("socket").setBrush("bust_base_beasts");
		local xxtype = [
			"bust_body_48",
			"bust_body_51",
			"bust_body_54",
			"bust_body_57"
		];
		xxtype = xxtype[this.Math.rand(0, xxtype.len() - 1)]
		this.getSprite("body").setBrush(xxtype);
		this.getSprite("body").Color = this.createColor("#edeeff");
		this.getSprite("body").varySaturation(0.2);
		this.getSprite("body").varyColor(0.05, 0.05, 0.05);
		this.getSprite("injury_body").setBrush(this.getSprite("body").getBrush().Name + "_damaged");
		this.getSprite("head").setBrush("");
		this.getSprite("head").Scale = 0.9;
		this.getSprite("hair").setBrush("bust_ghosthead_" + this.Math.rand(1, 3));
		this.getSprite("hair").varySaturation(0.2);
		this.getSprite("hair").varyColor(0.05, 0.05, 0.05);
		this.setSpriteOffset("arms_icon", this.createVec(10, 0));
		this.setAlwaysApplySpriteOffset(true);
		this.m.Skills.add(this.new("scripts/skills/perks/perk_pathfinder"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_steel_brow"));
		this.m.Skills.add(this.new("scripts/skills/actives/ai_bonushit"));
	}

	function assignRandomEquipment()
	{
		local weapons = [
			"weapons/named/named_cleaver",
			"weapons/named/named_mace",
			"weapons/named/named_warhammer",
			"weapons/named/named_spear",
			"weapons/named/named_three_headed_flail",
			"weapons/named/named_sword",
			"weapons/named/named_flail",
			"weapons/named/named_axe"
		];
		this.m.Items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
		this.m.Items.equip(this.new("scripts/items/shields/named/xxmob_shield_elemental"));
		this.m.Items.addToBag(this.new("scripts/items/weapons/barbarians/heavy_javelin"));
		this.m.Items.addToBag(this.new("scripts/items/weapons/barbarians/heavy_throwing_axe"));
	}

	function onUpdateInjuryLayer()
	{
		local p = this.m.Hitpoints / this.getHitpointsMax();
		if (p < 0.3 && !this.m.Skills.hasSkill("perk.fearsome"))
		{
			local b = this.m.BaseProperties;
			this.m.Skills.add(this.new("scripts/skills/perks/perk_fearsome"));
			b.Armor[this.Const.BodyPart.Body] = 200;
			this.m.Hitpoints = this.getHitpointsMax();
			this.getSprite("injury_body").Visible = true;
			this.getSprite("head").setBrush("zombify_no_head");
			this.getSprite("hair").setBrush("bust_ghosthead_0");
		}
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (_tile != null)
		{
			this.m.BloodType = this.Const.BloodType.Ash;
			local flip = this.Math.rand(0, 100) < 50;
			this.m.IsCorpseFlipped = flip;
			local decal = _tile.spawnDetail("bust_naked_body_00_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.Scale = 0.95;
			decal.setBrightness(0.1);

			decal = _tile.spawnDetail(this.getSprite("body").getBrush().Name + "_dead", this.Const.Tactical.DetailFlag.Corpse, flip);
			decal.Color = this.getSprite("body").Color;
			decal.Saturation = this.getSprite("body").Saturation;
			decal.Scale = 0.9;
			this.spawnTerrainDropdownEffect(_tile);
			local corpse = clone this.Const.Corpse;
			corpse.Faction = this.getFaction();
			corpse.CorpseName = "A " + this.getName();
			corpse.Tile = _tile;
			corpse.Armor = this.m.BaseProperties.Armor;
			corpse.Items = this.getItems();
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

		this.m.Info = {
			Tile = this.getTile(),
			Faction = this.getFaction()
		};
		this.Sound.play("sounds/enemies/horrific_scream_01.wav", this.Const.Sound.Volume.Skill * 0.8, this.m.Info.Tile.Pos);
	}

	function onAfterDeath( _tile )
	{
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
		local e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/ghost", this.m.Info.Tile.Coords);
		e.setFaction(this.m.Info.Faction);
	}

});

