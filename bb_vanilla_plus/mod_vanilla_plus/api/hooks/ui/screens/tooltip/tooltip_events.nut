::VanillaPlus.HooksMod.hook("scripts/ui/screens/tooltip/tooltip_events", function(q) {
	q.tactical_helper_addHintsToTooltip = @(__original) function( _activeEntity, _entity, _item, _itemOwner, _ignoreStashLocked = false )
	{
		local ret = __original(_activeEntity, _entity, _item, _itemOwner, _ignoreStashLocked);

		if (_itemOwner == "character-screen-inventory-list-module.stash" && !_item.CP_canBeRepaired())
		{
			foreach (index, entry in ret)
			{
				// Remove any mention of the repair shortcut for items that are not repairable
				if (entry.id == 3 && "icon" in entry && entry.icon == "ui/icons/mouse_right_button_alt.png")
				{
					ret.remove(index);
					break;
				}
			}
		}

		if (_itemOwner == "world-town-screen-shop-dialog-module.stash" && !_item.CP_canBeRepaired())
		{
			foreach (index, entry in ret)
			{
				// Remove any mention of the instant-repair shortcut for smith buildings
				if (entry.id == 3 && "icon" in entry && entry.icon == "ui/icons/mouse_right_button_alt.png")
				{
					ret.remove(index);
					break;
				}
			}
		}

		return ret;
	}
});
