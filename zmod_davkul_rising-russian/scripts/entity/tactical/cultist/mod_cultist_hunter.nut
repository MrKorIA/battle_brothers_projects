//bannerman, buffs the others to keep their morale up, is in every cultist party
this.mod_cultist_hunter <- this.inherit("scripts/entity/tactical/human", {
	m = {
	},
	function create()
	{
		this.m.Type = this.Const.EntityType.Cultist_Hunter;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.Cultist_Hunter.XP;
		this.human.create();
		this.m.SoundPitch = 0.9;
		this.m.Faces = this.Const.Faces.WildMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Raider;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/bandit_ranged_agent");
		this.m.AIAgent.setActor(this);
		this.m.AIAgent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_disengage"));
		//this.m.AIAgent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_heavy_sling"))
		//this.m.AIAgent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_engage_ranged_w_sling"))	
		this.m.AIAgent.m.Properties.TargetPriorityArmorMult = 1.2;
		this.m.AIAgent.m.Properties.TargetPriorityHittingAlliesMult = 1.0
	}

	function onInit()
	{
		this.human.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.Cultist_Hunter);
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.setAppearance();
		this.getSprite("socket").setBrush("bust_base_mod_cultist");
		local dirt = this.getSprite("dirt");
		dirt.Visible = true;
		dirt.Alpha = this.Math.rand(150, 255);
		this.getSprite("armor").Saturation = 0.85;
		this.getSprite("helmet").Saturation = 0.85;
		this.getSprite("helmet_damage").Saturation = 0.85;
		this.getSprite("shield_icon").Saturation = 0.85;
		this.getSprite("shield_icon").setBrightness(0.85);

		b.IsSpecializedInThrowing = true
		this.m.Skills.add(this.new("scripts/skills/actives/footwork"));
		this.m.Skills.add(this.new("scripts/skills/actives/recover_skill"));
		this.m.Skills.add(this.new("scripts/skills/traits/cultist_acolyte_trait"));
	}

	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.actor.onAppearanceChanged(_appearance, false);
		this.setDirty(true);
	}

	function assignRandomEquipment()
	{

		local r = this.Math.rand(1, 4);

		if (r == 1)
		{
			this.m.Items.addToBag(this.new("scripts/items/weapons/dagger"));
		}
		else if (r == 2)
		{
			this.m.Items.addToBag(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 3)
		{
			this.m.Items.addToBag(this.new("scripts/items/weapons/hatchet"));
		}
		else if (r == 4)
		{
			this.m.Items.addToBag(this.new("scripts/items/weapons/bludgeon"));
		}
		local weapons =
		[
		"scripts/items/weapons/heavy_staff_sling"
		]
		local helmets = [
		"scripts/items/helmets/cultist_flesh_hunter"
		]
		local armors = [
		"scripts/items/armor/cultist_leather_robe"
		]
		this.m.Items.equip(this.new(weapons[this.Math.rand(0, weapons.len()-1)])); //weapon
		this.m.Items.equip(this.new(helmets[this.Math.rand(0, helmets.len()-1)]));	//helmet

		local armor = this.new(armors[this.Math.rand(0, armors.len()-1)])	//armor
		local tabard = this.new("scripts/items/armor_upgrades/tabard_01_upgrade")
		armor.setUpgrade(tabard)
		this.m.Items.equip(armor);
	}

});