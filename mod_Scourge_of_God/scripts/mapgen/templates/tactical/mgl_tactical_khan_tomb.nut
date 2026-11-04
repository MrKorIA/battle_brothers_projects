this.mgl_tactical_khan_tomb <- this.inherit("scripts/mapgen/tactical_template", {
	m = {},
	function init()
	{
		this.m.Name = "tactical.mgl_khan_tomb";
		this.m.MinX = 32;
		this.m.MinY = 32;
	}

	// Геометрия арены (0,0 — левый нижний угол, поле 32x32):
	//   - овальный зал: центр (19,15), радиусы (10, 8)
	//   - коридор входа: x 0..9, y 12..19 (слева)
	//   - зелёный (спавн игрока):   x 10..11, y 12..19
	//   - оранжевый (спавн врагов): x 17..18, y 11..20
	//   - жёлтый (саркофаг):       объект на (25,15)
	//   - ниши: верх (13,22) (19,22) (25,22), низ (13,8) (19,8) (25,8),
	//     каждая — альков 3x2, прорезанный в стене и ограниченный ею с трёх сторон
	function fill( _rect, _properties, _pass = 1 )
	{
		// ВАЖНО: стены кургана рисует TerrainTemplate (tactical.mgl_cave_ground) —
		// этот шаблон лишь ПРОРЕЗАЕТ в них зал и коридор. Самому красить стены
		// нельзя: патч CP_cave_thick красит только тайлы с Type == 0, а к этому
		// моменту базовая местность уже раздала всем тайлам свой Type.
		local tile1 = ::MapGen.get("tactical.tile.stone1");
		local tile2 = ::MapGen.get("tactical.tile.stone2");

		local cx = 19;
		local cy = 15;

		local function isOpen( _x, _y )
		{
			// коридор
			if (_x <= 9 && _y >= 12 && _y <= 19) return true;
			// овальный зал
			local dx = (_x - cx) * 1.0 / 10.0;
			local dy = (_y - cy) * 1.0 / 8.0;
			return dx * dx + dy * dy <= 1.0;
		}

		local alcoves = [
			{ X = 13, Y = 22, Top = true }, { X = 19, Y = 22, Top = true }, { X = 25, Y = 22, Top = true },
			{ X = 13, Y = 8, Top = false }, { X = 19, Y = 8, Top = false }, { X = 25, Y = 8, Top = false }
		];
		local function inAlcove( _x, _y )
		{
			foreach (a in alcoves)
			{
				if (_x >= a.X - 1 && _x <= a.X + 1)
				{
					if (a.Top && _y >= a.Y && _y <= a.Y + 1) return true;
					if (!a.Top && _y >= a.Y - 1 && _y <= a.Y) return true;
				}
			}
			return false;
		}

		// --- этап 1: вырубаем зал, коридор и альковы ниш в каменной толще ---
		for (local x = _rect.X; x < _rect.X + _rect.W; ++x)
		{
			for (local y = _rect.Y; y < _rect.Y + _rect.H; ++y)
			{
				if (!::Tactical.isValidTileSquare(x, y)) continue;
				if (!isOpen(x, y) && !inAlcove(x, y)) continue;

				local tile = ::Tactical.getTileSquare(x, y);
				tile.Type = 0;
				tile.Level = 0;
				tile.IsSpecialTerrain = false;
				if (!tile.IsEmpty)
				{
				    tile.clear();
				    tile.removeObject();
				}
				if (::Math.rand(1, 100) < 60)
					tile1.fill({ X = x, Y = y, W = 1, H = 1 }, _properties);
				else
					tile2.fill({ X = x, Y = y, W = 1, H = 1 }, _properties);
			}
		}


		// --- этап 3: декали — шкуры и объедки кочевников, разреженные по проходимой зоне ---
		local decalBrushes = ["orcs_07", "orcs_07", "orcs_02", "orcs_03"];
		for (local i = 0; i < 40; ++i)
		{
			local x = ::Math.rand(1, 30);
			local y = ::Math.rand(1, 30);
			if (!::Tactical.isValidTileSquare(x, y)) continue;
			local tile = ::Tactical.getTileSquare(x, y);
			if (tile.IsSpecialTerrain || !tile.IsEmpty || tile.IsOccupiedByActor) continue;
			if (!isOpen(x, y)) continue;
			if (::Math.rand(1, 100) > 45) continue; // редкий слой
			tile.spawnDetail(decalBrushes[::Math.rand(0, decalBrushes.len() - 1)]);
		}

		this.makeBordersImpassable(_rect);
	}

	function campify( _rect, _properties )
	{
		return;
	}
});
