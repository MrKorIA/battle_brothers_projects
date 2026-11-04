this.wolfrat_attacks_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.wolfrat_attacks";
		this.m.Name = "Стаи волкокрысов";
		this.m.Description = "Близлежащие чащобы кишат волкокрысами. С наступлением темноты эти прожорливые твари спускаются с холмов, совершая ночные набеги на окраины поселения и разрывая в клочья любого, кто замешкался в пути.";
		this.m.Icon = "ui/settlement_status/rat_settlement_effect_06.png";
		this.m.Rumors = [
			"Бродячий торговец божился, будто на тракте у поселения %settlement% всё истоптано когтями волкокрысов. Упаси нас боги встретить стаю этих голодных тварей в глухом лесу!",
			"Заходил я в %settlement% на днях - там беда. Ватага лесорубов ушла в чащу на заготовку дров, да так никто и не вернулся. Лишь окровавленные топоры нашли посреди просеки...",
			"Слыхал про волкокрысов? Мерзкие подземные гончие, они по ночам прорываются за частокол и таскают скотину прямо из хлевов! Люди бают, их пронзительный вой теперь постоянно слышен вблизи поселения %settlement%."
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
		_settlement.resetShop();
		_settlement.resetRoster(true);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.RecruitsMult *= 0.6;
	}

});

