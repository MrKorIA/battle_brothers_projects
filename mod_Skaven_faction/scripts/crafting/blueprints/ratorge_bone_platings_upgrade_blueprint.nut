this.ratorge_bone_platings_upgrade_blueprint <- this.inherit("scripts/crafting/blueprint", {
	m = {},
	function create()
	{
		this.blueprint.create();
		this.m.ID = "blueprint.ratorge_bone_platings_upgrade";
		this.m.PreviewCraftable = this.new("scripts/items/armor_upgrades/ratorge_bone_platings_upgrade");
		this.m.Cost = 450;
		local ingredients = [
			{
				Script = "scripts/items/misc/hellpit_bones_item",
				Num = 1
			},
			{
				Script = "scripts/items/misc/ratorge_bones_item",
				Num = 1
			}
		];
		this.init(ingredients);
	}

	function onCraft( _stash )
	{
		_stash.add(this.new("scripts/items/armor_upgrades/ratorge_bone_platings_upgrade"));
	}

});

