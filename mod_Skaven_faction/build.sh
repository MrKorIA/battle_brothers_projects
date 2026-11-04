#!/usr/bin/env bash
# Сборщик мода mod_Skaven_faction
# Упаковывает папки мода в mod_Skaven_faction.zip и кладёт с заменой в data игры.
# ВНИМАНИЕ: игра не должна быть запущена. Автоматический запуск ЗАПРЕЩЁН.
set -euo pipefail

ROOT="$(cd "$(dirname "${{BASH_SOURCE[0]}}")" && pwd)"
DATA="/z/SteamLibrary/steamapps/common/Battle Brothers/data"
OUT_NAME="mod_Skaven_faction.zip"
BUILD_DIR="$ROOT/.build"
TMPZIP="$BUILD_DIR/$OUT_NAME"

cd "$ROOT"

FOLDERS=()
for d in brushes gfx music scripts sounds ui; do
    [ -d "$d" ] && FOLDERS+=("$d")
done
# каталог хуков мода (mod_*/zmod_*)
for d in mod_* zmod_*; do
    [ -d "$d" ] && FOLDERS+=("$d")
done

if [ ${{#FOLDERS[@]}} -eq 0 ]; then
    echo "ОШИБКА: не найдено ни одной папки мода в $ROOT" >&2
    exit 1
fi
if [ ! -d "$DATA" ]; then
    echo "ОШИБКА: каталог игры не найден: $DATA" >&2
    exit 1
fi

mkdir -p "$BUILD_DIR"
rm -f "$TMPZIP"

TMPWIN=$(cygpath -w "$TMPZIP")
FOLDERS_PS=""
for f in "${{FOLDERS[@]}}"; do FOLDERS_PS+="'$f',"; done
FOLDERS_PS=${{FOLDERS_PS%,}}
echo "==> Упаковка: ${{FOLDERS[*]}} -> $OUT_NAME"
powershell.exe -NoProfile -Command     "Compress-Archive -Path $FOLDERS_PS -DestinationPath '$TMPWIN' -CompressionLevel Optimal -Force"

if [ ! -f "$TMPZIP" ]; then
    echo "ОШИБКА: архив не создан" >&2
    exit 1
fi

echo "==> Копирование в $DATA (с заменой)"
cp -f "$TMPZIP" "$DATA/$OUT_NAME"

SIZE=$(du -h "$TMPZIP" | cut -f1)
rm -rf "$BUILD_DIR"
echo "ГОТОВО: $DATA/$OUT_NAME ($SIZE)"
