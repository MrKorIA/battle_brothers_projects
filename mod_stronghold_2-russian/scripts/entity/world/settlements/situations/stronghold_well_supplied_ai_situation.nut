this.stronghold_well_supplied_ai_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	//buff when AI caravans arrive at stronghold
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.stronghold_well_supplied_ai";
		this.m.Name = "Хорошее снабжение";
		this.m.Description = "В это поселение недавно завезли множество товаров, многие из которых можно купить за разумную цену.";
		this.m.Icon = "ui/settlement_status/settlement_effect_03.png";
		this.m.Rumors = [
			"%settlement% процветает от торговли, друг мой! Дороги безопасны, а амбары полны - и будем надеяться, что так всё и пребудет...",
			"%settlement% - там живёт мой брат, всё время хвастающийся, как у них там всё умно устроено. Оживлённая торговля и всё такое. Не то что в нашем бардаке."
		];
		this.m.IsStacking = false;
	}

	function getAddedString( _s )
	{
		return _s + " теперь имеет статус " + this.m.Name;
	}

	function getRemovedString( _s )
	{
		return _s + " утратил статус " + this.m.Name;
	}

	function onAdded( _settlement )
	{

	}

	function onUpdate( _modifiers )
	{
		//number might need tweaking
		_modifiers.RarityMult *= 1.05;
	}

});

