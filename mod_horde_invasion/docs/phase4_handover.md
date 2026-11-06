# Передача на фазу 4: контракт «Порох орды» (новый, с нуля)

> Документ-хендовер между сессиями. Написан по итогам сессии, в которой делались
> фазы 0–3. Новая сессия: прочитай это + TZ §7 (спека контракта) + профиль AGENTS.md мода,
> затем начинай с РЕКОНА (список вопросов ниже). Жёсткое правило API и ловушки — в корневом
> `AGENTS.md` (там всё уже зафиксировано, не дублируй).

## Состояние проекта на момент передачи

- **Фазы 0–2 ✅** (каркас кризиса, конфиг, лагеря/отряды/Генерал) — протестировано в игре.
- **Фаза 3 ✅** — все 5 контрактов адаптированы и зарегистрированы, чекер зелёный:
  `horde_root_out`, `horde_last_stand`, `horde_break_siege`, `horde_free_prisoners`,
  `horde_decisive_battle` (последний — другой сессией). Actions на трейте NobleHouse,
  регистрация — в `mod_horde_invasion/config/units_config.nut`.
  Игровой тест 4 контрактов (decisive_battle не тестили) — на стороне заказчика.
- **Фаза 4 ⬜ — «Порох орды» (этот документ).** Фаза 5 (амбиция + финализация, отчасти готова:
  news/альянс/сила работают), фаза 6 (полировка текстов валидацией) — после.

## Спека контракта (TZ §7, кратко)

1. Наниматель даёт огненную бомбу (`data_014/scripts/items/tools/fire_bomb_item.nut`), отправляет
   взорвать склад пороха в ближайшем лагере орды.
2. Поле боя: ~10 бочек `mod_Jurchen/scripts/entity/tactical/objective/barrel_of_gunpowder.nut`,
   **у спавна врага, за его спиной** — к бочкам надо прорываться.
3. Постоянные подкрепления врага — по образцу
   `!project/zmod_davkul_rising-russian/scripts/skills/actives/summon_reinforcements_skill.nut`.
4. Отслеживать, взорваны бочки или нет.
5. Цель — не победить, а взорвать бочки и отступить. В тексте честно написать.
6. Кастомный Defeat: анализ «отступили ли с взорванным складом» → не выполнили = контракт
   остаётся активным; выполнили = стадия возврата к нанимателю.

## Рекон (обязательный первый шаг новой сессии)

1. **Контрактный скелет**: как устроены адаптированные `horde_*_contract.nut` (есть в репо) —
   состояния/экраны/флаги; куда вешать кастомный бой. Образец «нового» контракта ванили
   не существует — собирать из кусков: scripted combat (`Const.Tactical.CombatInfo.getClone()`,
   см. экраны Scouts/Ambush в horde_free_prisoners), стадии Offer→Running→Return.
