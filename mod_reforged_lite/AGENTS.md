# Проект: mod_reforged_lite (Reforged Lite)

Lite-версия мод-комплекса Reforged для Battle Brothers (Squirrel, .nut + JS-хуки).
Источник контента — полный Reforged; переносится ТОЛЬКО функционал из явных задач пользователя.

## Базовые принципы (обязательны для любой сессии)

1. **Бережно к ваниле.** Обратная совместимость с другими модами важнее полноты переноса.
   Никаких глобальных переписываний ванильных систем. Только самые необходимые обёртки
   из утилитарных модов: MSU (`mod_msu`), modern hooks (`mod_modern_hooks`).
   Для вложенных тултипов при необходимости — `mod_nested_tooltips` (см. ниже).
2. **Только задачный функционал.** Переносится ровно то, что указано в задаче пользователя,
   ничего лишнего. Если по зависимостям есть сомнения — спрашивать пользователя,
   не тянуть «на всякий случай».
3. **ID не меняем.** При переносе сохраняются изначальные ID сущностей, предметов, скиллов,
   травм, констант (`rf_*`, `RF_*`), чтобы lite-версия совпадала со старшим братом
   (сейвы, совместимость, отладка по референсу).
4. **Ассеты — только нужное.** Переносим brushes/gfx/sounds/music только для переносимого
   функционала. Спрайты reforged лежат целыми листами (brush+png парой) — разделять листы
   не требуется, копируем пару целиком.
5. **Адаптация вместо фреймворка.** Полный Reforged завязан на свой фреймворк
   (`::Reforged.*`, Reach, perk groups, affordability preview, dynamic spawns). В lite НЕ
   переносим фреймворк: референсные вызовы заменяются на ванильные аналоги
   (обычно `this.new`/`::new` + присвоение полей).
   Исключение — вложенные тултипы: это функционал мода-зависимости mod_nested_tooltips,
   тексты пишутся с `::ReforgedLite.Mod.Tooltips.parseString(...)` и ссылками
   `[текст|Concept.X]` / `[текст|Skill+имя_файла]`.
   **Скиллы НЕ хукаются поодиночке**: ссылки резолвятся по индексу ВСЕХ скиллов/предметов
   (vanilla + все моды) по имени файла скрипта. Правило: ванильные скиллы ради ссылок не трогаем;
   свои тексты снабжаем parseString сразу; ссылка на скилл чужого мода — только через Skill+filename.

## Зависимости

- **mod_msu >= 1.8.0** (`::MSU.*`: Table, Text, AI, Class.Mod) — обязательна
- **mod_modern_hooks** (`::Hooks.*`) — обязательна
- **mod_nested_tooltips** (Nested Tooltips Framework >= 0.5.4, полная версия с JS) —
  обязательна; вложенные тултипы ([текст|Concept.X] / [текст|Skill+имя файла]) работают
  через `::ReforgedLite.Mod.Tooltips.parseString` поверх её API. В data игры должен стоять
  ПОЛНЫЙ мод (с `ui/mods/msu/nested_tooltips.js`), иначе гиперссылки не рендерятся.
- Все DLC (как у полного Reforged/vanilla_plus)

## Ресурсы старшего брата (НЕ коммитить, только чтение)

Каталог `Z:\GameMods\Battle Brothers\mods\!project`:

- `mod_framework-0.9.2-russian/` — фреймворк Reforged (modular_vanilla: preview-система,
  Reach и пр.). Для lite — только референс, как заменять вызовы.
- `mod_reforged_core-0.9.3-russian/` — основной код: `scripts/` (сущности, предметы, скиллы,
  травмы), `mod_reforged/` (хуки, dynamic_spawns, msu_systems/tooltips).
- `mod_reforged_assets-0.1.4/` — ассеты: `brushes/*.brush`, `gfx/*.png`, `music/`, `sounds/`.
- Распакованная ваниль: `data_014/` — жёсткое правило API: незнакомые методы/константы
  сверять grep'ом по этому каталогу, иначе не использовать.

Промежуточная адаптация многих вещей уже сделана в `../bb_vanilla_plus` (ручной перенос
с 0.8.14 под ванильные перки) — сверяться и с ним.

## Структура

- `scripts/!mods_preload/mod_reforged_lite.nut` — регистрация мода (`::Hooks.register`,
  require, queue после mod_msu/mod_modern_hooks)
