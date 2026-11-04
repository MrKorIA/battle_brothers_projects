this.legend_warlock_cloak_blueprint <- this.inherit("scripts/crafting/blueprint", {
	m = {},
	function create()
	{
		this.blueprint.create();
		this.m.ID = "blueprint.legend_warlock_cloak";
		this.m.PreviewCraftable = this.new("scripts/items/armor_upgrades/legend_armor_named_warlock_cloak");
		this.m.Cost = 2000;
		local ingredients = [
			{
				Script = "scripts/items/misc/witch_hair_item",
				Num = 4
			},
			{
				Script = "scripts/items/misc/parched_skin_item",
				Num = 4
			},
			{
				Script = "scripts/items/misc/legend_zombie_item",
				Num = 1
			}
		];
		this.init(ingredients);
	}

	function onCraft( _stash )
	{
		_stash.add(this.new("scripts/items/armor_upgrades/legend_armor_named_warlock_cloak"));
	}

});

