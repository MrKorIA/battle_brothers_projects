this.bear_hide_upgrade_blueprint <- this.inherit("scripts/crafting/blueprint", {
	m = {},
	function create()
	{
		this.blueprint.create();
		this.m.ID = "blueprint.bear_hide_upgrade";
		this.m.PreviewCraftable = this.new("scripts/items/armor_upgrades/bear_hide_upgrade");
		this.m.Cost = 500;
		local ingredients = [
			{
				Script = "scripts/items/misc/bear_hide_item",
				Num = 2
			}
		];
		this.init(ingredients);
	}

	function onCraft( _stash )
	{
		_stash.add(this.new("scripts/items/armor_upgrades/bear_hide_upgrade"));
	}

});

