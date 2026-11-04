this.gae_buidhe <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.hackflows_gae_buidhe";
		this.m.Name = "Гэ Будэ";
		this.m.Description = "Блестящее золотое копье с отточенным наконечником, который сверкает даже в темноте. Владельцы копья никогда не промахиваются при уколе. Такое ощущение, что оружие переписывает саму судьбу, чтобы удар достиг цели. Это сестринское копье Гэ Дерг.";
		this.m.Categories = "Копье, одноручное";
		this.m.IconLarge = "weapons/melee/gae_buidhe.png";
		this.m.Icon = "weapons/melee/gae_buidhe_stash.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded | this.Const.Items.ItemType.Legendary;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_gae_buidhe";
		this.m.Condition = 72.0;
		this.m.ConditionMax = 72.0;
		this.m.Value = 10000;
		this.m.RegularDamage = 55;
		this.m.RegularDamageMax = 60;
		this.m.ArmorDamageMult = 0.85;
		this.m.DirectDamageMult = 0.25;
		this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Legendary;
	}

	function getTooltip()
	{
		local result = this.weapon.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/perks/perk_57.png",
			text = "Основная атака требует меньший урон для нанесения травм."
		});
		result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Никогда не промахивается при уколе."
		});
		return result;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/gae_buidhe_thrust"));
		this.addSkill(this.new("scripts/skills/actives/spearwall"));
	}

});

