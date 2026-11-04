this.legend_mummy_heavy <- this.inherit("scripts/entity/tactical/legend_mummy", {
	m = {},
	function create()
	{
		this.m.Type = this.Const.EntityType.LegendMummyHeavy;
		this.m.XP = this.Const.Tactical.Actor.LegendMummyHeavy.XP;
		this.m.ResurrectionValue = 5.0;
		this.m.ResurrectWithScript = "scripts/entity/tactical/enemies/legend_mummy_heavy";
		this.legend_mummy.create();
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/skeleton_melee_agent");
		this.m.AIAgent.setActor(this);
	}

	function onInit()
	{
		this.legend_mummy.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.LegendMummyHeavy);
		b.Initiative -= 20;
		b.IsAffectedByNight = false;
		b.IsAffectedByInjuries = false;
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;

		if (!this.Tactical.State.isScenarioMode() && this.World.getTime().Days >= 100)
		{
			b.IsSpecializedInPolearms = true;
		}

		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		this.m.Skills.add(this.new("scripts/skills/perks/perk_reach_advantage"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_coup_de_grace"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_crippling_strikes"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_fast_adaption"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_legend_bloodbath"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_legend_carnage"));
		if (this.World.getTime().Days >= 50)
		{
            this.m.Skills.add(this.new("scripts/skills/perks/perk_battle_forged"));
            this.m.Skills.add(this.new("scripts/skills/perks/perk_crippling_strikes"));
            this.m.Skills.add(this.new("scripts/skills/perks/perk_coup_de_grace"));
		}

	}

	function assignRandomEquipment()
	{
        local weapon = ::MSU.Class.WeightedContainer([
            [1, "scripts/items/weapons/ancient/legend_fan_axe"],
            [1, "scripts/items/weapons/ancient/crypt_cleaver"],
            [1, "scripts/items/weapons/ancient/bladed_pike"],
            [1, "scripts/items/weapons/ancient/legend_great_khopesh"],
            [1, "scripts/items/weapons/ancient/rhomphaia"],
            [1, "scripts/items/weapons/ancient/legend_royal_lance"]
        ]).roll();

        this.m.Items.equip(::new(weapon));

		if (this.m.Items.hasEmptySlot(::Const.ItemSlot.Head))
		{
            local helmet = ::MSU.Class.WeightedContainer([
                [2, "scripts/items/helmets/ancient/ancient_wig"],
                [5, "scripts/items/helmets/ancient/legend_mummy_headband"],
                [1, "scripts/items/helmets/ancient/legend_mummy_crown_king"]
            ]).roll();

			this.m.Items.equip(::new(helmet));
		}

		if (this.m.Items.hasEmptySlot(::Const.ItemSlot.Body))
		{
            local armor = ::MSU.Class.WeightedContainer([
                [1, "scripts/items/armor/ancient/legend_mummy_bandages"],
                [4, "scripts/items/armor/ancient/legend_mummy_royal_plate"]
            ]).roll();

			this.m.Items.equip(::new(armor));
		}

	}

	function makeMiniboss()
	{
		if (!this.actor.makeMiniboss())
			return false;

        local weapon = ::MSU.Class.WeightedContainer([
            [1, "scripts/items/weapons/named/legend_named_gladius"],
            [1, "scripts/items/weapons/named/named_crypt_cleaver"],
            [1, "scripts/items/weapons/named/named_khopesh"],
            [1, "scripts/items/weapons/named/legend_named_great_khopesh"],
            [1, "scripts/items/weapons/named/named_warscythe"],
            [1, "scripts/items/weapons/named/legend_named_royal_lance"],
            [1, "scripts/items/weapons/named/named_bladed_pike"]
        ]).roll();

        this.m.Items.equip(::new(weapon));

		this.getSkills().add(this.new("scripts/skills/perks/perk_legend_forceful_swing"));
		this.getSkills().add(this.new("scripts/skills/perks/perk_legend_smackdown"));
		this.getSkills().add(this.new("scripts/skills/perks/perk_underdog"));
	}

});

