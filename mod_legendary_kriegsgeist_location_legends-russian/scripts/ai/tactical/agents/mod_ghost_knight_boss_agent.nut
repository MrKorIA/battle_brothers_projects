this.mod_ghost_knight_boss_agent <- ::inherit("scripts/ai/tactical/agent", {
	m = {},
	function create()
	{
		this.agent.create();
		this.m.ID = ::Const.AI.Agent.ID.Ghost;
		this.m.Properties.TargetPriorityHitchanceMult = 0.5;
		this.m.Properties.TargetPriorityHitpointsMult = 0.25;
		this.m.Properties.TargetPriorityRandomMult = 0.0;
		this.m.Properties.TargetPriorityDamageMult = 0.0;
		this.m.Properties.TargetPriorityFleeingMult = 1.0;
		this.m.Properties.TargetPriorityHittingAlliesMult = 0.1;
		this.m.Properties.TargetPriorityFinishOpponentMult = 2.75;
		this.m.Properties.TargetPriorityCounterSkillsMult = 0.5;
		this.m.Properties.TargetPriorityArmorMult = 2.0;
		this.m.Properties.TargetPriorityMoraleMult = 0.25;
		this.m.Properties.TargetPriorityBraveryMult = 0.25;
		this.m.Properties.OverallDefensivenessMult = 0.5;
		this.m.Properties.OverallFormationMult = 0.5;
		this.m.Properties.EngageWhenAlreadyEngagedMult = 0.0;
		this.m.Properties.EngageTargetMultipleOpponentsMult = 1.0;
		this.m.Properties.EngageOnGoodTerrainBonusMult = 1.0;
		this.m.Properties.EngageOnBadTerrainPenaltyMult = 1.0;
		this.m.Properties.EngageAgainstSpearwallMult = 0.25;
		this.m.Properties.EngageAgainstSpearwallWithShieldwallMult = 0.25;
		this.m.Properties.EngageTargetArmedWithRangedWeaponMult = 1.0;
		this.m.Properties.EngageTargetAlreadyBeingEngagedMult = 1.0;
		this.m.Properties.EngageLockDownTargetMult = 1.0;
		this.m.Properties.EngageRangeMin = 1;
		this.m.Properties.EngageRangeMax = 2;
		this.m.Properties.EngageRangeIdeal = 1;
		this.m.Properties.EngageEnemiesInLinePreference = 2;
		this.m.Properties.PreferCarefulEngage = true;
	}

	function onAddBehaviors()
	{
		this.addBehavior(::new("scripts/ai/tactical/behaviors/ai_engage_melee"));
		this.addBehavior(::new("scripts/ai/tactical/behaviors/ai_attack_default"));
		this.addBehavior(::new("scripts/ai/tactical/behaviors/ai_attack_split"));
		this.addBehavior(::new("scripts/ai/tactical/behaviors/ai_attack_swing"));
		this.addBehavior(::new("scripts/ai/tactical/behaviors/ai_disengage"));
		this.addBehavior(::new("scripts/ai/tactical/behaviors/ai_defend"));
		this.addBehavior(::new("scripts/ai/tactical/behaviors/ai_defend_rotation"));
		this.addBehavior(::new("scripts/ai/tactical/behaviors/ai_defend_knock_back"));
		this.addBehavior(::new("scripts/ai/tactical/behaviors/ai_always_use"));

		this.addBehavior(::new("scripts/ai/tactical/behaviors/mod_ai_ghost_teleport"));
		this.addBehavior(::new("scripts/ai/tactical/behaviors/mod_ai_ghost_passive_teleport"));
		this.addBehavior(::new("scripts/ai/tactical/behaviors/mod_ai_spawn_ghost_fragment"));
	}

	function onUpdate()
	{
		local strategy = ::Tactical.Entities.getStrategy(this.getActor().getFaction());

		if (::Tactical.State.isAutoRetreat() && !strategy.getStats().IsEngaged && ::Time.getRound() <= 1)
		{
			this.m.Properties.EngageTileLimit = 0;
			this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.Darkflight] = 0.0;
			this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.EngageMelee] = 0.0;
			this.m.Properties.PreferWait = true;
		}
		else
		{
			this.m.Properties.EngageTileLimit = 0;
			this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.Darkflight] = 1.0;
			this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.EngageMelee] = 0.5;
			this.m.Properties.PreferWait = false;
		}
	}

});

