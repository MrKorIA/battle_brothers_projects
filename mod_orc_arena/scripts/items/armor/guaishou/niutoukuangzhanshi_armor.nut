this.niutoukuangzhanshi_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.updateVariant();
		this.m.ID = "armor.body.niutoukuangzhanshi_armor";
		this.m.Name = "Тяжёлый доспех";
		this.m.Description = "";
		this.m.IconLarge = "";
		this.m.Icon = "";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Condition = 600;
		this.m.ConditionMax = 600;
		this.m.StaminaModifier = -50;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_guaishou_01_armor_01";
		this.m.SpriteDamaged = "bust_guaishou_01_armor_01_damaged";
		this.m.SpriteCorpse = "bust_guaishou_01_armor_01_dead";
	}

});

