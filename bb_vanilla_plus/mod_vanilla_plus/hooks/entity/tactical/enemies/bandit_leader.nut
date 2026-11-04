::VanillaPlus.HooksMod.hook("scripts/entity/tactical/enemies/bandit_leader", function(q) {

	q.assignRandomEquipment = @(__original) function()
	{
		__original();
		if (this.Math.rand(1, 100) <= 5)
		{
		    local armor = this.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
		    if (armor != null && armor.getUpgrade() == null)
		    {
                armor.setUpgrade(this.new("scripts/items/armor_upgrades/xxcape_upgrade"))
		    }
		}
	}
});
