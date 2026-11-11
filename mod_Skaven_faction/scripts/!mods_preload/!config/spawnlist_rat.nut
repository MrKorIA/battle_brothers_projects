// Генератор спавн-листов скавенов (Smooth Weighted Round-Robin).
// Портировано из spawnlist_wushi.nut (мод Samurai).
//
// Режимы:
//   Mode = "Weighted"  — единый пул юнитов с весами.
//   Mode = "Archetype" — несколько архетипов отрядов, чередующихся по бюджету.
//
// Архетипы поддерживают MinR/MaxR: архетип участвует в ротации только
// на бюджетах своего ценового диапазона. Это позволяет передать
// ручные спавн-листы (разные типы отрядов в разных бюджетных бэндах).

// ==========================================================
// SORT
// ==========================================================

local function onCostCompare( _t1, _t2 )
{
    if (_t1.Cost < _t2.Cost) return -1;
    if (_t1.Cost > _t2.Cost) return 1;
    return 0;
}

// ==========================================================
// COSTS
// ==========================================================

local function calculateCosts( _p )
{
    foreach (p in _p)
    {
        p.Cost <- 0;

        foreach (t in p.Troops)
        {
            p.Cost += t.Type.Cost * t.Num;
        }

        if (!("MovementSpeedMult" in p)) p.MovementSpeedMult <- 1.0;
        if (!("VisibilityMult"    in p)) p.VisibilityMult    <- 1.0;
        if (!("VisionMult"        in p)) p.VisionMult        <- 1.0;
    }

    _p.sort(onCostCompare);
}

// ==========================================================
// UNIT VALIDATION
// ==========================================================

// Возвращает эффективный вес юнита на текущем бюджете.
// Если задан FadeR — линейно гасит вес от FadeStartR до FadeR.
local function getEffectiveWeight( _u, _budget )
{
    if (!("FadeR" in _u)) return _u.Weight;

    local startR = ("FadeStartR" in _u) ? _u.FadeStartR : 0;

    if (_budget <= startR) return _u.Weight;
    if (_budget >= _u.FadeR) return 0;

    local t = (_budget - startR).tofloat() / (_u.FadeR - startR).tofloat();
    return (_u.Weight * (1.0 - t)).tointeger();
}

local function isUnitAvailable( _u, _budget, _remaining, _counts )
{
    if (getEffectiveWeight(_u, _budget) <= 0) return false;
    if (_u.Type.Cost > _remaining) return false;
    if ("MinR" in _u && _budget < _u.MinR) return false;
    if ("MaxR" in _u && _budget > _u.MaxR) return false;
    if ("MaxCount" in _u && _counts[_u.Type] >= _u.MaxCount) return false;
    return true;
}

// Суммарный вес доступных юнитов для SWRR.
// ПЕРЕСЧИТЫВАЕТСЯ НА КАЖДОМ ШАГЕ: когда MaxCount выводит тяжёлых юнитов
// из ротации, фиксированный totalWeight по всем юнитам ломал пропорции —
// выжившие юниты получали ~1/N хвоста независимо от веса.
local function computeAvailableTotalWeight( _units, _budget, _remaining, _counts )
{
    local sum = 0;
    foreach (u in _units)
    {
        if (!isUnitAvailable(u, _budget, _remaining, _counts)) continue;
        sum += getEffectiveWeight(u, _budget);
    }
    return sum > 0 ? sum : 1;
}

// ==========================================================
// SWRR TROOP FILLER
// ==========================================================

local function resolveBody( _troops, _defaultBody, _units )
{
    local overrideByType = {};
    foreach (u in _units)
    {
        if ("BodyOverride" in u)
        {
            overrideByType[u.Type] <- {
                Body     = u.BodyOverride,
                Priority = ("BodyPriority" in u) ? u.BodyPriority : 0
            };
        }
    }

    local bestBody     = _defaultBody;
    local bestPriority = -1000000;

    foreach (t in _troops)
    {
        if (!(t.Type in overrideByType)) continue;
        local o = overrideByType[t.Type];
        if (o.Priority > bestPriority)
        {
            bestPriority = o.Priority;
            bestBody     = o.Body;
        }
    }

    return bestBody;
}

