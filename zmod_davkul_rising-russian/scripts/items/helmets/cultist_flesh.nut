this.cultist_flesh <- ::inherit("scripts/items/helmets/helmet", {
	m = {
	},
	function create()
	{
		this.helmet.create();
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.ReplaceSprite = true;
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Cultist
	}

	function updateVariant()
	{
		local getVariant = function(){
			local variant = this.Math.rand(1, this.m.MaxVariant)
			return variant < 10 ? "0" + variant : variant
		}
		local variant = this.m.Variant = getVariant()
		this.m.Sprite = this.m.VariantString + variant;
		this.m.SpriteDamaged = this.m.Sprite + "_damaged";
		this.m.SpriteCorpse = this.m.Sprite + "_dead";
		this.m.IconLarge = "";
		this.m.Icon = "helmets/" + this.m.VariantString + variant + "_icon.png";
	}
});

