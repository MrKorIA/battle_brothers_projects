this.stronghold_well_supplied_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	//had to use a very hacky way to select player base, as otherwise deserialisation errors (or custom addSituation function)
	m = {
		Home = null
	},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.stronghold_well_supplied";
		this.m.Name = this.defineName();
		this.m.Description = ""
		this.m.Icon = "ui/settlement_status/settlement_effect_03.png";
		this.m.Rumors = [
			"%settlement% процветает от торговли, друг мой! Дороги безопасны, а амбары полны - и будем надеяться, что так всё и пребудет...",
			"%settlement% - там живёт мой брат, всё время хвастающийся, как у них там всё умно устроено. Оживлённая торговля и всё такое. Не то что в нашем бардаке."
		];
		this.m.Descriptions <- [
			"Немногие купцы, которые осмеливаются заглянуть в это поселение, имеют мало выгоды.", "Ваш форт - один из многих, что приводит к посредственным ценам на ваши товары.", "Поскольку ни один благородный дом не облагает вас налогами, цены на ваши товары весьма хороши.", "Как лорду великой крепости, купцы предлагают вам отличные цены и доставляют свои самые редкие товары.",
		]
		this.m.IsStacking = false;
		
	}
	function defineName()
	{
		local company_name = this.World.Assets.getName();
		local final_name = " ";
		if (company_name.slice(company_name.len()-1, company_name.len()) == "s")
		{
			company_name = company_name.slice(0, company_name.len()-1);
		}
		final_name += "Блага отряда " + company_name;
		return final_name;
	}
	function isValid()
	{
		return true;
	}

	//should be dynamic and check the properties
	function defineDescription(_town)
	{
		return this.m.Descriptions[_town.getSize() - 1];
	}

	function getAddedString( _s )
	{
		return _s + " теперь имеет статус " + this.m.Name;
	}

	function getRemovedString( _s )
	{
		return _s + " утратил статус " + this.m.Name;
	}

	function onUpdate( _modifiers )
	{ 
		local playerBase = this.World.State.getCurrentTown();
		if (playerBase == null) return
		this.m.Description = this.defineDescription(playerBase);
		local mults = this.Stronghold.BaseTiers[playerBase.getSize()]
		_modifiers.RarityMult *= mults.Rarity;
        _modifiers.BuyPriceMult *= mults.BuyPrice;
        _modifiers.SellPriceMult *= mults.SellPrice;
}

});

