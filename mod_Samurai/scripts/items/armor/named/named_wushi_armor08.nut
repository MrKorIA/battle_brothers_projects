this.named_wushi_armor08 <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.named_wushi_armor08";
		this.m.Description = "Доспехи, которые носил очень храбрый самурайский генерал. Легенда гласит, что эти доспехи содержат дух бога-оленя, и самурай, носящий их, обретает невероятную храбрость.";
		this.m.Name = "Дух оленя";
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 8000;
		this.m.Condition = 220;
		this.m.ConditionMax = 220;
		this.m.StaminaModifier = -25;
		this.randomizeValues();
	}
    
	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_wushi_ armor08_body_" + variant;
		this.m.SpriteDamaged = "bust_wushi_ armor08_body_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_wushi_ armor08_body_" + variant + "_dead";
		this.m.IconLarge = "armor/inventory_wushi_armor08_body_" + variant + ".png";
		this.m.Icon = "armor/icon_wushi_armor08_body_" + variant + ".png";
	}
	function getTooltip()
	{
		local result = this.armor.getTooltip();
		result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+15[/color] к решимости"
		});
		return result;
	}
	function onUpdateProperties( _properties )
	{
		this.armor.onUpdateProperties(_properties);
		_properties.Bravery += 15;
	}
});

