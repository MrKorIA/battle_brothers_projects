ModItemComparison.NestedHooks = {};
ModItemComparison.NestedActive = false;
ModItemComparison.NestedSource = null;
ModItemComparison.NestedCurrentSource = null;
ModItemComparison.NestedRequest = 0;

ModItemComparison.getNestedTooltip = function()
{
    if (typeof MSU === 'undefined' || MSU.NestedTooltip === undefined)
        return null;
    return MSU.NestedTooltip;
};

ModItemComparison.isNestedItem = function(_source)
{
    if (_source === null || _source === undefined || _source.length === 0)
        return false;
    return ModItemComparison.isCharacterItem(ModItemComparison.getVisibleCharacterScreen(), _source.data('msu-tooltip-parameters'));
};

ModItemComparison.getNestedSource = function()
{
    var nested = ModItemComparison.getNestedTooltip();
    if (nested === null)
        return null;

    var stack = nested.TooltipStack.getStack();
    if (stack.length > 0 && ModItemComparison.isNestedItem(stack[0].sourceContainer))
        return stack[0].sourceContainer;

    if (ModItemComparison.isNestedItem(ModItemComparison.NestedCurrentSource))
        return ModItemComparison.NestedCurrentSource;
    return null;
};

ModItemComparison.showNestedComparison = function(_source)
{
    if (!ModItemComparison.isNestedItem(_source))
        return;

    var nested = ModItemComparison.getNestedTooltip();
    var tooltip = ModItemComparison.getTooltipModule();
    if (nested === null || tooltip === null)
        return;

    var screen = ModItemComparison.getVisibleCharacterScreen();
    var query = ModItemComparison.prepareQuery(screen, _source.data('msu-tooltip-parameters'));
    var request = ++ModItemComparison.NestedRequest;
    ModItemComparison.NestedActive = true;
    ModItemComparison.NestedSource = _source;

    nested.Events.cancelTimer('SHOW');
    nested.Events.cancelTimer('HIDE');
    nested.TooltipStack.clear();

    tooltip.notifyBackendQueryTooltipData(query, function(_tooltipData) {
        if (request !== ModItemComparison.NestedRequest || !ModItemComparison.ShiftDown)
            return;
        if (_tooltipData === undefined || _tooltipData === null)
            return;

        var comparison = ModItemComparison.extract(_tooltipData);
        if (comparison === null)
        {
            ModItemComparison.NestedActive = false;
            ModItemComparison.NestedSource = null;
            ModItemComparison.NestedHooks.createTooltip.call(nested, _tooltipData, _source, query);
            return;
        }

        tooltip.mIsVisible = true;
        tooltip.mCurrentData = query;
        tooltip.mCurrentElement = _source;
        tooltip.mItemComparisonActive = true;
        tooltip.buildItemComparison(comparison);
        tooltip.setupUITooltip(_source, query);
    });
};

ModItemComparison.hideNestedComparison = function(_restore)
{
    if (!ModItemComparison.NestedActive)
        return;

    var nested = ModItemComparison.getNestedTooltip();
    var source = ModItemComparison.NestedSource;
    ++ModItemComparison.NestedRequest;
    ModItemComparison.NestedActive = false;
    ModItemComparison.NestedSource = null;

    var tooltip = ModItemComparison.getTooltipModule();
    if (tooltip !== null)
        tooltip.hideUITooltip();

    if (_restore && nested !== null && source !== null && source.isInDOM())
        ModItemComparison.NestedHooks.onShowTooltipTimerExpired.call(nested, source);
};

ModItemComparison.onNestedModifierDown = function()
{
    var source = ModItemComparison.getNestedSource();
    if (source !== null)
        ModItemComparison.showNestedComparison(source);
};

ModItemComparison.onNestedModifierUp = function()
{
    ModItemComparison.hideNestedComparison(true);
};

ModItemComparison.initNestedTooltips = function()
{
    var nested = ModItemComparison.getNestedTooltip();
    if (nested === null || ModItemComparison.NestedHooks.onShowTooltipTimerExpired !== undefined)
        return;

    ModItemComparison.NestedHooks.onShowTooltipTimerExpired = nested.onShowTooltipTimerExpired;
    nested.onShowTooltipTimerExpired = function(_sourceContainer) {
        if (!ModItemComparison.isNestedItem(_sourceContainer))
        {
            ModItemComparison.NestedHooks.onShowTooltipTimerExpired.call(this, _sourceContainer);
            return;
        }

        var originalParams = _sourceContainer.data('msu-tooltip-parameters');
        var query = ModItemComparison.prepareQuery(ModItemComparison.getVisibleCharacterScreen(), originalParams);
        _sourceContainer.data('msu-tooltip-parameters', query);
        try
        {
            if (ModItemComparison.ShiftDown)
            {
                ModItemComparison.showNestedComparison(_sourceContainer);
                return;
            }
            ModItemComparison.NestedHooks.onShowTooltipTimerExpired.call(this, _sourceContainer);
        }
        finally
        {
            _sourceContainer.data('msu-tooltip-parameters', originalParams);
        }
    };

    ModItemComparison.NestedHooks.createTooltip = nested.createTooltip;
    nested.createTooltip = function(_backendData, _sourceContainer, _tooltipParams) {
        if (ModItemComparison.ShiftDown && ModItemComparison.NestedActive && _sourceContainer.is(ModItemComparison.NestedSource))
            return;
        ModItemComparison.NestedHooks.createTooltip.call(this, _backendData, _sourceContainer, _tooltipParams);
    };

    ModItemComparison.NestedHooks.onSourceEnter = nested.Events.onSourceEnter;
    nested.Events.onSourceEnter = function(_event) {
        var source = $(_event.currentTarget);
        if (ModItemComparison.isNestedItem(source))
            ModItemComparison.NestedCurrentSource = source;
        ModItemComparison.NestedHooks.onSourceEnter.call(this, _event);
    };

    ModItemComparison.NestedHooks.onSourceLeave = nested.Events.onSourceLeave;
    nested.Events.onSourceLeave = function(_event) {
        var source = $(_event.currentTarget);
        if (ModItemComparison.NestedCurrentSource !== null && source.is(ModItemComparison.NestedCurrentSource))
            ModItemComparison.NestedCurrentSource = null;
        if (ModItemComparison.NestedActive && source.is(ModItemComparison.NestedSource))
            ModItemComparison.hideNestedComparison(false);
        ModItemComparison.NestedHooks.onSourceLeave.call(this, _event);
    };
};

setTimeout(ModItemComparison.initNestedTooltips, 0);
