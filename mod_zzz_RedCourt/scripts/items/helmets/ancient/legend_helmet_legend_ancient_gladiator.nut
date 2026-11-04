this.legend_helmet_legend_ancient_gladiator <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.legend_helmet_legend_ancient_gladiator";
        this.m.Name = "Древний шлем гладиатора";
        this.m.Description = "Шлем древнего гладиатора, отличающий его от остальных легионеров.";
		local variants = [1];
        this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 1200;
		this.m.Condition = 150;
		this.m.ConditionMax = 150;
		this.m.StaminaModifier = -11;
		this.m.Vision = -2;
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
        this.m.ItemType = this.m.ItemType;
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "legendhelms_legend_ancient_gladiator_" + variant;
		this.m.SpriteDamaged = "legendhelms_legend_ancient_gladiator_" + variant + "_damaged";
		this.m.SpriteCorpse = "legendhelms_legend_ancient_gladiator_" + variant + "_dead";
		this.m.Icon = "legend_helmets/inventory_legend_ancient_gladiator_" + variant + ".png";
        this.m.IconLarge = this.m.Icon;
	}
});