this.oriental7_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.oriental7_armor";
		this.m.Name = "Доспех иноземного мастера копья";
		this.m.Description = "Этот доспех, покрытый красным одеянием, имеет умеренный вес.";
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 3000;
		this.m.Condition = 200;
		this.m.ConditionMax = 200;
		this.m.StaminaModifier = -22;
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_jin_ armor7_body_" + variant;
		this.m.SpriteDamaged = "bust_jin_ armor7_body_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_jin_ armor7_body_" + variant + "_dead";
		this.m.IconLarge = "armor/inventory_jin_armor7_body_" + variant + ".png";
		this.m.Icon = "armor/icon_jin_armor7_body_" + variant + ".png";
	}

});