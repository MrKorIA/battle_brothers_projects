this.cultist_flesh_defiler <- ::inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.cultist_flesh_defiler";
		this.m.Name = "Плотный капюшон культиста";
		this.m.Description = "Ужасающий капюшон, сделанный из кожи жертв.";
		this.m.VariantString = "defiler_hood_";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.MaxVariant <- 6;
		this.updateVariant();
		this.m.Value = 700;
		this.m.Condition = 230;
		this.m.ConditionMax = 230;
		this.m.StaminaModifier = -17;
		this.m.Vision = -3;
	}
	function updateVariant()
    {
        if (this.m.Variant == 0)
        {
            this.m.Variant = this.Math.rand(1, this.m.MaxVariant);
        }

        local vString = this.m.Variant < 10 ? "0" + this.m.Variant : this.m.Variant.tostring();

        // 1. Иконка для инвентаря (раз она работает, оставляем так)
        this.m.Icon = "helmets/" + this.m.VariantString + vString + "_icon.png";

        // 2. Спрайты для персонажа (добавляем или убираем папку helmets/)
        // Попробуй сначала ТАК (без папки helmets/ в начале):
        this.m.Sprite = this.m.VariantString + vString;
        this.m.SpriteDamaged = this.m.VariantString + vString + "_damaged";
        this.m.SpriteCorpse = this.m.VariantString + vString + "_dead";
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
		result.push({
			id = 10,
			type = "text",
			icon = "ui/icons/bravery.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] к решимости"
		});
		return result;
	}
	function onUpdateProperties( _properties )
	{
		this.helmet.onUpdateProperties(_properties);
		_properties.Threat += 10;
		_properties.Bravery -= 10;
	}

});

