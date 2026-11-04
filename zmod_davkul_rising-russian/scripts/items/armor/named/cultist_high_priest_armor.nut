this.cultist_high_priest_armor <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.cultist_high_priest_armor";
		this.m.Description = "Сверкающие доспехи верховного жреца культистов.";
		this.m.Sprite = "high_priest_armor";
		this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Cultist

		this.m.NameList = [
			"Питомец Давкула", "Объятия тьмы", "Многообразие еретика", "Оплот тёмного бога", "Нечистая страж", "Тёмный лабиринт", "Покров мертвеца"
		];
		this.m.Name = this.Math.randArray(this.m.NameList)
		this.m.SpriteDamaged = this.m.Sprite + "_damaged"
		this.m.SpriteCorpse = this.m.Sprite + "_dead"
		this.m.IconLarge = "";
		this.m.Icon = "armors/named/high_priest_armor_icon.png";
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 9000;
		this.m.Condition = 260;
		this.m.ConditionMax = 260;
		this.m.StaminaModifier = -15;
	}
	function createRandomName()
	{
		return this.Math.randArray(this.m.NameList)
	}
	
	function updateVariant()
	{

	}
});

