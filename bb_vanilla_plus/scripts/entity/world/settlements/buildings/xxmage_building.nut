this.xxmage_building <- this.inherit("scripts/entity/world/settlements/buildings/building", {
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
		this.m.ID = "building.xxmage_building";
		this.m.Name = "Mage Shop";
		this.m.Description = this.Const.Strings.FT.ShopText;
		this.m.UIImage = "ui/settlements/desert_building_14";
		this.m.UIImageNight = "ui/settlements/desert_building_14_night";
		this.m.Tooltip = "world-town-screen.main-dialog-module.MageShop";
		this.m.TooltipIcon = "ui/icons/special.png";
		this.m.IsRepairOffered = true;
		this.m.Stash = this.new("scripts/items/stash_container");
		this.m.Stash.setID("shop");
		this.m.Stash.setResizable(true);
		this.m.Sounds = [
			{
				File = "ambience/buildings/alchemist_cooking_pot_01.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/alchemist_cooking_pot_02.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/alchemist_cooking_pot_03.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/alchemist_cooking_pot_04.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/alchemist_cooking_pot_05.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/alchemist_creaking_door_01.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/alchemist_grinder_01.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/alchemist_grinder_02.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/alchemist_metal_pot_01.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/alchemist_metal_pot_02.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/alchemist_metal_pot_03.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/alchemist_metal_pot_03.wav",
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
				S = "misc/xxsbook"
			},
			{
				S = "misc/xxsc_helmet"
			},
			{
				S = "misc/xxsc_armor"
			},
			{
				S = "misc/xxtransmog_helmet"
			},
			{
				S = "misc/xxtransmog_armor"
			},
			{
				S = "armor_upgrades/xxcape_upgrade"
			},
			{
				S = "misc/xxchangepotion"
			}
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
			for (local num = 0; num < 10; ++num)
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

