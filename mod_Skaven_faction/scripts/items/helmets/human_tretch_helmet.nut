this.human_tretch_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.updateVariant();
		this.m.ID = "armor.head.human_tretch_helmet";
		this.m.Name = "Шлем из \'Везучего Черепа\'";
		this.m.Description = "Шлем, сделанный из черепа побеждённого соперника, который может считаться своеобразным талисманом удачи.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 1800;
		this.m.Condition = 140;
		this.m.ConditionMax = 140;
		this.m.StaminaModifier = -6;
		this.m.Vision = -1;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_tretch_helmet_02";
		this.m.SpriteDamaged = "bust_tretch_helmet_02_damaged";
		this.m.SpriteCorpse = "bust_tretch_helmet_02_dead";
		this.m.IconLarge = "helmets/inventory_tretch_helmet.png";
		this.m.Icon = "helmets/inventory_tretch_helmet.png";
	}

});

