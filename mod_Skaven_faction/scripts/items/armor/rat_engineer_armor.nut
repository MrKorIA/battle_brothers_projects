this.rat_engineer_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.updateVariant();
		this.m.ID = "armor.body.rat_engineer_armor";
		this.m.Name = "Броня варп-инженера крыс";
		this.m.Description = "";
		this.m.IconLarge = "";
		this.m.Icon = "";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.Condition = 60;
		this.m.ConditionMax = 60;
		this.m.StaminaModifier = -8;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_rat_enginer_armor_01";
		this.m.SpriteDamaged = "bust_rat_enginer_armor_01_damaged";
		this.m.SpriteCorpse = "bust_rat_enginer_armor_01_dead";
	}

});
