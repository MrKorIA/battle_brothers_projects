::Const.Perks.HemovoreMagic <- [];

local function addPerk(perk) {
    perk.Unlocks <- perk.Row;
    ::Const.Perks.HemovoreMagic.push(perk);
    ::Const.Perks.LookupMap[perk.ID] <- perk;
}

::Const.Strings.PerkName.LegendSpawnZombieLow <- "Лепка из падали";
::Const.Strings.PerkName.LegendExtendendAura <- "Губительная аура";
::Const.Strings.PerkName.LegendSpawnZombieMed <- "Сшивание плоти";
::Const.Strings.PerkName.LegendReclamation <- "Жатва костей";
::Const.Strings.PerkName.LegendViolentDecomposition <- "Губительный распад";
::Const.Strings.PerkName.LegendSpawnZombieHigh <- "Венец творения";

::Const.Strings.PerkDescription.LegendSpawnZombieLow <- "Поднимает бесформенного слугу из груды разнородной мёртвой плоти. И пусть этой твари не хватает физической силы или телесной целостности, она будет беспрекословно повиноваться.\n[u]Активная способность:[/u]\nДля призыва требуется пожертвовать [color=" + this.Const.UI.Color.NegativeValue + "]15[/color] ОЗ и использовать [color=" + this.Const.UI.Color.NegativeValue + "]1[/color] человеческую плоть из обоза отряда.\nИзучение этого навыка навсегда увеличивает максимальное ОЗ на [color=" + this.Const.UI.Color.PositiveValue + "]20[/color] единиц.\nДействие стоит [color=" + this.Const.UI.Color.NegativeValue + "]3[/color] ОД и [color=" + this.Const.UI.Color.NegativeValue + "]10[/color] выносливости.";

::Const.Strings.PerkDescription.LegendExtendendAura <- "Подчинитесь тёмной силе, позволив ей сочиться из каждой поры вашего существа. Ныне эта скверна сорвана с привязи, позволяя вам проецировать своё искусство пробуждения мёртвых ещё дальше.\n[u]Пассивная способность:[/u]\nУвеличивает дальность действия всех навыков поднятия мёртвых на одну клетку.";

::Const.Strings.PerkDescription.LegendSpawnZombieMed <- "Анатомически упорядочивает останки перед их оживлением, благодаря чему ваше творение становится гораздо приспособленнее к грядущим трудам. Эта марионетка будет крепче как формой, так и своей мёртвой сутью.\n[u]Активная способность:[/u]\nДля призыва требуется пожертвовать [color=" + this.Const.UI.Color.NegativeValue + "]20[/color] ОЗ и использовать [color=" + this.Const.UI.Color.NegativeValue + "]1[/color] человеческую плоть из обоза отряда.\nИзучение этого навыка мгновенно добавляет [color=" + this.Const.UI.Color.PositiveValue + "]+30[/color] медицинских припасов в ваш инвентарь и увеличивает их максимальный лимит на [color=" + this.Const.UI.Color.PositiveValue + "]+30[/color]\nДействие стоит [color=" + this.Const.UI.Color.NegativeValue + "]4[/color] ОД и [color=" + this.Const.UI.Color.NegativeValue + "]20[/color] выносливости.";

::Const.Strings.PerkDescription.LegendReclamation <- "Пропустите крупицу своей тёмной магии сквозь разлагающуюся плоть павших, дабы извлечь из неё как можно больше ценных ресурсов.\n[u]Пассивная способность:[/u]\nУвеличивает частоту нахождения человеческой падали и человеческих костей в качестве трофеев после боя.";

