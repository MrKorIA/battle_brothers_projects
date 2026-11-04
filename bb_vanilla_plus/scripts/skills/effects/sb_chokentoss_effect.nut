this.sb_chokentoss_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.sb_chokentoss_effect";
		this.m.Name = "Выбранная цель (Силовой бросок)";
		this.m.Description = "Становится приоритетной целью для навыка «Силовой бросок».";
		this.m.Icon = "skills/status_effect_52.png";
		this.m.IconMini = "status_effect_52_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsSerialized = false;
		this.m.IsActive = false;
		this.m.IsHidden = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function onTurnEnd()
	{
		this.removeSelf();
	}

	function onTurnStart()
	{
		this.removeSelf();
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		actor.addSprite("permanent_injury_toss1").setBrush("bust_arrow");
		actor.getSprite("permanent_injury_toss1").Visible = true;
		actor.getSprite("permanent_injury_toss1").Scale = 0.9;
		actor.getSprite("permanent_injury_toss1").Color = this.createColor("#ff6a19");
		actor.setSpriteOffset("permanent_injury_toss1", this.createVec(30, 15));
		actor.getSprite("permanent_injury_toss1").Rotation = -45.0;
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();
		if (actor.hasSprite("permanent_injury_toss1"))
		{
			actor.getSprite("permanent_injury_toss1").Visible = false;
			actor.removeSprite("permanent_injury_toss1");
		}
	}

});

