this.legend_mummy_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "Древние руины, выполненные в невиданном доселе архитектурном стиле.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.legend_mummy";
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = true;
		this.m.IsAttackable = false;
		this.m.IsDestructible = false;
		this.m.VisibilityMult = 0.8;
		this.m.Resources = 0;
		this.m.OnEnter = "event.location.legend_mummy_enter";
	}

	function onSpawned()
	{
		this.m.Name = "Древняя пирамида";
		this.location.onSpawned();
	}

	function onDiscovered()
	{
		this.location.onDiscovered();
		this.World.Flags.increment("LegendaryLocationsDiscovered", 1);
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("legend_pyramid");
		local banner = this.addSprite("banner");
		banner.setOffset(this.createVec(-60, 50));
	}

	function onDropLootForPlayer ( _lootTable )
	{
		this.location.onDropLootForPlayer(_lootTable);
		this.dropArmorParts(this.Math.rand(0, 60), _lootTable);
		local loot = [  "loot/white_pearls_item",
                        "loot/jeweled_crown_item",
                        "loot/gemstones_item",
                        "loot/golden_chalice_item",
                        "loot/ancient_gold_coins_item"
        ];
        if (::mods_getRegisteredMod("mod_fantasybro") != null)
            loot.push("misc/xxsbook_se");
		this.dropTreasure(this.Math.rand(3, 4), loot, _lootTable);
	}

});

