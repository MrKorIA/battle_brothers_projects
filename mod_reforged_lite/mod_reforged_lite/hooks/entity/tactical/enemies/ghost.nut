// Слеза гейста: 20% дроп с ванильного призрака (аналог хука ghost.nut Reforged 0.9.3) —
// ингредиент крафта зелий у алхимика.
::ReforgedLite.HooksMod.hook("scripts/entity/tactical/enemies/ghost", function(q) {
	q.getLootForTile = @(__original) { function getLootForTile( _killer, _loot )
	{
		local ret = __original(_killer, _loot);

		if (_killer == null || _killer.getFaction() == ::Const.Faction.Player || _killer.getFaction() == ::Const.Faction.PlayerAnimals)
		{
			if (::Math.rand(1, 100) <= 20)
			{
				ret.push(::new("scripts/items/loot/rf_geist_tear_item"));
			}
		}

		return ret;
	}}.getLootForTile;
});
