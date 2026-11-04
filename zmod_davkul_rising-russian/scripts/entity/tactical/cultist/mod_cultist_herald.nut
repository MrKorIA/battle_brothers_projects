//bannerman, buffs the others to keep their morale up, is in every cultist party
this.mod_cultist_herald <- this.inherit("scripts/entity/tactical/cultist/mod_cultist_priest", {
	m = {
	},
	function create()
	{
		this.m.Type = this.Const.EntityType.Cultist_Herald;
		this.m.XP = this.Const.Tactical.Actor.Cultist_Herald.XP;
		this.mod_cultist_priest.create()
	}

	function onInit()
	{
		this.mod_cultist_priest.onInit()
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.Cultist_Herald);
		b.TargetAttractionMult = 3.0;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		b.IsSpecializedInPolearms = true;
		this.m.CurrentProperties = clone b;


		this.m.Skills.add(this.new("scripts/skills/perks/perk_fearsome"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_nimble"));	
	}

	function assignRandomEquipment()
	{
		this.mod_cultist_priest.assignRandomEquipment()
		local helmet = this.new("scripts/items/helmets/cultist_flesh_prophet")
		helmet.setVariant(3)
		this.m.Items.equip(helmet);	//helmet
	}

});