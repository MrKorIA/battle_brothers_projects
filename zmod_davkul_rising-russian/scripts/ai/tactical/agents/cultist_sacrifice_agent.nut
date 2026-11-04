this.cultist_sacrifice_agent <- this.inherit("scripts/ai/tactical/agent", {
	m = {},
	function create()
	{
		this.agent.create();
		this.m.ID = this.Const.AI.Agent.ID.SkeletonMelee;
		this.m.Properties.BehaviorMult[this.Const.AI.Behavior.ID.ModDavkulSacrificeStick] = 100;
		this.m.Properties.TargetPriorityMoraleMult = 0.25;
		this.m.Properties.OverallMagnetismMult = 0.1
		this.m.Properties.TargetPriorityBraveryMult = 0.25;
		this.m.Properties.OverallDefensivenessMult = 1.0;
		this.m.Properties.OverallFormationMult = 1.0;
		this.m.Properties.EngageTileLimit = 0;
		this.m.Properties.IgnoreTargetValueOnEngage = true;
		this.m.Properties.PreferWait = true;
	}

	function onAddBehaviors()
	{
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_break_free"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_glue_to_prophet"));
	}

	function onUpdate()
	{
		this.setEngageRangeBasedOnWeapon();
	}

});

