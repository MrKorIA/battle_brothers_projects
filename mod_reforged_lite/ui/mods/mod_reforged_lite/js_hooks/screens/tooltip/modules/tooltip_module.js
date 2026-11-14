// Поддержка типа rf_image в тултипах (картинка сложности контракта в тултипе
// на экране города) — аналог хука Reforged 0.9.3.
ReforgedLite.Hooks.TooltipModule_buildFromData = TooltipModule.prototype.buildFromData;
TooltipModule.prototype.buildFromData = function(_data, _shouldBeUpdated, _contentType)
{
	ReforgedLite.Hooks.TooltipModule_buildFromData.call(this, _data, _shouldBeUpdated, _contentType);

	// Add rf_image to tooltip
	if (_data !== null && jQuery.isArray(_data))
	{
		for (var i = 0; i < _data.length; ++i)
		{
			if (_data[i].type === 'rf_image' && 'image' in _data[i] && 'cssClass' in _data[i])
			{
				var image = $('<img class="' + _data[i].cssClass + '"/>');
				image.attr('src', Path.GFX + _data[i].image);
				this.mContainer.append(image);
			}
		}
	}
};
