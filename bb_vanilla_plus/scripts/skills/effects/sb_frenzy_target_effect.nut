this.sb_frenzy_target_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.sb_frenzy_target_effect";
		this.m.Name = "Безумная ярость (Кастер)";
		this.m.Description = "-50% ко всем характеристикам. Этот эффект действует до конца сражения.";
		this.m.Icon = "skills/status_effect_02_a.png";
		this.m.IconMini = "status_effect_02_a_mini";
		this.m.Overlay = "status_effect_02_a";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function onUpdate( _properties )
	{
		_properties.HitpointsMult *= 0.5;
		_properties.StaminaMult *= 0.5;
		_properties.BraveryMult *= 0.5;
		_properties.InitiativeMult *= 0.5;
		_properties.MeleeSkillMult *= 0.5;
		_properties.RangedSkillMult *= 0.5;
		_properties.MeleeDefenseMult *= 0.5;
		_properties.RangedDefenseMult *= 0.5;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		actor.addSprite("permanent_injury_frz1t");
		actor.getSprite("permanent_injury_frz1t").setBrush("bust_slave_whipped_expiring");
		actor.getSprite("permanent_injury_frz1t").Visible = true;

	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();
		if (actor.hasSprite("permanent_injury_frz1t"))
		{
			actor.getSprite("permanent_injury_frz1t").Visible = false;
			actor.removeSprite("permanent_injury_frz1t");
		}
	}

});

