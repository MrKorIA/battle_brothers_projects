::Const.Perks.Piro <- [];

local function addPerk(perk) {
    perk.Unlocks <- perk.Row;
    ::Const.Perks.Piro.push(perk);
    ::Const.Perks.LookupMap[perk.ID] <- perk;
}

local function green(text) {
    return ::Const.UI.getColorized(text + "", ::Const.UI.Color.PositiveValue)
}
local function red(text) {
    return ::Const.UI.getColorized(text + "", ::Const.UI.Color.NegativeValue)
}

addPerk({
    ID = "perk.vp.xx19"
    Script = "scripts/skills/perks/perk_vp_xx19"
    Name = "Пламенная волна"
    Tooltip = "Обжигает и оглушает несколько целей по прямой. Может поразить до 5 целей.\nВосстановление: 9 ходов"
    Icon = "perks/perk_xx19.png"
    IconDisabled = "perks/perk_xx19_sw.png"
    Row = 3
})
addPerk({
    ID = "perk.vp.xx80"
    Script = "scripts/skills/perks/perk_vp_xx80"
    Name = "Армагеддон"
    Tooltip = "Наносит урон всем союзникам и врагам, включая читателя заклинания. После применения этого навыка заклинатель не сможете действовать 4 хода. Этот навык можно использовать только во время ближнего боя."
    Icon = "perks/perk_xx80.png"
    IconDisabled = "perks/perk_xx80_sw.png"
    Row = 4
})
addPerk({
    ID = "perk.vp.xxp26"
    Script = "scripts/skills/perks/perk_vp_xxp26"
    Name = "Мастерство маны"
    Tooltip = "Когда обе руки пусты, урон от магии увеличивается. Чем выше ваш текущий показатель «Решимость», тем сильнее эффект.\nУлучшаемые навыки: Огненный шар, Пламенная волна, Армагеддон, Электрический шок, Гроза, Шаровая Молния, Штормовая сила, Ледяной Взрыв"
    Icon = "perks/perk_xx26p.png"
    IconDisabled = "perks/perk_xx26p_sw.png"
    Row = 5
})
addPerk({
    ID = "perk.vp.xxp09"
    Script = "scripts/skills/perks/perk_vp_xxp09"
    Name = "Боевой транс"
    Tooltip = "При сильной усталости повышает живучесть мага.\nПри наличии навыка «Мастерство маны»: +10 ко всем характеристикам"
    Icon = "perks/perk_xx09p.png"
    IconDisabled = "perks/perk_xx09p_sw.png"
    Row = 6
})