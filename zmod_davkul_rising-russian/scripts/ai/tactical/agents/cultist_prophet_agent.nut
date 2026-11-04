this.cultist_prophet_agent <- this.inherit("scripts/ai/tactical/agent", {
	m = {},
	function create()
	{
		this.agent.create();
		this.m.ID = this.Const.AI.Agent.ID.MilitaryMelee;

		this.m.Properties.TargetPriorityHitchanceMult = 0.4;
		this.m.Properties.TargetPriorityHitpointsMult = 0.25;
		this.m.Properties.TargetPriorityRandomMult = 0.0;
		this.m.Properties.TargetPriorityDamageMult = 0.35;
		this.m.Properties.TargetPriorityFleeingMult = 0.5;
		this.m.Properties.TargetPriorityHittingAlliesMult = 0.1;
		this.m.Properties.TargetPriorityFinishOpponentMult = 3.0;
		this.m.Properties.TargetPriorityCounterSkillsMult = 0.5;
		this.m.Properties.TargetPriorityArmorMult = 0.6;
		this.m.Properties.EngageTargetMultipleOpponentsMult = 1.25;
		this.m.Properties.EngageTargetAlreadyBeingEngagedMult = 0.5;

		this.m.Properties.OverallFormationMult = 1.5;
		this.m.Properties.OverallMagnetismMult = 3.0;
		this.m.Properties.TargetPriorityRandomMult = 0.0;
		this.m.Properties.OverallDefensivenessMult = 2.0
		this.m.Properties.BehaviorMult[this.Const.AI.Behavior.ID.Protect] = 0.0;
		this.m.Properties.BehaviorMult[this.Const.AI.Behavior.ID.EngageMelee] = 0.5
	}

	function onAddBehaviors()
	{
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_flee"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_retreat"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_engage_melee"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_defend"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_break_free"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_wake_up_ally"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_recover"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_default"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_move_into_support_range"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_defend_rotation"));
		//this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_engage_ranged_prophet"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_dark_chant"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_sacrifice_ally"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_disengage"));
	}

	function onUpdate()
	{
		this.setEngageRangeBasedOnWeapon();
	}

});

