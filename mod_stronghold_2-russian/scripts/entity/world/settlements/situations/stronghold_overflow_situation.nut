this.stronghold_overflow_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {
		Home = null
	},

	function create()
	{
		this.situation.create();
		this.m.ID = "situation.stronghold_overflow";
		this.m.Description = "У вас слишком много предметов! Зайдите в хранилище и соберите их, прежде чем покинуть базу."
		this.m.Icon = "ui/settlement_status/stronghold_overflow.png";
		this.m.IsStacking = false;
		
	}

	function isValid()
	{
		return true;
	}

	function onUpdate( _modifiers )
	{
	}

});

