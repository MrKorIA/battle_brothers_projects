# Жёсткое правило API и проверенные ловушки

Правило коротко (в корневом `AGENTS.md`): **запрещено выдумывать функции, константы и сигнатуры**.
Каждое использование незнакомого метода/константы сначала проверяется по источникам (grep по
определениям), не подтвердилось — не использовать, спросить или перестроить решение.

## Референс-ваниль `!project/data_014`

Путь: `Z:\GameMods\Battle Brothers\mods\!project\data_014` — полная декомпилированная распаковка
скриптов игры (merged dump `scripts/` из архивов `data_001.dat`–`data_022.dat`, ~3100 файлов `.nut`),
а не только файлы локализации. **Актуальна с 2026-11-07.** Сигнатуры свежие — например, там
`setEscortedEntity( _e, _fastEscort = false )` с двумя параметрами. Незнакомые методы/константы
сверять напрямую grep'ом по определениям в этом каталоге.

**ЛОВУШКА ВРЕМЕНИ:** при следующем обновлении игры референс снова расходится с установленной
ванилью — сигнатуру из него при конфликте перепроверять по установленной игре: извлечь
`scripts/.../X.cnut` из `data_001.dat` → `bbsq.exe -d` (XXTEA-расшифровка, bin лежит в
`Z:\GameMods\Battle Brothers\mods\bbros\bin`) → `nutcracker.exe` (там же) даёт исходник.

Ловушки тактических локаций и скриптованных боёв — в `docs/locations/tactical_location_guide.md`.

## Константы и сигнатуры

- `Const.EntityType.Donkey` не существует (есть `CaravanDonkey`).
- У тайла нет `hasObject()`.
- Скилловый `onDamageReceived(_attacker, _damageHitpoints, _damageArmor)` ничего не возвращает.
- У `CombatInfo` обязателен `TerrainTemplate`.
- `fillVisibility(Player, true)` — отключение тумана войны.
- `Navigator().teleport()` в фазе развёртывания — мёртвая блокировка (игрока расставлять
  `addEntityToMap`, паттерн tutorial_contract).

## Squirrel-синтаксис

- **Squirrel BB не поддерживает битовые составные присваивания** (`|=`, `&=`, `^=`, `<<=`, `>>=`) —
  ваниль пишет `a = a | b`, иначе парсер падает с «expression expected».

## Const.AI.Behavior.ID: только динамическая выдача ID

- **Запрещён хардкод индексов поведений и `COUNT` в `Const.AI.Behavior.ID`** (например
  `MSU.Table.merge(::Const.AI.Behavior.ID, { X = 91, COUNT = 92 })`). Поведения выдаются
  только через `::MSU.AI.addBehavior(name, scriptless_name, order, score)` (или собственный
  аналог «берём COUNT, пишем ключ, делаем COUNT++»). Порядок загрузки модов не гарантирован:
  мерж с хардкодом затирает `COUNT` модов, загрузившихся раньше, — их поведения остаются
  в таблице с ID >= урезанного COUNT, и каждый `BehaviorMult[id]` падает
  «the index 'N' does not exist» (ваниль `agent.create()` делает
  `BehaviorMult.resize(Const.AI.Behavior.ID.COUNT)`; повторяется при каждом evaluate ИИ).
  Реальный кейс: скавенский `RatAttackWarpfire = 91, COUNT = 92` (коммит 9adcd30) резал COUNT
  давкула (99 → 92; дальше +3 от других модов → 95) и валил боёв культистов — `ModDavkulSacrificeStick`
  оставался в таблице со значением 95.
- Число в сообщении об ошибке — это ID поведения; «the index 'X' does not exist» в Squirrel
  одинаково выглядит для выхода за границы массива и отсутствующего ключа таблицы.
- Проверка «какие ID реально выданы»: `foreach (k, v in ::Const.AI.Behavior.ID)` —
  целочисленные значения; COUNT должен быть на 1 больше максимального.

## Хуки и перехват чужих модов

- Мод `mod_useful_pack` (`mod_crisis_duration_setting`) полностью переписывает `updateGreaterEvil`
  на уровне инстанса — классовые хуки на него молча в тени; лечится мягкой сортировкой
  `queue(">mod_crisis_duration_setting", ...)` + обёрткой через `mods_hookNewObject` (хуки
  применяются к инстансу в порядке регистрации, см. `mod_hooks/!!redirect.nut`), реакции на смену
  состояния — хуком `update` + флаги `World.Statistics.getFlags()`.
- Обёртки modern hooks обязаны повторять сигнатуру оригинала включая параметры по умолчанию
  (`function update(_ignoreDelay = false)`, а не `update()`), иначе падение «fewer total
  parameters» при загрузке.
- Тот же класс падений — `q.X = @(__original) {...}` по функции, которой НЕТ в классе/предках
  («failed to set function ...: there is no function to set»): modern hooks требует существующий
  оригинал, НОВЫЕ члены объявляются только через `q.X <- {...}` (урок: перенос contract-хука
  Reforged, где `getSecondsRequiredToTravel` — новый метод ванильного класса, в ванили её нет —
  инлайн внутри `getDaysRequiredToTravel`).

## Спавн, экипировка, контрактные бои

- `assignRandomEquipment` движком НЕ вызывается — только явно (`tactical_entity_manager.spawnNewEntity`
  для отрядов с карты мира, контракты/ивенты руками), голый `Tactical.spawnEntity` в
  событиях/объектах экипировку не раздаёт (лечение: вызов из конца `onInit` юнита — повторный вызов
  безвреден, методы обычно защищены `hasEmptySlot`; слепой вызов на юните без такого метода падает
  с «index does not exist»).
