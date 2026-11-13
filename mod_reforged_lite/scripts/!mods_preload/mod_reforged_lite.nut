::ReforgedLite <- {
	ID = "mod_reforged_lite",
	Name = "Reforged Lite",
	Version = "0.1.0",
	__IsDuringGetRumor = false
}

::ReforgedLite.HooksMod <- ::Hooks.register(::ReforgedLite.ID, ::ReforgedLite.Version, ::ReforgedLite.Name);
::ReforgedLite.HooksMod.require(["mod_msu", "mod_modern_hooks", "mod_nested_tooltips"]);

::ReforgedLite.HooksMod.queue(">mod_msu", ">mod_modern_hooks", ">mod_nested_tooltips", function() {
	::ReforgedLite.Mod <- ::MSU.Class.Mod(::ReforgedLite.ID, ::ReforgedLite.Version, ::ReforgedLite.Name);
	::include("mod_reforged_lite/load");
});
