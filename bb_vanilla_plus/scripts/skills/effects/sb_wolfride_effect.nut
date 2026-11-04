this.sb_wolfride_effect <- this.inherit("scripts/skills/skill", {
	m = {
		TurnsLeft = 3
	},
	function create()
	{
		this.m.ID = "effects.sb_wolfride_effect";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
		this.m.IsRemovedAfterBattle = true;
	}

	function onUpdate( _properties )
	{
		_properties.MovementAPCostAdditional -= 1;
		_properties.MovementFatigueCostMult *= 0;
		_properties.MeleeDefense -= 10;
		_properties.RangedDefense -= 10;
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
		local variant = this.Math.rand(1, 2);
		local offset = this.createVec(15, -22);
		local offsetb = this.createVec(10, -25);
		local scaleb = 1.11
		actor.addSprite("permanent_injury_wolfride1");
		actor.getSprite("permanent_injury_wolfride1").setHorizontalFlipping(true);
		actor.getSprite("permanent_injury_wolfride1").setBrush("bust_wolf_0" + variant + "_body");
		actor.getSprite("permanent_injury_wolfride1").Visible = true;
		actor.setSpriteOffset("permanent_injury_wolfride1", offsetb);
		actor.getSprite("permanent_injury_wolfride1").Scale = scaleb;
		actor.addSprite("permanent_injury_wolfride2");
		actor.getSprite("permanent_injury_wolfride2").setHorizontalFlipping(true);
		actor.getSprite("permanent_injury_wolfride2").setBrush("bust_wolf_0" + variant + "_head");
		actor.getSprite("permanent_injury_wolfride2").Visible = true;
		actor.setSpriteOffset("permanent_injury_wolfride2", offset);
		if (actor.getLevel() >= 10)
		{
			local offset2 = this.createVec(21, -20);
			actor.addSprite("permanent_injury_wolfride3").setHorizontalFlipping(true);
			actor.getSprite("permanent_injury_wolfride3").setBrush("bust_direwolf_03_head_frenzy");
			actor.getSprite("permanent_injury_wolfride3").Visible = true;
			actor.setSpriteOffset("permanent_injury_wolfride3", offset2);
		}
		actor.addSprite("permanent_injury_wolfride4");
		actor.getSprite("permanent_injury_wolfride4").setHorizontalFlipping(true);
		actor.getSprite("permanent_injury_wolfride4").setBrush("bust_wolf_02_armor_01");
		actor.getSprite("permanent_injury_wolfride4").Visible = true;
		actor.setSpriteOffset("permanent_injury_wolfride4", offset);
		if (actor.hasSprite("arms_icon"))
		{
			actor.removeSprite("arms_icon");
			actor.addSprite("arms_icon")
			actor.getItems().updateAppearance();
		}
		actor.setAlwaysApplySpriteOffset(true);
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();
		if (actor.hasSprite("permanent_injury_wolfride1"))
		{
			actor.getSprite("permanent_injury_wolfride1").Visible = false;
			actor.removeSprite("permanent_injury_wolfride1");
		}
		if (actor.hasSprite("permanent_injury_wolfride2"))
		{
			actor.getSprite("permanent_injury_wolfride2").Visible = false;
			actor.removeSprite("permanent_injury_wolfride2");
		}
		if (actor.hasSprite("permanent_injury_wolfride3"))
		{
			actor.getSprite("permanent_injury_wolfride3").Visible = false;
			actor.removeSprite("permanent_injury_wolfride3");
		}
		if (actor.hasSprite("permanent_injury_wolfride4"))
		{
			actor.getSprite("permanent_injury_wolfride4").Visible = false;
			actor.removeSprite("permanent_injury_wolfride4");
		}
	}

});

