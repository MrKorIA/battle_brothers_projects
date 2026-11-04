this.cp_wooden_torch_blueprint_02 <- this.inherit("scripts/crafting/blueprint", {
	m = {},
	function create()
	{
		this.blueprint.create();
		this.m.ID = "blueprint.cp_wooden_torch_02";
		this.m.PreviewCraftable = ::new("scripts/items/tools/cp_wooden_torch");
		this.m.Cost = 25;

		local ingredients = [
			{
				Script = "scripts/items/weapons/wooden_stick",
				Num = 1,
			},
			{
				Script = "scripts/items/misc/spider_silk_item",
				Num = 1,
			},
		];
		this.init(ingredients);
	}

	function onCraft( _stash )
	{
		_stash.add(::new("scripts/items/tools/cp_wooden_torch"));
	}
});
