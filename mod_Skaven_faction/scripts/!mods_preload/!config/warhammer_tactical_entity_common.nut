::Const.Tactical.Common.onApplyPlagueCloud <- function( _tile, _entity )
{

    if (_entity.getFlags().has("rat"))
    {
        return;
    }

    if (_entity.getCurrentProperties().IsImmuneToPlague)
    {
        return;
    }

    this.Tactical.spawnIconEffect("rat_status_effect_01", _tile, this.Const.Tactical.Settings.SkillIconOffsetX, this.Const.Tactical.Settings.SkillIconOffsetY, this.Const.Tactical.Settings.SkillIconScale, this.Const.Tactical.Settings.SkillIconFadeInDuration, this.Const.Tactical.Settings.SkillIconStayDuration, this.Const.Tactical.Settings.SkillIconFadeOutDuration, this.Const.Tactical.Settings.SkillIconMovement);

    local sounds = [
        "sounds/enemies/dlc2/giant_spider_poison_01.wav",
        "sounds/enemies/dlc2/giant_spider_poison_02.wav"
    ];
    this.Sound.play(sounds[this.Math.rand(0, sounds.len() - 1)], this.Const.Sound.Volume.Actor, _entity.getPos());

    _entity.getSkills().add(this.new("scripts/skills/effects/rat_plague_effect"));

}
