this.ai_mortalwound_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 3
	},
	function create()
	{
		this.m.ID = "effects.ai_mortalwound_effect";
		this.m.Name = "Смертельная рана";
		this.m.Description = "Этот персонаж смертельно ранен."
		this.m.Icon = "skills/status_effect_02_a.png";
		this.m.IconMini = "status_effect_02_a_mini";
		this.m.Overlay = "status_effect_02_a";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_skill.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]-99%[/color] All stats except health. Unable to act"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.MeleeSkillMult *= 0.01;
		_properties.RangedSkillMult *= 0.01;
		_properties.MeleeDefenseMult *= 0.01;
		_properties.RangedDefenseMult *= 0.01;
		_properties.InitiativeMult *= 0.01;
		_properties.StaminaMult *= 0.01;
		_properties.BraveryMult *= 0.01;
		_properties.ActionPoints *= 0;
		_properties.IsAbleToUseSkills = false;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		actor.addSprite("permanent_injury_mortalwound1");
		actor.getSprite("permanent_injury_mortalwound1").setBrush("bust_slave_whipped_expiring");
		actor.getSprite("permanent_injury_mortalwound1").Visible = true;
		actor.getSprite("permanent_injury_mortalwound1").Scale = 1.4;
		actor.getSprite("permanent_injury_mortalwound1").Color = this.createColor("#d40000");
		if (actor.isAlliedWithPlayer())
		{
			actor.setSpriteOffset("permanent_injury_mortalwound1", this.createVec(-15, -10));
		}
		else
		{
			actor.setSpriteOffset("permanent_injury_mortalwound1", this.createVec(15, -10));
		}
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();
		if (actor.hasSprite("permanent_injury_mortalwound1"))
		{
			actor.getSprite("permanent_injury_mortalwound1").Visible = false;
			actor.removeSprite("permanent_injury_mortalwound1");
		}
	}

});

