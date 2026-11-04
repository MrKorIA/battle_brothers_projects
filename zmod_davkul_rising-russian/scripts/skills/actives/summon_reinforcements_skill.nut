this.summon_reinforcements_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.summon_reinforcements";
		this.m.Name = "Призыв подкрепления";
		this.m.Description = "";
		this.m.Icon = "ui/perks/perk_42_active.png";
		this.m.IconDisabled = "ui/perks/perk_42_active_sw.png";
		this.m.Overlay = "perk_42_active";
		this.m.SoundOnUse = [
			"sounds/combat/rally_the_troops_01.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Any;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = false;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.ActionPointCost = 0;
		this.m.FatigueCost = 25;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.Cooldown <- 0
	}

	function isUsable()
	{
		return this.m.Cooldown == 0 && this.skill.isUsable()
	}

	function onUse( _user, _targetTile )
	{
		local myTile = _user.getTile();
		local numSummons = 4 - this.Math.min(2, this.getCultists().m.Flags.get("RitualSitesBeat"))
		local map =  this.Tactical.getMapSize();
		local spawnTiles = [], tileArray = []

		local minX = 10, maxX = 30, minY = 2, maxY = 5
		for (local x = minX; x < maxX; x++) {
		    for (local y = minY; y < maxY; y++) {
		        tileArray.push(this.Tactical.getTileSquare(y, x))
		    }
		}
		local idx = 0, temparr = []
		//get tiles to spawn reinforcments
		while (tileArray.len() > 0) {
			idx = this.Math.rand(0, tileArray.len()-1)
			temparr = []
		    local startTile = tileArray.remove(idx)
		    if (!startTile.IsEmpty || startTile.IsVisibleForPlayer) continue
		    temparr.push(startTile)

		    for( local i = 0; i < 6; i = ++i )
			{
				if (startTile.hasNextTile(i))
				{
					local nextTile = startTile.getNextTile(i);
					if (nextTile.IsEmpty && !startTile.IsVisibleForPlayer) temparr.push(nextTile)
				}
			}
			if (temparr.len() >= numSummons){
				spawnTiles = temparr
				break
			}
		}

		for( local i = 0; i < numSummons; i = ++i )
		{
			local tile = spawnTiles.pop()
			local spawn = this.Tactical.spawnEntity("scripts/entity/tactical/cultist/mod_cultist_fanatic", tile.Coords);
			spawn.setFaction(_user.getFaction());
			spawn.assignRandomEquipment()
		}
		this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_user) + " призывает подкрепление!");
		this.m.Cooldown = 3
		return true;
	}

	function onTurnEnd()
	{
		this.m.Cooldown = this.Math.max(0, this.m.Cooldown-1);
	}

	function isTileIsolated( _tile )
	{
		local isCompletelyIsolated = true;

		for( local i = 0; i != 6; i = ++i )
		{
			if (!_tile.hasNextTile(i))
			{
			}
			else if (_tile.getNextTile(i).IsEmpty && this.Math.abs(_tile.Level - _tile.getNextTile(i).Level) <= 1)
			{
				isCompletelyIsolated = false;
				break;
			}
		}

		if (isCompletelyIsolated)
		{
			return true;
		}

		local size = this.Tactical.getMapSize();

		if (_tile.Level == 0 && this.Tactical.getTileSquare(0, 0).Level == 3 && this.Tactical.getTileSquare(size.X - 1, size.Y - 1).Level == 3 && this.Tactical.getTileSquare(0, size.Y - 1).Level == 3 && this.Tactical.getTileSquare(size.X - 1, 0).Level == 3)
		{
			return false;
		}

		local allFactions = [];
		allFactions.resize(32, 0);

		for( local i = 0; i != 32; i = ++i )
		{
			allFactions[i] = i;
		}

		local navigator = this.Tactical.getNavigator();
		local settings = navigator.createSettings();
		settings.ActionPointCosts = this.Const.SameMovementAPCost;
		settings.FatigueCosts = this.Const.PathfinderMovementFatigueCost;
		settings.AllowZoneOfControlPassing = true;
		settings.AlliedFactions = allFactions;

		if (!navigator.findPath(_tile, this.Tactical.getTileSquare(0, 0), settings, 1) && !navigator.findPath(_tile, this.Tactical.getTileSquare(size.X - 1, size.Y - 1), settings, 1) && !navigator.findPath(_tile, this.Tactical.getTileSquare(0, size.Y - 1), settings, 1) && !navigator.findPath(_tile, this.Tactical.getTileSquare(size.X - 1, 0), settings, 1))
		{
			return true;
		}

		return false;
	}

});

