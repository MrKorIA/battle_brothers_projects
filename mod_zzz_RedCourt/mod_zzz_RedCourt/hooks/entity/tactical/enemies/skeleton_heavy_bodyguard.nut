::TheRedCourt.HooksMod.hook("scripts/entity/tactical/enemies/skeleton_heavy_bodyguard", function(q)
{
	q.assignRandomEquipment = @(__original) function()
	{
	    __original();

		local r = this.Math.rand(1, 6);

		if (r == 6)
		{
            local oldWeapon = this.m.Items.getItemAtSlot(this.Const.ItemSlot.Mainhand);

            if (oldWeapon != null)
            {
                this.m.Items.unequip(oldWeapon);
            }
			this.m.Items.equip(this.new("scripts/items/weapons/ancient/legend_gladius"));
		}

		if (this.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) == null)
		{
			this.m.Items.equip(this.new("scripts/items/shields/ancient/tower_shield"));
		}
	}
});
