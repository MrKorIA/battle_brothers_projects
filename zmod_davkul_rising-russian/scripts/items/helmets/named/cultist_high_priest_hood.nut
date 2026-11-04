this.cultist_high_priest_hood <- this.inherit("scripts/items/helmets/named/cultist_flesh_named", {
	m = {},
	function create()
	{
		this.cultist_flesh_named.create();
		this.m.ID = "armor.head.cultist_high_priest_hood";
		#this.m.Name = "Капюшон верховного жреца";
		this.m.Description = "Сверкающий капюшон верховного жреца культистов.";
		this.m.VariantString = ""
		this.m.Sprite = "high_priest_hood";
		this.m.NameList = [
			"Капюшон Давкула", "Зов тьмы", "Венец повелителя", "Взор еретика", "Суждение", "Капюшон инквизитора"
		];
		this.m.Name = this.Math.randArray(this.m.NameList)
		this.m.MaxVariant <- 1
		this.m.SpriteDamaged = this.m.Sprite + "_damaged"
		this.m.SpriteCorpse = this.m.Sprite + "_dead"
		this.m.IconLarge = "";
		this.m.Icon = "helmets/named/high_priest_hood_icon.png";
		this.m.Value = 6000;
		this.m.Condition = 260;
		this.m.ConditionMax = 260;
		this.m.StaminaModifier = -8;
		this.m.Vision = -3;
	}
	function createRandomName()
	{
		return this.Math.randArray(this.m.NameList)
	}

	function updateVariant()
	{

	}

});

