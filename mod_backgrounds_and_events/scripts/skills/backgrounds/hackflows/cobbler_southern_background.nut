this.cobbler_southern_background <- this.inherit("scripts/skills/backgrounds/hackflows/cobbler_background", {
	m = {},
	function create()
	{
		this.cobbler_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernMale;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.BeardChance = 90;
		this.m.Ethnicity = 1;
		this.m.Excluded = [
			"trait.bloodthirsty",
			"trait.brute",
			"trait.cocky",
			"trait.clumsy",
			"trait.hate_beasts",
			"trait.huge",
			"trait.impatient"
		];
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onAddEquipment()
    {
        local items = this.getContainer().getActor().getItems();
        local r;
        r = this.Math.rand(0, 2);

        if (r == 0)
        {
            items.equip(this.new("scripts/items/armor/linen_tunic"));
        }
        else
        {
            items.equip(this.new("scripts/items/armor/oriental/cloth_sash"));
        }

        r = this.Math.rand(1, 4);

        if (r == 1)
        {
            items.equip(this.new("scripts/items/helmets/feathered_hat"));
        }
        else if (r == 2)
        {
            items.equip(this.new("scripts/items/helmets/oriental/southern_head_wrap"));
        }
    }

});