local function fillTroops( _units, _budget )
{
    local troops = [];
    local counts = {};
    local accum  = {};

    // Ключ — сам объект Type (гарантированно уникален)
    foreach (u in _units)
    {
        counts[u.Type] <- 0;
        accum[u.Type]  <- 0;
    }

    local spent = 0;

    while (true)
    {
        local remaining = _budget - spent;

        // Шаг 1. Начисляем вес доступным юнитам
        foreach (u in _units)
        {
            if (!isUnitAvailable(u, _budget, remaining, counts)) continue;
            accum[u.Type] += getEffectiveWeight(u, _budget);
        }

        // Шаг 2. Ищем победителя
        local bestUnit  = null;
        local bestScore = -1000000;

        foreach (u in _units)
        {
            if (!isUnitAvailable(u, _budget, remaining, counts)) continue;
            if (accum[u.Type] > bestScore)
            {
                bestScore = accum[u.Type];
                bestUnit  = u;
            }
        }

        if (bestUnit == null) break;

        // Шаг 3. Сброс счётчика победителя на суммарный вес ДОСТУПНЫХ юнитов
        accum[bestUnit.Type] -= computeAvailableTotalWeight(_units, _budget, remaining, counts);

        // Шаг 4. Запись победителя
        local found = false;
        foreach (t in troops)
        {
            if (t.Type == bestUnit.Type)
            {
                t.Num++;
                found = true;
                break;
            }
        }
        if (!found)
        {
            troops.push({ Type = bestUnit.Type, Num = 1 });
        }

        counts[bestUnit.Type]++;
        spent += bestUnit.Type.Cost;
    }

    return troops;
}

// ==========================================================
// LEADER ARCHETYPES SUPPORT
// ==========================================================

// Слияние юнитов с УЖЕСТОЧЕНИЕМ лимитов.
local function addUnit( _units, _unitsByType, _u )
{
    local key = _u.Type;

    if (!(key in _unitsByType))
    {
        local copy = {};
        foreach (k, v in _u) copy[k] <- v;
        _units.push(copy);
        _unitsByType[key] <- copy;
        return;
    }

    local existing = _unitsByType[key];

    // Вес суммируется
    existing.Weight += _u.Weight;

    // MinR НЕ сливаем: лидерский архетип уже ограничен своим arch.MinR.
    if ("MinR" in _u && !("MinR" in existing))
    {
        existing.MinR <- _u.MinR;
    }

    // MaxR — берём минимум (ужесточение).
    if ("MaxR" in _u)
    {
        if (!("MaxR" in existing)) existing.MaxR <- _u.MaxR;
        else existing.MaxR = existing.MaxR < _u.MaxR ? existing.MaxR : _u.MaxR;
    }

    // MaxCount — берём минимум (ужесточение).
    if ("MaxCount" in _u)
    {
        if (!("MaxCount" in existing)) existing.MaxCount <- _u.MaxCount;
        else existing.MaxCount = existing.MaxCount < _u.MaxCount
            ? existing.MaxCount : _u.MaxCount;
    }
}

// Собирает пул юнитов для одного бюджета, опционально добавляя лидерский архетип.
local function buildUnitPoolWithLeaderArchetype(
    _cfg, _budget, _minR, _step, _leaderInterval )
{
    local units       = [];
    local unitsByType = {};

    // Базовый пул
    foreach (u in _cfg.Units)
    {
        addUnit(units, unitsByType, u);
    }

    if (!("LeaderArchetypes" in _cfg)) return units;

    // Отбираем лидерские архетипы, доступные на этом бюджете
    local availableLeaders = [];
    foreach (arch in _cfg.LeaderArchetypes)
    {
        if (_budget >= arch.MinR) availableLeaders.push(arch);
    }
    if (availableLeaders.len() == 0) return units;

    // Каждый _leaderInterval-й пресет — лидерский
    local stepIndex = ( _budget - _minR ) / _step;
    if (stepIndex % _leaderInterval != 0) return units;

    // Смещение по бюджету, чтобы близкие бюджеты не залипали на одном архетипе
    local leaderIndex =
        ( stepIndex / _leaderInterval ) % availableLeaders.len();

    local arch = availableLeaders[leaderIndex];

    foreach (u in arch.Units)
    {
        addUnit(units, unitsByType, u);
    }

    return units;
}

// ==========================================================
// MAIN GENERATOR
// ==========================================================

