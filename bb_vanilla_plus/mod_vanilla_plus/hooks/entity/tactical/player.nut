::VanillaPlus.HooksMod.hook("scripts/entity/tactical/player", function(q) {

	q.onInit = @(__original) { function onInit()
	{
		__original();
		this.getSkills().add(::new("scripts/skills/special/vp_veteran_levels"));
	}}.onInit;

	// Demonologist path exclusion safety net: never let a blocked path perk be unlocked,
	// whatever path (UI dialog, autopilot). The tooltip lock lives in verifyPrerequisites
	// on the perk defs (see scripts/config/z_demon.nut).
	q.unlockPerk = @(__original) function (_id) {
		if (("Demon" in ::Const) && ::Const.Demon.isPerkBlocked(_id, this.getSkills())) return false;
		return __original(_id);
	}

});
