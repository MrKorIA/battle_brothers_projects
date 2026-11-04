// ::Const.Perks.Druid - Druid-only perks, injected into the perk tree for the background.
// ::Const.Druid - Druid runtime config: beast pools, group exclusion rules, Beastform/Rage tunables.
//
// The tree splits into two mutually exclusive groups (see docs/beast-branch/plan.md):
//   Nature: Regrowth, Hatch, Entangling Roots, Greater Beasts
//   Beast:  Beastform (gate) -> Beast Aura, Beast Rage
//   Venom:  ungrouped, adapts to whichever side you commit to
// The group is chosen implicitly by the first group perk taken; ::Const.Druid.isPerkBlocked
// enforces the exclusion (see mod_druid.nut for where it is consulted).

::Const.Perks.Druid <- [];

local function addPerk(perk) {
    perk.Unlocks <- perk.Row;
    // DPF's native lock: its isPerkUnlockable consults this and the perk tooltip shows the
    // reason. Without DPF nothing calls it; the druid_blocked path in mod_druid.nut applies.
    perk.verifyPrerequisites <- function (_player, _tooltip) {
        local reason = ::Const.Druid.perkBlockReason(this.ID, _player.getSkills());
        if (reason == null) return true;
        _tooltip.push({id = 3, type = "hint", icon = "ui/icons/icon_locked.png", text = reason});
        return false;
    }
    ::Const.Perks.Druid.push(perk);
    ::Const.Perks.LookupMap[perk.ID] <- perk;
}

local function green(text) {
    return ::Const.UI.getColorized(text + "", ::Const.UI.Color.PositiveValue)
}
local function red(text) {
    return ::Const.UI.getColorized(text + "", ::Const.UI.Color.NegativeValue)
}

// --- Nature group ----------------------------------------------------------
addPerk({
    ID = "perk.druid.regrowth"
    Script = "scripts/skills/perks/perk_druid_regrowth"
    Name = "Живица"
    Tooltip = "Затягивает раны соратника, восстанавливая по " + green(10) + " ОЗ за ход. На зверей эта магия действует в двойном объёме. На цель может быть наложено не более одного эффекта \'Живицы\' одновременно."
            + "\n" + red("Внимание: выбор этого навыка навсегда закроет \'Путь зверя\'.")

    Icon = "druid/perk_regrowth.png"
    IconDisabled = "druid/perk_regrowth_sw.png"
    Row = 1
})
addPerk({
    ID = "perk.druid.hatch"
    Script = "scripts/skills/perks/perk_druid_hatch"
    Name = "Выводок"
    Tooltip = "Снимает ограничение на одно использование способности \'Призыв зверя\' за бой. Друид восстанавливает дополнительный заряд призыва " + green("каждый третий ход") + "."
            + "\n" + red("Внимание: выбор этого навыка навсегда закроет \'Путь зверя\'.")
    Icon = "druid/perk_hatch.png"
    IconDisabled = "druid/perk_hatch_sw.png"
    Row = 3
})
addPerk({
    ID = "perk.druid.entangle"
    Script = "scripts/skills/perks/perk_druid_entangle"
    Name = "Оплетающие корни"
    Tooltip = "Призывает оплетающие корни, которые намертво опутывают врагов и лишают их возможности двигаться."
            + "\n" + red("Внимание: выбор этого навыка навсегда закроет \'Путь зверя\'.")
    Icon = "druid/perk_entangle.png"
    IconDisabled = "druid/perk_entangle_sw.png"
    Row = 4
})
addPerk({
    ID = "perk.druid.apex"
    Script = "scripts/skills/perks/perk_druid_apex"
    Name = "Грозные твари"
    Tooltip = "Способность \'Призыв зверя\' теперь достигает слуха самых опасных хищников. Лютоволки и гиены являются на зов охваченными бешенством, а прочие лесные монстры приходят крупнее и свирепее."
            + "\n" + red("Внимание: выбор этого навыка навсегда закроет \'Путь зверя\'.")
    Icon = "druid/perk_apex.png"
    IconDisabled = "druid/perk_apex_sw.png"
    Row = 6
})

