ModItemComparison.Attributes = [
    { Section: 'attack', Keys: ['DamageMin', 'DamageMax'], Label: 'Базовый урон', Kinds: ['weapon'], Visible: function(a, b) { return a.DamageMax > 0 || b.DamageMax > 0; } },
    { Section: 'attack', Keys: ['DirectDamage'], Label: 'Урон по ОЗ', Suffix: '%', Kinds: ['weapon'], Visible: function(a, b) { return a.DirectDamage !== 0 || b.DirectDamage !== 0; } },
    { Section: 'attack', Keys: ['ArmorDamage'], Label: 'Урон по броне', Suffix: '%', Kinds: ['weapon'], Visible: function(a, b) { return a.ArmorDamage !== 0 || b.ArmorDamage !== 0; } },
    { Section: 'attack', Keys: ['ShieldDamage'], Label: 'Повреждение щита', Kinds: ['weapon'], Visible: function(a, b) { return a.ShieldDamage !== 0 || b.ShieldDamage !== 0; } },
    { Section: 'attack', Keys: ['Accuracy'], Label: 'К шансу попадания', Suffix: '%', Kinds: ['weapon'], Visible: function(a, b) { return a.Accuracy !== 0 || b.Accuracy !== 0; } },
    { Section: 'attack', Keys: ['Headshot'], Label: 'Шанс попасть в голову', Suffix: '%', Kinds: ['weapon'], Visible: function(a, b) { return a.Headshot !== 0 || b.Headshot !== 0; } },
    { Section: 'attack', Keys: ['RangeMin', 'RangeMax'], Label: 'Дальность', Kinds: ['weapon'], Visible: function(a, b) { return a.RangeMax > 1 || b.RangeMax > 1; } },
    { Section: 'attack', Keys: ['RangeIdeal'], Label: 'Оптимальная дальность', Kinds: ['weapon'], Visible: function(a, b) { return a.RangeMax > 1 || b.RangeMax > 1; } },
    { Section: 'attack', Keys: ['RangeMaxBonus'], Label: 'Макс. бонус дальности', Kinds: ['weapon'], Visible: function(a, b) { return a.RangeMax > 1 || b.RangeMax > 1; } },
    { Section: 'attack', Keys: ['Ammo', 'AmmoMax'], Label: 'Боеприпасы', Kinds: ['weapon'], Visible: function(a, b) { return a.AmmoMax > 0 || b.AmmoMax > 0; } },
    { Section: 'defense', Keys: ['ArmorMax'], Label: 'Максимальная броня', Kinds: ['armor', 'helmet'], Visible: function(a, b) { return a.ArmorMax > 0 || b.ArmorMax > 0; } },
    { Section: 'defense', Keys: ['MeleeDefense'], Label: 'Защита в ближнем бою', Kinds: ['shield'], Visible: function(a, b) { return a.MeleeDefense !== 0 || b.MeleeDefense !== 0; } },
    { Section: 'defense', Keys: ['RangedDefense'], Label: 'Защита в дальнем бою', Kinds: ['shield'], Visible: function(a, b) { return a.RangedDefense !== 0 || b.RangedDefense !== 0; } },
    { Section: 'defense', Keys: ['Vision'], Label: 'Обзор', Kinds: ['helmet'], Visible: function(a, b) { return a.Vision !== 0 || b.Vision !== 0; } },
    { Section: 'general', Keys: ['ConditionMax'], Label: 'Максимальная прочность', Kinds: ['weapon', 'shield'], Visible: function(a, b) { return a.ConditionMax > 1 || b.ConditionMax > 1; } },
    { Section: 'general', Keys: ['Stamina'], Label: 'Вес (выносливость)', Visible: function(a, b) { return a.Stamina !== 0 || b.Stamina !== 0; } },
    { Section: 'general', Keys: ['SkillFatigue'], Label: 'Доп. расход выносливости', Kinds: ['weapon', 'shield'], Visible: function(a, b) { return a.SkillFatigue !== 0 || b.SkillFatigue !== 0; } },
    { Section: 'general', Keys: ['Value'], Label: 'Стоимость', Suffix: ' крон', Visible: function() { return true; } }
];

ModItemComparison.SectionNames = {
    attack: 'Атакующие характеристики',
    defense: 'Защитные характеристики',
    general: 'Общие характеристики'
};

