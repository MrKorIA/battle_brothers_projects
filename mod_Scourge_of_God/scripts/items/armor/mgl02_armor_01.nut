this.mgl02_armor_01 <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.mgl02_armor_01";
		this.m.Name = "Степной ламелляр";
		this.m.Description = "Традиционный восточный доспех, собранный из сотен прочных стальных пластин, искусно переплетённых сыромятными кожаными шнурами поверх стёганого халата. Такая конструкция обеспечивает великолепную защиту от стрел и рубящих ударов, сохраняя подвижность.";
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 500;
		this.m.Condition = 120;
		this.m.ConditionMax = 120;
		this.m.StaminaModifier = -11;
	}

	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_body_mgl02_" + variant;
		this.m.SpriteDamaged = "bust_body_mgl02_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_body_mgl02_" + variant + "_dead";
		this.m.IconLarge = "armor/inventory_bust_body_mgl02_" + variant + ".png";
		this.m.Icon = "armor/icon_bust_body_mgl02_" + variant + ".png";
	}

});