local function buildSpawnArray( _cfg )
{
    local result = [];

    // Значения по умолчанию
    local leaderInterval = ("LeaderInterval" in _cfg) ? _cfg.LeaderInterval : 3;
    local archetypeStride = ("ArchetypeStride" in _cfg) ? _cfg.ArchetypeStride : 1;

    if (_cfg.Mode == "Archetype")
    {
        local archCount = _cfg.Archetypes.len();
        if (archCount == 0) return result;

        // Стартовое смещение: самый слабый бюджет получает архетип №1
        local startOffset = ( _cfg.MinR / _cfg.Step ) % archCount;

        for (local budget = _cfg.MinR; budget <= _cfg.MaxR; budget += _cfg.Step)
        {
            local stepIndex = ( budget - _cfg.MinR ) / _cfg.Step;

            // Архетипы с MinR/MaxR участвуют в ротации только
            // на бюджетах своего ценового диапазона
            local eligible = [];
            foreach (arch in _cfg.Archetypes)
            {
                if ("MinR" in arch && budget < arch.MinR) continue;
                if ("MaxR" in arch && budget > arch.MaxR) continue;
                eligible.push(arch);
            }
            if (eligible.len() == 0) continue;

            local archIndex =
                ( ( stepIndex / archetypeStride ) + startOffset ) % eligible.len();

            local arch   = eligible[archIndex];
            local troops = fillTroops(arch.Units, budget);

            // Fallback: если ничего не влезло и базовый юнит по карману
            if (troops.len() == 0 && arch.Units.len() > 0
                && arch.Units[0].Type.Cost <= budget)
            {
                troops.push({ Type = arch.Units[0].Type, Num = 1 });
            }

            // Если после fallback всё ещё пусто — пресет не создаём
            if (troops.len() == 0) continue;

            result.push({
                Body              = resolveBody(troops, arch.Body, arch.Units),
                MovementSpeedMult = ("MovementSpeedMult" in arch)
                                    ? arch.MovementSpeedMult : 1.0,
                VisibilityMult    = ("VisibilityMult" in arch)
                                    ? arch.VisibilityMult : 1.0,
                VisionMult        = ("VisionMult" in arch)
                                    ? arch.VisionMult : 1.0,
                Troops            = troops
            });
        }
    }
    else // "Weighted"
    {
        for (local budget = _cfg.MinR; budget <= _cfg.MaxR; budget += _cfg.Step)
        {
            local units = buildUnitPoolWithLeaderArchetype(
                _cfg, budget, _cfg.MinR, _cfg.Step, leaderInterval
            );

            local troops = fillTroops(units, budget);

            if (troops.len() == 0) continue;

            result.push({
                Body              = resolveBody(troops, _cfg.Body, units),
                MovementSpeedMult = ("MovementSpeedMult" in _cfg)
                                    ? _cfg.MovementSpeedMult : 1.0,
                VisibilityMult    = ("VisibilityMult" in _cfg)
                                    ? _cfg.VisibilityMult : 1.0,
                VisionMult        = ("VisionMult" in _cfg)
                                    ? _cfg.VisionMult : 1.0,
                Troops            = troops
            });
        }
    }

    calculateCosts(result);
    return result;
}

// ==========================================================
// КОНФИГИ
// ==========================================================
//
// Ценовые бэнды и пропорции повторяют исходные ручные спавн-листы.
// Стоимости юнитов: RatSwarm 7, RatClanrat 8, RatMonk 12, RatWarrior 20,
// RatAssassin 20, RatPackmaster 20, RatBannerMen 15, RatWarlord 25,
// RatGreyseer 30, RatOrge 45, RatOrgeArmored 55, RatEngineer 25.
//
// Варп-инженер присутствует в двух ролях:
//  - редкий маловесный юнит в пачках с ассасинами (Raiders C2, вес 10)
//    и с ограми (Defenders G, вес 10 / H и I, вес 15; MaxCount 2);
//  - полноправный боевой юнит в отдельном лейт-гейм архетипе Raiders D-eng
//    (вес 40, MaxCount 4) — этот архетип чередуется с пачками ассасинов
//    вождя (D-ass).
// Вес 10/15, а не меньше: из-за короткого хвоста ротации в пулах с капами
// меньший вес физически не успевает набрать очки за отведённый бюджет.

