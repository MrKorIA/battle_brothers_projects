this.wolf_black_white_hide_upgrade_blueprint <- this.inherit("scripts/crafting/blueprint", {
	m = {},
	function create()
	{
		this.blueprint.create();
		this.m.ID = "blueprint.wolf_black_white_hide_upgrade";
		this.m.PreviewCraftable = this.new("scripts/items/armor_upgrades/direwolf_pelt_upgrade");
		this.m.Cost = 250;
		local ingredients = [
			{
				Script = "scripts/items/misc/werewolf_pelt_item",
				Num = 2
			},
			{
				Script = "scripts/items/misc/white_wolf_hide_item",
				Num = 1
			}
		];
		this.init(ingredients);
	}

	function onCraft( _stash )
	{
		_stash.add(this.new("scripts/items/armor_upgrades/direwolf_pelt_upgrade"));
	}

});

