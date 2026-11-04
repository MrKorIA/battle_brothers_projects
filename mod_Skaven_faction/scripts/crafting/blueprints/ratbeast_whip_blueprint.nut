this.ratbeast_whip_blueprint <- this.inherit("scripts/crafting/blueprint", {
	m = {},
	function create()
	{
		this.blueprint.create();
		this.m.ID = "blueprint.ratbeast_whip";
		this.m.PreviewCraftable = this.new("scripts/items/weapons/craftable_ratbeast_whip");
		this.m.Cost = 500;
		local ingredients = [
			{
				Script = "scripts/items/misc/hellpit_hide_item",
				Num = 1
			},
			{
				Script = "scripts/items/misc/hellpit_tail_item",
				Num = 1
			}
		];
		this.init(ingredients);
	}

	function onCraft( _stash )
	{
		_stash.add(this.new("scripts/items/weapons/craftable_ratbeast_whip"));
	}

});

