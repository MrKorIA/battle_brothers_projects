::VanillaPlus.HooksMod.hook("scripts/factions/faction", function(q) {
	// Private
	q.m.CP_LastSpawnedParty <- null;	// weakref to the last party, spawned by this factions spawnEntity function

	q.spawnEntity = @(__original) function( _tile, _name, _uniqueName, _template, _resources, _minibossify = 0 )
	{
		local ret = __original(_tile, _name, _uniqueName, _template, _resources, _minibossify);

		this.m.CP_LastSpawnedParty <- ::MSU.asWeakTableRef(ret);

		return ret;
	}
});
