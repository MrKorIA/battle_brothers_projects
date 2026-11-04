// ::Const.Perks.Demon - perks of the Demonologist background, injected into the perk tree via
// the data_helper hook (see mod_vanilla_plus/hooks/ui/global/data_helper.nut).
//
// The tree splits into two mutually exclusive paths:
//   Path of Blood (magic):  Bloodletting (row 2, gate) -> Bloodlust, Drain Blood, Converter, Summon Demon
//   Path of the Demon (berserk): Demonize (row 3, gate) -> Grip of the Abyss, Masochism, Evil Madness
// Taking the gate perk of one path forever closes the other path. ::Const.Demon.perkBlockReason
// is the single source of truth: it feeds verifyPrerequisites (tooltip lock) and the hard guard
// on player.unlockPerk (see mod_vanilla_plus/hooks/entity/tactical/player.nut).

::Const.Perks.Demon <- [];

local function addPerk(perk) {
    perk.Unlocks <- perk.Row;
    perk.verifyPrerequisites <- function (_player, _tooltip) {
        local reason = ::Const.Demon.perkBlockReason(this.ID, _player.getSkills());
        if (reason == null) return true;
        _tooltip.push({id = 3, type = "hint", icon = "ui/icons/icon_locked.png", text = reason});
        return false;
    }
    ::Const.Perks.Demon.push(perk);
    ::Const.Perks.LookupMap[perk.ID] <- perk;
}

local function green(text) {
    return ::Const.UI.getColorized(text + "", ::Const.UI.Color.PositiveValue)
}
local function red(text) {
    return ::Const.UI.getColorized(text + "", ::Const.UI.Color.NegativeValue)
}

// --- Path of the Demon (berserk) -------------------------------------------
addPerk({
    ID = "perk.vp.demon"
    Script = "scripts/skills/perks/perk_vp_demon"
    Name = "Демонизировать"
    Tooltip = "Обретает огромную силу посредством злого колдовства. Но с большой силой приходит и большая ответственность."
            + "\n" + red("Внимание: выбор этого навыка навсегда закроет \'Путь крови\'.")
    Icon = "perks/perk_vp_demon.png"
    IconDisabled = "perks/perk_vp_demon_sw.png"
    Row = 3
})
addPerk({
    ID = "perk.vp.pull"
    Script = "scripts/skills/perks/perk_vp_pull"
    Name = "Хватка Бездны"
    Tooltip = "Притягивает к себе удалённую вражескую цель и связывает её щупальцами."
            + "\n" + red("Этот навык — часть \'Пути демона\'; ветка несовместима с \'Путём крови\'.")
    Icon = "perks/perk_vp_pull.png"
    IconDisabled = "perks/perk_vp_pull_sw.png"
    Row = 4
})
addPerk({
    ID = "perk.vp.maso"
    Script = "scripts/skills/perks/perk_vp_maso"
    Name = "Мазохизм"
    Tooltip = "Этот персонаж наслаждается собственной болью и становится сильнее по мере получения урона."
            + "\n" + red("Этот навык — часть \'Пути демона\'; ветка несовместима с \'Путём крови\'.")
    Icon = "perks/perk_vp_maso.png"
    IconDisabled = "perks/perk_vp_maso_sw.png"
    Row = 5
})
addPerk({
    ID = "perk.vp.frenzy"
    Script = "scripts/skills/perks/perk_vp_frenzy"
    Name = "Злое безумие"
    Tooltip = "Похищает силу союзников, чтобы стать сильнее. Эффект длится до конца боя."
            + "\n" + red("Этот навык — часть \'Пути демона\'; ветка несовместима с \'Путём крови\'.")
    Icon = "perks/perk_vp_frenzy.png"
    IconDisabled = "perks/perk_vp_frenzy_sw.png"
    Row = 6
})

