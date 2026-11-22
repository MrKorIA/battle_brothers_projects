// Общий движок тултип-хуков скиллов ДРУГИХ модов (вложенные ссылки без дублирования текстов).
// Реестры: mod_reforged_lite/tooltips/hooks/<мод>/registry.nut.
//
// Принцип: тексты исходных модов не трогаем и не дублируем. Оборачиваем getTooltip классов
// из реестра; после оригинала прогоняем текстовые записи через словарь терминов
// (игровые термины → [текст|Concept.X], упоминания скиллов/эффектов → [текст|Skill+файл])
// и ::ReforgedLite.Mod.Tooltips.parseString. Разметка накладывается поверх результата
// оригинального getTooltip, поэтому правки текстов в модах не ломают ссылки.
//
// Словари бывают глобальные (Scope = null — игровые термины, для всех зарегистрированных
// модов) и мод-специфичные (Scope = ключ мода из registry-файла — термины не протекают
// в другие моды: название «Гроза» из bb_vanilla_plus не станет ссылкой в чужих текстах).
//
// ЛОВУШКИ:
// - совпадение только по границам слов (байт до/после термина — не буква/цифра), чтобы «яд»
//   не цеплял «ядовитый», а «отравлен» — «отравления» (формы склонений добавляем явно);
// - длинные термины побеждают короткие с той же позиции («проверка боевого духа» vs «боевой дух»);
// - участки с уже закодированными вложенными тегами ([ddd=ddd]...[/ddd] из чужих хуков/батчей)
//   защищены от повторной обработки (иначе ссылки вкладывались бы в ссылки);
// - регистрация БЕЗ проверок: очереди модов выполняются в !mods_preload (scripts/!mods_preload/
//   ~~modern_hooks.nut → __runQueue), т.е. ДО загрузки scripts/**; Prototype классов выставляется
//   дебаг-хуком при загрузке файлов. Проверки «класс зарегистрирован» на этом этапе всегда
//   ложны — ранний вариант с isClassRegistered (::Hooks.BBClass[src].Prototype) молча
//   пропускал ВСЕ хуки. Хук безусловно кладётся в RawHooks и применяется леново: листовые
//   классы — в __finalizeHooks, остальные — при inherit. Мод не установлен → warning в логе
//   на finalize (как у любого мода), функционал не страдает.

