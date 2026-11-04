this.ai_roc_effect <- this.inherit("scripts/skills/skill", {
	m = {	},
	function create()
	{
		this.m.ID = "effects.ai_roc_effect";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsAttack = false,
		this.m.IsStacking = false;
		this.m.IsHidden = true;
		this.m.IsRemovedAfterBattle = true;
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		_properties.IsImmuneToZoneOfControl = true;
		_properties.MovementFatigueCostMult *= 0;
		_properties.MovementAPCostAdditional = -1;
		actor.m.ActionPointCosts = this.Const.SameMovementAPCost;
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();
		if (!actor.hasSprite("scar_body"))
		{
			actor.addSprite("scar_body");
		}
		actor.getSprite("scar_body").setBrush("bust_wing_01");
		actor.getSprite("scar_body").Visible = true;
	}

	function onRemoved()
	{
		local actor = this.getContainer().getActor();
		if (actor.hasSprite("scar_body"))
		{
			actor.getSprite("scar_body").setBrush("");
		}
		if (actor.getSkills().hasSkill("perk.pathfinder"))
		{
			actor.m.ActionPointCosts = this.Const.PathfinderMovementAPCost;
		}
		else
		{
			actor.m.ActionPointCosts = this.Const.DefaultMovementAPCost;
		}
	}

	function onNewRound()
	{
		this.removeSelf();
	}

});