- `scripts/!mods_preload/!config/` — конфиги-константы, грузятся автоматически
  (регистрация EntityType/FactionType/спавн-листы)
- `mod_reforged_lite/load.nut` — подключает `mod_reforged_lite/hooks/**` и регистрирует JS
- `mod_reforged_lite/hooks/` — хуки (config/, factions/, ui/screens/tooltip/)
- `mod_reforged_lite/tooltips/` — хелперы вложенных ссылок и Concept-словарь
- `NESTED_TOOLTIPS_TASK.md` — ТЗ отдельной задачи: ссылочные тултипы для всей игры (ванила + моды)
- `scripts/` — игровой контент (entity/, items/, skills/, factions/, events/, ai/)
- `ui/mods/mod_reforged_lite/` — JS-хуки (оборачивают прототипы ванильных UI-модулей)
- `brushes/ gfx/ music/ sounds/` — ассеты (в гит не коммитятся, локальные)

## Сборка

- `build.bat` — упаковка в `mod_reforged_lite.zip` через корневой `../build.sh`
  → `Z:\SteamLibrary\steamapps\common\Battle Brothers\data`. ЗАПРЕЩЕНО запускать
  автоматически — только по явной просьбе пользователя, при закрытой игре.
- `build_brushes.bat` — то же с пересборкой спрайтов (bbrusher), см. корневой AGENTS.md.

## Состав (нарастает по задачам)

- Фракция драугров (курганники): сущности, предметы, скиллы, локации, спавн-листы
  (`scripts/!mods_preload/!config/mod_draugr_spawnlist.nut`, пропорции по оригиналу 0.9.3),
  фракция, tavern-руморы (getType-костыль), mapgen-шаблон tactical_rf_barrows
- Травмы rf_black_eye / rf_dislocated_jaw / rf_heat_stroke + хук character_injuries;
  мини preview-система (хук actor: isPreviewing/getPreviewSkill) для тултипов
- Вложенные тултипы: зависимость **mod_nested_tooltips** (полная версия 0.5.4 в data);
  Concept-словарь мода — `mod_reforged_lite/tooltips/concepts.nut`, ссылки в текстах —
  `::ReforgedLite.Mod.Tooltips.parseString`
- Орки-нежить: rf_zombie_orc* (7 сущностей, 2 расовых скилла, bite-скилл), хуки generateCorpse
  ванильных орков; спавн — только в партиях с некромантом (vanilla Necromancer/NecromancerSouthern/UndeadScourge)
- Расширение предметов: оружие/броня/шлемы/зелья/банка с холодом (rf_*, кроме anatomist-зелий),
  named в NamedMeleeWeapons, магазины (оружейник/бронник/алхимик/прикреплённые локации),
  раздача врагам — пост-хуки assignRandomEquipment (rf_item_distribution.nut)
- Кризис нежити: элитные юниты Reforged — некрокультист-лорд (rf_vampire_lord), скорбная мать
  (rf_banshee), адская гончая (rf_hollenhund) — через .extend в UndeadScourge (поздние партии);
  орки-нежить — только в партиях с некромантом; 20% дроп слезы гейста с ванильного призрака;
  крафт зелий/банки у алхимика (scripts/crafting/blueprints, ванильный менеджер подхватывает сам)
- Защитник герольда (rf_heralds_bodyguard, Royal Guard) + 6 перков + special rf_bodyguard —
  через .extend в ванильных отрядах благородных (Spawn.Noble); единственный пользователь
  rf_heraldic_cape_upgrade (как в оригинале; в магазины НЕ добавлять)
- Проверка использования: все перенесённые предметы имеют пользователей (магазины, крафт,
  экипировка, раздача); сироты оригинала (rf_draugr_pauldron_*) оставлены как в 0.9.3
- Крепость разбойников (rf_bandit_fort_location + rf_build_bandit_camp_action): элитный лагерь
  бандитов (палисад, 300 ресурсов, лут богаче bandit_camp); строится фракцией бандитов
  (1 с 1-го дня, +1 за 50 дней, макс 6) — регистрация через .extend actions бандитов;
  спрайт карты уже в rf_world_entity
