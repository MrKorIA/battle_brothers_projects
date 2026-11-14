// Событие HD_onRemoved: вызывается world_controller.popOrder() перед снятием приказа со стека
// (порт из mod_hardened — используется охотниками за головами для смены работодателя)
::ReforgedLite.HooksMod.hook("scripts/ai/world/world_behavior", function(q) {
	q.HD_onRemoved <- function()
	{
	}
});
