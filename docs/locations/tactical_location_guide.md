# Гайд: легендарные локации и скриптованные бои — Battle Brothers

Свод проверенных на практике (на примере «Кургана Хана», мод Scourge of God) правил создания
легендарной локации: событие входа → скриптованный бой → своя тактическая карта → спавны → награды.
Каждый пункт здесь — результат отладки; ловушки помечены ⚠️.

Эталоны, на которые стоит смотреть живьём:
- Событие: `Scourge of God/scripts/events/events/mods/mod_legendary_khan_location_enter_event.nut` (рабочее, финальное)
- Событие-эталон: `mod_zzz_RedCourt/.../legend_mummy_enter_event.nut`
- Расстановка игрока: `data_014/scripts/contracts/contracts/tutorial_contract.nut` (DeploymentType.Custom + addEntityToMap)

---

## 1. Архитектура боя локации

Цепочка: событие строит `CombatInfo` → `World.State.startScriptedCombat(p, false, false, false)` →
`tactical_state.initMap` генерирует карту → `BeforeDeploymentCallback` (враги/объекты) →
ваниль развёртывание → `AfterDeploymentCallback` (ручная расстановка игрока, погода) → бой.

## 2. CombatInfo — обязательные и опасные поля

```squirrel
local p = ::Const.Tactical.CombatInfo.getClone();
p.LocationTemplate = clone ::Const.Tactical.LocationTemplate;
p.CombatID = "UniqueName";
p.TerrainTemplate = "tactical.my_ground";        // ОБЯЗАТЕЛЬНО
p.LocationTemplate.Template[0] = "tactical.my_location";
p.IsWithoutAmbience = true;                      // ОБЯЗАТЕЛЬНО для событийных боёв (см. ⚠️2)
p.PlayerDeploymentType = ::Const.Tactical.DeploymentType.Custom; // при ручной расстановке
p.Entities = [];                                  // при спавне вручную через callback
```

- ⚠️ **1. Без `TerrainTemplate` — падение в `initMap`** (`MapGen.get(null)`). Это базовый генератор
  земли под шаблоном локации (`tactical.steppe`, `tactical.plains`, либо свой — см. §3).
- ⚠️ **2. Событийный бой приходит без мировой клетки** (`StrategicProperties.Tile == null`; её ставит
  только `getLocalCombatProperties` при обычном бое на карте). Ваниль зовёт
  `setupAmbience(Tile)` под условием `!IsWithoutAmbience` → без флага краш/ошибка. Паттерн эталона
  (mummy): `IsWithoutAmbience = true`, погоду настраивать вручную в `AfterDeploymentCallback`.
- `Music`, `CombatID`, `EnemyDeploymentType` — по вкусу.

## 3. Пара шаблонов карты: Terrain + Location

`initMap` вызывает в порядке: **1)** `terrain.fill(rect)` → **2)** `location.fill(rect)` →
**3)** `terrain.campify(rect, LocationTemplate)` (да, campify зовётся у карты МЕСТНОСТИ).

Выводы:
- **Стены рисует только terrain-шаблон.** ⚠️ Патч `CP_cave_thick` красит исключительно тайлы с
  `Type == 0` (`if (tile.Type != 0) continue;`). К моменту `fill` локации мировая земля уже раздала
  всем тайлам Type — патч в location-шаблоне молча ничего не нарисует. Порядок «земля-стены первой»
  — единственный рабочий.
- Location-шаблон лишь **прорезает** залы в толще: `tile.Type = 0; tile.Level = 0;
  tile.IsSpecialTerrain = false;` + своя заливка пола (stone1/stone2). `Level = 0` обязателен —
  стены патча поднимают уровень до 8.
- ⚠️ **`campify` местности зачищает объекты в центре** (радиус лагеря). Статичные объекты
  (саркофаги и пр.) ставить **в `BeforeDeploymentCallback`**, а не в `fill` шаблона. Campify обоих
  шаблонов оставить пустыми.
- `makeBordersImpassable(_rect)` — в обоих шаблонах.
- Минимальный terrain-шаблон-«толща»: залить весь rect патчем стен; минимальный location-шаблон:
  прорезать геометрию. Размер карты 32×32 (`m.MinX/m.MinY = 32`), начало координат (0,0) — левый нижний.

## 4. Callback'и: спавн и расстановка

### BeforeDeploymentCallback (враги, объекты, декорации)
```squirrel
p.BeforeDeploymentCallback = function () {
    // статичные объекты
    tile.spawnObject("entity/tactical/objects/graveyard_sarcophagus");
    // актёры (в т.ч. объекты-спавнеры на базе actor)
    local e = this.Tactical.spawnEntity("scripts/entity/tactical/humans/xxx", tile.Coords);
    e.setFaction(f);
};
```
- Статика — `spawnObject` (путь без `scripts/`); актёры — `spawnEntity` (путь с `scripts/`), фракция отдельно.
- ⚠️ Контекст внутри `BeforeDeploymentCallback` — `this == CombatInfo`: `this.Tactical`/`this.Math` работают
  (подтверждено ванилью, drive_away_barbarians_contract.nut), а `this.new` — НЕТ. Инстансы (`this.new(...)`)
  создавать ДО присвоения колбэка и захватывать в локалы (паттерн контракта «Порох орды»,
  mod_horde_invasion).
