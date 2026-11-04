this.ratbeast_faction <- this.inherit("scripts/factions/faction", {
	m = {},
	function create()
	{
		this.faction.create();
		this.m.Type = this.Const.FactionType.RatBeast;
		this.m.Base = "world_base_rat";
		this.m.TacticalBase = "bust_base_rat";
		this.m.CombatMusic = this.Const.Music.RatTracks;
		this.m.Footprints = this.Const.SkavenFootprints;
		this.m.PlayerRelation = 0.0;
		this.m.IsHidden = true;
		this.m.IsRelationDecaying = false;
	}

	function onSerialize( _out )
	{
		this.faction.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.faction.onDeserialize(_in);
	}
    
});

