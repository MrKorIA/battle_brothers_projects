// rune effects
local effectsDefs = [];

::Legends.Effect.NgGHRswCorrosion <- null;
effectsDefs.push({
	ID = "special.mod_RSW_corrosion",
	Script = "scripts/skills/rune_sigils/nggh_mod_RSW_corrosion",
	Name = "Рунный знак: Ржавчина",
	Const = "NgGHRswCorrosion"
});

::Legends.Effect.NgGHRswLucky <- null;
effectsDefs.push({
	ID = "special.mod_RSW_lucky",
	Script = "scripts/skills/rune_sigils/nggh_mod_RSW_lucky",
	Name = "Рунный знак: Удача",
	Const = "NgGHRswLucky"
});

::Legends.Effect.NgGHRswUnstable <- null;
effectsDefs.push({
	ID = "special.mod_RSW_unstable",
	Script = "scripts/skills/rune_sigils/nggh_mod_RSW_unstable",
	Name = "Рунный знак: Нестабильность",
	Const = "NgGHRswUnstable"
});

::Legends.Effect.NgGHRshNightVision <- null;
effectsDefs.push({
	ID = "special.mod_RSH_night_vision",
	Script = "scripts/skills/rune_sigils/nggh_mod_RSH_night_vision",
	Name = "Рунный знак: Ночное зрение",
	Const = "NgGHRshNightVision"
});

::Legends.Effect.NgGHRsaRepulsion <- null;
effectsDefs.push({
	ID = "special.mod_RSA_repulsion",
	Script = "scripts/skills/rune_sigils/nggh_mod_RSA_repulsion",
	Name = "Рунный знак: Отталкивание",
	Const = "NgGHRsaRepulsion"
});

::Legends.Effect.NgGHRshShielding <- null;
effectsDefs.push({
	ID = "special.magic_shield",
	Script = "scripts/skills/rune_sigils/nggh_mod_RSH_shielding",
	Name = "Рунный знак: Барьер",
	Const = "NgGHRshShielding"
});

::Legends.Effect.NgGHRsaThorns <- null;
effectsDefs.push({
	ID = "special.mod_RSA_thorns",
	Script = "scripts/skills/rune_sigils/nggh_mod_RSA_thorns",
	Name = "Рунный знак: Шипы",
	Const = "NgGHRsaThorns"
});

::Legends.Effect.NgGHRssBrimstone <- null;
effectsDefs.push({
	ID = "effects.mod_RSS_brimstone",
	Script = "scripts/skills/rune_sigils/nggh_mod_RSS_brimstone",
	Name = "Рунный знак: Сера",
	Const = "NgGHRssBrimstone"
});

::Legends.Effects.addEffectDefObjects(effectsDefs);


// rune defs
::Legends.Rune.NgGHRswCorrosion <- ::Legends.Runes.add({
	ItemType = ::Legends.Runes.Target.Weapon,
	Name = "Рунный знак оружия: Ржавчина",
	Description = "Расписанный рунами камень, который может быть прикреплён к оружию персонажа.",
	Icon = "rune_sigils/rune_stone_1.png",
	IconLarge = "rune_sigils/rune_stone_1.png",
	Effect = ::Legends.Effect.NgGHRswCorrosion,
	Script = "scripts/items/rune_sigils/legend_vala_inscription_token",
	setRuneBonus = function(_item, _bonus) {},
	getTooltip = function(_item) {
		return "Этот предмет обладает силой рунного знака Ржавчина:\n[color=" + ::Const.UI.Color.PositiveValue + "]1 - 2[/color] хода(ов) применения кислоты, которая способна разрушить [color=" + ::Const.UI.Color.NegativeValue + "]10%[/color] брони пораженной цели за ход.";
	}
	getRuneTooltip = function (_item) {
		return "Этот предмет обладает силой рунного знака Ржавчина:\n[color=" + ::Const.UI.Color.PositiveValue + "]1 - 2[/color] хода(ов) применения кислоты, которая способна разрушить [color=" + ::Const.UI.Color.NegativeValue + "]10%[/color] брони пораженной цели за ход.";
	}
});