::ReforgedLite.ModSkillTooltips <- {
	Terms = [], // { Term, Link, Scope = null|<ключ мода> } — отсортирован по убыванию длины термина

	function addTerms( _terms, _scope = null )
	{
		foreach (t in _terms)
		{
			this.Terms.push({ Term = t.Term, Link = t.Link, Len = t.Term.len(), Scope = _scope });
		}
		this.sortByLengthDescending(this.Terms);
	}

	// Базовый словарь: игровые термины и частые ванильные эффекты в текстах модов.
	// Формы склонений добавлять явно — по границам слов «ход» НЕ захватит «хода».
	function create()
	{
		this.addTerms([
			// Игровые термины (Concept — словарь concepts.nut + автоконцепты character-stats.*)
			{ Term = "очков действия", Link = "Concept.ActionPoints" },
			{ Term = "очки действия", Link = "Concept.ActionPoints" },
			{ Term = "ОД", Link = "Concept.ActionPoints" },
			{ Term = "ОЗ", Link = "Concept.Hitpoints" },
			{ Term = "здоровья", Link = "Concept.Hitpoints" },
			{ Term = "здоровье", Link = "Concept.Hitpoints" },
			{ Term = "здоровью", Link = "Concept.Hitpoints" },
			{ Term = "выносливости", Link = "Concept.Fatigue" },
			{ Term = "выносливость", Link = "Concept.Fatigue" },
			{ Term = "усталости", Link = "Concept.Fatigue" },
			{ Term = "усталость", Link = "Concept.Fatigue" },
			{ Term = "максимальной выносливости", Link = "Concept.MaximumFatigue" },
			{ Term = "максимальная выносливость", Link = "Concept.MaximumFatigue" },
			{ Term = "максимальной усталости", Link = "Concept.MaximumFatigue" },
			{ Term = "максимальная усталость", Link = "Concept.MaximumFatigue" },
			{ Term = "решимости", Link = "Concept.Bravery" },
			{ Term = "решимость", Link = "Concept.Bravery" },
			{ Term = "инициативы", Link = "Concept.Initiative" },
			{ Term = "инициатива", Link = "Concept.Initiative" },
			{ Term = "инициативе", Link = "Concept.Initiative" },
			{ Term = "инициативу", Link = "Concept.Initiative" },
			{ Term = "зоне контроля", Link = "Concept.ZoneOfControl" },
			{ Term = "зону контроля", Link = "Concept.ZoneOfControl" },
			{ Term = "зоны контроля", Link = "Concept.ZoneOfControl" },
			{ Term = "зона контроля", Link = "Concept.ZoneOfControl" },
			{ Term = "проверки боевого духа", Link = "Concept.MoraleCheck" },
			{ Term = "проверка боевого духа", Link = "Concept.MoraleCheck" },
			{ Term = "проверку боевого духа", Link = "Concept.MoraleCheck" },
			{ Term = "проверке боевого духа", Link = "Concept.MoraleCheck" },
			{ Term = "боевого духа", Link = "Concept.Morale" },
			{ Term = "Боевого духа", Link = "Concept.Morale" },
			{ Term = "боевой дух", Link = "Concept.Morale" },
			{ Term = "Боевой дух", Link = "Concept.Morale" },
			{ Term = "навыка ближнего боя", Link = "Concept.MeleeSkill" },
			{ Term = "навык ближнего боя", Link = "Concept.MeleeSkill" },
			{ Term = "навыку ближнего боя", Link = "Concept.MeleeSkill" },
			{ Term = "навыкам ближнего боя", Link = "Concept.MeleeSkill" },
			{ Term = "защиты в ближнем бою", Link = "Concept.MeleeDefense" },
			{ Term = "защита в ближнем бою", Link = "Concept.MeleeDefense" },
			{ Term = "защите в ближнем бою", Link = "Concept.MeleeDefense" },
			{ Term = "защите от ближнего боя", Link = "Concept.MeleeDefense" },
			{ Term = "защита от ближнего боя", Link = "Concept.MeleeDefense" },
			{ Term = "навыка дальнего боя", Link = "Concept.RangeSkill" },
			{ Term = "навык дальнего боя", Link = "Concept.RangeSkill" },
			{ Term = "навыку дальнего боя", Link = "Concept.RangeSkill" },
			{ Term = "навыкам дальнего боя", Link = "Concept.RangeSkill" },
			{ Term = "защиты в дальнем бою", Link = "Concept.RangeDefense" },
			{ Term = "защита в дальнем бою", Link = "Concept.RangeDefense" },
			{ Term = "защите в дальнем бою", Link = "Concept.RangeDefense" },
			{ Term = "защите от дальнего боя", Link = "Concept.RangeDefense" },
			{ Term = "защита от дальнего боя", Link = "Concept.RangeDefense" },
			{ Term = "хода боя", Link = "Concept.Round" },
			{ Term = "ход боя", Link = "Concept.Round" },
			{ Term = "каждого хода", Link = "Concept.Turn" },
			{ Term = "следующего хода", Link = "Concept.Turn" },
			{ Term = "своего хода", Link = "Concept.Turn" },
			{ Term = "каждый ход", Link = "Concept.Turn" },
			{ Term = "ходов", Link = "Concept.Turn" },
			{ Term = "хода", Link = "Concept.Turn" },
			{ Term = "ходу", Link = "Concept.Turn" },
			{ Term = "ходе", Link = "Concept.Turn" },
			{ Term = "в свой ход", Link = "Concept.Turn" },
			{ Term = "ход", Link = "Concept.Turn" },
			{ Term = "полученного опыта", Link = "Concept.Experience" },
			{ Term = "очков опыта", Link = "Concept.Experience" },
			{ Term = "опыта", Link = "Concept.Experience" },
			{ Term = "опыт", Link = "Concept.Experience" },
			{ Term = "уровня", Link = "Concept.Level" },
			{ Term = "уровень", Link = "Concept.Level" },
			{ Term = "травмам", Link = "Concept.Injury" },
			{ Term = "травмы", Link = "Concept.Injury" },

			// Частые ванильные эффекты в текстах модов (Skill — индекс по имени файла)
			{ Term = "кровотечением", Link = "Skill+bleeding_effect" },
			{ Term = "кровотечения", Link = "Skill+bleeding_effect" },
			{ Term = "кровотечение", Link = "Skill+bleeding_effect" },
			{ Term = "отравления", Link = "Skill+spider_poison_effect" },
			{ Term = "отравление", Link = "Skill+spider_poison_effect" },
			{ Term = "оглушить", Link = "Skill+stunned_effect" },
			{ Term = "оглушает", Link = "Skill+stunned_effect" },
			{ Term = "оглушён", Link = "Skill+stunned_effect" },
			{ Term = "оглушен", Link = "Skill+stunned_effect" },
			{ Term = "оглушение", Link = "Skill+stunned_effect" },
			{ Term = "Оглушение", Link = "Skill+stunned_effect" },
			{ Term = "Оглушён", Link = "Skill+stunned_effect" },
			{ Term = "Оглушен", Link = "Skill+stunned_effect" },
			{ Term = "растерянности", Link = "Skill+dazed_effect" },
			{ Term = "растерянность", Link = "Skill+dazed_effect" },
			{ Term = "Выбит дух", Link = "Skill+dazed_effect" },
			{ Term = "выбит дух", Link = "Skill+dazed_effect" },
			{ Term = "выбить дух", Link = "Skill+dazed_effect" },
			{ Term = "обездвижен", Link = "Skill+rooted_effect" },
			{ Term = "Обездвижен", Link = "Skill+rooted_effect" },
			{ Term = "опутан паутиной", Link = "Skill+web_effect" },
			{ Term = "пойман в сеть", Link = "Skill+net_effect" },
			{ Term = "Пойман в сеть", Link = "Skill+net_effect" },
		]);
	}

	function addSkill( _src, _scope = null )
	{
		local src = _src; // замыкание
		::ReforgedLite.HooksMod.hook(src, function(q) {
			q.getTooltip = @(__original) { function getTooltip()
			{
				local ret = __original();
				return ::ReforgedLite.ModSkillTooltips.linkifyTooltip(ret, _scope);
			}}.getTooltip;
		});
	}

	function addSkills( _srcs, _scope = null )
	{
		foreach (src in _srcs)
		{
			this.addSkill(src, _scope);
		}
	}

	// Пост-обработка результата getTooltip: линкификация словарём + parseString.
	function linkifyTooltip( _tooltip, _scope = null )
	{
		foreach (entry in _tooltip)
		{
			if (typeof entry != "table" || !("text" in entry) || typeof entry.text != "string")
				continue;
			if (("type" in entry && entry.type == "title") || ("id" in entry && entry.id == 1))
				continue;

			local text = this.linkifyText(entry.text, _scope);
			if (text != entry.text)
			{
				entry.text = ::ReforgedLite.Mod.Tooltips.parseString(text);
			}
		}
		return _tooltip;
	}

	function linkifyText( _text, _scope = null )
	{
		if (this.Terms.len() == 0)
			return _text;

		local protectedRanges = this.computeProtectedRanges(_text);
		local matches = [];

		foreach (term in this.Terms)
		{
			if (term.Scope != null && term.Scope != _scope)
				continue; // термин чужого мода

			local start = 0;
			while (true)
			{
				local idx = _text.find(term.Term, start);
				if (idx == null)
					break;

				local end = idx + term.Len;
				if ((idx == 0 || !this.isWordChar(_text[idx - 1])) && (end >= _text.len() || !this.isWordChar(_text[end])) && !this.isInsideRanges(idx, end, protectedRanges))
				{
					matches.push({ Begin = idx, End = end, Link = term.Link });
					start = end;
				}
				else
				{
					start = idx + 1;
				}
			}
		}

		if (matches.len() == 0)
			return _text;

		matches.sort(function( a, b ) {
			if (a.Begin != b.Begin)
				return a.Begin < b.Begin ? -1 : 1;
			if (a.End != b.End)
				return a.End > b.End ? -1 : 1; // с той же позиции длинный термин побеждает
			return 0;
		});

		local ret = "";
		local last = 0;
		foreach (m in matches)
		{
			if (m.Begin < last)
				continue; // пересечение с уже вставленной ссылкой — короткий термин проигрывает

			ret += _text.slice(last, m.Begin) + "[" + _text.slice(m.Begin, m.End) + "|" + m.Link + "]";
			last = m.End;
		}

		return ret + _text.slice(last);
	}

	// Защита уже закодированных вложенных ссылок ([ddd=ddd]текст[/ddd] из чужих хуков/батчей):
	// защищаем и сами теги, и видимый текст между ними (это якорь существующей ссылки —
	// повторная линкификация вкладывала бы ссылку в ссылку).
	function computeProtectedRanges( _text )
	{
		local ranges = [];
		local i = 0;
		while (true)
		{
			local open = _text.find("[", i);
			if (open == null)
				break;

			local j = open + 1;
			if (j < _text.len() && _text[j] == '/')
				j++;

			local digitsStart = j;
			while (j < _text.len() && _text[j] >= 0x30 && _text[j] <= 0x39)
				j++;

			if (j > digitsStart && j < _text.len() && _text[j] == '=')
			{
				j++;
				local digitsStart2 = j;
				while (j < _text.len() && _text[j] >= 0x30 && _text[j] <= 0x39)
					j++;

				if (j > digitsStart2 && j < _text.len() && _text[j] == ']')
				{
					local range = { Begin = open, End = j + 1 };
					// ищем закрывающий тег [/ddd] и защищаем видимый текст до него
					local close = _text.find("[/", j + 1);
					if (close != null)
					{
						local k = close + 2;
						local digitsStart3 = k;
						while (k < _text.len() && _text[k] >= 0x30 && _text[k] <= 0x39)
							k++;
						if (k > digitsStart3 && k < _text.len() && _text[k] == ']')
						{
							range.End = k + 1;
						}
					}
					ranges.push(range);
					i = range.End;
					continue;
				}
			}

			i = open + 1;
		}
		return ranges;
	}

	function isInsideRanges( _begin, _end, _ranges )
	{
		foreach (r in _ranges)
		{
			if (_begin < r.End && _end > r.Begin)
				return true;
		}
		return false;
	}

	// Байт — буква: кириллица (UTF-8 ≥ 0x80 — в Squirrel байты строки SIGNED, т.е. < 0),
	// латиница или цифра
	function isWordChar( _c )
	{
		return _c < 0 || (_c >= 0x30 && _c <= 0x39) || (_c >= 0x41 && _c <= 0x5A) || (_c >= 0x61 && _c <= 0x7A);
	}

	function sortByLengthDescending( _array )
	{
		_array.sort(function( a, b ) {
			if (a.Len != b.Len)
				return a.Len > b.Len ? -1 : 1;
			return 0;
		});
	}
};

::ReforgedLite.ModSkillTooltips.create();
