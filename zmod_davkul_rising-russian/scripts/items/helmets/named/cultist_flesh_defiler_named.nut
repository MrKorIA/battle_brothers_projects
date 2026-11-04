this.cultist_flesh_defiler_named <- this.inherit("scripts/items/helmets/named/cultist_flesh_named", {
	m = {},
	function create()
	{
		this.cultist_flesh_named.create();
		this.m.ID = "armor.head.cultist_flesh_defiler_named";
		this.m.Name = "Плотный капюшон культиста";
		this.m.Description = "Ужасающий капюшон, сделанный из кожи жертв.";
		this.m.VariantString = "named_defiler_hood_"
		this.m.NameList = [
			"Маска осквернителя", "Вуаль страданий", "Плачущие объятия", "Нечистый лик", "Плоть сломленного", "Бич зла", "Полутенистая мантия", "Корона магистра", "Капюшон предателя"
		];
		this.m.MaxVariant <- 2
		this.updateVariant();
		this.m.Value = 6000;
		this.m.Condition = 270;
		this.m.ConditionMax = 270;
		this.m.StaminaModifier = -18;
		this.m.Vision = -3;
		this.randomizeValues();
	}

});

