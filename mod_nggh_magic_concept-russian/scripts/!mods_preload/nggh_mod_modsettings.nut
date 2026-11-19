::Nggh_MagicConcept.mod_settings <- function ()
{
	// default value of settings
	::Nggh_MagicConcept.ChanceToHireHexe <- 5;
	::Nggh_MagicConcept.HexeOriginRitual <- {
		IsLoseLevelWhenFail = true,
		UnluckyChance = 5,
		UnluckyMult = 10.0,
		RandomizeMin = 80,
		RandomizeMax = 150,
		Cooldown = 7,
		Mult = 7.0,
	};
	::Nggh_MagicConcept.RandomizedStatsMode <- {
		IsEnabled = true,
		Chance = 50,
		Min = 90,
		Max = 110,
	};

	local tools = 
	{
		processIntegerInput = function( _input , _oldValue )
		{
			if (typeof _input != "string")
			{
				return {
					Value = _oldValue.tointeger(),
					Result = false,
				};
			}

			local ret = _input.tointeger();

			if (typeof ret != "integer")
			{
				return {
					Value = _oldValue.tointeger(),
					Result = false,
				};
			}

			return {
				Value = ret,
				Result = true,
			};
		},

		processFloatInput = function( _input , _oldValue )
		{
			if (typeof _input != "string")
			{
				return {
					Value = _oldValue.tofloat(),
					Result = false,
				};
			}

			local ret = _input.tofloat();

			if (typeof ret != "float")
			{
				return {
					Value = _oldValue.tofloat(),
					Result = false,
				};
			}

			return {
				Value = ret,
				Result = true,
			};
		}
	}

// add general page
	local page = ::Nggh_MagicConcept.Mod.ModSettings.addPage("general_page", "Основное");

// 1-title
	page.addTitle("title_1", "Важное").setDescription("Этот раздел содержит настройки для некоторых наиболее важных механизмов этого мода.");

// 1-content

	//- option
	local OP_Mode = page.addBooleanSetting("balance_mode", true, "Ослабленные зачарованные персонажи");
	OP_Mode.setDescription("Определяет, имеют ли зачарованные вами нечеловеческие персонажи исходные или уменьшенные характеристики, а также влияет на результат и эффективность определенных умений при их использовании игроком.");
	OP_Mode.setPersistence(true);

	//- option
	local cosmetic = page.addBooleanSetting("cosmetic_helmet", true, "Шлем для украшения");
	cosmetic.setDescription("Определяет, может ли персонаж звериного типа использовать шлемы или нет. Если шлемы разрешены, то для персонажей звериного типа они имеют только декоративное назначение.")
	cosmetic.setPersistence(true);

	//- option
	local arena = page.addBooleanSetting("arena_charm", false, "Очарование на арене");
	arena.setDescription("Определяет, можете ли вы использовать [color=" + ::Const.UI.Color.NegativeValue + "]Очарование[/color] на арене.");
	arena.setPersistence(true);

	//- option
	local canBetray = page.addBooleanSetting("can_betray", true, "Больше не простак");
	canBetray.setDescription("Определяет, предадут ли вас простаки при соблюдении необходимых условий.");
	canBetray.setPersistence(true);

	//- option
	local kraken = page.addBooleanSetting("kraken_vs_kraken", false, "Пропустить бой кракенов");
	kraken.setDescription("Если включено, то позволяет пропустить бой кракена с кракеном в начале происхождения [color=" + ::Const.UI.Color.NegativeValue + "]Зверь из зверей[/color].");
	kraken.setPersistence(true);

	//- option
	local hiringHexeChance = page.addStringSetting("hiring_hexe_chance", ::Nggh_MagicConcept.ChanceToHireHexe.tostring(), "Шанс события про ведьм (%)");
	hiringHexeChance.setDescription("Шанс встретить событие, в котором у вас есть возможность завербовать ведьму в свой отряд, выполняя контракт, в котором надо защитить первенца от ведьм. Шанс удваивается при выполнении легендарного контракта, а при игре в происхождение 'Ведьма' шанс увеличивается втрое. [color=" + ::Const.UI.Color.NegativeValue + "]Вводить можно только целое число. Слова или символы не допускаются.[/color]");
	hiringHexeChance.setPersistence(true);
	hiringHexeChance.addAfterChangeCallback(function (_oldValue)
	{
		if (this.getValue() == _oldValue) return;
		local ret = tools.processIntegerInput(this.getValue(), _oldValue);

		if (!ret.Result)
			this.set(_oldValue);

		::logInfo("After change 'Recruit Hexe Event Chance': Changed old value: " + _oldValue + " to new value: " + this.getValue());
	    ::Nggh_MagicConcept.ChanceToHireHexe = ret.Value;
	});

	//- option
	local maxHexeNum = page.addRangeSetting("hired_hexe_num_max", 1, 0, 10, 1, "Максимальное количество завербованных ведьм за кампанию");
	maxHexeNum.setDescription("Максимальное количество завербованных ведьм в вашем текущем составе (за исключением предыстории 'Ведьма-старейшина'). Пока вы не достигли максимального числа, вы можете участвовать в событии по набору. При игре в происхождение 'Ведьма' вы можете набрать в 3 раза больше, чем обычно.");
	maxHexeNum.setPersistence(true);

// 1-divider
	page.addDivider("divider_1");

// 2-title
	page.addTitle("title_2", "Ритуал ведьмы").setDescription("Этот раздел содержит настройки для ритуального события, которое связано с предысторией [color=" + ::Const.UI.Color.NegativeValue + "]Ведьма-старейшина[/color].");

// 2-content

	//- option
	local loseLevel = page.addBooleanSetting("ritual_lose_level", true, "Потеря уровня простака при неудаче");
	loseLevel.setDescription("Если включено, то при провале ритуала все ваши зачарованные персонажи потеряют [color=" + ::Const.UI.Color.NegativeValue + "]1[/color] уровенень. Эта потеря уровня может быть отменена с шансом [color=" + ::Const.UI.Color.PositiveValue + "]60%[/color], если вы успешно проведёте следующий ритуал.")
	loseLevel.setPersistence(true);

	//- option
	local ritual = page.addRangeSetting("ritual_cooldown", 7, 1, 30, 1, "Время между ритуалами");
	ritual.setDescription("Определяет, сколько дней осталось до следующего обязательного ритуала ведьмы.");
	ritual.setPersistence(true);

	//- option
	local modFactor = page.addStringSetting("ritual_factor", "" + ::Nggh_MagicConcept.HexeOriginRitual.Mult + "", "Размер подношения");
	modFactor.setDescription("Важный параметр, определяющий размер подношения. Чем он выше, тем больше вам придется пожертвовать ради события. [color=" + ::Const.UI.Color.NegativeValue + "]Вводите только положительное плавающее или целое число. Слова или символы не допускаются[/color].\n\nПримеры: \n• '1.1' верно.\n• '-1.1' неверно.\n• '1' верно.");
	modFactor.setPersistence(true);
	modFactor.addAfterChangeCallback(function (_oldValue)
	{
		if (this.getValue() == _oldValue) return;
		local ret = tools.processFloatInput(this.getValue(), _oldValue);

		if (!ret.Result)
			this.set(_oldValue);

		::logInfo("After change 'Hexe Origin Ritual - Modifying Factor': Changed old value: " + _oldValue + " to new value: " + this.getValue());
	    ::Nggh_MagicConcept.HexeOriginRitual.Mult = ret.Value;
	});

	//- option
	local randomizeMin = page.addStringSetting("ritual_min", ::Nggh_MagicConcept.HexeOriginRitual.RandomizeMin.tostring(), "Случайный коэффициент минимум (%)");
	randomizeMin.setDescription("Минимальное значение случайного коэффициента. [color=" + ::Const.UI.Color.NegativeValue + "]Вводится только целое число. Слова или символы не допускаются[/color].");
	randomizeMin.setPersistence(true);
	randomizeMin.addAfterChangeCallback(function (_oldValue)
	{
		if (this.getValue() == _oldValue) return;
		local ret = tools.processIntegerInput(this.getValue(), _oldValue);

		if (!ret.Result)
			this.set(_oldValue);

		::logInfo("After change 'Hexe Origin Ritual - Randomized Factor Min': Changed old value: " + _oldValue + " to new value: " + this.getValue());
	    ::Nggh_MagicConcept.HexeOriginRitual.RandomizeMin = ret.Value;
	});

	//- option
	local randomizeMax = page.addStringSetting("ritual_max", ::Nggh_MagicConcept.HexeOriginRitual.RandomizeMax.tostring(), "Случайный коэффициент максимум (%)");
	randomizeMax.setDescription("Максимальное значение случайного коэффициента. [color=" + ::Const.UI.Color.NegativeValue + "]Вводите только целое число и, пожалуйста, не превышайте 500. Слова или символы не допускаются[/color].");
	randomizeMax.setPersistence(true);
	randomizeMax.addAfterChangeCallback(function (_oldValue)
	{
		if (this.getValue() == _oldValue) return;
		local ret = tools.processIntegerInput(this.getValue(), _oldValue);

		if (!ret.Result)
			this.set(_oldValue);

		::logInfo("After change 'Hexe Origin Ritual - Randomized Factor Max': Changed old value: " + _oldValue + " to new value: " + this.getValue());
	    ::Nggh_MagicConcept.HexeOriginRitual.RandomizeMax = ret.Value;
	});

	//- option
	local unluckyChance = page.addStringSetting("ritual_unlucky_chance", ::Nggh_MagicConcept.HexeOriginRitual.UnluckyChance.tostring(), " Шанс неудачи(%)");
	unluckyChance.setDescription("Шанс того, что ритуальное событие потребует больше жертв, чем обычно. [color=" + ::Const.UI.Color.NegativeValue + "]Вводится только целое число. Слова или символы не допускаются[/color].");
	unluckyChance.setPersistence(true);
	unluckyChance.addAfterChangeCallback(function (_oldValue)
	{
		if (this.getValue() == _oldValue) return;
		local ret = tools.processIntegerInput(this.getValue(), _oldValue);

		if (!ret.Result)
			this.set(_oldValue);

		::logInfo("After change 'Hexe Origin Ritual - Unlucky Chance': Changed old value: " + _oldValue + " to new value: " + this.getValue());
	    ::Nggh_MagicConcept.HexeOriginRitual.UnluckyChance = ret.Value;
	});

	//- option
	local unluckyMult = page.addStringSetting("ritual_unlucky_mult", ::Nggh_MagicConcept.HexeOriginRitual.UnluckyMult.tostring(), "Коэффициент неудачного жертвоприношения");
	unluckyMult.setDescription("Коэффициент, определяющий, сколько жертв нужно принести, если вам не повезло. [color=" + ::Const.UI.Color.NegativeValue + "]Вводится только положительное плавающее или целое число. Слова или символы не допускаются[/color].\n\nПримеры: \n• '1.1' верно.\n• '-1.1' неверно.\n• '1' верно.");
	unluckyMult.setPersistence(true);
	unluckyMult.addAfterChangeCallback(function (_oldValue)
	{
		if (this.getValue() == _oldValue) return;
		local ret = tools.processFloatInput(this.getValue(), _oldValue);

		if (!ret.Result)
			this.set(_oldValue);

		::logInfo("After change 'Hexe Origin Ritual - Unlucky Sacrifice Multiplier': Changed old value: " + _oldValue + " to new value: " + this.getValue());
	    ::Nggh_MagicConcept.HexeOriginRitual.UnluckyMult = ret.Value;
	});

// 2-divider
	page.addDivider("divider_2");

// 3-title
	page.addTitle("title_3", "Случайные характеристики").setDescription("Этот раздел содержит настройки для системы случайных характеристик противников, благодаря которым любой враг получает шанс изменить свои характеристики в рамках нижнего/верхнего (мин/макс) пределов.\n\n[color=#4f1800][u]Затрагиваемые показатели:[/u][/color]\n• [color=" + ::Const.UI.Color.NegativeValue + "]ОЗ[/color]\n• [color=" + ::Const.UI.Color.NegativeValue + "]Решимость[/color]\n• [color=" + ::Const.UI.Color.NegativeValue + "]Выносливость[/color]\n• [color=" + ::Const.UI.Color.NegativeValue + "]Инициатива[/color]\n• [color=" + ::Const.UI.Color.NegativeValue + "]Навык ближнего боя[/color]\n• [color=" + ::Const.UI.Color.NegativeValue + "]Защита в ближнем бою[/color]\n• [color=" + ::Const.UI.Color.NegativeValue + "]Навык дальнего боя[/color]\n• [color=" + ::Const.UI.Color.NegativeValue + "]Защита в дальнем бою[/color]");

// 3-content

	//- option
	local enable = page.addBooleanSetting("randomize_stats_is_enabled", true, "Включено");
	enable.setDescription("[color=" + ::Const.UI.Color.PositiveValue + "]ВКЛ[/color] или [color=" + ::Const.UI.Color.NegativeValue + "]ВЫКЛ[/color] систему 'Случайные характеристики'.");
	enable.setPersistence(true);

	//- option
	local chance = page.addStringSetting("randomize_stats_chance", ::Nggh_MagicConcept.RandomizedStatsMode.Chance.tostring() , "Шанс (%)");
	chance.setDescription("Шанс того, что враг получит случайные характеристики. [color=" + ::Const.UI.Color.NegativeValue + "]Вводится только целое число. Слова или символы не допускаются[/color].");
	chance.setPersistence(true);
	chance.addAfterChangeCallback(function (_oldValue)
	{
		if (this.getValue() == _oldValue) return;
		local ret = tools.processIntegerInput(this.getValue(), _oldValue);

		if (!ret.Result)
			this.set(_oldValue);

		::logInfo("After change 'Randomized Stats - Chance': Changed old value: " + _oldValue + " to new value: " + this.getValue());
	    ::Nggh_MagicConcept.RandomizedStatsMode.Chance = ret.Value;
	});

	//- option
	local min = page.addStringSetting("randomize_stats_min", ::Nggh_MagicConcept.RandomizedStatsMode.Min.tostring(), "Нижний предел (%)");
	min.setDescription("Процент от исходных показателей, который будет использоваться в качестве нижнего предела при расчете случайных характеристик. [color=" + ::Const.UI.Color.NegativeValue + "]Вводится только целое число. Слова или символы не допускаются[/color].");
	min.setPersistence(true);
	min.addAfterChangeCallback(function (_oldValue)
	{
		if (this.getValue() == _oldValue) return;
		local ret = tools.processIntegerInput(this.getValue(), _oldValue);

		if (!ret.Result)
			this.set(_oldValue);

		::logInfo("After change 'Randomized Stats - Default Lower Limit': Changed old value: " + _oldValue + " to new value: " + this.getValue());
	    ::Nggh_MagicConcept.RandomizedStatsMode.Min = ret.Value;
	});

	//- option
	local max = page.addStringSetting("randomize_stats_max", ::Nggh_MagicConcept.RandomizedStatsMode.Max.tostring(), "Верхний предел (%)");
	max.setDescription("Процент от исходных показателей, который будет использоваться в качестве верхнего предела при расчете случайных характеристик. [color=" + ::Const.UI.Color.NegativeValue + "]Вводится только целое число. Слова или символы не допускаются[/color].");
	max.setPersistence(true);
	max.addAfterChangeCallback(function (_oldValue)
	{
		if (this.getValue() == _oldValue) return;
		local ret = tools.processIntegerInput(this.getValue(), _oldValue);

		if (!ret.Result)
			this.set(_oldValue);

		::logInfo("After change 'Randomized Stats - Default Upper Limit': Changed old value: " + _oldValue + " to new value: " + this.getValue());
	    ::Nggh_MagicConcept.RandomizedStatsMode.Max = ret.Value;
	});

	delete ::Nggh_MagicConcept.mod_settings;
}
