this.named_mgl09_armor_01 <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.named_mgl09_armor_01";
		this.m.Description = "Хан пожаловал своим гвардейцам прекрасные доспехи, чтобы племя могло гордиться лучшими лучниками в мире.";
		this.m.Name = "Джэбэ";
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 5000;
		this.m.Condition = 260;
		this.m.ConditionMax = 260;
		this.m.StaminaModifier = -28;
		this.randomizeValues();
	}
    
	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_body_mgl09_" + variant;
		this.m.SpriteDamaged = "bust_body_mgl09_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_body_mgl09_" + variant + "_dead";
		this.m.IconLarge = "armor/inventory_bust_body_mgl09_" + variant + ".png";
		this.m.Icon = "armor/icon_bust_body_mgl09_" + variant + ".png";
	}
	
	function getTooltip()
	{
		local result = this.armor.getTooltip();
		result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] к навыку дальнего боя"
		});
		return result;
	}

	function onUpdateProperties( _properties )
	{
		this.armor.onUpdateProperties(_properties);
		_properties.RangedSkill += 5;
	}

});

