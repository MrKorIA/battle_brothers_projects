# Фаза 0: рекон устройства кризисов (отчёт)

Дата: 2026-11-04. Источники: ваниль `mods/!project/data_014/scripts/` (версия 65), `mod_Jurchen`, `Scourge of God-486-0-1-1643807750`. Репозиторные копии обоих модов идентичны внешним.

## 1. Устройство кризисов в ванили

«Кризис» = **Greater Evil**, состояние — в `factions/faction_manager.nut`, поле `m.GreaterEvil = { Type, LastType, TypesUsed, Phase, NextPhaseTime, Strength, LastUpdate }`. Константы — `config/world.nut`:

```
GreaterEvilType: Random=0, CivilWar=1, Greenskins=2, Undead=3, HolyWar=4, None=255
GreaterEvilTypeBit: CivilWar=1, Greenskins=2, Undead=4, HolyWar=8, All=15
GreaterEvilPhase: NotSet=0, Warning=1, Live=2
```

- Предикаты: `isGreaterEvil()`, `isGreenskinInvasion()` и т.п. — проверка `Type == X && Phase == Live`.
- Запуск: `faction_manager.updateGreaterEvil()` (ежедневно). Warning при силе отряда ≥160, Live при ≥180. `Type == Random` → случайный выбор из неиспользованных (битовая маска `TypesUsed`).
- Старт Live-фазы — per-type ветки: `addNews("crisis_X_start")` + альянсы (Greenskins: `Orcs.addAlly(Goblins)` и обратно, `faction_manager.nut:989-990`). Священная война: `breakNorthSouthAlliances()`.
- Сила кризиса: `GreaterEvilStartStrength = 125`, расход по константам `config/factions.nut:10-17` (CriticalContract −12, CommonContract −6, LocationDestroyed −4, PartyDestroyed −2, TownDestroyed **+20**, ежедневно −1). Конец: `Strength <= 0` и нет активного контракта → `addNews("crisis_X_end")`, `TypesUsed |= бит`, снятие альянсов, `LastType = Type; Type = Random; Phase = NotSet`, пауза 25–35 дней.
- **Альянс двух фракций** (паттерн Зеленокожих) — только на время Live-фазы. Паттерн Нежити (`Undead ↔ Zombies` в `createAlliances()`) — союз «всегда», без кода кризиса.
- Финального «типа контракта» нет: финалы — обычные crisis-actions с `addGreaterEvilStrength(Critical)`. Кризис кончается сам, когда Strength ≤ 0.
- События: `events/events/crisis/*` подхватываются автоматически (`event_manager.create` делает enumerateFiles). Intro/outro цепляются за news: `Statistics.hasNews("crisis_X_start")` → `popNews`. Warning-события гейтятся на `Phase == Warning && Type == X`.
- Контракты кризиса — faction actions на трейте **NobleHouse (8)** (`config/faction_traits.nut` → `Const.FactionTrait.Actions`), гейт в `onUpdate`: `isXxxInvasion()` + общие условия (relation > 25, репутация 1500–1600, `ambition.make_nobles_aware`). Наниматель — случайный персонаж фракции-владельца action'а (обычное поселение/благородный дом).
- Лагеря: та же механика `build_*_camp_action`, в кризис — выше лимит (до 20 vs 12–14) и ближе к поселениям (8–20 vs 15+ тайлов). Спавн: `World.spawnLocation(...)` + `faction.addSettlement(camp, false)`.
- Амбиции (`defeat_greenskins_ambition.nut`): успех = `getGreaterEvil().Type == 0 && LastType == <мой тип>`; прогресс = `Strength / GreaterEvilStartStrength`.
- **UI выбора кризиса** — два файла:
  1. `ui/screens/menu/modules/campaign_menu/new_campaign_menu_module.js` — `buildCompanyCrisisSelectionPanel` (~стр. 190), радиокнопки `self.mEvil = N`; `gatherSettings` → `settings.lateGameCrisis` (стр. 1070).
  2. `scripts/ui/screens/tooltip/tooltip_events.nut` — кейсы `menu-screen.new-campaign.EvilRandom|EvilNone|EvilWar|EvilGreenskins|EvilUndead|EvilCrusade` (стр. 2030–2114).
