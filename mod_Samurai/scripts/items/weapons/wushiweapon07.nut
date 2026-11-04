this.wushiweapon07 <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.wushiweapon07";
		this.m.Name = "Сай";
		this.m.Description = "Тяжёлый гранёный стилет с характерным массивным трезубцем у рукояти. Его лезвия лишены заточки, а кованое остриё создано для точечных колющих ударов в сочленения доспехов. Боковые зубцы позволяют мастерски перехватывать и блокировать удары вражеских клинков.";
		this.m.Categories = "Меч, одноручный";
		this.m.IconLarge = "weapons/melee/wushi_weapon_07.png";
		this.m.Icon = "weapons/melee/wushi_weapon_07_70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "wushi_weapon_07";
		this.m.Condition = 70.0;
		this.m.ConditionMax = 70.0;
		this.m.Value = 1500;
		this.m.RegularDamage = 30;
		this.m.RegularDamageMax = 45;
		this.m.ArmorDamageMult = 1.0;
		this.m.DirectDamageMult = 0.30;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/slash"));
		this.addSkill(this.new("scripts/skills/actives/lunge_skill"));
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});

