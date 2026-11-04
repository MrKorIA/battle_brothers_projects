this.mgl_faction <- this.inherit("scripts/factions/faction", {
	m = {},
	function create()
	{
		this.faction.create();
		this.m.Type = this.Const.FactionType.Mgl;
		this.m.Base = "world_base_07";
		this.m.TacticalBase = "bust_base_mgl";
		this.m.CombatMusic = this.Const.Music.MglTracks;
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

