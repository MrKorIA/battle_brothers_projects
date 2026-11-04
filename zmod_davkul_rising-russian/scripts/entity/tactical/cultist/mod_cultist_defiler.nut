//big champs, need some way to distinguish from barb Defiler
this.mod_cultist_defiler <- this.inherit("scripts/entity/tactical/human", {
	m = {
	},
	function create()
	{
		this.m.Type = this.Const.EntityType.Cultist_Defiler;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.Cultist_Defiler.XP;
		this.human.create();
		this.m.SoundPitch = 0.7;
		this.m.Faces = this.Const.Faces.WildMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Raider;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/cultist_defiler_agent");
		this.m.AIAgent.setActor(this);
	}

	function onInit()
	{
		this.human.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.Cultist_Defiler);
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.setAppearance();
		this.getSprite("socket").setBrush("bust_base_mod_cultist");
		local dirt = this.getSprite("dirt");
		dirt.Visible = true;
		dirt.Alpha = this.Math.rand(150, 255);

		this.m.Skills.add(this.new("scripts/skills/perks/perk_brawny"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_coup_de_grace"));
		#this.m.Skills.add(this.new("scripts/skills/actives/recover_skill"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_nimble"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_battle_forged"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_reach_advantage"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_berserk"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_fearsome"));
		this.m.Skills.add(this.new("scripts/skills/traits/cultist_zealot_trait"));
	}

	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.actor.onAppearanceChanged(_appearance, false);
		this.setDirty(true);
	}

	function assignRandomEquipment()
	{
		local weapons =
		[
			"scripts/items/weapons/cultist_billhook",
			"scripts/items/weapons/cultist_crowbeak",
			"scripts/items/weapons/cultist_scythe",
			"scripts/items/weapons/cultist_scythe",
			"scripts/items/weapons/cultist_scythe",
			"scripts/items/weapons/cultist_scythe",
			"scripts/items/weapons/cultist_scythe",
			"scripts/items/weapons/cultist_scythe"
		]

		local armors = [
		"scripts/items/armor/decayed_coat_of_plates",
		"scripts/items/armor/decayed_coat_of_scales",
		]
		local helmets = [
		"scripts/items/helmets/cultist_flesh_defiler"
		]

		local weapon = this.Math.randArray(weapons)
		if (weapon == "scripts/items/weapons/cultist_scythe"){
			this.m.AIAgent.m.Properties.TargetPriorityHitpointsMult = 0.5;
		}
		if (weapon == "scripts/items/weapons/cultist_crowbeak"){
			this.m.AIAgent.m.Properties.TargetPriorityHitpointsMult = 0.2;
		}

		this.m.Items.equip(this.new(weapon)); //weapon
		this.m.Items.equip(this.new(helmets[this.Math.rand(0, helmets.len()-1)]));	//helmet

		local armor = this.new(armors[this.Math.rand(0, armors.len()-1)])	//armor
		// local tabard = this.new("scripts/items/armor_upgrades/tabard_01_upgrade")
		// armor.setUpgrade(tabard)
		this.m.Items.equip(armor);
	}


	function makeMiniboss()
	{
		if (!this.actor.makeMiniboss())
		{
			return false;
		}

		this.getSprite("miniboss").setBrush("bust_miniboss");
		local items = clone this.Const.Items.NamedCultistWeapons;
		items.extend(this.Const.Items.NamedCultistHelmets)

		this.m.Items.equip(this.new("scripts/items/" + this.Math.randArray(items)));
		return true;
	}

});