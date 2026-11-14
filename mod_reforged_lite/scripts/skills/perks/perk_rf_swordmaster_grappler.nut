this.perk_rf_swordmaster_grappler <- ::inherit("scripts/skills/perks/perk_rf_swordmaster_abstract", {
	m = {},
	function create()
	{
		this.perk_rf_swordmaster_abstract.create();
		this.m.ID = "perk.rf_swordmaster_grappler";
		this.m.Name = "Захват";
		this.m.Description = ::ReforgedLite.Mod.Tooltips.parseString("Становится доступным умение [Пинок|Skill+rf_swordmaster_kick_skill], позволяющее провести бесплатную атаку по противнику и ошеломить его. При успешной атаке цель отбрасывается на одну клетку назад.");
		this.m.Icon = "ui/perks/perk_rf_swordmaster_grappler.png";
	}

	function onAdded()
	{
		this.getContainer().add(::new("scripts/skills/actives/rf_swordmaster_tackle_skill"));
		this.getContainer().add(::new("scripts/skills/actives/rf_swordmaster_kick_skill"));
		this.getContainer().add(::new("scripts/skills/actives/rf_swordmaster_push_through_skill"));
	}

	function onRemoved()
	{
		this.getContainer().removeByID("actives.rf_swordmaster_tackle");
		this.getContainer().removeByID("actives.rf_swordmaster_kick");
		this.getContainer().removeByID("actives.rf_swordmaster_push_through");
	}
});
