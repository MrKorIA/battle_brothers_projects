::mods_hookExactClass("entity/world/settlements/situations/archery_contest_situation", function (cls) {
    local onUpdateDraftList = cls.onUpdateDraftList;
    cls.onUpdateDraftList = function (_draftList) {
        onUpdateDraftList(_draftList);
        _draftList.push("hackflows/arbalester_background");
        _draftList.push("hackflows/arbalester_background");
        _draftList.push("hackflows/arbalester_background");
        _draftList.push("hackflows/arbalester_background");
        _draftList.push("hackflows/arbalester_background");
        _draftList.push("hackflows/arbalester_background");
        _draftList.push("hackflows/arbalester_background");
        _draftList.push("hackflows/arbalester_background");
        _draftList.push("hackflows/arbalester_background");
        _draftList.push("hackflows/arbalester_background");
        _draftList.push("hackflows/arbalester_background");
    }
})

