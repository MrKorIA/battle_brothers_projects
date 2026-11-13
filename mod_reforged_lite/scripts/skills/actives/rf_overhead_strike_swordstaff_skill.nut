this.rf_overhead_strike_swordstaff_skill <- ::inherit("scripts/skills/actives/overhead_strike", {
	m = {
		// ReachAdd не переносим (система досягаемости Reforged отсутствует в lite)
	},
	function create()
	{
		this.overhead_strike.create();
		this.m.IsIgnoredAsAOO = true;
	}
});
