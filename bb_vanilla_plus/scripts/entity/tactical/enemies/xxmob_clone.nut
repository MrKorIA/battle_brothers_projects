this.xxmob_clone <- this.inherit("scripts/entity/tactical/human", {
	m = {
		Info = 0
	},
	function create()
	{
		this.m.Info = this.Math.rand(0, this.World.getPlayerRoster().getAll().len() - 1);
		local brothers = this.World.getPlayerRoster().getAll();
		local curbro = brothers[this.m.Info];
		this.m.Type = this.Const.EntityType.BountyHunter;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.BountyHunter.XP;
		this.human.create();
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.AllMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		if (curbro.hasRangedWeapon())
		{
			this.m.AIAgent = this.new("scripts/ai/tactical/agents/bounty_hunter_melee_agent");
			this.m.AIAgent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_handgonne"));
		}
		else
		{
			this.m.AIAgent = this.new("scripts/ai/tactical/agents/bounty_hunter_melee_agent");
		}

		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Flee);
		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Retreat);
		this.m.AIAgent.setActor(this);

		this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived] = [
			"sounds/enemies/vampire_hurt_01.wav", "sounds/enemies/vampire_hurt_02.wav", "sounds/enemies/vampire_hurt_03.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Death] = [
			"sounds/enemies/vampire_death_01.wav", "sounds/enemies/vampire_death_02.wav", "sounds/enemies/vampire_death_03.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.Idle] = [
			"sounds/enemies/vampire_idle_01.wav", "sounds/enemies/vampire_idle_02.wav", "sounds/enemies/vampire_idle_03.wav"
		];
		this.m.Sound[this.Const.Sound.ActorEvent.NoDamageReceived] = this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived];
		this.m.Sound[this.Const.Sound.ActorEvent.Flee] = this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived];
		this.m.Sound[this.Const.Sound.ActorEvent.Fatigue] = this.m.Sound[this.Const.Sound.ActorEvent.DamageReceived];
		this.getFlags().add("clone");
	}

	function onInit()
	{
		this.actor.onInit();
		local app = this.getItems().getAppearance();
		app.Quiver = this.Const.Items.Default.PlayerQuiver;
		app.Body = this.m.Bodies[this.m.Body];
		app.Corpse = this.m.Bodies[this.m.Body] + "_dead";
		this.addSprite("background");
		this.addSprite("socket").setBrush("bust_base_player");
		this.addSprite("quiver");
		this.addSprite("body");
		this.getSprite("body").setBrush(this.m.Bodies[this.m.Body]);
		this.addSprite("tattoo_body");
		local injury_body = this.addSprite("injury_body");
		injury_body.Visible = false;
		injury_body.setBrush("bust_naked_body_0" + this.m.Body + "_injured");
		this.addSprite("armor");
		local fakearmor = this.addSprite("fakearmor");
		fakearmor.Visible = false;
		this.addSprite("surcoat");
		this.addSprite("armor_upgrade_back");
		local fakearmor_upgrade_back = this.addSprite("fakearmor_upgrade_back");
		local bandage2 = this.addSprite("bandage_2");
		bandage2.Visible = false;
		local bandage3 = this.addSprite("bandage_3");
		bandage3.Visible = false;
		this.addSprite("shaft");
		this.addSprite("head");
		local eye_rings = this.addSprite("eye_rings");
		eye_rings.setBrush("bust_eye_rings");
		eye_rings.Visible = false;
		local closed_eyes = this.addSprite("closed_eyes");
		closed_eyes.setBrush("sleep_eyes");
		closed_eyes.Visible = false;
		this.addSprite("tattoo_head");
		this.addSprite("injury").Visible = false;
		this.addSprite("permanent_injury_3");
		this.addSprite("permanent_injury_2");
		local beard = this.addSprite("beard");
		local hair = this.addSprite("hair");
		this.addSprite("permanent_injury_4");
		this.addSprite("permanent_injury_1");
		this.addSprite("helmet");
		this.addSprite("helmet_damage");
		local fakehelmet = this.addSprite("fakehelmet");
		fakehelmet.Visible = false;
		local bandage1 = this.addSprite("bandage_1");
		bandage1.Visible = false;
		this.addSprite("accessory");
		this.addSprite("accessory_special");
		local beard_top = this.addSprite("beard_top");
		this.addSprite("armor_upgrade_front");
		local fakearmor_upgrade_front = this.addSprite("fakearmor_upgrade_front");
		local body_blood = this.addSprite("body_blood");
		body_blood.setBrush("bust_body_bloodied_02");
		body_blood.Visible = false;
		local body_dirt = this.addSprite("dirt");
		body_dirt.setBrush("bust_body_dirt_02");
		body_dirt.Visible = false;
		this.addDefaultStatusSprites();
		this.getSprite("status_rooted").Scale = 0.55;
		this.setSpriteOffset("status_rooted", this.createVec(0, 5));
		this.m.Skills.add(this.new("scripts/skills/actives/hand_to_hand"));
		if (this.Const.DLC.Unhold)
		{
			this.m.Skills.add(this.new("scripts/skills/actives/wake_ally_skill"));
		}
		this.m.Skills.add(this.new("scripts/skills/special/double_grip"));
		//
		this.m.Skills.add(this.new("scripts/skills/effects/dodge_effect"));
		local ska = this.new("scripts/skills/actives/ai_hand_upg");
		ska.setDamage(14);
		this.m.Skills.add(ska);
		ska = this.new("scripts/skills/actives/ai_norun");
		ska.m.ID = "effects.ai_norun2"
		this.m.Skills.add(ska);

		local brothers = this.World.getPlayerRoster().getAll();
		local curbro = brothers[this.m.Info];
		local b = this.m.BaseProperties;
		b.setValues(curbro.m.BaseProperties);
		local rr = this.Math.max(b.MeleeSkill, b.RangedSkill);
		b.MeleeSkill = this.Math.max(70, rr + this.Math.rand(1, 3));
		b.Initiative = this.Math.max(70, b.Initiative - 30);
		b.MeleeDefense = this.Math.max(10, b.MeleeDefense + this.Math.rand(1, 3));
		b.Hitpoints += 50 + b.Bravery;
		b.Stamina += 20;
		b.Bravery += 20;
		local BodyT = curbro.m.Items.getItemAtSlot(this.Const.ItemSlot.Body);
		if (BodyT != null)
		{
			b.Armor[this.Const.BodyPart.Body] += BodyT.getArmorMax();
			b.ArmorMax[this.Const.BodyPart.Body] += BodyT.getArmorMax();
		}
		local HeadT = curbro.m.Items.getItemAtSlot(this.Const.ItemSlot.Head);
		if (HeadT != null)
		{
			b.Armor[this.Const.BodyPart.Head] += HeadT.getArmorMax();
			b.ArmorMax[this.Const.BodyPart.Head] += HeadT.getArmorMax();
		}
		foreach( skill in curbro.getSkills().m.Skills )
		{
			if (skill.isType(this.Const.SkillType.Perk))
			{
				if (skill.m.ID == "perk.gifted" || skill.m.ID == "perk.student" || skill.m.ID == "perk.bags_and_belts") continue;
				local copy_perks = [
					"perk.fast_adaption", "perk.crippling_strikes", "perk.colossus", "perk.nine_lives", "perk.pathfinder", "perk.adrenaline",
					"perk.steel_brow", "perk.hold_out",
					"perk.backstabber", "perk.anticipation", "perk.shield_expert", "perk.relentless",
					"perk.mastery.axe", "perk.mastery.cleaver", "perk.mastery.dagger", "perk.mastery.flail", "perk.mastery.mace", "perk.mastery.polearm", "perk.mastery.spear", "perk.mastery.sword", "perk.mastery.hammer",
					"perk.reach_advantage", "perk.overwhelm", "perk.lone_wolf", "perk.underdog",
					"perk.berserk", "perk.head_hunter", "perk.battle_forged", "perk.nimble",
					"perk.fearsome", "perk.duelist", "perk.killing_frenzy"
				];

				if (copy_perks.find(skill.m.ID) != null)
				{
					this.m.Skills.add(this.new(this.IO.scriptFilenameByHash(skill.ClassNameHash)));
				}
				else
				{
					b.DamageTotalMult += 0.02;
					b.Hitpoints += 20;
				}
			}
		}
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.Name = curbro.m.Name + this.Const.Strings.FT.M19;
		//
		local sprites = [
			"body", "head", "beard", "hair", "tattoo_body", "tattoo_head", "beard_top",
			"permanent_injury_1", "permanent_injury_2", "permanent_injury_3", "permanent_injury_4"
		];
		foreach (s in sprites)
		{
			if (!curbro.hasSprite(s)) continue;
			local targetSprite = curbro.getSprite(s);
			local mySprite = this.getSprite(s);

			if (targetSprite.HasBrush)
			{
				mySprite.setBrush(targetSprite.getBrush().Name);
				mySprite.Color = targetSprite.Color;
				mySprite.Saturation = targetSprite.Saturation;
				mySprite.Scale = targetSprite.Scale;
				mySprite.Visible = targetSprite.Visible;
			}
			else
			{
				mySprite.setBrush("");
				mySprite.Visible = false;
			}
		}
		if (BodyT != null)
		{
			local targetArmor = curbro.getSprite("armor");
			fakearmor.setBrush(targetArmor.getBrush().Name);
			fakearmor.Color = targetArmor.Color;
			fakearmor.Saturation = targetArmor.Saturation;
			fakearmor.Visible = true;
			if (curbro.hasSprite("armor_upgrade_front") && curbro.getSprite("armor_upgrade_front").HasBrush)
			{
				local targetFront = curbro.getSprite("armor_upgrade_front");
				if (targetFront.HasBrush) 
				{
					fakearmor_upgrade_front.setBrush(targetFront.getBrush().Name);
					fakearmor_upgrade_front.Visible = true;
				}
			}
			else
			{
				fakearmor_upgrade_front.setBrush("");
				fakearmor_upgrade_front.Visible = false;
			}
			if (curbro.hasSprite("armor_upgrade_back") && curbro.getSprite("armor_upgrade_back").HasBrush)
			{
				local targetBack = curbro.getSprite("armor_upgrade_back");
				if (targetBack.HasBrush) 
				{
					fakearmor_upgrade_back.setBrush(targetBack.getBrush().Name);
					fakearmor_upgrade_back.Visible = true;
				}
			}
			else
			{
				fakearmor_upgrade_back.setBrush("");
				fakearmor_upgrade_back.Visible = false;
			}
			if (curbro.hasSprite("surcoat") && curbro.getSprite("surcoat").HasBrush)
			{
				local targetSurcoat = curbro.getSprite("surcoat");
				local mySurcoat = this.getSprite("surcoat");
				mySurcoat.setBrush(targetSurcoat.getBrush().Name);
				mySurcoat.Color = targetSurcoat.Color;
				mySurcoat.Saturation = targetSurcoat.Saturation;
				mySurcoat.Visible = true;
			}
			else
			{
				this.getSprite("surcoat").setBrush("");
				this.getSprite("surcoat").Visible = false;
			}
		}
		if (HeadT != null)
		{
			local targetHelmet = curbro.getSprite("helmet");
			fakehelmet.setBrush(targetHelmet.getBrush().Name);
			fakehelmet.Color = targetHelmet.Color;
			fakehelmet.Saturation = targetHelmet.Saturation;
			fakehelmet.Visible = true;
			if (HeadT.m.HideHair)
			{
				 this.getSprite("hair").setBrush("");
			}
			if (HeadT.m.HideBeard)
			{
				this.getSprite("beard").setBrush("");
				this.getSprite("beard_top").setBrush("");
			}
		}
		local eyes = this.addSprite("permanent_injury_5");
		eyes.setHorizontalFlipping(true);
		eyes.setBrush("zombie_rage_eyes");
		eyes.Visible = true;
		eyes.Color = this.createColor("#212121");
		eyes.Saturation = 0.1;
	}

	function onFactionChanged()
	{
		this.actor.onFactionChanged();
		local flip = !this.isAlliedWithPlayer();
		this.getSprite("background").setHorizontalFlipping(flip);
		this.getSprite("quiver").setHorizontalFlipping(flip);
		this.getSprite("body").setHorizontalFlipping(flip);
		this.getSprite("tattoo_body").setHorizontalFlipping(flip);
		this.getSprite("injury_body").setHorizontalFlipping(flip);
		this.getSprite("armor").setHorizontalFlipping(flip);
		this.getSprite("fakearmor").setHorizontalFlipping(flip);
		this.getSprite("surcoat").setHorizontalFlipping(flip);
		this.getSprite("fakearmor_upgrade_back").setHorizontalFlipping(flip);
		this.getSprite("fakearmor_upgrade_front").setHorizontalFlipping(flip);
		this.getSprite("shaft").setHorizontalFlipping(flip);
		this.getSprite("head").setHorizontalFlipping(flip);
		this.getSprite("closed_eyes").setHorizontalFlipping(flip);
		this.getSprite("eye_rings").setHorizontalFlipping(flip);
		this.getSprite("tattoo_head").setHorizontalFlipping(flip);
		this.getSprite("injury").setHorizontalFlipping(flip);
		this.getSprite("beard").setHorizontalFlipping(flip);
		this.getSprite("hair").setHorizontalFlipping(flip);
		this.getSprite("helmet").setHorizontalFlipping(flip);
		this.getSprite("helmet_damage").setHorizontalFlipping(flip);
		this.getSprite("fakehelmet").setHorizontalFlipping(flip);
		this.getSprite("beard_top").setHorizontalFlipping(flip);
		this.getSprite("body_blood").setHorizontalFlipping(flip);
		this.getSprite("accessory").setHorizontalFlipping(flip);
		this.getSprite("accessory_special").setHorizontalFlipping(flip);
		this.getSprite("dirt").setHorizontalFlipping(flip);
		this.getSprite("permanent_injury_1").setHorizontalFlipping(flip);
		this.getSprite("permanent_injury_2").setHorizontalFlipping(flip);
		this.getSprite("permanent_injury_3").setHorizontalFlipping(flip);
		this.getSprite("permanent_injury_4").setHorizontalFlipping(flip);
		this.getSprite("bandage_1").setHorizontalFlipping(flip);
		this.getSprite("bandage_2").setHorizontalFlipping(flip);
		this.getSprite("bandage_3").setHorizontalFlipping(flip);
	}

	function onUpdateInjuryLayer()
	{
		this.human.onUpdateInjuryLayer();
		local parts = [
			{
				sprite = "fakearmor",
				bodyPart = this.Const.BodyPart.Body
			},
			{
				sprite = "surcoat",
				bodyPart = this.Const.BodyPart.Body
			},
			{
				sprite = "fakehelmet",
				bodyPart = this.Const.BodyPart.Head
			}
		];
		foreach( p in parts )
		{
			if (!this.hasSprite(p.sprite)) continue;
			local s = this.getSprite(p.sprite);
			if (s.HasBrush)
			{
				local armorCurrent = this.getArmor(p.bodyPart);
				local armorMax = this.Math.max(1, this.getArmorMax(p.bodyPart));
				local armorPercent = armorCurrent.tofloat() / armorMax.tofloat();
				local baseName = s.getBrush().Name;
				if (armorPercent <= 0.5 && baseName.find("_damaged") == null)
				{
					s.setBrush(baseName + "_damaged");
				}
			}
		}
	}

	function assignRandomEquipment()
	{
		if (this.Math.rand(1, 25) == 10)
		{
			this.m.Items.addToBag(this.new("scripts/items/weapons/named/named_sword"));
		}
		local brothers = this.World.getPlayerRoster().getAll();
		local curbro = brothers[this.m.Info];
		local itemz = curbro.m.Items;
		for( local i = 0; i < this.Const.ItemSlot.COUNT; i = ++i )
		{
			for( local j = 0; j < this.Const.ItemSlotSpaces[i]; j = ++j )
			{
				local curitem = itemz.m.Items[i][j];
				if (curitem != null && curitem != -1 && 
				!curitem.isItemType(this.Const.Items.ItemType.Usable) && 
				!curitem.isItemType(this.Const.Items.ItemType.Misc) && 
				!curitem.isItemType(this.Const.Items.ItemType.Armor) && 
				!curitem.isItemType(this.Const.Items.ItemType.Helmet) &&
				curitem.getID() != "accessory.cursed_crystal_skull" &&
				curitem.getID() != "accessory.falcon")
				{
					local newitem = this.new(this.IO.scriptFilenameByHash(curitem.ClassNameHash));
					if (curitem.isItemType(this.Const.Items.ItemType.Weapon))
					{
						if ((curitem.isItemType(this.Const.Items.ItemType.MeleeWeapon) && curitem.m.Value < 890) || 
						curitem.isItemType(this.Const.Items.ItemType.RangedWeapon) ||						
						curitem.getID() == "weapon.xxringblade" || 
						curitem.getID() == "weapon.xxmstaff" || 
						curitem.getID() == "weapon.lute")
						{
							if (curitem.getBlockedSlotType() == this.Const.ItemSlot.Offhand)
							{
								local ww = [
									"weapons/named/named_crypt_cleaver",
									"weapons/named/named_warscythe",
									"weapons/named/named_swordlance",
									"weapons/named/named_warhammer",
									"weapons/named/named_billhook",
									"weapons/named/named_bladed_pike",
									"weapons/named/named_bardiche",
									"weapons/named/named_greataxe",
									"weapons/named/named_greatsword",
									"weapons/named/named_two_handed_hammer",
									"weapons/named/named_two_handed_mace",
									"weapons/named/named_two_handed_flail",
									"weapons/named/named_bardiche",
									"weapons/named/named_warbrand"
								];
								newitem = this.new("scripts/items/" + ww[this.Math.rand(0, ww.len() - 1)])
							}
							else
							{
								local ww = [
									"weapons/named/named_khopesh",
									"weapons/named/named_flail",
									"weapons/named/named_battle_whip",
									"weapons/named/named_dagger",
									"weapons/named/named_orc_cleaver",
									"weapons/named/named_orc_axe",
									"weapons/named/named_axe",
									"weapons/named/named_cleaver",
									"weapons/named/named_mace",
									"weapons/named/named_sword"
								];
								newitem = this.new("scripts/items/" + ww[this.Math.rand(0, ww.len() - 1)])
							}
						}
					}
					if (this.Const.ItemSlotSpaces[i] == 1)
					{
						this.m.Items.equip(newitem);
					}
					newitem.m.IsDroppedAsLoot = false
				}
			}
		}
		if (this.m.Items.getItemAtSlot(this.Const.ItemSlot.Accessory) != null)
		{
			if (this.m.Skills.hasSkill("actives.unleash_wardog") || this.m.Skills.hasSkill("actives.unleash_wolf"))
			{
				this.m.Items.unequip(this.m.Items.getItemAtSlot(this.Const.ItemSlot.Accessory));
			}
		}
		this.getSkills().update();
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (_tile != null)
		{
			local flip = this.Math.rand(0, 100) < 50;
			local decal = _tile.spawnDetail("desert_bones_01", this.Const.Tactical.DetailFlag.Corpse, flip, false);
			decal.Scale = 0.7;
			this.spawnTerrainDropdownEffect(_tile);
		}
		this.m.BloodType = this.Const.BloodType.Ash;
		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
	}
});

