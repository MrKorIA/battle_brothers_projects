::HordeInvasion <- {
	ID = "mod_horde_invasion",
	Name = "Нашествие Великой Орды",
	Version = "0.1.0"
}

::HordeInvasion.HooksMod <- ::Hooks.register(::HordeInvasion.ID, ::HordeInvasion.Version, ::HordeInvasion.Name);
::HordeInvasion.HooksMod.require(["mod_msu", "mod_jin", "mod_mgl"]);

::HordeInvasion.HooksMod.queue(">mod_msu", ">mod_jin", ">mod_mgl", ">mod_crisis_duration_setting", function() {
	// ">mod_crisis_duration_setting" — мягкая сортировка: мод-замена опционален; при его
	// наличии грузимся после него, чтобы инстанс-обёртка updateGreaterEvil (см. hooks/)
	// наделась поверх его реализации, а не оказалась в тени.
	::HordeInvasion.Mod <- ::MSU.Class.Mod(::HordeInvasion.ID, ::HordeInvasion.Version, ::HordeInvasion.Name);
	::include("mod_horde_invasion/load");
});
