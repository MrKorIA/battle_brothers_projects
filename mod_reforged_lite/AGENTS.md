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
- `mod_reforged_lite/load.nut` — подключает `mod_reforged_lite/hooks/**` (функциональные хуки),
  движок тултип-хуков скиллов, `mod_reforged_lite/tooltips/hooks/**` (тултип-хуки) и регистрирует JS
- `mod_reforged_lite/hooks/` — ФУНКЦИОНАЛЬНЫЕ хуки (config/, factions/, entity/, contracts/, ui/)
- `mod_reforged_lite/tooltips/` — хелперы вложенных ссылок, Concept-словарь, движок
  `mod_skill_tooltips.nut` и `tooltips/hooks/` — тултип-хуки: `vanilla/` (батч ванили из
  прошлой сессии + инфраструктура: actor-линкификация, skill-заглушка + registry.nut —
  линкифайер-реестр остальных ванильных перков/черт/эффектов/расовых) и `<мод>/registry.nut`
  (реестры скиллов чужих модов под линкифайер)
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
- Вложенные тултипы: зависимость **mod_nested_tooltips** (полная версия в data, сейчас 0.5.5);
  Concept-словарь мода — `mod_reforged_lite/tooltips/concepts.nut`, ссылки в текстах —
  `::ReforgedLite.Mod.Tooltips.parseString`
