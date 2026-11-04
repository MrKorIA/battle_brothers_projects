this.ratorge_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "armor.body.ratorge_armor";
		this.m.Name = "Броня крысоогра";
		this.m.Description = "";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = false;
		this.m.ShowOnCharacter = true;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorUnholdImpact;
		this.m.InventorySound = this.Const.Sound.ArmorUnholdImpact;
		this.m.Value = 0;
		this.m.Condition = 200;
		this.m.ConditionMax = 200;
		this.m.StaminaModifier = -10;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_armored_ratorge_body_01";
		this.m.SpriteDamaged = "bust_armored_ratorge_body_01_damaged";
		this.m.SpriteCorpse = "bust_armored_ratorge_body_01_dead";
	}

});

