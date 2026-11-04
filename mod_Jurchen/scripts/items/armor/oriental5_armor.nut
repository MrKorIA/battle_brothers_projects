this.oriental5_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.oriental5_armor";
		this.m.Name = "Доспех иноземного воеводы";
		this.m.Description = "Доспех, который носят воеводы иноземной армии.";
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 5000;
		this.m.Condition = 300;
		this.m.ConditionMax = 300;
		this.m.StaminaModifier = -40;
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_jin_ armor5_body_" + variant;
		this.m.SpriteDamaged = "bust_jin_ armor5_body_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_jin_ armor5_body_" + variant + "_dead";
		this.m.IconLarge = "armor/inventory_jin_armor5_body_" + variant + ".png";
		this.m.Icon = "armor/icon_jin_armor5_body_" + variant + ".png";
	}

});