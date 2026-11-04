this.cultist_flesh_named <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {
	},
	function create()
	{
		this.named_helmet.create();
		this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Cultist
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.ReplaceSprite = true;
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
	}

	function updateVariant()
	{
		local getVariant = function(){
			local variant = this.Math.rand(1, this.m.MaxVariant)
			return variant < 10 ? "0" + variant : variant
		}
		local variant = this.m.Variant = getVariant()
		this.m.Sprite = this.m.VariantString + variant;
		this.m.SpriteDamaged = this.m.Sprite + "_damaged"
		this.m.SpriteCorpse = this.m.Sprite + "_dead"
		this.m.IconLarge = "";
		this.m.Icon = "helmets/named/" + this.m.VariantString + variant + "_icon.png";
	}
	function getTooltip()
	{
		local result = this.helmet.getTooltip();
		result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Уменьшает решимость любого противника в ближнем бою на [color=" + this.Const.UI.Color.NegativeValue + "]-10[/color]"
		});
		return result;
	}
	function onUpdateProperties( _properties )
	{
		this.helmet.onUpdateProperties(_properties);
		_properties.Threat += 10;
	}

});