// --- Beast group -----------------------------------------------------------
addPerk({
    ID = "perk.druid.beastform"
    Script = "scripts/skills/perks/perk_druid_beastform"
    Name = "Звериный облик"
    Tooltip = "Навсегда принимает облик зверя: " + green("+10% к навыкам атаки и защиты в ближнем бою")
            + " и " + green("+20% ОЗ") + "."
            + " Но друид больше не сможете носить тяжёлые щиты, шлемы и броню, а также пользоваться дальнобойным оружием."
            + "\n" + red("Внимание: выбор этого навыка навсегда закроет \'Путь природы\'.")
    Icon = "druid/perk_beastform.png"
    IconDisabled = "druid/perk_beastform_sw.png"
    Row = 1
})
addPerk({
    ID = "perk.druid.beast_aura"
    Script = "scripts/skills/perks/perk_druid_beast_aura"
    Name = "Аура зверя"
    Tooltip = "Звери признают в вас вожака. Они держатся рядом, ведут себя уверенно и не бегут, пока вы близко."
    Icon = "druid/perk_beast_aura.png"
    IconDisabled = "druid/perk_beast_aura_sw.png"
    Row = 3
})
addPerk({
    ID = "perk.druid.beast_rage"
    Script = "scripts/skills/perks/perk_druid_beast_rage"
    Name = "Ярость зверя"
    Tooltip = "Кровь питает растущую ярость: накапливает урон в ближнем бою, решимость,"
            + " " + green("регенерацию") + " и восстановление выносливости - ценой защиты. На пике вы отбрасываете щит и издаёте рык."
            + "\n" + red("Взяв этот навык, вы закроете для изучения навык \'Яд\'.")
    Name = "Ярость зверя"
    Tooltip = "Пролитая кровь подпитывает вашу первобытную ярость. Каждый удар в бою увеличивает урон в ближнем бою и решимость, повышает " + green("регенерацию ОЗ")
            + " и восстановление выносливости - но ценой снижения защиты. На пике этого безумия друид яростно отбрасывает щит и издаёт устрашающий рык."
            + "\n" + red("Внимание: выбор этого навыка навсегда закроет для изучения навык \'Яд\'.")
    Icon = "druid/perk_beast_rage.png"
    IconDisabled = "druid/perk_beast_rage_sw.png"
    Row = 5
})

// --- Ungrouped -------------------------------------------------------------
addPerk({
    ID = "perk.druid.venom"
    Script = "scripts/skills/perks/perk_druid_venom"
    Name = "Яд"
    Tooltip = "Укус ваших зверей теперь несёт в себе коварный токсин, который затуманивает врагу зрение и замедляет его движения. Если друид принимает звериный облик, то этот смертоносный яд получает он сам, а не призванные звери."
            + "\n" + red("Внимание: выбор этого навыка навсегда закроет для изучения навык \'Ярость зверя\'.")
    Icon = "druid/perk_venom.png"
    IconDisabled = "druid/perk_venom_sw.png"
    Row = 5
})


