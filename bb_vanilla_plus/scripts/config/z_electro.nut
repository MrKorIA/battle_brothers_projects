::Const.Perks.Electro <- [];

local function addPerk(perk) {
    perk.Unlocks <- perk.Row;
    ::Const.Perks.Electro.push(perk);
    ::Const.Perks.LookupMap[perk.ID] <- perk;
}

local function green(text) {
    return ::Const.UI.getColorized(text + "", ::Const.UI.Color.PositiveValue)
}
local function red(text) {
    return ::Const.UI.getColorized(text + "", ::Const.UI.Color.NegativeValue)
}

addPerk({
    ID = "perk.vp.xx41"
    Script = "scripts/skills/perks/perk_vp_xx41"
    Name = "Гроза"
    Tooltip = "Наносит урон от дальнего боя случайным врагам в радиусе 2 клеток вокруг вас 10 раз. Заклинатель не может действовать в течение 2 ходов."
    Icon = "perks/perk_xx41.png"
    IconDisabled = "perks/perk_xx41_sw.png"
    Row = 3
})
addPerk({
    ID = "perk.vp.xx57"
    Script = "scripts/skills/perks/perk_vp_xx57"
    Name = "Шаровая Молния"
    Tooltip = "Наносит небольшой урон по здоровью и выносливости целям в зоне поражения и отталкивает их от центра. Ошеломляет цели и снимает защиту от стены щитов / стены копий / ответного удара."
    Icon = "perks/perk_xx57.png"
    IconDisabled = "perks/perk_xx57_sw.png"
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