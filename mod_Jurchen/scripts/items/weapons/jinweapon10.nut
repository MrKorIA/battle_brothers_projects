this.jinweapon10 <- this.inherit("scripts/items/weapons/weapon", {
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

		if (_l)
		{
			this.m.ArmamentIcon = "jin_weapon_10_loaded";
		}
		else
		{
			this.m.ArmamentIcon = "jin_weapon_10_empty";
		}

		this.updateAppearance();
	}

	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.jinweapon10";
		this.m.Name = "Чурчжэньская пищаль";
        this.m.Description = "Примитивное пороховое оружие, состоящее из кованого железного ствола на длинном деревянном древке. Оно извергает сноп раскалённой картечи, способной накрыть несколько целей одним залпом. Бесполезно в ближнем бою.";
		this.m.Categories = "Огнестрельное оружие, двуручное";
		this.m.IconLarge = "weapons/melee/jin_weapon_11.png";
		this.m.Icon = "weapons/melee/jin_weapon_11_70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.RangedWeapon | this.Const.Items.ItemType.Defensive;
		this.m.EquipSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = true;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "jin_weapon_10_loaded";
		this.m.Value = 3000;
		this.m.RangeMin = 2;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RangeMaxBonus = 1;
		this.m.StaminaModifier = -15;
		this.m.Condition = 60.0;
		this.m.ConditionMax = 60.0;
		this.m.RegularDamage = 30;
		this.m.RegularDamageMax = 70;
		this.m.ArmorDamageMult = 1.1;
		this.m.DirectDamageMult = 0.25;
		this.m.IsEnforcingRangeLimit = true;
	}

	function getAmmoID()
	{
		return "ammo.powder";
	}

	function getRangeEffective()
	{
		return this.m.RangeMax + 2;
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
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Требуется перезарядка[/color]"
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
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/fire_handgonne_skill"));

		if (!this.m.IsLoaded)
		{
			this.addSkill(this.new("scripts/skills/actives/reload_handgonne_skill"));
		}
	}

	function onCombatFinished()
	{
		this.weapon.onCombatFinished();
		this.m.IsLoaded = true;
	}

});

