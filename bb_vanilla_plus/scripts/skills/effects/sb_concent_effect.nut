this.sb_concent_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 2
	},
	function create()
	{
		this.m.ID = "effects.sb_concent_effect";
		this.m.Name = "Концентрация";
		this.m.Description = "+50% урон. +20 к навыку ближнего боя. +20 к навыку дальнего боя. -50% к затратам навыка на усталость. Удалена штрафная усталость от атак противника.";
		this.m.Icon = "ui/perks/perk_36.png";
		this.m.IconMini = "perk_36_mini";
		this.m.Overlay = "perk_36";
		this.m.SoundOnUse = [
			"sounds/combat/rage_01.wav",
			"sounds/combat/rage_02.wav"
		];
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Actor, this.getContainer().getActor().getPos(), this.Math.rand(100, 115) * 0.01 * this.getContainer().getActor().getSoundPitch());
	}

	function onTargetMissed( _skill, _targetEntity )
	{
		this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.Actor, this.getContainer().getActor().getPos(), this.Math.rand(100, 115) * 0.01 * this.getContainer().getActor().getSoundPitch());
	}

	function onUpdate( _properties )
	{
		_properties.DamageTotalMult += 0.5;
		_properties.MeleeSkill += 20;
		_properties.RangedSkill += 20;
		_properties.FatigueEffectMult *= 0.5;
		_properties.FatigueReceivedPerHitMult *= 0;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		if (actor.hasSprite("permanent_injury_xx1"))
		{
			actor.getSprite("permanent_injury_xx1").Visible = false;
			actor.removeSprite("permanent_injury_xx1");
		}
		actor.addSprite("permanent_injury_xx1");
		actor.getSprite("permanent_injury_xx1").setBrush("zombie_rage_eyes");
		actor.getSprite("permanent_injury_xx1").Visible = true;
		actor.getSprite("permanent_injury_xx1").Color = this.createColor("#502ebf");
		actor.getSprite("permanent_injury_xx1").Saturation = 0.8;
		if (actor.hasSprite("arms_icon"))
		{
			actor.removeSprite("arms_icon");
			actor.addSprite("arms_icon")
			actor.getItems().updateAppearance();
		}
	}

	function onTurnEnd()
	{
		this.m.TurnsLeft = this.m.TurnsLeft - 1
		if (this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();
		if (actor.hasSprite("permanent_injury_xx1"))
		{
			actor.getSprite("permanent_injury_xx1").Visible = false;
			actor.removeSprite("permanent_injury_xx1");
		}
	}

});

