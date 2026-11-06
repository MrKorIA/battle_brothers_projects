// Spawnlists кризиса «Нашествие Железной Орды»: HordeRoamers / HordeRaiders / HordeDefenders.
// Генератор — копия проверенного паттерна spawnlist_jin.nut (mod_Jurchen):
// SWRR-заполнение, архетипы с ротацией, FadeR, BodyOverride, сортировка по Cost
// (обязательна — assignTroops бинарно ищет по Cost).

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
// MAIN GENERATOR
// ==========================================================

local function buildSpawnArray( _cfg )
{
    local result = [];

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
            local units = _cfg.Units;

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
// HORDE ROAMERS — лёгкие разведчики, MovementSpeedMult 1.1 (TZ §5).
// Много лучников Mgl + лёгкая пехота Jurchen с мастерами копья/алебарды.
// Командир — сотник Mgl (Kehanweishi).
// ==========================================================
::Const.World.Spawn.HordeRoamers <- buildSpawnArray({
    MinR = 60,
    MaxR = 600,
    Step = 20,
    Mode = "Archetype",
    ArchetypeStride = 1,

    Archetypes = [
        {
            Body = "figure_tiefutu_00",
            MovementSpeedMult = 1.1,
            Units = [
                { Type = this.Const.World.Spawn.Troops.Mumin,         Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.Caoyuanzhanshi, Weight = 60  }
            ]
        },
        {
            Body = "figure_tiefutu_00",
            MovementSpeedMult = 1.1,
            Units = [
                { Type = this.Const.World.Spawn.Troops.Mumin,         Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.NomadInfantry, Weight = 80  },
                { Type = this.Const.World.Spawn.Troops.Caoyuanzhanshi, Weight = 40  }
            ]
        },
        {
            Body = "figure_changmaodashi_01",
            MovementSpeedMult = 1.1,
            Units = [
                { Type = this.Const.World.Spawn.Troops.NomadInfantry,    Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.Mumin,            Weight = 70  },
                { Type = this.Const.World.Spawn.Troops.NomadSpearMaster, Weight = 40, MinR = 200, MaxCount = 1 }
            ]
        },
        {
            Body = "figure_changjidashi_01",
            MovementSpeedMult = 1.1,
            Units = [
                { Type = this.Const.World.Spawn.Troops.NomadInfantry,      Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.Caoyuanzhanshi,     Weight = 60  },
                { Type = this.Const.World.Spawn.Troops.NomadHalberdMaster, Weight = 40, MinR = 200, MaxCount = 1 }
            ]
        },
        {
            Body = "figure_tiefutu_01",
            MovementSpeedMult = 1.1,
            Units = [
                { Type = this.Const.World.Spawn.Troops.NomadInfantry, Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.Mumin,         Weight = 80  },
                { Type = this.Const.World.Spawn.Troops.Kehanweishi,   Weight = 30, MinR = 300, MaxCount = 1, BodyOverride = "figure_tiefutu_02" }
            ]
        }
    ]
});

// ==========================================================
// HORDE RAIDERS — тяжёлые рейдеры, MovementSpeedMult 1.0 (TZ §5).
// Тяжёлые лучники Mgl + железные латники с огнестрельными войсками Jurchen.
// Командир — сотник Jurchen (NomadCenturion).
// ==========================================================
::Const.World.Spawn.HordeRaiders <- buildSpawnArray({
    MinR = 200,
    MaxR = 800,
    Step = 25,
    Mode = "Archetype",
    ArchetypeStride = 1,

    Archetypes = [
        {
            Body = "figure_tiefutu_01",
            MovementSpeedMult = 1.0,
            Units = [
                { Type = this.Const.World.Spawn.Troops.NomadIronPagoda,      Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.NomadFireBlunderbuss, Weight = 50  },
                { Type = this.Const.World.Spawn.Troops.Caoyuanzhanshi,       Weight = 30  }
            ]
        },
        {
            Body = "figure_tiefutu_01",
            MovementSpeedMult = 1.0,
            Units = [
                { Type = this.Const.World.Spawn.Troops.NomadIronPagoda,      Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.NomadFireBlunderbuss, Weight = 60  },
                { Type = this.Const.World.Spawn.Troops.Baihuzhang,           Weight = 25, MinR = 350 }
            ]
        },
        {
            Body = "figure_changjidashi_01",
            MovementSpeedMult = 1.0,
            Units = [
                { Type = this.Const.World.Spawn.Troops.NomadIronPagoda,      Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.NomadFireBlunderbuss, Weight = 50  },
                { Type = this.Const.World.Spawn.Troops.NomadHalberdMaster,   Weight = 30, MinR = 250, MaxCount = 1 },
                { Type = this.Const.World.Spawn.Troops.Caoyuanzhanshi,       Weight = 25  }
            ]
        },
        {
            Body = "figure_changmaodashi_01",
            MovementSpeedMult = 1.0,
            Units = [
                { Type = this.Const.World.Spawn.Troops.NomadIronPagoda,      Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.NomadFireBlunderbuss, Weight = 50  },
                { Type = this.Const.World.Spawn.Troops.NomadSpearMaster,     Weight = 30, MinR = 250, MaxCount = 1 },
                { Type = this.Const.World.Spawn.Troops.Baihuzhang,           Weight = 25, MinR = 350 },
                { Type = this.Const.World.Spawn.Troops.NomadCenturion,       Weight = 25, MinR = 300, MaxCount = 1, BodyOverride = "figure_tiefutu_02" }
            ]
        }
    ]
});

// ==========================================================
// HORDE DEFENDERS — элитная охрана лагерей (TZ §5).
// Единственное место, где встречается босс «Генерал» (MaxCount = 1).
// ==========================================================
::Const.World.Spawn.HordeDefenders <- buildSpawnArray({
    MinR = 280,
    MaxR = 1200,
    Step = 40,
    Mode = "Archetype",
    ArchetypeStride = 1,

    Archetypes = [
        {
            Body = "figure_tiefutu_01",
            MovementSpeedMult = 1.0,
            Units = [
                { Type = this.Const.World.Spawn.Troops.NomadIronPagoda,      Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.NomadFireBlunderbuss, Weight = 70  },
                { Type = this.Const.World.Spawn.Troops.Kehanweishi,          Weight = 30  },
                { Type = this.Const.World.Spawn.Troops.Baihuzhang,           Weight = 30  },
                { Type = this.Const.World.Spawn.Troops.HordeGeneral,         Weight = 40, MinR = 400, MaxCount = 1, BodyOverride = "figure_tiefutu_02", BodyPriority = 100 },
                { Type = this.Const.World.Spawn.Troops.NomadHalberdMaster,   Weight = 25, MinR = 300, MaxCount = 1, BodyOverride = "figure_changjidashi_01", BodyPriority = 75 }
            ]
        },
        {
            Body = "figure_tiefutu_01",
            MovementSpeedMult = 1.0,
            Units = [
                { Type = this.Const.World.Spawn.Troops.NomadIronPagoda,      Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.NomadFireBlunderbuss, Weight = 70  },
                { Type = this.Const.World.Spawn.Troops.Baihuzhang,           Weight = 30  },
                { Type = this.Const.World.Spawn.Troops.NomadCenturion,       Weight = 25, MaxCount = 1, BodyOverride = "figure_tiefutu_02", BodyPriority = 50 },
                { Type = this.Const.World.Spawn.Troops.HordeGeneral,         Weight = 40, MinR = 400, MaxCount = 1, BodyOverride = "figure_tiefutu_02", BodyPriority = 100 },
                { Type = this.Const.World.Spawn.Troops.NomadSpearMaster,     Weight = 30, MinR = 300, MaxCount = 1, BodyOverride = "figure_changmaodashi_01", BodyPriority = 75 }
            ]
        },
        {
            Body = "figure_tiefutu_01",
            MovementSpeedMult = 1.0,
            Units = [
                { Type = this.Const.World.Spawn.Troops.NomadIronPagoda,      Weight = 100 },
                { Type = this.Const.World.Spawn.Troops.NomadFireBlunderbuss, Weight = 80  },
                { Type = this.Const.World.Spawn.Troops.Kehanweishi,          Weight = 30  },
                { Type = this.Const.World.Spawn.Troops.Baihuzhang,           Weight = 30  },
                { Type = this.Const.World.Spawn.Troops.HordeGeneral,         Weight = 40, MinR = 400, MaxCount = 1, BodyOverride = "figure_tiefutu_02", BodyPriority = 100 }
            ]
        }
    ]
});
