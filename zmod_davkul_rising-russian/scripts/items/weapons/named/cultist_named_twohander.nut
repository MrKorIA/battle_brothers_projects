this.cultist_named_twohander <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.UseRandomName = false;

		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.Named | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded | this.Const.Items.ItemType.Cultist
		
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;

		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
	}
	
	function setArmament()
	{
		local prefix;
		local suffix = this.m.Variant
		local full;

		prefix = "named_cult_weapon_"
		if (suffix == 0 ){
			suffix = this.Math.rand(this.m.Variants[0], this.m.Variants[1])
			this.m.Variant = suffix
		}
		if (suffix < 10) suffix = "0"+ suffix
		full = prefix+suffix

		this.m.ArmamentIcon = full
		this.m.Icon = "weapons/melee/" +full+"_icon.png"
		this.m.IconLarge ="weapons/melee/" + full+"_large_icon.png"
	}

	function createRandomName()
	{
		return this.Math.randArray(this.m.NameList)
	}

	function updateVariant()
	{
		this.setArmament()
	}

});

