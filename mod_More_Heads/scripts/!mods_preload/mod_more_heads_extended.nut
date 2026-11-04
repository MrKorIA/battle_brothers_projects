// More Heads Extended v2.0.4 - mod entry point
//
// Original More Heads worked by OVERWRITING vanilla files (character_heads,
// human, every humans/*.nut, every *_background.nut). This conflicted with
// Reforged and Hardened, which hook the same files.
//
// This rewrite uses Modern Hooks (the system Reforged and Hardened use) to
// LAYER our changes on top of whatever vanilla + Reforged + Hardened did.

::MoreHeadsExtended <- {
	ID = "mod_more_heads_extended",
	Version = "2.0.4",
	Name = "More Heads Extended"
};

::MoreHeadsExtended.HooksMod <- ::Hooks.register(
	::MoreHeadsExtended.ID,
	::MoreHeadsExtended.Version,
	::MoreHeadsExtended.Name
);
::MoreHeadsExtended.HooksMod.require("mod_modern_hooks >= 0.4.10");

// Load AFTER everything that might touch the same files. The leading ">"
// means "after this mod IF present" — absent mods are tolerated. We list
// Hardened too so our appearance overrides land last in the hook chain.
::MoreHeadsExtended.HooksMod.queue(
	[">vanilla", ">mod_reforged", ">mod_msu", ">mod_hardened", ">mod_backgrounds_and_events", ">mod_jin", ">mod_wushi"],
	function() {
		::include("mod_more_heads_extended/const_extensions.nut");
		::include("mod_more_heads_extended/hooks/human.nut");
		::include("mod_more_heads_extended/hooks/humans.nut");
		::include("mod_more_heads_extended/hooks/backgrounds.nut");
	}
);
