::VanillaPlus.HooksMod.hook("scripts/entity/world/location", function(q) {
	q.m.CP_CanSpawnRoamer <- false;		// New flag that tells us, whether some new spawn-related functions are implemented

	q.onDeserialize = @(__original) function( _in )
	{
		__original(_in);
		local spawnListId = this.getDefenderSpawnListId();
		if (spawnListId != "")
		{
			this.setDefenderSpawnListId(spawnListId);
		}
	}

// New Functions
	q.getDefenderSpawnListId <- function()
	{
		if (this.getFlags().has("CP_SpawnListId"))
		{
			return this.getFlags().get("CP_SpawnListId");
		}
		return "";
	}

	q.setDefenderSpawnListId <- function( _spawnListId )
	{
		this.getFlags().set("CP_SpawnListId", _spawnListId);
		this.setDefenderSpawnList(::Const.World.Spawn[_spawnListId]);
	}

});
