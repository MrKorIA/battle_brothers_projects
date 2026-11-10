this.free_cultist_prisoner_action <- this.inherit("scripts/factions/faction_action", {
	m = {},
	function create()
	{
		this.m.ID = "free_cultist_prisoner_action";
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

		if (_faction.getPlayerRelation() <= 25)
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() < 750)
		{
			return;
		}
		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}
		local rngToBeat = this.World.FactionManager.isGreaterEvil() ? 30 : 50;
		if (this.Math.rand(1, 100) > rngToBeat)
		{
			this.printDebug("Диапазон не превышен ", "mod_cultists")
			return;
		}

		local cultists = this.getCultists()
		if (cultists == null ||  !cultists.hasLairs()){
			if (cultists != null) this.printDebug("проблема действий по освобождению заключенного с культистом: " + cultists, "mod_cultists")
			else this.printDebug("проблема действий по освобождению заключенного с культистом: " + cultists + " " + cultists.m.Flags.get("CultistLegendaryLocationBeat") + " " + cultists.hasLairs(), "mod_cultists")
			return
		}
		local lairExists = false
		foreach (lair in cultists.getLairs()){
			if (lair.m.TargetSettlement != null) this.printDebug(format("проверка логова на предмет пленника. Размер: %i targetSettlement: %s фракция: %s targetfaction: %s", lair.getSize(),
				lair.m.TargetSettlement == null ? "null" : lair.m.TargetSettlement.getName(), 
				_faction.getName(),
				lair.m.TargetSettlement.getFactionOfType(this.Const.FactionType.NobleHouse).getName()), "mod_cultists")

			if (lair.m.Size > 1 && lair.m.TargetSettlement != null && lair.m.TargetSettlement.getFactionOfType(this.Const.FactionType.NobleHouse).getID() == _faction.getID()) {
				this.printDebug("lairExists " + lairExists, "mod_cultists")
			    lairExists = true
			}
		}
		if (!lairExists){
			this.printDebug("Нет логова? ", "mod_cultists")
			return
		}
		this.printDebug("оценка действий по освобождению заключенного ", "mod_cultists")
		this.m.Score = 1;
	}

	function onClear()
	{
	}

	function onExecute( _faction )
	{
		local contract = this.new("scripts/contracts/contracts/free_cultist_prisoner_contract");
		contract.setFaction(_faction.getID());
		contract.setEmployerID(_faction.getRandomCharacter().getID());
		contract.setDestination(_faction);
		this.World.Contracts.addContract(contract);
		this.printDebug("действие по освобождению заключенного добавлено во фракцию: " + _faction.getName(), "mod_cultists")
	}

});

