// Охотники за головами: менеджер живёт в entity_manager (порт из mod_hardened/api/hooks/entity/world/entity_manager.nut)
::ReforgedLite.HooksMod.hook("scripts/entity/world/entity_manager", function(q) {
	// Private
	q.m.HD_BountyHunterManager <- null;

	q.create = @(__original) function()
	{
		__original();
		this.m.HD_BountyHunterManager = ::new("scripts/ai/world/bounty_hunter_manager");
	}

	q.update = @(__original) function()
	{
		__original();
		this.m.HD_BountyHunterManager.update();
	}

	q.clear = @(__original) function()
	{
		__original();
		this.m.HD_BountyHunterManager.clear();
	}

	q.onDeserialize = @(__original) function( _in )
	{
		__original(_in);

		this.m.HD_BountyHunterManager.onDeserialize();
	}
});
