this.rat_greyseer_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.updateVariant();
		this.m.ID = "armor.body.rat_greyseer_armor";
		this.m.Name = "Броня Серого Провидца скавенов";
		this.m.Description = "";
		this.m.IconLarge = "";
		this.m.Icon = "";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.Condition = 100;
		this.m.ConditionMax = 100;
		this.m.StaminaModifier = -8;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_rat_greyseer_armor_01";
		this.m.SpriteDamaged = "bust_rat_greyseer_armor_01_damaged";
		this.m.SpriteCorpse = "bust_rat_greyseer_armor_01_dead";
	}

});

