this.named_wushiweapon16 <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = this.Math.rand(1, 3);
		this.updateVariant();
		this.m.ID = "weapon.named_wushiweapon16";
		this.m.Name = "Остаточный угол";
		this.m.Description = "Жил-был знаменитый самурай, который был непобедим, и в одной битве это копье было повреждено, но это нисколько не повлияло на его силу.";
		this.m.Categories = "Древковое, двуручное";
		this.m.IconLarge = "weapons/melee/wushi_weapon_16.png";
		this.m.Icon = "weapons/melee/wushi_weapon_16_70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded | this.Const.Items.ItemType.Defensive;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "wushi_weapon_16";
		this.m.Value = 3800;
		this.m.ShieldDamage = 0;
		this.m.Condition = 94.0;
		this.m.ConditionMax = 94.0;
		this.m.StaminaModifier = -18;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 70;
		this.m.RegularDamageMax = 90;
		this.m.ArmorDamageMult = 1.4;
		this.m.DirectDamageMult = 0.4;
		this.m.ChanceToHitHead = 10;
		this.randomizeValues();
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		local impale = this.new("scripts/skills/actives/impale");
		impale.m.Icon = "skills/active_54.png";
		impale.m.IconDisabled = "skills/active_54_sw.png";
		impale.m.Overlay = "active_54";
		this.addSkill(impale);
		this.addSkill(this.new("scripts/skills/actives/reap_skill"));
	}

});

