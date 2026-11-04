this.xxhero_goblin_background <- this.inherit("scripts/skills/backgrounds/xxhero_background", {
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
		this.m.Names = this.Const.Strings.GoblinNames;
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local xhead = actor.getSprite("head");
		local xbody = actor.getSprite("body");
		xbody.setBrush("bust_naked_body_7871");
		xhead.setBrush("xxgoblin_head_" + this.Math.rand(100, 103));
		xbody.Saturation = 0.9;
		xbody.varySaturation(0.1);
		xbody.varyColor(0.025, 0.025, 0.025);
		xhead.Color = xbody.Color;
		xhead.Saturation = xbody.Saturation;
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

