this.mod_ai_counter_player_animals <- ::inherit("scripts/ai/tactical/behavior", {
	// counter player animals by spawning more ghosts XD
	m = {
		Tiles = [],
		SpawnList = [],
		Ghosts = 0,
		Skill = null,
		PossibleSkills = [
			"actives.mass_spawn_ghost"
		],
		WaitUntil = 0.0
	},
	function create()
	{
		this.m.ID = ::Const.AI.Behavior.ID.MirrorImage;
		this.m.Order = ::Const.AI.Behavior.Order.MirrorImage;
		//this.m.IsThreaded = true;
		this.behavior.create();
	}

	function onEvaluate( _entity )
	{
		this.m.Tiles = [];
		this.m.SpawnList = [];
		this.m.Skill = null;
		this.m.WaitUntil = 0.0;
		local scoreMult = this.getProperties().BehaviorMult[this.m.ID];
		local time = ::Time.getExactTime();

		if (::Tactical.TurnSequenceBar.isLastEntityActive() && ::Tactical.TurnSequenceBar.getActiveEntity().getID() == _entity.getID())
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		this.m.Skill = this.selectSkill(this.m.PossibleSkills);

		if (this.m.Skill == null)
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		local ghosts = 0;
		local players = ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player).len();
		local player_animals = ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.PlayerAnimals).len();

		if (player_animals < players * 0.2)
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		foreach (e in ::Tactical.Entities.getInstancesOfFaction(_entity.getFaction()))
		{
			if (e.getType() == ::Const.EntityType.Ghost || e.getType() == ::Const.EntityType.LegendBanshee)
			if (e.getType() == ::Const.EntityType.Ghost)
			{
				++ghosts;
			}
		}

		if (ghosts - 1 >= player_animals)
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		this.m.Ghosts = ::Math.max(1, player_animals - ghosts + 1);
		local myTile = _entity.getTile();
		local mapSize = ::Tactical.getMapSize();
		local attempts = 0;
		local usedIDs = [];

		while (attempts++ < 250)
		{
			local x = ::Math.rand(::Math.max(0, myTile.SquareCoords.X - 5), ::Math.min(mapSize.X - 1, myTile.SquareCoords.X + 5));
			local y = ::Math.rand(::Math.max(0, myTile.SquareCoords.Y - 5), ::Math.min(mapSize.Y - 1, myTile.SquareCoords.Y + 5));

			if (!::Tactical.isValidTileSquare(x, y))
			{
				continue;
			}

			local tile = ::Tactical.getTileSquare(x, y);

			if (!tile.IsEmpty || usedIDs.find(tile.ID) != null)
			{
				continue;
			}

			usedIDs.push(tile.ID);
			this.m.Tiles.push(tile);

			if (--this.m.Ghosts <= 0)
			{
				break;
			}
		}

		if (this.m.Tiles.len() == 0)
		{
			return ::Const.AI.Behavior.Score.Zero;
		}

		this.m.SpawnList = this.prepareSpawnlist();
		return ::Const.AI.Behavior.Score.MirrorImage * scoreMult;
	}

	function onExecute( _entity )
	{
		if (this.m.IsFirstExecuted)
		{
			this.getAgent().adjustCameraToDestination(_entity.getTile());
			this.m.IsFirstExecuted = false;
			this.m.Skill.use(_entity.getTile());
			this.m.WaitUntil = ::Time.getRealTimeF() + 1.45;
			return false;
		}
		else if (::Time.getRealTimeF() >= this.m.WaitUntil)
		{
			local _f = _entity.getFaction();

			foreach(i, tile in this.m.Tiles )
			{
				local ghost = ::Tactical.spawnEntity("scripts/entity/tactical/enemies/" + this.m.SpawnList[i], tile.Coords);
				ghost.setFaction(_f);
				ghost.getSkills().add(::new("scripts/skills/perks/perk_fearsome"));
				this.spawnSpawnEffect(tile);
			}

			this.m.Tiles = [];
			this.m.SpawnList = [];
			this.getAgent().declareEvaluationDelay(this.m.Skill.getDelay() + 1000);
			return true;
		}

		return false;
	}

	function prepareSpawnlist()
	{
		local difficulty = ::Tactical.Entities.getFlags().getAsInt("ghost_illusion_difficulty");
		local list = [];

		foreach (tile in this.m.Tiles)
		{
			if (::Math.rand(1, 15) <= difficulty)
			{
				list.push("legend_banshee");
			}
			else
			{
				list.push("ghost");
			}
		}

		return list;
	}

	function spawnSpawnEffect( _tile )
	{
		local effect = {
			Delay = 0,
			Quantity = 12,
			LifeTimeQuantity = 12,
			SpawnRate = 100,
			Brushes = [
				"bust_ghost_01"
			],
			Stages = [
				{
					LifeTimeMin = 1.0,
					LifeTimeMax = 1.0,
					ColorMin = ::createColor("ffffff5f"),
					ColorMax = ::createColor("ffffff5f"),
					ScaleMin = 1.0,
					ScaleMax = 1.0,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = ::createVec(-1.0, -1.0),
					DirectionMax = ::createVec(1.0, 1.0),
					SpawnOffsetMin = ::createVec(-10, -10),
					SpawnOffsetMax = ::createVec(10, 10),
					ForceMin = ::createVec(0, 0),
					ForceMax = ::createVec(0, 0)
				},
				{
					LifeTimeMin = 1.0,
					LifeTimeMax = 1.0,
					ColorMin = ::createColor("ffffff2f"),
					ColorMax = ::createColor("ffffff2f"),
					ScaleMin = 0.9,
					ScaleMax = 0.9,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = ::createVec(-1.0, -1.0),
					DirectionMax = ::createVec(1.0, 1.0),
					ForceMin = ::createVec(0, 0),
					ForceMax = ::createVec(0, 0)
				},
				{
					LifeTimeMin = 0.1,
					LifeTimeMax = 0.1,
					ColorMin = ::createColor("ffffff00"),
					ColorMax = ::createColor("ffffff00"),
					ScaleMin = 0.1,
					ScaleMax = 0.1,
					RotationMin = 0,
					RotationMax = 0,
					VelocityMin = 80,
					VelocityMax = 100,
					DirectionMin = ::createVec(-1.0, -1.0),
					DirectionMax = ::createVec(1.0, 1.0),
					ForceMin = ::createVec(0, 0),
					ForceMax = ::createVec(0, 0)
				}
			]
		};
		::Tactical.spawnParticleEffect(false, effect.Brushes, _tile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, ::createVec(0, 40));
	}

});

