this.companions_xxmob_toad_agent <- this.inherit("scripts/companions/types/companions_nacho_agent", {
	m = {},
	function create()
	{
		this.companions_nacho_agent.create();
		this.m.Properties.EngageRangeMax = 3;
		this.m.Properties.EngageRangeIdeal = 3;
	}

	function onAddBehaviors()
	{
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_flee"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_engage_melee"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_break_free"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_default"));
	}

	function onUpdate()
	{
		if (this.getActor().getHitpointsPct() < 1.0 && this.Math.rand(1, 100) <= 25)
		{
			this.m.Properties.EngageAgainstSpearwallMult = 1.5;
		}
		else
		{
			this.m.Properties.EngageAgainstSpearwallMult = 1.25;
		}

		this.getStrategy().compileKnownOpponents();
	}
});
