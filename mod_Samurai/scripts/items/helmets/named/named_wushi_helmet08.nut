this.named_wushi_helmet08 <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.named_wushi_helmet08";
		this.m.Description = "Шлем, который носил очень храбрый самурайский генерал. Легенда гласит, что этот шлем содержит дух бога-оленя, и самурай, носящий его, обретает невероятную храбрость.";
		this.m.Name = "Дух оленя";
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 7000;
		this.m.Condition = 255;
		this.m.ConditionMax = 255;
		this.m.StaminaModifier = -18;
		this.m.Vision = -2;
		this.randomizeValues();
	}



   function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_wushi_helmet08_" + variant;
		this.m.SpriteDamaged = "bust_wushi_helmet08_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_wushi_helmet08_" + variant + "_dead";
		this.m.IconLarge = "";
		this.m.Icon = "helmets/icon_wushi_helmet08_" + variant + ".png";
	}
	
	function getTooltip()
	{
	local result = this.helmet.getTooltip();
		result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] к Решимости"
		});
		return result;
	}
	function onUpdateProperties( _properties )
	{
		this.helmet.onUpdateProperties(_properties);
		_properties.Bravery += 15;
	}
});

