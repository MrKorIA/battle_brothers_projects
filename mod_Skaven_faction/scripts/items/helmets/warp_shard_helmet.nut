this.warp_shard_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.updateVariant();
		this.m.ID = "armor.head.warp_shard_helmet";
		this.m.Name = "Модифицированный шлем из Варп-Осколков";
		this.m.Description = "Шлем из шипованных пластин, инкрустированных осколками чистого варп-камня. Который защищает владельца от вреда посредством силы варп-камня.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 1700;
		this.m.Condition = 250;
		this.m.ConditionMax = 250;
		this.m.StaminaModifier = -16;
		this.m.Vision = -2;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_warp_shard_helmet";
		this.m.SpriteDamaged = "bust_warp_shard_helmet_damaged";
		this.m.SpriteCorpse = "bust_warp_shard_helmet_dead";
		this.m.IconLarge = "helmets/inventory_warp_shard_helmet.png";
		this.m.Icon = "helmets/inventory_warp_shard_helmet.png";
	}

});

