this.legend_mummy_queen <- this.inherit("scripts/entity/tactical/legend_mummy", {
	m = {},
	function create()
	{
		this.m.Type = this.Const.EntityType.LegendMummyQueen;
		this.m.XP = this.Const.Tactical.Actor.LegendMummyQueen.XP;
		this.m.ResurrectionValue = 5.0;
		this.m.ResurrectWithScript = "scripts/entity/tactical/enemies/legend_mummy_queen";
		this.legend_mummy.create();
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/legend_mummy_queen_agent");
		this.m.AIAgent.setActor(this);
	}

	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.actor.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_killer == null || _killer.getFaction() == this.Const.Faction.Player || _killer.getFaction() == this.Const.Faction.PlayerAnimals)
		{
            local loot = this.new("scripts/items/loot/ancient_gold_coins_item");
            loot.drop(_tile);
            loot = this.new("scripts/items/loot/jeweled_crown_item");
            loot.drop(_tile);
			if (::mods_getRegisteredMod("mod_fantasybro") != null && this.Math.rand(1, 100) <= 3)
			{
                loot = this.new("scripts/items/misc/xxsbook");
                loot.drop(_tile);
			}
		}
	}

	function onInit()
	{
		this.legend_mummy.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.LegendMummyQueen);
		b.IsAffectedByNight = false;
		b.IsAffectedByInjuries = false;
		b.IsImmuneToBleeding = true;
		b.IsImmuneToDisarm = true;
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
		this.m.Skills.add(this.new("scripts/skills/perks/perk_hold_out"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_coup_de_grace"));
        this.m.Skills.add(this.new("scripts/skills/perks/perk_crippling_strikes"));
        this.m.Skills.add(this.new("scripts/skills/perks/perk_fast_adaption"));
        this.m.Skills.add(this.new("scripts/skills/perks/perk_underdog"));
        this.m.Skills.add(this.new("scripts/skills/perks/perk_berserk"));
        this.m.Skills.add(this.new("scripts/skills/special/double_grip"));
        this.m.Skills.add(this.new("scripts/skills/racial/vampire_racial"));
        this.m.Skills.add(this.new("scripts/skills/racial/alp_racial"));
        this.m.Skills.add(this.new("scripts/skills/actives/darkflight"));
        this.m.Skills.add(this.new("scripts/skills/perks/perk_anticipation"));
        this.m.Skills.add(this.new("scripts/skills/perks/perk_head_hunter"));
        this.m.Skills.add(this.new("scripts/skills/perks/perk_nine_lives"));
        this.m.Skills.add(this.new("scripts/skills/perks/perk_legend_bloodbath"));
        this.m.Skills.add(this.new("scripts/skills/perks/perk_legend_carnage"));

		if (this.World.getTime().Days >= 50)
		{
		    this.m.Skills.add(this.new("scripts/skills/perks/perk_battle_forged"));
		}

	}

	function assignRandomEquipment() {
        this.m.Items.equip(this.new("scripts/items/weapons/named/legend_named_royal_lance"));
        this.m.Items.equip(this.new("scripts/items/armor/ancient/legend_mummy_dress"));
        this.m.Items.equip(this.new("scripts/items/helmets/ancient/legend_mummy_crown"));
	}

});

