this.fantasy_faction <- this.inherit("scripts/factions/faction", {
	m = {},
	function create()
	{
		this.faction.create();
		this.m.BannerPrefix = "banner_noble_"
		this.m.Banner = 14;
		this.m.Base = "world_base_07";
		this.m.TacticalBase = "bust_base_bandits";
		this.m.CombatMusic = this.Const.Music.BanditTracks;
		this.m.PlayerRelation = 50.0;
		this.m.IsHidden = false;
		this.m.IsRelationDecaying = false;
	}

	function onUpdateRoster()
	{
		local roster;
		local character;
		for( roster = this.getRoster(); roster.getSize() < 1;  )
		{
			character = roster.create("scripts/entity/tactical/enemies/xxmob_elfsword");
			character.setFaction(this.Const.Faction.PlayerAnimals);
			character.setAppearance();
			character.setName(this.Const.Strings.AncientDeadNames[this.Math.rand(0, this.Const.Strings.AncientDeadNames.len() - 1)])
			character.setTitle("the Great Adventurer");
			character.assignRandomEquipment();
		}
		character = roster.create("scripts/entity/tactical/humans/swordmaster");
		character.setFaction(this.Const.Faction.PlayerAnimals);
		character.setAppearance();
		character.setName(this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)])
		character.setTitle(this.Const.Strings.SwordmasterTitles[this.Math.rand(0, this.Const.Strings.SwordmasterTitles.len() - 1)]);
		character.assignRandomEquipment();
		character = roster.create("scripts/entity/tactical/humans/desert_devil");
		character.setFaction(this.Const.Faction.PlayerAnimals);
		character.setAppearance();
		character.setName(this.Const.Strings.SouthernNames[this.Math.rand(0, this.Const.Strings.SouthernNames.len() - 1)])
		character.setTitle(this.Const.Strings.NomadChampionTitles[this.Math.rand(0, this.Const.Strings.NomadChampionTitles.len() - 1)]);
		character.assignRandomEquipment();
		character = roster.create("scripts/entity/tactical/humans/barbarian_champion");
		character.setFaction(this.Const.Faction.PlayerAnimals);
		character.setAppearance();
		character.setName(this.Const.Strings.BarbarianNames[this.Math.rand(0, this.Const.Strings.BarbarianNames.len() - 1)])
		character.setTitle(this.Const.Strings.BarbarianTitles[this.Math.rand(0, this.Const.Strings.BarbarianTitles.len() - 1)]);
		character.assignRandomEquipment();
	}

	function getBannerSmall()
	{
		return this.m.BannerPrefix + (this.m.Banner < 10 ? "0" + this.m.Banner : this.m.Banner)
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

