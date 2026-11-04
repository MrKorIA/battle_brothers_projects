this.xx_mob_hunsbow <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.xx_mob_hunsbow";
		this.m.Name = "Восточный Лук Кочевника";
		this.m.Description = "Очень легкий короткий лук";
		this.m.Categories = "Bow, One-Handed";
		this.m.IconLarge = "weapons/ranged/bow_goblin_01.png";
		this.m.Icon = "weapons/ranged/bow_goblin_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.RangedWeapon | this.Const.Items.ItemType.Defensive;
		this.m.EquipSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = true;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_goblin_bow_01";
		this.m.Value = 100;
		this.m.Condition = 100.0;
		this.m.ConditionMax = 100.0;
		this.m.StaminaModifier = -1;
		this.m.RangeMin = 2;
		this.m.RangeMax = 5;
		this.m.RangeIdeal = 5;
		this.m.RegularDamage = 40;
		this.m.RegularDamageMax = 60;
		this.m.ArmorDamageMult = 0.7;
		this.m.DirectDamageMult = 0.3;
	}

	function getAmmoID()
	{
		return "ammo.arrows";
	}

	function getAdditionalRange( _actor )
	{
		return _actor.getCurrentProperties().IsSpecializedInBows ? 1 : 0;
	}

	function onEquip()
	{
		this.named_weapon.onEquip();
		local xxskill = this.new("scripts/skills/actives/quick_shot");
		xxskill.m.MaxRange = 5;
		this.addSkill(xxskill);
	}

});

