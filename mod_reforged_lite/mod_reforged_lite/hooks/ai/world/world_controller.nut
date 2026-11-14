// Событие HD_onRemoved перед снятием приказа (порт из mod_hardened/api/hooks/ai/world/world_controller.nut)
::ReforgedLite.HooksMod.hook("scripts/ai/world/world_controller", function(q) {
	q.popOrder = @(__original) function()
	{
		if (this.m.Orders.len() != 0)
		{
			this.m.Orders[0].HD_onRemoved();
		}

		__original();
	}
});
