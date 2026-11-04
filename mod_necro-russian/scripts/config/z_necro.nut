::Const.Perks.Necro <- [];

local function addPerk(perk) {
    perk.Unlocks <- perk.Row;
    ::Const.Perks.Necro.push(perk);
    ::Const.Perks.LookupMap[perk.ID] <- perk;
}

local function green(text) {
    return ::Const.UI.getColorized(text + "", ::Const.UI.Color.PositiveValue)
}
local function red(text) {
    return ::Const.UI.getColorized(text + "", ::Const.UI.Color.NegativeValue)
}

addPerk({
    ID = "perk.necro.regeneration"
    Script = "scripts/skills/perks/perk_necro_regeneration"
    Name = "Регенерация нежити"
    Tooltip = "Восстановление не прекращается после поднятия трупа, а продолжается со скоростью "
            + green(10) + " ОЗ за ход."
    Icon = "necro/perk_regeneration.png"
    IconDisabled = "necro/perk_regeneration_sw.png"
    Row = 2
})
addPerk({
    ID = "perk.necro.mastery"
    Script = "scripts/skills/perks/perk_necro_mastery"
    Name = "Некромастерство"
    Tooltip = "Мастер поднятия нежити. Затрачивает на "
            + green("4") + " меньше ОД и на " + green("25%") + " меньше выносливости для поднятия нежити."
    Icon = "necro/perk_mastery.png"
    IconDisabled = "necro/perk_mastery_sw.png"
    Row = 3
})
addPerk({
    ID = "perk.necro.possess"
    Script = "scripts/skills/perks/perk_necro_possess"
    Name = "Власть над нежитью"
    Tooltip = "Позволяет персонажу овладевать поднятой нежитью. Хозяин почувствует, когда его марионетке будет больно."
    Icon = "necro/perk_possess.png"
    IconDisabled = "necro/perk_possess_sw.png"
    Row = 3
})
addPerk({
    ID = "perk.necro.mind_meld"
    Script = "scripts/skills/perks/perk_necro_mind_meld"
    Name = "Слияние разумов"
    Tooltip = "Поделиться некоторыми навыками с поднятой нежитью, а также получите парочку взамен."
    Icon = "necro/perk_mind_meld.png"
    IconDisabled = "necro/perk_mind_meld_sw.png"
    Row = 3
})
addPerk({
    ID = "perk.necro.blood_sucking"
    Script = "scripts/skills/perks/perk_necro_blood_sucking"
    Name = "Кровососы"
    Tooltip = "Наделить свою нежить способностью высасывать кровь."
    Icon = "necro/perk_blood_sucking.png"
    IconDisabled = "necro/perk_blood_sucking_sw.png"
    Row = 4
})
addPerk({
    ID = "perk.necro.range"
    Script = "scripts/skills/perks/perk_necro_range"
    Name = "Некротический охват"
    Tooltip = "Расширить свой некротический охват. Позволяет поднимать нежить в два раза дальше."
    Icon = "necro/perk_range.png"
    IconDisabled = "necro/perk_range_sw.png"
    Row = 5
})
addPerk({
    ID = "perk.necro.flesh_of_iron"
    Script = "scripts/skills/perks/perk_necro_flesh_of_iron"
    Name = "Стальная плоть"
    Tooltip = "Сталь - та же мёртвая материя."
            + " Частично восстанавливает броню при поднятии нежити."
            + "\n\nПродолжает действовать, если у персонажа есть навык 'Регенерация нежити'."
    Icon = "necro/perk_flesh_of_iron.png"
    IconDisabled = "necro/perk_flesh_of_iron_sw.png"
    Row = 5
})
addPerk({
    ID = "perk.necro.soul_link"
    Script = "scripts/skills/perks/perk_necro_soul_link"
    Name = "Связь душ"
    Tooltip = "Позволяет персонажу перенаправлять часть урона на одну из своих марионеток."
            + " Если персонаж близок к смерти, то вместо него умрёт она из марионеток."
    Icon = "necro/perk_soul_link.png"
    IconDisabled = "necro/perk_soul_link_sw.png"
    Row = 6
})
