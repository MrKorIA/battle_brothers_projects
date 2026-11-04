var GladiatorPerkTree = {};

GladiatorPerkTree.CharacterScreenPerksModule_loadPerkTreesWithBrotherData
    = CharacterScreenPerksModule.prototype.loadPerkTreesWithBrotherData;
CharacterScreenPerksModule.prototype.loadPerkTreesWithBrotherData = function (_brother) {
    if (_brother.gladiator_perkTree) {
        this.resetPerkTree(this.mPerkTree);
        this.onPerkTreeLoaded(null, _brother.gladiator_perkTree);
        this.mPerkTree.gladiatorTree = true; // tag so we only ever restore the stock tree from our own
    } else if (_brother.gladiatorLight_perkTree) {
        this.resetPerkTree(this.mPerkTree);
        this.onPerkTreeLoaded(null, _brother.gladiatorLight_perkTree);
        this.mPerkTree.gladiatorTree = true; // tag so we only ever restore the stock tree from our own
    } else if (this.mPerkTree && this.mPerkTree.gladiatorTree) {
        this.onPerkTreeLoaded(null, this.mDataSource.getPerkTrees());
    }
    GladiatorPerkTree.CharacterScreenPerksModule_loadPerkTreesWithBrotherData.call(this, _brother);
};
