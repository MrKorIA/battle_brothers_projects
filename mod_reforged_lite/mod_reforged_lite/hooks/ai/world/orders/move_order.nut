// Охотники за головами меняют работодателя: по прибытии move_order в поселение отряд
// перекрашивается во фракцию ближайшего поселения (порт из mod_hardened/hooks/ai/world/orders/move_order.nut)
::ReforgedLite.HooksMod.hook("scripts/ai/world/orders/move_order", function(q) {
	// Своя реализация вместо обёртки: базовый HD_onRemoved (world_behavior) пустой
	q.HD_onRemoved <- function()
	{
		local party = this.getController().getEntity();
		if (party.getFlags().has("HD_IsBountyHunters"))
		{
			foreach (worldEntity in ::World.getAllEntitiesAtPos(party.getPos(), 100))
			{
				if (!worldEntity.isLocation()) continue;
				if (!worldEntity.isLocationType(::Const.World.LocationType.Settlement)) continue;

				if (worldEntity.getFactions().len() == 1)
				{
					party.setFaction(worldEntity.getOwner().getID());
				}
				else
				{
					party.setFaction(worldEntity.getFactionOfType(::Const.FactionType.Settlement).getID());
				}
				break;
			}
		}
	}
});
