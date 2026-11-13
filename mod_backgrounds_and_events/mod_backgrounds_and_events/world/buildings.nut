// These are accessible globally to make them editable by other mods
local buildings = ::XBE.Data.BuildingDrafts <- {
    alchemist_building = []
    arena_building = [
        "gladiator_background"
        "gladiator_background"
        "gladiator_background"
        "paladin_background" // oathtaker
        "hackflows/folk_hero_background"
        "hackflows/champion_background"
        "hackflows/myrmidon_background"
        "hackflows/myrmidon_background"
        "hackflows/myrmidon_background"
        "hackflows/bounty_hunter_background"
        "hackflows/bounty_hunter_background"
        "hackflows/berserker_background"
        "hackflows/berserker_background"
        "hackflows/lancer_background"
        "hackflows/lancer_background"
    ]
    armorsmith_building = [
        "hackflows/blacksmith_background"
        "hackflows/blacksmith_background"
    ]
    // armorsmith_oriental_building inherits from armorsmith_building
    barber_building = []
    fletcher_building = [
        "hackflows/atilliator_background"
        "hackflows/fletcher_background"
    ]
    kennel_building = []
    marketplace_building = []
    // marketplace_oriental_building inherits from marketplace_building
    port_building = [
        "hackflows/pirate_background"
        "hackflows/pirate_background"
        "hackflows/outlander_background"
        "hackflows/outlander_background"
    ]
    // port_oriental_building inherits from port_building
    tavern_building = [
        "hackflows/barkeep_background"
        "hackflows/barkeep_background"
        "hackflows/con_artist_background"
        "hackflows/drifter_background"
    ]
    taxidermist_building = []
    // taxidermist_oriental_building inherits from taxidermist_building
    temple_building = [
        "hackflows/herbalist_background"
        "hackflows/leper_background"
    ]
    // temple_oriental_building inherits from temple_building
    training_hall_building = [
        "hackflows/bounty_hunter_background"
        "hackflows/bounty_hunter_background"
        "hackflows/bounty_hunter_background"
        "hackflows/lancer_background"
        "hackflows/lancer_background"
        "hackflows/champion_background"
        "hackflows/master_archer_background"
        "hackflows/bodyguard_background"
    ]
    weaponsmith_building = [
        "hackflows/blacksmith_background"
        "hackflows/blacksmith_background"
    ]
    // weaponsmith_oriental_building inherits from weaponsmith_building
}
// std.Debug.log("buildings", buildings);

::mods_queue(::XBE.ID, "mod_hooks(>=20)", function() {
    ::mods_hookDescendants("entity/world/settlements/buildings/building", function (cls) {
        // .ClassName is not yet set here on cls, so we set a flag and parse script name in inherit
        cls.hackflows_isBuilding <- true;
    })
    ::mods_addHook("inherit", function (baseScript, script, cls) {
        if (!("hackflows_isBuilding" in cls)) return;

        local name = split(script, "/").top();
        local backgrounds = name in buildings ? buildings[name] : [];
        if (backgrounds.len() == 0) return;
        // this.logInfo("hx: hook building " + name + " dl=" + ("onUpdateDraftList" in cls));

        local original = "onUpdateDraftList" in cls ? cls.onUpdateDraftList : null;
        cls.onUpdateDraftList <- function (_list) {
            if (original) original(_list);
            _list.extend(backgrounds)
            // if (cls.ClassName == "arena_building") ::std.Debug.log("drafts", _list);
        }
    })
})
