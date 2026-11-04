this.wang_agent <- this.inherit("scripts/ai/tactical/agents/ghoul_agent", {
	function onAddBehaviors()
	{
		this.ghoul_agent.onAddBehaviors();
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_thresh"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_warcry"));
	}
});

