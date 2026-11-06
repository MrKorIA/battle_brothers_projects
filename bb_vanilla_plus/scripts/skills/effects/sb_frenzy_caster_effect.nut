this.sb_frenzy_caster_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.sb_frenzy_caster_effect";
		this.m.Name = "Безумная ярость";
		this.m.Description = "+15% ко всем характеристикам. +30% урона при атаке врагов в пределах 1 клетки. Этот эффект действует до конца боя.";
		this.m.Icon = "ui/perks/perk_36.png";
		this.m.IconMini = "perk_36_mini";
		this.m.Overlay = "perk_36";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function onUpdate( _properties )
	{
		_properties.HitpointsMult *= 1.15;
		_properties.StaminaMult *= 1.15;
		_properties.BraveryMult *= 1.15;
		_properties.InitiativeMult *= 1.15;
		_properties.MeleeSkillMult *= 1.15;
		_properties.RangedSkillMult *= 1.15;
		_properties.MeleeDefenseMult *= 1.15;
		_properties.RangedDefenseMult *= 1.15;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_targetEntity == null)
		{
			return;
		}

		if (_skill.isAttack())
		{
			local d = this.getContainer().getActor().getTile().getDistanceTo(_targetEntity.getTile());
			if (d == 1)
			{
				_properties.DamageTotalMult += 0.3;
			}
		}
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		if (actor.hasSprite("permanent_injury_frz1"))
		{
			actor.getSprite("permanent_injury_frz1").Visible = false;
			actor.removeSprite("permanent_injury_frz1");
		}
		actor.addSprite("permanent_injury_frz1");
		actor.getSprite("permanent_injury_frz1").setBrush("zombie_rage_eyes");
		actor.getSprite("permanent_injury_frz1").Visible = true;
		actor.getSprite("permanent_injury_frz1").Color = this.createColor("#00ff95");
		actor.getSprite("permanent_injury_frz1").Alpha = 155;
		if (actor.hasSprite("arms_icon"))
		{
			actor.removeSprite("arms_icon");
			actor.addSprite("arms_icon")
			actor.getItems().updateAppearance();
		}
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();
		if (actor.hasSprite("permanent_injury_frz1"))
		{
			actor.getSprite("permanent_injury_frz1").Visible = false;
			actor.removeSprite("permanent_injury_frz1");
		}
	}

});

