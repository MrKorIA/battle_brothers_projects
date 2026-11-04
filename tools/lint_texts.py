#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
lint_texts.py — технический линт русских текстов bb_vanilla_plus.

Прогоняет детерминированные проверки из docs/texts/text_generation.md /
docs/texts/text_validation.md (технический контроль) по всем строковым
литералам Squirrel (.nut), похожим на игровой текст.

Использование:
    python tools/lint_texts.py [пути...]      (по умолчанию scripts/)

Статусы:
    ERR  — жёсткая ошибка (парность скобок/тегов, экранирование, грамматика «вы доволен»)
    WARN — эвристика на ручную проверку (ё, «что бы», повторы, плотность «вы» и т.п.)

Код возврата: 0 — ошибок нет (WARN допустимы), 1 — есть ERR.
Литературная вычитка этим скриптом НЕ заменяется — см. docs/texts/text_validation.md.
"""

import os
import re
import sys

if sys.stdout.encoding and sys.stdout.encoding.lower() != "utf-8":
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")

CYR = re.compile(r"[А-Яа-яЁё]")

# ---------------------------------------------------------------------------
# Словари и паттерны проверок
# ---------------------------------------------------------------------------

# Слова, где «ё» обязательна (проверка восстановления буквы ё).
# Эвристика: покрывает только ходовые формы, не заменяет чтение текста.
# Формы, где письменно без ударения обязательна «ё». Только формы с реальной «ё».
YO_WORDS = {
    "еще": "ещё", "Еще": "Ещё",
    "мое": "моё", "Мое": "Моё",
    "твое": "твоё", "Твое": "Твоё",
    "свое": "своё", "Свое": "Своё",
    "нее": "неё",
    "еду": "ёду", "едем": "ёдем",
    "ехал": "ёхал", "ехала": "ёхала", "ехали": "ёхали",
    "идет": "идёт", "идем": "идём",
    "шел": "шёл",
    "пришел": "пришёл",
    "ушел": "ушёл",
    "пошел": "пошёл",
    "вошел": "вошёл", "вышел": "вышёл",
    "нашел": "нашёл",
    "лег": "лёг",
    "умрет": "умрёт", "умрут": "умрут",
    "сожрет": "сожрёт", "сожрут": "сожрут",
    "берет": "берёт",
    "вернет": "вернёт",
    "жмет": "жмёт",
    "ждет": "ждёт",
    "пьет": "пьёт", "льет": "льёт", "бьет": "бьёт",
    "течет": "течёт",
    "споет": "споёт",
}

# Вежливое «вы» к одному лицу + краткая форма ед.ч. — грамматическая ошибка.
# Граница слова справа исключает «вы готовите», «вы правы» (мн.ч.) и т.п.
VY_SHORT_ADJ = re.compile(
    r"\bвы (" + "|".join([
        "доволен", "довольна",
        "готов", "готова",
        "уверен", "уверена",
        "согласен", "согласна",
        "обязан", "обязана",
        "вынужден", "вынуждена",
        "намерен", "намерена",
        "знаком", "знакома",
        "близок", "близка",
        "должен", "должна",
        "болен", "больна",
        "способен", "способна",
        "желанен",
        "рад", "рада", "рады",
    ]) + r")\b",
    re.IGNORECASE,
)

VY_LEXEMA = re.compile(r"\b(вы|вас|вам|вами)\b", re.IGNORECASE)

# Предлог + переменная подстановки — кандидат на косвенный падеж.
# %direction% — дативная константа (разрешена), %reward% — сумма с валютой.
PREP_VAR = re.compile(
    r"\b(из|у|от|до|с|со|к|ко|над|под|перед|за|для|о|об|во|на|при|про|через|между|вокруг|ради|вместо)\s+%([A-Za-z]+)%(?![а-яё])"
)

PREP_VAR_OK = {"direction", "reward"}

# Стоп-слова для эвристики повторов (местоимения, союзы, общеупотребительное).
STOPWORDS = {
    "который", "которая", "которое", "которые", "которого", "которой",
    "чтобы", "потому", "ничего", "никто", "никого", "снова", "самый",
    "самая", "самое", "сами", "время", "дело", "вдруг", "очень", "весь",
    "вся", "всё", "все", "уже", "только", "можно", "нельзя", "почти",
    "слишком", "кажется", "здесь", "там", "куда", "откуда",
    "поэтому", "однако", "сейчас", "теперь", "тогда", "всегда", "никогда",
    "либо", "когда", "после", "перед", "ради", "через", "иногда",
    "вокруг", "потом", "также", "вместе", "один", "одна", "одно",
    "кроме", "между", "вновь", "впервые", "нужен", "нужна", "нужно", "нужны",
}

WORD = re.compile(r"[А-Яа-яЁё]{4,}")


def is_text_like(s):
    """Отбирает строки, похожие на игровой текст (отсеивает пути, ID, код)."""
    if not CYR.search(s):
        return False
    if "[img]" in s or "%SPEECH_ON%" in s:
        return True
    if "{" in s and "|" in s:
        return True
    if len(s) > 200:
        return True
    return False


def extract_strings(path):
    """Извлекает строковые литералы Squirrel с учётом экранирования и комментариев."""
    results = []  # (lineno, content, had_bare_quote)
    try:
        with open(path, "r", encoding="utf-8") as f:
            src = f.read()
    except (OSError, UnicodeDecodeError):
        return results

    i, n = 0, len(src)
    line = 1
    while i < n:
        c = src[i]
        if c == "\n":
            line += 1
            i += 1
            continue
        # комментарии
        if c == "/" and i + 1 < n and src[i + 1] == "/":
            while i < n and src[i] != "\n":
                i += 1
            continue
        if c == "/" and i + 1 < n and src[i + 1] == "*":
            i += 2
            while i + 1 < n and not (src[i] == "*" and src[i + 1] == "/"):
                if src[i] == "\n":
                    line += 1
                i += 1
            i += 2
            continue
        # строковые литералы ("..." и '...')
        if c == '"' or c == "'":
            quote = c
            start_line = line
            i += 1
            buf = []
            bare_quote = False
            while i < n:
                ch = src[i]
                if ch == "\n":
                    line += 1
                    break  # незакрытый литерал — синтаксическая ошибка .nut, не наша забота
                if ch == "\\" and i + 1 < n:
                    nxt = src[i + 1]
                    if nxt == "'":
                        buf.append("\\'")  # экранированная кавычка — оставляем как есть
                    else:
                        buf.append("\\" + nxt)
                    i += 2
                    continue
                if ch == quote:
                    i += 1
                    break
                if ch == "'":
                    bare_quote = True  # неэкранированная кавычка внутри строки
                buf.append(ch)
                i += 1
            content = "".join(buf)
            if is_text_like(content):
                results.append((start_line, content, bare_quote))
            continue
        i += 1
    return results


def sentences(text):
    """Грубое разбиение на предложения для эвристик плотности и повторов."""
    parts = re.split(r"(?<=[.!?…])\s+", text.replace("\\n", " "))
    return [p.strip() for p in parts if p.strip()]


def lint_string(content):
    """Возвращает список (severity, check_id, message, pos)."""
    findings = []

    def add(sev, cid, msg, pos=0):
        findings.append((sev, cid, msg, pos))

    # --- ERR: парность тегов и скобок ---
    o, c = content.count("[img]"), content.count("[/img]")
    if o != c:
        add("ERR", "IMG_PAIR", "[img] без пары [/img]: %d vs %d" % (o, c))
    o, c = content.count("{"), content.count("}")
    if o != c:
        add("ERR", "BRACE_PAIR", "непарные {}: %d vs %d" % (o, c))

    # --- ERR: пробелы у границ прямой речи ---
    # Пробел перед разделителем варианта «|» или скобкой «}» безвреден (так делает
    # и ваниль) — флагаем только пробел непосредственно перед текстом/после текста.
    for m in re.finditer(r"%SPEECH_OFF%[ \t]+(?=[А-Яа-яЁё])", content):
        add("ERR", "SPEECH_SPACE", "пробел сразу после %SPEECH_OFF% перед текстом", m.start())
    for m in re.finditer(r"(?<=[А-Яа-яЁё])[ \t]+%SPEECH_ON%", content):
        add("ERR", "SPEECH_SPACE", "пробел перед %SPEECH_ON% после текста", m.start())

    # --- ERR: экранирование одинарных кавычек ---
    for m in re.finditer(r"(?<!\\)'", content):
        add("ERR", "QUOTE_ESC", "неэкранированная кавычка ' (нужно \\')", m.start())

    # --- ERR: «вы» + краткое прилагательное ед.ч. ---
    for m in VY_SHORT_ADJ.finditer(content):
        add("ERR", "VY_SG", "вежливое «вы» + ед.ч.: «%s» → мн.ч." % m.group(0), m.start())

    # --- WARN: « - » вместо тире ---
    for m in re.finditer(r"\s-\s", content):
        add("WARN", "DASH", "« - » вместо тире «—»", m.start())

    # --- WARN: «что бы» (кроме «что бы ... ни») ---
    for m in re.finditer(r"\bчто бы\b(?=( [а-яё]+){0,2} ни\b)?", content, re.IGNORECASE):
        tail = content[m.end():m.end() + 20]
        if not re.match(r"( [а-яё]+){0,2} ни\b", tail):
            add("WARN", "CHTO_BY", "«что бы» вместо «чтобы»", m.start())

    # --- WARN: буква ё ---
    for w, fixed in YO_WORDS.items():
        for m in re.finditer(r"\b%s\b" % re.escape(w), content, re.IGNORECASE):
            add("WARN", "YO", "«%s» → «%s»" % (m.group(0), fixed), m.start())

    # --- WARN: предлог + переменная (косвенный падеж) ---
    for m in PREP_VAR.finditer(content):
        if m.group(2).lower() in PREP_VAR_OK:
            continue
        add("WARN", "PREP_VAR",
            "предлог + %%%s%% — проверить падеж подстановки" % m.group(2), m.start())

    # Эвристики плотности и повторов считаются внутри одного варианта —
    # разные варианты через | не читаются подряд.
    for variant in content.split("|"):
        # --- WARN: плотность «вы» в предложении ---
        for s in sentences(variant):
            n_vy = len(VY_LEXEMA.findall(s))
            if n_vy >= 3:
                add("WARN", "VY_DENSE", "3+ «вы»-лексемы в одном предложении (%d)" % n_vy)

        # --- WARN: повтор слова в предложении ---
        for s in sentences(variant):
            seen = {}
            for m in WORD.finditer(s.lower()):
                w = m.group(0)
                if w in STOPWORDS:
                    continue
                seen[w] = seen.get(w, 0) + 1
            for w, cnt in seen.items():
                if cnt >= 2:
                    add("WARN", "WORD_REPEAT", "повтор «%s» в предложении (%d×)" % (w, cnt))

    # --- WARN: смешение \n и \n\n (только в текстах с вариантами {}) ---
    if "{" in content:
        stripped = content.replace("\\n\\n", "")
        if "\\n" in stripped:
            add("WARN", "PARA_MIX", "смешены \\n и \\n\\n внутри одного текста")

    # --- WARN: двойные пробелы ---
    for m in re.finditer(r"[^\s\\]  +[^\s]", content):
        add("WARN", "DBL_SPACE", "двойной пробел", m.start())

    return findings


def excerpt(content, pos, width=50):
    a = max(0, pos - width)
    b = min(len(content), pos + width)
    frag = content[a:b].replace("\n", " ").replace("\\n", "¶")
    return ("..." if a > 0 else "") + frag + ("..." if b < len(content) else "")


def main():
    roots = sys.argv[1:] or ["scripts"]
    total_err = total_warn = 0
    for root in roots:
        files = [root] if os.path.isfile(root) else []
        if os.path.isdir(root):
            for dirpath, _, names in os.walk(root):
                files.extend(os.path.join(dirpath, x) for x in names if x.endswith(".nut"))
        for path in sorted(files):
            for lineno, content, _ in extract_strings(path):
                for sev, cid, msg, pos in lint_string(content):
                    mark = "ERR " if sev == "ERR" else "WARN"
                    print("%s %s:%d [%s] %s || %s" % (mark, path, lineno, cid, msg, excerpt(content, pos)))
                    if sev == "ERR":
                        total_err += 1
                    else:
                        total_warn += 1
    print("---\nИтого: %d ERR, %d WARN" % (total_err, total_warn))
    sys.exit(1 if total_err else 0)


if __name__ == "__main__":
    main()
