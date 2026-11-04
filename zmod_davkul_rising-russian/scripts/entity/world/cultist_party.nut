this.cultist_party <- this.inherit("scripts/entity/world/party", {
	m = {
		SlavesFreed = 0
		}

	function onCombatLost()
	{
		this.party.onCombatLost()
		if (this.getFlags().has("SlavesFreed") && this.getFlags().get("SlavesFreed") > 0)
		{
			this.printDebug("Рабы, освобожденные после битвы: " + this.m.SlavesFreed, "mod_cultists")
			local cultist_event = this.World.Events.getEvent( "event.party.cultist_destroyed" )
			if (cultist_event != null){
				cultist_event.m.SlavesFreed = this.getFlags().get("SlavesFreed")
				this.World.Events.fire("event.party.cultist_destroyed");
			}		
		}
	}

})