ModItemComparison.setParsedText = function(_element, _text)
{
    var parsed = XBBCODE.process({
        text: _text,
        removeMisalignedTags: false,
        addInLineBreaks: true
    });
    _element.html(parsed.html);
};

ModItemComparison.addValue = function(_parent, _value, _otherValue, _suffix)
{
    var value = Number(_value) || 0;
    var otherValue = Number(_otherValue) || 0;
    var cssClass = value > otherValue ? 'is-better' : (value < otherValue ? 'is-worse' : 'is-equal');
    $('<span class="comparison-value ' + cssClass + '"/>').text(value + (_suffix || '')).appendTo(_parent);
};

ModItemComparison.addValues = function(_parent, _definition, _stats, _otherStats)
{
    for (var i = 0; i < _definition.Keys.length; ++i)
    {
        if (i > 0)
            $('<span class="value-separator"/>').text(' – ').appendTo(_parent);
        ModItemComparison.addValue(_parent, _stats[_definition.Keys[i]], _otherStats[_definition.Keys[i]], _definition.Suffix);
    }
};

ModItemComparison.formatDifference = function(_value, _suffix)
{
    var value = Number(_value) || 0;
    return (value > 0 ? '+' : '') + value + (_suffix || '');
};

ModItemComparison.addDifference = function(_parent, _definition, _equipped, _selected)
{
    var parts = [];
    for (var i = 0; i < _definition.Keys.length; ++i)
    {
        var key = _definition.Keys[i];
        parts.push(ModItemComparison.formatDifference((Number(_selected[key]) || 0) - (Number(_equipped[key]) || 0), _definition.Suffix));
    }
    _parent.text(parts.join(' / '));
};

ModItemComparison.createItemHeader = function(_item, _caption)
{
    var column = $('<div class="comparison-item-header"/>');
    $('<div class="comparison-caption text-font-small"/>').text(_caption).appendTo(column);
    var name = $('<div class="comparison-item-name title-font-normal font-bold font-color-ink"/>');
    ModItemComparison.setParsedText(name, _item.Name);
    name.appendTo(column);
    return column;
};

ModItemComparison.createItemIcon = function(_item)
{
    var column = $('<div class="comparison-item-icon-container"/>');
    var frame = $('<div class="comparison-item-icon-frame"/>').appendTo(column);
    var image = $('<img class="comparison-item-icon"/>');
    image.attr('src', Path.ITEMS + _item.Icon);
    image.attr('alt', '');
    frame.append(image);
    if (_item.IconOverlay !== '')
    {
        var overlay = $('<img class="comparison-item-icon-overlay"/>');
        overlay.attr('src', Path.ITEMS + _item.IconOverlay);
        overlay.attr('alt', '');
        frame.append(overlay);
    }
    return column;
};

ModItemComparison.createSectionTitle = function(_text)
{
    var title = $('<div class="comparison-section-title text-font-small font-bold"/>');
    $('<span/>').text(_text).appendTo(title);
    return title;
};

ModItemComparison.addSection = function(_parent, _section, _equipped, _selected)
{
    var rows = [];
    for (var i = 0; i < ModItemComparison.Attributes.length; ++i)
    {
        var definition = ModItemComparison.Attributes[i];
        if (definition.Section !== _section)
            continue;
        if (definition.Kinds !== undefined && jQuery.inArray(_equipped.Kind, definition.Kinds) === -1)
            continue;
        if (!definition.Visible(_equipped.Stats, _selected.Stats))
            continue;
        rows.push(definition);
    }

    if (rows.length === 0)
        return;

    var section = $('<div class="comparison-section"/>').appendTo(_parent);
    section.append(ModItemComparison.createSectionTitle(ModItemComparison.SectionNames[_section]));

    for (var i = 0; i < rows.length; ++i)
    {
        var definition = rows[i];
        var row = $('<div class="comparison-attribute-row"/>').appendTo(section);
        var leftValue = $('<div class="comparison-attribute-value is-left"/>').appendTo(row);
        ModItemComparison.addValues(leftValue, definition, _equipped.Stats, _selected.Stats);

        var center = $('<div class="comparison-attribute-center"/>').appendTo(row);
        $('<div class="comparison-attribute-label"/>').text(definition.Label).appendTo(center);
        var difference = $('<div class="comparison-difference"/>').appendTo(center);
        ModItemComparison.addDifference(difference, definition, _equipped.Stats, _selected.Stats);

        var rightValue = $('<div class="comparison-attribute-value is-right"/>').appendTo(row);
        ModItemComparison.addValues(rightValue, definition, _selected.Stats, _equipped.Stats);
    }
};

