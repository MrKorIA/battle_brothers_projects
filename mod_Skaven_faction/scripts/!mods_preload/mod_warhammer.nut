::TheSkaven <- {
	ID = "mod_warhammer",
	Name = "The Skaven",
	Version = "1.1.0",
	GitHubURL = "",
}

::TheSkaven.HooksMod <- ::Hooks.register(::TheSkaven.ID, ::TheSkaven.Version, ::TheSkaven.Name);
::TheSkaven.HooksMod.require(["mod_msu"]);

::TheSkaven.HooksMod.queue(">mod_msu", function() {
	::TheSkaven.Mod <- ::MSU.Class.Mod(::TheSkaven.ID, ::TheSkaven.Version, ::TheSkaven.Name);

	::include("mod_warhammer/load");		// Load mod adjustments and other hooks
});