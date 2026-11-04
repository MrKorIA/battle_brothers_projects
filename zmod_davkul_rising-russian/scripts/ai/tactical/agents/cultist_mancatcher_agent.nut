this.cultist_mancatcher_agent <- this.inherit("scripts/ai/tactical/agents/bandit_melee_agent", {
	m = {},
	function create()
	{
		this.bandit_melee_agent.create();
	}

	function onAddBehaviors()
	{
		this.bandit_melee_agent.onAddBehaviors()
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_catch_enemy"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_rattle_enemy"));
	}

});

