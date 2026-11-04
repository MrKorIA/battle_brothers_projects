::VanillaPlus.HooksMod.hook("scripts/ui/screens/world/modules/world_town_screen/town_shop_dialog_module", function(q) {
	q.onRepairItem = @(__original) function( _itemIndex )
	{
		// Items that can't be repaired also can't be repaired at a smith
		local item = this.Stash.getItemAtIndex(_itemIndex).item;
		if (!item.CP_canBeRepaired()) return null;

		return __original(_itemIndex);
	}
});
