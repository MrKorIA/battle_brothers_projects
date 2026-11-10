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
        this.m.OnEnterCallback = function( _settlement ) {};
		this.m.IsVisited = true;
		this.m.IsAttackable = false;
		this.m.IsDestructible = false;
		this.m.IsAttackableByAI = false;
		this.m.IsShowingStrength = false;
		this.m.IsScalingDefenders = false;
		this.m.IsShowingLabel = true;
		this.m.IsShowingBanner = true;
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
		this.updateBuildings();
		this.updateQuests();
		this.updateRoster();
		this.updateShop();
		this.Math.seedRandom(this.Time.getRealTime());
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
		return this.settlement.getContracts();
	}

	function updateQuests()
	{
		local stage = this.getFlags().getAsInt("ZhujiancunStage");

		if (stage >= 4)
		{
			return;
		}

		local nextContractTime = this.getFlags().getAsFloat("ZhujiancunNextContractTime");

		if (nextContractTime > 0 && this.Time.getVirtualTimeF() < nextContractTime)
		{
			return;
		}

		local faction = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zhujiancun);

		foreach( contract in faction.getContracts() )
		{
			if (contract.getType() == "contract.zhujiancun" && contract.getHome() != null && !contract.getHome().isNull() && contract.getHome().getID() == this.getID())
			{
				return;
			}
		}

		local contract = this.new("scripts/contracts/contracts/zhujiancun_contract");
		contract.setStage(stage + 1);
		contract.setHome(this);
		contract.setOrigin(this);
		contract.setFaction(faction.getID());

		if (faction.getRoster().getSize() == 0)
		{
			faction.onUpdateRoster();
		}

		contract.setEmployerID(faction.getRandomCharacter().getID());

		this.World.Contracts.addContract(contract);
		contract.m.TimeOut = 0.0;
	}

	function updateBuildings()
	{
		local stage = this.getFlags().getAsInt("ZhujiancunStage");
		local slots = [2, 5, 1, 4];
		local buildings = [
			"scripts/entity/world/settlements/buildings/zhujiancun01_building",
			"scripts/entity/world/settlements/buildings/zhujiancun_building",
			"scripts/entity/world/settlements/buildings/zhujiancun02_building",
			"scripts/entity/world/settlements/buildings/zhujiancun03_building"
		];

		for( local i = 0; i < buildings.len(); i = ++i )
		{
			if (stage > i)
			{
				if (this.m.Buildings[slots[i]] == null)
				{
					this.addBuilding(this.new(buildings[i]), slots[i]);
				}
			}
			else
			{
				this.m.Buildings[slots[i]] = null;
			}
		}
	}

	function completeContractStage( _stage )
	{
		if (_stage != this.getFlags().getAsInt("ZhujiancunStage") + 1)
		{
			return;
		}

		this.getFlags().set("ZhujiancunStage", _stage);
		this.getFlags().set("ZhujiancunNextContractTime", _stage < 4 ? this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 10.0 : 0.0);
		this.updateBuildings();
		this.updateShop(true);

		if (_stage == 2)
		{
			this.updateRoster(true);
		}
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

	function onDeserialize( _in )
	{
		this.settlement.onDeserialize(_in);
		this.updateBuildings();
	}

});

