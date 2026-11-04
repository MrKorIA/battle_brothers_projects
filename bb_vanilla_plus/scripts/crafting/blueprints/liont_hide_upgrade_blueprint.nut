this.liont_hide_upgrade_blueprint <- this.inherit("scripts/crafting/blueprint", {
	m = {},
	function create()
	{
		this.blueprint.create();
		this.m.ID = "blueprint.liont_hide_upgrade";
		this.m.PreviewCraftable = this.new("scripts/items/armor_upgrades/lion_hide_upgrade");
		this.m.Cost = 500;
		local ingredients = [
			{
				Script = "scripts/items/misc/leon_hide_item",
				Num = 2
			},
			{
				Script = "scripts/items/misc/tiger_hide_item",
				Num = 1
			}
		];
		this.init(ingredients);
	}

	function onCraft( _stash )
	{
		_stash.add(this.new("scripts/items/armor_upgrades/lion_hide_upgrade"));
	}

});

