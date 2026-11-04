::VanillaPlus.HooksMod.hook("scripts/events/event_manager", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		this.addSpecialEvent("event.vp_capture_orc_or_goblin_event");
	}}.create;
});
