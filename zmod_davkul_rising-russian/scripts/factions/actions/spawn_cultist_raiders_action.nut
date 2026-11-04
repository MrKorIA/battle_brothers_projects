//spawns the raiders that raid the closeby settlement, only possible if theres a base
this.spawn_cultist_raiders_action <- this.inherit("scripts/factions/faction_action", {
	m = {},
	function create()
	{
		this.m.ID = "spawn_cultist_raiders_action";
		this.m.Cooldown = this.World.getTime().SecondsPerDay * 1;
		this.m.IsSettlementsRequired = true;
		this.m.Base <- null;
		this.faction_action.create();
	}

	function onUpdate( _faction )
	{
		foreach (settlement in _faction.getSettlements())
		{
			if (settlement.m.TypeID == "location.cultist_camp" && settlement.readyToSpawnRaiders()){
				this.m.Score = 1;
				this.m.Base = this.WeakTableRef(settlement)
				break
			}
		}
	}

	function onClear()
	{
	}

	function onExecute( _faction )
	{
		
		local origin = this.m.Base
		if (origin == null || origin.isNull()) return
		local target = origin.m.TargetSettlement
		if (target == null) return

		local myTile = origin.getTile();
		local resources = origin.getResources() * this.getScaledDifficultyMult()
        local party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Cultists).spawnCultistEntity(myTile, "Налетчики Культистов", false, this.Const.World.Spawn.CultistRaiders, resources)
		party.setDescription("Шайка культистов, совершающая набеги на соседние деревни");
		party.setFootprintType(this.Const.World.FootprintsType.Brigands);
		party.setMovementSpeed(100)
		party.getFlags().set("IsRandomlySpawned", true);
		party.getLoot().Money = this.Math.rand(resources, resources*2);
		party.getLoot().Medicine = this.Math.rand(resources/30, resources/20);
		party.getLoot().ArmorParts = this.Math.rand(resources/20, resources/10);
		
		local c = party.getController();
		c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		local raid = this.new("scripts/ai/world/orders/cultist_raid_order");
		raid.setTime(60.0);
		raid.setTargetTile(target.getTile());
		raid.setTargetID(target.getID());
		raid.setOriginID(origin.getID());
		c.addOrder(raid);
		local move = this.new("scripts/ai/world/orders/move_order");
		move.setDestination(origin.getTile());
		c.addOrder(move);

		local despawn = this.new("scripts/ai/world/orders/cultist_despawn_order");
		c.addOrder(despawn)

		origin.setNextRaiderSpawn(4 + origin.m.Size)
		return true;
	}

});

