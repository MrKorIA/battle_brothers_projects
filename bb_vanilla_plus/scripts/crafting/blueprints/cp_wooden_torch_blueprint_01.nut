this.cp_wooden_torch_blueprint_01 <- this.inherit("scripts/crafting/blueprint", {
	m = {},
	function create()
	{
		this.blueprint.create();
		this.m.ID = "blueprint.cp_wooden_torch_01";
		this.m.PreviewCraftable = ::new("scripts/items/tools/cp_wooden_torch");
		this.m.Cost = 25;

		local ingredients = [
			{
				Script = "scripts/items/weapons/wooden_stick",
				Num = 1,
			},
			{
				Script = "scripts/items/accessory/bandage_item",
				Num = 2,
			},
		];
		this.init(ingredients);
	}

	function onCraft( _stash )
	{
		_stash.add(::new("scripts/items/tools/cp_wooden_torch"));
	}
});
