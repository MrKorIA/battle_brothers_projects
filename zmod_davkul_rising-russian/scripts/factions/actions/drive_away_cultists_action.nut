//spawns the base close to a village, only one || only spawns another one after previous is lvl3
this.drive_away_cultists_action <- this.inherit("scripts/factions/faction_action", {
	m = {},
	function create()
	{
		this.m.ID = "drive_away_cultists_action";
		this.m.Cooldown = this.World.getTime().SecondsPerDay * 7;
		this.m.IsStartingOnCooldown = false;
		this.m.IsSettlementsRequired = true;
		this.faction_action.create();
	}

	function onUpdate( _faction )
	{

		if (_faction.getSettlements()[0].isIsolated())
		{
			return;
		}
		local target = _faction.getSettlements()[0]
		local cultists = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Cultists)
		if (cultists == null || !cultists.isActive()) return
		local settlements = cultists.getSettlements();

		foreach( settlement in settlements )
		{
			if ("TargetSettlement" in settlement.m && settlement.m.TargetSettlement != null && settlement.m.TargetSettlement.getID() == target.getID())
			{
				this.m.Score = 3;
				return
			}
		}
	}

	function onClear()
	{
	}

	function onExecute( _faction )
	{
		local contract = this.new("scripts/contracts/contracts/drive_away_cultists_contract");
		contract.setFaction(_faction.getID());
		contract.setHome(_faction.getSettlements()[0]);
		contract.setEmployerID(_faction.getRandomCharacter().getID());
		contract.setDestination();
		this.World.Contracts.addContract(contract);
	}

});

