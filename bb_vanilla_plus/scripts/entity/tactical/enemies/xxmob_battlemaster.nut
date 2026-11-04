this.xxmob_battlemaster <- this.inherit("scripts/entity/tactical/human", {
	m = {},
	function create()
	{
		this.m.Name = this.Const.Strings.FT.M11;
		this.m.Type = this.Const.EntityType.AlpShadow;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.OrcBerserker.XP;
		this.human.create();
		this.m.Faces = this.Const.Faces.SmartMale;
		this.m.Hairs = null;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = null;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/barbarian_melee_agent");
		this.m.AIAgent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_reap"));
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
		b.IsImmuneToStun = true;
		b.IsImmuneToDaze = true;
		b.IsImmuneToRoot = true;
		b.IsImmuneToRotation = true;
		b.IsImmuneToDisarm = true;
		b.IsImmuneToKnockBackAndGrab = true;
		b.IsImmuneToDamageReflection = true;
		b.FatigueReceivedPerHitMult = 0.0;
		b.IsSpecializedInSwords = true;
		b.IsSpecializedInAxes = true;
		b.IsSpecializedInMaces = true;
		b.IsSpecializedInFlails = true;
		b.IsSpecializedInPolearms = true;
		b.IsSpecializedInThrowing = true;
		b.IsSpecializedInHammers = true;
		b.IsSpecializedInSpears = true;
		b.IsSpecializedInCleavers = true;
		b.Vision += 1;
		b.Hitpoints += 100;
		b.MeleeSkill += 25;
		b.RangedSkill += 35;
		b.MeleeDefense += 20;
		b.RangedDefense += 10;
		b.Bravery += 80;
		b.Stamina += 150;
		b.Initiative += 10;
		local an = 300;
		b.Armor[this.Const.BodyPart.Head] += an;
		b.ArmorMax[this.Const.BodyPart.Head] += an;
		b.Armor[this.Const.BodyPart.Body] += an;
		b.ArmorMax[this.Const.BodyPart.Body] += an;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.setAppearance();
		this.addSprite("socket").setBrush("bust_base_beasts");
		this.m.Skills.add(this.new("scripts/skills/actives/recover_skill"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_quick_hands"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_duelist"));
		this.m.Skills.add(this.new("scripts/skills/traits/teamplayer_trait"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_nimble"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_battle_forged"));
		this.m.Skills.add(this.new("scripts/skills/traits/lucky_trait"));
		this.m.Skills.add(this.new("scripts/skills/traits/weasel_trait"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_hold_out"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_steel_brow"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_underdog"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_overwhelm"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_reach_advantage"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_backstabber"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_crippling_strikes"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_coup_de_grace"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_head_hunter"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_fearsome"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_berserk"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_battle_flow"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_killing_frenzy"));
		local xrota = this.new("scripts/skills/actives/barbarian_fury_skill");
		xrota.m.SoundOnUse = [
			"sounds/combat/rotation_01.wav"
		];
		xrota.m.Name = "Enhanced Rotation";
		xrota.m.Overlay = "perk_11_active";
		xrota.m.ActionPointCost = 2;
		xrota.m.FatigueCost = 1;
		this.m.Skills.add(xrota);
		local rrr = this.Math.rand(1, 16);
		local rrr_type;
		local xbody = this.getSprite("body");
		local xtattoo_body = this.getSprite("tattoo_body");
		local xscar_body = this.getSprite("scar_body");
		local xsurcoat = this.getSprite("surcoat")
		local xhead = this.getSprite("head");
		local xtattoo_head = this.getSprite("tattoo_head");
		local xbeard = this.getSprite("beard");
		local xhair = this.getSprite("hair");
		local xbeard_top = this.getSprite("beard_top");
		xtattoo_body.Visible = true;
		xtattoo_head.Visible = true;
		xbeard.Visible = true;
		xbeard_top.Visible = true;
		if (rrr == 1) // black naked
		{
			xhead.setBrush(this.Const.Faces.SouthernMale[this.Math.rand(0, this.Const.Faces.SouthernMale.len() - 1)]);
			xhead.Color = this.createColor("#999491");
			xhead.Saturation = 0.4;
			xbody.setBrush(this.Const.Bodies.SouthernSkinny[this.Math.rand(0, this.Const.Bodies.SouthernSkinny.len() - 1)]);
			xbody.Color = xhead.Color;
			xbody.Saturation = xhead.Saturation;
			if (this.Math.rand(1, 2) == 1)
			{
				xhair.setBrush("hair_black_southern_05");
			}
			else
			{
				xhair.setBrush("");
			}
			if (this.Math.rand(1, 2) == 1)
			{
				xtattoo_head.setBrush("tattoo_05_head");
				xtattoo_head.Saturation = 0.5;
				xtattoo_head.setBrightness(1.1);
				xbeard.setBrush("scar_02_head");
				xbeard.Saturation = 0.1;
				xbeard.setBrightness(1.5);
			}
			xtattoo_body.setBrush("tattoo_0" + this.Math.rand(4, 4) + "_" + actor.getSprite("body").getBrush().Name);
			xsurcoat.setBrush("bust_body_noble_10");
			xscar_body.setBrush("bust_body_southern_11");
			this.getSprite("shaft").setBrush("upgrade_25_front");
			this.getSprite("accessory_special").setBrush("bust_helmet_187");
			this.getSprite("accessory_special").Color = this.createColor("#fff200");
			this.getSprite("accessory_special").Saturation = 2.8;
			this.getSprite("accessory_special").setBrightness(5.7);
		}
		else	if (rrr == 2) // black armor
		{
			xhead.Color = this.createColor("#995c31");
			xhead.Saturation = 0.8;
			xhair.setBrush("helmet_desert_noble_03");
			xbody.setBrush("bust_body_southern_01");
			xtattoo_head.setBrush("warpaint_02_head");
		}
		else	if (rrr == 3 || rrr == 4) // yellow general
		{
			xhead.Color = this.createColor("#d6b074");
			xbody.setBrush("bust_body_39");
			if (this.Math.rand(1, 3) == 1)
			{
				xhair.setBrush("bust_helmet_199");
				xbeard.setBrush("bust_helmet_45");
			}
			else
			{
				xhair.setBrush("bust_helmet_204");
				rrr_type = [
					"beard_black_05",
					"beard_black_06",
					"beard_black_07",
					"beard_black_08",
					"beard_black_09"
				];
				rrr_type = rrr_type[this.Math.rand(0, rrr_type.len() - 1)]
				xbeard.setBrush(rrr_type);
			}
		}
		else	if (rrr == 5 || rrr == 6) // masked samurai
		{
			xhead.setBrush("bust_head_787" + this.Math.rand(6, 7));
			xhead.Color = this.createColor("#eb3131");
			rrr_type = [
				"beard_grey_02",
				"beard_grey_06",
				"beard_grey_10"
			];
			xtattoo_head.setBrush(rrr_type[this.Math.rand(0, rrr_type.len() - 1)]);
			xhair.setBrush("bust_helmet_xx03");
			xbody.setBrush("bust_body_100");
			xbody.Saturation = 1.3;
		}
		else	if (rrr == 7) // noble assasin
		{
			xhair.setBrush("bust_helmet_southern_10");
			xbeard.setBrush("bust_helmet_southern_07");
			xhead.setBrush("bust_head_southern_0" + this.Math.rand(1, 8));
			xbody.setBrush("bust_desert_noble_01");
			xtattoo_body.setBrush("bust_body_noble_01");
		}
		else	if (rrr == 8 || rrr == 9) // horn man
		{
			if (this.Math.rand(1, 2) == 1)
			{
				xhair.setBrush("bust_helmet_195");
				xbody.setBrush("bust_naked_body_01");
				xtattoo_body.setBrush("scar_01_bust_naked_body_01");
				if (this.Math.rand(1, 2) == 1)
				{
					xtattoo_head.setBrush("warpaint_01_head");
				}
				else
				{
					xtattoo_head.setBrush("scar_02_head");
				}
			}
			else
			{
				xbeard_top.setBrush("xxhorn_1");
				xtattoo_body.setBrush("tattoo_04_bust_naked_body_02");
				if (this.Math.rand(1, 2) == 1)
				{
					xtattoo_head.setBrush("warpaint_02_head");
					xbody.setBrush("bust_naked_body_02");
				}
				else
				{
					xtattoo_head.setBrush("scar_02_head");
					xtattoo_body.setBrush("scar_01_bust_naked_body_01");
				}
				rrr = this.Math.rand(0, 4)
				rrr_type = [
					"hair_blonde_09",
					"hair_brown_09",
					"hair_red_09",
					"hair_black_09",
					"hair_grey_09"
				];
				rrr_type = rrr_type[rrr];
				xhair.setBrush(rrr_type);
				rrr_type = [
					"hair_blonde_19",
					"hair_brown_19",
					"hair_red_19",
					"hair_black_19",
					"hair_grey_19"
				];
				rrr_type = rrr_type[rrr];
				xsurcoat.setBrush(rrr_type);
			}
			xscar_body.setBrush("scar_02_bust_naked_body_01");
		}
		else	if (rrr == 10) // horn viking
		{
			xbeard_top.setBrush("xxhorn_1");
			xhair.setBrush("bust_helmet_196");
			rrr_type = [
				"beard_blonde_12_top",
				"beard_blonde_17_top",
				"beard_red_12_top",
				"beard_red_17_top",
				"beard_brown_12_top",
				"beard_brown_17_top",
				"beard_black_12_top",
				"beard_black_17_top",
				"beard_grey_12_top",
				"beard_grey_17_top"
			];
			rrr_type = rrr_type[this.Math.rand(0, rrr_type.len() - 1)];
			xbeard.setBrush(rrr_type);
			xbody.setBrush("bust_body_96");
		}
		else	if (rrr == 11 || rrr == 12 || rrr == 13) // eastern general
		{
			xhead.Color = this.createColor("#d6b074");
			if (this.Math.rand(1, 2) == 1)
			{
				rrr_type = [
					"hair_black_8012",
					"hair_black_8015"
				];
				rrr_type = rrr_type[this.Math.rand(0, rrr_type.len() - 1)];
				xbeard.setBrush(rrr_type);
				rrr_type = [
					"bust_body_03",
					"bust_body_08"
				];
				rrr_type = rrr_type[this.Math.rand(0, rrr_type.len() - 1)];
				xbody.setBrush(rrr_type);
				if (this.Math.rand(1, 3) != 1)
				{
					xhair.setBrush("bust_xxhairband_99");
				}
				xtattoo_body.setBrush("xxcloth_101");
			}
			else
			{
				local rpp = this.Math.rand(0, 6)
				rrr_type = [
					"xxbeard_black_1000",
					"beard_black_06",
					"beard_black_07",
					"beard_black_08",
					"hair_black_8010",
					"beard_black_09",
					"beard_black_14_top"
				];
				rrr_type = rrr_type[rpp]
				xbeard.setBrush(rrr_type);
				rrr_type = [
					"bust_helmet_42",
					"hair_black_8010",
					"hair_black_8010",
					"bust_helmet_44",
					"bust_xxhairband_99",
					"hair_black_8010",
					"bust_helmet_44"
				];
				rrr_type = rrr_type[rpp]
				xhair.setBrush(rrr_type);
				rrr_type = [
					"xxcloth_100",
					"xxcloth_100",
					"xxcloth_102",
					"xxcloth_101",
					"xxcloth_101",
					"xxcloth_101",
					"xxcloth_101"
				];
				rrr_type = rrr_type[rpp]
				xtattoo_body.setBrush(rrr_type);
				rrr_type = [
					"bust_body_34",
					"bust_body_39",
				];
				rrr_type = rrr_type[this.Math.rand(0, rrr_type.len() - 1)];
				xbody.setBrush(rrr_type);
			}
		}
		else	if (rrr == 14) // masked wolfman
		{
			xhead.setBrush("bust_head_787" + this.Math.rand(4, 5));
			xhair.setBrush("bust_helmet_48");
			xbody.setBrush("bust_body_1" + this.Math.rand(6, 7));
		}
		else
		{
			if (this.Math.rand(0, 2) != 1)
			{
				local ht = this.Const.HairColors.All[this.Math.rand(0, this.Const.HairColors.All.len() - 1)];
				local bt = this.Const.Beards.All[this.Math.rand(0, 8)];
				xbeard.setBrush("beard_" + ht + "_" + bt);
			}
			local r = this.Math.rand(0, 6);
			rrr_type = [
				"bust_body_36",
				"bust_body_43",
				"bust_body_44",
				"bust_body_45",
				"bust_body_46",
				"bust_body_99",
				"bust_body_southern_named_02"
			];
			rrr_type = rrr_type[r];
			xbody.setBrush(rrr_type);
			rrr_type = [
				"bust_helmet_53",
				"bust_helmet_49",
				"bust_helmet_50",
				"bust_helmet_51",
				"bust_helmet_52",
				"bust_helmet_203",
				"bust_helmet_southern_named_02"
			];
			rrr_type = rrr_type[r];
			xhair.setBrush(rrr_type);
		}
	}

	function assignRandomEquipment()
	{
		local weapons = [
			"weapons/named/named_skullhammer",
			"weapons/named/named_two_handed_hammer",
			"weapons/named/named_two_handed_flail",
			"weapons/named/named_two_handed_mace",
			"weapons/named/named_two_handed_spiked_mace",
			"weapons/named/named_two_handed_scimitar",
			"weapons/named/named_crypt_cleaver",
			"weapons/named/named_rusty_warblade",
			"weapons/named/named_swordlance",
			"weapons/named/named_warscythe",
			"weapons/named/named_warbrand",
			"weapons/named/named_bardiche",
			"weapons/named/named_bardiche",
			"weapons/named/named_greatsword",
			"weapons/named/named_greatsword",
			"weapons/named/named_sword",
			"weapons/named/named_heavy_rusty_axe",
			"weapons/named/named_greataxe",
			"weapons/named/named_billhook",
			"weapons/named/named_pike",
			"weapons/named/named_spetum",
			"weapons/named/named_three_headed_flail",
			"weapons/named/named_khopesh",
			"weapons/named/named_goblin_falchion",
			"weapons/named/named_orc_cleaver",
			"weapons/named/named_orc_axe",
			"weapons/greenskins/orc_axe_2h"
		];
		this.m.Items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
		if (this.Math.rand(1, 100) <= 50)
		{
			weapons = [
				"weapons/named/named_throwing_axe",
				"weapons/named/named_javelin"
			];
			local r = this.Math.rand(0, weapons.len() - 1);
			this.m.Items.addToBag(this.new("scripts/items/" + weapons[r]));
			this.m.Items.addToBag(this.new("scripts/items/" + weapons[r]));
		}
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

