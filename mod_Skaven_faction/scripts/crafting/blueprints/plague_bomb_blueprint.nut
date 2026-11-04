this.plague_bomb_blueprint <- this.inherit("scripts/crafting/blueprint", {
	m = {},
	function create()
	{
		this.blueprint.create();
		this.m.ID = "blueprint.plague_bomb";
		this.m.PreviewCraftable = this.new("scripts/items/tools/plague_bomb_item");
		this.m.Cost = 100;
		local ingredients = [
			{
				Script = "scripts/items/misc/rat_blood_item",
				Num = 3
			}
		];
		this.init(ingredients);
	}

	function onCraft( _stash )
	{
		_stash.add(this.new("scripts/items/tools/plague_bomb_item"));
	}

});

