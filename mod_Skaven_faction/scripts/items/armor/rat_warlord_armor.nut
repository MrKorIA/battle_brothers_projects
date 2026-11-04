this.rat_warlord_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.updateVariant();
		this.m.ID = "armor.body.rat_warlord_armor";
		this.m.Name = "Броня вождя скавенов";
		this.m.Description = "";
		this.m.IconLarge = "";
		this.m.Icon = "";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Condition = 170;
		this.m.ConditionMax = 170;
		this.m.StaminaModifier = -8;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_rat_warlord_armor_01";
		this.m.SpriteDamaged = "bust_rat_warlord_armor_01_damaged";
		this.m.SpriteCorpse = "bust_rat_warlord_armor_01_dead";
	}

});

