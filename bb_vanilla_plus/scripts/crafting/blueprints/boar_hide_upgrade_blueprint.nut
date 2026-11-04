this.boar_hide_upgrade_blueprint <- this.inherit("scripts/crafting/blueprint", {
	m = {},
	function create()
	{
		this.blueprint.create();
		this.m.ID = "blueprint.boar_hide_upgrade";
		this.m.PreviewCraftable = this.new("scripts/items/armor_upgrades/boar_hide_upgrade");
		this.m.Cost = 300;
		local ingredients = [
			{
				Script = "scripts/items/misc/boar_hide_item",
				Num = 1
			},
			{
				Script = "scripts/items/misc/ankheg_shell_item",
				Num = 2
			}
		];
		this.init(ingredients);
	}

	function onCraft( _stash )
	{
		_stash.add(this.new("scripts/items/armor_upgrades/boar_hide_upgrade"));
	}

});

