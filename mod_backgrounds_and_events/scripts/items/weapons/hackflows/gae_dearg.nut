this.gae_dearg <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.hackflows_gae_dearg";
		this.m.Name = "Гэ Дерг";
		this.m.Description = "Багровое копьё, чьё остриё словно пропитано застывшей кровью. Лежащее на нём заклятие разрушает любую защиту: удары этого оружия проходят сквозь доспехи, словно те сотканы из паутины. Это сестринское копьё Гэ Будэ.";
		this.m.Categories = "Копье, одноручное";
		this.m.IconLarge = "weapons/melee/gae_dearg.png";
		this.m.Icon = "weapons/melee/gae_dearg_stash.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded | this.Const.Items.ItemType.Legendary;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_gae_dearg";
		this.m.Condition = 72.0;
		this.m.ConditionMax = 72.0;
		this.m.Value = 10000;
		this.m.RegularDamage = 55;
		this.m.RegularDamageMax = 60;
		this.m.ArmorDamageMult = 0.85;
		this.m.DirectDamageMult = 1.0;
	}

	function getTooltip()
	{
		local result = this.weapon.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Полностью игнорирует броню."
		});
		return result;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/gae_dearg_thrust"));
		this.addSkill(this.new("scripts/skills/actives/spearwall"));
	}

});
