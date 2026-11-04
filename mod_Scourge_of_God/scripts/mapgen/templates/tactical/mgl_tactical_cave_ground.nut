this.mgl_tactical_cave_ground <- this.inherit("scripts/mapgen/tactical_template", {
	m = {},
	function init()
	{
		this.m.Name = "tactical.mgl_cave_ground";
		this.m.MinX = 32;
		this.m.MinY = 32;
	}

	// Базовая карта боя — сплошная каменная толща кургана.
	// РАБОТАЕТ ТОЛЬКО как TerrainTemplate: патч CP_cave_thick красит
	// исключительно тайлы с Type == 0, поэтому эта заливка должна идти
	// ПЕРВОЙ (до fill шаблона локации, который прорезает зал и коридор).
	function fill( _rect, _properties, _pass = 1 )
	{
		local wallPatch = ::MapGen.get("tactical.patch.CP_cave_thick"); // локальная копия в этом моде (patches/CP_patch_cave_thick.nut)

		for (local x = _rect.X; x < _rect.X + _rect.W; ++x)
		{
			for (local y = _rect.Y; y < _rect.Y + _rect.H; ++y)
			{
				if (!::Tactical.isValidTileSquare(x, y)) continue;
				local tile = ::Tactical.getTileSquare(x, y);
				tile.Level = 0;
				wallPatch.fill({ X = x, Y = y, W = 1, H = 1 }, _properties);
			}
		}

		this.makeBordersImpassable(_rect);
	}

	function campify( _rect, _properties )
	{
		// центр не зачищаем: проходимые зоны и объекты определяет локация
		return;
	}
});
