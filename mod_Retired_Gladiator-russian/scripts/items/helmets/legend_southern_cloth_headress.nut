this.legend_southern_cloth_headress <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.legend_southern_veil";
		this.m.Name = "Южный головной убор";
		this.m.Description = "Южный головной убор, состоящий из складок мягких материалов";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = false;
		this.m.HideBeard = false;
		this.m.ReplaceSprite = true;
		local variants = [
			1,
			2,
			3,
			4,
			5,
			6
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 50;
		this.m.Condition = 20;
		this.m.ConditionMax = 20;
		this.m.StaminaModifier = 0;
		this.m.Vision = 0;
	}


	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "legendhelms_southern_cloth_headress_" + variant;
		this.m.SpriteDamaged = "legendhelms_southern_cloth_headress_" + variant + "_damaged";
		this.m.SpriteCorpse = "legendhelms_southern_cloth_headress_" + variant + "_dead";
		this.m.Icon = "helmets/inventory_southern_cloth_headress_" + variant + ".png";
		this.m.IconLarge = this.m.Icon;
	}

});

