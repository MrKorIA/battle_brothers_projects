this.xxhero_lizard_background <- this.inherit("scripts/skills/backgrounds/xxhero_background", {
	m = {},
	function create()
	{
		this.xxhero_background.create();
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = null;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = null;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.BeardChance = 0;
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local xbody = actor.getSprite("body");
		local xhead = actor.getSprite("head");
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");
		xbody.setBrush("bust_naked_body_7890");
		xhead.setBrush("bust_head_791" + this.Math.rand(0, 5));
		if (this.Math.rand(1, 3) == 1)
		{
			tattoo_body.setBrush("tattoo_0" + this.Math.rand(2, 4) + "_bust_naked_body_02");
			tattoo_head.setBrush("tattoo_01_head");
			tattoo_body.Visible = true;
			tattoo_head.Visible = true;
			tattoo_body.Scale = 0.9;
			tattoo_head.Scale = 0.9;
		}
		xhead.varyColor(0.05, 0.05, 0.05);
		xbody.Color = xhead.Color;
	}

	function onAdded()
	{
		this.xxhero_background.onAdded();
		if (!this.getContainer().getActor().getSkills().hasSkill("effects.xxzzvoice_skill"))
		{
			local actor = this.getContainer().getActor();
			actor.getSkills().add(this.new("scripts/skills/actives/xxzzvoice_skill"));
			actor.getFlags().add("xxzzvoice_goblin");
		}
	}

});