- Применение выбора: `states/world/asset_manager.nut:376 setCampaignSettings` → `FactionManager.getGreaterEvil().Type = _settings.GreaterEvil`. Никаких World.Flags — только `m.GreaterEvil`.

### Ключевой вывод по интеграции

`updateGreaterEvil()` не требует полного перекрытия файла. Все переходы фаз (Warning→Live, Live→конец, ежедневный расход силы, `TypesUsed`) — **type-агностичны**. Переопределить нужно только:
- константы `GreaterEvilType`/`GreaterEvilTypeBit` (добавить `Horde = 5`, бит `16`, расширить `All`) — динамически из конфига мода;
- добавить ветку старта/конца Live для типа 5 (news + `addAlly` Jurchen↔Mgl) — хуком на `updateGreaterEvil`;
- предикат `isHordeInvasion()` — хуком на faction_manager;
- радиокнопка в JS + кейс тултипа — перекрытием двух файлов UI.

Вариант «полностью свой цикл кризиса» отвергнут: ванильные проверки (`isGreaterEvil()` — музыка, концовки, ачивки) кризис не заметили бы, пришлось бы дублировать всё.

## 2. Устройство Jurchen и Mgl

- **Стек:** оба мода — Modern Hooks + MSU (`::Hooks.register`, `queue`, `@(__original)`, `require(["mod_msu"])`). Никакого копирования ванильных скриптов. Тот же стек, что у `bb_vanilla_plus`. ⇒ Наш мод пишем в этом же стиле; зависимость от `mod_msu` транзитивная.
- **Фракции** регистрируются хуком `faction_manager.createAlliances` + функция `addFaction()` в `!mods_preload/!config/mod_*_config.nut`: динамический хвост `Const.FactionType/Faction/Color/Base/Trait` (инкремент общего `COUNT` — номера зависят от порядка загрузки, ссылаться только по имени). Оба класса (`jin_faction.nut`, `mgl_faction.nut`): `IsHidden = true`, `PlayerRelation = 0`, своя музыка. **Альянсов нет ни с кем.**
- **Spawnlists** — самописный генератор (`spawnlist_jin.nut` 487 стр., `spawnlist_mgl.nut` 501 стр.): режимы `Mode = "Archetype"` (ротация по `ArchetypeStride`) и `"Weighted"` (+ `LeaderArchetypes` каждый `LeaderInterval`); юниты с `Weight/MinR/MaxR/MaxCount/FadeStartR/FadeR`; на выходе готовый массив пресетов `[{Body, MovementSpeedMult, Troops}]`, который читает **ванильный** `assignTroops`. Имена: `JurchenRoamers/JurchenRaiders/JurchenDefenders`, `MglRoamers/MglRaiders/MglDefenders`.
- **Archetypes** — только spawnlist-концепция: `Body` (worldmap-фигура), `MovementSpeedMult` (везде 1.0 — нашим Roamers выставим 1.1), `Units[]` с `BodyOverride` для лидеров. Разворачиваются на загрузке, не в рантайме.
- **Лагеря:** локации `nomad_jin_city(_city2)_location`, `nomad_mgl_city(_city2)_location` (`Resources = 300`, `setDefenderSpawnList(*Defenders)`); тактические шаблоны `tactical.jin_camp`, `tactical.jin_desert_camp` (спавнит бочки пороха!), `tactical.mgl_camp`. Спавн — `build_*_camp_action` (лимит 5, день ≥ 70). У Mgl есть `legendary_khan_location` (уникальный «Курган хана»).
- **Юниты (релевантные TZ):**
  - «сотник Mgl» = `mgl_kehanweishi.nut` («Кэшик», командир-лучник).
  - «сотник Jurchen» = `nomad_centurion.nut` («Мэнъань», named-оружие, `centurion_agent`).
  - Лёгкие лучники Mgl: `mgl_mumin`, `mgl_caoyuanzhanshi`; тяжёлый: `mgl_baihuzhang`.
  - Jurchen: `nomad_infantry`, `nomad_fireblunderbuss` (огнестрел; спавнит `barrel_of_gunpowder`), `nomad_ironpagoda` (латник), `nomad_spearmaster`, `nomad_halberdmaster`.
  - База босса «Генерал» — `nomad_centurion.nut`.
