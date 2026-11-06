#!/usr/bin/env bash
# Общий сборщик модов монорепозитория с пересборкой отредактированных спрайтов.
# Использование: build_brushes.sh <имя.zip> [каталог мода]
#   <имя.zip>      — имя итогового архива в data игры (обязательный)
#   [каталог мода] — корень мода; по умолчанию текущий каталог
# Алгоритм:
#   1. Для каждого <name>.brush из <мод>/brushes ищем одноимённый каталог
#      в <bbros>/bin (каталог с metadata.xml = спрайты правились в редакторе);
#   2. По каждому совпадению запускаем bbrusher.exe pack:
#        bbrusher.exe pack <bbros>/bin/<name>.brush <bbros>/bin/<name>
#      (без --gfxPath! brush хранит путь "gfx/<name>.png", bbrusher резолвит его
#       относительно родителя каталога с brush = <bbros>, итог: <bbros>/gfx/<name>.png.
#       Если передать --gfxPath <bbros>/gfx, png улетит в <bbros>/gfx/gfx/ — молча);
#   3. <name>.brush копируем с заменой в <мод>/brushes, <name>.png — в <мод>/gfx;
#   4. Обычная сборка мода через build.sh.
# Каталог bbros можно переопределить через BB_BROS.
# ВНИМАНИЕ: игра не должна быть запущена. Автоматический запуск ЗАПРЕЩЁН.
set -euo pipefail

if [ $# -lt 1 ]; then
    echo "ОШИБКА: не задано имя архива. Использование: build_brushes.sh <имя.zip> [каталог мода]" >&2
    exit 1
fi

OUT_NAME="$1"
ROOT="${2:-.}"
# нормализация: build.bat передаёт %~dp0. (Windows-путь с трейлинг-\. и обратными слэшами)
ROOT="${ROOT%/.}"
ROOT="${ROOT%\\.}"
ROOT="${ROOT%/}"
case "$ROOT" in
    [A-Za-z]:*) ROOT=$(cygpath -u "$ROOT") ;;
esac
ROOT="$(cd "$ROOT" && pwd)"

BBROS="${BB_BROS:-/z/GameMods/Battle Brothers/mods/bbros}"
BBROS="${BBROS%/.}"
BBROS="${BBROS%/}"
case "$BBROS" in
    [A-Za-z]:*) BBROS=$(cygpath -u "$BBROS") ;;
esac

BBRUSHER="$BBROS/bin/bbrusher.exe"
if [ ! -f "$BBRUSHER" ]; then
    echo "ОШИБКА: bbrusher не найден: $BBRUSHER" >&2
    exit 1
fi

if [ -d "$ROOT/brushes" ]; then
    for brush in "$ROOT/brushes"/*.brush; do
        [ -e "$brush" ] || continue
        name="$(basename "$brush" .brush)"
        SRC_DIR="$BBROS/bin/$name"
        if [ ! -d "$SRC_DIR" ]; then
            echo "-- $name: каталог $SRC_DIR не найден, пересборка не нужна"
            continue
        fi
        echo "==> Сборка спрайтов: $name"
        "$BBRUSHER" pack \
            "$(cygpath -w "$BBROS/bin/$name.brush")" \
            "$(cygpath -w "$SRC_DIR")"
        if [ ! -f "$BBROS/gfx/$name.png" ]; then
            echo "ОШИБКА: спрайт-лист не создан: $BBROS/gfx/$name.png" >&2
            exit 1
        fi
        cp -f "$BBROS/bin/$name.brush" "$ROOT/brushes/"
        mkdir -p "$ROOT/gfx"
        cp -f "$BBROS/gfx/$name.png" "$ROOT/gfx/"
        echo "    brush + png -> $ROOT (обновлено)"
    done
else
    echo "-- каталог brushes отсутствует в $ROOT, пересборка спрайтов пропущена"
fi

exec "$(dirname "$0")/build.sh" "$OUT_NAME" "$ROOT"
