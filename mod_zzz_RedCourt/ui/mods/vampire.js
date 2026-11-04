var Vampire = {};

Vampire.CharacterScreenPerksModule_loadPerkTreesWithBrotherData
    = CharacterScreenPerksModule.prototype.loadPerkTreesWithBrotherData;
CharacterScreenPerksModule.prototype.loadPerkTreesWithBrotherData = function (_brother) {
    if (_brother.vampire_perkTree) {
        this.resetPerkTree(this.mPerkTree);
        this.onPerkTreeLoaded(null, _brother.vampire_perkTree);
        this.mPerkTree.vampireTree = true; // tag so we only ever restore the stock tree from our own
    } else if (this.mPerkTree && this.mPerkTree.vampireTree) {
        this.onPerkTreeLoaded(null, this.mDataSource.getPerkTrees());
    }
    Vampire.CharacterScreenPerksModule_loadPerkTreesWithBrotherData.call(this, _brother);
};
