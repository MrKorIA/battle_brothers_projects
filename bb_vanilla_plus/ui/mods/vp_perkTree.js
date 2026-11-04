//var VanillaPlusPerkTree = {};
//
//VanillaPlusPerkTree.CharacterScreenPerksModule_loadPerkTreesWithBrotherData
//    = CharacterScreenPerksModule.prototype.loadPerkTreesWithBrotherData;
//
//CharacterScreenPerksModule.prototype.loadPerkTreesWithBrotherData = function (_brother) {
//
//    if (_brother !== null && 'vp_perkTree' in _brother && _brother.vp_perkTree !== null) {
//        this.resetPerkTree(this.mPerkTree);
//        this.onPerkTreeLoaded(null, _brother.vp_perkTree);
//    }
//    VanillaPlusPerkTree.CharacterScreenPerksModule_loadPerkTreesWithBrotherData.call(this, _brother);
//};
var VanillaPlusPerkTree = {};

VanillaPlusPerkTree.CharacterScreenPerksModule_loadPerkTreesWithBrotherData
    = CharacterScreenPerksModule.prototype.loadPerkTreesWithBrotherData;
CharacterScreenPerksModule.prototype.loadPerkTreesWithBrotherData = function (_brother) {
//     console.error("brother = " + JSON.stringify(_brother.vp_perkTree));
    if (_brother.vp_perkTree) {
//    console.error("brother = if");
        this.resetPerkTree(this.mPerkTree);
        this.onPerkTreeLoaded(null, _brother.vp_perkTree);
        this.mPerkTree.vpPerkTree = true; // tag so we only ever restore the stock tree from our own
    } else if (this.mPerkTree && this.mPerkTree.vpPerkTree) {
//    console.error("brother = else");
        // Leaving a necro: rebuild the stock tree so its extra rows don't linger for the next bro.
        // Keyed on our own tag, never on another mod's custom tree (druid), to avoid clobbering it.
        this.onPerkTreeLoaded(null, this.mDataSource.getPerkTrees());
    }
    VanillaPlusPerkTree.CharacterScreenPerksModule_loadPerkTreesWithBrotherData.call(this, _brother);
    if (_brother.vp_perkTree) {
        // Demonologist path exclusion: dim perks the blocked-path rule has closed off
        // (demon_blocked, stamped per brother in squirrel - see data_helper hook).
        VanillaPlusPerkTree.markBlockedPerks(this.mPerkTree);
    }
};

// Grey out perks the path rule has closed off. Distinct from tier-locked perks:
// they can never be taken on this build.
VanillaPlusPerkTree.markBlockedPerks = function (_perkTree) {
    for (var row = 0; row < _perkTree.length; ++row) {
        for (var i = 0; i < _perkTree[row].length; ++i) {
            var perk = _perkTree[row][i];
            if (!perk.Container) continue;
            if (perk.demon_blocked) perk.Container.addClass('demon-blocked');
            else perk.Container.removeClass('demon-blocked');
        }
    }
};

// A blocked perk is never selectable, regardless of tier or perk points: clicking it
// does not open the confirmation dialog (the hard guard on unlockPerk stays as safety net).
VanillaPlusPerkTree.CharacterScreenPerksModule_isPerkUnlockable = CharacterScreenPerksModule.prototype.isPerkUnlockable;
CharacterScreenPerksModule.prototype.isPerkUnlockable = function (_perk) {
    if (_perk.demon_blocked) return false;
    return VanillaPlusPerkTree.CharacterScreenPerksModule_isPerkUnlockable.call(this, _perk);
};
