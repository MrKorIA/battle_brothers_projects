this.excalibur <- this.inherit("scripts/items/weapons/weapon", {
	m = {
		StunChance = 0
	},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.hackflows_excalibur";
		this.m.Name = "Экскалибур";
		this.m.Description = "Легендарный клинок, якобы дарованный благороднейшим из рыцарей. Благодаря некоему мистическому заклинанию оружие имеет большую досягаемость, чем кажется.";
		this.m.Categories = "Меч, двуручный";
		this.m.IconLarge = "weapons/melee/excalibur.png";
		this.m.Icon = "weapons/melee/excalibur_stash.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon
			| this.Const.Items.ItemType.TwoHanded | this.Const.Items.ItemType.Legendary;
		this.m.IsAgainstShields = true;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_excalibur";
		this.m.Value = 3200;
		this.m.ShieldDamage = 16;
		this.m.Condition = 72.0;
		this.m.ConditionMax = 72.0;
		this.m.StaminaModifier = -12;
		this.m.RegularDamage = 100;
		this.m.RegularDamageMax = 120;
		this.m.ArmorDamageMult = 1.0;
		this.m.DirectDamageMult = 0.25;
		this.m.ChanceToHitHead = 5;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skillToAdd = this.new("scripts/skills/actives/overhead_strike");
		skillToAdd.setStunChance(this.m.StunChance);
		this.addSkill(skillToAdd);
		this.addSkill(this.new("scripts/skills/actives/excalibur_split"));
		this.addSkill(this.new("scripts/skills/actives/swing"));
		local skillToAdd = this.new("scripts/skills/actives/split_shield");
		skillToAdd.setFatigueCost(skillToAdd.getFatigueCostRaw() + 5);
		this.addSkill(skillToAdd);
	}

});
