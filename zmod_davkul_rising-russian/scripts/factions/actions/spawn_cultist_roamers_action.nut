//spawns the raiders that raid the closeby settlement, only possible if theres a base
this.spawn_cultist_roamers_action <- this.inherit("scripts/factions/faction_action", {
	m = {
		StartBase = null,
		Destination = null
		},
	function create()
	{
		this.m.ID = "spawn_cultist_roamers_action";
		this.m.Cooldown = this.World.getTime().SecondsPerDay * 2;
		this.m.IsSettlementsRequired = true;
		this.faction_action.create();
	}

	function onUpdate( _faction )
	{
		local lairs = []
		local weight = 0
		foreach (lair in _faction.getLairs()){
			local sizeScore = lair.m.Size == 3 ? 1 : 3
			lairs.push({ 
				set = lair,
				score = sizeScore
			});
			weight += sizeScore
		}
		if (lairs.len() == 0){
			this.printDebug("Не найдены логовища", "mod_cultists")
			return
		}

		local origin;
		
		local bestscore = 0
		foreach (lair in lairs)
		{
			local odds = this.Math.rand(1, weight)
			if (odds <= lair.score){
				origin = lair.set
				break
			}
			weight -= lair.score
		}
		if (origin == null){
			this.printDebug("Происхождение отсутствует", "mod_cultists")
			return
		}

		local destinations = []
		foreach (settlement in this.World.EntityManager.getSettlements())
		{
			if (settlement.getTile().getDistanceTo(origin.getTile()) > 30) destinations.push(settlement)
		}
		if (destinations.len() == 0) return

		local destination = destinations[this.Math.rand(0, destinations.len()-1)]
		if (destination == null){
			this.printDebug("Не найден пункт назначения", "mod_cultists")
			return
		}
		this.m.StartBase = this.WeakTableRef(destination)
		this.m.Destination =this.WeakTableRef(origin)
		this.m.Score = 1;
		this.printDebug("бродяги получили оценку", "mod_cultists")
		
	}

	function onClear()
	{
		this.m.StartBase = null,
		this.m.Destination = null
	}

	function onExecute( _faction )
	{
		local origin = this.m.StartBase
		local destination = this.m.Destination
		local myTile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries * 100, [
					this.Const.World.TerrainType.Mountains
				], 5, 1000, 1000, 0, 0, origin.getTile())
		if (myTile == null){
			this.printDebug("Не удалось найти клетку для создания бродяг", "mod_cultists")
			return
		}
		local resources = this.Math.rand(50, 100)*origin.m.Size*this.getScaledDifficultyMult()
		local slaveNum = this.Math.min(6, this.Math.floor(resources / 100))
		local party = this.getCultists().spawnCultistEntity(myTile, "Бродячие Культисты", false, this.Const.World.Spawn.CultistRoamers, resources);
		for (local x = 0; x < slaveNum; x++){
			this.Const.World.Common.addTroop(party, {Type = this.Const.World.Spawn.Troops.Cultist_Sacrifice}, true);
		}
		party.setDescription("Шайка культистов, возвращающаяся с пленниками в своё логово");
		party.setFootprintType(this.Const.World.FootprintsType.Brigands);
		party.setMovementSpeed(100)
		party.getFlags().set("IsRandomlySpawned", true);
		party.getLoot().Money = this.Math.rand(resources, resources*2);
		party.getLoot().Medicine = this.Math.rand(resources/30, resources/20);
		party.getLoot().ArmorParts = this.Math.rand(resources/20, resources/10);
		
		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);

		local move = this.new("scripts/ai/world/orders/move_order");
		move.setDestination(this.m.Destination.getTile());
		move.setRoadsOnly(false);
		c.addOrder(move);

		local despawn = this.new("scripts/ai/world/orders/cultist_despawn_order");
		c.addOrder(despawn);

		this.printDebug("Бродяги-культисты возрождены возле " + this.m.StartBase.getName(), "mod_cultists")
		if (this.debugLog.mod_cultists) party.getSprite("selection").Visible = true;
		return true;
	}

});

