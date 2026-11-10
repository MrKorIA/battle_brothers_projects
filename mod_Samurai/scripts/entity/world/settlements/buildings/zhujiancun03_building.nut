this.zhujiancun03_building <- this.inherit("scripts/entity/world/settlements/buildings/marketplace_building", {
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
		this.m.ID = "building.zhujiancun03_building";
		this.m.Name = "Тайны самураев";
		this.m.Description = "Добудь легендарные самурайские сведения и брось им вызов, купив секретные знания.";
		this.m.UIImage = "ui/settlements/zhujiancun04";
		this.m.UIImageNight = "ui/settlements/zhujiancun04_n";
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

	function getDefaultShopList()
	{
		local list = [
			{
				R = 0,
				P = 0.75,
				S = "supplies/ground_grains_item"
			},
			{
				R = 0,
				P = 0.75,
				S = "supplies/medicine_item"
			}
		];
		local regular = [
			{ R = 0, P = 1.5, S = "misc/unhold_hide_item" },
			{ R = 0, P = 1.5, S = "misc/spider_silk_item" },
			{ R = 0, P = 1.5, S = "misc/poison_gland_item" },
			{ R = 0, P = 1.5, S = "misc/glowing_resin_item" },
			{ R = 0, P = 1.5, S = "misc/serpent_skin_item" },
			{ R = 0, P = 1.5, S = "misc/hyena_fur_item" },
			{ R = 0, P = 0.9, S = "trade/silk_item" },
			{ R = 0, P = 0.9, S = "trade/spices_item" },
			{ R = 0, P = 0.9, S = "trade/incense_item" },
			{ R = 0, P = 0.9, S = "trade/dies_item" },
			{ R = 0, P = 0.9, S = "trade/cloth_rolls_item" },
			{ R = 0, P = 1.5, S = "misc/paint_set_item" },
			{ R = 0, P = 1.5, S = "misc/paint_remover_item" },
			{ R = 0, P = 1.5, S = "misc/paint_black_item" },
			{ R = 0, P = 1.5, S = "misc/paint_red_item" },
			{ R = 0, P = 1.5, S = "misc/paint_orange_red_item" },
			{ R = 0, P = 1.5, S = "misc/paint_white_blue_item" },
			{ R = 0, P = 1.5, S = "misc/paint_white_green_yellow_item" }
		];
		local rare = [
			{ R = 0, P = 1.5, S = "misc/lindwurm_scales_item" },
			{ R = 0, P = 1.5, S = "misc/vampire_dust_item" },
			{ R = 0, P = 1.5, S = "misc/kraken_horn_plate_item" },
			{ R = 0, P = 1.5, S = "misc/heart_of_the_forest_item" }
		];
		local count = this.Math.rand(2, 3);

		for( local i = 0; i < count; i = ++i )
		{
			local index = this.Math.rand(0, regular.len() - 1);
			list.push(regular[index]);
			regular.remove(index);
		}

		list.push(rare[this.Math.rand(0, rare.len() - 1)]);
		return list;
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

