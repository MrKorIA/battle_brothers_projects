this.rat_plague_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 6,
		Damage = 2,
		LastRoundApplied = 0
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
		this.m.ID = "effects.rat_plague";
		this.m.Name = "Чума";
		this.m.KilledString = "Умер от чумы";
		this.m.Icon = "skills/rat_status_effect_01.png";
		this.m.IconMini = "rat_status_effect_01_mini";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc2/giant_spider_poison_01.wav",
			"sounds/enemies/dlc2/giant_spider_poison_02.wav"
		];
		this.m.Type = this.Const.SkillType.StatusEffect | this.Const.SkillType.DamageOverTime;
		this.m.IsActive = false;
		this.m.IsStacking = true;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Тело этого персонажа было обрызгано чумной кровью крысы, что вызывает заражение организма болезнью ещё на [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] ход(ов).";
	}

	function resetTime()
	{
		this.m.TurnsLeft = this.Math.max(1, 6 + this.getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);

		if (this.m.SoundOnUse.len() != 0)
		{
			this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect * 1.25, this.getContainer().getActor().getPos());
		}
	}

	function applyDamage()
	{
		if (this.m.LastRoundApplied != this.Time.getRound())
		{
			this.m.LastRoundApplied = this.Time.getRound();
			local actor = this.getContainer().getActor();
			local body_affected = !actor.getFlags().has("rat");
			local damage_applied = false;
			this.spawnIcon("rat_status_effect_01", this.getContainer().getActor().getTile());

			if (this.m.SoundOnUse.len() != 0)
			{
				this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect * 1.0, this.getContainer().getActor().getPos());
			}

			if (body_affected)
			{
				local damage = actor.getArmor(this.Const.BodyPart.Body) * 0.0;
				local hitInfo = clone this.Const.Tactical.HitInfo;
				hitInfo.DamageRegular = this.m.Damage;
				hitInfo.DamageDirect = 1.0;
				hitInfo.BodyPart = this.Const.BodyPart.Body;
				hitInfo.BodyDamageMult = 1.0;
				hitInfo.FatalityChanceMult = 0.0;
				this.getContainer().getActor().onDamageReceived(this.getContainer().getActor(), this, hitInfo);
			}

			if (damage_applied && !actor.isHiddenToPlayer())
			{
				if (this.m.SoundOnUse.len() != 0)
				{
					this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect * 1.2, actor.getPos());
				}
			}
		}
	}

	function onAdded()
	{
		this.m.TurnsLeft = this.Math.max(1, 6 + this.getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);

		if (this.m.SoundOnUse.len() != 0)
		{
			this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect * 1.25, this.getContainer().getActor().getPos());
		}

		if (!this.getContainer().getActor().isHiddenToPlayer())
		{
			this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(this.getContainer().getActor()) + " был обрызган чумной кровью крысы");
		}

	}

	function onTurnEnd()
	{
		this.applyDamage();

		if (--this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

	function onWaitTurn()
	{
		this.applyDamage();
	}
});

