this.named_mgl07_helmet_01 <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.named_mgl07_helmet_01";
		this.m.Description = "Сверкающий золотой степной шлем, который носит, без сомнения, истинный воин.";
		this.m.Name = "Слава степи";
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 5000;
		this.m.Condition = 255;
		this.m.ConditionMax = 255;
		this.m.StaminaModifier = -20;
		this.m.Vision = -1;
		this.randomizeValues();
	}

   function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_helmet_mgl07_" + variant;
		this.m.SpriteDamaged = "bust_helmet_mgl07_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_helmet_mgl07_" + variant + "_dead";
		this.m.IconLarge = "";
		this.m.Icon = "helmets/icon_bust_helmet_mgl07_" + variant + ".png";
	}
	
	function getTooltip()
	{
	    local result = this.helmet.getTooltip();
		result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/special.png",
			text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] к решимости"
		});
		return result;
	}

	function onUpdateProperties( _properties )
	{
		this.helmet.onUpdateProperties(_properties);
		_properties.Bravery += 5;
	}
	
});

