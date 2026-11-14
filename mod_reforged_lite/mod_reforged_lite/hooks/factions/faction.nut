// Вложенный тултип фракции (для ссылок [имя|Faction+ID] в текстах контрактов и
// тултипе контракта на экране города) + обёртки имён фракций в текстах событий/контрактов.
::ReforgedLite.HooksMod.hook("scripts/factions/faction", function (q) {
	q.RF_getTooltip <- { function RF_getTooltip()
	{
		local settlements = this.getSettlements();

		if (this.getType() == ::Const.FactionType.Settlement && settlements.len() == 1)
		{
			return settlements[0].getTooltip();
		}

		local ret = [
			{
				id = 1,	type = "title",	text = this.getName()
			},
			{
				id = 2, type = "description", text = (this.getMotto() == "" ? "" : this.getMotto() + "\n\n") + this.getDescription()
			},
			{
				id = 10, type = "hint", icon = this.getUIBanner(), text = "Отношения: " + this.getPlayerRelationAsText()
			}
		];

		// List only discovered settlements.
		settlements = settlements.filter(@(_, _s) _s.isDiscovered());
		if (settlements.len() != 0)
		{
			// Sort military settlements before civilian ones.
			// Sort larger settlements before smaller ones.
			settlements.sort(function( _a, _b ) {
				if (_a.isMilitary() && !_b.isMilitary())
					return -1;
				if (!_a.isMilitary() && _b.isMilitary())
					return 1;
				if (_a.getSize() > _b.getSize())
					return -1;
				if (_a.getSize() < _b.getSize())
					return 1;
				return 0;
			});

			ret.push({
				id = 3, type = "hint",	 icon = "ui/icons/special.png",
				text = "Известные поселения:",
				children = settlements.map(@(_s) {
							id = 3,	type = "text",	icon = _s.getImagePath(),
							text = ::ReforgedLite.Mod.Tooltips.parseString(format("[%s|Obj+%s]", _s.getName(), ::ReforgedLite.Mod.Tooltips.parseObject(_s)))
						})
			});
		}

		return ret;
	}}.RF_getTooltip;
});

// Apply nesting in events/contracts: обёртка имён фракций во вложенные ссылки
// (аналог блока nested_tooltips.nut полного Reforged).
::ReforgedLite.HooksMod.hookTree("scripts/factions/faction", function(q) {
	q.getName = @(__original) { function getName()
	{
		return ::ReforgedLite.NestedTooltips.isApplyingNestingForEvents() ? ::ReforgedLite.Mod.Tooltips.parseString(format("[%s|Faction+%i]", ::ReforgedLite.Mod.Tooltips.removeAllFromString(__original()), this.getID())) : __original();
	}}.getName;

	// Some entities are spawned during event/contract `setScreen` while isApplyingNestingForEvents is true.
	// This causes the `_name` passed here to sometimes contain nested tooltip tags. So we have to clean up
	// the name otherwise the world map label for the entity ends up with the tooltip tags.
	// Note: An alternative would be to allow nested tooltips in name (so they appear in the tooltip of the entity)
	// but hook `updateStrength` to retroactively remove the tooltips from the name label.
	q.spawnEntity = @(__original) { function spawnEntity( _tile, _name, _uniqueName, _template, _resources, _minibossify = 0 )
	{
		if (::ReforgedLite.NestedTooltips.isApplyingNestingForEvents())
		{
			_name = ::ReforgedLite.Mod.Tooltips.removeAllFromString(_name);
		}
		return __original(_tile, _name, _uniqueName, _template, _resources, _minibossify);
	}}.spawnEntity;

	if (q.contains("getNameOnly"))
	{
		q.getNameOnly = @(__original) { function getNameOnly()
		{
			return ::ReforgedLite.NestedTooltips.isApplyingNestingForEvents() ? ::ReforgedLite.Mod.Tooltips.parseString(format("[%s|Faction+%i]", ::ReforgedLite.Mod.Tooltips.removeAllFromString(__original()), this.getID())) : __original();
		}}.getNameOnly;
	}
});
