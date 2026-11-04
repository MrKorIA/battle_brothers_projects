::VanillaPlus.HooksMod.hook("scripts/states/world_state", function(q) {
	q.getLocalCombatProperties = @(__original) function( _pos, _ignoreNoEnemies = false )
	{
		local ret = __original(_pos, _ignoreNoEnemies);

		if (!ret.IsAttackingLocation) return ret;

		local tile = ::World.getTile(::World.worldToTile(_pos));
		local tileCenterEntities = ::World.getAllEntitiesAtPos(tile.Pos, 10);

		foreach (entity in tileCenterEntities)
		{
			if (!entity.isLocation()) continue;
			if (entity.m.CP_TacticalTypeOverwrite == null) continue;

			ret.TerrainTemplate = entity.m.CP_TacticalTypeOverwrite;
			break;
		}

		return ret;
	}

	q.showCombatDialog = @(__original) function( _isPlayerInitiated = true, _isCombatantsVisible = true, _allowFormationPicking = true, _properties = null, _pos = null )
	{
		if (_pos == null) _pos = this.m.Player.getPos();
		local tile = ::World.getTile(::World.worldToTile(_pos));

		local oldEngageImage = ::Const.World.TerrainTacticalImage[tile.TacticalType];

		local tileCenterEntities = ::World.getAllEntitiesAtPos(tile.Pos, 10);
		foreach (entity in tileCenterEntities)
		{
			if (!entity.isLocation()) continue;
			if (entity.m.CP_EngageImageOverwrite == null) continue;

			::Const.World.TerrainTacticalImage[tile.TacticalType] = entity.m.CP_EngageImageOverwrite;
			break;
		}

		__original(_isPlayerInitiated, _isCombatantsVisible, _allowFormationPicking, _properties, _pos);

		::Const.World.TerrainTacticalImage[tile.TacticalType] = oldEngageImage;
	}
});
