this.perk_legend_throw_sand <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.legend_throw_sand";
		this.m.Name = "";
		this.m.Description = "";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsHidden = true;
		this.m.IsActive = false;
		this.m.IsStacking = false;
	}

	function onAdded()
	{
        if (!this.m.Container.hasSkill("actives.throw_dirt"))
        {
            this.m.Container.add(this.new("scripts/skills/actives/throw_dirt_skill"));
        }
	}

});

