this.legend_mummy_crown_king <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.legend_mummy_crown_king";
        this.m.Name = "Погребальный венец";
        this.m.Description = "Головной убор с древнего забальзамированного тела.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = false;
		this.m.HideHair = false;
		this.m.HideBeard = false;
		this.m.ReplaceSprite = true;
		local variants = [
			1
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 1000;
		this.m.Condition = 150;
		this.m.ConditionMax = 150;
		this.m.StaminaModifier = -2;
		this.m.Vision = 0;
	}


	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "legendhelms_mummy_crown_king_" + variant;
		this.m.SpriteDamaged = "legendhelms_mummy_crown_king_" + variant + "_damaged";
		this.m.SpriteCorpse = "legendhelms_mummy_crown_king_" + variant + "_dead";
		this.m.IconLarge = "legend_helmets/inventory_mummy_crown_king_" + variant + ".png";
		// this.m.Icon = "armor/icon_body_armor_" + variant + ".png";
	}

	function onEquip()
    {
    	this.helmet.onEquip();
    	local actor = this.getContainer().getActor();
    	local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;

        if (actor.getSprite("hair") != null)
        {
            actor.getSprite("hair").setBrush("mummy_bandage_" + variant);
        }
    }

});

