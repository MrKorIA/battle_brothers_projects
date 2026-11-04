::Const.Perks.Shaman <- [];

local function addPerk(perk) {
    perk.Unlocks <- perk.Row;
    ::Const.Perks.Shaman.push(perk);
    ::Const.Perks.LookupMap[perk.ID] <- perk;
}

local function green(text) {
    return ::Const.UI.getColorized(text + "", ::Const.UI.Color.PositiveValue)
}
local function red(text) {
    return ::Const.UI.getColorized(text + "", ::Const.UI.Color.NegativeValue)
}

addPerk({
    ID = "perk.vp.xx05"
    Script = "scripts/skills/perks/perk_vp_xx05"
    Name = "Призыв духа волка"
    Tooltip = "Добавляет навык призыва духа волка. На 10 уровне волк получает: +100% к урону, +10 к навыку ближнего боя, +100 к ОЗ"
    Icon = "perks/perk_xx05.png"
    IconDisabled = "perks/perk_xx05_sw.png"
    Row = 1
})
addPerk({
    ID = "perk.vp.xx81"
    Script = "scripts/skills/perks/perk_vp_xx81"
    Name = "Рой насекомых"
    Tooltip = "Призывает рой насекомых, чтобы ослабить цель.\nЦель получает -50% к навыку ближнего боя, навыку дальнего боя, защите от ближнего боя, защите от дальнего боя и инициативе на 3 хода."
    Icon = "perks/perk_xx81.png"
    IconDisabled = "perks/perk_xx81_sw.png"
    Row = 3
})
addPerk({
    ID = "perk.vp.xx82"
    Script = "scripts/skills/perks/perk_vp_xx82"
    Name = "Искоренение"
    Tooltip = "Из земли вырываются огромные корни, нанося урон трем целям по прямой линии и накладывая статус «Ошеломление»."
    Icon = "perks/perk_xx82.png"
    IconDisabled = "perks/perk_xx82_sw.png"
    Row = 5
})
addPerk({
    ID = "perk.vp.xxp25"
    Script = "scripts/skills/perks/perk_vp_xxp25"
    Name = "Месть"
    Tooltip = "Один раз за ход, когда этот персонаж успешно атакует или уклоняется, наносит 5 единиц урона.\nЭтот урон не может убить цель."
    Icon = "perks/perk_xx32.png"
    IconDisabled = "perks/perk_xx32_sw.png"
    Row = 3
})
addPerk({
    ID = "perk.vp.xxp12"
    Script = "scripts/skills/perks/perk_vp_xxp12"
    Name = "Быстрые рефлексы"
    Tooltip = "+20 к инициативе. На 20% меньше получаемого урона."
    Icon = "perks/perk_xx12p.png"
    IconDisabled = "perks/perk_xx12p_sw.png"
    Row = 6
})