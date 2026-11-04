this.legend_mummy_medium <- this.inherit("scripts/entity/tactical/legend_mummy", {
	m = {
		IsRanged = false
	},
	function create()
	{
		this.m.IsRanged = this.Math.rand(1, 5) == 1 ? true : false;
		this.m.Type = this.Const.EntityType.LegendMummyMedium;
		this.m.XP = this.Const.Tactical.Actor.LegendMummyMedium.XP;
		this.m.ResurrectionValue = 4.0;
		this.m.ResurrectWithScript = "scripts/entity/tactical/enemies/legend_mummy_medium";
		this.legend_mummy.create();
		if (!this.m.IsRanged)
			this.m.AIAgent = this.new("scripts/ai/tactical/agents/skeleton_melee_agent");
		else
		{
			this.m.AIAgent = this.new("scripts/ai/tactical/agents/bandit_ranged_agent");
			this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Retreat);
			this.m.AIAgent.removeBehavior(this.Const.AI.Behavior.ID.Flee);
		}
		this.m.AIAgent.setActor(this);
	}

	function onInit()
	{
		this.legend_mummy.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.LegendMummyMedium);
		b.IsAffectedByNight = false;
		b.IsAffectedByInjuries = false;
		b.IsImmuneToBleeding = true;
		b.IsImmuneToPoison = true;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		this.m.FatigueCosts = this.Const.DefaultMovementFatigueCost;
		if (this.World.getTime().Days >= 50)
		{
            this.m.Skills.add(this.new("scripts/skills/perks/perk_shield_expert"));
		    this.m.Skills.add(this.new("scripts/skills/perks/perk_battle_forged"));
            this.m.Skills.add(this.new("scripts/skills/perks/perk_crippling_strikes"));
            this.m.Skills.add(this.new("scripts/skills/perks/perk_coup_de_grace"));
		}

	}

	function assignRandomEquipment()
	{
		if (!this.m.IsRanged)
		{
            local weapon = ::MSU.Class.WeightedContainer([
                [1, "scripts/items/weapons/ancient/broken_ancient_sword"],
                [1, "scripts/items/weapons/ancient/ancient_spear"],
                [1, "scripts/items/weapons/ancient/ancient_sword"],
                [1, "scripts/items/weapons/ancient/khopesh"]
            ]).roll();

            this.m.Items.equip(this.new(weapon));
		}
		else
		{
			this.m.Items.equip(this.new("scripts/items/weapons/legend_dilapitated_sling"));

            local weapon = ::MSU.Class.WeightedContainer([
                [1, "scripts/items/weapons/ancient/broken_ancient_sword"],
                [1, "scripts/items/weapons/ancient/ancient_spear"],
                [1, "scripts/items/weapons/ancient/ancient_sword"],
                [1, "scripts/items/weapons/ancient/khopesh"]
            ]).roll();

            this.m.Items.equip(this.new(weapon));
		}

        local shield = ::MSU.Class.WeightedContainer([
            [33, "scripts/items/shields/ancient/legend_mummy_shield"],
            [66, "scripts/items/shields/ancient/legend_mummy_tower_shield"]
        ]).roll();

        this.m.Items.equip(this.new(shield));

        local armor = ::MSU.Class.WeightedContainer([
            [1, "scripts/items/armor/ancient/legend_mummy_bandages"],
            [1, "scripts/items/armor/ancient/legend_mummy_plate"]
        ]).roll();

        this.m.Items.equip(this.new(armor));

        local rand = this.Math.rand(1, 4);
        if (rand <= 3)
        {
            this.m.Items.equip(this.new("scripts/items/helmets/ancient/legend_mummy_bandage"));
        }

	}

});

