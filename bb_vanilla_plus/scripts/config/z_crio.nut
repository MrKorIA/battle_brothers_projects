::Const.Perks.Crio <- [];

local function addPerk(perk) {
    perk.Unlocks <- perk.Row;
    ::Const.Perks.Crio.push(perk);
    ::Const.Perks.LookupMap[perk.ID] <- perk;
}

local function green(text) {
    return ::Const.UI.getColorized(text + "", ::Const.UI.Color.PositiveValue)
}
local function red(text) {
    return ::Const.UI.getColorized(text + "", ::Const.UI.Color.NegativeValue)
}

addPerk({
    ID = "perk.vp.xx07"
    Script = "scripts/skills/perks/perk_vp_xx07"
    Name = "Ледяной Взрыв"
    Tooltip = "Накладывает мощное заклинание холода. Земля в области действия заклинания покрывается снегом, а находящиеся в ней отряды охлаждаются. Промокшая цель получает двойной урон."
    Icon = "perks/perk_xx07.png"
    IconDisabled = "perks/perk_xx07_sw.png"
    Row = 3
});
//addPerk({
//    ID = "perk.vp.xx75"
//    Script = "scripts/skills/perks/perk_vp_xx75"
//    Name = "Экстремальная погода"
//    Tooltip = "Вызывает аномальную погоду, снижает навыки ближнего боя, навыки дальнего боя, защиту ближнего боя и защиту дальнего боя всех врагов на поле боя на -5."
//    Icon = "perks/perk_xx75.png"
//    IconDisabled = "perks/perk_xx75_sw.png"
//    Row = 4
//});
addPerk({
    ID = "perk.vp.xx74"
    Script = "scripts/skills/perks/perk_vp_xx74"
    Name = "Болотная бомба"
    Tooltip = "Заполняет 7 клеток большим количеством воды, нанося урон и превращая местность в болото."
    Icon = "perks/perk_xx74.png"
    IconDisabled = "perks/perk_xx74_sw.png"
    Row = 4
});
addPerk({
    ID = "perk.vp.xxp26"
    Script = "scripts/skills/perks/perk_vp_xxp26"
    Name = "Мастерство маны"
    Tooltip = "Когда обе руки пусты, урон от магии увеличивается. Чем выше ваш текущий показатель «Решимость», тем сильнее эффект.\nУлучшаемые навыки: Огненный шар, Пламенная волна, Армагеддон, Электрический шок, Гроза, Шаровая Молния, Штормовая сила, Ледяной Взрыв"
    Icon = "perks/perk_xx26p.png"
    IconDisabled = "perks/perk_xx26p_sw.png"
    Row = 5
});
addPerk({
    ID = "perk.vp.xxp09"
    Script = "scripts/skills/perks/perk_vp_xxp09"
    Name = "Боевой транс"
    Tooltip = "При сильной усталости повышает живучесть мага.\nПри наличии навыка «Мастерство маны»: +10 ко всем характеристикам"
    Icon = "perks/perk_xx09p.png"
    IconDisabled = "perks/perk_xx09p_sw.png"
    Row = 6
});