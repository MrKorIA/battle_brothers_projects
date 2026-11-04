::VanillaPlus.HooksMod.hook("scripts/entity/world/location", function(q) {
	// Public
	q.m.CP_TacticalTypeOverwrite <- null;	// Define custom TacticalType that should be used when fighting this location

	// Define custom engage image to be displayed when fighting at this location
	// Must also have a _night variant for when you fight at night
	q.m.CP_EngageImageOverwrite <- null;
	q.m.CP_TacticalTextOverwrite <- null;	// Text description to be displayed on location tooltips

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		if (this.m.CP_TacticalTextOverwrite == null) return ret;

		foreach (entry in ret)
		{
			if (entry.id == 21 && entry.type == "hint" && entry.icon == "ui/orientation/terrain_orientation.png")
			{
				entry.text = "Эта локация " + this.m.CP_TacticalTextOverwrite;
				break;
			}
		}

		return ret;
	}
});
