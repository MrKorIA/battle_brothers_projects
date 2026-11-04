this.ai_pain_effect <- this.inherit("scripts/skills/skill", {
	m = {
		Damage = 5
	},
	function getDamage()
	{
		return this.m.Damage;
	}

	function setDamage( _d )
	{
		this.m.Damage = _d;
	}

	function create()
	{
		this.m.ID = "effects.bleeding";
		this.m.Name = "Боль";
		this.m.Icon = "skills/status_effect_01.png";
		this.m.IconMini = "status_effect_01_mini";
		this.m.Overlay = "status_effect_01";
		this.m.Type = this.Const.SkillType.StatusEffect | this.Const.SkillType.DamageOverTime;
		this.m.IsActive = false;
		this.m.IsStacking = true;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Этот персонаж проиграет [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.Damage + "[/color] очков здоровья в начале следующего хода. Этот эффект классифицируется как кровотечение, но не приводит к смерти.";
	}

	function onNewRound()
	{
		local actor = this.getContainer().getActor();
		local indure = 0;
		local dmg = this.m.Damage;
		if (actor.isAlive() && actor.getCurrentProperties().DamageReceivedTotalMult > 0)
		{
			if (actor.getCurrentProperties().IsResistantToAnyStatuses && this.Math.rand(1, 100) <= 50)
			{
				indure = 1;
			}
			if (actor.getCurrentProperties().NegativeStatusEffectDuration < 0 || actor.getCurrentProperties().IsImmuneToBleeding)
			{
				indure = 1;
			}
			if (indure == 0)
			{
				if (!actor.isHiddenToPlayer())
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " потеря " + dmg + " здоровье из-за болевого эффекта.");
				}
			}
			else
			{
				dmg = this.Math.max(this.m.Damage / 2, 1)
				if (!actor.isHiddenToPlayer())
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " потеря " + dmg + " здоровье из-за болевого эффекта. (Применены эффекты сопротивления)");
				}
			}
			actor.setHitpoints(this.Math.max(actor.getHitpoints() - dmg, 1));
		}
		this.removeSelf();
	}

	function onTurnStart()
	{
		local actor = this.getContainer().getActor();
		local indure = 0;
		local dmg = this.m.Damage;
		if (actor.isAlive() && actor.getCurrentProperties().DamageReceivedTotalMult > 0)
		{
			if (actor.getCurrentProperties().IsResistantToAnyStatuses && this.Math.rand(1, 100) <= 50)
			{
				indure = 1;
			}
			if (actor.getCurrentProperties().NegativeStatusEffectDuration < 0 || actor.getCurrentProperties().IsImmuneToBleeding)
			{
				indure = 1;
			}
			if (indure == 0)
			{
				if (!actor.isHiddenToPlayer())
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " lost " + dmg + " здоровье из-за болевого эффекта.");
				}
			}
			else
			{
				dmg = this.Math.max(this.m.Damage / 2, 1)
				if (!actor.isHiddenToPlayer())
				{
					this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " lost " + dmg + " здоровье из-за болевого эффекта. (Применены эффекты сопротивления)");
				}
			}
			actor.setHitpoints(this.Math.max(actor.getHitpoints() - dmg, 1));
		}
		this.removeSelf();
	}

});

