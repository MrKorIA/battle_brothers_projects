this.cultist_faction <- this.inherit("scripts/factions/faction", {
	m = {},
	function create()
	{
		this.faction.create();
		this.m.Type = this.Const.FactionType.Cultists;
		this.m.Banner = 13;
		this.m.Base = "world_base_07";
		this.m.TacticalBase = "bust_base_mod_cultist";
		this.m.CombatMusic = this.Const.Music.CultistTracks;
		this.m.PlayerRelation = 0.0;
		this.m.IsHidden = true;
		this.m.IsRelationDecaying = false;
		this.m.CanSpawnSettlement <- false;
		this.m.BannerPrefix = "banner_"
	}
	function onUpdate()
	{
		this.faction.onUpdate();

		//add legendary location if added during worldgen
		if (this.World.Flags.get("spawnedLegendaryCultistLocation") &&  this.getFlags().get("addedLegendaryCultistLocation") == false)
		{
			foreach(location in this.World.EntityManager.getLocations())
			{
				if (location.m.TypeID == "location.cultist_legendary_camp")
				{
					this.getFlags().set("addedLegendaryCultistLocation", true)
					this.addSettlement(location, false);
					break;
				}
			}		
		}

		if(this.isDebug("mod_cultists")){
			foreach(location in this.getSettlements()) location.getSprite("selection").Visible = true;
			foreach (unit in this.m.Units) unit.getSprite("selection").Visible = true;
		}
	}
	
	function addTrait( _list )
	{
		this.m.Deck = [];
		foreach( c in _list )
		{
			local card = this.new(c);
			card.setFaction(this);
			this.m.Deck.push(card);
		}
	}
	
	function getLairs(){
		local lairs = []
		foreach (location in this.getSettlements()){
			if (location != null && location.m.TypeID == "location.cultist_camp"){
		    	lairs.push(location)
		    }
		}
		return lairs
	}
	
	function hasLairs(){
		return this.getLairs().len() != 0
	}

	function getLegendary(){
		foreach (location in this.getSettlements()){
			if (location != null && location.m.TypeID == "location.cultist_legendary_camp"){
		    	return location
		    }
		}

	}

	function getSettlementSpawn()
	{
		local smallcount = 0;
		local settlements = this.getLairs()
		foreach (settlement in settlements){
			if (settlement.m.Size < 3){
				smallcount++
			}
		}
		return smallcount < this.Const.CultistConfig.MaxLairsInDevelopment
	}


	function isReadyToSpawnUnit()
	{
		return this.m.Units.len() <= 4;
	}

	function recomputeFanatics(_spawnlist, _overwriteOdds = null)
	{
		
		local timeScalingFanaticOdds = 0.01 * this.Math.maxf(this.Const.CultistConfig.EnlightenedFanaticMinOdds, this.Const.CultistConfig.EnlightenedFanaticMaxOdds * this.Math.minf(1.0, this.World.getTime().Days /this.Const.CultistConfig.EnlightenedFanaticMaxDay));
		if(_overwriteOdds != null) timeScalingFanaticOdds = _overwriteOdds 
		local enlightened, fanaticOddsFinal, partyResources, partyFanaticOdds, enlightenedNum
		local highestPartyResources = _spawnlist[_spawnlist.len()-1].Cost
		foreach(party in _spawnlist)
		{
			if (party.Fanatics == 0) continue
			partyResources = party.Cost;
			// this.printDebug("highestPartyResources" + highestPartyResources + " partyResources " + partyResources, "mod_cultists");
			partyFanaticOdds = (partyResources.tofloat() / highestPartyResources.tofloat()) * 0.4;
			// this.printDebug("partyFanaticOdds: " + partyResources / highestPartyResources, "mod_cultists");
			fanaticOddsFinal = partyFanaticOdds + timeScalingFanaticOdds;
			// this.printDebug("partyFanaticOdds: " + partyFanaticOdds + " timeScalingFanaticOdds: " + timeScalingFanaticOdds + " final " + fanaticOddsFinal, "mod_cultists");
			enlightenedNum = this.Math.floor(party.Fanatics * fanaticOddsFinal)

			foreach (troop in party.Troops)
			{
				if (troop.Type == this.Const.World.Spawn.Troops.Cultist_Fanatic)
				{
					troop.Num = party.Fanatics - enlightenedNum
				}
				if (troop.Type == this.Const.World.Spawn.Troops.Cultist_Fanatic_Enlightened){
					troop.Num = enlightenedNum;
				}
			}
			//this.printDebug("Количество просвещенных фанатиков: " + enlightenedNum, "mod_cultists");	
		}
	}

	function spawnCultistEntity( _tile, _name, _uniqueName, _template, _resources, _minibossify = 0 )
	{
		this.recomputeFanatics(_template)
		//cultist party instead of normal party
		local party = this.World.spawnEntity("scripts/entity/world/cultist_party", _tile.Coords);
		party.setFaction(this.getID());

		if (_uniqueName)
		{
			_name = this.getUniqueName(_name);
		}

		party.setName(_name);
		local t;

		if (_template != null)
		{
			t = this.Const.World.Common.assignTroops(party, _template, _resources);
		}

		party.getSprite("base").setBrush(this.m.Base);

		if (t != null)
		{
			party.getSprite("body").setBrush(t.Body);
		}
		if (_resources <= 150) party.getSprite("body").setBrush("figure_cultists_mod_02")
		else if (_resources <= 300) party.getSprite("body").setBrush("figure_cultists_mod_03")
		else party.getSprite("body").setBrush("figure_cultists_mod_01")


		if (this.m.BannerPrefix != "")
		{
			party.getSprite("banner").setBrush(this.m.BannerPrefix + (this.m.Banner < 10 ? "0" + this.m.Banner : this.m.Banner));
		}

		this.addUnit(party);
		return party;
	}
	
	function getBannerSmall()
	{
		return this.m.BannerPrefix + (this.m.Banner < 10 ? "0" + this.m.Banner : this.m.Banner)
	}

	function onSerialize( _out )
	{
		this.faction.onSerialize(_out);
		_out.writeBool(this.m.CanSpawnSettlement);
	}

	function onDeserialize( _in )
	{
		this.faction.onDeserialize(_in);
		this.m.CanSpawnSettlement = _in.readBool()
	
		this.addTrait(this.Const.CultistTraits)
	}

});

