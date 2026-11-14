// Текстовые хелперы (аналог ::Reforged.Text из Reforged 0.9.3): преобразование
// чисел дней/крон в текст для тултипов (тултип контракта на экране города).
::ReforgedLite.Text <- {
	// Converts a given integer into a text which represents that number
	// e.g. 1: один, 51: пятьдесят один, 1251: одна тысяча двести пятьдесят один
	function getNumberAsText( _number )
	{
		if (_number == 0)
			return "ноль";

		local ret = "";
		local n = _number;
		if (n < 0)
		{
			ret = "минус ";
			n = -n;
		}

		local units = ["", "один", "два", "три", "четыре", "пять", "шесть", "семь", "восемь", "девять", "десять", "одиннадцать", "двенадцать", "тринадцать", "четырнадцать", "пятнадцать", "шестнадцать", "семнадцать", "восемнадцать", "девятнадцать"];
		local tens = ["", "", "двадцать", "тридцать", "сорок", "пятьдесят", "шестьдесят", "семьдесят", "восемьдесят", "девяносто"];
		local hundreds = ["", "сто", "двести", "триста", "четыреста", "пятьсот", "шестьсот", "семьсот", "восемьсот", "девятьсот"];

		// Helper function to process groups of three digits (up to 999)
		local getPart = function( _n )
		{
			local str = "";
			if (_n >= 100)
			{
				str += hundreds[_n / 100];
				_n = _n % 100;
				if (_n > 0)
					str += " ";
			}

			if (_n >= 20)
			{
				str += tens[_n / 10];
				if (_n % 10 > 0)
					str += " " + units[_n % 10];
			}
			else if (_n > 0)
			{
				str += units[_n];
			}
			return str;
		};

		if (n >= 1000000)
		{
			ret += getPart(n / 1000000) + " миллионов";
			n = n % 1000000;
			if (n > 0)
				ret += " ";
		}

		if (n >= 1000)
		{
			local thousands = getPart(n / 1000);
			// согласование: "одна тысяча", "две тысячи", "пять тысяч"
			local lastTwo = (n / 1000) % 100;
			local lastOne = lastTwo % 10;
			local form = lastTwo >= 11 && lastTwo <= 14 ? "тысяч" : (lastOne == 1 ? "тысяча" : (lastOne >= 2 && lastOne <= 4 ? "тысячи" : "тысяч"));
			if (lastOne == 1 && lastTwo != 11)
				thousands = ::String.replace(thousands, "один ", "одна ");
			if ((n / 1000) % 10 == 2 && lastTwo != 12)
				thousands = ::String.replace(thousands, "два ", "две ");
			ret += thousands + " " + form;
			n = n % 1000;
			if (n > 0)
				ret += " ";
		}

		if (n > 0)
		{
			ret += getPart(n);
		}

		return ret;
	}

	// Возвращает строку вида "день", "2 дня", "два с половиной дня" для заданного
	// количества секунд игрового времени.
	function getDaysAndHalf( _seconds )
	{
		local doubleDays = ::Math.round(2.0 * (_seconds / ::World.getTime().SecondsPerDay));
		local daysAndHalf = (doubleDays / 2.0);
		if (daysAndHalf <= 1.0)
			return "день";

		if (daysAndHalf == daysAndHalf.tointeger())
			return daysAndHalf + " дня";

		return this.getNumberAsText(daysAndHalf.tointeger()) + " с половиной дня";
	}

	// Оценка оставшегося времени текстом (менее дня / около дня / ещё пару дней / ...).
	function getDaysRemainingText( _numDays )
	{
		if (_numDays > 8)
			return "очень долго";
		if (_numDays >= 6)
			return "около недели";
		if (_numDays >= 4)
			return "ещё несколько дней";
		if (_numDays >= 2)
			return "ещё пару дней";
		if (_numDays >= 1)
			return "около дня";

		return "менее дня";
	}
}
