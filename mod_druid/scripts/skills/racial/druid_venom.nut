// Permanent envenomed bite for summoned beasts (and a Beastform druid). Built on the goblin
// ambusher's racial poison: a debilitating debuff (blurred sight, clumsy movement), not
// damage-over-time, applied by every biting hit and - unlike a poison coat - never depleting.
this.druid_venom <- this.inherit("scripts/skills/racial/goblin_ambusher_racial", {
    m = {},
    function create()
    {
        this.goblin_ambusher_racial.create();
        this.m.ID = "racial.druid_venom";
        this.m.Name = "Яд";
        this.m.Icon = "skills/status_effect_66.png";
        this.m.IconMini = "status_effect_66_mini";
        this.m.Type = this.Const.SkillType.Racial;
        this.m.Order = this.Const.SkillOrder.Last;
        this.m.IsRemovedAfterBattle = true;
        this.m.IsHidden = false;
    }

    function getDescription()
    {
        return "Этот хищник охотится, используя сочащиеся ядом клыки. Его укус отравляет жертву, затуманивая ей взор и замедляя движения до тех пор, пока действие токсина не иссякнет.";
    }
});