ModItemComparison.createSkillList = function(_item)
{
    var column = $('<div class="comparison-skill-column"/>');
    if (_item.Skills.length === 0)
    {
        $('<div class="comparison-no-skills text-font-small"/>').text('Нет навыков').appendTo(column);
        return column;
    }

    for (var i = 0; i < _item.Skills.length; ++i)
    {
        var skill = _item.Skills[i];
        var row = $('<div class="comparison-skill-row"/>').appendTo(column);
        if (skill.Icon !== '')
        {
            var image = $('<img class="comparison-skill-icon"/>');
            image.attr('src', Path.GFX + skill.Icon);
            image.attr('alt', '');
            row.append(image);
        }
        var name = $('<div class="comparison-skill-name text-font-small"/>');
        ModItemComparison.setParsedText(name, skill.Name);
        name.appendTo(row);
    }
    return column;
};

TooltipModule.prototype.buildItemComparison = function(_data)
{
    this.mContainer.removeClass('is-full-width is-tile-content is-entity-content is-skill-content is-status-effect-content is-ui-element-content is-ui-item-content');
    this.mContainer.addClass('is-full-width is-ui-item-content mod-item-comparison');
    this.mContainer.empty();
    this.resetInternal();

    var background = $('<img class="item-comparison-background"/>').appendTo(this.mContainer);
    background.attr('src', 'coui://gfx/ui/skin/item_comparison_tooltip.png');
    background.attr('alt', '');
    var content = $('<div class="item-comparison-content"/>').appendTo(this.mContainer);

    var header = $('<div class="comparison-header"/>').appendTo(content);
    header.append(ModItemComparison.createItemHeader(_data.Equipped, 'Экипировано'));
    var versus = $('<div class="comparison-vs title-font-normal font-bold"/>').appendTo(header);
    $('<span/>').text('VS').appendTo(versus);
    header.append(ModItemComparison.createItemHeader(_data.Selected, 'Выбрано'));

    var icons = $('<div class="comparison-icons"/>').appendTo(content);
    icons.append(ModItemComparison.createItemIcon(_data.Equipped));
    $('<div class="comparison-icon-spacer"/>').appendTo(icons);
    icons.append(ModItemComparison.createItemIcon(_data.Selected));

    ModItemComparison.addSection(content, 'attack', _data.Equipped, _data.Selected);
    ModItemComparison.addSection(content, 'defense', _data.Equipped, _data.Selected);
    ModItemComparison.addSection(content, 'general', _data.Equipped, _data.Selected);

    if (_data.Equipped.Skills.length > 0 || _data.Selected.Skills.length > 0)
    {
        var section = $('<div class="comparison-section comparison-skills"/>').appendTo(content);
        section.append(ModItemComparison.createSectionTitle('Навыки предметов'));
        var columns = $('<div class="comparison-skill-columns"/>').appendTo(section);
        columns.append(ModItemComparison.createSkillList(_data.Equipped));
        $('<div class="comparison-skill-divider"/>').appendTo(columns);
        columns.append(ModItemComparison.createSkillList(_data.Selected));
    }
};

ModItemComparison.Hooks.showTooltip = TooltipModule.prototype.showTooltip;
TooltipModule.prototype.showTooltip = function(_targetDIV, _data)
{
    var screen = ModItemComparison.getVisibleCharacterScreen();
    var isCharacterItem = ModItemComparison.isCharacterItem(screen, _data);
    var query = isCharacterItem ? ModItemComparison.prepareQuery(screen, _data) : _data;
    if (!ModItemComparison.ShiftDown || !isCharacterItem)
    {
        ModItemComparison.resetModule(this);
        ModItemComparison.Hooks.showTooltip.call(this, _targetDIV, query);
        return;
    }

    if (this.mShowUITooltipTimer)
        this.mShowUITooltipTimer = clearTimeout(this.mShowUITooltipTimer);

    var isEnabled = _targetDIV.data('is-enabled');
    if (isEnabled !== null && isEnabled === false)
        return;

    var self = this;
    var request = (this.mItemComparisonRequest || 0) + 1;
    this.mItemComparisonRequest = request;
    this.mItemComparisonActive = true;

    this.notifyBackendQueryTooltipData(query, function(_tooltipData) {
        if (request !== self.mItemComparisonRequest || !ModItemComparison.ShiftDown)
            return;
        if (_tooltipData === undefined || _tooltipData === null)
            return;

        self.mIsVisible = true;
        self.mCurrentData = query;
        self.mCurrentElement = _targetDIV;

        var comparison = ModItemComparison.extract(_tooltipData);
        if (comparison !== null)
        {
            self.buildItemComparison(comparison);
        }
        else
        {
            self.mItemComparisonActive = false;
            self.buildFromData(_tooltipData, false, query.contentType);
        }
        self.setupUITooltip(_targetDIV, query);
    });
};

