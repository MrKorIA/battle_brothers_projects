this.legend_headress_coin <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.legend_headress_coin";
		this.m.Name = "Монетный наловник";
        this.m.Description = "Роскошный южный головной убор, сплетённый из изящных металлических колец и чеканных монет. Он неплохо защищает голову, не стесняя движений.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = false;
		this.m.HideBeard = false;
		this.m.ReplaceSprite = true;
		local variants = [
			1,
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 10;
		this.m.Condition = 5;
		this.m.ConditionMax = 5;
		this.m.StaminaModifier = 0;
		this.m.Vision = 0;
	}


	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "legendhelms_southern_headress_coin_" + variant;
		this.m.SpriteDamaged = "legendhelms_southern_headress_coin_" + variant + "_damaged";
		this.m.SpriteCorpse = "legendhelms_southern_headress_coin_" + variant + "_dead";
		this.m.Icon = "helmets/inventory_headress_coin_" + variant + ".png";
		this.m.IconLarge = this.m.Icon;
	}

});

