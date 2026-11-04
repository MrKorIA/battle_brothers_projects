::VanillaPlus.HooksMod.hook("scripts/entity/tactical/actor", function(q) {
	// Public
	q.m.CP_ChanceForNoWeapon <- 0;		// Value between 1 and 100 determining the chance for this actor to get no Weapon assigned from WeaponWeightContainer
	q.m.CP_WeaponWeightContainer <- null;		// If defined, the Weapon worn by this actor will by assigned by this weighted container
});

::VanillaPlus.HooksMod.hookTree("scripts/entity/tactical/actor", function(q) {
	// Assign all regular Equipment that this character brings into battle BEFORE any other assign equipment logic runs
	//	That way custom-gear code can react to these basic assignments
	q.assignRandomEquipment = @(__original) function()
	{
		// We assume that the offhand is always empty if the mainhand is empty
		if (this.m.CP_WeaponWeightContainer != null && this.getItems().hasEmptySlot(::Const.ItemSlot.Mainhand))
		{
			if (::Math.rand(1, 100) > this.m.CP_ChanceForNoWeapon)
			{
				this.getItems().equip(::new(this.m.CP_WeaponWeightContainer.roll()));
			}
		}

		__original();
	}
});
