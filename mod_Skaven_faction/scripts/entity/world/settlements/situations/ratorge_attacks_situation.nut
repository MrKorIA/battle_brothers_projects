this.ratorge_attacks_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.ratorge_attacks";
		this.m.Name = "Нападения крысоогров";
		this.m.Description = "В окрестностях бродят жуткие порождения подземного мира - огромные крысоогры. Твари нападают на пригородные хутора, и напуганные горожане боятся даже нос высунуть за городские ворота.";
		this.m.Icon = "ui/settlement_status/rat_settlement_effect_02.png";
		this.m.Rumors = [
			"Бродячий купец сказывал, будто видел на тракте у поселения %settlement% следы чудовищных лап величиной с добрый щит. Упаси боги повстречать тварь, которая способна так вминать землю!",
			"Заходил я в %settlement% на днях - там траур. Целая отара егерей ушла в чащобу за каким-то лохматым великаном, да так и сгинула. Ни костей не нашли, ни оружия...",
			"Слыхал про крысоогров? Поганые чудища, они хребты боевым коням ломают с одного пинка и повозки в щепки крошат! Люди бают, видели этих тварей прямо у околицы поселения %settlement%."
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
		_modifiers.BuyPriceMult *= 1.1;
		_modifiers.SellPriceMult *= 0.9;
		_modifiers.RarityMult *= 0.9;
		_modifiers.RecruitsMult *= 0.75;
	}

});

