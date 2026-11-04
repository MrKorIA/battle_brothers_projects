this.cultist_incursion_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.cultist_incursion";
		this.m.Name = "Набег культистов";
		this.m.Description = "Культисты из расположенного неподалёку логова постоянно донимают эту деревню похищениями и набегами.";
		this.m.Icon = "ui/settlement_status/settlement_effect_37.png";
		this.m.Rumors = [
			"Несчастные жители поселения %settlement% подвергаются набегам со стороны культистов. Почему дворяне ничего не предпринимают?",
			"Ходят слухи, что поселение %settlement% было разорено бандой культистов.",
			"Говорят, неподалёку от поселения %settlement% есть тёмное логово нечистой силы, несущее смерть. Разумеется, я даже близко не подойду к этому проклятому месту!"
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 9999;
	}

	function getAddedString( _s )
	{
		return _s + " теперь имеет статус " + this.m.Name;
	}

	function getRemovedString( _s )
	{
		return _s + " утратил статус " + this.m.Name;
	}

	function onUpdate(_modifiers)
	{
		_modifiers.RecruitsMult *= 0.9;
		_modifiers.RarityMult *= 0.9;
	}
});

