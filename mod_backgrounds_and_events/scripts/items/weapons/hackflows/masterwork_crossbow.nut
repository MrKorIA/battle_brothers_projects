this.masterwork_crossbow <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {
		IsLoaded = true
	},
	function isLoaded()
	{
		return this.m.IsLoaded;
	}

	function setLoaded( _l )
	{
		this.m.IsLoaded = _l;
	}

	function create()
	{
		this.named_weapon.create();
		this.m.Variant = this.Math.rand(1, 3);
		this.updateVariant();
		this.m.ID = "weapon.hackflows_masterwork_crossbow";
		this.m.NameList = this.Const.Strings.CrossbowNames;
		this.m.Description = "Искусно украшенный арбалет, собранный из компонентов высочайшего качества. При натяжении тетива сохраняет огромную потенциальную энергию относительно веса арбалета, позволяя каждому выстрелу с невероятной эффективностью пробивать даже тяжелую броню. Истинное творение мастера-арбалетчика.";
		this.m.Categories = "Арбалет, двуручный";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Named | this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.RangedWeapon | this.Const.Items.ItemType.Defensive;
		this.m.EquipSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = true;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 4400;
		this.m.RangeMin = 1;
		this.m.RangeMax = 6;
		this.m.RangeIdeal = 6;
		this.m.StaminaModifier = -12;
		this.m.Condition = 64.0;
		this.m.ConditionMax = 64.0;
		this.m.RegularDamage = 50;
		this.m.RegularDamageMax = 70;
		this.m.ArmorDamageMult = 0.75;
		this.m.DirectDamageMult = 0.75;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/crossbow_01_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/crossbow_01_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_named_crossbow_0" + this.m.Variant;
	}

	function getAmmoID()
	{
		return "ammo.bolts";
	}

	function getTooltip()
	{
		local result = this.weapon.getTooltip();

		if (!this.m.IsLoaded)
		{
			result.push({
				id = 10,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Требуется перезарядка перед следующим выстрелом[/color]"
			});
		}

		return result;
	}

	function onCombatFinished()
	{
		this.setLoaded(true);
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/shoot_bolt"));

		if (!this.m.IsLoaded)
		{
			this.addSkill(this.new("scripts/skills/actives/reload_bolt"));
		}
	}

	function onCombatFinished()
	{
		this.weapon.onCombatFinished();
		this.m.IsLoaded = true;
	}

});

