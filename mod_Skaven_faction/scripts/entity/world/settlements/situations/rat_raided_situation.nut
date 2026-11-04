this.rat_raided_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.rat_raided";
		this.m.Name = "Разорение";
		this.m.Description = "Поселение недавно пережило яростное нападение скавенов. Склады разграблены, ценные товары сожжены или унесены под землю, а улицы залиты кровью защитников. Город до сих пор подсчитывает потери.";
		this.m.Icon = "ui/settlement_status/rat_settlement_effect_05.png";
		this.m.Rumors = [
			"Беженцы, что бредут со стороны поселения %settlement%, в один голос твердят, что твари выгребли из их закромов всё подчистую. Бедняги, конечно... Но нам-то что делать? У самих в кошельках ветер гуляет. Пускай благородный лорд о них печётся, ему за то налоги платят!",
			"Паршивые пошли времена, наёмник, суровые. До меня только что дошли вести, что пригород поселения %settlement% предали огню и мечу всего две ночи назад. Будь наготове."
		];

		this.m.IsStacking = false;
		this.m.ValidDays = 4;
	}

	function getAddedString( _s )
	{
		return _s + " теперь имеет статус " + this.m.Name;
	}

	function getRemovedString( _s )
	{
		return _s + " no longer is " + this.m.Name;
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
		_settlement.resetRoster(true);
	}

	function onUpdate( _modifiers )
	{
		_modifiers.RecruitsMult *= 0.65;
		_modifiers.RarityMult *= 0.65;
	}

});

