this.perk_legend_spawn_zombie_med <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.legend_spawn_zombie_med";
		this.m.Name = this.Const.Strings.PerkName.LegendSpawnZombieMed;
		this.m.Description = this.Const.Strings.PerkDescription.LegendSpawnZombieMed;
		this.m.Icon = "ui/perks/fashion_body_circle.png";
		this.m.IconDisabled = "ui/perks/fashion_body_circle_bw.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
		if (!this.m.Container.hasSkill("actives.legend_spawn_zombie_med"))
		{
            local stash = this.World.Assets.getStash();
            stash.add(this.new("scripts/items/misc/legend_zombie_item"));
            stash.add(this.new("scripts/items/misc/legend_zombie_item"));
            stash.add(this.new("scripts/items/misc/legend_zombie_item"));
			this.m.Container.add(::new("scripts/skills/actives/legend_spawn_zombie_med_skill"));
		}
	}

	function onRemoved()
	{
		this.m.Container.removeByID("actives.legend_spawn_zombie_med");
	}

});
