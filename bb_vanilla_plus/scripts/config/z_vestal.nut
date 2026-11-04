::Const.Perks.Vestal <- [];

local function addPerk(perk) {
    perk.Unlocks <- perk.Row;
    ::Const.Perks.Vestal.push(perk);
    ::Const.Perks.LookupMap[perk.ID] <- perk;
}

local function green(text) {
    return ::Const.UI.getColorized(text + "", ::Const.UI.Color.PositiveValue)
}
local function red(text) {
    return ::Const.UI.getColorized(text + "", ::Const.UI.Color.NegativeValue)
}

addPerk({
    ID = "perk.vp.heal"
    Script = "scripts/skills/perks/perk_vp_heal"
    Name = "Магическое исцеление"
    Tooltip = "Восстанавливает здоровье, броню и шлем дружественной цели."
    Icon = "perks/perk_vp_heal.png"
    IconDisabled = "perks/perk_vp_heal_sw.png"
    Row = 3
})
addPerk({
    ID = "perk.vp.miracle"
    Script = "scripts/skills/perks/perk_vp_miracle"
    Name = "Чудо"
    Tooltip = "Исцеляет и снижает усталость ближайших союзников. Не действует на себя."
    Icon = "perks/perk_vp_miracle.png"
    IconDisabled = "perks/perk_vp_miracle_sw.png"
    Row = 4
})
addPerk({
    ID = "perk.vp.shieldf"
    Script = "scripts/skills/perks/perk_vp_shieldf"
    Name = "Щит веры"
    Tooltip = "При оснащении щитом: +25 к максимальной усталости, +10 к решимости (эффект удваивается для именного или легендарного щита)."
    Icon = "perks/perk_vp_shieldf.png"
    IconDisabled = "perks/perk_vp_shieldf_sw.png"
    Row = 5
})
addPerk({
    ID = "perk.vp.blessing"
    Script = "scripts/skills/perks/perk_vp_blessing"
    Name = "Благословение"
    Tooltip = "Даёт различные полезные эффекты цели."
    Icon = "perks/perk_vp_blessing.png"
    IconDisabled = "perks/perk_vp_blessing_sw.png"
    Row = 6
})
