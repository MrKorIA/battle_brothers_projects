this.xxmarketplace_building <- this.inherit("scripts/entity/world/settlements/buildings/marketplace_building", {
	m = {
		Stash = null
	},
	function getStash()
	{
		return this.m.Stash;
	}

	function create()
	{
		this.building.create();
		this.m.ID = "building.xxmarketplace_building";
		this.m.Name = "Рынок воров";
		this.m.Description = "Здесь вы можете покупать и продавать предметы или ремонтировать оборудование.";
		this.m.UIImage = "ui/settlements/building_06";
		this.m.UIImageNight = "ui/settlements/building_06_night";
		this.m.Tooltip = "world-town-screen.main-dialog-module.ThievesMarket";
		this.m.TooltipIcon = "ui/icons/special.png";
		this.m.IsRepairOffered = true;
		this.m.Stash = this.new("scripts/items/stash_container");
		this.m.Stash.setID("shop");
		this.m.Stash.setResizable(true);
		this.m.Sounds = [
			{
				File = "ambience/buildings/market_people_00.wav",
				Volume = 0.4,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_01.wav",
				Volume = 0.6,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_02.wav",
				Volume = 0.8,
			Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_03.wav",
				Volume = 0.8,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_04.wav",
				Volume = 0.8,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_05.wav",
				Volume = 0.8,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_07.wav",
				Volume = 0.8,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_08.wav",
				Volume = 0.8,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_09.wav",
				Volume = 0.8,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_10.wav",
				Volume = 0.8,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_11.wav",
				Volume = 0.8,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_12.wav",
				Volume = 0.8,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_13.wav",
				Volume = 0.8,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_14.wav",
				Volume = 0.8,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_pig_00.wav",
				Volume = 0.9,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_pig_01.wav",
				Volume = 0.9,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_pig_02.wav",
				Volume = 0.9,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_pig_03.wav",
				Volume = 0.9,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_pig_04.wav",
				Volume = 0.9,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_chicken_00.wav",
				Volume = 0.9,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_chicken_01.wav",
				Volume = 0.9,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_chicken_02.wav",
				Volume = 0.9,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_chicken_03.wav",
				Volume = 0.9,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_chicken_04.wav",
				Volume = 0.9,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_chicken_05.wav",
				Volume = 0.9,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_bottles_00.wav",
				Volume = 1.0,
				Pitch = 1.0
			}
		];
		this.m.SoundsAtNight = [];
	}


	function onClicked( _townScreen )
	{
		_townScreen.getShopDialogModule().setShop(this);
		_townScreen.showShopDialog();
		this.pushUIMenuStack();
	}

	function onSettlementEntered()
	{
		foreach( item in this.m.Stash.getItems() )
		{
			if (item != null)
			{
				item.setSold(false);
			}
		}
	}

	function onUpdateShopList()
	{
		local list = [
			{
				R = 25,
				P = 1.0,
				S = "weapons/xxarcanespear"
			},
			{
				R = 25,
				P = 1.0,
				S = "weapons/xxdragonsw"
			},
			{
				R = 24,
				P = 1.0,
				S = "weapons/xxheavylance"
			},
			{
				R = 25,
				P = 1.0,
				S = "weapons/xxkatar"
			},
			{
				R = 25,
				P = 1.0,
				S = "weapons/xxkusarigama"
			},
			{
				R = 24,
				P = 1.0,
				S = "weapons/xxlefts"
			},
			{
				R = 25,
				P = 1.0,
				S = "weapons/xxmagicstaff"
			},
			{
				R = 25,
				P = 1.0,
				S = "weapons/xxmeteor"
			},
			{
				R = 25,
				P = 1.0,
				S = "weapons/xxmstaff"
			},
			{
				R = 25,
				P = 1.0,
				S = "weapons/xxnodachi"
			},
			{
				R = 25,
				P = 1.0,
				S = "weapons/xxrifle"
			},
			{
				R = 25,
				P = 1.0,
				S = "weapons/xxringblade"
			},
			{
				R = 25,
				P = 1.0,
				S = "weapons/xxruneblade"
			},
			{
				R = 25,
				P = 1.0,
				S = "misc/xxsc_helmet"
			},
			{
				R = 25,
				P = 1.0,
				S = "misc/xxsc_armor"
			},
			{
				R = 10,
				P = 1.0,
				S = "special/bodily_reward_item"
			},
			{
				R = 25,
				P = 1.0,
				S = "shields/xxhorse_shield"
			},
			{
				R = 25,
				P = 1.0,
				S = "shields/xxheavyhorse_shield"
			}
		];
		list.extend(list);
		list.extend([
			{
				R = 20,
				P = 1.0,
				S = "accessory/falcon_item"
			},
			{
				R = 20,
				P = 1.0,
				S = "ammo/quiver_of_arrows"
			},
			{
				R = 20,
				P = 1.0,
				S = "ammo/quiver_of_bolts"
			},
			{
				R = 20,
				P = 1.0,
				S = "ammo/powder_bag"
			},
			{
				R = 20,
				P = 1.0,
				S = "accessory/bandage_item"
			},
			{
				R = 20,
				P = 1.0,
				S = "accessory/antidote_item"
			},
			{
				R = 20,
				P = 1.0,
				S = "tools/throwing_net"
			},
			{
				R = 0,
				P = 1.0,
				S = "supplies/ground_grains_item"
			},
			{
				R = 10,
				P = 1.0,
				S = "supplies/medicine_item"
			},
			{
				R = 10,
				P = 1.0,
				S = "supplies/ammo_item"
			},
			{
				R = 10,
				P = 1.0,
				S = "supplies/armor_parts_item"
			}
		]);
		list.extend([
			{
				R = 25,
				P = 1.0,
				S = "weapons/xxtorch"
			},
			{
				R = 25,
				P = 1.0,
				S = "weapons/xxbamboospear"
			},
			{
				R = 25,
				P = 1.0,
				S = "weapons/xxcestus"
			},
			{
				R = 25,
				P = 1.0,
				S = "weapons/xxcestusb"
			},
			{
				R = 25,
				P = 1.0,
				S = "weapons/xxshuriken"
			},
			{
				R = 25,
				P = 1.0,
				S = "accessory/xxdefring"
			},
			{
				R = 25,
				P = 1.0,
				S = "accessory/xxatkring"
			},
			{
				R = 25,
				P = 1.0,
				S = "accessory/xxbloodring"
			},
			{
				R = 25,
				P = 1.0,
				S = "misc/xxsbook"
			}
		]);
		this.m.Settlement.onUpdateShopList(this.m.ID, list);
		this.fillStash(list, this.m.Stash, 0.92, false);
	}

	function onSerialize( _out )
	{
		this.building.onSerialize(_out);
		this.m.Stash.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.building.onDeserialize(_in);
		this.m.Stash.onDeserialize(_in);
	}

});

