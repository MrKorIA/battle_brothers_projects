# Чек-лист: скриптованный бой локации перед игровым тестом

Пройти по каждому пункту. Каждый — реальная ошибка из практики (Курган Хана, 2026-11).

## CombatInfo
- [ ] `TerrainTemplate` задан (без него падение в `initMap`)
- [ ] `IsWithoutAmbience = true` (событийный бой без мировой клетки)
- [ ] `PlayerDeploymentType = Custom`, если расстановка ручная
- [ ] `p.Entities = []` при спавне через callback (иначе двойной спавн)

## Карта (2 шаблона)
- [ ] Стены рисует ТОЛЬКО terrain-шаблон (патч красит лишь Type == 0)
- [ ] Location-шаблон прорезает: `Type=0, Level=0, IsSpecialTerrain=false`
- [ ] `campify` пустые у обоих; объекты ставятся в `BeforeDeploymentCallback`
- [ ] `makeBordersImpassable` у обоих

## Спавны (BeforeDeploymentCallback)
- [ ] Статика `spawnObject` (без `scripts/`), актёры `spawnEntity` (с `scripts/`) + `setFaction`
- [ ] Нейтральным объектам-актёрам — существующий `EntityType` (CaravanDonkey, не Donkey)
- [ ] Важные объекты — со fallback-сканом соседних тайлов (декали занимают тайлы)
- [ ] Список кандидатов вместо цикла попыток; дистанции между зонами проверены на карте
- [ ] Все координаты в квадратной системе, конвертация в гексовую только у `getTile`/`addEntityToMap`

## Расстановка игрока (AfterDeploymentCallback)
- [ ] `addEntityToMap(bro, x, y - x/2)` — НЕ `Navigator().teleport()` (мёртвая блокировка)
- [ ] Фильтр тайлов: `IsEmpty && !IsOccupiedByActor && !IsSpecialTerrain && Level == 0`
- [ ] `fillVisibility(Player, true)` ОТСУТСТВУЕТ (это отключение тумана войны)
- [ ] Мест хватает на максимальный отряд (Legends: 24)

## Скрипты объектов/эффектов
- [ ] Скилловый `onDamageReceived(_attacker, _damageHitpoints, _damageArmor)`, без return
- [ ] Счётчики на бой сбрасываются в `onCombatStarted`
- [ ] Спавнеры: событие перепланируется каждый цикл; нет самоуничтожения без необходимости

## Общее
- [ ] Чекер синтаксиса по всем новым/изменённым .nut
- [ ] Каждый сомнительный API проверен grep'ом по `data_014` (правило AGENTS.md)
- [ ] Нет ссылок на другие моды (кроме ванили и MSU)
- [ ] Тестовый заход: вход → расстановка → 3+ раунда → выход/победа
