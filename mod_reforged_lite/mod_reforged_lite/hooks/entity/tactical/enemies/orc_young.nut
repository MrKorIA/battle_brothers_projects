// Убитые орки могут быть подняты как орки-нежить (авторская задумка Reforged 0.9.3)
::ReforgedLite.HooksMod.hook("scripts/entity/tactical/enemies/orc_young", function(q) {
	q.generateCorpse = @(__original) { function generateCorpse( _tile, _fatalityType, _killer )
	{
		local ret = __original(_tile, _fatalityType, _killer);
		ret.IsResurrectable = _fatalityType != ::Const.FatalityType.Decapitated && _fatalityType != ::Const.FatalityType.Smashed;
		ret.Type = "scripts/entity/tactical/enemies/rf_zombie_orc_young";
		return ret;
	}}.generateCorpse;
});