::Legends.Rune.NgGHRswLucky <- ::Legends.Runes.add({
	ItemType = ::Legends.Runes.Target.Weapon,
	Name = "Рунный знак оружия: Удача",
	Description = "Расписанный рунами камень, который может быть прикреплён к оружию персонажа.",
	Icon = "rune_sigils/rune_stone_1.png",
	IconLarge = "rune_sigils/rune_stone_1.png",
	Effect = ::Legends.Effect.NgGHRswLucky,
	Script = "scripts/items/rune_sigils/legend_vala_inscription_token",
	setRuneBonus = function(_item, _bonus) {},
	getTooltip = function(_item) {
		return "Этот предмет обладает силой рунного знака Удача:\nУбитый враг имеет шанс [color=" + ::Const.UI.Color.PositiveValue + "](XP / " + ::Const.LuckyRuneChanceModifier + ")%[/color] выпадения случайного предмета, вы можете получить именной предмет, если вам очень повезет!";
	}
	getRuneTooltip = function (_item) {
		return "Этот предмет обладает силой рунного знака Удача:\nУбитый враг имеет шанс [color=" + ::Const.UI.Color.PositiveValue + "](XP / " + ::Const.LuckyRuneChanceModifier + ")%[/color] выпадения случайного предмета, вы можете получить именной предмет, если вам очень повезет!";
	}
});

::Legends.Rune.NgGHRswUnstable <- ::Legends.Runes.add({
	ItemType = ::Legends.Runes.Target.Weapon,
	Name = "Рунный знак оружия: Нестабильность",
	Description = "Расписанный рунами камень, который может быть прикреплён к оружию персонажа.",
	Icon = "rune_sigils/rune_stone_1.png",
	IconLarge = "rune_sigils/rune_stone_1.png",
	Effect = ::Legends.Effect.NgGHRswUnstable,
	Script = "scripts/items/rune_sigils/legend_vala_inscription_token",
	setRuneBonus = function(_item, _bonus) {},
	getTooltip = function(_item) {
		return "Этот предмет обладает силой рунного знака Нестабильность:\nАтаки наносят [color=" + ::Const.UI.Color.PositiveValue + "]10%[/color] либо тройной, либо треть от первоначального урона.";
	}
	getRuneTooltip = function (_item) {
		return "Этот предмет обладает силой рунного знака Нестабильность:\nАтаки наносят [color=" + ::Const.UI.Color.PositiveValue + "]10%[/color] либо тройной, либо треть от первоначального урона.";
	}
});

::Legends.Rune.NgGHRshNightVision <- ::Legends.Runes.add({
	ItemType = ::Legends.Runes.Target.Helmet,
	Name = "Рунный знак шлема: Ночное зрение",
	Description = "Расписанный рунами камень, который может быть прикреплён к шлему персонажа.",
	Icon = "rune_sigils/rune_stone_2.png",
	IconLarge = "rune_sigils/rune_stone_2.png",
	Effect = ::Legends.Effect.NgGHRshNightVision,
	Script = "scripts/items/legend_helmets/runes/nggh_mod_rune_night_vision",
	setRuneBonus = function(_item, _bonus) {},
	getTooltip = function(_item) {
		return "Этот предмет обладает силой рунного знака Ночное зрение:\nНе подвержен эффекту [color=" + ::Const.UI.Color.PositiveValue + "]Ночное время[/color].";
	}
	getRuneTooltip = function (_item) {
		return "Этот предмет обладает силой рунного знака Ночное зрение:\nНе подвержен эффекту [color=" + ::Const.UI.Color.PositiveValue + "]Ночное время[/color].";
	}
});

::Legends.Rune.NgGHRshShielding <- ::Legends.Runes.add({
	ItemType = ::Legends.Runes.Target.Helmet,
	Name = "Рунный знак шлема: Барьер",
	Description = "Расписанный рунами камень, который может быть прикреплён к шлему персонажа.",
	Icon = "rune_sigils/rune_stone_2.png",
	IconLarge = "rune_sigils/rune_stone_2.png",
	Effect = ::Legends.Effect.NgGHRshShielding,
	Script = "scripts/items/legend_helmets/runes/nggh_mod_rune_shielding",
	setRuneBonus = function(_item, _bonus) {},
	getTooltip = function(_item) {
		return "Этот предмет обладает силой рунного знака Барьер:\nГарантирует [color=" + ::Const.UI.Color.PositiveValue + "]Защитный барьер[/color], который может отражать физические атаки.";
	}
	getRuneTooltip = function (_item) {
		return "Этот предмет обладает силой рунного знака Барьер:\nГарантирует [color=" + ::Const.UI.Color.PositiveValue + "]Защитный барьер[/color], который может отражать физические атаки.";
	}
});

