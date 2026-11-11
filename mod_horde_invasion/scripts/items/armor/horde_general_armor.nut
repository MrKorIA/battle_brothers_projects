this.horde_general_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.horde_general";
		this.m.Name = "Доспех генерала Великой Орды";
		this.m.Description = "Изящный и вместе с тем прочный доспех иноземного генерала Великой Орды.";
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 5500;
		this.m.Condition = 280;
		this.m.ConditionMax = 280;
		this.m.StaminaModifier = -24;
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "horde_general_armor_" + variant;
		this.m.SpriteDamaged = "horde_general_armor_" + variant + "_damaged";
		this.m.SpriteCorpse = "horde_general_armor_" + variant + "_dead";
		this.m.IconLarge = "armor/inventory_horde_general_armor_" + variant + ".png";
		this.m.Icon = "armor/icon_horde_general_armor_" + variant + ".png";
	}

	function onEquip()
	{
		this.armor.onEquip();
		if (this.m.Upgrade == null)
		    this.setUpgrade(this.new("scripts/items/armor_upgrades/jurchen_dragon_upgrade"));
	}
});