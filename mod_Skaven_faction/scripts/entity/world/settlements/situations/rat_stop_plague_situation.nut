this.rat_stop_plague_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.rat_stop_plague";
		this.m.Name = "Отступление чумы";
		this.m.Description = "Страшное поветрие в поселении %settlement% наконец-то удалось обуздать. Массовый мор прекратился, улицы очищены от скверны, а выжившие медленно возвращаются к мирной жизни. Город постепенно восстанавливает силы.";
		this.m.Icon = "ui/settlement_status/rat_settlement_effect_04.png";
		this.m.Rumors = [
			"Слыхали добрые вести? Чёрная смерть отступила от поселения %settlement%. Чумные доктора всё-таки сотворили чудо, выжгли заразу дотла. Скоро и торговые тракты откроют.",
			"Я как раз прибыл со стороны поселения %settlement% минувшей ночью. Мору конец, дышать в городе стало легче, слава богам. Думал, все там поляжем, ан нет - пронесло."
		];
		this.m.IsStacking = false;
	}

	function onAdded( _settlement )
	{
		_settlement.removeSituationByID("situation.rat_plague_outbreak");
		_settlement.resetShop();
	}

	function onUpdate( _modifiers )
	{
		_modifiers.PriceMult *= 1.1;
		_modifiers.RecruitsMult *= 1.3;
	}

});

