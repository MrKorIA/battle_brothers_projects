this.named_wushi_helmet22 <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.named_wushi_helmet22";
		this.m.Description = "Шлем, который носил знаменитый самурайский генерал.";
		this.m.Name = "Именной шлем";
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 7000;
		this.m.Condition = 180;
		this.m.ConditionMax = 180;
		this.m.StaminaModifier = -6;
		this.m.Vision = -2;
		this.randomizeValues();
	}



   function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_wushi_helmet22_" + variant;
		this.m.SpriteDamaged = "bust_wushi_helmet22_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_wushi_helmet22_" + variant + "_dead";
		this.m.IconLarge = "";
		this.m.Icon = "helmets/icon_wushi_helmet22_" + variant + ".png";
	}
	
	
});

