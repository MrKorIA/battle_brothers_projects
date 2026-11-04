this.zhujiancun01_building <- this.inherit("scripts/entity/world/settlements/buildings/marketplace_building", {
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
		this.m.ID = "building.zhujiancun01_building";
		this.m.Name = "Самурайский караван";
		this.m.Description = "Самурайские караваны приходят сюда торговать.";
		this.m.UIImage = "ui/settlements/zhujiancun01";
		this.m.UIImageNight = "";
		this.m.Tooltip = "world-town-screen.main-dialog-module.Marketplace";
		this.m.TooltipIcon = "ui/icons/special.png";
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
			},
			
		];

		this.m.Settlement.onUpdateShopList(this.m.ID, list);
		this.XfillStash(list, this.m.Stash);
	}

	function fillStash( _list, _stash, _priceMult, _allowDamagedEquipment )
	{
		return;
	}

	function XfillStash( _list, _stash)
	{
		_stash.clear();
		foreach( i in _list )
		{
			for (local num = 0; num < 5; ++num)
			{
				local item = this.new("scripts/items/" + i.S);
				_stash.add(item);
			}
		}
		_stash.sort();
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

