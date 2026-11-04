this.perk_legend_spawn_zombie_high <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.legend_spawn_zombie_high";
		this.m.Name = this.Const.Strings.PerkName.LegendSpawnZombieHigh;
		this.m.Description = this.Const.Strings.PerkDescription.LegendSpawnZombieHigh;
		this.m.Icon = "ui/perks/remake_man_circle.png";
		this.m.IconDisabled = "ui/perks/remake_man_circle.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAdded()
	{
        if (!this.m.Container.hasSkill("actives.legend_spawn_zombie_high"))
        {
            local stash = this.World.Assets.getStash();
            stash.add(this.new("scripts/items/misc/legend_zombie_item"));
            stash.add(this.new("scripts/items/misc/legend_zombie_item"));
            stash.add(this.new("scripts/items/misc/legend_zombie_item"));
            this.m.Container.add(::new("scripts/skills/actives/legend_spawn_zombie_high_skill"));
        }
	}

	function onRemoved()
	{
		this.m.Container.removeByID("actives.legend_spawn_zombie_high");
	}

});
