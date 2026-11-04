this.xx_mob_orcbow <- this.inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.xx_mob_orcbow";
		this.m.Name = "Длинный лук орка";
		this.m.Description = "Очень тяжелый длинный лук, используемый опытными орками.";
		this.m.Categories = "Bow, Two-Handed";
		this.m.IconLarge = "weapons/ranged/bow_goblin_01.png";
		this.m.Icon = "weapons/ranged/bow_goblin_01_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.RangedWeapon | this.Const.Items.ItemType.Defensive;
		this.m.EquipSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = true;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_named_bow_02";
		this.m.FatigueOnSkillUse = 5;
		this.m.Value = 30;
		this.m.RangeMin = 2;
		this.m.RangeMax = 8;
		this.m.RangeIdeal = 8;
		this.m.StaminaModifier = -10;
		this.m.Condition = 100.0;
		this.m.ConditionMax = 100.0;
		this.m.RegularDamage = 50;
		this.m.RegularDamageMax = 70;
		this.m.ArmorDamageMult = 0.6;
		this.m.DirectDamageMult = 0.5;
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
		local s;
		s = this.new("scripts/skills/actives/quick_shot");
		s.m.MaxRange = 7;
		s.m.DirectDamageMult = 0.4;
		this.addSkill(s);
		s = this.new("scripts/skills/actives/aimed_shot");
		s.m.MaxRange = 8;
		s.m.DirectDamageMult = 0.5;
		this.addSkill(s);
	}

});

