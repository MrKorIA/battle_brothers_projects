this.vp_southern_settlement_faction <- this.inherit("scripts/factions/faction", {
	m = {
		// Public
		VP_MaxUnits = 2,	// This many "flavor" world parties can be exist at the same time for this faction
		VP_VizierCount = 2,

		// Private
		VP_SecondaryType = ::Const.FactionType.Settlement,	// Only used during getFactionOfType from southern settlements
	},
	function create()
	{
		// t.Const.Faction
		this.faction.create();
		this.m.Type = ::Const.FactionType.OrientalCityState;	// Several contracts check for this property, to decide, whether it is southern or northern themed.
		// this.m.Type = ::Const.FactionType.Settlement;	// Several contracts check for this property, to decide, whether it is southern or northern themed.

		this.m.Base = "world_base_13";
		this.m.TacticalBase = "bust_base_southern";
		this.m.BannerPrefix = "banner_noble_";
		this.m.CombatMusic = ::Const.Music.OrientalCityStateTracks;
		this.m.RelationDecayPerDay = ::Const.World.Assets.RelationDecayPerDayNoble;
	}

	// city states have it. For safety reasons I also support this here, incase someone sees isSouthern, and calls this
	function getNameOnly()
	{
		return this.m.Name;
	}

	function getColor()
	{
		return this.createColor("#00ffff");
	}

	function getBannerSmall()
	{
		return "banner_noble_" + (this.m.Banner < 10 ? "0" + this.m.Banner : this.m.Banner);
	}

	function isReadyToSpawnUnit()
	{
		// City States allow 5 at the same time
		// Regular Settlements have 1 by default and +1 for each military attachement
		return this.m.Units.len() < this.m.VP_MaxUnits;
	}

	function addPlayerRelation( _r, _reason = "" )
	{
		this.faction.addPlayerRelation(_r, _reason);

		// Negative relation changes is also affecting the owner of this village, but to a lesser degree
		if (_r < 0)
		{
			foreach (s in this.m.Settlements)	// This appraoch will cause issues, when multiple settlements belong to this settlement faciotn. but that never happens in vanilla
			{
				local owner = s.getOwner();
				if (owner != null && owner.getID() != this.getID())
				{
					owner.addPlayerRelationEx(_r * 0.25);
				}
			}
		}
	}

	// This is never called in Vanilla. Only its equivalent, for the northern factions is called. So we just copy the implementation of city states
	function makeSettlementsFriendlyToPlayer()
	{
		this.m.PlayerRelation = ::Math.maxf(this.m.PlayerRelation, 30.0);
	}

	function onUpdateRoster()
	{
		for (local roster = this.getRoster(); roster.getSize() < this.m.VP_VizierCount;)
		{
			local character = roster.create("scripts/entity/tactical/humans/vizier");
			character.setFaction(this.m.ID);
			character.setAppearance();

			if (character.getTitle() != "")
			{
				local currentRoster = roster.getAll();

				foreach( c in currentRoster )
				{
					if (c.getID() != character.getID() && character.getTitle() == c.getTitle())
					{
						character.setTitle("");
						break;
					}
				}
			}

			if (character.getTitle() == "")
			{
				character.setTitle("из " + this.m.Name);
			}

			character.assignRandomEquipment();
		}
	}

	function isReadyForContract()	// This is taken from how northern settlements generate contract size
	{
		if (this.m.Settlements.len() == 0) return false;

		if (this.m.Contracts.len() >= this.getSettlements()[0].getSize()) return false;	// We can only have as many contracts as our town size (hard-coded to 2)

		if (this.m.LastContractTime == 0) return true;
		if (::World.getTime().Days <= 1) return true;	// Day 1, we fill every town with contracts

		local delay = 5.0 - (this.getSettlements()[0].getSize() - 1);
		delay *= ::World.getTime().SecondsPerDay;
		return ::Time.getVirtualTimeF() > this.m.LastContractTime + delay;
	}

	function addTrait( _trait )
	{
		// We don't want the CityState actions for our village
		// But we do want to pretend like we are a CityState, so that caravans are created of the correct type
		// So, when this specific faction adds the OrientalCityState trait, we only add that one to the Traits array and do nothing else
		if (_trait == ::Const.FactionTrait.OrientalCityState)
		{
			this.m.Traits.push(_trait);
		}
		else
		{
			this.faction.addTrait(_trait);
		}
	}
});

