this.cultist_flesh_prophet <- ::inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.cultist_flesh_prophet";
		this.m.Name = "Капюшон культиста с маской";
		this.m.Description = "Ужасающий капюшон, сделанный из человеческой кожи, усиленный металлической маской.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.VariantString = "prophet_hood_";
		this.m.MaxVariant <- 4;
		this.m.Value = 20;
		this.m.Condition = 120;
		this.m.ConditionMax = 120;
		this.m.StaminaModifier = -10;
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
	function setVariant(_var)
	{
		_var = _var < 10 ? "0" + _var : _var
		local variant = this.m.Variant = _var
		this.m.Sprite = this.m.VariantString + variant;
		this.m.SpriteDamaged = this.m.Sprite + "_damaged"
		this.m.SpriteCorpse = this.m.Sprite + "_dead"
		this.m.IconLarge = "";
		this.m.Icon = "helmets/" + this.m.VariantString + variant + "_icon.png";
	}
	function getTooltip()
	{
		local result = this.helmet.getTooltip();
		result.push({
			id = 15,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Уменьшает решимость любого противника в ближнем бою на [color=" + this.Const.UI.Color.NegativeValue + "]-5[/color]"
		});
		return result;
	}
	function onUpdateProperties( _properties )
	{
		this.helmet.onUpdateProperties(_properties);
		_properties.Threat += 5;
	}

});

