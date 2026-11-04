this.drive_away_jin_action <- this.inherit("scripts/factions/faction_action", {
	m = {},
	function create()
	{
		this.m.ID = "drive_away_jin_action";
		this.m.Cooldown = this.World.getTime().SecondsPerDay * 7;
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

		if (_faction.getSettlements()[0].isIsolated())
		{
			return;
		}

		if (this.World.getTime().Days <= 3 && this.Math.rand(1, 100) < 33 || this.Math.rand(1, 100) > 25)
		{
			return;
		}

		local tooFar = true;
		local myTile = _faction.getSettlements()[0].getTile();

		if (tooFar)
		{
		    if (this.World.FactionManager.getFactionOfType(this.Const.FactionType.Jurchen) == null) return;
			local bandits = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Jurchen).getSettlements();

			foreach( b in bandits )
			{
				if (myTile.getDistanceTo(b.getTile()) <= 15)
				{
					tooFar = false;
					break;
				}
			}
		}

		if (tooFar)
		{
			return;
		}

		this.m.Score = 1;
	}

	function onExecute( _faction )
	{
		local contract = this.Const.DLC.Desert && _faction.getType() == this.Const.FactionType.OrientalCityState
		    ? this.new("scripts/contracts/contracts/drive_away_desert_jin_contract")
		    : this.new("scripts/contracts/contracts/drive_away_jin_contract");
		contract.setFaction(_faction.getID());
		contract.setHome(_faction.getSettlements()[0]);
		contract.setEmployerID(_faction.getRandomCharacter().getID());
		this.World.Contracts.addContract(contract);
	}

});