- Фикс «залипания» тултипов mod_nested_tooltips 0.5.5 (JS-патч поверх `MSU.NestedTooltip` —
  `ui/mods/mod_reforged_lite/js_hooks/msu/nested_tooltips.js`, регистрация в load.nut; сторонний
  zip в data НЕ правим): 0.5.5 подавляет `showTileTooltip`, пока открыт залоченный тултип
  (коммит f763bbf; лок любого тултипа через lockDelay 500 мс), и тултип тайла под неподвижным
  курсором после резкого переноса на другого юнита не появлялся до следующего движения мыши
  (порог mMinMouseMovement 4 px) — разработчики мода знают («separate issue» в
  tests/tooltip_mouse.nut), фикса нет. Патч запоминает подавленный запрос
  (`__rflPendingTileTooltip`) и выполняет его из обёртки `updateStack`, когда стек освободился
  (залоченный тултип закрылся по grace). Защиты от ложного показа: свежесть запроса
  (grace+1000 мс) и проверка, что курсор не над UI-источником тултипа. UI-тултипы (навыки и пр.)
  багом не затронуты — их цепочка enter/leave залоченный тултип снимает корректно
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
- Охотники за головами (порт из mod_hardened): менеджер отрядов на карте мира
  (scripts/ai/world/bounty_hunter_manager.nut). 1 отряд (PartyMax), спавнится у неизолированного
  поселения >10 тайлов от игрока, фракция-работодатель = поселение, свежий ванильный спавн-лист
  Const.World.Spawn.BountyHunters (bounty_hunter/bounty_hunter_ranged/wardog, ВАНИЛЬНЫЕ тактические
  сущности — редизайн Hardened НЕ переносится), ресурсы как у ванильных наёмников
  (min(330, 150+дни), НЕТ глобальных множителей Hardened). Фигура figure_hd_bounty_hunter_01
  перенесена в лист rf_world_entity (brushes/gfx — pack через bbrusher из bbros\bin\rf_world_entity).
  Прописка: хуки entity_manager (create/update/clear/onDeserialize), world_state.onSerialize
  (список отрядов пишется в World.Flags "HD_BountyHunterIDs" ДО __original — ваниль сериализует
  Flags раньше EntityManager, порядок проверен), событие HD_onRemoved (world_controller.popOrder
  дергает его у снимаемого приказа; пустая база на world_behavior, реализация в move_order —
  отряд с флагом HD_IsBountyHunters по прибытии перекрашивается во фракцию ближайшего
  поселения). Новые члены классов (HD_onRemoved и пр.) объявлять ТОЛЬКО через q.X <- ... —
  обёртка q.X = @(__original) по отсутствующему члену падает при применении хука (порядок
  файлов в hooks/** не гарантирован). Утилиты имён/баннеров наёмников —
  mod_reforged_lite/utils.nut (::ReforgedLite.util, включён в load.nut)
- Набеги на пристройки (порт из mod_hardened): attached_location.m.IsRaidable (можно атаковать
  и временно разрушить даже союзную) / GoesIntoLockdown (закрыта, пока у поселения
  "situation.raided") / IsAutoDetectedRaidableLocation. Базовый хук hooks/entity/world/
  attached_location.nut: onCombatLost → setActive(false) + статус "Набеги" поселению; isAttackable
  → false в блокировке (цель контракта — выбор спрайта selection поселения — блокировку снимает);
  тултип состава защитников СОЮЗНОЙ пристройки через флаг world_entity.m.HD_IsTemporaryUnallied
  (isAlliedWithPlayer → false пока флаг; хук в world_entity.nut); «Производит:» (дети-тултипы)
  у всех пристроек; развалины с исходным именем «X (Развалины)»; восстановленная пристройка
  перебрасывает именной лут (setActive + guard MSU.Serialization.isLoading). 6 военных пристроек
  raidable (fortified_outpost, militia_trainingcamp(+oriental), stone_watchtower(+oriental),
  wooden_watchtower): защитники Noble/Southern/Militia, именной лут, краски, ресурсы 150–250
  (без множителей Hardened). Производственные — автодетектом по onUpdateProduce (у военных
  продукции нет — двойная защита от порядка хуков): защитники-крестьяне/ополчение, списки
  Const.World.Spawn.HD_AttachedProduction(/Southern) (!config/mod_hd_attached_production_spawnlist.nut,
  + calculateCosts в load.nut); культура поселения выбирает список в createDefenders (список
  ставится в create, когда поселение ещё null). ВАЖНО: ваниль пускает бой с ЛОКАЦИЕЙ только если
  она не союзная (isAttackable && !isAlliedWithPlayer; у локаций НЕТ Ctrl-force-attack — он только
  у партий и жжёт всю репутацию с фракцией), поэтому союзную цель перед startCombat временно метим
  ванильным faction.setIsTemporaryEnemy(true) (сброс — ванильная faction_manager.onCombatFinished
  после боя). КРИТИЧНО: ваниль НЕ сериализует мод-поля и НЕ вызывает create() при загрузке сейва —
  raidable-состояние восстанавливается в onDeserialize: базовый хук перепроводит автодетект
  (производственные), 6 военных файлов применяют свой сетап из общей applyRaidSetup(this) в create
  И onDeserialize (+fallback Resources==0 для сейвов до фичи). Без этого защитники пустые, а
  ванильный location.onBeforeCombatStarted («нет защитников в листе ожидания») сам дёргает
  onCombatLost → «Набеги» из воздуха. ВЗАИМОДЕЙСТВИЕ (по запросу игрока, вместо диалога hardened):
  атакующий клик — Ctrl+ЛКМ по союзной пристройке (курсор атаки с Ctrl — хук
  updateCursorAndTooltip, по аналогии с партиями) или обычный ЛКМ, если владеющий город враждебен;
  клик помечает цель (world_state.m.HD_ForceRaidTarget — только button-события, и флаг живёт,
  пока ваниль ведёт отряд к локации: события мыши с зажатой кнопкой/клики в другое место
  сбрасывают его вместе с AutoEnterLocation, иначе драг стирал его до прибытия) — enterLocation
  (вызывается ванилью по прибытии AutoEnterLocation, world_state:767) открывает ДИАЛОГ БОЯ как у
  ванильных враждебных локаций; обычный клик по союзной пристройке — по ванили ничего не делает
  (союзная локация), ПОДАВЛЕНИЕ enterLocation ЗАПРЕЩЕНО: ломает контракты на пристройках
  (slave_revolt вешают onEnter/OnEnterCallback на локацию — suppression съедает их). Сигнал набега
  — world_state.m.HD_RaidLocation (WeakRef): enterLocation-raid-ветка ставит, onCombatFinished и
  combat_dialog_module_onCancelPressed снимают. Гарнизон в бою участвует ТОЛЬКО когда пристройка
  цель набега (attached_location.onBeforeCombatStarted сравнивает getID() с HD_RaidLocation,
  иначе clearTroops + ранний return — иначе гарнизон влезал в посторонние бои рядом как союзник,
  эксплоит; предрасчитанные hover-ом защитники снимались бы ванилью с onCombatLost). ЛОВУШКА
  скана клика: гвард isInCameraMovementMode() ПЕРЕД __original бесполезен — DragStyleScrolling
  вооружает его на нажатии и сбрасывает только в updateCamera внутри __original; правильный
  гвард — !m.WasInCameraMovementMode (как у ванильной клик-ветки). Штраф отношений за набег из
  Hardened (глобальный startCombat-хук "Attacked them") НЕ перенесён.
  ЛОВУШКА: у пристроек ваниль часто НЕТ ФРАКЦИИ (0) — settlement.addFaction (faction.nut:378)
  раздаёт её только уже существующим пристройкам; с фракцией 0 ваниль молча пропускает локацию
  в showCombatDialog/getLocalCombatProperties (getFaction() == 0 → continue) — никакого боя и
  тишины в логах. Лечение — HD_ensureRaidFaction() (settlement.getFaction()) из setSettlement-хука
  и onDeserialize-восстановлений. ЛОВУШКА 2: ваниль не вызывает onSpawned у пристроек;
  наш setSettlement вызывает его вручную — но setSettlement дергается и из onDeserialize, а
  onSpawned докидывает именной лут в m.Loot → накапливание лута в сейвах; стабилизация в
  onDeserialize (Loot.len() > 2 → clear + onSpawned). Баннер: ванильный IsShowingBanner=true
  у location НЕ трогаем (у Hardened был свой UI-редизайн баннеров)
- Тултипы контрактов (перенос из mod_reforged/hooks/contracts/contract.nut + связанного):
  тултип контракта на экране города (картинка сложности rf_image, «будет доступен ещё N
  дней», маршрут «Цель/В пути примерно/к …», оплата аванс/по завершении/за голову, ситуация
  поселения, предупреждение об активном контракте, ПКМ «Расторгнуть контракт») и вложенные
  ссылки на города/фракции в текстах сцен контракта (имена оборачиваются при построении
  текста сцены; JS-рендер — зависимость mod_nested_tooltips). Файлы: хук
  hooks/contracts/contract.nut (RF_getTooltip + обёртки setScreen/buildText/onPrepareVariables
  вокруг флага ::ReforgedLite.NestedTooltips), флаг/хелперы — tooltips/nested_helpers.nut,
  текстовые хелперы — text/text.nut (::ReforgedLite.Text), регистрация Contract.Tooltip /
  Faction+<ID> — tooltips/contracts.nut, обёртки getName — hooks/entity/world/world_entity.nut
  (+guard updateStrength), hooks/factions/faction.nut (RF_getTooltip фракции + getName +
  guard spawnEntity), attached_location getRealName; SQ-хук ПКМ — hooks/ui/screens/world/
  world_town_screen.nut; JS — js_hooks/screens/world/** (town screen), rf_image в
  js_hooks/screens/tooltip/modules/tooltip_module.js + css/tooltip_module.css; ассеты
  gfx/ui/icons/rf_difficulty_*_tooltip.png (из mod_reforged_assets-0.1.4).
  НЕ перенесено из референса: авто-переговоры/скип сцен, портрет заказчика в списке,
  last-visit система поселений (ситуация в тултипе ищется только в живых ситуациях:
  текущего города без Агента / всех городов с Агентом), EventActor/Skill/Item-ссылки
  в текстах сцен, Contract.FocusOnObjective (панель активного контракта на карте мира).
  ЛОВУШКА: contentType «settlement-status-effect» — НЕ бесполезный маркер: ванильный
  TooltipModule.buildFromData по нему вешает тултипу is-full-width is-status-effect-content
  (Reforged вставляет его первой записью тултипа контракта/фракции — копируем).
  ЛОВУШКА 2: не-ASCII внутри идентификатора вложенной ссылки (ExtraData после «+») —
  не использовать динамический Tooltip+ с русским текстом в таблице (как в оригинальном
  RF_getOfferedByText): идентификатор кодируется байтами, JS держит его как Latin-1,
  транспорт JS->SQ кодирует в UTF-8 повторно → в тултипе иероглифы. Ссылки на объекты
  с русскими именами — только ID на проводе + резолв имени на стороне SQ (тип WorldActor).
- НЕ переносится: система Reach (досягаемость), rf-перки без ванильных аналогов
  (menacing/wear_them_down у zombie_orc, sweeping_strikes у vampire_lord — завязаны на Reach),
  addPerkGroupOfEquippedWeapon, anatomist-зелья, легендарные сущности кроме перечисленных кризисных
- Ссылочные тултипы ванильных навыков (batch Reforged 0.9.3, ~125 хуков в tooltips/hooks/vanilla/**):
  только тултип-части хуков из mod_reforged/hooks/skills/**. Решение А/Б из NESTED_TOOLTIPS_TASK.md
  не выбрано — перенос «как в Reforged» (хуки getTooltip), см. правила ниже. Также: хук
  tooltips/hooks/vanilla/actor.nut getTooltip (вынесен из hooks/entity/tactical/actor.nut
  при разделении тултип/функционал) — имена эффектов в тактическом тултипе стали
  вложенными ссылками (Skill+filename, entityId актора; работает для скиллов любых модов);
  tooltips/hooks/vanilla/skill.nut (бывший hooks/skills/skill.nut) — late-хук
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
     Бакет `Late` есть только во фреймворке Reforged (`::Reforged.QueueBucket.Late`).
     ВНИМАНИЕ: Late у Reforged дрейнится В КОНЦЕ их load.nut (во время preload, ДО
     загрузки scripts/**), а MSU.AfterHooks дрейнится в бакете modern-hooks AfterHooks —
     ПОСЛЕ __finalizeHooks: хук оттуда на уже обработанный класс мёртв (см. таймлайн
     в разделе линкифайера — dummy-контейнер skill.nut так погиб). Для «финальных»
     обёрток регистрировать хук напрямую в load.nut: порядок RawHooks = порядок
     регистрации, mod_nested_tooltips грузится раньше, обёртка будет внешней.
   - `setTooltips` MSU НЕ мёржит существующие подтаблицы: `__addTable` рекурсирует только
     в НОВЫЕ ключи, существующий под-ключ заменяется целиком. Повторный setTooltips с
     `{Concept = ...}` стёр бы ручные концепты. Дополнять словарь — прямой записью:
     `::MSU.System.Tooltips.getTooltip(::ReforgedLite.ID, "Concept").Tooltip[ключ] <- тултип`
     (образец — конец tooltips/concepts.nut). ВАЖНО: инжектованный nested_tooltips getTooltip
     возвращает обёртку `{Tooltip, Data}`, а не таблицу концептов — без `.Tooltip` запись
     молча уйдёт вникуда (ошибки в логе не будет, ссылки просто не резолвятся).

## Тултип-хуки скиллов модов и ванили (линкифайер)

Движок: `tooltips/mod_skill_tooltips.nut` (::ReforgedLite.ModSkillTooltips), реестры:
`tooltips/hooks/<мод>/registry.nut`. Разделение тултип-хуков и функциональных хуков —
функциональные живут в `hooks/`, ванильный батч и реестры модов — в `tooltips/hooks/`.

Принцип: в отличие от ванильного батча (перенос готовых текстов Reforged) тексты чужих
модов НЕ дублируются — обёртка getTooltip прогоняет готовые записи через словарь терминов
(игровые термины/ванильные эффекты → [текст|Concept.X] / [текст|Skill+файл]) и parseString.
Тексты модов остаются единственным источником — правки текстовок в модах ссылки не ломают.

Правила расширения:
- Новый скилл мода — строка в реестр его мода (группировка комментариями: активные/
  эффекты/перки/расовые). Новый термин — в addTerms реестра (скоуп мода) или в базовый
  словарь движка (только общие игровые термины и ванильные эффекты).
- Скоупы: термины с `_scope` видны только скиллам своего мода (названия умений вроде
  «Гроза»/«Чума» не протекают в чужие тексты). Глобальные термины — Scope = null.
- Формы склонений добавлять ЯВНО: совпадение строго по границам слов (байт до/после —
  не буква/цифра; в Squirrel байты строк SIGNED — кириллица это _c < 0, см. isWordChar).
  «ход» не захватит «хода»; «отравлен» не захватит «отравленный», но и «отравлена» без
  отдельной формы НЕ сматчится (частичное совпадение отвергается).
- Реестры выполняются в include-файлах load.nut — движок подключён раньше; порядок
  между реестрами не гарантирован, взаимозависимостей нет.

ТАЙМЛАЙН ЗАГРУЗКИ (критично для регистрации хуков, проверено по коду modern hooks):
!mods_preload (моды регистрируются и queue-функции) → scripts/!mods_preload/~~modern_hooks.nut
выполняет ВСЕ очереди (__runQueue) → загрузка scripts/** (классы регистрируются, Prototype
выставляется дебаг-хуком по возврату main каждого файла) → scripts/~~modern_hooks.nut:
__finalizeHooks (листовые классы получают накопленные RawHooks) → бакет AfterHooks.
ЛОВУШКИ на этом таймлайне:
- Регистрация HooksMod.hook БЕЗУСЛОВНА: в момент выполнения очереди ни один класс scripts/**
  ещё не зарегистрирован — любая проверка «класс существует» (::Hooks.BBClass[src].Prototype)
  молча ложна и убивает ВСЕ хуки (так погиб ранний isClassRegistered — ссылки не появились
  ни в ванили, ни в модах). Мод не установлен → один warning на класс в логе на finalize —
  как у любого мода, это норма.
- ::MSU.QueueBucket.AfterHooks дрейнится в бакете modern-hooks AfterHooks, т.е. ПОСЛЕ
  __finalizeHooks: хук оттуда на уже обработанный (Processed = true) класс НИКОГДА не
  применяется (молчаливая мёртвая обёртка — так погиб dummy-контейнер в skill.nut батча,
  замечено при разборе этой регрессии). Регистрировать «финальные» обёртки нужно напрямую
  в load.nut: mod_nested_tooltips грузится раньше (алфавит), его RawHook на класс лежит
  глубже, наша обёртка применяется последней и остаётся внешней.

ЛОВУШКИ (проверено юнит-тестом на sq.exe):
- Уже закодированные ссылки ([ddd=ddd]текст[/ddd] от чужих хуков/батчей, например
  наследники ванильных активов из kriegsgeist ghost_skull) защищены: защищается и тег,
  и видимый текст до закрывающего тега — иначе ссылки вкладывались бы в ссылки.
- Двойная обработка наследников: хук на класс-наследник ванильного скилла срабатывает
  ПОСЛЕ хука родителя из ванильного батча — parseString идемпотентен к закодированным
  тегам, линкифайер не находит русских терминов внутри цифровых payload'ов.
- Заголовок (type "title" / id 1) не линкифицируется.
- В bb_vanilla_plus хукаются: перки из scripts/config/z_*.nut + ВСЕ player-facing активы
  и эффекты мода (семейства sb*/xxitem* — 27+163+22 = 212 классов; ai_*/cp_* — ИИ/компаньоны,
  не трогаем). Скоуп-словарь: магические умения, погодный навык, ванильные умения в текстах
  bb_vp ('Стена щитов', 'Стена копий', 'Контратака' → ванильные файлы), связи перков
  ('Мастерство маны' → perk_vp_xxp26). «Шок» из текста электрошока ссылкой НЕ является —
  отдельного файла нет, это название ванильного оглушения (скилл кладёт stunned_effect).
  ТЕКСТЫ МОДА нормализованы под единый вид цитирования (8 файлов: z_electro + sb_pull,
  sb_pull2, sb_gale, sb_flingback, sb_linebreaker, sb_taichi, sbp_spear — упоминания
  стен/контратаки приведены к 'Стена щитов', 'Стена копий', 'Контратака' в стиле ванили;
  экранирование в файлах РАЗНОЕ — \\' и \' встречаются оба варианта, править точечно).
  ЛОВУШКА хвостов: bb_vp-перки «Мастерство маны»/«Боевой транс» существуют в НЕСКОЛЬКИХ
  деревьях с разными Script — термин ведёт на представителя (perk_vp_xxp26).
- ВАНИЛЬ под линкифайером: tooltips/hooks/vanilla/registry.nut — 327 классов перков/черт/
  эффектов/расовых/активов, НЕ вошедших в батч Reforged (список сгенерирован из data_014, минус
  классы батча; перегенерировать при обновлении игры), + скоуп-словарь из ~33 имён умений,
  упоминаемых по имени в текстах ванили ('Контратака', 'Стена щитов', 'Выпад'… → Skill+файл;
  аудит по config/strings.nut + skills/**). Коллизии имён у ванили: «Отбрасывание»
  (knock_back/fling_back → выбран knock_back), «Размах» (swing/ghost_swing → swing из текста
  мастера меча); «Оглушение»/«Выбит дух»/«Пойман в сеть» сознательно НЕ дублируются —
  базовый словарь уже ведёт их на эффекты (иначе двойной матч на одной позиции).
- БАТЧ-ОВЕРЛЕЙ: классы батча Reforged перестраивают getTooltip и не входят в registry.nut, но
  базовый словарь должен работать в их текстах однотипно (строка стоимости 'ОД/выносливости').
  batch_overlay.nut (128 классов — файлы батча) подключается в load.nut ЯВНО после
  includeFiles(tooltips/hooks): порядок include = порядок RawHooks, обёртка линкифайера
  ВНЕШНЯЯ — батч отдаёт tooltip со своими ссылками, поверх линкификация (чужие теги защищены).
  ЛОВУШКА: порядок файлов в enumerateFiles НЕ гарантирован — оверлей только через явный include.
- AC_2 (Animal Companions): квирки зверя зарегистрированы (scripts/companions/quirks/*), НО
  список «Черты, которыми он обладает» строится в ПАТЧЕ МОДА: mod_AC.nut (хук items/misc/
  wardog_heavy_armor_upgrade_item, ~стр. 1386) собирает quirkString плоским текстом через
  legacy mods_hookNewObject — классовый хук его не перехватит (инстанс-обёртка тенит прототип).
  Патч: имена квирков оборачиваются в getNestedSkillName+parseString под гардом
  ("ReforgedLite" in getroottable()) — AC остаётся работоспособным без lite. AC сам отключает
  свой tooltip-JS при установленном mod_nested_tooltips, рендер стандартный — ссылки живут.
  ЛОВУШКА: тултип перка на экране
  персонажа ваниль строит из perk-def (tooltip_events.general_queryUIPerkTooltipData →
  perk.Tooltip), минуя getTooltip класса, — поэтому есть обёртка general_queryUIPerkTooltipData
  в hooks/ui/screens/tooltip/tooltip_events.nut мода. Скоуп разрешается по perk.Script через
  реестр ClassScopes движка (addSkill запоминает script→scope): скоупные термины мода работают
  в тултипах его перков, ванильные перки получают скоуп "vanilla", незнакомый Script — только
  глобальный словарь.
- ИНДЕКС nested tooltips: Skill+X резолвится через SkillObjectsByFilename, который
  mod_nested_tooltips строит ТОЛЬКО по scripts/skills (и items). Классы ВНЕ этого дерева
  (квирки/активы AC в scripts/companions/**) не резолвятся — в логе «Key 'companions_X' not
  found, getObjFromFilename» и тултип по ссылке не открывается. addSkill автоматически
  добавляет такие классы в индекс (basename -> script path, ленивый ::new по первому клику;
  при коллизии имён существующая запись в приоритете). Проверка `_src.find("scripts/skills/")`.
- ЭКРАНИРОВАНИЕ КАВЫЧЕК В .nut: `\'` в файле → `'` в игре; `\\'` в файле → БАКСЛЕШ В ИГРЕ
  (literal \'). bb_vp пишет ОБА стиля (даже в соседних файлах) — при правках цитирования
  копировать стиль КОНКРЕТНОГО файла, иначе в игре видны \' (урок: нормализация текстов
  bb_vp первым заходом вставила \\' во все файлы подряд — пользователь увидел мусор).
  Также активы AC из scripts/companions/onequip + companions/skills зарегистрированы
  (ссылочная стоимость ОД/выносливости у способностей питомцев).
- ГРАНИЦЫ СЛОВ (isWordCharBefore/After): байты строк в Squirrel SIGNED. Хвосты многобайтовых
  символов (0x80–0xBF → отрицательные) — это и буквы кириллицы, И знаки «»—… — различать
  по лид-байту: кириллица D0–D3 = signed −48…−45 (сравнивать с -0x30…-0x2D, НЕ с 0xD0!).
  Проверка ДО термина: последний байт предыдущего символа + его лид; ПОСЛЕ: первый байт
  следующего (лид D0–D3 → буква). Урок найден на «ёлочках»: «Решимость» не линковалась.
- Ссылки рендерятся только через стандартный tooltip-модуль mod_nested_tooltips (тактика,
  экран персонажа, панель зверя AC); журнал боя/плавающие тексты/сцены событий — нет.

## Правила работы

- Жёсткое правило API монорепозитория (см. корневой `../AGENTS.md`) действует в полной мере.
- Отладка «не работает в игре» — СНАЧАЛА факты, потом теории: (1) сверить задеплоенный
  артефакт (`unzip -l` по zip в data + время сборки), НЕ утверждать «сборка старая» без
  проверки; (2) лог игры (`log.html`) — warning'и modern hooks/MSU; (3) таймлайн загрузки
  и порядок регистрации хуков по коду загрузчика. Урок: целая сессия ушла в ложный путь
  «у вас старая сборка», пока причиной оказался собственный гард isClassRegistered.
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
