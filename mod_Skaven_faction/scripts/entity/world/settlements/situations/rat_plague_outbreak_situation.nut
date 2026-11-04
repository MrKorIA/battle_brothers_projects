this.rat_plague_outbreak_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.rat_plague_outbreak";
		this.m.Name = "Чумное поветрие";
		this.m.Description = "Местные колодцы отравлены, и по улицам стремительно расползается чёрная смерть. Раздувшиеся трупы громоздятся прямо у порогов домов, а воздух пропитан смрадом гниения. Живых в городе почти не осталось - нанимать здесь больше некого.";
		this.m.Icon = "ui/settlement_status/rat_settlement_effect_03.png";
		this.m.Rumors = [
			"Ну его к чёрту, этот %settlement%! Я туда ни ногой. Беженцы на тракте сказывают, будто тамошняя вода превратилась в сущий яд. Старое правило - держаться подальше от чужой беды - меня ещё никогда не подводило.",
			"Если тебе дорога твоя шкура, наёмник, обходи стороной город %settlement%. Там сейчас пирует костлявая, а по улицам рыщут лишь мародёры да чумные крысы.",
			"Говорят, в городе %settlement% чумные доктора в своих птичьих масках мрут один за другим. Не берёт эту заразу их хвалёный уксус. Хвороба-то непростая, чёрная магия тут замешана, не иначе..."
		];
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
		_settlement.removeSituationByID("situation.rat_stop_plague");
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.BuyPriceMult *= 1.25;
		_modifiers.SellPriceMult *= 0.75;
		_modifiers.RecruitsMult *= 0.25;
	}

});