// ----------------------------------------------------------
// RatRoamers
//   A: чистые пачки стай + клановых крыс, со знаменосцем (MinR ~120)
//      и хозяином стаи (MinR ~185) на больших бюджетах
//   B: те же стаи + чумные монахи
//   C: клановые крысы + монахи + воины
// ----------------------------------------------------------
this.Const.World.Spawn.RatRoamers <- buildSpawnArray({
    MinR = 55,
    MaxR = 560,
    Step = 10,
    Mode = "Archetype",
    ArchetypeStride = 1,

    Archetypes = [
        {
            Body = "figure_rat_01",
            MovementSpeedMult = 1.1,
            MinR = 55,
            MaxR = 230,
            Units = [
                { Type = this.Const.World.Spawn.Troops.RatSwarm,     Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.RatClanrat,   Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.RatBannerMen, Weight = 15, MinR = 120, MaxCount = 1 },
                { Type = this.Const.World.Spawn.Troops.RatPackmaster, Weight = 15, MinR = 185, MaxCount = 1 }
            ]
        },
        {
            Body = "figure_rat_01",
            MovementSpeedMult = 1.1,
            MinR = 55,
            Units = [
                { Type = this.Const.World.Spawn.Troops.RatSwarm,     Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.RatClanrat,   Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.RatMonk,      Weight = 40 },
                { Type = this.Const.World.Spawn.Troops.RatBannerMen, Weight = 15, MinR = 115, MaxCount = 1 },
                { Type = this.Const.World.Spawn.Troops.RatPackmaster, Weight = 15, MinR = 185, MaxCount = 1, BodyOverride = "figure_tiefutu_04" }
            ]
        },
        {
            Body = "figure_rat_01",
            MovementSpeedMult = 1.1,
            MinR = 140,
            Units = [
                { Type = this.Const.World.Spawn.Troops.RatClanrat,    Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.RatMonk,       Weight = 85 },
                { Type = this.Const.World.Spawn.Troops.RatWarrior,    Weight = 85, BodyOverride = "figure_tiefutu_02", BodyPriority = 50 },
                { Type = this.Const.World.Spawn.Troops.RatBannerMen,  Weight = 15, MinR = 145, MaxCount = 1 },
                { Type = this.Const.World.Spawn.Troops.RatPackmaster, Weight = 15, MinR = 190, MaxCount = 1, BodyOverride = "figure_tiefutu_04", BodyPriority = 100 }
            ]
        }
    ]
});

// ----------------------------------------------------------
// RatScouts
//   A: разведгруппы клановых крыс
//   B: клановые крысы + воины
// ----------------------------------------------------------
this.Const.World.Spawn.RatScouts <- buildSpawnArray({
    MinR = 16,
    MaxR = 80,
    Step = 8,
    Mode = "Archetype",
    ArchetypeStride = 1,

    Archetypes = [
        {
            Body = "figure_rat_01",
            MovementSpeedMult = 1.0,
            MinR = 16,
            MaxR = 60,
            Units = [
                { Type = this.Const.World.Spawn.Troops.RatClanrat, Weight = 100 }
            ]
        },
        {
            Body = "figure_rat_01",
            MovementSpeedMult = 1.0,
            MinR = 40,
            MaxR = 80,
            Units = [
                { Type = this.Const.World.Spawn.Troops.RatClanrat, Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.RatWarrior, Weight = 40 }
            ]
        }
    ]
});

