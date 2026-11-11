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

// Варп-огонь: как обычный огонь, но урон по ОЗ/броне и длительность удвоены
::Const.Tactical.Common.onApplyWarpFire <- function( _tile, _entity )
{
    if (_entity.getCurrentProperties().IsImmuneToFire)
    {
        return;
    }

    this.Tactical.spawnIconEffect("status_effect_116", _tile, this.Const.Tactical.Settings.SkillIconOffsetX, this.Const.Tactical.Settings.SkillIconOffsetY, this.Const.Tactical.Settings.SkillIconScale, this.Const.Tactical.Settings.SkillIconFadeInDuration, this.Const.Tactical.Settings.SkillIconStayDuration, this.Const.Tactical.Settings.SkillIconFadeOutDuration, this.Const.Tactical.Settings.SkillIconMovement);
    local sounds = [
        "sounds/combat/dlc6/status_on_fire_01.wav",
        "sounds/combat/dlc6/status_on_fire_02.wav",
        "sounds/combat/dlc6/status_on_fire_03.wav"
    ];
    this.Sound.play(sounds[this.Math.rand(0, sounds.len() - 1)], this.Const.Sound.Volume.Actor, _entity.getPos());
    local damageMult = _entity.getCurrentProperties().DamageReceivedFireMult;
    local damage = this.Math.rand(30, 60);
    local hitInfo = clone this.Const.Tactical.HitInfo;
    hitInfo.DamageRegular = damage * damageMult;
    hitInfo.DamageArmor = damage;
    hitInfo.DamageDirect = 0.1;
    hitInfo.BodyPart = this.Const.BodyPart.Body;
    hitInfo.BodyDamageMult = 1.0;
    hitInfo.FatalityChanceMult = 0.0;
    hitInfo.Injuries = this.Const.Injury.Burning;
    hitInfo.IsPlayingArmorSound = false;
    _entity.onDamageReceived(_entity, null, hitInfo);
}

// Взрыв варп-огня: урон всем актёрам на тайле и соседних
::Const.Tactical.Common.spawnWarpExplosion <- function( _tile, _damage )
{
    if (_tile == null)
    {
        return;
    }

    this.Tactical.getCamera().quake(this.createVec(0, -1.0), 6.0, 0.16, 0.35);
    this.Sound.play("sounds/combat/dlc6/fire_mortar_impact_01.wav", 1.0, _tile.Pos);

    for (local i = 0; i < this.Const.Tactical.WarpFireParticles.len(); i = ++i)
    {
        local effect = this.Const.Tactical.WarpFireParticles[i];
        this.Tactical.spawnParticleEffect(true, effect.Brushes, _tile, effect.Delay, effect.Quantity * 2, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 0));
    }

    local tiles = [
        _tile
    ];

    for (local i = 0; i < 6; i = ++i)
    {
        if (_tile.hasNextTile(i))
        {
            tiles.push(_tile.getNextTile(i));
        }
    }

    foreach( t in tiles )
    {
        if (!t.IsOccupiedByActor)
        {
            continue;
        }

        local target = t.getEntity();

        if (!target.isAttackable() || !target.isAlive() || target.isDying())
        {
            continue;
        }

        local hitInfo = clone this.Const.Tactical.HitInfo;
        hitInfo.DamageRegular = _damage;
        hitInfo.DamageArmor = _damage;
        hitInfo.DamageDirect = 0.25;
        hitInfo.BodyPart = this.Const.BodyPart.Body;
        hitInfo.BodyDamageMult = 1.0;
        hitInfo.FatalityChanceMult = 0.0;
        hitInfo.Injuries = this.Const.Injury.Burning;
        target.onDamageReceived(null, null, hitInfo);
    }
}
