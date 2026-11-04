this.return_rat_item_action <- this.inherit("scripts/factions/faction_action", {
	m = {},
	function create()
	{
		this.m.ID = "return_rat_item_action";
		this.m.Cooldown = this.World.getTime().SecondsPerDay * 13;
		this.m.IsStartingOnCooldown = false;
		this.m.IsSettlementsRequired = true;
		this.faction_action.create();
	}

	function onUpdate( _faction )
	{
		if (!_faction.isReadyForContract())
		{
			return;
		}

		if (_faction.getSettlements()[0].isIsolatedFromRoads())
		{
			return;
		}

		if (this.World.getTime().Days <= 3 && this.Math.rand(1, 100) < 20 || this.Math.rand(1, 100) > 9)
		{
			return;
		}

		this.m.Score = 1;
	}

	function onClear()
	{
	}

	function onExecute( _faction )
	{
		local contract = this.Const.DLC.Desert && _faction.getType() == this.Const.FactionType.OrientalCityState
		    ? this.new("scripts/contracts/contracts/south_return_rat_item_contract")
		    : this.new("scripts/contracts/contracts/return_rat_item_contract");
		contract.setFaction(_faction.getID());
		contract.setEmployerID(_faction.getRandomCharacter().getID());
		this.World.Contracts.addContract(contract);
	}

});