// ----------------------------------------------------------
// RatRaiders (MinR 55 — MaxR 960)
//   A:  ранние пачки стай + клановых крыс со знаменосцем (55-115)
//   B1: стаи + клановые крысы + воины (85-210)
//   B2: то же + хозяин стаи (110-335)
//   C1: пачки ассасинов (64-250)
//   C2: пачки ассасинов + хозяин стаи + редкий инженер (150-620)
//   D-eng: отряды вождя с варп-инженерами вместо ассасинов (320+)
//   D-ass: отряды вождя с ассасинами (340+)
//   D-eng и D-ass чередуются в ротации
// ----------------------------------------------------------
this.Const.World.Spawn.RatRaiders <- buildSpawnArray({
    MinR = 55,
    MaxR = 760,
    Step = 15,
    Mode = "Archetype",
    ArchetypeStride = 1,

    Archetypes = [
        {
            Body = "figure_rat_01",
            MovementSpeedMult = 1.1,
            MinR = 55,
            MaxR = 115,
            Units = [
                { Type = this.Const.World.Spawn.Troops.RatSwarm,     Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.RatClanrat,   Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.RatBannerMen, Weight = 20, MinR = 65, MaxCount = 1 }
            ]
        },
        {
            Body = "figure_rat_01",
            MovementSpeedMult = 1.1,
            MinR = 85,
            MaxR = 210,
            Units = [
                { Type = this.Const.World.Spawn.Troops.RatSwarm,     Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.RatClanrat,   Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.RatWarrior,   Weight = 60, BodyOverride = "figure_tiefutu_02" },
                { Type = this.Const.World.Spawn.Troops.RatBannerMen, Weight = 15, MinR = 100, MaxCount = 1 }
            ]
        },
        {
            Body = "figure_rat_02",
            MovementSpeedMult = 1.1,
            MinR = 110,
            MaxR = 335,
            Units = [
                { Type = this.Const.World.Spawn.Troops.RatSwarm,      Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.RatClanrat,    Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.RatWarrior,    Weight = 60  },
                { Type = this.Const.World.Spawn.Troops.RatBannerMen,  Weight = 15, MinR = 115, MaxCount = 1 },
                { Type = this.Const.World.Spawn.Troops.RatPackmaster, Weight = 15, MinR = 140, MaxCount = 1 }
            ]
        },
        {
            Body = "figure_rat_03",
            MovementSpeedMult = 1.1,
            MinR = 64,
            MaxR = 250,
            Units = [
                { Type = this.Const.World.Spawn.Troops.RatClanrat,  Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.RatAssassin, Weight = 40, MaxCount = 4 },
                { Type = this.Const.World.Spawn.Troops.RatWarrior,  Weight = 60 }
            ]
        },
        {
            Body = "figure_rat_02",
            MovementSpeedMult = 1.1,
            MinR = 150,
            MaxR = 620,
            Units = [
                { Type = this.Const.World.Spawn.Troops.RatClanrat,    Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.RatAssassin,   Weight = 40, MaxCount = 4 },
                { Type = this.Const.World.Spawn.Troops.RatWarrior,    Weight = 60 },
                { Type = this.Const.World.Spawn.Troops.RatPackmaster, Weight = 15, MinR = 180, MaxCount = 1 },
                { Type = this.Const.World.Spawn.Troops.RatEngineer,   Weight = 10, MinR = 150, MaxCount = 2, BodyOverride = "figure_tiefutu_03" }
            ]
        },
        {
            Body = "figure_rat_05",
            MovementSpeedMult = 1.1,
            MinR = 320,
            Units = [
                { Type = this.Const.World.Spawn.Troops.RatClanrat,    Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.RatWarrior,    Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.RatEngineer,   Weight = 40, MaxCount = 4 },
                { Type = this.Const.World.Spawn.Troops.RatWarlord,    Weight = 200, MaxCount = 1 },
                { Type = this.Const.World.Spawn.Troops.RatBannerMen,  Weight = 15, MaxCount = 1 },
                { Type = this.Const.World.Spawn.Troops.RatPackmaster, Weight = 15, MaxCount = 1 }
            ]
        },
        {
            Body = "figure_rat_05",
            MovementSpeedMult = 1.1,
            MinR = 340,
            Units = [
                { Type = this.Const.World.Spawn.Troops.RatClanrat,    Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.RatWarrior,    Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.RatAssassin,   Weight = 40, MaxCount = 4 },
                { Type = this.Const.World.Spawn.Troops.RatWarlord,    Weight = 200, MaxCount = 1 },
                { Type = this.Const.World.Spawn.Troops.RatBannerMen,  Weight = 15, MaxCount = 1 },
                { Type = this.Const.World.Spawn.Troops.RatPackmaster, Weight = 15, MaxCount = 1 }
            ]
        }
    ]
});

