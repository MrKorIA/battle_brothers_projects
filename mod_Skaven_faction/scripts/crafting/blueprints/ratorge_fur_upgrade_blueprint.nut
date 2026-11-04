this.ratorge_fur_upgrade_blueprint <- this.inherit("scripts/crafting/blueprint", {
	m = {},
	function create()
	{
		this.blueprint.create();
		this.m.ID = "blueprint.ratorge_fur_upgrade";
		this.m.PreviewCraftable = this.new("scripts/items/armor_upgrades/ratorge_fur_upgrade");
		this.m.Cost = 500;
		local ingredients = [
			{
				Script = "scripts/items/misc/ratorge_fur_item",
				Num = 2
			}
		];
		this.init(ingredients);
	}

	function onCraft( _stash )
	{
		_stash.add(this.new("scripts/items/armor_upgrades/ratorge_fur_upgrade"));
	}

});

