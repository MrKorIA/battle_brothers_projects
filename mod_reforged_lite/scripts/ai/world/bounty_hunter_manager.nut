// Управляет отрядами охотников за головами на карте мира (порт из mod_hardened).
// Живёт в entity_manager: создание в create(), такт из update(), сериализация через
// World.Flags (запись в world_state.onSerialize, чтение в entity_manager.onDeserialize).
// Отличия от Hardened: нет глобальных множителей сложности — ресурсы растут как у ванильных
// наёмников (min(330, 150 + дни)).
this.bounty_hunter_manager <- {
	m = {
	// Public
		PartyMax = 1,					// максимум отрядов охотников за головами на карте мира
		RoamingDistance = [8, 20],		// охотники бродят в таком радиусе от работодателя
		RoamingDuration = 200.0,		// и так долго (в игровых секундах)

	// Private
		BountyHunters = [],				// weakrefs на все отряды охотников за головами в мире
		LastUpdateTime = 0,
		UpdateTimeInSeconds = 3.0,		// управляем отрядами раз в столько виртуальных секунд
		WorldFlagName = "HD_BountyHunterIDs",
	},

	function create () {}

	function update()
	{
		this.__collectGarbage()

		// Для экономии производительности управляем раз в 3 виртуальные секунды
		if (!this.__isNewUpdateCycle()) return;

		if (this.getAllBountyHunters().len() < this.m.PartyMax)
		{
			this.__spawnNewParty();
		}

		foreach (bountyHunter in this.getAllBountyHunters())
		{
			bountyHunter.updatePlayerRelation();
			this.__updateOrders(bountyHunter);
		}
	}

	function clear()
	{
		this.m.BountyHunters = [];
		this.m.LastUpdateTime = 0;
	}

	function getAllBountyHunters()
	{
		return this.m.BountyHunters;
	}

	// Из-за WorldFlags важно, чтобы вызывалось ДО сериализации World Flags
	function onSerialize()
	{
		local serializedString = "";
		foreach (party in this.getAllBountyHunters())
		{
			if (::MSU.isNull(party)) continue;
			if (!party.isAlive()) continue;
			serializedString += party.getID() + ";";
		}
		::World.Flags.set(this.m.WorldFlagName, serializedString);
	}

	function onDeserialize()
	{
		if (!::World.Flags.has(this.m.WorldFlagName)) return;

		local deserializedString = ::World.Flags.get(this.m.WorldFlagName);
		foreach (bountyHunterID in split(deserializedString, ";"))
		{
			local party = ::World.getEntityByID(bountyHunterID.tointeger());
			if (party == null) continue;

			this.m.BountyHunters.push(::WeakTableRef(party));
		}
	}

// Private
	function __collectGarbage()
	{
		local garbage = [];
		local bountyHunterArray = this.getAllBountyHunters();
		foreach (i, bountyHunter in bountyHunterArray)
		{
			if (bountyHunter.isNull() || !bountyHunter.isAlive()) garbage.push(i);
		}
		garbage.reverse();
		foreach (g in garbage)
		{
			bountyHunterArray.remove(g);
		}
	}

	function __isNewUpdateCycle()
	{
		if (this.m.LastUpdateTime + this.m.UpdateTimeInSeconds > ::Time.getVirtualTimeF()) return false;

		this.m.LastUpdateTime = ::Time.getVirtualTimeF();
		return true;
	}

	function __spawnNewParty()
	{
		local originSettlement = this.__findStartingSettlement();
		if (originSettlement == null) return;	// может случиться при слишком малом числе поселений

		local party = ::World.spawnEntity("scripts/entity/world/party", originSettlement.getTile().Coords);
		party.setPos(::createVec(party.getPos().X - 50, party.getPos().Y - 50));

		party.setName(::ReforgedLite.util.findUnusedMercenaryName());
		party.setDescription("Отряд охотников за головами, скитающийся по миру и предлагающий свои умения тому, кто больше заплатит.");
		party.setFootprintType(::Const.World.FootprintsType.Mercenaries);
		party.getSprite("base").setBrush("world_base_07");
		party.getSprite("body").setBrush("figure_hd_bounty_hunter_01");
		party.getSprite("banner").setBrush(::ReforgedLite.util.findUnusedMercenaryBanner());
		if (originSettlement.getFactions().len() == 1)
		{
			party.setFaction(originSettlement.getOwner().getID());
		}
		else
		{
			party.setFaction(originSettlement.getFactionOfType(::Const.FactionType.Settlement).getID());
		}
		party.setVisionRadius(party.m.VisionRadius * 1.25);		// у охотников за головами обзор +25%

		this.__refreshTroops(party);

		this.__addLoot(party);

		party.getFlags().set("IsMercenaries", true);		// чтобы убийство шло в амбицию на наёмников
		party.getFlags().set("HD_IsBountyHunters", true);	// чтобы опознавать их потом

		this.m.BountyHunters.push(::WeakTableRef(party))
	}

	function __findStartingSettlement()
	{
		local playerTile = ::World.State.getPlayer().getTile();
		local candidates = [];
		foreach (settlement in ::World.EntityManager.getSettlements())
		{
			if (settlement.isIsolated()) continue;
			if (settlement.getTile().getDistanceTo(playerTile) <= 10) continue;

			candidates.push(settlement);
		}
		if (candidates.len() == 0) return null;

		return ::MSU.Array.rand(candidates);
	}

	function __refreshTroops( _party )
	{
		// Сохраняем выданную при генерации фигуру
		local oldWorldFigure = _party.getSprite("body").getBrush().Name;

		_party.clearTroops();
		// как у ванильных наёмников: min(330, 150 + дни)
		local resources = ::Math.min(330, 150 + ::World.getTime().Days);
		::Const.World.Common.assignTroops(_party, ::Const.World.Spawn.BountyHunters, ::Math.rand(resources * 0.8, resources));

		_party.getSprite("body").setBrush(oldWorldFigure);
	}

	function __addLoot( _party )
	{
		// 1:1 с лутом ванильного отряда наёмников
		_party.getLoot().Money = ::Math.rand(300, 600);
		_party.getLoot().ArmorParts = ::Math.rand(0, 25);
		_party.getLoot().Medicine = ::Math.rand(0, 10);
		_party.getLoot().Ammo = ::Math.rand(0, 50);

		local foodLoot = ::MSU.Class.WeightedContainer([
			[12, "supplies/beer_item"],
			[12, "supplies/bread_item"],
			[12, "supplies/dried_fruits_item"],
			[12, "supplies/mead_item"],
		]);
		_party.addToInventory(foodLoot.roll());
		_party.addToInventory(foodLoot.roll());
	}

	function __updateOrders( _party )
	{
		local controller = _party.getController();
		if (controller.getOrders().len() > 2) return;
		// Когда осталось два приказа, отряд завершил цикл и ждёт новых
		// (если не получит вовремя — дойдёт до despawn и самоуничтожится)

		local newDestinationSettlement = this.__findNewDestination(_party);
		if (newDestinationSettlement == null) return;

		// Первым делом обновляем состав отряда
		this.__refreshTroops(_party);

		// Заменяем все приказы на свежий набор
		local controller = _party.getController();
		controller.clearOrders();
		local wait1 = ::new("scripts/ai/world/orders/wait_order");		// посидеть после сдачи контракта
		wait1.setTime(::Math.rand(10, 20) * 1.0);
		local move1 = ::new("scripts/ai/world/orders/move_order");		// переехать в новое поселение
		move1.setDestination(newDestinationSettlement.getTile());
		local wait2 = ::new("scripts/ai/world/orders/wait_order");		// побродить по поселению, принять контракт
		wait2.setTime(::Math.rand(10, 60) * 1.0);
		local roam = ::new("scripts/ai/world/orders/roam_order");		// искать цели
		roam.setAllTerrainAvailable();
		roam.setTerrain(::Const.World.TerrainType.Ocean, false);
		roam.setTerrain(::Const.World.TerrainType.Shore, false);
		roam.setTerrain(::Const.World.TerrainType.Mountains, false);
		roam.setPivot(newDestinationSettlement);
		roam.setMinRange(this.m.RoamingDistance[0]);
		roam.setMaxRange(this.m.RoamingDistance[1]);
		roam.setTime(this.m.RoamingDuration);
		local move2 = ::new("scripts/ai/world/orders/move_order");		// вернуться в поселение
		move2.setDestination(newDestinationSettlement.getTile());
		local wait3 = ::new("scripts/ai/world/orders/wait_order");		// передохнуть (дождаться следующего цикла менеджера)
		wait3.setTime(30.0);
		local despawn = ::new("scripts/ai/world/orders/despawn_order");	// самоочистка

		controller.addOrder(wait1);
		controller.addOrder(move1);
		controller.addOrder(wait2);
		controller.addOrder(roam);
		controller.addOrder(move2);
		controller.addOrder(wait3);
		controller.addOrder(despawn);
	}

	function __findNewDestination( _party )
	{
		local validSettlements = [];
		foreach (settlement in ::World.EntityManager.getSettlements())
		{
			if (settlement.isIsolated()) continue;
			if (!settlement.isAlliedWith(_party)) continue;
			validSettlements.push(settlement);

			// Hardened: враждебные игроку поселения вдвое вероятнее как цель охотников
			if (!settlement.isAlliedWithPlayer())
			{
				validSettlements.push(settlement);
			}
		}
		if (validSettlements.len() == 0) return null;

		return ::MSU.Array.rand(validSettlements);
	}
}
