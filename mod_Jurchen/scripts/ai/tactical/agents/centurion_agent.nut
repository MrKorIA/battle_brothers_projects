this.centurion_agent <- this.inherit("scripts/ai/tactical/agents/bandit_melee_agent", {
	function onAddBehaviors()
	{
		this.bandit_melee_agent.onAddBehaviors();
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_rally"));
	}
});

