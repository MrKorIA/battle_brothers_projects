//bannerman, buffs the others to keep their morale up, is in every cultist party
this.mod_cultist_high_priest <- this.inherit("scripts/entity/tactical/cultist/mod_cultist_priest", {
	m = {
	},
	function create()
	{
		this.m.Type = this.Const.EntityType.Cultist_High_Priest;
		this.m.XP = this.Const.Tactical.Actor.Cultist_High_Priest.XP;
		this.mod_cultist_priest.create()
		this.m.AIAgent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_summon_reinforcements"))
		this.m.AIAgent.m.Properties.BehaviorMult[this.Const.AI.Behavior.ID.EngageMelee] = 0.0
	}

	function onInit()
	{
		this.mod_cultist_priest.onInit()
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.Cultist_High_Priest);
		b.TargetAttractionMult = 3.0;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;

		this.m.Skills.add(this.new("scripts/skills/perks/perk_battle_forged"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_fearsome"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_nimble"));	
		this.m.Skills.add(this.new("scripts/skills/perks/perk_nine_lives"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_killing_frenzy"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_berserk"));

		this.m.Skills.add(this.new("scripts/skills/actives/summon_reinforcements_skill"));
	}
	function assignRandomEquipment()
	{
		local banner = 13;
		local weapon = this.new("scripts/items/tools/player_banner");
		weapon.setVariant(banner);
		weapon.m.IsDroppedAsLoot = false;
		this.m.Items.equip(weapon);

		local armors = [
		"scripts/items/armor/named/cultist_high_priest_armor"
		]
		local helmets = [
		"scripts/items/helmets/named/cultist_high_priest_hood"
		]

		this.m.Items.equip(this.new(helmets[this.Math.rand(0, helmets.len()-1)]));	//helmet
		local armor = this.new(armors[this.Math.rand(0, armors.len()-1)])	//armor
		this.m.Items.equip(armor);

	}
});