this.rat_packmaster_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.updateVariant();
		this.m.ID = "armor.body.rat_packmaster_armor";
		this.m.Name = "Броня крысиного хозяина стаи";
		this.m.Description = "";
		this.m.IconLarge = "";
		this.m.Icon = "";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.Condition = 70;
		this.m.ConditionMax = 70;
		this.m.StaminaModifier = -8;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_rat_packmaster_armor_01";
		this.m.SpriteDamaged = "bust_rat_packmaster_armor_01_damaged";
		this.m.SpriteCorpse = "bust_rat_packmaster_armor_01_dead";
	}

});

