this.xxhero_elf_background <- this.inherit("scripts/skills/backgrounds/xxhero_background", {
	m = {},
	function create()
	{
		this.xxhero_background.create();
		this.m.Faces = this.Const.Faces.SmartMale;
		this.m.Hairs = null;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = null;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.BeardChance = 0;
		this.m.Names = this.Const.Strings.AncientDeadNames;
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");
		local pp = this.Math.rand(0, 3)
		if (pp == 1)
		{
			tattoo_body.setBrush("warpaint_01_" + actor.getSprite("body").getBrush().Name);
			tattoo_body.Visible = true;
			tattoo_head.setBrush("warpaint_01_head");
			tattoo_head.Visible = true;
		}
		else
		if (pp == 2)
		{
			tattoo_body.setBrush("tattoo_02_" + actor.getSprite("body").getBrush().Name);
			tattoo_body.Visible = true;
			tattoo_head.setBrush("tattoo_02_head");
			tattoo_head.Visible = true;
		}
		local hair_type = [
			"04",
			"10",
			"19",
			"21",
			"southern_03"
		];
		actor.getSprite("hair").setBrush("hair_" + this.Const.HairColors.All[this.Math.rand(0, this.Const.HairColors.All.len() - 1)] + "_" + hair_type[this.Math.rand(0, hair_type.len() - 1)]);
		actor.getSprite("accessory_special").setBrush("ear_elf");
	}

});

