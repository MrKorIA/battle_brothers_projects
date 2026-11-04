// Генератор спавн-листов
//
// Режимы:
//   Mode = "Weighted"  — единый пул юнитов с весами.
//   Mode = "Archetype" — несколько архетипов отрядов, чередующихся по бюджету.
//
// Алгоритм наполнения — Smooth Weighted Round-Robin (SWRR):
//   * totalWeight фиксируется ДЛЯ КАЖДОГО БЮДЖЕТА отдельно и учитывает
//     только доступные (MinR/MaxR) юниты, но НЕ учитывает MaxCount.
//   * На каждом шаге к доступным юнитам прибавляется их Weight.
//   * Побеждает юнит с максимальным accum.
//   * У победителя accum -= totalWeight.
//
// Ключ юнита в counts/accum — сам объект Type (а не Type.ID),
// чтобы избежать случайного схлопывания разных типов с одинаковым ID.
//

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
// Если FadeStartR не задан — старт затухания = MinR (или 0).
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

// Стабильный суммарный вес для SWRR.
// Считается ОДИН РАЗ на бюджет. Учитывает MinR/MaxR, игнорирует MaxCount.
local function computeBudgetTotalWeight( _units, _budget )
{
    local sum = 0;
    foreach (u in _units)
    {
        if ("MinR" in u && _budget < u.MinR) continue;
        if ("MaxR" in u && _budget > u.MaxR) continue;
        sum += u.Weight;
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

    local totalWeight = computeBudgetTotalWeight(_units, _budget);
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

        // Шаг 3. Сброс счётчика победителя на стабильный totalWeight
        accum[bestUnit.Type] -= totalWeight;

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

    // ВАЖНО: MinR НЕ сливаем.
    // Лидерский архетип уже ограничен своим arch.MinR,
    // а повышение MinR базового юнита может неожиданно
    // убрать его из пула на низких бюджетах.
    //
    // Если юнита нет в базовом пуле — берём MinR из лидерского.
    if ("MinR" in _u && !("MinR" in existing))
    {
        existing.MinR <- _u.MinR;
    }

    // MaxR — берём минимум (ужесточение).
    // Безопасно: базовый юнит не станет внезапно доступен шире.
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
// _minR, _step передаются явно, чтобы функция не зависела от _cfg неявно.
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

            // ArchetypeStride позволяет "растянуть" ротацию:
            // при Stride=1 архетип меняется каждый шаг,
            // при Stride=2 — каждые два шага, и т.д.
            local archIndex =
                ( ( stepIndex / archetypeStride ) + startOffset ) % archCount;

            local arch   = _cfg.Archetypes[archIndex];
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

// ----------------------------------------------------------
// WushiRoamers
// ----------------------------------------------------------
this.Const.World.Spawn.WushiRoamers <- buildSpawnArray({
    MinR = 45,
    MaxR = 600,
    Step = 15,
    Mode = "Archetype",
    ArchetypeStride = 2,

    Archetypes = [
        {
            Body = "figure_wushi_01",
            MovementSpeedMult = 1.0,
            Units = [
                { Type = this.Const.World.Spawn.Troops.Zuqing, Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.Wushi,  Weight = 30, MinR = 90, BodyOverride = "figure_wushi_02" }
            ]
        },
        {
            Body = "figure_renzhe_01",
            MovementSpeedMult = 1.1,
            Units = [
                { Type = this.Const.World.Spawn.Troops.Renzhe02, Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.Renzhe,   Weight = 20, MinR = 120 }
            ]
        },
        {
            Body = "figure_sengbing_01",
            MovementSpeedMult = 1.0,
            Units = [
                { Type = this.Const.World.Spawn.Troops.Sengbing, Weight = 100 }
            ]
        },
        {
            Body = "figure_wushi_02",
            MovementSpeedMult = 1.0,
            Units = [
                { Type = this.Const.World.Spawn.Troops.Wushi,        Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.Wushidajiang, Weight = 30, MinR = 220, BodyOverride = "figure_wushi_03" }
            ]
        },
        {
            Body = "figure_wushi_01",
            MovementSpeedMult = 1.0,
            Units = [
                { Type = this.Const.World.Spawn.Troops.Langren, Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.Jianhao, Weight = 25, MinR = 180 }
            ]
        }
    ]
});

// ----------------------------------------------------------
// WushiRaiders
// ----------------------------------------------------------
this.Const.World.Spawn.WushiRaiders <- buildSpawnArray({
    MinR = 80,
    MaxR = 750,
    Step = 20,
    Mode = "Weighted",
    Body = "figure_wushi_01",
    MovementSpeedMult = 1.0,
    LeaderInterval = 3,

    LeaderArchetypes = [
        {
            MinR = 300,
            Units = [
                { Type = this.Const.World.Spawn.Troops.Wushidajiang, Weight = 200, MaxCount = 2 },
                { Type = this.Const.World.Spawn.Troops.Wushi,        Weight = 100 }
            ]
        },
        {
            MinR = 340,
            Units = [
                { Type = this.Const.World.Spawn.Troops.Jianhao,  Weight = 200, MaxCount = 1 },
                { Type = this.Const.World.Spawn.Troops.Wushi,    Weight = 80 }
            ]
        },
        {
            MinR = 500,
            Units = [
                { Type = this.Const.World.Spawn.Troops.Jiangjun,     Weight = 200, MaxCount = 1 },
                { Type = this.Const.World.Spawn.Troops.Wushidajiang, Weight = 100 }
            ]
        }
    ],

    Units = [
        { Type = this.Const.World.Spawn.Troops.Jiangjun,     Weight = 50,  MinR = 500, MaxCount = 1, BodyOverride = "figure_wushi_04", BodyPriority = 100 },
        { Type = this.Const.World.Spawn.Troops.Wushidajiang, Weight = 20,  MinR = 300, BodyOverride = "figure_wushi_03", BodyPriority = 50 },
        { Type = this.Const.World.Spawn.Troops.Jianhao,      Weight = 10,  MinR = 250, MaxCount = 1, BodyOverride = "figure_wushi_01", BodyPriority = 30  },
        { Type = this.Const.World.Spawn.Troops.Langren,      Weight = 15,  MinR = 200, MaxCount = 2, BodyOverride = "figure_wushi_01", BodyPriority = 20  },
        { Type = this.Const.World.Spawn.Troops.Wushi,        Weight = 50,  MinR = 60, BodyOverride = "figure_wushi_02", BodyPriority = 10 },
        { Type = this.Const.World.Spawn.Troops.Renzhe02,     Weight = 30,  MinR = 120, BodyOverride = "figure_renzhe_01", BodyPriority = 15 },
        { Type = this.Const.World.Spawn.Troops.Zuqing,       Weight = 100, FadeStartR = 250, FadeR = 700 }
    ]
});

// ----------------------------------------------------------
// WushiDefenders
// ----------------------------------------------------------
this.Const.World.Spawn.WushiDefenders <- buildSpawnArray({
    MinR = 75,
    MaxR = 950,
    Step = 25,
    Mode = "Weighted",
    Body = "figure_wushi_02",
    MovementSpeedMult = 1.0,

    LeaderInterval = 3,

    LeaderArchetypes = [
        {
            MinR = 350,
            Units = [
                { Type = this.Const.World.Spawn.Troops.Wushidajiang, Weight = 150, MaxCount = 2 },
                { Type = this.Const.World.Spawn.Troops.Sengbing,     Weight = 80 }
            ]
        },
        {
            MinR = 400,
            Units = [
                { Type = this.Const.World.Spawn.Troops.Sengbing, Weight = 150 },
                { Type = this.Const.World.Spawn.Troops.Renzhe,   Weight = 100 }
            ]
        },
        {
            MinR = 500,
            Units = [
                { Type = this.Const.World.Spawn.Troops.Jiangjun,     Weight = 200, MaxCount = 1 },
                { Type = this.Const.World.Spawn.Troops.Wushidajiang, Weight = 150 }
            ]
        }
    ],

    Units = [
        { Type = this.Const.World.Spawn.Troops.Jiangjun,     Weight = 50,  MinR = 500, MaxCount = 1, BodyOverride = "figure_wushi_04", BodyPriority = 100 },
        { Type = this.Const.World.Spawn.Troops.Wushidajiang, Weight = 25,  MinR = 350, BodyOverride = "figure_wushi_03", BodyPriority = 50 },
        { Type = this.Const.World.Spawn.Troops.Jianhao,      Weight = 12,  MinR = 300, MaxCount = 1 },
        { Type = this.Const.World.Spawn.Troops.Langren,      Weight = 15,  MinR = 225, MaxCount = 2 },
        { Type = this.Const.World.Spawn.Troops.Sengbing,     Weight = 20,  MinR = 200 },
        { Type = this.Const.World.Spawn.Troops.Renzhe,       Weight = 15,  MinR = 200 },
        { Type = this.Const.World.Spawn.Troops.Wushi,        Weight = 45,  MinR = 125 },
        { Type = this.Const.World.Spawn.Troops.Renzhe02,     Weight = 40,  MinR = 0   },
        { Type = this.Const.World.Spawn.Troops.Zuqing,       Weight = 100, MinR = 0, FadeStartR = 300, FadeR = 800 }
    ]
});