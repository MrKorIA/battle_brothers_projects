this.master_southern_archer_background <- this.inherit("scripts/skills/backgrounds/hackflows/master_archer_background", {
	m = {},
	function create()
	{
		this.master_archer_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernMale;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.BeardChance = 90;
		this.m.Ethnicity = 1;
		this.m.Excluded = [
			"trait.clubfooted",
			"trait.clumsy",
			"trait.fear_beasts",
			"trait.hesitant",
			"trait.impatient",
			"trait.tough"
		];
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onAddEquipment()
    {
        local items = this.getContainer().getActor().getItems();
        local r;
        items.equip(this.new("scripts/items/weapons/oriental/composite_bow"));

        r = this.Math.rand(0, 0);

        if (r == 0)
        {
            items.equip(this.new("scripts/items/shields/oriental/southern_light_shield"));
        }

        r = this.Math.rand(0, 3);

        if (r == 0)
        {
            items.equip(this.new("scripts/items/armor/oriental/nomad_robe"));
        }
        else if (r == 1)
        {
            items.equip(this.new("scripts/items/armor/oriental/thick_nomad_robe"));
        }
        else if (r == 2)
        {
            items.equip(this.new("scripts/items/armor/oriental/stitched_nomad_armor"));
        }
        else if (r == 3)
        {
            items.equip(this.new("scripts/items/armor/oriental/leather_nomad_robe"));
        }

        r = this.Math.rand(0, 3);

        if (r == 0)
        {
            items.equip(this.new("scripts/items/helmets/oriental/nomad_head_wrap"));
        }
        else if (r == 1)
        {
            items.equip(this.new("scripts/items/helmets/oriental/nomad_leather_cap"));
        }
        else if (r == 2)
        {
            items.equip(this.new("scripts/items/helmets/oriental/nomad_light_helmet"));
        }
    }

});
