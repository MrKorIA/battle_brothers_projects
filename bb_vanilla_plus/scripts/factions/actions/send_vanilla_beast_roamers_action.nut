this.send_vanilla_beast_roamers_action <- this.inherit("scripts/factions/faction_action", {
	m = {
		Options = [],
		BeastsLow = [],
		BeastsMedium = [],
		BeastsHigh = []
	},
	function create()
	{
		this.m.ID = "send_vanilla_beast_roamers_action";
		this.m.Cooldown = 5.0;
		this.faction_action.create();
		local distanceToNextAlly = 10;
		local beast;

//Кровососы
		beast = function ( _action, _nearTile = null )
		{
			local disallowedTerrain = [];

			for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
			{
				if (i == this.Const.World.TerrainType.Forest || i == this.Const.World.TerrainType.Swamp || i == this.Const.World.TerrainType.LeaveForest || i == this.Const.World.TerrainType.AutumnForest || i == this.Const.World.TerrainType.Oasis)
				{
				}
				else
				{
					disallowedTerrain.push(i);
				}
			}

			local tile = _action.getTileToSpawnLocation(10, disallowedTerrain, 7, 50, 1000, 3, 0, _nearTile, 0.2);

			if (tile == null)
			{
				return false;
			}

			if (_action.getDistanceToNextAlly(tile) <= distanceToNextAlly / (_nearTile == null ? 1 : 2))
			{
				return false;
			}

			local distanceToNextSettlement = _action.getDistanceToSettlements(tile);
			local party = _action.getFaction().spawnEntity(tile, "Рой Кровососов", false, this.Const.World.Spawn.XXMobBloodsucker, this.Math.rand(80, 120) * _action.getScaledDifficultyMult() * this.Math.maxf(0.7, this.Math.minf(1.5, distanceToNextSettlement / 14.0)));
			party.getSprite("banner").setBrush("banner_beasts_01");
			party.setDescription("Чудовищные крылатые насекомые, которые нападают на всё что имеет плоть и кровь.");
			party.setFootprintType(this.Const.World.FootprintsType.Direwolves);
			party.setSlowerAtNight(false);
			party.setUsingGlobalVision(false);
			party.setLooting(false);
			local roam = this.new("scripts/ai/world/orders/roam_order");
			roam.setNoTerrainAvailable();
			roam.setTerrain(this.Const.World.TerrainType.Forest, true);
			roam.setTerrain(this.Const.World.TerrainType.Swamp, true);
			roam.setTerrain(this.Const.World.TerrainType.LeaveForest, true);
			roam.setTerrain(this.Const.World.TerrainType.AutumnForest, true);
			party.getController().addOrder(roam);
			return true;
		};
		this.m.Options.push(beast);
		this.m.BeastsLow.push(beast);


//Снежные Волки
		beast = function ( _action, _nearTile = null )
		{
			local disallowedTerrain = [];

			for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
			{
				if (i == this.Const.World.TerrainType.SnowyForest || i == this.Const.World.TerrainType.Snow || i == this.Const.World.TerrainType.Tundra)
				{
				}
				else
				{
					disallowedTerrain.push(i);
				}
			}

			local tile = _action.getTileToSpawnLocation(10, disallowedTerrain, 7, 50, 1000, 3, 0, _nearTile, 0.2);

			if (tile == null)
			{
				return false;
			}

			if (_action.getDistanceToNextAlly(tile) <= distanceToNextAlly / (_nearTile == null ? 1 : 2))
			{
				return false;
			}

			local distanceToNextSettlement = _action.getDistanceToSettlements(tile);
			local party = _action.getFaction().spawnEntity(tile, "Стая Снежных Волков", false, this.Const.World.Spawn.XXMobWhiteWolf, this.Math.rand(80, 120) * _action.getScaledDifficultyMult() * this.Math.maxf(0.7, this.Math.minf(1.5, distanceToNextSettlement / 14.0)));
			party.getSprite("banner").setBrush("banner_beasts_01");
			party.setDescription("Стая свирепых снежных волков на охоте за добычей.");
			party.setFootprintType(this.Const.World.FootprintsType.Direwolves);
			party.setSlowerAtNight(false);
			party.setUsingGlobalVision(false);
			party.setLooting(false);
			local roam = this.new("scripts/ai/world/orders/roam_order");
			roam.setNoTerrainAvailable();
			roam.setTerrain(this.Const.World.TerrainType.SnowyForest, true);
			roam.setTerrain(this.Const.World.TerrainType.Snow, true);
			roam.setTerrain(this.Const.World.TerrainType.Tundra, true);
			roam.setTerrain(this.Const.World.TerrainType.Hills, true);
			party.getController().addOrder(roam);
			return true;
		};
		this.m.Options.push(beast);
		this.m.BeastsLow.push(beast);

//Кабаны
		beast = function ( _action, _nearTile = null )
		{
			local disallowedTerrain = [];

			for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
			{
				if (i == this.Const.World.TerrainType.Forest || i == this.Const.World.TerrainType.SnowyForest || i == this.Const.World.TerrainType.LeaveForest || i == this.Const.World.TerrainType.AutumnForest)
				{
				}
				else
				{
					disallowedTerrain.push(i);
				}
			}

			local tile = _action.getTileToSpawnLocation(10, disallowedTerrain, 7, 50, 1000, 3, 0, _nearTile, 0.2);

			if (tile == null)
			{
				return false;
			}

			if (_action.getDistanceToNextAlly(tile) <= distanceToNextAlly / (_nearTile == null ? 1 : 2))
			{
				return false;
			}

			local distanceToNextSettlement = _action.getDistanceToSettlements(tile);
			local party = _action.getFaction().spawnEntity(tile, "Стая Шиповепрей", false, this.Const.World.Spawn.XXMobBoar, this.Math.rand(80, 120) * _action.getScaledDifficultyMult() * this.Math.maxf(0.7, this.Math.minf(1.5, distanceToNextSettlement / 14.0)));
			party.getSprite("banner").setBrush("banner_beasts_01");
			party.setDescription("Шиповепри — чудовищные создания, их шкура покрыта острыми шипами, которые легко отлетают при ударах впиваясь в плоть и доспехи.");
			party.setFootprintType(this.Const.World.FootprintsType.Direwolves);
			party.setSlowerAtNight(false);
			party.setUsingGlobalVision(false);
			party.setLooting(false);
			local roam = this.new("scripts/ai/world/orders/roam_order");
			roam.setNoTerrainAvailable();
			roam.setTerrain(this.Const.World.TerrainType.Forest, true);
			roam.setTerrain(this.Const.World.TerrainType.SnowyForest, true);
			roam.setTerrain(this.Const.World.TerrainType.LeaveForest, true);
			roam.setTerrain(this.Const.World.TerrainType.AutumnForest, true);
			roam.setTerrain(this.Const.World.TerrainType.Hills, true);
			party.getController().addOrder(roam);
			return true;
		};
		this.m.Options.push(beast);
		this.m.BeastsLow.push(beast);

//Тигры
		beast = function ( _action, _nearTile = null )
		{
			local disallowedTerrain = [];

			for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
			{
				if (i == this.Const.World.TerrainType.Forest || i == this.Const.World.TerrainType.SnowyForest || i == this.Const.World.TerrainType.LeaveForest || i == this.Const.World.TerrainType.AutumnForest || i == this.Const.World.TerrainType.Badlands)
				{
				}
				else
				{
					disallowedTerrain.push(i);
				}
			}

			local tile = _action.getTileToSpawnLocation(10, disallowedTerrain, 7, 50, 1000, 3, 0, _nearTile, 0.2);

			if (tile == null)
			{
				return false;
			}

			if (_action.getDistanceToNextAlly(tile) <= distanceToNextAlly / (_nearTile == null ? 1 : 2))
			{
				return false;
			}

			local distanceToNextSettlement = _action.getDistanceToSettlements(tile);
			local party = _action.getFaction().spawnEntity(tile, "Стая Тигров", false, this.Const.World.Spawn.XXMobTiger, this.Math.rand(80, 120) * _action.getScaledDifficultyMult() * this.Math.maxf(0.7, this.Math.minf(1.5, distanceToNextSettlement / 14.0)));
			party.getSprite("banner").setBrush("banner_beasts_01");
			party.setDescription("Тигры — вышедшие на охоту.");
			party.setFootprintType(this.Const.World.FootprintsType.Direwolves);
			party.setSlowerAtNight(false);
			party.setUsingGlobalVision(false);
			party.setLooting(false);
			local roam = this.new("scripts/ai/world/orders/roam_order");
			roam.setNoTerrainAvailable();
			roam.setTerrain(this.Const.World.TerrainType.Forest, true);
			roam.setTerrain(this.Const.World.TerrainType.SnowyForest, true);
			roam.setTerrain(this.Const.World.TerrainType.LeaveForest, true);
			roam.setTerrain(this.Const.World.TerrainType.AutumnForest, true);
			roam.setTerrain(this.Const.World.TerrainType.Badlands, true);
			party.getController().addOrder(roam);
			return true;
		};
		this.m.Options.push(beast);
		this.m.BeastsMedium.push(beast);

//Медвежата
		beast = function ( _action, _nearTile = null )
		{
			local disallowedTerrain = [];

			for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
			{
				if (i == this.Const.World.TerrainType.Forest || i == this.Const.World.TerrainType.SnowyForest || i == this.Const.World.TerrainType.LeaveForest || i == this.Const.World.TerrainType.AutumnForest || i == this.Const.World.TerrainType.Badlands)
				{
				}
				else
				{
					disallowedTerrain.push(i);
				}
			}

			local tile = _action.getTileToSpawnLocation(10, disallowedTerrain, 7, 50, 1000, 3, 0, _nearTile, 0.2);

			if (tile == null)
			{
				return false;
			}

			if (_action.getDistanceToNextAlly(tile) <= distanceToNextAlly / (_nearTile == null ? 1 : 2))
			{
				return false;
			}

			local distanceToNextSettlement = _action.getDistanceToSettlements(tile);
			local party = _action.getFaction().spawnEntity(tile, "Стая Голодных Медведей", false, this.Const.World.Spawn.XXMobBear, this.Math.rand(80, 120) * _action.getScaledDifficultyMult() * this.Math.maxf(0.7, this.Math.minf(1.5, distanceToNextSettlement / 14.0)));
			party.getSprite("banner").setBrush("banner_beasts_01");
			party.setDescription("Медведи-Убийцы в поисках еды готовы напасть и уничтожить все что встретят на своем пути.");
			party.setFootprintType(this.Const.World.FootprintsType.Direwolves);
			party.setSlowerAtNight(false);
			party.setUsingGlobalVision(false);
			party.setLooting(false);
			local roam = this.new("scripts/ai/world/orders/roam_order");
			roam.setNoTerrainAvailable();
			roam.setTerrain(this.Const.World.TerrainType.Forest, true);
			roam.setTerrain(this.Const.World.TerrainType.SnowyForest, true);
			roam.setTerrain(this.Const.World.TerrainType.LeaveForest, true);
			roam.setTerrain(this.Const.World.TerrainType.AutumnForest, true);
			roam.setTerrain(this.Const.World.TerrainType.Hills, true);
			roam.setTerrain(this.Const.World.TerrainType.Badlands, true);
			party.getController().addOrder(roam);
			return true;
		};
		this.m.Options.push(beast);
		this.m.BeastsMedium.push(beast);

//Жабы
		beast = function ( _action, _nearTile = null )
		{
			local disallowedTerrain = [];

			for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
			{
				if (i == this.Const.World.TerrainType.Oasis || i == this.Const.World.TerrainType.Swamp)
				{
				}
				else
				{
					disallowedTerrain.push(i);
				}
			}

			local tile = _action.getTileToSpawnLocation(10, disallowedTerrain, 7, 50, 1000, 3, 0, _nearTile, 0.2);

			if (tile == null)
			{
				return false;
			}

			if (_action.getDistanceToNextAlly(tile) <= distanceToNextAlly / (_nearTile == null ? 1 : 2))
			{
				return false;
			}

			local distanceToNextSettlement = _action.getDistanceToSettlements(tile);
			local party = _action.getFaction().spawnEntity(tile, "Колония Жаб", false, this.Const.World.Spawn.XXMobToad, this.Math.rand(80, 120) * _action.getScaledDifficultyMult() * this.Math.maxf(0.7, this.Math.minf(1.5, distanceToNextSettlement / 14.0)));
			party.getSprite("banner").setBrush("banner_beasts_01");
			party.setDescription("Колония Жаб, которые облюбовали ближайшую местность. Агрессивны к всему живому.");
			party.setFootprintType(this.Const.World.FootprintsType.Direwolves);
			party.setSlowerAtNight(false);
			party.setUsingGlobalVision(false);
			party.setLooting(false);
			local roam = this.new("scripts/ai/world/orders/roam_order");
			roam.setNoTerrainAvailable();
			roam.setTerrain(this.Const.World.TerrainType.Oasis, true);
			roam.setTerrain(this.Const.World.TerrainType.Swamp, true);
			party.getController().addOrder(roam);
			return true;
		};
		this.m.Options.push(beast);
		this.m.BeastsMedium.push(beast);

		if (this.Const.DLC.Desert)
		{

//Львы
            beast = function ( _action, _nearTile = null )
            {
                local disallowedTerrain = [];

                for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
                {
                    if (i == this.Const.World.TerrainType.Steppe || i == this.Const.World.TerrainType.Desert || i == this.Const.World.TerrainType.Oasis)
                    {
                    }
                    else
                    {
                        disallowedTerrain.push(i);
                    }
                }

                local tile = _action.getTileToSpawnLocation(10, disallowedTerrain, 7, 50, 1000, 3, 0, _nearTile, 0.2);

                if (tile == null)
                {
                    return false;
                }

                if (_action.getDistanceToNextAlly(tile) <= distanceToNextAlly / (_nearTile == null ? 1 : 2))
                {
                    return false;
                }

                local distanceToNextSettlement = _action.getDistanceToSettlements(tile);
                local party = _action.getFaction().spawnEntity(tile, "Прайд Львов", false, this.Const.World.Spawn.XXMobLion, this.Math.rand(80, 120) * _action.getScaledDifficultyMult() * this.Math.maxf(0.7, this.Math.minf(1.5, distanceToNextSettlement / 14.0)));
                party.getSprite("banner").setBrush("banner_beasts_01");
                party.setDescription("Львы — цари животных. Лучше держаться стороной от них.");
                party.setFootprintType(this.Const.World.FootprintsType.Direwolves);
                party.setSlowerAtNight(false);
                party.setUsingGlobalVision(false);
                party.setLooting(false);
                local roam = this.new("scripts/ai/world/orders/roam_order");
                roam.setNoTerrainAvailable();
                roam.setTerrain(this.Const.World.TerrainType.Steppe, true);
                roam.setTerrain(this.Const.World.TerrainType.Desert, true);
                roam.setTerrain(this.Const.World.TerrainType.Oasis, true);
                roam.setTerrain(this.Const.World.TerrainType.Hills, true);
                party.getController().addOrder(roam);
                return true;
            };
            this.m.Options.push(beast);
            this.m.BeastsMedium.push(beast);

//Анхеги
			beast = function ( _action, _nearTile = null )
			{
				if (this.World.getTime().Days < 25 && _nearTile == null)
				{
					return false;
				}

				local disallowedTerrain = [];

				for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
				{
					if (i == this.Const.World.TerrainType.Steppe || i == this.Const.World.TerrainType.Desert)
					{
					}
					else
					{
						disallowedTerrain.push(i);
					}
				}

				local tile = _action.getTileToSpawnLocation(10, disallowedTerrain, 18 - (_nearTile == null ? 0 : 10), 100, 1000, 3, 0, _nearTile, this.Const.DLC.Desert ? 0.1 : 0.0, 0.5);

				if (tile == null)
				{
					return false;
				}

				if (_action.getDistanceToNextAlly(tile) <= distanceToNextAlly / (_nearTile == null ? 1 : 2))
				{
					return false;
				}

				local distanceToNextSettlement = _action.getDistanceToSettlements(tile);
				local party = _action.getFaction().spawnEntity(tile, "Рой Анхегов", false, this.Const.World.Spawn.XXMobAnkheg, this.Math.rand(80, 120) * _action.getScaledDifficultyMult() * this.Math.maxf(0.7, this.Math.minf(1.5, distanceToNextSettlement / 14.0)));
				party.getSprite("banner").setBrush("banner_beasts_01");
				party.setDescription("Анхег похож на огромное насекомое с множеством лап. Его длинные усики подергиваются, реагируя на любое движение вокруг. На концах его лап огромные крюки, пригодные как для рытья, так и для того, чтобы хватать добычу. Его мощные челюсти способны перекусить небольшое дерево пополам. Также анхег может плеваться кислотой в своих врагов.");
				party.setFootprintType(this.Const.World.FootprintsType.Direwolves);
				party.setSlowerAtNight(false);
				party.setUsingGlobalVision(false);
				party.setLooting(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setNoTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Hills, true);
				roam.setTerrain(this.Const.World.TerrainType.Desert, true);
				roam.setTerrain(this.Const.World.TerrainType.Steppe, true);
				party.getController().addOrder(roam);
				return true;
			};
			this.m.Options.push(beast);
			this.m.BeastsMedium.push(beast);
		}
	}

	function onUpdate( _faction )
	{
		foreach( u in _faction.getUnits() )
		{
			if (!u.isDiscovered() && this.Time.getVirtualTimeF() - u.getSpawnTime() >= 20.0 * this.World.getTime().SecondsPerDay && !u.getSprite("selection").Visible && (this.World.State.getPlayer() == null || this.World.State.getPlayer().getTile().getDistanceTo(u.getTile()) >= 8))
			{
				u.die();
				break;
			}
		}

		if (_faction.getUnits().len() >= 15 + (this.Const.DLC.Desert ? 3 : 0))
		{
			return;
		}

		this.m.Score = 10;
	}

	function onClear()
	{
	}

	function onExecute( _faction )
	{
		local r = this.Math.rand(0, this.m.Options.len() - 1);

		if (this.World.getTime().Days <= 9)
		{
			local r_max = 0;

			if (this.Const.DLC.Desert)
			{
				r_max = r_max + 1;
			}

			r = this.Math.rand(0, r_max);
		}

		for( local i = 0; i < 15 - _faction.getUnits().len(); i = ++i )
		{
			if (this.m.Options[r](this))
			{
				this.m.Cooldown = 5.0;
				break;
			}
			else
			{
				this.m.Cooldown = 0.0;
			}
		}
	}

});

