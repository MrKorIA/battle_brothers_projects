this.sb_unlrage_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 3
	},
	function create()
	{
		this.m.ID = "effects.sb_unlrage_effect";
		this.m.Name = "Выпустите ярость";
		this.m.Description = "+30% Урон в ближнем бою, на 30% меньше получаемого урона";
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

	function onUpdate( _properties )
	{
		_properties.MeleeDamageMult += 0.3;
		_properties.DamageReceivedTotalMult *= 0.7;
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
		actor.getSprite("permanent_injury_xx1").Color = this.createColor("#f6ff00");
		actor.getSprite("permanent_injury_xx1").Saturation = 5.5;
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

