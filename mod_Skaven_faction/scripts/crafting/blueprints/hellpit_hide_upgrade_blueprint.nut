this.hellpit_hide_upgrade_blueprint <- this.inherit("scripts/crafting/blueprint", {
	m = {},
	function create()
	{
		this.blueprint.create();
		this.m.ID = "blueprint.hellpit_hide_upgrade";
		this.m.PreviewCraftable = this.new("scripts/items/armor_upgrades/hellpit_hide_upgrade");
		this.m.Cost = 300;
		local ingredients = [
			{
				Script = "scripts/items/misc/hellpit_hide_item",
				Num = 2
			},
			{
				Script = "scripts/items/misc/wolfrat_pelt_item",
				Num = 1
			}
		];
		this.init(ingredients);
	}

	function onCraft( _stash )
	{
		_stash.add(this.new("scripts/items/armor_upgrades/hellpit_hide_upgrade"));
	}

});

