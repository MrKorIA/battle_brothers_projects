::VanillaPlus.HooksMod.hookTree("scripts/entity/tactical/actor", function(q) {
	// HookTree, because some child classes (like Human) don't call generateCorpse from the actor base class
	q.generateCorpse = @(__original) function( _tile, _fatalityType, _killer )
	{
		local ret = __original(_tile, _fatalityType, _killer);

		// Feat: save the original name of the dead unit. This is useful, because some child classes (like Human), edit the name before putting it into the Name field
		ret.CP_OriginalName <- this.getName();

		return ret;
	}
});
