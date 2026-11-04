::VanillaPlus.HooksMod.hook("scripts/entity/tactical/humans/nomad_cutthroat", function(q) {
	q.create = @(__original) function()
	{
		__original();

		// There is now a flat 10% chance for any cutthroat to spawn with our new reinforced staff
		// Otherwise the Reforged/Vanilla weapon spawn behavior will happen
		this.m.CP_ChanceForNoWeapon = 90;
		this.m.CP_WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/cp_reinforced_wooden_staff"],
		]);
	}
});
