this.send_rat_beast_roamers_action <- this.inherit("scripts/factions/faction_action", {
	m = {
		Options = [],
		BeastsLow = [],
		BeastsMedium = [],
		BeastsHigh = []
	},
	function create()
	{
		this.m.ID = "send_rat_beast_roamers_action";
		this.m.Cooldown = 5.0;
		this.faction_action.create();
		local distanceToNextAlly = 10;
		local ratbeast;

		ratbeast = function ( _action, _nearTile = null )
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
			local party = _action.getFaction().spawnEntity(tile, "Волкокрысы", false, this.Const.World.Spawn.WolfRat, this.Math.rand(80, 120) * _action.getScaledDifficultyMult() * this.Math.maxf(0.7, this.Math.minf(1.5, distanceToNextSettlement / 14.0)));
			party.getSprite("banner").setBrush("banner_beasts_01");
			party.setDescription("Волкокрыс - чудовищное создание, порождённое тайными техниками скавенов.");
			party.setFootprintType(this.Const.World.FootprintsType.Skavens);
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
		this.m.Options.push(ratbeast);
		this.m.BeastsLow.push(ratbeast);

		if (this.Const.DLC.Unhold)
		{
			ratbeast = function ( _action, _nearTile = null )
			{
				if (this.World.getTime().Days < 10 && _nearTile == null)
				{
					return false;
				}

				local disallowedTerrain = [];

				for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
				{
					if (i == this.Const.World.TerrainType.Tundra || i == this.Const.World.TerrainType.Hills || i == this.Const.World.TerrainType.Mountains)
					{
					}
					else
					{
						disallowedTerrain.push(i);
					}
				}

				local tile = _action.getTileToSpawnLocation(10, disallowedTerrain, 10 - (_nearTile == null ? 0 : 2), 100, 1000, 3, 0, _nearTile, 0.0, 0.9);

				if (tile == null)
				{
					return false;
				}

				if (_action.getDistanceToNextAlly(tile) <= distanceToNextAlly / (_nearTile == null ? 1 : 2))
				{
					return false;
				}

				local distanceToNextSettlement = _action.getDistanceToSettlements(tile);
				local party = _action.getFaction().spawnEntity(tile, "Крысоогры", false, this.Const.World.Spawn.RatOrge, this.Math.rand(80, 120) * _action.getScaledDifficultyMult() * this.Math.maxf(0.7, this.Math.minf(1.5, distanceToNextSettlement / 14.0)));
				party.getSprite("banner").setBrush("banner_beasts_01");
				party.setDescription("Крысоогр - смертоносная машина для убийств, сочетающий нечеловеческие рефлексы скавена с силой и размером огра.");
				party.setFootprintType(this.Const.World.FootprintsType.Skavens);
				party.setSlowerAtNight(true);
				party.setUsingGlobalVision(false);
				party.setLooting(false);
				party.getFlags().set("IsUnholds", true);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setNoTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Forest, true);
				roam.setTerrain(this.Const.World.TerrainType.Hills, true);
				roam.setTerrain(this.Const.World.TerrainType.Tundra, true);
				roam.setTerrain(this.Const.World.TerrainType.Mountains, true);
				party.getController().addOrder(roam);
				return true;
			};
			this.m.Options.push(ratbeast);
			this.m.BeastsMedium.push(ratbeast);
		}

		if (this.Const.DLC.Lindwurm)
		{
			ratbeast = function ( _action, _nearTile = null )
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
				local party = _action.getFaction().spawnEntity(tile, "Мерзость Адской Ямы", false, this.Const.World.Spawn.HellPit, this.Math.rand(80, 120) * _action.getScaledDifficultyMult() * this.Math.maxf(0.7, this.Math.minf(1.5, distanceToNextSettlement / 14.0)));
				party.getSprite("banner").setBrush("banner_beasts_01");
				party.setDescription("Мерзость Адской Ямы - гора уродливой плоти, движущаяся пульсирующей волной неестественных судорог, извивающаяся подобно червю и использующая свои многочисленные конечности, чтобы подтягивать и волочить своё чудовищное тело вперёд.");
				party.setFootprintType(this.Const.World.FootprintsType.Skavens);
				party.setSlowerAtNight(false);
				party.setUsingGlobalVision(false);
				party.setLooting(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setNoTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Forest, true);
				roam.setTerrain(this.Const.World.TerrainType.LeaveForest, true);
				roam.setTerrain(this.Const.World.TerrainType.AutumnForest, true);
				roam.setTerrain(this.Const.World.TerrainType.Desert, true);
				roam.setTerrain(this.Const.World.TerrainType.Steppe, true);
				party.getController().addOrder(roam);
				return true;
			};
			this.m.Options.push(ratbeast);
			this.m.BeastsHigh.push(ratbeast);
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

		if (_faction.getUnits().len() >= 5 + (this.Const.DLC.Desert ? 3 : 0))
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

			if (this.Const.DLC.Unhold)
			{
				r_max = r_max + 1;
			}

			r = this.Math.rand(0, r_max);
		}

		for( local i = 0; i < 5 - _faction.getUnits().len(); i = ++i )
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

