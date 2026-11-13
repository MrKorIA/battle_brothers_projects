// Хелперы генерации вложенных ссылок (аналог ::Reforged.NestedTooltips из Reforged 0.9.3):
// формируют разметку [текст|Skill+X] / [текст|Perk+X] / [текст|Entity+ID] для parseString.
::ReforgedLite.NestedTooltips <- {
	function getNestedPerkName( _obj, _extraData = null )
	{
		local perkDef = ::Const.Perks.findById(_obj.getID());
		return format("[%s|Perk+%s%s]", perkDef != null ? perkDef.Name : _obj.m.Name, _obj.ClassName, _extraData == null ? "" : "," + _extraData);
	}

	function getNestedPerkImage( _obj, _extraData = null )
	{
		local perkDef = ::Const.Perks.findById(_obj.getID());
		return format("[Img/gfx/%s|Perk+%s%s,cssClass:rf-nested-skill-image]", perkDef != null ? perkDef.Icon : _obj.getIcon(), _obj.ClassName, _extraData == null ? "" : "," + _extraData);
	}

	function getNestedSkillName( _obj, _extraData = null, _getName = false )
	{
		// We use `.m.Name` instead of `getName()` because some skills (e.g. status effects)
		// modify the name during getName() e.g. to add info about the number of stacks
		return format("[%s|Skill+%s%s]", _getName ? _obj.getName() : _obj.m.Name, _obj.ClassName, _extraData == null ? "" : "," + _extraData);
	}

	function getNestedSkillImage( _obj, _extraData = null, _checkUsability = false )
	{
		local icon = !_checkUsability || _obj.isUsable() && _obj.isAffordable() ? _obj.getIconColored() : _obj.getIconDisabled();
		return format("[Img/gfx/%s|Skill+%s%s,cssClass:rf-nested-skill-image]", icon, _obj.ClassName, _extraData == null ? "" : "," + _extraData);
	}

	function getNestedItemName( _obj, _extraData = null )
	{
		return format("[%s|Item+%s%s]", _obj.getName(), _obj.ClassName, _extraData == null ? "" : "," + _extraData);
	}

	function getNestedItemImage( _obj, _extraData = null )
	{
		return format("[Img/gfx/ui/items/%s|Item+%s%s]", _obj.getIcon(), _obj.ClassName, _extraData == null ? "" : "," + _extraData);
	}

	function getNestedEntityImage( _obj, _extraData = null )
	{
		return format("[Img/gfx/ui/orientation/%s.png|Entity+%i%s,cssClass:rf-nested-skill-image]", _obj.getOverlayImage(), _obj.getID(), _extraData == null ? "" : "," + _extraData);
	}

	function getNestedEntityName( _obj, _extraData = null )
	{
		return format("[%s|Entity+%i%s]", _obj.getName(), _obj.getID(), _extraData == null ? "" : "," + _extraData);
	}
};
