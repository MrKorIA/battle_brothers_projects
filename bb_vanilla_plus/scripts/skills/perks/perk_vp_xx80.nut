this.perk_vp_xx80 <- this.inherit("scripts/skills/skill", {
    m = {}
    function create() {
        this.m.ID = "perk.vp.xx80";
        local perk = ::Const.Perks.LookupMap[this.m.ID];
        this.m.Name = perk.Name;
        this.m.Description = perk.Tooltip;
        this.m.Icon = perk.Icon;
        this.m.IconDisabled = perk.IconDisabled;

        this.m.Type = this.Const.SkillType.Perk;
        this.m.Order = this.Const.SkillOrder.Perk;
    }

    function onAdded() {
        this.m.Container.add(::new("scripts/skills/actives/sbq6_bigfire_skill"));
    }
})
