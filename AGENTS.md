# Monorepo: проекты модов Battle Brothers

Репозиторий объединяет все свои моды. Рабочий каталог сессии = корень репозитория.
Все общие правила — здесь; профиль конкретного мода (зависимости, ТЗ) — в `AGENTS.md`/`TZ.md` самого мода.

## Реестр модов (каталог → zip в data)

| Каталог | Zip в data | Профиль |
|---|---|---|
| `bb_vanilla_plus/` | `mod_vanilla_plus.zip` | Основной контент-мод. Деревья перков магов (piro/crio/electro/shaman/demon/vestal), предыстории, интеграция с AC |
| `mod_horde_invasion/` | `mod_horde_invasion.zip` | Кризис «Нашествие Жёлёной Орды». ТЗ: `mod_horde_invasion/TZ.md`. Депендсы: mod_Jurchen + mod_Scourge_of_God |
| `mod_Scourge_of_God/` | `mod_Scourge_of_God.zip` | Фракция Mgl («Скверна Бога»). Юниты, курган хана, named-предметы |
| `mod_Jurchen/` | `mod_Jurchen.zip` | Фракция чучженей. Юниты, лагерные шаблоны, named-оружие, бочки пороха |
| `AC_2-russian/` | `AC_2-russian.zip` | Animal Companions (рус.). Типы компаньонов 20–26 — существа bb_vanilla_plus |
| `mod_necro-russian/`, `mod_Retired_Gladiator-russian/` и пр. | по имени каталога | Русификации/мелкие моды, адаптируются под задачи |

Сторонние зависимости-референсы (НЕ коммитить сюда): ваниль `Z:\GameMods\Battle Brothers\mods\!project\data_014`,
davkul_rising (`!project/zmod_davkul_rising-russian`).

## Жёсткое правило API

**Запрещено выдумывать функции, константы и сигнатуры.** Каждое использование незнакомого метода/константы
сначала проверяется по источникам: распакованная ваниль `Z:\GameMods\Battle Brothers\mods\!project\data_014`
(grep по определениям) либо данный пользователем референс. Если подтвердить нельзя — не использовать,
а спросить или перестроить решение на проверенном API. Проверенные ловушки (полный список — в
`docs/locations/tactical_location_guide.md`): `Const.EntityType.Donkey` не существует (есть `CaravanDonkey`);
у тайла нет `hasObject()`; скилловый `onDamageReceived(_attacker, _damageHitpoints, _damageArmor)` ничего
не возвращает; у `CombatInfo` обязателен `TerrainTemplate`; `fillVisibility(Player, true)` — отключение
тумана войны; `Navigator().teleport()` в фазе развёртывания — мёртвая блокировка (игрока расставлять
`addEntityToMap`, паттерн tutorial_contract).

## Тексты (предыстории, события, контракты, кризисы)

- Генерация: `docs/texts/text_generation.md`, `docs/backstories/backgrounds_generation.md` (предыстории),
  `docs/backstories/backgrounds_rules_south.md` (юг), концовки — `docs/backstories/backgrounds_endings.md`
- Проверка — ОТДЕЛЬНЫМ проходом: `docs/texts/text_validation.md`, `docs/backstories/backgrounds_validation.md`
  (формат результата: [OK]/[FAIL] + вердикт)
- Легендарные события — один вариант текста, вариативность не нужна

## Локации и скриптованные бои

- Гайд: `docs/locations/tactical_location_guide.md`; чек-лист перед игровым тестом: `docs/locations/tactical_location_checklist.md`
- Ключевое: стены красит только TerrainTemplate (патч — только `Type == 0`); событийному бою нужен
  `IsWithoutAmbience`; объекты ставить в callback'и, не в `fill` (campify зачистит)

## Иконки

- Подложки: `Z:\GameMods\Battle Brothers\mods\perk.png` (перки), `...\background.png` (бэкграунды);
  генератор — `tools/make_icons.py` (нужен Pillow, venv поднимать самостоятельно)

## Сборка

- У каждого мода свой `build.sh` + `build.bat` (имя zip — см. реестр выше). ЗАПРЕЩЕНО запускать сборку
  автоматически — только по явной просьбе пользователя, при закрытой игре (иначе «Corrupted archive»).
- Скрипты упаковывают существующие игровые папки мода (brushes/gfx/music/scripts/sounds/ui + каталог хуков mod_*/zmod_*)
  и кладут zip с заменой в `Z:\SteamLibrary\steamapps\common\Battle Brothers\data`.

## Соглашения по коду и гиту

- Формат/стиль — как в соседних файлах мода-референса. Минимальные изменения.
- Запрещено менять порядок существующих записей в реестрах-конфигах (сейвы) — новое в конец.
- После правок .nut — чекер баланса скобок/строк (см. `tools/`).
- Ассеты (*.png, *.ogg, *.wav, *.brush) в гит не коммитятся (см. .gitignore) — они локальные;
  `.brush` — текстовые описатели спрайтов, при необходимости переносимых на другую машину стоит рассмотреть коммит.
- git-мутации (commit/push) — только по явной просьбе.
