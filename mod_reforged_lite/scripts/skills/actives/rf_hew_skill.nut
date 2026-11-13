this.rf_hew_skill <- ::inherit("scripts/skills/actives/chop", {
	m = {
		// ReachAdd не переносим (система досягаемости Reforged отсутствует в lite)
	},
	function create()
	{
		this.chop.create();
		// We keep the ID the same as chop as this
		// skill is basically the same thing.

		this.m.Name = "Подсечка";
		this.m.Icon = "skills/rf_poleaxe_hew_skill.png";
		this.m.IconDisabled = "skills/rf_poleaxe_hew_skill_sw.png";
		this.m.Overlay = "rf_poleaxe_hew_skill";
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 15;
	}
});
