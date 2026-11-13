this.named_rf_halberd <- ::inherit("scripts/items/weapons/named/named_weapon", {
	m = {},
	function create()
	{
		this.named_weapon.create();
		this.m.Variant = ::Math.rand(1, 3);
		this.updateVariant();
		this.m.ID = "weapon.named_rf_halberd";
		this.m.NameList = ::Const.Strings.AxeNames;
		this.m.Description = "Лезвие этой искусно выкованной алебарды создано для сражений, его мощь позволяет завершить бой одним ударом.";
		this.m.Value = 4600;
		this.m.BaseItemScript = "scripts/items/weapons/rf_halberd";
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/rf_halberd_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/rf_halberd_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_rf_halberd_named_0" + this.m.Variant;
	}

	// No need to define onEquip because skills are copied from base weapon definition due to BaseItemScript
});