// --- Path of Blood (magic) ---------------------------------------------------
addPerk({
    ID = "perk.vp.bloodletting"
    Script = "scripts/skills/perks/perk_vp_bloodletting"
    Name = "Кровопускание"
    Tooltip = "Исцеляет себя или союзника с помощью кровопускания."
            + "\n" + red("Внимание: выбор этого навыка навсегда закроет \'Путь демона\'.")
    Icon = "perks/perk_vp_bloodletting.png"
    IconDisabled = "perks/perk_vp_bloodletting_sw.png"
    Row = 2
})
addPerk({
    ID = "perk.vp.bloodlust"
    Script = "scripts/skills/perks/perk_vp_bloodlust"
    Name = "Жажда крови"
    Tooltip = "Увеличивает боевую мощь с помощью жажды крови. Можно использовать на себя или союзников. При применении заклинатель теряет " + red(10) + " здоровья."
            + "\n" + red("Этот навык — часть \'Пути крови\'; ветка несовместима с \'Путём демона\'.")
    Icon = "perks/perk_vp_bloodlust.png"
    IconDisabled = "perks/perk_vp_bloodlust_sw.png"
    Row = 3
})
addPerk({
    ID = "perk.vp.drainblood"
    Script = "scripts/skills/perks/perk_vp_drainblood"
    Name = "Слить кровь"
    Tooltip = "Накладывает заклинание на кровоточащую цель, чтобы нанести урон и восстановить выносливость заклинателя. Эффект усиливается при накоплении кровотечения у цели."
            + "\n" + red("Этот навык — часть \'Пути крови\'; ветка несовместима с \'Путём демона\'.")
    Icon = "perks/perk_vp_drainblood.png"
    IconDisabled = "perks/perk_vp_drainblood_sw.png"
    Row = 4
})
addPerk({
    ID = "perk.vp.counter"
    Script = "scripts/skills/perks/perk_vp_counter"
    Name = "Адаптивный преобразователь"
    Tooltip = "Даёт бонус к максимальной выносливости, навыку ближнего боя и навыку дальнего боя пропорционально защите от дальних атак."
            + "\n" + red("Этот навык — часть \'Пути крови\'; ветка несовместима с \'Путём демона\'.")
    Icon = "perks/perk_vp_counter.png"
    IconDisabled = "perks/perk_vp_counter_sw.png"
    Row = 5
})
addPerk({
    ID = "perk.vp.sumfiend"
    Script = "scripts/skills/perks/perk_vp_sumfiend"
    Name = "Призвать демона"
    Tooltip = "Призывает мощного монстра на ограниченное время."
            + "\n" + red("Этот навык — часть \'Пути крови\'; ветка несовместима с \'Путём демона\'.")
    Icon = "perks/perk_vp_sumfiend.png"
    IconDisabled = "perks/perk_vp_sumfiend_sw.png"
    Row = 6
})

// --- Runtime config: path exclusion ------------------------------------------
::Const.Demon <- {
    GroupPerks = {
        Berserk = ["perk.vp.demon", "perk.vp.pull", "perk.vp.maso", "perk.vp.frenzy"]
        Mage = ["perk.vp.bloodletting", "perk.vp.bloodlust", "perk.vp.drainblood",
                "perk.vp.counter", "perk.vp.sumfiend"]
    }

    // Returns a reason string when _perkID may NOT be taken given the perks _skills
    // already holds, null when it may. Single source of truth for the tooltip lock
    // (verifyPrerequisites above) and the unlockPerk guard in the player hook.
    function perkBlockReason(_perkID, _skills) {
        local has = @(id) _skills.hasSkill(id);
        local hasBerserk = false;
        foreach (id in ::Const.Demon.GroupPerks.Berserk) if (has(id)) { hasBerserk = true; break; }
        local hasMage = false;
        foreach (id in ::Const.Demon.GroupPerks.Mage) if (has(id)) { hasMage = true; break; }

        if (::Const.Demon.GroupPerks.Berserk.find(_perkID) != null)
            return hasMage ? "Закрыто: этот персонаж идёт по \'Пути крови\'" : null;
        if (::Const.Demon.GroupPerks.Mage.find(_perkID) != null)
            return hasBerserk ? "Закрыто: этот персонаж идёт по \'Пути демона\'" : null;
        return null;
    }

    function isPerkBlocked(_perkID, _skills) {
        return ::Const.Demon.perkBlockReason(_perkID, _skills) != null;
    }
}
