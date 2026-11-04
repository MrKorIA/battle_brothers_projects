this.named_wushi_helmet02 <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.named_wushi_helmet02";
		this.m.Description = "Грозный самурайский шлем, который носил один из величайших воинов всех времён.";
		this.m.Name = "Шлем ужаса";
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 7000;
		this.m.Condition = 285;
		this.m.ConditionMax = 285;
		this.m.StaminaModifier = -20;
		this.m.Vision = -2;
		this.randomizeValues();
	}



   function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_wushi_helmet02_" + variant;
		this.m.SpriteDamaged = "bust_wushi_helmet02_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_wushi_helmet02_" + variant + "_dead";
		this.m.IconLarge = "";
		this.m.Icon = "helmets/icon_wushi_helmet02_" + variant + ".png";
	}
	
	function getTooltip()
	{
		local result = this.helmet.getTooltip();
		result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Уменьшает Решимость любого противника в ближнем бою на [color=" + this.Const.UI.Color.NegativeValue + "]-12[/color]"
		});
		return result;
	}
	function onUpdateProperties( _properties )
	{
		this.helmet.onUpdateProperties(_properties);
		_properties.Threat += 12;
	}
});

