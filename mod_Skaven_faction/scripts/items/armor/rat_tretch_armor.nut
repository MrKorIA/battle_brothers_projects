this.rat_tretch_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.updateVariant();
		this.m.ID = "armor.body.rat_tretch_armor";
		this.m.Name = "Крысиная броня Треча";
		this.m.Description = "";
		this.m.IconLarge = "";
		this.m.Icon = "";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Condition = 150;
		this.m.ConditionMax = 150;
		this.m.StaminaModifier = -9;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_rat_tretch_armor_01";
		this.m.SpriteDamaged = "bust_rat_tretch_armor_01_damaged";
		this.m.SpriteCorpse = "bust_rat_tretch_armor_01_dead";
	}

});

