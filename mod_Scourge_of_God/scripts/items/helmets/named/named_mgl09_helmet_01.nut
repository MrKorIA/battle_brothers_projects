this.named_mgl09_helmet_01 <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create();
		this.m.ID = "armor.head.named_mgl09_helmet_01";
		this.m.Description = "Легенда гласит, что жил когда-то воин, чье мастерство в стрельбе из лука было столь велико, что сам Хан нарёк его Джэбэ.";
		this.m.Name = "Джэбэ";
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 7000;
		this.m.Condition = 285;
		this.m.ConditionMax = 285;
		this.m.StaminaModifier = -20;
		this.randomizeValues();
	}

   function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_helmet_mgl09_" + variant;
		this.m.SpriteDamaged = "bust_helmet_mgl09_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_helmet_mgl09_" + variant + "_dead";
		this.m.IconLarge = "";
		this.m.Icon = "helmets/icon_bust_helmet_mgl09_" + variant + ".png";
	}
	
});

