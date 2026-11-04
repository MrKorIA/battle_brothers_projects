this.wushiweapon21 <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function isAmountShown()
	{
		return true;
	}

	function getAmountString()
	{
		return this.m.Ammo + "/" + this.m.AmmoMax;
	}

	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.wushiweapon21";
		this.m.Name = "Связка мандзи-сюрикэнов";
		this.m.Description = "Грозный крупный сюрикэн с четырьмя изогнутыми серповидными лучами. При броске это оружие раскручивается в воздухе до свиста, превращаясь во вращающийся диск, который буквально сдирает мясо с костей врага и оставляет страшные рваные раны.";
		this.m.Categories = "Метательное, одноручное";
		this.m.IconLarge = "weapons/melee/wushi_weapon_21.png";
		this.m.Icon = "weapons/melee/wushi_weapon_21_70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.RangedWeapon | this.Const.Items.ItemType.Ammo | this.Const.Items.ItemType.Defensive;
		this.m.AddGenericSkill = true;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "wushi_weapon_21";
		this.m.Value = 800;
		this.m.Ammo = 5;
		this.m.AmmoMax = 5;
		this.m.RangeMin = 1;
		this.m.RangeMax = 4;
		this.m.RangeIdeal = 4;
		this.m.StaminaModifier = -5;
		this.m.RegularDamage = 55;
		this.m.RegularDamageMax = 65;
		this.m.ArmorDamageMult = 0.65;
		this.m.DirectDamageMult = 0.25;
		this.m.ShieldDamage = 0;
		this.m.IsDroppedAsLoot = true;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/wushiweapon21_01"));
	}

	function setAmmo( _a )
	{
		this.weapon.setAmmo(_a);

		if (this.m.Ammo > 0)
		{
			this.m.Name = "Связка мандзи-сюрикэнов";
			this.m.IconLarge = "weapons/melee/wushi_weapon_21.png";
			this.m.Icon = "weapons/melee/wushi_weapon_21_70.png";
			this.m.ShowArmamentIcon = true;
		}
		else
		{
			this.m.Name = "Связка мандзи-сюрикэнов (пустая)";
			this.m.IconLarge = "weapons/melee/wushi_weapon_21.png";
			this.m.Icon = "weapons/melee/wushi_weapon_21_70.png";
			this.m.ShowArmamentIcon = false;
		}

		this.updateAppearance();
	}

});