local T = ::Const.World.TerrainType;
::Const.Druid <- {
    // Beast pools per battlefield. Values are enemy entity script base names under
    // scripts/entity/tactical/enemies/. A low-level call mostly yields a plain Wolf, the biome
    // pool creeping in as the druid grows (see wolfChance() and druid_summon_beast.onUse). Apex
    // upgrades these per ApexMap.
    Biomes = {
        // The plain Wolf the wilds answer with early on; the biome variety (direwolf, spider,
        // schrat...) creeps in as the druid grows - see wolfChance() and druid_summon_beast.onUse.
        Starter = "wolf"

        Pools = {
            [T.Snow] = ["direwolf"],
            [T.SnowyForest] = ["direwolf"],
            [T.Tundra] = ["direwolf"],
            [T.Plains] = ["direwolf", "spider"],
            [T.Farmland] = ["direwolf", "spider"],
            [T.Forest] = ["direwolf", "spider", "schrat_small"],
            [T.LeaveForest] = ["direwolf", "spider", "schrat_small"],
            [T.AutumnForest] = ["direwolf", "spider", "schrat_small"],
            [T.Steppe] = ["direwolf", "hyena"],
            [T.Desert] = ["hyena", "serpent"],
            [T.Oasis] = ["hyena", "serpent"],
            [T.Swamp] = ["spider", "serpent"],
            [T.Hills] = ["direwolf", "hyena"],
            [T.Mountains] = ["direwolf", "hyena"],
            [T.Badlands] = ["direwolf", "hyena"],
        }
        Default = ["direwolf"]
        ApexMap = {
            direwolf = "direwolf_high"
            hyena = "hyena_high"
            // Beasts with no entry here (spider, schrat_small, serpent) are grown in place
            // by druid_summon_beast.makeApex() instead of swapping to another entity.
        }
    }

    // Beastform tunables (balance pass Q5 - see plan.md). Equipment limits read an item's
    // fatigue penalty magnitude (-getStaminaModifier); a light shield/buckler stays allowed.
    Beastform = {
        MeleeSkillMult = 1.1
        MeleeDefenseMult = 1.1
        HitpointsMult = 1.2
        ShieldFatigueMax = 10
        HelmetFatigueMax = 10
        BodyFatigueMax = 20
    }

    // Beast Rage tunables (Q5). Like Reforged's perk_rf_feral_rage but damage reduction is
    // swapped for per-stack hitpoint regen, with an extra stack granted on a melee miss.
    // TODO: move to rage file
    Rage = {
        PerStackHpRegen = 2
        PerStackMaxHp = 2
        PerStackDamagePct = 2
        PerStackResolve = 2
        PerStackInitiative = 2
        PerStackMeleeDefense = -1
        StacksPerTurn = -3
        ShieldDropThreshold = 10
        // A beast's death stokes the rage: hard for the druid's own kin, a flicker for any other
        // allied beast that falls (see the actor.onDeath hook in mod_druid).
        OwnBeastDeath = 3
        AllyBeastDeath = 1
    }

    // Beast Aura tunables (Q5).
    Aura = {
        Range = 2
        Resolve = 10
        // The leash: the druid's beasts carry ai_protect (onBeastJoinedPack) and he reads as a VIP
        // (TargetAttractionMult > 1.0), so they cluster to guard him instead of charging off. The
        // side cost is drawing more enemy eyes, kept modest at 2.0.
        TargetAttractionMult = 2.0
    }

    // The Wolf-and-the-Bear origin walks the wild paths: its band slips quicker through the trees
    // and sees farther beneath the canopy. Scenario-only - see the world hooks in mod_druid.
    Forest = {
        SpeedMult = 1.6 // 0.64 is base for forests, 0.64 * 1.6 is a little bit over 1.0
        VisionMult = 1.4
        Terrain = {
            [T.Forest] = true,
            [T.SnowyForest] = true,
            [T.LeaveForest] = true,
            [T.AutumnForest] = true,
        }
    }

    GroupPerks = {
        Nature = ["perk.druid.regrowth", "perk.druid.hatch", "perk.druid.entangle",
                  "perk.druid.apex"]
        Beast = ["perk.druid.beastform", "perk.druid.beast_aura", "perk.druid.beast_rage"]
    }

    // The implicit-group exclusion rule. Returns a reason string when _perkID may NOT be taken
    // given the perks _skills already holds, null when it may. Single source of truth: feeds
    // verifyPrerequisites (DPF lock + tooltip), the data_helper UI gate and the unlock guard
    // (player.unlockPerk) via isPerkBlocked.
    function perkBlockReason(_perkID, _skills) {
        local has = @(id) _skills.hasSkill(id);
        local hasNature = false;
        foreach (id in ::Const.Druid.GroupPerks.Nature) if (has(id)) { hasNature = true; break; }
        local hasBeastform = has("perk.druid.beastform");

        switch (_perkID) {
        case "perk.druid.regrowth":
        case "perk.druid.hatch":
        case "perk.druid.entangle":
        case "perk.druid.apex":
            // Nature perks closed once you turn Beast
            return hasBeastform ? "Закрыто: этот персонаж идёт по \'Пути зверя\'" : null;
        case "perk.druid.beastform":
            // Beastform closed once you took any Nature perk
            return hasNature ? "Закрыто: этот персонаж идёт по \'Пути природы\'" : null;
        case "perk.druid.beast_aura":
            return hasBeastform ? null : "Закрыто: требуется навык \'Звериный облик\'";
        case "perk.druid.beast_rage":
            if (!hasBeastform) return "Закрыто: требуется \'Звериный облик\'";
            return has("perk.druid.venom") ? "Закрыто: навыки \'Яд\' и \'Ярость зверя\' несовместимы" : null;
        case "perk.druid.venom":
            return has("perk.druid.beast_rage") ? "Закрыто: навыки \'Яд\' и \'Ярость зверя\' несовместимы" : null;
        }
        return null;
    }

    function isPerkBlocked(_perkID, _skills) {
        return ::Const.Druid.perkBlockReason(_perkID, _skills) != null;
    }

    // Whether a Beastform druid may equip _item. Heavy shields/helmets/armor and any ranged
    // weapon are forbidden; a light shield (buckler) under the fatigue cap stays allowed.
    function beastformAllows(_item) {
        local IT = ::Const.Items.ItemType;
        if (_item.isItemType(IT.RangedWeapon)) return false;
        local fatigue = -_item.getStaminaModifier();  // penalties are stored negative
        local B = ::Const.Druid.Beastform;
        if (_item.isItemType(IT.Shield) && fatigue > B.ShieldFatigueMax) return false;
        if (_item.isItemType(IT.Helmet) && fatigue > B.HelmetFatigueMax) return false;
        if (_item.isItemType(IT.Armor)  && fatigue > B.BodyFatigueMax)   return false;
        return true;
    }

    // Chance (percent) a summon answers as a plain Wolf rather than a biome beast, by druid level.
    // The wild variety creeps in as he grows; Apex drives this to 0 (see druid_summon_beast.onUse),
    // so every call then brings a greater beast.
    function wolfChance(_level)
    {
        if (_level <= 3) return 95;
        if (_level == 4) return 85;
        if (_level == 5) return 50;
        if (_level == 6) return 15;
        if (_level == 7) return 10;
        return 5;
    }

    function isAnimal(_actor)
    {
        if (_actor.getFaction() == ::Const.Faction.PlayerAnimals) return true;

        local t = _actor.getType();
        if (::Const.EntityType.getDefaultFaction(t) == ::Const.FactionType.Beasts) return true;

        switch (t)
        {
        case ::Const.EntityType.Wardog:
        case ::Const.EntityType.ArmoredWardog:
        case ::Const.EntityType.Warhound:
        case ::Const.EntityType.Wolf:
        case ::Const.EntityType.BarbarianUnhold:
        case ::Const.EntityType.BarbarianUnholdFrost:
            return true;
        }

        return false;
    }
}
