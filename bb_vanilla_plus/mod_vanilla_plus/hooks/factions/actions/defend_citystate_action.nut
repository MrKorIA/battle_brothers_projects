::VanillaPlus.HooksMod.hook("scripts/factions/actions/defend_citystate_action", function(q) {
	// Vanilla Fix: Vanilla allows city states to spawn defender at any of their settlement.
	// In Vanilla this is no problem, but as soon as they have minor settlements, this spawns glitchy patrols
	q.onUpdate = @(__original) function( _faction )
	{
		local proxySettlements = [];
		foreach (settlement in _faction.getSettlements())
		{
			if (settlement.getFaction() == _faction.getID())	// Only settlements, that completely belong to us (not just owned by us), count for this
			// if (::isKindOf(settlement, "city_state"))
			{
				proxySettlements.push(settlement);
			}
		}

		local oldGetSettlement = _faction.get().getSettlements;
		_faction.get().getSettlements = function() {
			return proxySettlements;	// We briefly pretend like _faction only has "proxySettlements" settlements
		}

		__original(_faction);

		_faction.get().getSettlements = oldGetSettlement;
	}
});
