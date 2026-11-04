this.cultist_flesh_acolyte <- ::inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.cultist_flesh_acolyte";
		this.m.Name = "Кожаная шапка культиста";
		this.m.Description = "Лёгкая шапка из человеческой кожи.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.VariantString = "acolyte_hood_";
		this.m.MaxVariant <- 7;
		this.updateVariant();
		this.m.Value = 50;
		this.m.Condition = 55;
		this.m.ConditionMax = 55;
		this.m.StaminaModifier = -4;
		this.m.Vision = -2;
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
			text = "Уменьшает решимость любого противника в ближнем бою на [color=" + this.Const.UI.Color.NegativeValue + "]-3[/color]"
		});
		result.push({
			id = 10,
			type = "text",
			icon = "ui/icons/bravery.png",
			text = "[color=" + this.Const.UI.Color.NegativeValue + "]-3[/color] к решимости"
		});
		return result;
	}
	function onUpdateProperties( _properties )
	{
		this.helmet.onUpdateProperties(_properties);
		_properties.Threat += 3;
		_properties.Bravery -= 3;
	}

});

