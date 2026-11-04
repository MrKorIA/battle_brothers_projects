local locations = ::XBE.Data.AttachedLocationDrafts <- {
    amber_collector_location = ["hackflows/pirate_background"]
    beekeeper_location = []
    blast_furnace_location = ["hackflows/blacksmith_background"]
    brewery_location = ["hackflows/barkeep_background"]
    dye_maker_location = [
        "hackflows/cartographer_background"
        "hackflows/painter_background"
        "hackflows/painter_background"
    ]
    // dye_maker_oriental_location inherits from dye_maker_location
    fishing_huts_location = []
    fishing_huts_oriental_location = []
    fletchers_hut_location = [
        "hackflows/arbalester_background"
        "hackflows/atilliator_background"
        "hackflows/atilliator_background"
        "hackflows/fletcher_background"
        "hackflows/fletcher_background"
        "hackflows/fletcher_background"
    ]

    fortified_outpost_location = [
        "hackflows/arbalester_background"
        "hackflows/arbalester_background"
        "hackflows/bodyguard_background"
        "hackflows/skirmisher_background"
    ]
    gatherers_hut_location = []
    gem_mine_location = ["hackflows/con_artist_background"]
    goat_herd_location = ["hackflows/cook_background"]
    goat_herd_oriental_location = []
    gold_mine_location = []
    guarded_checkpoint_location = [
        "hackflows/arbalester_background"
        "hackflows/bodyguard_background"
        "hackflows/skirmisher_background"
        "hackflows/town_watchman_background"
    ]
    harbor_location = [] // pirate ???
    herbalists_grove_location = [
        "hackflows/gardener_background"
        "hackflows/herbalist_background"
        "hackflows/herbalist_background"
        "hackflows/leper_background"
    ]
    hunters_cabin_location = []
    incense_dryer_location = []
    leather_tanner_location = [
        "hackflows/cobbler_background"
        "hackflows/cobbler_background"
    ]
    militia_trainingcamp_location = []
    militia_trainingcamp_oriental_location = []
    lumber_camp_location = ["hackflows/carpenter_background"]
    mushroom_grove_location = [
        "hackflows/gardener_background"
        "hackflows/herbalist_background"
    ]
    orchard_location = ["hackflows/cook_background"]
    ore_smelters_location = ["hackflows/blacksmith_background"]
    peat_pit_location = ["hackflows/roofer_background"]
    pig_farm_location = ["hackflows/cook_background"]
    plantation_location = []
    salt_mine_location = []
    silk_farm_location = []
    stone_watchtower_location = ["hackflows/arbalester_background"]
    stone_watchtower_oriental_location = []
    surface_copper_vein_location = []
    surface_iron_vein_location = []
    trapper_location = []
    wheat_fields_location = ["hackflows/cook_background"]
    winery_location = []
    wooden_watchtower_location = [
        "hackflows/skirmisher_background"
        "hackflows/town_watchman_background"
        "hackflows/falconer_background"
    ]
    wool_spinner_location = []
    workshop_location = [
        "hackflows/blacksmith_background"
        "hackflows/carpenter_background"
    ]
}

// We defined data on include so that any other mod might change/update this before we patch
::mods_queue(::XBE.ID, "mod_hooks(>=20)", function() {
    ::mods_hookDescendants("entity/world/attached_location", function (cls) {
        // .ClassName is not yet set here on cls, so we set a flag and parse script name in inherit
        cls.hackflows_isAttachedLocation <- true;
    })
    ::mods_addHook("inherit", function (baseScript, script, cls) {
        if (!("hackflows_isAttachedLocation" in cls)) return;

        local name = split(script, "/").top();
        local backgrounds = name in locations ? locations[name] : [];
        if (backgrounds.len() == 0) return;
        // this.logInfo("hx: hook location " + name + " dl=" + ("onUpdateDraftList" in cls));

        local original = "onUpdateDraftList" in cls ? cls.onUpdateDraftList : null;
        cls.onUpdateDraftList <- function (_list) {
            if (original) original(_list);
            if (this.isActive()) _list.extend(backgrounds)
        }
    })
})
