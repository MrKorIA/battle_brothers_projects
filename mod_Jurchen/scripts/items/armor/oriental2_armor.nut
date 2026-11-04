this.oriental2_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.oriental2_armor";
		this.m.Name = "Восточный доспех";
		this.m.Description = "Этот доспех носят иноземные стрелки.";
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 1500;
		this.m.Condition = 180;
		this.m.ConditionMax = 180;
		this.m.StaminaModifier = -23;
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_jin_ armor2_body_" + variant;
		this.m.SpriteDamaged = "bust_jin_ armor2_body_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_jin_ armor2_body_" + variant + "_dead";
		this.m.IconLarge = "armor/inventory_jin_armor2_body_" + variant + ".png";
		this.m.Icon = "armor/icon_jin_armor2_body_" + variant + ".png";
	}

	function onEquip()
	{
		this.armor.onEquip();
		if (this.m.Upgrade == null)
		    this.setUpgrade(this.new("scripts/items/armor_upgrades/jurchen_dragon_upgrade"));
	}
});