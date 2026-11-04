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
// MGL ROAMERS — Archetype
// ==========================================================
this.Const.World.Spawn.MglRoamers <- buildSpawnArray({
    MinR = 50,
    MaxR = 600,
    Step = 25,
    Mode = "Archetype",
    ArchetypeStride = 2,

    Archetypes = [
        {
            Body = "figure_mgl_01",
            MovementSpeedMult = 1.0,
            Units = [
                { Type = this.Const.World.Spawn.Troops.Mumin, Weight = 100 }
            ]
        },
        {
            Body = "figure_mgl_01",
            MovementSpeedMult = 1.0,
            Units = [
                { Type = this.Const.World.Spawn.Troops.Caoyuanzhanshi, Weight = 100 }
            ]
        },
        {
            Body = "figure_mgl_01",
            MovementSpeedMult = 1.0,
            Units = [
                { Type = this.Const.World.Spawn.Troops.Kehanweishi, Weight = 100 }
            ]
        },
        {
            Body = "figure_mgl_01",
            MovementSpeedMult = 1.0,
            Units = [
                { Type = this.Const.World.Spawn.Troops.Baihuzhang,       Weight = 20,  MaxCount = 1 },
                { Type = this.Const.World.Spawn.Troops.Caoyuanzhanshi,   Weight = 100 }
            ]
        }
    ]
});

// ==========================================================
// MGL RAIDERS — Archetype
// ==========================================================
this.Const.World.Spawn.MglRaiders <- buildSpawnArray({
    MinR = 75,
    MaxR = 750,
    Step = 25,
    Mode = "Archetype",
    ArchetypeStride = 1,

    Archetypes = [
        {
            Body = "figure_mgl_01",
            MovementSpeedMult = 1.0,
            Units = [
                { Type = this.Const.World.Spawn.Troops.Mumin,       Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.Kehanweishi, Weight = 20,  MinR = 300, MaxCount = 1 }
            ]
        },
        {
            Body = "figure_mgl_01",
            MovementSpeedMult = 1.0,
            Units = [
                { Type = this.Const.World.Spawn.Troops.Caoyuanzhanshi,  Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.Kehanweishi,     Weight = 20,  MinR = 300, MaxCount = 1 }
            ]
        },
        {
            Body = "figure_mgl_01",
            MovementSpeedMult = 1.0,
            Units = [
                { Type = this.Const.World.Spawn.Troops.Kehanweishi, Weight = 100 }
            ]
        },
        {
            Body = "figure_mgl_01",
            MovementSpeedMult = 1.0,
            Units = [
                { Type = this.Const.World.Spawn.Troops.Baihuzhang,       Weight = 20,  MaxCount = 1 },
                { Type = this.Const.World.Spawn.Troops.Kehanweishi,      Weight = 40,  MaxCount = 2 },
                { Type = this.Const.World.Spawn.Troops.Caoyuanzhanshi,   Weight = 100 }
            ]
        }
    ]
});

// ==========================================================
// MGL DEFENDERS — Archetype
// ==========================================================
this.Const.World.Spawn.MglDefenders <- buildSpawnArray({
    MinR = 100,
    MaxR = 960,
    Step = 30,
    Mode = "Archetype",
    ArchetypeStride = 1,

    Archetypes = [
        {
            Body = "figure_mgl_01",
            MovementSpeedMult = 1.0,
            Units = [
                { Type = this.Const.World.Spawn.Troops.Mumin, Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.Kehanweishi, Weight = 20,  MinR = 300, MaxCount = 1 }
            ]
        },
        {
            Body = "figure_mgl_01",
            MovementSpeedMult = 1.0,
            Units = [
                { Type = this.Const.World.Spawn.Troops.Caoyuanzhanshi, Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.Kehanweishi, Weight = 20,  MinR = 300, MaxCount = 1 }
            ]
        },
        {
            Body = "figure_mgl_01",
            MovementSpeedMult = 1.0,
            Units = [
                { Type = this.Const.World.Spawn.Troops.Kehanweishi, Weight = 100 }
            ]
        },
        {
            Body = "figure_mgl_01",
            MovementSpeedMult = 1.0,
            Units = [
                { Type = this.Const.World.Spawn.Troops.Baihuzhang,       Weight = 20,  MaxCount = 1 },
                { Type = this.Const.World.Spawn.Troops.Caoyuanzhanshi,   Weight = 100 }
            ]
        },
        {
            Body = "figure_mgl_01",
            MovementSpeedMult = 1.0,
            Units = [
                { Type = this.Const.World.Spawn.Troops.Baihuzhang,       Weight = 15,  MinR = 300, MaxCount = 1 },
                { Type = this.Const.World.Spawn.Troops.Caoyuanzhanshi,   Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.Kehanweishi,      Weight = 60,  MinR = 600 }
            ]
        }
    ]
});