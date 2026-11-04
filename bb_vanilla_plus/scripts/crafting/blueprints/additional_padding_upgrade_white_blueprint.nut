this.additional_padding_upgrade_white_blueprint <- this.inherit("scripts/crafting/blueprint", {
	m = {},
	function create()
	{
		this.blueprint.create();
		this.m.ID = "blueprint.additional_padding_upgrade_white";
		this.m.PreviewCraftable = this.new("scripts/items/armor_upgrades/additional_padding_upgrade");
		this.m.Cost = 400;
		local ingredients = [
			{
				Script = "scripts/items/misc/frost_unhold_fur_item",
				Num = 1
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
		_stash.add(this.new("scripts/items/armor_upgrades/additional_padding_upgrade"));
	}

});

