::Const.Perks.RetiredGladiatorTree <- [];
::Const.Perks.RetiredGladiatorTreeLight <- [];

local function addPerkToRetiredGladiatorTree(perk) {
    ::Const.Perks.RetiredGladiatorTree.push(perk);
    perk.Unlocks <- perk.Row;
    ::Const.Perks.LookupMap[perk.ID] <- perk;
}

local function addPerkToRetiredGladiatorTreeLight(perk) {
    addPerkToRetiredGladiatorTree(perk);
    ::Const.Perks.RetiredGladiatorTreeLight.push(perk);
}

// new perk names
::Const.Strings.PerkName.RetGladPath <- "Путь Златоликого"; //grants bonuses based on if the brother is holding a 'southern' weapon or not.
::Const.Strings.PerkName.RetGladPreciseStrikes <- "Точные удары"; //netted, rooted or distracted targets have a chance to 'cripple' when hit.
::Const.Strings.PerkName.RetGladRapidAdvance <- "Быстрое продвижение"; //all fatigue costs are reduced for every point over 65.
::Const.Strings.PerkName.RetGladStoic <- "Стоик"; //When activated, ignore all current injury effects you have accumulated and reduce damage you take by 40% for 3 turns. Negitive effects last 1 turn less.
::Const.Strings.PerkName.RetGladMentor <- "Наставник"; //Unlocks new events.

// new perk descriptions
::Const.Strings.PerkDescription.RetGladPath <- "Многие ошибки совершаются по незнанию, нынешние бойцы испорчены грубостью северного оружия - и лишь усердная учёба исправит это.\n\nПри использовании южного оружия ближнего или дальнего боя персонаж получает [color=" + ::Const.UI.Color.PositiveValue + "]+5%[/color] к наносимому урону, [color=" + ::Const.UI.Color.PositiveValue + "]+10%[/color] к урону по броне и [color=" + ::Const.UI.Color.PositiveValue + "]+10%[/color] к получаемому опыту. Использование именного или уникального оружия южного происхождения усиливает эти эффекты. [color=" + ::Const.UI.Color.NegativeValue + "]Не действует на щиты и предметы во второй руке.[/color]";

::Const.Strings.PerkDescription.RetGladPreciseStrikes <- "Никогда не ждите, что плохие люди освободят вас от своего разрушительного влияния. Каждое преимущество, которое у вас есть, должно быть использовано.\n\nКогда персонаж атакует врага в сетях, паутине, корнях или отвлечённого брошенной грязью, добавляется уровень эффекта [color=" + ::Const.UI.Color.PositiveValue + "]'Калека'[/color], который уменьшает наносимый и получаемый целью урон на 5% за каждый уровень эффекта.";

::Const.Strings.PerkDescription.RetGladRapidAdvance <- "В любое время важно сохранять самоконтроль. Жизнь коротка, в конце концов.\n\nВсе затраты выносливости снижаются за каждую единицу [color=" + ::Const.UI.Color.PositiveValue + "]текущего[/color] показателя инициативы сверх [color=" + ::Const.UI.Color.PositiveValue + "]65[/color]. Чем выше инициатива персонажа, тем больше пользы. Если инициатива ниже этого значения, то навык не действует.";

::Const.Strings.PerkDescription.RetGladStoic <- "Вас могут ранить, лишь если вы позволите это.\n\nПри включении способности персонаж получает невосприимчивость к эффектам свежих ран, [color=" + ::Const.UI.Color.PositiveValue + "]+60%[/color] к сопротивлению урону, кроме того уменьшается длительность всех негативных эффектов на 1 ход. Эта способность длится 1 ход.";

::Const.Strings.PerkDescription.RetGladMentor <- "Вы уже мертвы - осталось лишь верно распорядиться остатками своей жизни.\n\nВзяв этот навык, персонаж получит доступ к событиям, позволяющим обращать непрощённых вашего отряда в гладиаторов и улучшить самих гладиаторов.";

addPerkToRetiredGladiatorTreeLight({
    ID = "perk.retglad_path"
    Script = "scripts/skills/perks/perk_retglad_path"
	Name = ::Const.Strings.PerkName.RetGladPath
	Tooltip = ::Const.Strings.PerkDescription.RetGladPath
    Icon = "ui/perks/perk_mentor.png"
    IconDisabled = "ui/perks/perk_mentor_bw.png"
    Row = 1
});
addPerkToRetiredGladiatorTreeLight({
    ID = "perk.retglad_precise_strikes"
    Script = "scripts/skills/perks/perk_retglad_precise_strikes"
	Name = ::Const.Strings.PerkName.RetGladPreciseStrikes
	Tooltip = ::Const.Strings.PerkDescription.RetGladPreciseStrikes
    Icon = "ui/perks/perk_precise_strikes.png"
    IconDisabled = "ui/perks/perk_precise_strikes_bw.png"
    Row = 3
});
addPerkToRetiredGladiatorTreeLight({
    ID = "perk.retglad_rapid_advance"
    Script = "scripts/skills/perks/perk_retglad_rapid_advance"
	Name = ::Const.Strings.PerkName.RetGladRapidAdvance
	Tooltip = ::Const.Strings.PerkDescription.RetGladRapidAdvance
    Icon = "ui/perks/perk_rapid_advance.png"
    IconDisabled = "ui/perks/perk_rapid_advance_bw.png"
    Row = 4
});
addPerkToRetiredGladiatorTreeLight({
    ID = "perk.retglad_stoic"
    Script = "scripts/skills/perks/perk_retglad_stoic"
	Name = ::Const.Strings.PerkName.RetGladStoic
	Tooltip = ::Const.Strings.PerkDescription.RetGladStoic
    Icon = "ui/perks/perk_stoic.png"
    IconDisabled = "ui/perks/perk_stoic_bw.png"
    Row = 5
});
addPerkToRetiredGladiatorTree({
    ID = "perk.retglad_mentor"
    Script = "scripts/skills/perks/perk_retglad_mentor"
	Name = ::Const.Strings.PerkName.RetGladMentor
	Tooltip = ::Const.Strings.PerkDescription.RetGladMentor
    Icon = "ui/perks/perk_retired.png"
    IconDisabled = "ui/perks/perk_retired_bw.png"
    Row = 6
});
