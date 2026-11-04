Stronghold.Text = {
	format : function(_string)
	{
		//adapted from https://coderwall.com/p/flonoa/simple-string-format-in-javascript
		var args = Array.prototype.slice.call(arguments, 1);
		for (k in args) {
			_string = _string.replace("{" + k + "}", "<b>" + args[k] + "</b>");
		}
		return _string;
	},
	Error : "Произошла ошибка.",
	Requirements : "Требования",
	Advantages : "Преимущества",
	General : {
		Tier1 : "Застава",
		Tier2 : "Форт",
		Tier3 : "Замок",
		Tier4 : "Крепость",
		Hamlet : "Деревушка",
		Houses : "Дома",
		Mercenaries : "Наёмники",
		Price : "Цена: {0} крон.",
	},
	MainModule : {
		Title : "Обзор",
		LastEnterLog : {
			Days : "Дней с момента последнего посещения: {0}",
			Gold : "Накоплено золота: {0}",
			Tools : "Накоплено инструментов: {0}",
			Items : "Прочие накопленные предметы: {0}",
			Experience : "Получено опыта: {0}",
		},
		BaseSettings : {
			ShowEffectRadius : "Показать радиус действия вашей базы на карте мира.",
			ShowBanner : "Показать знамя вашей базы на карте мира.",
		},
		RaidedTitle : "Набег",
		RaidedText : "Ваша база недавно подверглась набегу. Чтобы расчистить завалы и сделать базу полностью доступной, потребуется {0} дней. Вы также можете заплатить {1} крон, чтобы ускорить расчистку.",
		RaidedButton : "Заплатить {0} крон",
		OverflowTitle : "Переполнение предметов",
		OverflowText : "{0} предметы переполняют ваш склад. Нажмите эту кнопку, чтобы добавить их на свой склад. <b>Осторожно!</b> Вам придется выделить для них место, иначе они будут потеряны после того, как вы покинете базу.",
		PopupButton : "Показать предметы",
		OverflowButton : "Взять предметы",
		UpgradingTitle : "Улучшение базы",
		UpgradingText : "При улучшении базы до следующего уровня многие функции базы становятся недоступны. Атаку можно ожидать каждые 12-24 часа, причем каждая волна будет сильнее предыдущей.",
	},
	MiscModule : {
		BuildRoad : {
			Title : "Строительство дороги",
			Description : "Строительство дороги позволит вашим караванам путешествовать, а патрулям - передвигаться. Вы также сможете отправлять подарки фракциям, проложив к ним дорогу.",
			BuildTo : "Построить дорогу в: ",
			Faction : "Фракция: {0}",
			Distance : "Расстояние (по воздуху): {0}",
			Segments : "Сегментов дороги: {0}",
			Requirements : {
				BaseTier : "Улучшите свою базу до уровня {0}, чтобы иметь возможность строить дороги к другим поселениям."
			}
		},
		SendGifts : {
			Title : "Отправить подарки",
			TargetTitle : "Целевая фракция",
			Description : "Вы можете отправить делегацию с подарками для фракции. На это уйдут сокровища, хранящиеся на вашем складе, а отношения с фракцией улучшатся в зависимости от стоимости подарков. Караван потребует {0} крон за перевозку товаров.<br>Караван будет двигаться по дорогам в направлении целевого города, и хотя его будут охранять несколько наёмников, возможно, вам следует сопроводить его.",
			SendTo : "Отправить подарки для: ",
			Requirements: {
				Faction : "Как минимум одна фракция связана с вами дорогами и не является союзником.",
				Price : "Цена: {price} (для транспортировки подарков).",
				HaveGifts : "На вашем складе есть подарки (сокровища).",
			},
			CurrentRelation : "Текущие отношения: {num} ({numText})",
			TargetTown : "Целевой город: {town}",
			ReputationGain : "Репутация, приобретенная благодаря подаркам: {reputation}",
			OnSend : "Караван направляется в {town}"
		},
		TrainBrother : {
			Title : "Тренировать брата",
			Description : "Наймите тренера, чтобы он обучил одного из ваших братьев. Тренировка должна быть жестокой, так как ни один брат не захочет проходить ее более одного раза.<br> Брат получит одну звезду таланта в выбранном атрибуте. Выбрать можно только те атрибуты, у которых меньше трех звезд таланта могут быть выбраны.<br>Значения применяются задним числом (брат выше 1-го уровня получит атрибуты, которые были бы у него, если бы он тренировался на 1-м уровне и после этого повысил уровень).<br>Кроме того, брат получит специальный эффект обучения, увеличивающий его прирост опыта на {0}x в течение следующих {1} битв.",
			Invalid : "Здесь никто не сможет предоставить вам обучение, которое вы ищете.",
			Requirements : {
				FoundTrainer : "Найдите человека, который сможет провести обучение, которое вам нужно. [Награда]",
			},
			ConfirmButton : "Тренировать брата",
			ChooseButton : "Выбрать брата",
			AttributeNames : ["ОЗ", "Решимость", "Выносливость", "Инициатива", "Навык ближнего боя", "Навык дальнего боя", "Защита в ближнем бою", "Защита в дальнем бою"],
			SuccessTalent : "Ваш брат успешно прошел обучение. Его талант в {0} вырос до {1}.<br>",
			SuccessAttribute : "Его текущий {0} увеличился на {1}.",
			NoChangeAttribute : "Его текущий {0} остался прежним.",
		},
		BuyWater : {
			Title : "Купить живую воду",
			Description : "Купить живую воду с мифическими свойствами.",
			Requirements : {
				Unlocked : "Восстановите рецепт создания мифической живой воды. [Награда]",
				EmptySlot : "У вас должно быть свободное место для нового предмета."
			},
			ConfirmButton : "Купить живую воду",
		},
		HireMercenaries : {
			Title : "Нанять группу наёмников",
			Description : "Нанять группу наемников, чтобы они следовали за вами в путешествиях. Они будут следовать за вашим отрядом и участвовать в любых боях в течение {0} дней.",
			Requirements : {
				Unlocked : "Вы привлекли группу наемников для найма. [Награда]",
				NoMercenaries : "В настоящее время за вами не следуют наёмники."
			},
			ConfirmButton : "Нанять группу наёмников",
		},
		RemoveBase : {
			Title : "Уничтожить базу",
			Description : "Уничтожить базу и связанную с ней деревушку, если она существует. Это действие нельзя отменить.",
			Requirements: {
				NoContract : "У вас не должно быть активного контракта.",
			},
			Warning : "ПОСЛЕДНЕЕ ПРЕДУПРЕЖДЕНИЕ! Вы уверены, что хотите удалить свою базу?"
		}
	},
	RosterModule : {
		Attributes : "Показатели",
		Skills : "Умения",
		Portrait : "Портрет",
	},
	StashModule : {},
	StructureModule : {
		Build : "Построить",
		Remove : "Уничтожить",
		Upgrade : "Улучшить",
	},
	BuildingsModule : {
		Build : "Построить",
		Remove : "Уничтожить",
		Upgrade : "Улучшить",
	},
	LocationsModule : {
		Build : "Построить",
		Upgrade : "Улучшить",
		Remove : "Уничтожить",
		Level : " (Уровень: {0}/{1})",
		MaxForBaseLevel : "Уровень вашей базы ({0}) должен быть выше уровня локации ({1})",
		MaxTotal : "Уровень вашей базы ({0}) может поддерживать до {1} различных локаций. (В настоящее время: {2})",
		MaxLevel : "Вы достигли максимально возможного уровня для этой локации.",
		CurrentDetails : "Текущий уровень: <br>",
		NextDetails : "Следующий уровень: <br>",
	},
	VisualsModule : {
		Title : "Сменить внешний вид",
		Spriteset : "{0} от {1}{2}", // name by author (current visuals)
		Current : " (текущий внешний вид)",
		Button : "Применить",
	},
	UpgradeModule : {
		Title : "Улучшение базы",
		Name : "Улучшение",
		Description : "Улучшайте свою базу, расширяя её возможности. Всего у базы четыре уровня.",
		Requirements : {
			MaxSize : "Ваша база полностью улучшена!",
			Warehouse : "Ваш склад должен быть улучшен до уровня базы.",
			Price : "Недостаточно денег ({0})",
			NoContract : "У вас не должно быть активного контракта.",
			Renown: "Необходимо как минимум {0} репутации (в настоящее время: {1}).",
		},
		UpgradeDescription : "Улучшите свою базу с уровня {0} до уровня {1}, чтобы разблокировать следующие возможности:",
		GeneralUnlockDescription : "<li>Вы сможете построить дополнительное здание и две дополнительные локации.</li><li>Локации можно будет улучшить ещё на один уровень.</li><li>Цены на покупку и продажу улучшатся на 5%, а запасы торговцев вырастут в редкости и количестве.</li><li>Радиус действия вашей базы будет увеличен.</li>",
		UnlockDescriptions : {
			1 : "<li></li>",
			2 : "<li>Вы сможете строить дороги к другим поселениям, соединяя свою базу с миром.</li>",
			3 : "<li>Будет предоставлен ряд уникальных контрактов.</li>",
			4 : "<li>Будет построена деревушка и соединена с вашей базой.</li>",
		}
	},
	Locations : {
		Warehouse : {
			UpgradeDescription : {
				MaxItemSlots : "<li>На базе можно хранить до {0} предметов.</li>",
				UpgradeBase : "<li>Позволяет обновить базу до уровня {0}.</li>"
			},
			getUpgradeDescription : function(_element, _level){
				return  Stronghold.Text.format(this.UpgradeDescription.UpgradeBase, _level) + Stronghold.Text.format(this.UpgradeDescription.MaxItemSlots, (_level + 1) * _element.MaxItemSlots);
			}

		},
		Collector : {
			UpgradeDescription : {
				Description : "<li>Каждый день у коллекционера есть {0}% шанс найти предметы и добавить их на ваш склад.</li>",
				Rarity : "<li>Улучшение коллекционера добавляет в запасы более редкие предметы.</li>",
			},
			getUpgradeDescription : function(_element, _level){
				return  Stronghold.Text.format(this.UpgradeDescription.Description, _element.Chance) + this.UpgradeDescription.Rarity;
			}
		},
		Workshop : {
			UpgradeDescription : {
				Amounts : "<li>Склад будет производить {0} инструментов каждый день, а ваш склад сможет хранить в общей сложности {1}.</li>"
			},
			getUpgradeDescription : function(_element, _level){
				return  Stronghold.Text.format(this.UpgradeDescription.Amounts, _element.DailyIncome * _level, _element.MaxItemSlots * _level);
			},
		},
		Ore_Smelter : {
			UpgradeDescription : {
				Weaponsmith : "<li>Плавильные печи увеличивают запас предметов у местного оружейника.</li>",
				Reforge : "<li>Вы сможете выковать именные предметы, стоимость которых составляет {0}% от их базовой стоимости. Чтобы выковать именной предмет, положите его на склад и щелкните по нему ПКМ. [Привязка клавиш MSU, можно изменить в настройках.]</li>"
			},
			getUpgradeDescription : function(_element, _level){
				return  this.UpgradeDescription.Weaponsmith +  Stronghold.Text.format(this.UpgradeDescription.Reforge, parseInt((1 - _element.ReforgeMultiplier * _level) * 100));
			},
		},
		Blast_Furnace : {
			UpgradeDescription : {
				Armorsmith : "<li>Доменная печь увеличивает запас предметов у местного оружейника.</li>",
				RepairMultiplier : "<li>Находясь на базе, вы сможете ремонтировать предметы на {0}% дешевле, чем у оружейника или кузнеца.</li>"
			},
			getUpgradeDescription : function(_element, _level){
				return  this.UpgradeDescription.Armorsmith + Stronghold.Text.format(this.UpgradeDescription.RepairMultiplier,  parseInt(_element.RepairMultiplier * _level * 100));
			},
		},
		Stone_Watchtower : {
			UpgradeDescription : {
				FOV : "<li>Выявляет врагов в тумане войны вокруг базы и предупреждает вас о готовящихся атаках, когда вражеская база находится в радиусе действия вашей базы.</li>",
				VisionIncrease : "<li>Обзор увеличивается на {0}, когда вы находитесь в радиусе действия эффекта базы.</li>",
				MovementSpeedIncrease : "<li>Скорость передвижения отряда увеличивается на {0}%, когда он находится в радиусе действия эффекта базы.</li>",
			},
			getUpgradeDescription : function(_element, _level){
				var text = this.UpgradeDescription.FOV;
				text += Stronghold.Text.format(this.UpgradeDescription.VisionIncrease, _element.VisionIncrease * _level);
				text += Stronghold.Text.format(this.UpgradeDescription.MovementSpeedIncrease,  parseInt(_element.MovementSpeedIncrease * _level * 100));
				return  text
			},
		},
		Troop_Quarters : {
			UpgradeDescription : {
				Slots : "<li>Эта локация предоставляет жилье для ваших братьев, позволяя вам оставить на базе до {0} братьев.</li>",
				WageCost : "<li>Жалование братьев на базе составляет всего {0}% от обычного.</li>",
				Mood : "<li>Настроение братьев, проживающих на базе, с течением времени стремится к {0}.</li>",
			},
			getUpgradeDescription : function(_element, _level){
				var text = Stronghold.Text.format(this.UpgradeDescription.Slots, _element.MaxTroops * _level);
				text += Stronghold.Text.format(this.UpgradeDescription.WageCost, parseInt((_element.WageCost - _level * _element.WageCostPerLevel) * 100));
				text += Stronghold.Text.format(this.UpgradeDescription.Mood, _element.MoodStateNames[_element.MoodStateStart + _element.MoodStatePerLevel * _level]);
				return  text
			},
		},
		Militia_Trainingcamp : {
			UpgradeDescription : {
				DailyIncome : "<li>Тренировочный лагерь генерирует {0} опыта в день, который делится на всех находящихся на базе братьев ниже уровня {1}.</li>",
				NPC : "<li>Ваши союзные наёмники и помощники будут тренироваться здесь, увеличивая силу наёмного отряда и сопровождения караванов.</li>",
				Hamlet : "<li>Если у вашей базы есть деревушка, то каждый тренировочный лагерь увеличивает количество новобранцев, которые выстраиваются в очередь, чтобы присоединиться к вам, на {0}.</li>"
			},
			getUpgradeDescription : function(_element, _level){
				var text = Stronghold.Text.format(this.UpgradeDescription.DailyIncome, _element.DailyIncome * _level, _element.MaxBrotherExpLevel + _element.MaxBrotherExpLevelUpgrade);
				text += this.UpgradeDescription.NPC;
				text += Stronghold.Text.format(this.UpgradeDescription.Hamlet, _element.RecruitIncrease);
				return  text
			},
		},
		Wheat_Fields : {
			UpgradeDescription : {
				StatBuff : "<li>Братья в вашем отряде получают эффект 'Сытый', повышающий их решимость, ОЗ и выносливость на {0}. Этот эффект действует в течение {1} дней после выхода из радиуса базы.</li>",
			},
			getUpgradeDescription : function(_element, _level){
				var text = Stronghold.Text.format(this.UpgradeDescription.StatBuff, _element.StatGain * _level, _element.EffectTime);
				return  text},
		},
		Gold_Mine : {
			UpgradeDescription : {
				DailyIncome : "<li>Золотая шахта приносит {0} крон в день, которые пополняют вашу казну, когда вы посещаете базу.</li>",
			},
			getUpgradeDescription : function(_element, _level){
				return Stronghold.Text.format(this.UpgradeDescription.DailyIncome, _element.DailyIncome * _level)
			},
		}
	}
}
