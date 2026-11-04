this.plague_cured_blueprint <- this.inherit("scripts/crafting/blueprint", {
	m = {},
	function create()
	{
		this.blueprint.create();
		this.m.ID = "blueprint.plague_cured";
		this.m.PreviewCraftable = this.new("scripts/items/accessory/plague_cured_item");
		this.m.Cost = 100;
		local ingredients = [
			{
				Script = "scripts/items/misc/rat_blood_item",
				Num = 2
			}
		];
		this.init(ingredients);
	}

	function onCraft( _stash )
	{
		_stash.add(this.new("scripts/items/accessory/plague_cured_item"));
	}

});

