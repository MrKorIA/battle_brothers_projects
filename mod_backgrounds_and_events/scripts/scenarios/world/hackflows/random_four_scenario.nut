this.random_four_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.hackflows_random_four";
		this.m.Name = "Случайная четверка";
		this.m.Description = "[p=c][img]gfx/ui/events/event_134.png[/img][/p][p]Вы понятия не имеете, какая чертовщина свела вас четверых в один отряд. Как бы то ни было, сейчас самое подходящее время для этой разношёрстной компании, чтобы наконец стать профессиональными наёмниками.\n\n[color=#bcad8c]Странные обстоятельства:[/color] Начните с четырьмя братьями, чьи предыстории будут абсолютно случайными - судьба может свести вместе кого угодно.\n[color=#bcad8c]Нить судьбы:[/color] Начните без известности, но ваша известность растёт на четверть быстрее.[/p]";
		this.m.Difficulty = 2;
		this.m.Order = 53;
		this.m.IsFixedLook = true;
	}

	function isValid()
	{
		return this.Const.DLC.Wildmen && this.Const.DLC.Unhold && this.Const.DLC.Desert;
	}

	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();

		for( local i = 0; i < 4; i++ )
		{
			local bro;
			bro = roster.create("scripts/entity/tactical/player");
			bro.m.HireTime = this.Time.getVirtualTimeF();
			bro.setStartValuesEx(this.Const.AllCharacterBackgrounds);
		}

		local bros = roster.getAll();
		this.World.Assets.m.BusinessReputation = 0;
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/bread_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/smoked_ham_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/loot/ornate_tome_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/loot/ornate_tome_item"));
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (!randomVillage.isMilitary() && !randomVillage.isIsolatedFromRoads() && randomVillage.getSize() >= 3)
			{
				break;
			}

			i = ++i;
			i = i;
		}

		local randomVillageTile = randomVillage.getTile();
		local navSettings = this.World.getNavigator().createSettings();
		navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;

		do
		{
			local x = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.X - 8), this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 8));
			local y = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.Y - 8), this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 8));

			if (!this.World.isValidTileSquare(x, y))
			{
			}
			else
			{
				local tile = this.World.getTileSquare(x, y);

				if (tile.IsOccupied)
				{
				}
				else if (tile.getDistanceTo(randomVillageTile) <= 5)
				{
				}
				else if (!tile.HasRoad)
				{
				}
				else
				{
					local path = this.World.getNavigator().findPath(tile, randomVillageTile, navSettings, 0);

					if (!path.isEmpty())
					{
						randomVillageTile = tile;
						break;
					}
				}
			}
		}
		while (1);

		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		this.World.Assets.updateLook(9);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList([
				"music/civilians_01.ogg"
			], this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.hackflows_random_four_intro");
		}, null);
	}

	function onInit()
	{
		this.World.Assets.m.BusinessReputationRate = 1.25;
	}

	function onUpdateHiringRoster( _roster )
	{
	}

});

