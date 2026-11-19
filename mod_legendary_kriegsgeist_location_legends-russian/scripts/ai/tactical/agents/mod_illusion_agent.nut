this.mod_illusion_agent <- this.inherit("scripts/ai/tactical/agent", {
	m = {},
	function create()
	{
		this.agent.create();
		this.m.ID = ::Const.AI.Agent.ID.Idle;
		this.m.Properties.OverallMagnetismMult = 10.0;
		this.m.Properties.OverallDefensivenessMult = 20.0;
		this.m.Properties.OverallFormationMult = 10.0;
	}

	function onAddBehaviors()
	{
		this.addBehavior(::new("scripts/ai/tactical/behaviors/mod_ai_illusion_teleport"));
	}

	function onUpdate()
	{
	}

});

