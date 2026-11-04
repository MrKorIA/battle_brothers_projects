this.human_tretch_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.updateVariant();
		this.m.ID = "armor.body.human_tretch_armor";
		this.m.Name = "Модифицированная броня Треча Трусливого Хвоста";
		this.m.Description = "Эта броня когда-то принадлежала Тречу Трусливому Хвосту, \'Великому Вождю Глубинных Нор\', но была модифицирована для использования человеком.";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 1450;
		this.m.Condition = 125;
		this.m.ConditionMax = 125;
		this.m.StaminaModifier = -9;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_human_tretch_armor";
		this.m.SpriteDamaged = "bust_human_tretch_armor_damaged";
		this.m.SpriteCorpse = "bust_human_tretch_armor_dead";
		this.m.IconLarge = "armor/inventory_human_tretch_armor.png";
		this.m.Icon = "armor/icon_human_tretch_armor.png";
	}
});

