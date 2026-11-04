this.xxdragonsw <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.xxdragonsw";
		this.m.Name = "Убийца драконов";
		this.m.Description = "Он был слишком велик, чтобы его можно было назвать мечом. Массивный, толстый, тяжелый и слишком грубый. По сути, это был кусок необработанного железа. Это оружие игнорирует бонус к ближней защите, предоставляемый щитами.";
		this.m.Categories = "оружие, двуручное";
		this.m.IconLarge = "xx_weapon_08.png";
		this.m.Icon = "xx_weapon_08_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_xx_weapon_08";
		this.m.Value = 7000;
		this.m.ShieldDamage = 0;
		this.m.Condition = 200;
		this.m.ConditionMax = 200;
		this.m.StaminaModifier = -40;
		this.m.RegularDamage = 170;
		this.m.RegularDamageMax = 200;
		this.m.ArmorDamageMult = 1.5;
		this.m.DirectDamageMult = 0.5;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/xxitem_dragonswaa_skill"));
		this.addSkill(this.new("scripts/skills/actives/xxitem_dragonswbb_skill"));
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});

