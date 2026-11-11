this.rat_warpfire_thrower <- this.inherit("scripts/items/weapons/weapon", {
	m = {
		Heat = 0,
		HeatPerShot = 30,
		CooldownPerTurn = 30
	},
	function getHeat()
	{
		return this.m.Heat;
	}

	function addHeat( _h )
	{
		this.m.Heat = this.Math.min(100, this.m.Heat + _h);
	}

	function coolDown( _h )
	{
		this.m.Heat = this.Math.max(0, this.m.Heat - _h);
	}

	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.rat_warpfire_thrower";
		this.m.Name = "Метатель Варп-Огня";
		this.m.Description = "Метатель Варп-Огня - это грубый, но крайне нестабильный огнемёт, который обрушивает на врага или небольшой участок земли взрыв концентрированного Варп-Огня. Поражённая цель будет заражена чумой. Не может использоваться в ближнем бою. После каждого выстрела огнемёт перегревается, и в конце концов может взорваться.";
		this.m.Categories = "Огнестрельное, двуручное";
		this.m.IconLarge = "weapons/ranged/handgonne_01.png";
		this.m.Icon = "weapons/ranged/handgonne_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.RangedWeapon | this.Const.Items.ItemType.Defensive;
		this.m.EquipSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = true;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "rat_warp_weapon_01";
		this.m.Value = 3000;
		this.m.RangeMin = 2;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RangeMaxBonus = 1;
		this.m.StaminaModifier = -14;
		this.m.Condition = 60.0;
		this.m.ConditionMax = 60.0;
		this.m.RegularDamage = 35;
		this.m.RegularDamageMax = 75;
		this.m.ArmorDamageMult = 0.9;
		this.m.DirectDamageMult = 0.25;
		this.m.IsEnforcingRangeLimit = true;
		this.m.IsDroppedAsLoot = false;
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

		if (this.m.Heat > 0)
		{
			result.push({
				id = 10,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Перегрев: " + this.m.Heat + "%. Каждый выстрел нагревает огнемёт, простой остывает[/color]"
			});
		}

		return result;
	}

	function onCombatFinished()
	{
		this.weapon.onCombatFinished();
		this.m.Heat = 0;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/rat_warpfire_throw_skill"));
	}

});