- **Barrel of gunpowder:** `mod_Jurchen/scripts/entity/tactical/objective/barrel_of_gunpowder.nut` (`EntityType.CaravanDonkey`, взрыв в `onDeath`); атакуемость — хук `entity.isAttackable` по `ClassName == "barrel_of_gunpowder"` в `mod_jin.nut` (нам переиспользовать тот же хук — или он уже сработает, раз Jurchen загружен).
- **Named-оружие** без реестров: прямая экипировка в `onInit` юнитов. Кандидаты для Генерала: `named_jinweapon{02,03,04,05,13}`, `named_mgl_{05,09}`.
- Совместимость с data_014 (v65) подтверждена чтением кода обоих модов — конфликтов API не найдено.

## 3. Решения

### [ВОПРОС-1] — РЕШЕНО: альянс существующих фракций (паттерн Зеленокожих)

Отряды орды — в существующих фракциях **Jurchen + Mgl**, объединённых временным альянсом на Live-фазе кризиса (`addAlly`/`removeAlly`, как Orcs↔Goblins). Новая фракция-кризис **не создаётся**. Аргументация:

1. Ванильный прецедент: кризис Зеленокожих — ровно это (две фракции + альянс на время кризиса).
2. Обе фракции уже полностью обеспечены: юниты, spawnlists (3 списка на фракцию — Roamers/Raiders/Defenders уже существуют!), лагеря, тактические шаблоны, named-оружие.
3. Кризисная логика (сила, новости, амбиция, контракты) живёт в FactionManager и не зависит от того, одна фракция или две.
4. Смешанные составы Roamers/Raiders (лучники Mgl + пехота Jurchen) реализуются отдельным spawnlist'ом кризиса (`HordeRoamers/HordeRaiders/HordeDefenders`) по образцу `buildSpawnArray` — это не требует новой фракции.
5. Меньше кода, меньше конфликтов с сейвами (новая фракция = новый индекс в сейвах).

### Ответы на прочие вопросы TZ (из рекона)

- **[ВОПРОС-2]** ID босса: `mgl_general_...` из TZ не подходит (босс на базе **Jurchen**-центуриона). Предлагается `nomad_horde_general` / `HordeGeneral`. Финал — при фазе 2.
- **[ВОПРОС-3]** Размещение 10 camp: по образцу `build_orc_camp_action` в кризисе — кризисные параметры `getTileToSpawnLocation(..., 8, 20, ...)` (близко к поселениям) + повышенный лимит. Своя action `build_horde_camp_action` с лимитом 10 и гейтом `isHordeInvasion()`.
- **[ВОПРОС-4]** Наниматель — обычные поселения/благородные дома (трейт NobleHouse), как во всех ванильных кризисах. Решено реконом.

## 4. План-конспект для фазы 1 (каркас)

1. Регистрация мода `mod_horde_invasion` (Modern Hooks, `require mod_msu`; транзитивно jurchen/mgl).
2. Конфиг: `GreaterEvilType.Horde = 5`, бит 16 в `GreaterEvilTypeBit` (+`All`).
3. Хуки на `faction_manager`: предикат `isHordeInvasion()`, ветки старта/конца Live (news `crisis_horde_start/end`, альянс Jurchen↔Mgl).
4. Crisis-события: warning (беженцы, гейт Warning+Type 5), intro (news start), outro (news end).
5. UI: радиокнопка в `new_campaign_menu_module.js` + кейс в `tooltip_events.nut`.
6. Проверка: игра грузится, кризис выбирается при старте, warning → live → news/alley работают (без контрактов/лагерей — фазы 2+).