- НЕ переносится: система Reach (досягаемость), rf-перки без ванильных аналогов
  (menacing/wear_them_down у zombie_orc, sweeping_strikes у vampire_lord — завязаны на Reach),
  addPerkGroupOfEquippedWeapon, anatomist-зелья, легендарные сущности кроме перечисленных кризисных
- Ссылочные тултипы ванильных навыков (batch Reforged 0.9.3, ~125 хуков в hooks/skills/**):
  только тултип-части хуков из mod_reforged/hooks/skills/**. Решение А/Б из NESTED_TOOLTIPS_TASK.md
  не выбрано — перенос «как в Reforged» (хуки getTooltip), см. правила ниже. Также: хук
  hooks/entity/tactical/actor.nut getTooltip — имена эффектов в тактическом тултипе стали
  вложенными ссылками (Skill+filename, entityId актора); hooks/skills/skill.nut — late-хук
  защиты getTooltip скилла без контейнера (dummy-контейнер MSU); в concepts.nut добавлен
  Concept.MoraleCheck (в словаре Reforged ссылка на него была, а самого концепта — нет)

## Ссылочные тултипы навыков (правила переноса на любой мод)

Эталон — полный Reforged (`mod_reforged_core-0.9.3-russian/mod_reforged/hooks/skills/**`).
Цель lite: ссылки `[текст|Skill+файл]` / `[текст|Concept.X]` в описаниях, ВАНИЛЬНЫЕ механики
и числа, ноль балансовых правок. Пользовательская формулировка задачи на будущее:
«сделай отображение описания навыков этого мода по нашим правилам».

Процедура:
1. Для каждого файла хука определить класс: PURE (только getTooltip/getDescription/getName/
   getCostString/create-описательное) — переносить целиком с заменой неймспейсов
   (`::Reforged.Mod.Tooltips`→`::ReforgedLite.Mod.Tooltips`, `::Reforged.NestedTooltips`→
   `::ReforgedLite.NestedTooltips`, `::Reforged.HooksMod`→`::ReforgedLite.HooksMod`);
   MIXED — переносить ТОЛЬКО тултип-присваивания, баланс (onUse/onHit/onAdded/onUpdate...)
   выбрасывать. `create` переносить, только если меняет Description/Name/Icon/Overlay.
2. Если getTooltip вызывает хелпер из выброшенной части — хелпер переносить тоже, но только
   если он чистое вычисление/геттер, воспроизводящее ванильную логику (образцы:
   split_shield.RF_getFatigueDamage, champion_racial.getDefenseMultiplier/getHitpointMult,
   berserker_rage_effect.calcDamageTakenMult).
3. КРАСНЫЕ ФЛАГИ — не переносить файл либо переписывать текст под ваниль:
   - текст описывает рефордже-механику: Reach/досягаемость (Concept.Reach, rf_reach.png,
     getReachIgnore), суммирующееся кровотечение (стаки, m.Stacks, RF_BleedingEffectMult),
     переделанные перки/эффекты (adrenaline с иммунитетом к травмам, taunt/taunted со
     штрафом защиты, nimble с защитой брони, gash с BleedStacks и порогом травм, recover
     с запретом после перемещения, shieldwall «снимает штраф усталости», night_effect
     «штраф за клетку», throw_balls «игнорирует щит», double_grip по типам оружия);
   - обращение к полям/методам, которых нет в ванили (аудит ниже): m.MeleeSkillAdd,
     m.BonusMult, m.MinHP, GrantsInjuryImmunity, getMaxTilesAllowed, rf_polearm_adjacency,
     rf_*-эффекты в ::new/ссылках (rf_falcon_released_effect, rf_inspiring_presence_buff_effect);
   - ссылки `Skill+rf_*` / `Perk+perk_rf_*` на контент, отсутствующий в lite;
   - ::Reforged.Mod.ModSettings / ::Reforged.Const — зависимость от систем Reforged;
   - тултип СКРЫВАЕТ ванильную информацию (knock_back switcheroo, hand_to_hand удаление
     записи) или переворачивает ванильную семантику (horror: horrified при ПРОВАЛЕННОЙ
     проверке, checkMorale возвращает true = успех).
4. Подчёркивать (ссылки): названия эффектов/умений/перков/предметов — через
   `::ReforgedLite.NestedTooltips.getNestedSkillName/Image(obj, "entityId:"+id)` (в текстах
   тактического тултипа) или `[текст|Skill+имя_файла]`; игровые термины (ход, усталость,
   зона контроля...) — `[текст|Concept.X]`. Каждая ссылка должна резолвиться: файл скилла/
   предмета — проверять существование в data_014 + lite, концепт — наличие ключа в
   concepts.nut (ручные + автоконцепты character-stats.*). Отсутствующий концепт — добавить
   в concepts.nut (текст — по ванильным строкам из tooltip_events.nut data_014).
5. Эталон структуры ванильного описания: title (1) / description (2) / стоимость (3) /
   урон (4-5) / дальность (8) / особые записи (10+) — писать в том же стиле; для «голых»
   скиллов возвращать `this.skill.getDefaultTooltip()` (нужен контейнер) или
   `getDefaultUtilityTooltip()` (без контейнера); BBCode-цвета — ::MSU.Text.* (colorPositive/
   colorNegative/colorDamage/colorize*), ванильные константы — ::Const.Combat/Strings.
6. Проверки ОБЯЗАТЕЛЬНЫ: `python ../tools/nut_check.py`; аудит полей `this.m.X` и вызовов
   `this.X()` против data_014 (скрипты классификации/аудита — вне репо, см. историю
   сессии nested-тултипов; пересоздать по описанию); сверка КАЖДОГО числа и механического
   утверждения текста с ванильным файлом скилла (grep по data_014) — рефордже-числа часто
   отличаются (огонь скелета 66% не 75%, шрат +200% от огня, альп 90/66/75% дальнобойные).
   Скрытые в ванили скиллы (IsHidden = true) — тултип недостижим в списках эффектов, но
   доступен по вложенной ссылке: хук не мёртв, не удалять.
7. ЛОВУШКИ АДАПТАЦИИ (найдены в игровом тесте):
   - `::MSU.QueueBucket` в MSU 1.9 имеет только VeryLate/AfterHooks/FirstWorldInit.
     Бакет `Late` есть только во фреймворке Reforged (`::Reforged.QueueBucket.Late`) —
     при адаптации их хуков менять на `::MSU.QueueBucket.AfterHooks` (выполняется после
     применения ВСЕХ хуков — именно поэтому им пользовался Reforged для финальных обёрток).
   - `setTooltips` MSU НЕ мёржит существующие подтаблицы: `__addTable` рекурсирует только
     в НОВЫЕ ключи, существующий под-ключ заменяется целиком. Повторный setTooltips с
     `{Concept = ...}` стёр бы ручные концепты. Дополнять словарь — прямой записью:
     `::MSU.System.Tooltips.getTooltip(::ReforgedLite.ID, "Concept").Tooltip[ключ] <- тултип`
     (образец — конец tooltips/concepts.nut). ВАЖНО: инжектованный nested_tooltips getTooltip
     возвращает обёртку `{Tooltip, Data}`, а не таблицу концептов — без `.Tooltip` запись
     молча уйдёт вникуда (ошибки в логе не будет, ссылки просто не резолвятся).

## Правила работы

- Жёсткое правило API монорепозитория (см. корневой `../AGENTS.md`) действует в полной мере.
- После правок .nut — `python ../tools/nut_check.py <файлы>`.
- ПОСЛЕ переноса скиллов/перков с наследованием — обязательная сверка ВСЕХ inherit/new-цепочек
  (`::inherit("scripts/...")`, `::new("scripts/...")`) по lite + data_014: рефордже перки-наследники
  тянут абстрактных родителей (perk_rf_swordmaster_abstract, rf_swordmaster_active_abstract,
  rf_heavy_cleave_skill), которые легко пропустить. Урок первого запуска: 2 «безродных» родителя.
- Ключи ванильных enum НЕ угадывать: `FactionTrait.Bandit` (не Bandits) — сверять grep'ом по data_014.
- Минимальные изменения; стиль — как в референсе (reforged/vanilla_plus).
- Порядок записей в реестрах-конфигах не менять; новое — в конец.
- `.extend` партий в ВАНИЛЬНЫЕ спавн-группы: ванильный спавнер требует `party.Cost` (ставит
  ванильный `calculateCosts` в конце конфига, ДО мод-хуков). Поэтому — централизованный
  пересчёт `::calculateCosts` для всех затронутых групп в `MSU.QueueBucket.VeryLate`
  (load.nut мода). Урок первого запуска: «the index 'Cost' does not exist».
