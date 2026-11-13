// Во время генерации слухов в таверне фракции могут подменять свой тип (см. rf_draugr_faction.getType)
::ReforgedLite.HooksMod.hook("scripts/entity/world/settlements/buildings/tavern_building", function(q) {
	q.getRumor = @(__original) { function getRumor( _isPaidFor = false )
	{
		::ReforgedLite.__IsDuringGetRumor = true;
		local ret = __original(_isPaidFor);
		::ReforgedLite.__IsDuringGetRumor = false;
		return ret;
	}}.getRumor;
});
