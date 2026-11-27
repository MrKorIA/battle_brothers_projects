var ModItemComparison = {
    ShiftDown: false,
    Hooks: {},

    getTooltipModule: function()
    {
        if (typeof Screens === 'undefined' || !Screens.Tooltip || !Screens.Tooltip.isConnected())
            return null;
        return Screens.Tooltip.getModule('TooltipModule');
    },

    getVisibleCharacterScreen: function()
    {
        if (typeof Screens === 'undefined')
            return null;

        var names = ['WorldCharacterScreen', 'TacticalCharacterScreen'];
        for (var i = 0; i < names.length; ++i)
        {
            var screen = Screens[names[i]];
            if (screen !== undefined && screen !== null && screen.mContainer && screen.mContainer.hasClass('display-block'))
                return screen;
        }
        return null;
    },

    isCharacterItem: function(_screen, _data)
    {
        if (_screen === null || _data === null || _data.contentType !== 'ui-item' || !('itemId' in _data))
            return false;

        return _data.itemOwner === TooltipIdentifier.ItemOwner.Entity ||
            _data.itemOwner === CharacterScreenIdentifier.ItemOwner.Stash ||
            _data.itemOwner === CharacterScreenIdentifier.ItemOwner.Ground ||
            _data.itemOwner === CharacterScreenIdentifier.ItemOwner.Backpack ||
            _data.itemOwner === CharacterScreenIdentifier.ItemOwner.Paperdoll;
    },

    prepareQuery: function(_screen, _data)
    {
        var query = {};
        for (var key in _data)
            query[key] = _data[key];

        var isSharedInventory = query.itemOwner === CharacterScreenIdentifier.ItemOwner.Stash ||
            query.itemOwner === CharacterScreenIdentifier.ItemOwner.Ground;
        if (isSharedInventory || query.entityId === undefined || query.entityId === null)
        {
            var brother = _screen.mDataSource.getSelectedBrother();
            if (brother !== null && brother !== undefined)
                query.entityId = brother[CharacterScreenIdentifier.Entity.Id];
        }
        return query;
    },

    extract: function(_tooltipData)
    {
        if (!jQuery.isArray(_tooltipData))
            return null;

        for (var i = 0; i < _tooltipData.length; ++i)
        {
            if (_tooltipData[i].type === 'mod_item_comparison')
                return _tooltipData[i];
        }
        return null;
    },

    resetModule: function(_module)
    {
        _module.mItemComparisonRequest = (_module.mItemComparisonRequest || 0) + 1;
        _module.mItemComparisonActive = false;
    },

    restoreTooltip: function(_module)
    {
        if (_module === null || ModItemComparison.NestedActive || !_module.mItemComparisonActive)
            return;

        var element = _module.mCurrentElement;
        var data = _module.mCurrentData;
        _module.hideUITooltip();

        if (element !== null && element !== undefined && element.isInDOM())
            _module.showTooltip(element, data);
    }
};
