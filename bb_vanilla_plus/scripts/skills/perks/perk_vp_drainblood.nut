this.perk_vp_drainblood <- this.inherit("scripts/skills/skill", {
    m = {}
    function create() {
        this.m.ID = "perk.vp.drainblood";
        local perk = ::Const.Perks.LookupMap[this.m.ID];
        this.m.Name = perk.Name;
        this.m.Description = perk.Tooltip;
        this.m.Icon = perk.Icon;
        this.m.IconDisabled = perk.IconDisabled;

        this.m.Type = this.Const.SkillType.Perk;
        this.m.Order = this.Const.SkillOrder.Perk;
    }

    function onAdded() {
        this.m.Container.add(::new("scripts/skills/actives/sb_drainblood_skill"));
    }
})
