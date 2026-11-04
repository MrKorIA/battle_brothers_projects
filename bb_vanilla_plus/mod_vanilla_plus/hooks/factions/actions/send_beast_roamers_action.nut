::VanillaPlus.HooksMod.hook("scripts/factions/actions/send_beast_roamers_action", function(q) {
	// Public
	q.m.MaxSpawnedParties <- 6;	// This many beast roamers may be on the world map at the same time
	q.m.NarrowedOptions <- [];	// Array of vanilla options minus everything covered by new caves

	// Private
	q.m.RoamerFlagName <- "CP_IsVanillaRoamer";

	q.create = @(__original) function()
	{
		__original();

		this.m.NarrowedOptions = this.m.Options;
		this.m.NarrowedOptions.remove(0);		// Remove Nachzehrer from spawn-pool
		this.m.NarrowedOptions.remove(0);		// Remove Direwolves from spawn-pool
		this.m.NarrowedOptions.remove(0);		// Remove Hyenas from spawn-pool
		this.m.NarrowedOptions.remove(0);		// Remove Serpents from spawn-pool
		this.m.NarrowedOptions.remove(0);		// Remove Webknechts from spawn-pool
		this.m.NarrowedOptions.remove(0);		// Remove Unholds from spawn-pool
		this.m.NarrowedOptions.remove(0);		// Remove Frost Unholds from spawn-pool
		this.m.NarrowedOptions.remove(0);		// Remove Bog Unholds from spawn-pool
		// Keep Alps in the pool
		this.m.NarrowedOptions.remove(1);		// Remove Hexen from spawn-pool
		// Keep Schrats in the pool
		// Keep Kraken in the pool
		// Keep Ifrits in the pool
		this.m.NarrowedOptions.remove(4);		// Remove Lindwurms from spawn-pool

		// We run __original again in order to fill this.m.Options a second time as we need to preserve the original options for something like big_game_hunt accessing it
		this.m.Options = [];
		__original();
	}

	// Overwrite, because we simplify the vanilla calculation a lot and remove its hard-coded exclusion of certain high level beasts.
	// That is now handled in the onUpdate
	q.onExecute = @() function( _faction )
	{
		if (::MSU.Array.rand(this.m.NarrowedOptions)(this))
		{
			this.m.Cooldown = 10.0;
			if (::MSU.isNull(_faction.m.CP_LastSpawnedParty))
			{
				::logWarning("CrockPot: CP_LastSpawnedParty is null, this should not happen!");
			}
			else
			{
				_faction.m.CP_LastSpawnedParty.getFlags().set(this.m.RoamerFlagName, true);
			}
		}
		else
		{
			this.m.Cooldown = 3.0;	// A cooldown of 0 might be in-performance, in case all current beasts are difficult to spawn
		}

	}

	q.onUpdate = @(__original) function( _faction )
	{
		__original(_faction);	// So the beast-cleanup still works

		this.m.Score = 0;	// We calculate the score once again

		// We don't allow the full 'MaxSpawnedParties' from day one, because currently nothing will spawn anyways this early anyways
		// And we don't want beasts, introduced by mods, to take up all the slots right away
		local allowedSpawns = ::Math.min(::World.getTime().Days / 3, this.m.MaxSpawnedParties);

		// We enforce the maximum beasts on the map via a member variable now
		if (this.getSpawnedParties(_faction).len() > allowedSpawns) return;

		this.m.Score = 10;
	}

// New Functions
	q.getSpawnedParties <- function( _faction )
	{
		local spawnedParties = [];
		foreach (worldParty in _faction.getUnits())
		{
			if (worldParty.getFlags().has(this.m.RoamerFlagName))
			{
				spawnedParties.push(worldParty);
			}
		}
		return spawnedParties;
	}
});
