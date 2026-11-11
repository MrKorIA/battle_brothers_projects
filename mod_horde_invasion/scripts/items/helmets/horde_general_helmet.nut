this.horde_general_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.horde_general";
		this.m.Name = "Шлем генерала Великой Орды";
		this.m.Description = "Изящный и вместе с тем прочный шлем иноземного генерала Великой Орды.";
		this.m.ShowOnCharacter = true;
		this.m.HideCharacterHead = false;
		this.m.HideCorpseHead = false;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.IsDroppedAsLoot = true;
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 4000;
		this.m.Condition = 240;
		this.m.ConditionMax = 240;
		this.m.StaminaModifier = -16;
		this.m.Vision = -1;
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "horde_general_helm_" + variant;
		this.m.SpriteDamaged = "horde_general_helm_" + variant + "_damaged";
		this.m.SpriteCorpse = "horde_general_helm_" + variant + "_dead";
		this.m.IconLarge = "";
		this.m.Icon = "helmets/icon_horde_general_helmet_" + variant + ".png";
	}
});

