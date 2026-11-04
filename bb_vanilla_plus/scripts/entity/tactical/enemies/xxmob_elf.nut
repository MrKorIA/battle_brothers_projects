this.xxmob_elf <- this.inherit("scripts/entity/tactical/human", {
	m = {},
	function create()
	{
		this.m.Name = this.Const.Strings.FT.M31;
		this.m.Type = this.Const.EntityType.AlpShadow;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.BanditPoacher.XP;
		this.human.create();
		this.m.Faces = this.Const.Faces.SmartMale;
		this.m.Hairs = null;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = null;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/bounty_hunter_ranged_agent");
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
		b.Hitpoints += 45;
		b.MeleeSkill += 15;
		b.RangedSkill += 20;
		b.MeleeDefense += 15;
		b.RangedDefense += 10;
		b.Bravery += 30;
		b.Stamina += 50;
		b.Initiative += 50;
		b.Vision += 5;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.setAppearance();
		this.getSprite("socket").setBrush("bust_base_beasts");
		this.m.Skills.add(this.new("scripts/skills/perks/perk_fast_adaption"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_pathfinder"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_nimble"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_bullseye"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_quick_hands"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_duelist"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_crippling_strikes"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_coup_de_grace"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_relentless"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_overwhelm"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_fearsome"));
		this.m.Skills.add(this.new("scripts/skills/actives/rotation"));
		this.m.Skills.add(this.new("scripts/skills/actives/recover_skill"));
		this.m.Skills.add(this.new("scripts/skills/actives/ai_noteamkill"));
		local xhead = this.getSprite("head");
		local xbody = this.getSprite("body");
		local xhair = this.getSprite("hair");
		local xear = this.getSprite("accessory_special");
		local tattoo_body = this.getSprite("tattoo_body");
		local tattoo_head = this.getSprite("tattoo_head");
		local xsurcoat = this.getSprite("surcoat");
		xhead.setBrush("bust_head_78" + this.Math.rand(68, 71));
		xbody.setBrush("bust_naked_body_78" + this.Math.rand(69, 70));
		xear.setBrush("ear_elf");
		local hair_type = [
			"10",
			"19",
			"21",
			"southern_03"
		];
		xhair.setBrush("hair_blonde_" + hair_type[this.Math.rand(0, hair_type.len() - 1)]);
		xhair.Color = this.createColor("#fff28f");
		xhair.varyColor(0.05, 0.05, 0.05);
		local pp = this.Math.rand(1, 3)
		if (pp == 1)
		{
			tattoo_body.setBrush("warpaint_01_bust_naked_body_02");
			tattoo_body.Visible = true;
			tattoo_head.setBrush("warpaint_01_head");
			tattoo_head.Visible = true;
		}
		else if (pp == 2)
		{
			tattoo_body.setBrush("tattoo_02_bust_naked_body_02");
			tattoo_body.Visible = true;
			tattoo_head.setBrush("tattoo_02_head");
			tattoo_head.Visible = true;
		}
		tattoo_body.Scale = 0.85;
		local itt = [
			"#89bf75",
			"#9bbf75",
			"#7da84f",
			"#88ad31",
			"#7a5f3a",
			"#8c6e4c",
			"#ffffff"
		];
		this.getSprite("surcoat").Color = this.createColor(itt[this.Math.rand(0, itt.len() - 1)]);
		itt = [
			"bust_body_01",
			"bust_body_02",
			"bust_body_18"
		];
		xsurcoat.setBrush(itt[this.Math.rand(0, itt.len() - 1)]);
		xsurcoat.Scale = 0.92;
		xsurcoat.Visible = true;
		if (this.Math.rand(1, 5) == 2)
		{
			if (!tattoo_body.HasBrush)
			{
				tattoo_body.setBrush("tattoo_02_bust_naked_body_02");
				tattoo_body.Visible = true;
				tattoo_head.setBrush("warpaint_01_head");
				tattoo_head.Visible = true;
			}
			xbody.Color = this.createColor("#75bf81");
			xhead.Color = xbody.Color;
			xhair.Color = xbody.Color;
			xear.Color = xbody.Color;
			this.m.Skills.add(this.new("scripts/skills/perks/perk_nine_lives"));
			this.m.Skills.add(this.new("scripts/skills/effects/dodge_effect"));
			this.getSprite("surcoat").setBrush("");
			this.setName("Sylvan Elf");
		}
		b.Armor[this.Const.BodyPart.Body] += 20;
		b.ArmorMax[this.Const.BodyPart.Body] += 20;
	}

	function onUpdateInjuryLayer()
	{
		local injury = this.getSprite("injury");
		local injury_body = this.getSprite("injury_body");
		local xsurcoat = this.getSprite("surcoat");
		local p = this.m.Hitpoints / this.getHitpointsMax();
		if (p > 0.66)
		{
			this.setDirty(this.m.IsDirty || injury.Visible || injury_body.Visible);
			injury.Visible = false;
			injury_body.Visible = false;
		}
		else
		{
			this.setDirty(this.m.IsDirty || !injury.Visible || !injury_body.Visible);
			injury.Visible = true;
			injury_body.Visible = true;
			if (p > 0.33)
			{
				injury.setBrush("bust_head_injured_01");
			}
			else
			{
				injury.setBrush("bust_head_injured_02");
			}

			if (p > 0.4)
			{
				injury_body.Visible = false;
			}
			else
			{
				injury_body.Visible = true;
			}

			if (xsurcoat.HasBrush && this.doesBrushExist(xsurcoat.getBrush().Name + "_damaged"))
			{
				xsurcoat.setBrush(xsurcoat.getBrush().Name + "_damaged")
			}
		}
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
		itt.m.RegularDamage = this.Math.rand(40, 50);
		itt.m.RegularDamageMax = this.Math.rand(60, 75);
		itt.m.DirectDamageMult = 0.3;
		this.m.Items.equip(itt);
		itt = this.new("scripts/items/weapons/greenskins/goblin_notched_blade");
		weapons = [
			"icon_obsidian_dagger",
			"icon_goblin_weapon_02_named_01"
		];
		itt.m.ArmamentIcon = weapons[this.Math.rand(0, weapons.len() - 1)];
		this.m.Items.addToBag(itt);
		this.m.Items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
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
		if (_killer == null || _killer.getFaction() == this.Const.Faction.Player || _killer.getFaction() == this.Const.Faction.PlayerAnimals)
		{
			local loot;
			if (this.Math.rand(1, 100) <= 20)
			{
				loot = this.new("scripts/items/loot/growth_pearls_item");
				loot.drop(_tile);
			}
		}
		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}

});