2. **Скриптованный бой с объектами**: как в тактический бой контракта добавить акторов-объектов
   (бочки) на конкретные позиции. Ключи: `p.Entities` (только юниты?), хуки боя у контракта
   (`onCombatStarted`?), либо спавн из юнита как делает `nomad_fireblunderbuss.nut`
   (`spawnEntitiesAtCenter`). Прочитать `docs/locations/tactical_location_guide.md` и чек-лист
   (`docs/locations/tactical_location_checklist.md`) — ОБЯЗАТЕЛЬНО до боевой части
   (там же ловушки: объекты ставить в callback'и, не в fill и т.п.).
3. **Бочки**: `barrel_of_gunpowder.nut` — `EntityType.CaravanDonkey`, взрыв в `onDeath`,
   атакуемость — хук `entity.isAttackable` в mod_jin (загружен всегда, наш мод требует mod_jin —
   повторный хук не нужен). Как детектить смерть бочки в рамках контрактного боя:
   флаги на актора / счётчик через `onActorKilled`-подобный коллбек контракта
   (см. `onActorKilled` в horde_last_stand).
4. **Подкрепления**: полностью разобрать `summon_reinforcements_skill.nut` (davkul) —
   механика вызова юнитов среди боя, лимиты, AI.
5. **Кастомный Defeat/отступление**: как контракты обрабатывают поражение и ретрит —
   `onRetreatedFromCombat(_combatID)`, `finishActiveContract(true)`, флаг «IsContractFailed»
   (см. Running у horde_break_siege); вариант «контракт не провален, остаётся активным» —
   просто не вызывать finish, выставить флаг и вернуться в стадию подготовки.
6. **Награда/возврат**: стандартная стадия Return + Success1 (копипаста из любого horde_*).
7. **Тексты**: читать `docs/texts/text_generation.md` + `text_validation.md`. Правило коней:
   в бою пешие — коней не упоминать.

## Проверенные паттерны (не выдумывать, брать готовое)

- Регистрация контракта: action-класс в `scripts/factions/contracts/horde_powder_action.nut`
  (копия любого horde_*_action) + push в `units_config.nut` (НЕ менять порядок существующих —
  добавлять в конец). Gate — `isHordeInvasion()`, порог репутации ~1500, cooldown 5–7 дней.
- Все мировые спавны через `FactionManager.getFactionOfType(Const.FactionType.Jurchen/Mgl)`;
  спавнлисты орды: `Const.World.Spawn.HordeRoamers/HordeRaiders/HordeDefenders`
  (Defenders — с Генералом, MaxCount 1).
- Лагеря-цели считать ВСЕ: `location.nomad_jin_city*`, `location.nomad_mgl_city*`,
  `location.horde_camp*` (решение заказчика, зафиксировано в TZ §4).
- Музыка боёв с ордой — `this.Const.Music.JinTracks`; следы — `FootprintsType.Nomads`;
  баннеры — `banner_jin`/`banner_mgl` или баннер ближайшего лагеря.
- Ордера AI: `roam_order`, `ambush_order`, `move_order`, `wait_order`,
  `attack_zone_order`, `destroy_order` (НЕ `convert_order` — тот превращает город в зомби-город).
- Сохранение: новые поля m.* сериализовать в onSerialize/onDeserialize как в существующих
  (writeU32 ID + WeakTableRef восстановление).
- Только новые кампании: Deck фракций строится при генерации мира — actions пушатся
  в `FactionTrait.Actions` на загрузке мода, сейвы без мода не подхватят (известно, ок).

## Тестовый стенд (проверен)

- bb_vanilla_plus: сценарий «Мужской Персонаж + Книга Умений» = суперотряд 12×13 ур. с именной
  экипировкой (сила отряда сразу >180).
- useful_pack (`mod_crisis_duration_setting`): Warning=0, Live=0, первый кризис=1 день,
  Warning→Live=1 день → Live через ~2–7 дней на любой пати.
- Лог: `C:\Users\Ivan\Documents\Battle Brothers\log.html` (маркеры `HordeInvasion:`).
- Сборка: `build.bat` мода, игра закрыта; чекер `python ../tools/nut_check.py <файлы>`.

## Нерешённые мелочи (не блокеры)

- decisive_battle не тестился в игре.
- Ловушка: наши кризисные контракты висят на том же трейте NobleHouse, что и ванильные —
  при совпадении кризисов (не наш) они просто не спавнятся (гейт isHordeInvasion), ок.
- Осадные орудия в break_siege используют ванильные спрайты катапульт — заказчик планирует
  возможный рескин.

---

## Итог фазы 4 (2026-11-05, сессия 2)

Реализовано по этому хендоверу, чекер `nut_check.py` и линт `lint_texts.py` — чисто:

- `scripts/factions/contracts/horde_powder_action.nut` — копия гейта horde_root_out (репутация 1500,
  cooldown 6 дней, шанс 30, трейт NobleHouse; регистрация — в конец списка `units_config.nut`).
- `scripts/contracts/contracts/horde_powder_contract.nut` — контракт с нуля:
  - цель — ближайшее поселение Jurchen/Mgl к городу нанимателя (все типы лагерей, решение TZ §4);
  - наниматель выдаёт `fire_bomb_item` в стеш (Offer.end);
  - бой — `CombatID "PowderDepot"`, `p.Entities = []`, всё спавнится в `BeforeDeploymentCallback`:
    гарнизон 9–11 юнитов (ironpagoda/fireblunderbuss/halberdmaster/spearmaster, зона x 19..24),
    первому — скрытый эффект подкреплений; 10 бочек `barrel_of_gunpowder` за спинами врага (x 26..30),
    фракция бочек = фракция лагеря (союзники по фракции их не трогают, игрок бьёт — хук isAttackable в mod_jin);
  - подсчёт взорванных бочек — `onActorKilled` по `ClassName == "barrel_of_gunpowder"`
    (см. `onActorKilled` в horde_last_stand), все 10 = `IsDepotDestroyed`;
  - кастомный Defeat: победа/отступление без склада → экраны WonDepotIntact/RetreatAfterFailure,
    контракт остаётся активным (cooldown повторного штурма 8 ч); со складом → Return;
  - сериализация `m.Target` — writeU32 + WeakTableRef.
- `scripts/skills/effects/horde_call_reinforcements_effect.nut` — подкрепления по образцу davkul,
  но скрытый StatusEffect с `onTurnEnd` (детерминированно, не зависит от AI-агента):
  3 юнита каждые 3 хода с восточного края, лимит 25 юнитов фракции, стоп при отступлении.
  Убийство сотника (первый ironpagoda) прекращает волны.

Уроки (внесены в `docs/locations/tactical_location_guide.md` §4): контекст `BeforeDeploymentCallback`
(`this.Tactical`/`this.Math` ок, `this.new` — нет, инстансы создавать до присвоения колбэка);
геометрия Line-развёртывания (игрок x 10..12, враг x 19..24, «за спинами» = x 26..30).

Не сделано (как и планировалось): игровой тест — на стороне заказчика; сборка — только по запросу.
