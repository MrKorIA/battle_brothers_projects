// Apply nesting in events/contracts: имена сущностей мира (города, локации) в текстах
// сцен контрактов становятся вложенными ссылками [имя|WorldEntity+ID] (аналог
// mod_reforged/msu_systems/nested_tooltips.nut полного Reforged).
::ReforgedLite.HooksMod.hookTree("scripts/entity/world/world_entity", function(q) {
	q.getName = @(__original) { function getName()
	{
		return ::ReforgedLite.NestedTooltips.isApplyingNestingForEvents() ? ::ReforgedLite.Mod.Tooltips.parseString(format("[%s|WorldEntity+%i]", ::ReforgedLite.Mod.Tooltips.removeAllFromString(__original()), this.getID())) : __original();
	}}.getName;

	// World entities get assigned their labels during `updateStrength` when they spawn
	// during events or contracts. The label assigns their name by using getName(). We need
	// to return a name during this time that isn't nested with tooltip tags.
	q.updateStrength = @(__original) { function updateStrength()
	{
		local original_IsApplyingNestingForEvents = ::ReforgedLite.NestedTooltips.__IsApplyingNestingForEvents;
		::ReforgedLite.NestedTooltips.__IsApplyingNestingForEvents = 0;
		__original();
		::ReforgedLite.NestedTooltips.__IsApplyingNestingForEvents = original_IsApplyingNestingForEvents;
	}}.updateStrength;
});

::ReforgedLite.HooksMod.hookTree("scripts/entity/world/attached_location", function(q) {
	q.getRealName = @(__original) { function getRealName()
	{
		return ::ReforgedLite.NestedTooltips.isApplyingNestingForEvents() ? ::ReforgedLite.Mod.Tooltips.parseString(format("[%s|WorldEntity+%i]", ::ReforgedLite.Mod.Tooltips.removeAllFromString(__original()), this.getID())) : __original();
	}}.getRealName;
});
