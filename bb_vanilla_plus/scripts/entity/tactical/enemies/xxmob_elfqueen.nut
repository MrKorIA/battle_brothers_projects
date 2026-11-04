this.xxmob_elfqueen <- this.inherit("scripts/entity/tactical/human", {
	m = {},
	function create()
	{
		this.m.Name = this.Const.Strings.FT.M32;
		this.m.Type = this.Const.EntityType.AlpShadow;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.OrcBerserker.XP;
		this.human.create();
		this.m.Faces = this.Const.Faces.SmartMale;
		this.m.Hairs = null;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = null;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/bounty_hunter_ranged_agent");
		this.m.AIAgent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_split"));
		this.m.AIAgent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_swing"));
		this.m.AIAgent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_adrenaline"));
		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Flee);
		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Retreat);
		this.m.AIAgent.setActor(this);
		this.m.ConfidentMoraleBrush = "icon_confident_orcs";
		this.m.Sound[this.Const.Sound.ActorEvent.NoDamageReceived] = [
			"sounds/enemies/ghost_death_01.wav",
			"sounds/enemies/ghost_death_02.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/ghost_death_01.wav",
			"sounds/enemies/ghost_death_02.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/ghost_death_01.wav",
			"sounds/enemies/ghost_death_02.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Flee] = [
			"sounds/enemies/ghastly_touch_01.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Fatigue] = [
			"sounds/enemies/ghastly_touch_01.wav"
		];
	}

	function onInit()
	{
		this.human.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.BanditPoacher);
		b.IsSpecializedInBows = true;
		b.IsAffectedByNight = false;
		b.Hitpoints += 345;
		b.MeleeSkill += 50;
		b.RangedSkill += 40;
		b.MeleeDefense += 30;
		b.RangedDefense += 30;
		b.Bravery += 500;
		b.Stamina += 500;
		b.Initiative += 50;
		b.Vision += 5;
		b.RangedAttackBlockedChanceMult *= 0;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.setAppearance();
		this.getSprite("socket").setBrush("bust_base_beasts");
		this.m.Skills.add(this.new("scripts/skills/perks/perk_bullseye"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_quick_hands"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_crippling_strikes"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_coup_de_grace"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_relentless"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_fast_adaption"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_overwhelm"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_pathfinder"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_nimble"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_fearsome"));
		this.m.Skills.add(this.new("scripts/skills/actives/rotation"));
		this.m.Skills.add(this.new("scripts/skills/actives/recover_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/adrenaline_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/ai_noteamkill"));
		local xhead = this.getSprite("head");
		local xbody = this.getSprite("body");
		local xhair = this.getSprite("hair");
		local xbeard = this.getSprite("beard");
		local tattoo_head = this.getSprite("tattoo_head");
		local peye = this.getSprite("permanent_injury_4");
		local aarm = this.getSprite("armor_upgrade_back");
		local barm = this.getSprite("armor_upgrade_front");
		xhair.setBrush("hair_elf_0" + this.Math.rand(4, 5));
		xhead.setBrush("bust_head_78" + this.Math.rand(68, 71));
		xbody.setBrush("bust_naked_body_7870");
		xhead.Saturation = 0.7;
		xbody.Saturation = xhead.Saturation;
		xhair.Saturation = xhead.Saturation;
		tattoo_head.setBrush("tattoo_02_head");
		tattoo_head.Visible = true;
		tattoo_head.Saturation = 0.1;
		xbeard.setBrush("bust_helmet_188");
		xbeard.Visible = true;
		xbeard.Color = this.createColor("#d9ff00");
		xbeard.Saturation = 2.8;
		this.setSpriteOffset("beard", this.createVec(0, 0.5));
		peye.setBrush("zombie_rage_eyes");
		peye.Visible = true;
		peye.Color = this.createColor("#ffffff");
		peye.Saturation = 0.3;
		this.setSpriteOffset("permanent_injury_4", this.createVec(0.5, -1.5));
		aarm.Scale = 0.9;
		barm.Scale = 0.9;
		aarm.Color = this.createColor("#404f1d");
		barm.Color = aarm.Color;
		this.setAlwaysApplySpriteOffset(true);
	}

	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.actor.onAppearanceChanged(_appearance, false);
		this.setDirty(true);
	}

	function assignRandomEquipment()
	{
		local itt = this.new("scripts/items/weapons/war_bow");
		local weapons = [
			"icon_composite_bow_01",
			"icon_goblin_bow_02_named_01",
			"icon_named_bow_01",
			"icon_named_bow_02",
			"icon_named_bow_03",
			"icon_war_bow",
			"icon_goblin_bow_01",
			"icon_goblin_bow_02",
			"icon_event_bow_01",
			"icon_event_bow_02",
			"icon_short_bow",
			"icon_hunting_bow",
			"icon_hunting_bow",
			"icon_hunting_bow",
			"icon_hunting_bow",
			"icon_hunting_bow"
		];
		itt.m.ArmamentIcon = weapons[this.Math.rand(0, weapons.len() - 1)];
		itt.m.RegularDamage = 60;
		itt.m.RegularDamageMax = 80;
		itt.m.DirectDamageMult = 0.4;
		this.m.Items.equip(itt);
		local uu = this.new("scripts/items/armor_upgrades/unhold_fur_upgrade");
		itt = this.new("scripts/items/armor/named/named_sellswords_armor");
		if (this.Math.rand(1, 2) == 1)
		{
			itt.setVariant(82);
		}
		itt.setUpgrade(uu);
		itt.m.StaminaModifier = -1;
		this.m.Items.equip(itt);
		this.m.Items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
		this.m.Items.equip(this.new("scripts/items/accessory/goblin_trophy_item"));
		this.m.Items.addToBag(this.new("scripts/items/weapons/longsword"));
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

