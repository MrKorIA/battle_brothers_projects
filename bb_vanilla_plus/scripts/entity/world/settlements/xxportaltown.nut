this.xxportaltown <- this.inherit("scripts/entity/world/settlement", {
	m = {},
	function create()
	{
		this.settlement.create();
		this.m.Name = this.Const.Strings.FT.PortalGateName;
		this.m.DraftList = [];
		this.m.UIDescription = this.Const.Strings.FT.PortalGateText;
		this.m.Description = this.Const.Strings.FT.PortalGateText;
		this.m.UIBackgroundCenter = "ui/settlements/foreground_01";
		this.m.UIBackgroundLeft = "ui/settlements/foreground_01";
		this.m.UIBackgroundRight = "ui/settlements/foreground_01";
		this.m.UIRampPathway = "ui/settlements/desert_ramp_01_cobblestone";
		this.m.UISprite = "ui/settlements/mood_dark_mountains";
		this.m.Sprite = "world_portalgate";
		this.m.Rumors = this.Const.Strings.RumorsFarmingSettlement;
		this.m.Culture = this.Const.World.Culture.Neutral;
		this.m.Size = 3;
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.VisibilityMult = 1.57;
		this.m.Banner = "";
		this.addBuilding(this.new("scripts/entity/world/settlements/buildings/xxport_building"), 1);
		this.m.IsVisited = true;
		this.m.IsAttackable = false;
		this.m.IsDestructible = false;
		this.m.IsAttackableByAI = false;
		this.m.IsShowingStrength = false;
		this.m.IsScalingDefenders = false;
		this.m.IsShowingLabel = true;
		this.m.IsShowingBanner = false;
	}

	function onInit()
	{
        	this.settlement.onInit();
		::World.EntityManager.removeSettlement(this);
        }
	
	function onEnter()
	{
		this.location.onEnter();
		this.Math.seedRandom(this.Time.getRealTime());
		return true;
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

	function getSellPriceMult()
	{
		return 1;
	}

});

