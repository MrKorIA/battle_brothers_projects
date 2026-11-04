this.zhujiancun <- this.inherit("scripts/entity/world/settlement", {
	m = {},
	function create()
	{
		this.settlement.create();
		this.m.Name = "Деревня Меча"
		this.m.DraftList = [
            "jianhao_background",
            "jianhao_background",
            "langren_background",
            "langren_background",
            "wushi_background",
            "wushi_background",
            "renzhe_background",
            "renzhe_background"
		
		];
		this.m.UIDescription = "Деревня, утопающая в цветах сакуры, где живут самураи.";
		this.m.Description = "Деревня, утопающая в цветах сакуры, где живут самураи.";
		this.m.UIBackgroundCenter = "ui/settlements/zhujiancun";
		this.m.UIBackgroundLeft = "ui/settlements/water_01";
		this.m.UIBackgroundRight = "ui/settlements/zhujiancun_houses_01_right";
//		this.m.UIRampPathway = "ui/settlements/zhujiancun_ramp_01";
		this.m.UISprite = "ui/settlement_sprites/wushi_townhall_01.png";
		this.m.Sprite = "wushi_townhall_01";
		this.m.Lighting = "wushi_townhall_01_light";
		this.m.Rumors = this.Const.Strings.RumorsFarmingSettlement;
		this.m.Culture = this.Const.World.Culture.Neutral;
		this.m.Size = 3;
		this.m.LocationType = ::Const.World.LocationType.Unique;
		this.m.ShopSeed = this.Time.getRealTime() + this.Math.rand();
		this.m.RosterSeed = this.Time.getRealTime() + this.Math.rand();
		this.m.VisibilityMult = 1.5;
		this.m.Banner = this.World.Assets.getBannerID();
		this.m.IsShowingBanner = true;
		this.getFlags().set("IsSecondaryBase", true);
//		this.m.IsActive = true;
        this.m.OnEnterCallback = function( _settlement ) {};
		this.m.IsVisited = true;
		this.m.IsAttackable = false;
		this.m.IsDestructible = false;
		this.m.IsAttackableByAI = false;
		this.m.IsShowingStrength = false;
		this.m.IsScalingDefenders = false;
		this.m.IsShowingLabel = true;
		this.m.IsShowingBanner = true;
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/zhujiancun_building"), 5);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/zhujiancun01_building"), 2);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/zhujiancun02_building"), 1);
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/zhujiancun03_building"), 4);
	}

	function onInit()
	{
        this.settlement.onInit();
		this.m.UIForeground = "ui/settlements/foreground_01";
		this.m.UIRamp = "ui/settlements/zhujiancun_ramp_01";
    }
	
	function onEnter()
	{
		this.location.onEnter();
		this.updateRoster();
		this.updateShop();
		this.Math.seedRandom(this.Time.getRealTime());
//		this.m.IsVisited = false;
		return true;
	}

	function onUpdateShopList( _id, _list )
	{
		foreach( loc in this.m.AttachedLocations )
		{
			if (loc.isActive())
			{
				loc.onUpdateShopList(_id, _list);
			}
		}
	}

	function isEnterable()
	{
		if (!this.m.IsActive)
		{
			return false;
		}
		return true;
	}

	function getContracts()
	{
		return [];
	}

	function getFactionOfType( _type )
	{
		if (_type == ::Const.FactionType.Settlement)
		{
			foreach (i in this.m.Factions)
			{
				local f = this.World.FactionManager.getFaction(i);

				if ("ZhujiancunFaction_SecondaryType" in f.m && f.m.ZhujiancunFaction_SecondaryType == ::Const.FactionType.Settlement)
				{
					return f;
				}
			}
		}

		return this.settlement.getFactionOfType(_type);
	}

    function updateRoster( _force = false )
    {
        local daysPassed = (this.Time.getVirtualTimeF() - this.m.LastRosterUpdate) / this.World.getTime().SecondsPerDay;
        if (!_force && this.m.LastRosterUpdate != 0 && daysPassed < 2)
        {
            return;
        }
        if (this.m.RosterSeed != 0)
        {
            this.Math.seedRandom(this.m.RosterSeed);
        }
        this.m.RosterSeed = this.Math.floor(this.Time.getRealTime() + this.Math.rand());
        this.m.LastRosterUpdate = this.Time.getVirtualTimeF();
        local roster = this.World.getRoster(this.getID());
        local current = roster.getAll();
        local iterations = this.Math.max(1, daysPassed / 2);
        local rosterMin = 4 + this.World.Assets.m.RosterSizeAdditionalMin;
        local rosterMax = 7 + this.World.Assets.m.RosterSizeAdditionalMax;
        if (iterations < 7)
        {
            for( local i = 0; i < iterations; i = ++i )
            {
                for( local maxRecruits = this.Math.rand(this.Math.max(0, rosterMax / 2 - 1), rosterMax - 1); current.len() > maxRecruits;  )
                {
                    local n = this.Math.rand(0, current.len() - 1);
                    roster.remove(current[n]);
                    current.remove(n);
                }
            }
        }
        else
        {
            roster.clear();
            current = [];
        }
        local maxRecruits = this.Math.rand(rosterMin, rosterMax);
        local draftList;
        draftList = clone this.m.DraftList;
        this.World.Assets.getOrigin().onUpdateDraftList(draftList);
        while (maxRecruits > current.len())
        {
            local bro = roster.create("scripts/entity/tactical/player");
            bro.setStartValuesEx(draftList);
            current.push(bro);
        }
        this.World.Assets.getOrigin().onUpdateHiringRoster(roster);
    }

});

