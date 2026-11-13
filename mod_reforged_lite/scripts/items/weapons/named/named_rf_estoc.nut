this.named_rf_estoc <- ::inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "weapon.named_rf_estoc";
		this.m.NameList = ::Const.Strings.FencingSwordNames;
		this.m.Description = "Хорошо выкованный эсток требует длины и прочности, совмещённой с лёгкостью, дабы наносить быстрые и ловкие удары. Этот клинок - один из лучших образцов, которые вы когда-либо видели.";
		this.m.Value = 4200;
		this.m.BaseItemScript = "scripts/items/weapons/rf_estoc";
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/rf_estoc_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/rf_estoc_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_rf_estoc_named_0" + this.m.Variant;
	}

	// No need to define onEquip because skills are copied from base weapon definition due to BaseItemScript
});
