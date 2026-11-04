//better acolytes, same plan but better stats?
this.mod_cultist_fanatic <- this.inherit("scripts/entity/tactical/human", {
	m = {
	},
	function create()
	{
		this.m.Type = this.Const.EntityType.Cultist_Fanatic;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.Cultist_Fanatic.XP;
		this.human.create();
		this.m.SoundPitch = 0.8;
		this.m.Faces = this.Const.Faces.WildMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Raider;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/bandit_melee_agent");
		this.m.AIAgent.setActor(this);
		this.m.AIAgent.m.Properties.EngageTargetMultipleOpponentsMult = 0.7
		this.m.AIAgent.m.Properties.EngageAgainstSpearwallMult = 1.0
		#this.m.AIAgent.m.Properties.IgnoreTargetValueOnEngage = true;
		this.m.AIAgent.m.Properties.PreferCarefulEngage = false;
		this.m.AIAgent.m.Properties.OverallFormationMult = 0.5
	}

	function onInit()
	{
		this.human.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.Cultist_Fanatic);
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.setAppearance();
		this.getSprite("socket").setBrush("bust_base_mod_cultist");
		local dirt = this.getSprite("dirt");
		dirt.Visible = true;
		dirt.Alpha = this.Math.rand(150, 255);


		this.m.Skills.add(this.new("scripts/skills/perks/perk_fearsome"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_coup_de_grace"));
		#this.m.Skills.add(this.new("scripts/skills/perks/perk_crippling_strikes"));
		this.m.Skills.add(this.new("scripts/skills/traits/cultist_fanatic_trait"));

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
		"scripts/items/weapons/scramasax",
		"scripts/items/weapons/hand_axe"
		]
		local helmets = [
		"scripts/items/helmets/cultist_flesh_fanatic"
		]
		local armors = [
		"scripts/items/armor/mail_shirt",
		"scripts/items/armor/worn_mail_shirt",
		"scripts/items/armor/patched_mail_shirt",
		"scripts/items/armor/padded_leather",
		"scripts/items/armor/basic_mail_shirt",
		"scripts/items/armor/ragged_surcoat"
		]

		this.m.Items.equip(this.new(weapons[this.Math.rand(0, weapons.len()-1)])); //weapon
		this.m.Items.equip(this.new(helmets[this.Math.rand(0, helmets.len()-1)]));	//helmet

		local armor = this.new(armors[this.Math.rand(0, armors.len()-1)])	//armor
		local tabard = this.new("scripts/items/armor_upgrades/tabard_01_upgrade")
		armor.setUpgrade(tabard)
		this.m.Items.equip(armor);
	}

});