this.zhujiancun_faction <- this.inherit("scripts/factions/faction", {
    m = {
        ZhujiancunFaction_SecondaryType = ::Const.FactionType.Settlement
    },
    function create()
    {
        this.faction.create();
		this.m.Type = this.Const.FactionType.Zhujiancun;
        this.m.BannerPrefix = "zhujiancun_";
        this.m.Banner = 1;
        this.m.Base = "world_base_07";
        this.m.TacticalBase = "bust_base_wushi";
        this.m.CombatMusic = this.Const.Music.WushiTracks;
        this.m.PlayerRelation = 50.0;
        this.m.IsHidden = false;
        this.m.IsRelationDecaying = false;
        this.setDescription("Нейтральное поселение изгоев и беженцев из дальнего востока.");
    }

    function onUpdateRoster()
    {
        local roster = this.getRoster();
        local character;
//        for( roster = this.getRoster(); roster.getSize() < 1;  )
//        {
//            character = roster.create("scripts/entity/tactical/enemies/xxmob_elfsword");
//            character.setFaction(this.Const.Faction.PlayerAnimals);
//            character.setAppearance();
//            character.setName(this.Const.Strings.AncientDeadNames[this.Math.rand(0, this.Const.Strings.AncientDeadNames.len() - 1)])
//            character.setTitle("the Great Adventurer");
//            character.assignRandomEquipment();
//        }
        character = roster.create("scripts/entity/tactical/humans/jianhao");
        character.setFaction(this.Const.Faction.PlayerAnimals);
        character.setAppearance();
        character.setName(this.Const.Strings.WushiNames[this.Math.rand(0, this.Const.Strings.WushiNames.len() - 1)])
        character.setTitle(this.Const.Strings.SwordmasterTitles[this.Math.rand(0, this.Const.Strings.SwordmasterTitles.len() - 1)]);
        character.readyToSettlement();
//        character.m.Items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
        character = roster.create("scripts/entity/tactical/humans/jiangjun");
        character.setFaction(this.Const.Faction.PlayerAnimals);
        character.setAppearance();
        character.setName(this.Const.Strings.WushiNames[this.Math.rand(0, this.Const.Strings.WushiNames.len() - 1)])
        character.setTitle(this.Const.Strings.NomadChampionTitles[this.Math.rand(0, this.Const.Strings.NomadChampionTitles.len() - 1)]);
        character.readyToSettlement();
//        character.m.Items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
        character = roster.create("scripts/entity/tactical/humans/langren");
        character.setFaction(this.Const.Faction.PlayerAnimals);
        character.setAppearance();
        character.setName(this.Const.Strings.WushiNames[this.Math.rand(0, this.Const.Strings.WushiNames.len() - 1)])
        character.setTitle(this.Const.Strings.SwordmasterTitles[this.Math.rand(0, this.Const.Strings.SwordmasterTitles.len() - 1)]);
        character.readyToSettlement();
//        character.m.Items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
    }
//
    function getBannerSmall()
    {
        return this.m.BannerPrefix + (this.m.Banner < 10 ? "0" + this.m.Banner : this.m.Banner);
    }

	function getUIBanner()
	{
		return "ui/banners/factions/zhujiancun_" + (this.m.Banner < 10 ? "0" + this.m.Banner : this.m.Banner) + ".png";
	}

	function getUIBannerSmall()
	{
		return "ui/banners/factions/zhujiancun_" + (this.m.Banner < 10 ? "0" + this.m.Banner : this.m.Banner) + "s.png";
	}

	function getNameOnly()
	{
		return this.m.Name;
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

