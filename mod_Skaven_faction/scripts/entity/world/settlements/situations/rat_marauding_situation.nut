this.rat_marauding_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.rat_marauding";
		this.m.Name = "Набеги скавенов";
		this.m.Description = "Земли вокруг поселения охвачены ужасом. Скавены бесчинствуют на дорогах: отдалённые фермы сожжены, а торговые караваны бесследно исчезают в глуши. Припасы на исходе, и среди местных жителей зреет отчаяние.";
		this.m.Icon = "ui/settlement_status/rat_settlement_effect_01.png";
		this.m.Rumors = [
			"Поговаривают, окаянные крысы почуяли наживу и вовсю мародёрствуют под стенами поселения %settlement%. Спаси нас боги, если эти твари двинутся в нашу сторону...",
			"Видали багровое зарево на горизонте? Это горят амбары вокруг поселения %settlement%. Скавены выжигают деревню за деревней, не оставляя после себя ничего, кроме пепла.",
			"Глянь-ка лучше на мою руку, наёмник! Калека на всю жизнь, твари оттяпали пальцы в прошлой стычке. А теперь доходят вести, что этот крысиный сброд снова грабит пригород поселения %settlement%."
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
		_settlement.resetShop();
		_settlement.resetRoster(true);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.RarityMult *= 0.75;
		_modifiers.RecruitsMult *= 0.75;
	}

});

