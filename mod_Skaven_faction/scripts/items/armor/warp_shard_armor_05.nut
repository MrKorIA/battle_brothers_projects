this.warp_shard_armor_05 <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.updateVariant();
		this.m.ID = "armor.body.warp_shard_armor_05";
		this.m.Name = "Модифицированная броня из варп-осколков";
		this.m.Description = "Броня из шипованных пластин, инкрустированных осколками чистого варп-камня. Которая защищает владельца от вреда посредством силы варп-камня.";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 4200;
		this.m.Condition = 265;
		this.m.ConditionMax = 265;
		this.m.StaminaModifier = -35;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_warp_shard_armor_04";
		this.m.SpriteDamaged = "bust_warp_shard_armor_04_damaged";
		this.m.SpriteCorpse = "bust_warp_shard_armor_04_dead";
		this.m.IconLarge = "armor/inventory_warp_shard_armor_04.png";
		this.m.Icon = "armor/icon_warp_shard_armor_04.png";
	}
});

