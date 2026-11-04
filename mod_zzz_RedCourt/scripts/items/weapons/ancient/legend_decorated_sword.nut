this.legend_decorated_sword <- this.inherit("scripts/items/weapons/weapon", {
	m = {
		Bravery = 8
	},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.legend_decorated_sword";
        this.m.Name = "Древний украшенный меч";
        this.m.Description = "Прямой клинок древнего происхождения. Рукоять и навершие богато украшены, а балансировке меча уделено особое внимание - несмотря на то, что он явно предназначен для церемониальных целей.";
		this.m.IconLarge = "weapons/melee/legend_decorated_sword_01.png";
		this.m.Icon = "weapons/melee/legend_decorated_sword_01_70x70.png";
		this.m.WeaponType = this.Const.Items.WeaponType.Sword;
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_legend_decorated_sword_01";
		this.m.Value = 1300;
		this.m.Condition = 48.0;
		this.m.ConditionMax = 48.0;
		this.m.StaminaModifier = -4;
		this.m.RegularDamage = 35;
		this.m.RegularDamageMax = 45;
		this.m.ArmorDamageMult = 0.6;
		this.m.DirectDamageMult = 0.2;
		this.m.DirectDamageAdd = 0.1;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/slash"));
		this.addSkill(this.new("scripts/skills/actives/riposte"));
	}
});

