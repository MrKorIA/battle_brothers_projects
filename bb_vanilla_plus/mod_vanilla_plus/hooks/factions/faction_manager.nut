::VanillaPlus.HooksMod.hook("scripts/factions/faction_manager", function(q) {
	q.RF_createDraugr <- { function RF_createDraugr()
	{
		local f = ::new("scripts/factions/rf_draugr_faction");
		f.setID(this.m.Factions.len());
		f.setName("Barrowkin");
		f.setDiscovered(true);
		f.addTrait(::Const.FactionTrait.RF_Draugr);
		this.m.Factions.push(f);
	}}.RF_createDraugr;

	q.createAlliances = @(__original) { function createAlliances()
	{
		this.RF_createDraugr();

		__original();

	}}.createAlliances;

	q.runSimulation = @(__original) { function runSimulation()
	{
		local draugr = this.getFactionOfType(::Const.FactionType.RF_Draugr);
		local ping = this.__ping;
		this.__ping = function()
		{
			draugr.update(true, true);
			ping();
		}
		__original();
		this.__ping = ping;
	}}.runSimulation;

	q.assignSettlementsToCityStates = @(__original) function( _cityStates )
	{
		__original(_cityStates);
		this.VP_assignVillagesToCityStates();
	}

	q.assignSettlementsToNobleHouses = @(__original) function( _nobleHouses )
	{
		// We briefly we remove all southern villages from the Settlements-List so that they are not assigned to the noble houses
		local removedVillages = VP_getApplicableRandomSituations();
		__original(_nobleHouses);
		this.VP_restoreSouthernVillages(removedVillages);
	}

	q.createCityStates = @(__original) function()
	{
		this.VP_createSouthernSettlements();
		return __original();
	}

	q.createSettlements = @(__original) function()
	{
		// We briefly we remove all southern villages from the Settlements-List so that no settlement faction is created for them
		local removedVillages = this.VP_getApplicableRandomSituations();
		__original();
		this.VP_restoreSouthernVillages(removedVillages);
	}

// New Functions
	q.VP_assignVillagesToCityStates <- function()
	{
		local southernSettlements = [];
		local southernCityStates = [];

		foreach (settlement in ::World.EntityManager.getSettlements())
		{
			if (!settlement.isSouthern()) continue;

			if (::isKindOf(settlement, "city_state"))
			{
				southernCityStates.push(settlement);
			}
			else if (::MSU.isNull(settlement.getOwner()))	// We are only interested in southern settlements, that are not yet assigned to anyone
			{
				southernSettlements.push(settlement);
			}
		}

		foreach (southernVillage in southernSettlements)
		{
			local best;
			local bestDistance = 9000.0;

			foreach (cityState in southernCityStates)
			{
				local distance = southernVillage.getTile().getDistanceTo(cityState.getTile());
				if (distance < bestDistance)
				{
					bestDistance = distance;
					best = cityState;
				}
			}

			if (best != null)
			{
				best.getOwner().addSettlement(southernVillage);
				// Unlike northern villages, we decide that the village re-uses the banner of its owner
				southernVillage.getFactionOfType(::Const.FactionType.Settlement).setBanner(best.getOwner().getBanner());
			}
		}
	}

	q.VP_createSouthernSettlements <- function()
	{
		local settlements = ::World.EntityManager.getSettlements();
		foreach (s in settlements)
		{
			if (s.isMilitary()) continue;
			if (::isKindOf(s, "city_state")) continue;
			if (!s.isSouthern()) continue;

			local f = ::new("scripts/factions/vp_southern_settlement_faction");
			f.setID(this.m.Factions.len());
			f.setName(s.getName());
			f.setDescription(s.getDescription());
			f.setBanner(11);	// Just a placeholder. This needs to be replaced. As southern cities use it to spawn specific world fitures
			f.setDiscovered(true);
			this.m.Factions.push(f);
			f.addTrait(::Const.FactionTrait.OrientalVillage);
			f.addTrait(::Const.FactionTrait.OrientalCityState);

			f.addSettlement(s, false);
		}
	}

	q.VP_getApplicableRandomSituations <- function()
	{
		// We briefly we remove all southern villages from the Settlements-List so that they are not assigned to the noble houses
		local temporarilyRemovedSettlements = [];
		local settlements = ::World.EntityManager.getSettlements();
		for (local i = settlements.len() - 1; i >= 0; --i)
		{
			if (settlements[i].isSouthern() && !::isKindOf(settlements[i], "city_state")) //  && ::MSU.isNull(settlements[i].getOwner())
			{
				temporarilyRemovedSettlements.push(settlements[i]);
				settlements.remove(i);
			}
		}

		return temporarilyRemovedSettlements;
	}

	q.VP_restoreSouthernVillages <- function( _removedVillages )
	{
		foreach (settlement in _removedVillages)
		{
			::World.EntityManager.addSettlement(settlement);
		}
	}
});
