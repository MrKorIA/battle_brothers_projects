this.zhujiancun01_building <- this.inherit("scripts/entity/world/settlements/buildings/marketplace_building", {
	m = {},
	function create()
	{
		this.marketplace_building.create();
		this.m.UIImage = "ui/settlements/zhujiancun01";
		this.m.UIImageNight = "";
	}

// New Functions
	function getDefaultShopList()
	{
		local list = [
        {
            R = 20,
            P = 0.75,
            S = "weapons/wushiweapon03"
        },
        {
            R = 20,
            P = 0.75,
            S = "weapons/wushiweapon04"
        },
        {
            R = 20,
            P = 0.75,
            S = "weapons/wushiweapon05"
        },
        {
            R = 20,
            P = 0.75,
            S = "weapons/wushiweapon06"
        },
        {
            R = 20,
            P = 0.75,
            S = "weapons/wushiweapon07"
        },
        {
            R = 20,
            P = 0.75,
            S = "weapons/wushiweapon08"
        },
        {
            R = 20,
            P = 0.75,
            S = "weapons/wushiweapon09"
        },
        {
            R = 20,
            P = 0.75,
            S = "accessory/falcon_item"
        },
        {
            R = 20,
            P = 0.75,
            S = "ammo/quiver_of_arrows"
        },
        {
            R = 20,
            P = 0.75,
            S = "ammo/quiver_of_bolts"
        },
        {
            R = 20,
            P = 0.75,
            S = "weapons/throwing_spear"
        },
        {
            R = 20,
            P = 0.75,
            S = "accessory/bandage_item"
        },
        {
            R = 20,
            P = 0.75,
            S = "tools/throwing_net"
        },
        {
            R = 0,
            P = 0.75,
            S = "supplies/ground_grains_item"
        },
        {
            R = 10,
            P = 0.75,
            S = "supplies/medicine_item"
        }];

		if (::mods_getRegisteredMod("mod_fantasybro") != null)
		{
			list.push({
				R = 50,
				P = 1.0,
				S = "weapons/xxbamboospear"
			});
		}

		return list;
	}
});



