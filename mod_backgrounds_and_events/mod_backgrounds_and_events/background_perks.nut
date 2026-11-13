if (!::mods_getRegisteredMod("mod_background_perks")) return;

local chances = {
    arbalester = {
        "mastery.crossbow": 50
        "bullseye": 20
        "coup_de_grace": 20
    }

    atilliator = {
        "mastery.crossbow": 25
        "bullseye": 18
        "anticipation": 10
    }

    barkeep = {
        "hold_out": 30
        "steel_brow": 15
        "brawny": 15
        "quick_hands": 7
    }

    berserker = {
        "berserk": 100
        "indomitable": 10
        "killing_frenzy": 10
        "hackflows.battle_flow": 20
        "hackflows.full_force": 5
    }

    blacksmith = {
        "mastery.hammer": 70
        "brawny": 30
        "student": 5
        "hackflows.full_force": 5
    }

    bodyguard = {
        "shield_expert": 100
        "taunt": 50
        "brawny": 50
        "hackflows.balance": 33
    }

    bounty_hunter = {
        "lone_wolf": 50
        "head_hunter": 20
        "quick_hands": 50
        "mastery.sword": 8
        "mastery.mace": 8
        "mastery.flail": 8
        "mastery.crossbow": 8
        "mastery.throwing": 8
        "hackflows.stabilized": 12
        "backstabber": 1
    }

    carpenter = {
        "mastery.hammer": 18
        "mastery.axe": 12
        "quick_hands": 10
        "student": 5
    }

    cartographer = {
        "student": 80
        "gifted": 10
        "anticipation": 20
    }

    champion = {
        "indomitable": 10
        "fortified_mind": 10
        "steel_brow": 10
        "hold_out": 10
        "battle_forged": 5
        "brawny": 10
        "fearsome": 50
        "hackflows.bloody_harvest": 10

        "mastery.axe": 25
        "mastery.mace": 25
        "mastery.flail": 25
        "mastery.sword": 25
    }

    cobbler = {
        "footwork": 33
        "quick_hands": 20
        "fast_adaption": 15
        "student": 5
    }

    con_artist = {
        "quick_hands": 30
        "taunt": 30
        "footwork": 15
        "fast_adaption": 15
        "hackflows.balance": 15
        "backstabber": 3
    }

    cook = {
        "mastery.dagger": 30
        "bags_and_belts": 30
        "underdog": 30
    }

    dissenter = {
        "fortified_mind": 40
        "anticipation": 5
        "rally_the_troops": 15
    }

    drifter = {
        "pathfinder": 50
        "footwork": 10
        "recover": 5
    }

    druid = {
        "pathfinder": 33
        "fortified_mind": 33
        "hackflows.flesh_on_the_bones": 50
    }

    falconer = {
        "bullseye": 5
        "pathfinder": 20
        "quick_hands": 10
    }

    fletcher = {
        "mastery.bow": 5
        "mastery.crossbow": 5
        "bullseye": 5
    }

    folk_hero = {
        "colossus": 30
        "brawny": 30
        "underdog": 20
        "hackflows.flesh_on_the_bones": 20
        "relentless": 20
        "rally_the_troops": 10
        "gifted": 5
    }

    gardener = {
        "pathfinder": 5
        "underdog": 20
        "bags_and_belts": 20
        "mastery.axe": 3
    }

    hangman = {
        "hold_out": 20
        "steel_brow": 20
        "coup_de_grace": 30
        "nine_lives": 20
    }

    herbalist = {
        "bags_and_belts": 50
        "student": 25
        "pathfinder": 15
    }

    lancer = {
        "mastery.spear": 100
        "mastery.polearm": 100
        "rotation": 40
        "footwork": 20
    }

    // This one is intentionally useless
    leper = {
        "colossus": 5
        "nine_lives": 5
        "hackflows.flesh_on_the_bones": 5
    }

    locksmith = {
        "quick_hands": 100
        "fast_adaption": 33
        "hackflows.balance": 33
    }

    master_archer = {
        "mastery.bow": 100
        "bullseye": 50
    }

    myrmidon = {
        "relentless": 50
        "mastery.dagger": 20
        "mastery.sword": 20
        "hackflows.stabilized": 10
        "duelist": 5
    }

    outlander = {
        "mastery.sword": 5
        "duelist": 50
        "crippling_strikes": 30
        "coup_de_grace": 20
    }

    painter = {
        "student": 20
        "gifted": 20
        "quick_hands": 10
        "lone_wolf": 10
    }

    pirate = {
        "fearsome": 50
        "overwhelm": 50
        "killing_frenzy": 5
        "nine_lives": 3
        "hackflows.flesh_on_the_bones": 2
    }

    roofer = {
        "hackflows.balance": 33
        "footwork": 20
        "recover": 10
    }

    skirmisher = {
        "mastery.throwing": 25
        "shield_expert": 33
        "anticipation": 10
        "footwork": 33
        "overwhelm": 10
        "hackflows.balance": 10
    }

    surgeon = {
        "quick_hands": 50
        "fortified_mind": 33
        "student": 10
    }

    torturer = {
        "crippling_strikes": 40
        "coup_de_grace": 30
        "mastery.cleaver": 10
        "mastery.flail": 5
        "mastery.dagger": 5
    }

    town_watchman = {
        "anticipation": 50
        "rotation": 50
    }

    paladin_commander = ::BgPerks.chances.paladin
}

foreach (key, value in chances) {
    ::BgPerks.chances["hackflows_" + key] <- value;
}