- Из состояний/экранов контракта (их таблицы, `this` = Table) `this.new` недоступен, а
  `this.Contract.new(...)` падает с «the index 'new' does not exist» (подтверждено логом игры;
  `new` резолвится только на `this` методов инстанса) — создавать объекты из стейта/скрина через
  метод инстанса контракта: `this.Contract.myMethod()`, внутри которого обычный `this.new(...)`.
- Скриптованный бой с пустым `CombatInfo.Entities` молча не стартует — `showCombatDialog` считает
  `hasOpponents` по этому списку и при нуле просто выходит (`world_state.nut`), ошибки в логе нет,
  врагов спавнить в `BeforeDeploymentCallback` при этом поздно — начальный гарнизон обязан быть в
  `Entities`, а вот записи `Entities` движок сам экипирует (`setupEntity`: `assignRandomEquipment`,
  фракция из поля `Faction`, поле `Callback` на записи — точка для кастома, паттерн
  `raze_attached_location_contract.nut`; следить за `Variant` — у части troop-таблиц он >0, и тогда
  КАЖДЫЙ боец станет минибоссом).
- Итоговые экраны контракта после боя показывать из `update()` по флагам, которые ставят
  `onCombatVictory`/`onRetreatedFromCombat` (паттерн free_greenskin) — прямой `setScreen`+
  `showActiveContract` из них всплывает ещё в тактике и ломается на карте.
- Конец боя считается по `isNoCombatantsLeft` — только не-`IsNonCombatant` враги держат бой,
  поэтому объекты-цели (бочки и т.п.), которые должны удерживать поле, спавнить с
  `m.IsNonCombatant = false` на инстансе (не трогая класс-зависимость).

## Эффекты на предметах (onEquip/onUnequip)

- Эффект на броне/предмете (тултип + механика, живущие пока предмет надет) вешается override
  `onEquip()` предмета + `this.addSkill(this.new("scripts/skills/effects/..."))` — паттерн
  ванильного оружия (`fighting_spear.nut`), переживает сейв/лоад (SkillPtrs не сериализуются, при
  десериализации предметы переэкипируются).
- ОБЯЗАТЕЛЬНА симметричная явная снятка: override `onUnequip()` с удалением эффекта по ID +
  `skill.getItem() == this` через `removeSelf()` — полагаться на `clearSkills()`/`SkillPtrs`
  НЕЛЬЗЯ: `removeFromContainer()` (передача лута вне unequip) обнуляет контейнер без `onUnequip`,
  и эффект остаётся на актёре навсегда — для эффектов с апгрейдом в `onCombatFinished` это эксплойт
  (апгрейд срабатывает без брони/чужой брони); эффект дополнительно проверяет
  `getItem().getContainer() == getContainer().getActor().getItems()` перед манипуляцией предметом.
- В `onCombatFinished` скилла скилл-контейнер находится в IsUpdating — `Skills.remove()` в это
  время молчаливый no-op, `add()` уходит в отложенный SkillsToAdd, снять скилл можно только
  `removeSelf()`; замена экипированного предмета (unequip + equip нового) внутри onCombatFinished
  безопасна — контейнер сам применит мутации после итерации (образец:
  `mod_Skaven_faction/scripts/skills/effects/warp_shard_upgrade_effect.nut`).
- `armor.nut`/`helmet.nut` переопределяют `isDroppedAsLoot()` с порогами прочности (у врага —
  >30 и ≥25%) — гарантированное выпадение разрушенной вещи даёт флаг `ItemType.Named` (у
  Named-вещей врага условия прочности нет).

## Порт враждебной сущности в компаньона AC (паттерн `companions_xxmob_*`)

- В `onFactionChanged` НЕ копировать ванильный код врага — он либо не флипает спрайт body вовсе,
  либо флипает с `!isAlliedWithPlayer()` (арт собак/людей нарисован лицом вправо), а браши
  вражеских зверей из контент-модов нарисованы лицом влево — союзнику нужен
  `flip = isAlliedWithPlayer()` на все основные спрайты (body/head/injury/body_blood), иначе
  призванный питомец смотрит как враг.
- Класс обязан реализовывать все методы, которые зовут поведения выбранного companions-агента —
  `ai_gruesome_feast` требует `getSize()` (иначе «the index 'getSize' does not exist» в потоковом
  генераторе поведения → «resuming dead generator» → ход юнита не завершается, бой виснет;
  симптом — ошибка при первом же ходе призванного питомца).
- `onUpdate` агента-источника может тащить логику засады (`PreferWait = true` +
  `BehaviorMult[EngageMelee] = 0` у гуля — у ванили ещё и с оговорками: ≤3 раунда, пока гулов
  меньше прочих союзников; условие «гулов меньше» считает флаг «ghoul» у союзников — питомцу без
  флага среди братьев оно вечно true, т.е. неприменимо) — для атакующего питомца засаду вырезают
  целиком, иначе стоит на месте весь бой.
- `ai_engage_melee` сближает НЕ по дальности оружия, а по `Properties.EngageRangeMax/EngageRangeIdeal`
  (дефолт 1/1; авто-подстройка `setEngageRangeBasedOnWeapon` в ванили ниоткуда не вызывается) —
  питомцу с дальнобойной атакой (у жабы язык 3 клетки) в create() агента выставлять
  `EngageRangeMax/Ideal = 3` по паттерну ванильного `ghost_agent`, иначе питомец идёт в рукопашку
  вплотную; осторожность при этом даёт `PreferCarefulEngage = true` (обход вредных тайлов/зон
  контроля) — компромисс «осторожный, но атакующий» (образец: `companions_xxmob_toad_agent`).
