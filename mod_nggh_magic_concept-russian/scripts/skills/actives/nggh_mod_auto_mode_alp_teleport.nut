this.nggh_mod_auto_mode_alp_teleport <- ::inherit("scripts/skills/nggh_mod_toggle_mode_skill", {
	m = {},
	function create()
	{
		this.nggh_mod_toggle_mode_skill.create();
		this.m.ID = "actives.auto_mode_alp_teleport";
		this.m.Name = "Автотелепортация";
		this.m.FlagName = "auto_teleport";
		this.m.Description = "Способность телепортироваться, когда персонаж или союзник получает удар.";
		this.m.Icon = "skills/active_auto_teleport_on.png";
		this.m.IconDisabled = "skills/active_auto_teleport_off.png";
	}
	

});

