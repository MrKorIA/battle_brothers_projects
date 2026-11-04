this.ratorge_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.ratorge_helmet";
		this.m.Name = "Шлем крысоогра";
		this.m.Description = "";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = false;
		this.m.HideHair = false;
		this.m.HideBeard = false;
		this.m.HideCharacterHead = false;
		this.m.HideHelmetIfDestroyed = false;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorUnholdImpact;
		this.m.InventorySound = this.Const.Sound.ArmorUnholdImpact;
		this.m.Value = 0;
		this.m.Condition = 300;
		this.m.ConditionMax = 300;
		this.m.StaminaModifier = -10;
		this.m.Vision = 0;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_armored_ratorge_head_01";
		this.m.SpriteDamaged = "bust_armored_ratorge_head_01_damaged";
		this.m.SpriteCorpse = "bust_armored_ratorge_head_01_dead";
	}

});

