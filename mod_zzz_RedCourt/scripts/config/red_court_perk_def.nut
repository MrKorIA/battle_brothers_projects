::Const.Perks.Vampire <- [];

local function addPerk(perk) {
    perk.Unlocks <- perk.Row;
    ::Const.Perks.Vampire.push(perk);
    ::Const.Perks.LookupMap[perk.ID] <- perk;
}

// new perk names
::Const.Strings.PerkName.VampireAncientWisdom <- "Древняя мудрость";
::Const.Strings.PerkName.VampireMaintenance <- "Уход за оружием";
::Const.Strings.PerkName.VampireDarkflight <- "Тёмный полёт";
::Const.Strings.PerkName.VampireVileWeaponry <- "Мерзкое оружие";
::Const.Strings.PerkName.VampireApexPredator <- "Верховный хищник";
::Const.Strings.PerkName.VampireDemoralise <- "Моральное разложение";

// new perk descriptions
::Const.Strings.PerkDescription.VampireAncientWisdom <- "Получает [color=" + this.Const.UI.Color.PositiveValue + "]+5%[/color] снижения получаемого урона от всех атак за каждый уровень, [color=" + this.Const.UI.Color.NegativeValue + "]вплоть до максимума на 12-ом уровне[/color], в дополнение к текущему снижению урону. Также получает [color=" + this.Const.UI.Color.PositiveValue + "]+30%[/color] к максимальным ОЗ.";

::Const.Strings.PerkDescription.VampireMaintenance <- "Урон от \'древнего оружия\', такого как Хопеш, Бронзовый тесак, Ромфея и прочие, увеличивается на [color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color].\n Кроме того, \'именные\' и \'уникальные\' разновидности данного оружия тратят на [color=" + this.Const.UI.Color.PositiveValue + "]-5[/color] меньше выносливости на атаки.\n Всё экипированное древнее оружие восстанавливает свою прочность на [color=" + this.Const.UI.Color.PositiveValue + "]+3-5[/color] за каждый смертельный удар.";

::Const.Strings.PerkDescription.VampireDarkflight <- "Позволяет преодолеть расстояние в [color=" + this.Const.UI.Color.PositiveValue + "]4[/color] клетки без штрафа за рельеф местности.\n [color=" + this.Const.UI.Color.NegativeValue + "]Целевая клетка должна быть свободна и открыта.[/color]\n Уменьшает решимость любого врага поблизости на [color=" + this.Const.UI.Color.NegativeValue + "]-5[/color]. Эффект суммируется со схожими типами эффектов.";

::Const.Strings.PerkDescription.VampireVileWeaponry <- "При успешном попадании по кровоточащему врагу наносит яд, который снижает его навыки ближнего и дальнего боя на [color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color], а инициативу на [color=" + this.Const.UI.Color.NegativeValue + "]-10[/color] за каждое попадание. Эффект суммируется, но быстро пропадает.";

::Const.Strings.PerkDescription.VampireApexPredator <- "В ночном бою даёт [color=" + this.Const.UI.Color.PositiveValue + "]+5[/color] к восстановлению выносливости за ход, [color=" + this.Const.UI.Color.PositiveValue + "]+2[/color] к обзору, [color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] к навыку ближнего боя, [color=" + this.Const.UI.Color.PositiveValue + "]+15%[/color] к защите в ближнем бою и [color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] к навыку дальнего боя.\n\n [color=" + this.Const.UI.Color.NegativeValue + "]Не действует днём.[/color]";

::Const.Strings.PerkDescription.VampireDemoralise <- "Позволяет провести атаку по решимости противника. Если атака удалась, то враг потеряет решимость и будет оглушён на 1 ход.\n [color=" + this.Const.UI.Color.NegativeValue + "]Использует навык дальнего боя для попадания и не действует на существ, которые не могут убежать.[/color]";

addPerk({
    ID = "perk.vampire_ancient_wisdom"
    Script = "scripts/skills/perks/perk_vampire_ancient_wisdom"
	Name = ::Const.Strings.PerkName.VampireAncientWisdom
	Tooltip = ::Const.Strings.PerkDescription.VampireAncientWisdom
    Icon = "ui/perks/vampire_ancient_wisdom.png"
    IconDisabled = "ui/perks/vampire_ancient_wisdom_bw.png"
    Row = 1
});
addPerk({
    ID = "perk.vampire_apex_predator"
    Script = "scripts/skills/perks/perk_vampire_apex_predator"
    Name = ::Const.Strings.PerkName.VampireApexPredator
    Tooltip = ::Const.Strings.PerkDescription.VampireApexPredator
    Icon = "ui/perks/vampire_apex_predator.png"
    IconDisabled = "ui/perks/vampire_apex_predator_bw.png"
    Row = 6
});
addPerk({
    ID = "perk.vampire_maintenance"
    Script = "scripts/skills/perks/perk_vampire_maintenance"
    Name = ::Const.Strings.PerkName.VampireMaintenance
    Tooltip = ::Const.Strings.PerkDescription.VampireMaintenance
    Icon = "ui/perks/vampire_maintenance.png"
    IconDisabled = "ui/perks/vampire_maintenance_bw.png"
    Row = 2
});
addPerk({
    ID = "perk.vampire_vile_weaponry"
    Script = "scripts/skills/perks/perk_vampire_vile_weaponry"
    Name = ::Const.Strings.PerkName.VampireVileWeaponry
    Tooltip = ::Const.Strings.PerkDescription.VampireVileWeaponry
    Icon = "ui/perks/vampire_vile_weaponry.png"
    IconDisabled = "ui/perks/vampire_vile_weaponry_bw.png"
    Row = 5
});
addPerk({
    ID = "perk.vampire_darkflight"
    Script = "scripts/skills/perks/perk_vampire_darkflight"
    Name = ::Const.Strings.PerkName.VampireDarkflight
	Tooltip = ::Const.Strings.PerkDescription.VampireDarkflight
    Icon = "ui/perks/vampire_darkflight.png"
    IconDisabled = "ui/perks/vampire_darkflight_bw.png"
    Row = 4
});
//addPerk({
//    ID = "perk.vampire_demoralise"
//    Script = "scripts/skills/perks/perk_vampire_demoralise"
//    Name = ::Const.Strings.PerkName.VampireDemoralise
//    Tooltip = ::Const.Strings.PerkDescription.VampireDemoralise
//    Icon = "ui/perks/vampire_demoralise.png"
//    IconDisabled = "ui/perks/vampire_demoralise_bw.png"
//    Row = 7
//})