- ⚠️ Геометрия `DeploymentType.Line` (карта 32×32, квадратные координаты): игрок — x 10..12,
  первая вражеская фракция — x 19..24 (обе стороны развёрнуты на восток), ряды по y ~10..21.
  «За спинами врага» = x 26..30. У восточного края удобно ставить объекты цели (склады) и
  зону подкреплений (проверено, фаза 4 mod_horde_invasion).
- ⚠️ Нейтральному объекту-актёру (спавнер, декорация-жертва) нужен существующий `m.Type`:
  `this.Const.EntityType.CaravanDonkey` (просто `Donkey` НЕ существует — краш).
- Декали: `tile.spawnDetail("orcs_07")` (ванильные кисти). ⚠️ Декаль может занять тайл — спавн важных
  объектов делать с fallback-сканом соседних клеток, иначе объект молча пропустится.

### AfterDeploymentCallback (отряд игрока + погода)
⚠️ **Главная ловушка проекта.** Не использовать `Navigator().teleport()` — он асинхронен и в фазе
развёртывания (ходовая система не крутится) даёт **мёртвую блокировку без ошибок в логе**,
воспроизводится через раз. Правильно — паттерн tutorial_contract:

```squirrel
p.AfterDeploymentCallback = function () {
    local bros = this.World.getPlayerRoster().getAll();
    // собрать список подходящих тайлов: IsEmpty && !IsOccupiedByActor
    //                          && !IsSpecialTerrain && Level == 0 (ровный пол!)
    foreach (bro in bros) {
        local spot = /* тайл из списка */;
        this.Tactical.addEntityToMap(bro, spot.SquareCoords.X,
                                     spot.SquareCoords.Y - spot.SquareCoords.X / 2);
    }
    // погода: buildCloudCover + setAmbientLightingPreset/Saturation — безопасно
};
```
- ⚠️ `addEntityToMap` принимает **гексовые** координаты: `y - x/2` (как `getTile`).
- ⚠️ `fillVisibility(Player, true)` сюда НЕ добавлять — в ванили это **отключение тумана войны**
  (`tactical_state` dev-переключатель и конец боя). Видимость пересчитается по актёрам сама.
- Проверки тайла: `IsEmpty`, `IsOccupiedByActor`, `IsSpecialTerrain`, `Level`. ⚠️ У тайла **нет**
  `hasObject()` — вместо него `IsEmpty` / `removeObject()`.
- Расстановка списком кандидатов (сбор → выбор), а не «N попыток вслепую» — гарантированно ставит
  всех, кто влезает, и никогда не зацикливается.

## 5. Координаты: три системы, не путать

| Что | Где | Формат |
|---|---|---|
| Квадратные тайлы | `getTileSquare(x, y)`, `SquareCoords.X/Y` | прямоугольная сетка 32×32 |
| Гексовые | `getTile(x, y)`, `addEntityToMap(x, y)`, координаты в логах спавна | `y_hex = y_square - x/2` |
| Экранные пиксели | `tile.Pos`, `actor.getPos()` | НЕ для адресации тайлов |

Ошибка «координата из другой системы» = спавн не там или краш без явной причины.

## 6. Скилловые хуки (эффекты наград, спавнеры)

- ⚠️ Скилловый `onDamageReceived` — сигнатура `(_attacker, _damageHitpoints, _damageArmor)`,
  **ничего не возвращает** (контейнер игнорирует возврат; образцы: `alp_racial`, `hex_master_effect`).
  Сигнатура `(_attacker, _skill, _hitInfo)` + `return _hitInfo` — это хук **актёра**, в скилле он мёртв.
- Счётчики «раз за бой» сбрасывать в `onCombatStarted()` (эффект живёт между боями).
- Объект-спавнер по образцу `spider_eggs`: `onPlacedOnMap` → `registerSpawnEvent` →
  `Time.scheduleEvent(Rounds, 1-2, onSpawn)`; в `onSpawn` заново планировать событие (бесконечные
  волны), условия: `!isEnemyRetreating()`, свободная соседняя клетка (`hasNextTile`, `IsEmpty`,
  `abs(Level diff) <= 1`).

## 7. Зависимости между модами

- Каждый мод должен быть самодостаточен: ваниль (`data_014`) + MSU (практически всегда уже есть).
- Ассеты/патчи из других модов — только через локальные копии с указанием источника в комментарии.
- Проверка чистоты: `grep -rn "ИмяДругогоМода" scripts/`.

## 8. Отладка

- Лог спавна (`TacticalScene Spawned Entity ... at (x, y)`) — гексовые координаты; сводить с квадратными.
- «Зависание без ошибок» — почти всегда асинхронный API (Navigator/scheduleEvent с null-коллбеками)
  или неограниченный цикл; пересматривать каждый вызов на синхронность.
- Перед сдачей: чекер синтаксиса (.nut) + grep каждого сомнительного API по `data_014` (правило из AGENTS.md).