ModItemComparison.Hooks.buildFromData = TooltipModule.prototype.buildFromData;
TooltipModule.prototype.buildFromData = function(_data, _shouldBeUpdated, _contentType)
{
    this.mContainer.removeClass('mod-item-comparison');
    ModItemComparison.Hooks.buildFromData.call(this, _data, _shouldBeUpdated, _contentType);
};

ModItemComparison.Hooks.hideTooltip = TooltipModule.prototype.hideTooltip;
TooltipModule.prototype.hideTooltip = function()
{
    ModItemComparison.resetModule(this);
    ModItemComparison.Hooks.hideTooltip.call(this);
};

ModItemComparison.Hooks.hideUITooltip = TooltipModule.prototype.hideUITooltip;
TooltipModule.prototype.hideUITooltip = function()
{
    ModItemComparison.resetModule(this);
    ModItemComparison.Hooks.hideUITooltip.call(this);
};

ModItemComparison.Hooks.reloadUITooltip = TooltipModule.prototype.reloadUITooltip;
TooltipModule.prototype.reloadUITooltip = function()
{
    if (this.mItemComparisonActive && ModItemComparison.ShiftDown && this.mCurrentElement !== null && this.mCurrentData !== null)
    {
        this.showTooltip(this.mCurrentElement, this.mCurrentData);
        return;
    }
    ModItemComparison.Hooks.reloadUITooltip.call(this);
};

ModItemComparison.Hooks.setupUITooltip = TooltipModule.prototype.setupUITooltip;
TooltipModule.prototype.setupUITooltip = function(_targetDIV, _data)
{
    ModItemComparison.Hooks.setupUITooltip.call(this, _targetDIV, _data);
    if (!this.mItemComparisonActive)
        return;

    var margin = 10;
    var width = this.mContainer.outerWidth(true);
    var height = this.mContainer.outerHeight(true);
    var left = Math.max(margin, Math.min(parseFloat(this.mContainer.css('left')), this.mParent.width() - width - margin));
    var top = Math.max(margin, Math.min(parseFloat(this.mContainer.css('top')), this.mParent.height() - height - margin));
    this.mContainer.css({ left: left, top: top });
};

$(document).on('keydown.mod-item-comparison', function(_event) {
    if (_event.keyCode !== 16)
        return;

    var wasDown = ModItemComparison.ShiftDown;
    ModItemComparison.ShiftDown = true;
    _event.preventDefault();
    if (wasDown)
        return;

    var tooltip = ModItemComparison.getTooltipModule();
    if (tooltip !== null && tooltip.mIsVisible && tooltip.mCurrentElement !== null && tooltip.mCurrentData !== null)
        tooltip.showTooltip(tooltip.mCurrentElement, tooltip.mCurrentData);
    if (ModItemComparison.onNestedModifierDown !== undefined)
        ModItemComparison.onNestedModifierDown();
});

$(document).on('keyup.mod-item-comparison', function(_event) {
    if (_event.keyCode !== 16)
        return;

    ModItemComparison.ShiftDown = false;
    _event.preventDefault();
    ModItemComparison.restoreTooltip(ModItemComparison.getTooltipModule());
    if (ModItemComparison.onNestedModifierUp !== undefined)
        ModItemComparison.onNestedModifierUp();
});

$(window).on('blur.mod-item-comparison', function() {
    ModItemComparison.ShiftDown = false;
    ModItemComparison.restoreTooltip(ModItemComparison.getTooltipModule());
    if (ModItemComparison.onNestedModifierUp !== undefined)
        ModItemComparison.onNestedModifierUp();
});
