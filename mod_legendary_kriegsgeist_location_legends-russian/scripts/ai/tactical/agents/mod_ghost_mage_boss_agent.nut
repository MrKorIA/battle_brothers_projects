this.mod_ghost_mage_boss_agent <- ::inherit("scripts/ai/tactical/agent", {
	m = {},
	function create()
	{
		this.agent.create();
		this.m.ID = ::Const.AI.Agent.ID.Ghost;
		this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.EngageMelee] = 0.0;
		this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.Defend] = 1.0;
		this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.AttackDefault] = 2.5;
		this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.MirrorImage] = 5.0;
		this.m.Properties.TargetPriorityHitchanceMult = 0.0;
		this.m.Properties.TargetPriorityHitpointsMult = 0.5;
		this.m.Properties.TargetPriorityRandomMult = 0.0;
		this.m.Properties.TargetPriorityMoraleMult = 0.25;
		this.m.Properties.TargetPriorityBraveryMult = 0.25;
		this.m.Properties.TargetPriorityHittingAlliesMult = 1.0;
		this.m.Properties.OverallDefensivenessMult = 2.0;
		this.m.Properties.OverallFormationMult = 1.0;
		this.m.Properties.EngageRangeMin = 3;
		this.m.Properties.EngageRangeMax = 8;
		this.m.Properties.EngageRangeIdeal = 3;
		this.m.Properties.IsRangedUnit = true;
	}

	function onAddBehaviors()
	{
		this.addBehavior(::new("scripts/ai/tactical/behaviors/ai_engage_ranged"));
		this.addBehavior(::new("scripts/ai/tactical/behaviors/ai_attack_default"));
		this.addBehavior(::new("scripts/ai/tactical/behaviors/ai_disengage"));
		this.addBehavior(::new("scripts/ai/tactical/behaviors/ai_defend"));
		this.addBehavior(::new("scripts/ai/tactical/behaviors/ai_defend_rotation"));
		this.addBehavior(::new("scripts/ai/tactical/behaviors/ai_defend_knock_back"));
		this.addBehavior(::new("scripts/ai/tactical/behaviors/ai_always_use"));

		this.addBehavior(::new("scripts/ai/tactical/behaviors/mod_ai_hallucinate"));
		this.addBehavior(::new("scripts/ai/tactical/behaviors/mod_ai_mass_miasma"));
		this.addBehavior(::new("scripts/ai/tactical/behaviors/mod_ai_mass_root"));
		this.addBehavior(::new("scripts/ai/tactical/behaviors/mod_ai_illusion_teleport"));
		this.addBehavior(::new("scripts/ai/tactical/behaviors/mod_ai_spawn_ghost_illusion"));
		this.addBehavior(::new("scripts/ai/tactical/behaviors/mod_ai_counter_player_animals"));
	}

	function onUpdate()
	{
		local strategy = ::Tactical.Entities.getStrategy(this.getActor().getFaction());
		//::Const.AI.VerboseMode = true;

		if (!::Tactical.State.isAutoRetreat() && !strategy.getStats().IsEngaged && ::Time.getRound() <= 1)
		{
			this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.Root] = 0.0;
			this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.Miasma] = 0.0;
			this.m.Properties.EngageRangeIdeal = 8;
			this.m.Properties.EngageTileLimit = 0;
			this.m.Properties.PreferWait = true;
		}
		else
		{
			this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.Root] = 1.0;
			this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.Miasma] = 1.0;
			this.m.Properties.EngageRangeIdeal = 3;
			this.m.Properties.EngageTileLimit = 0;
			this.m.Properties.PreferWait = false;
		}
	}

});

