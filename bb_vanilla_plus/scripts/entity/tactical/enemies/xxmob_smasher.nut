this.xxmob_smasher <- this.inherit("scripts/entity/tactical/human", {
	m = {},
	function create()
	{
		this.m.Name = this.Const.Strings.FT.M65;
		this.m.Type = this.Const.EntityType.AlpShadow;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.BanditPoacher.XP;
		this.human.create();
		this.m.Faces = this.Const.Faces.WildMale;
		this.m.Hairs = null;
		this.m.HairColors = this.Const.HairColors.SouthernYoung;
		this.m.Beards = this.Const.Beards.WildExtended;
		this.m.BeardChance = 100;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/bounty_hunter_melee_agent");
		this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Retreat);
		this.m.AIAgent.setActor(this);
	}

	function onInit()
	{
		this.human.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.BanditPoacher);
		if (!this.Tactical.State.isScenarioMode() && this.World.getTime().Days >= 155)
		{
			b.DamageTotalMult += 0.1;
			b.MeleeSkill += 15;
		}
		else
		{
			b.MeleeSkill += 5;
		}
		b.Hitpoints += 145;
		b.MeleeDefense += 5;
		b.RangedDefense += 5;
		b.Bravery += 30;
		b.Stamina += 50;
		b.Initiative += -40;
		b.FatigueRecoveryRate += 7;
		b.DamageAgainstMult[this.Const.BodyPart.Head] += 1;
		b.IsImmuneToStun = true;
		b.IsImmuneToDaze = true;
		b.IsImmuneToRoot = true;
		b.IsImmuneToKnockBackAndGrab = true;
		b.IsSpecializedInHammers = true;
		b.IsSpecializedInShields = true;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.setAppearance();
		this.addSprite("socket").setBrush("bust_base_beasts");
		local armor = this.getSprite("armor");
		local helmet = this.getSprite("helmet");
		local tattoo_body = this.getSprite("tattoo_body");
		local tattoo_head = this.getSprite("tattoo_head");
		this.getSprite("hair").setBrush("hair_beast_0" + this.Math.rand(1, 3));
		local pp = this.Math.rand(1, 3);
		if (pp == 1)
		{
			tattoo_body.setBrush("tattoo_0" + this.Math.rand(2, 4) + "_bust_naked_body_02");
			tattoo_head.setBrush("tattoo_01_head");
			tattoo_body.Visible = true;
			tattoo_head.Visible = true;
		}
		else if (pp == 2)
		{
			tattoo_body.setBrush("warpaint_01_bust_naked_body_02");
			tattoo_head.setBrush("warpaint_01_head");
			tattoo_body.Visible = true;
			tattoo_head.Visible = true;
		}
		if (this.Math.rand(1, 3) == 2)
		{
			this.getSprite("beard").setBrush("beard_brown_08");
			this.getSprite("beard_top").setBrush("");
		}
		armor.varySaturation(0.2);
		armor.varyColor(0.02, 0.02, 0.02);
		helmet.Saturation = armor.Saturation;
		helmet.Color = armor.Color;
		this.m.Skills.add(this.new("scripts/skills/actives/recover_skill"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_duelist"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_hold_out"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_steel_brow"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_underdog"));
		this.m.Skills.add(this.new("scripts/skills/actives/ai_bonushit"));
	}

	function assignRandomEquipment()
	{
		local w = [
			"weapons/named/named_warhammer",
			"weapons/warhammer",
			"weapons/warhammer"
		];
		w = this.new("scripts/items/" + w[this.Math.rand(0, w.len() - 1)]);
		w.m.IsDroppedAsLoot = false;
		this.m.Items.equip(w);
		w = [
			"armor/barbarians/rugged_scale_armor",
			"armor/barbarians/heavy_iron_armor",
			"armor/barbarians/thick_plated_barbarian_armor",
			"armor/barbarians/thick_plated_barbarian_armor"
		];
		w = this.new("scripts/items/" + w[this.Math.rand(0, w.len() - 1)]);
		w.m.IsDroppedAsLoot = false;
		this.m.Items.equip(w);
		w = this.new("scripts/items/shields/wooden_shield");
		w.setVariant(this.Math.rand(1, 2));
		this.m.Items.equip(w);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		if (_killer == null || _killer.getFaction() == this.Const.Faction.Player || _killer.getFaction() == this.Const.Faction.PlayerAnimals)
		{
			local loot;
			if (this.Math.rand(1, 100) <= 20)
			{
				loot = this.new("scripts/items/loot/growth_pearls_item");
				loot.drop(_tile);
			}
		}
		this.human.onDeath(_killer, _skill, _tile, _fatalityType);
	}

});