// ----------------------------------------------------------
// RatDefenders (MinR 35 — MaxR 1160)
//   E1: гарнизоны монахов + воинов (35-195)
//   E2: то же + знаменосец, хозяин стаи и ассасины (95-380)
//   F:  отряд вождя + серого провидца вместе (280-860)
//   G:  пачки крысоогров + хозяин стаи + редкий инженер (289-706)
//   H:  огры + бронированный огра + серый провидец + редкий инженер (350+)
//   I:  бронированный огра + вождь + огры + редкий инженер (380+)
// ----------------------------------------------------------
this.Const.World.Spawn.RatDefenders <- buildSpawnArray({
    MinR = 35,
    MaxR = 960,
    Step = 15,
    Mode = "Archetype",
    ArchetypeStride = 1,

    Archetypes = [
        {
            Body = "figure_rat_02",
            MovementSpeedMult = 1.1,
            MinR = 35,
            MaxR = 195,
            Units = [
                { Type = this.Const.World.Spawn.Troops.RatMonk,    Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.RatWarrior, Weight = 55 },
                { Type = this.Const.World.Spawn.Troops.RatAssassin, Weight = 20, MinR = 80, MaxCount = 2 }
            ]
        },
        {
            Body = "figure_rat_04",
            MovementSpeedMult = 1.1,
            MinR = 95,
            MaxR = 380,
            Units = [
                { Type = this.Const.World.Spawn.Troops.RatMonk,       Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.RatWarrior,    Weight = 55 },
                { Type = this.Const.World.Spawn.Troops.RatAssassin,   Weight = 20, MinR = 100, MaxCount = 2 },
                { Type = this.Const.World.Spawn.Troops.RatBannerMen,  Weight = 15, MinR = 110, MaxCount = 1 },
                { Type = this.Const.World.Spawn.Troops.RatPackmaster, Weight = 15, MinR = 130, MaxCount = 1 }
            ]
        },
        {
            Body = "figure_rat_05",
            MovementSpeedMult = 1.1,
            MinR = 280,
            MaxR = 860,
            Units = [
                { Type = this.Const.World.Spawn.Troops.RatMonk,       Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.RatWarrior,    Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.RatWarlord,    Weight = 200, MaxCount = 1 },
                { Type = this.Const.World.Spawn.Troops.RatGreyseer,   Weight = 200, MaxCount = 1 },
                { Type = this.Const.World.Spawn.Troops.RatBannerMen,  Weight = 15, MaxCount = 1 },
                { Type = this.Const.World.Spawn.Troops.RatPackmaster, Weight = 15, MaxCount = 1 }
            ]
        },
        {
            Body = "figure_rat_03",
            MovementSpeedMult = 1.1,
            MinR = 289,
            MaxR = 706,
            Units = [
                { Type = this.Const.World.Spawn.Troops.RatClanrat,    Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.RatWarrior,    Weight = 65 },
                { Type = this.Const.World.Spawn.Troops.RatOrge,       Weight = 200, MaxCount = 2 },
                { Type = this.Const.World.Spawn.Troops.RatPackmaster, Weight = 100, MaxCount = 1 },
                { Type = this.Const.World.Spawn.Troops.RatEngineer,   Weight = 10, MaxCount = 2 }
            ]
        },
        {
            Body = "figure_rat_06",
            MovementSpeedMult = 1.1,
            MinR = 350,
            Units = [
                { Type = this.Const.World.Spawn.Troops.RatMonk,        Weight = 80 },
                { Type = this.Const.World.Spawn.Troops.RatOrge,        Weight = 200, MaxCount = 2 },
                { Type = this.Const.World.Spawn.Troops.RatOrgeArmored, Weight = 150, MaxCount = 1 },
                { Type = this.Const.World.Spawn.Troops.RatWarrior,     Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.RatGreyseer,    Weight = 200, MaxCount = 1 },
                { Type = this.Const.World.Spawn.Troops.RatPackmaster,  Weight = 100, MaxCount = 1 },
                { Type = this.Const.World.Spawn.Troops.RatEngineer,    Weight = 15, MaxCount = 2 }
            ]
        },
        {
            Body = "figure_rat_05",
            MovementSpeedMult = 1.1,
            MinR = 380,
            Units = [
                { Type = this.Const.World.Spawn.Troops.RatOrgeArmored, Weight = 200, MaxCount = 1 },
                { Type = this.Const.World.Spawn.Troops.RatOrge,        Weight = 150, MaxCount = 2 },
                { Type = this.Const.World.Spawn.Troops.RatWarrior,     Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.RatWarlord,     Weight = 200, MaxCount = 1 },
                { Type = this.Const.World.Spawn.Troops.RatPackmaster,  Weight = 100, MaxCount = 1 },
                { Type = this.Const.World.Spawn.Troops.RatEngineer,    Weight = 15, MaxCount = 2 }
            ]
        }
    ]
});

// ----------------------------------------------------------
// RatLord / RatChef — одиночные легендарные вожди (статика)
// ----------------------------------------------------------
this.Const.World.Spawn.RatLord <- [
	{
		Body = "figure_rat_08",
		Troops = [
			{
				Type = ::Const.World.Spawn.Troops.RatQueek,
				Num = 1
			}
		]
	}
];

this.Const.World.Spawn.RatChef <- [
	{
		Body = "figure_rat_07",
		Troops = [
			{
				Type = ::Const.World.Spawn.Troops.RatTretch,
				Num = 1
			}
		]
	}
];

calculateCosts(::Const.World.Spawn.RatLord);
calculateCosts(::Const.World.Spawn.RatChef);