::Const.Strings.PerkDescription.LegendViolentDecomposition <- "Искажает и перегружает тёмную силу, удерживающую плоть одного из ваших созданных слуг.\n[u]Активная способность:[/u]\nОткрывает навык \'Губительный распад\', который заставляет марионетку разрушительно детонировать после того, как скверна наберёт силу. Заражённый мертвец взрывается в конце своего хода в следующем раунде, нанося урон в радиусе одной клетки. Чем меньше ОЗ осталось у слуги, тем сокрушительнее будет взрыв. Если марионетка будет уничтожена врагом до детонации, эффект рассеется.\nРаботает только на слугах, созданных из трупов.\nДействие стоит [color=%negative%]5[/color] ОД и [color=%negative%]25[/color] выносливости.";

::Const.Strings.PerkDescription.LegendSpawnZombieHigh <- "Сшивает мёртвое тело с такой хирургической точностью, что после оживления его можно принять за живого человека. Настоящий венец творения из плоти и крови, не имеющий равных в своей разрушительной силе.\n[u]Активная способность:[/u]\nДля призыва требуется пожертвовать [color=" + this.Const.UI.Color.NegativeValue + "]30[/color] ОЗ и использовать [color=" + this.Const.UI.Color.NegativeValue + "]1[/color] человеческую плоть из обоза отряда.\nДействие стоит [color=" + this.Const.UI.Color.NegativeValue + "]6[/color] ОД и [color=" + this.Const.UI.Color.NegativeValue + "]25[/color] выносливости.";

addPerk({
    ID = "perk.legend_spawn_zombie_low"
    Script = "scripts/skills/perks/perk_legend_spawn_zombie_low"
	Name = ::Const.Strings.PerkName.LegendSpawnZombieLow
	Tooltip = ::Const.Strings.PerkDescription.LegendSpawnZombieLow
    Icon = "ui/perks/mold_carrion_circle.png"
    IconDisabled = "ui/perks/mold_carrion_circle_bw.png"
    Row = 0
});
addPerk({
    ID = "perk.legend_extended_aura"
    Script = "scripts/skills/perks/perk_legend_extended_aura"
    Name = ::Const.Strings.PerkName.LegendExtendendAura
    Tooltip = ::Const.Strings.PerkDescription.LegendExtendendAura
    Icon = "ui/perks/extended_aura_circle.png"
    IconDisabled = "ui/perks/extended_aura_circle_bw.png"
    Row = 2
});
addPerk({
    ID = "perk.legend_spawn_zombie_med"
    Script = "scripts/skills/perks/perk_legend_spawn_zombie_med"
    Name = ::Const.Strings.PerkName.LegendSpawnZombieMed
    Tooltip = ::Const.Strings.PerkDescription.LegendSpawnZombieMed
    Icon = "ui/perks/fashion_body_circle.png"
    IconDisabled = "ui/perks/fashion_body_circle_bw.png"
    Row = 3
});
addPerk({
    ID = "perk.legend_reclamation"
    Script = "scripts/skills/perks/perk_legend_reclamation"
    Name = ::Const.Strings.PerkName.LegendReclamation
    Tooltip = ::Const.Strings.PerkDescription.LegendReclamation
    Icon = "ui/perks/reclamation_circle.png"
    IconDisabled = "ui/perks/reclamation_circle_bw.png"
    Row = 4
});
addPerk({
    ID = "perk.legend_violent_decomposition"
    Script = "scripts/skills/perks/perk_legend_violent_decomposition"
    Name = ::Const.Strings.PerkName.LegendViolentDecomposition
	Tooltip = ::Const.Strings.PerkDescription.LegendViolentDecomposition
    Icon = "ui/perks/violent_decomposition_circle.png"
    IconDisabled = "ui/perks/violent_decomposition_circle_bw.png"
    Row = 5
});
addPerk({
    ID = "perk.legend_spawn_zombie_high"
    Script = "scripts/skills/perks/perk_legend_spawn_zombie_high"
    Name = ::Const.Strings.PerkName.LegendSpawnZombieHigh
	Tooltip = ::Const.Strings.PerkDescription.LegendSpawnZombieHigh
    Icon = "ui/perks/remake_man_circle.png"
    IconDisabled = "ui/perks/remake_man_circle_bw.png"
    Row = 6
});
