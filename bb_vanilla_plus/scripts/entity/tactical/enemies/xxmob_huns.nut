this.xxmob_huns <- this.inherit("scripts/entity/tactical/human", {
	m = {},
	function create()
	{
		this.m.Name = this.Const.Strings.FT.M46;
		this.m.Type = this.Const.EntityType.AlpShadow;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.BanditPoacher.XP;
		this.human.create();
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = null;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = null;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/goblin_melee_agent");
		this.m.AIAgent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_bow"));
		this.m.AIAgent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_engage_ranged"));
		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Retreat);
		this.m.AIAgent.setActor(this);
	}

	function onInit()
	{
		this.human.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.BanditPoacher);
		b.IsSpecializedInSwords = true;
		b.IsSpecializedInAxes = true;
		b.IsSpecializedInMaces = true;
		b.IsSpecializedInFlails = true;
		b.IsSpecializedInPolearms = true;
		b.IsSpecializedInThrowing = true;
		b.IsSpecializedInHammers = true;
		b.IsSpecializedInSpears = true;
		b.IsSpecializedInCleavers = true;
		b.DamageTotalMult += 0.1;
		b.DamageReceivedArmorMult *= 0.8;
		b.FatigueDealtPerHitMult *= 1.5;
		b.Hitpoints += 100;
		b.MeleeSkill += this.Math.rand(10, 20);
		b.RangedSkill += this.Math.rand(10, 20);
		b.MeleeDefense += 7;
		b.RangedDefense += 1;
		b.Bravery += 30;
		b.Stamina += 50;
		b.Initiative += 120;
		b.Vision += 3;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.setAppearance();
		this.getSprite("socket").setBrush("bust_base_beasts");
		local rrr_type;
		rrr_type = [
			"",
			"",
			"beard_black_02",
			"beard_black_03",
			"beard_black_04",
			"beard_black_05",
			"beard_black_06",
			"beard_black_07",
			"beard_black_09",
			"beard_black_10",
			"beard_black_11",
			"beard_black_16"
		];
		rrr_type = rrr_type[this.Math.rand(0, rrr_type.len() - 1)]
		this.getSprite("beard").setBrush(rrr_type);

		rrr_type = [
			"",
			"hair_black_09",
			"hair_black_11",
			"hair_black_12",
			"hair_black_8001",
			"hair_black_8000",
			"hair_black_8000"
		];
		rrr_type = rrr_type[this.Math.rand(0, rrr_type.len() - 1)]
		this.getSprite("hair").setBrush(rrr_type);

		this.getSprite("head").Color = this.createColor("#d6b074");
		this.getSprite("body").Color = this.getSprite("head").Color;
		this.m.Skills.add(this.new("scripts/skills/actives/recover_skill"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_quick_hands"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_pathfinder"));
		this.m.Skills.add(this.new("scripts/skills//actives/ai_damaged_move"));
		this.m.Skills.add(this.new("scripts/skills/actives/ai_bonushit"));
		local bh = this.new("scripts/skills/actives/footwork");
		bh.m.ActionPointCost = 2;
		this.m.Skills.add(bh);
	}

	function assignRandomEquipment()
	{
		if (this.Math.rand(1, 3) == 3)
		{
			this.m.Items.equip(this.new("scripts/items/helmets/xxhat_hunshat"));
		}
		this.m.Items.equip(this.new("scripts/items/weapons/named/xx_mob_hunsbow"));
		this.m.Items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
		local w = this.new("scripts/items/weapons/boar_spear");
		w.m.IsDroppedAsLoot = false;
		this.m.Items.addToBag(w);
		w = [
			"armor/sackcloth",
			"armor/leather_wraps",
			"armor/ragged_surcoat",
			"armor/padded_surcoat",
			"armor/blotched_gambeson",
			"armor/worn_mail_shirt"
		];
		w = this.new("scripts/items/" + w[this.Math.rand(0, w.len() - 1)]);
		w.m.IsDroppedAsLoot = false;
		this.m.Items.equip(w);
		if (this.Math.rand(1, 2) == 2)
		{
			if (this.Math.rand(1, 2) == 2)
			{
				this.getSprite("surcoat").setBrush("bust_body_90");
			}
			else
			{
				this.getSprite("surcoat").setBrush("bust_body_91");
			}

		}
		w = this.new("scripts/items/shields/xxhorse_shield");
		w.m.IsDroppedAsLoot = false;
		this.m.Items.equip(w);
	}

	function onUpdate()
	{
		this.actor.onUpdate();
		if (!this.m.Skills.hasSkill("effects.xxitem_horse_skill") && this.m.Skills.hasSkill("effects.ai_damaged_move"))
		{
			this.m.Skills.removeByID("effects.ai_damaged_move");
		}
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (_killer == null || _killer.getFaction() == this.Const.Faction.Player || _killer.getFaction() == this.Const.Faction.PlayerAnimals)
		{
			if (this.Math.rand(1, 100) <= 20)
			{
				local loot = this.new("scripts/items/loot/growth_pearls_item");
				loot.drop(_tile);
			}
		}
		this.human.onDeath(_killer, _skill, _tile, _fatalityType);
	}

});

