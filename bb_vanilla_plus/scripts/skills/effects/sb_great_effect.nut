this.sb_great_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 1
	},
	function create()
	{
		this.m.ID = "effects.sb_great_effect";
		this.m.Name = "Великое пробуждение";
		this.m.Description = "Стоимость AP навыка уменьшена вдвое";
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
		_properties.IsSkillUseHalfCost = true;
	}

	function onTurnEnd()
	{
		this.m.TurnsLeft = this.m.TurnsLeft - 1
		if (this.m.TurnsLeft <= 0)
		{
			this.removeSelf();
		}
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
		actor.getSprite("permanent_injury_xx1").Color = this.createColor("#00ffff");
		actor.getSprite("permanent_injury_xx1").Saturation = 1.1;
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
		if (actor.hasSprite("permanent_injury_xx1"))
		{
			actor.getSprite("permanent_injury_xx1").Visible = false;
			actor.removeSprite("permanent_injury_xx1");
		}
	}

});

