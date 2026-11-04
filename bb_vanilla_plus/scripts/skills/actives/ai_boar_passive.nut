this.ai_boar_passive <- this.inherit("scripts/skills/skill", {
	m = {
		Rage = 0
	},
	function create()
	{
		this.m.ID = "effects.ai_boar_passive";
		this.m.Name = "Шипастая шкура";
		this.m.Description = "";
		this.m.Icon = "";
		this.m.Type = this.Const.SkillType.Racial | this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.Last;
		this.m.IsSerialized = false;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
    {
        if (this.m.Rage < 5 && _damageHitpoints > 4 && _attacker != null && this.getContainer().getActor() != null)
        {
            local at = _attacker;
            local ac = this.getContainer().getActor();
            local d = at.getTile().getDistanceTo(ac.getTile());

            if (at.isAlive() && ac.isAlive() && at.getID() != ac.getID() && at.getHitpoints() > 0 && d == 1 && !at.getCurrentProperties().IsImmuneToDamageReflection)
            {
                this.m.Rage = this.m.Rage + 1;

                if (at.getArmor(this.Const.BodyPart.Body) > 20)
                {
					local hitInfo = clone ::Const.Tactical.HitInfo;

					hitInfo.DamageRegular = 0;                      // Урон по здоровью равен НУЛЮ
					hitInfo.DamageArmor = ::Math.rand(8, 15);       // Случайный урон по броне
					hitInfo.DamageDirect = 0.0;                     // Никакого пробития брони
					hitInfo.BodyPart = ::Const.BodyPart.Body;       // Бьем туда, где есть броня
					hitInfo.BodyDamageMult = 1.0;
					hitInfo.FatalityChanceMult = 0.0;
					hitInfo.Injuries = null;                        // Никаких травм доспеху
					hitInfo.DamageType = ::Const.Damage.DamageType.Blunt; // Тип урона (Дробящий/Удар о шипы)

					at.onDamageReceived(ac, null, hitInfo);

					if (!ac.isHiddenToPlayer() && ac.getTile().IsVisibleForPlayer)
					{
						this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(at) + " мнет доспехи об острые шипы " + this.Const.UI.getColorizedEntityName(ac));
					}
                }
                else
                {
                    local effect = this.new("scripts/skills/effects/bleeding_effect");
                    effect.setDamage(this.Math.rand(1, 4));
                    at.getSkills().add(effect);

                    if (!ac.isHiddenToPlayer() && ac.getTile().IsVisibleForPlayer)
                    {
                        this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(at) + " начинает истекать кровью, напоровшись на шипы " + this.Const.UI.getColorizedEntityName(ac));
                    }
                }
            }
        }
    }

	function onNewRound()
	{
		this.m.Rage = 0;
	}

});