::Legends.Rune.NgGHRsaRepulsion <- ::Legends.Runes.add({
	ItemType = ::Legends.Runes.Target.Armor,
	Name = "Рунный знак доспехов: Отталкивание",
	Description = "Расписанный рунами камень, который может быть прикреплён к доспеху персонажа.",
	Icon = "rune_sigils/rune_stone_3.png",
	IconLarge = "rune_sigils/rune_stone_3.png",
	Effect = ::Legends.Effect.NgGHRsaRepulsion,
	Script = "scripts/items/legend_armor/runes/nggh_mod_rune_repulsion",
	setRuneBonus = function(_item, _bonus) {},
	getTooltip = function(_item) {
		return "Этот предмет обладает силой рунного знака Отталкивание:\nШанс [color=" + ::Const.UI.Color.PositiveValue + "]50%[/color] на отталкивание противника. [color=" + ::Const.UI.Color.PositiveValue + "]Невосприимчивость[/color] к отталкиванию и захватам.";
	}
	getRuneTooltip = function (_item) {
		return "Этот предмет обладает силой рунного знака Отталкивание:\nШанс [color=" + ::Const.UI.Color.PositiveValue + "]50%[/color] на отталкивание противника. [color=" + ::Const.UI.Color.PositiveValue + "]Невосприимчивость[/color] к отталкиванию и захватам.";
	}
});

::Legends.Rune.NgGHRsaThorns <- ::Legends.Runes.add({
	ItemType = ::Legends.Runes.Target.Armor,
	Name = "Рунный знак доспехов: Шипы",
	Description = "Расписанный рунами камень, который может быть прикреплён к доспеху персонажа.",
	Icon = "rune_sigils/rune_stone_3.png",
	IconLarge = "rune_sigils/rune_stone_3.png",
	Effect = ::Legends.Effect.NgGHRsaThorns,
	Script = "scripts/items/legend_armor/runes/nggh_mod_rune_thorns",
	setRuneBonus = function(_item, _bonus) {},
	getTooltip = function(_item) {
		return "Этот предмет обладает силой рунного знака Шипы:\n[color=" + ::Const.UI.Color.PositiveValue + "]+25%[/color] урона, наносимого броне.\nОтражает [color=" + ::Const.UI.Color.PositiveValue + "]35[/color]-[color=" + ::Const.UI.Color.PositiveValue + "]65%[/color] урона, наносимого броне, обратно атакующему.";
	}
	getRuneTooltip = function (_item) {
		return "Этот предмет обладает силой рунного знака Шипы:\n[color=" + ::Const.UI.Color.PositiveValue + "]+25%[/color] урона, наносимого броне.\nОтражает [color=" + ::Const.UI.Color.PositiveValue + "]35[/color]-[color=" + ::Const.UI.Color.PositiveValue + "]65%[/color] урона, наносимого броне, обратно атакующему.";
	}
});

::Legends.Rune.NgGHRssBrimstone <- ::Legends.Runes.add({
	ItemType = ::Legends.Runes.Target.Shield,
	Name = "Рунный знак щита: Сера",
	Description = "Расписанный рунами камень, который может быть прикреплён к щиту персонажа.",
	Icon = "rune_sigils/rune_stone_4.png",
	IconLarge = "rune_sigils/rune_stone_4.png",
	Effect = ::Legends.Effect.NgGHRssBrimstone,
	Script = "scripts/items/rune_sigils/legend_vala_inscription_token",
	setRuneBonus = function(_item, _bonus) {},
	getTooltip = function(_item) {
		return "Этот предмет обладает силой рунного знака Сера:\n[color=" + ::Const.UI.Color.PositiveValue + "]Невосприимчивость[/color] к огню, персонаж получает [color=" + ::Const.UI.Color.NegativeValue + "]+10[/color] к восстановлению выносливости за ход и небольшое снижение наносимого урона при нахождении в огне.";
	}
	getRuneTooltip = function (_item) {
		return "Этот предмет обладает силой рунного знака Сера:\n[color=" + ::Const.UI.Color.PositiveValue + "]Невосприимчивость[/color] к огню, персонаж получает [color=" + ::Const.UI.Color.NegativeValue + "]+10[/color] к восстановлению выносливости за ход и небольшое снижение наносимого урона при нахождении в огне.";
	}
});