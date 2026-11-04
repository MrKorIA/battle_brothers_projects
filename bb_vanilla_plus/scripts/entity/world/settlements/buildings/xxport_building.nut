this.xxport_building <- this.inherit("scripts/entity/world/settlements/buildings/building", {
	m = {},
	function create()
	{
		this.building.create();
		this.m.ID = "building.port";
		this.m.Name = this.Const.Strings.FT.PortalGateName;
		this.m.Description = this.Const.Strings.FT.PortalGateText;
		this.m.UIImage = "ui/xbuilding_02";
		this.m.UIImageNight = "ui/xbuilding_02_night";
		this.m.Tooltip = "world-town-screen.main-dialog-module.PortalGate";
		this.m.TooltipIcon = "ui/icons/special.png";
		this.m.IsClosedAtNight = false;
		this.m.Sounds = [
			{
				File = "ambience/buildings/docks_rope_00.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/docks_rope_01.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/docks_bell_00.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/docks_bell_01.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/docks_bell_02.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/docks_flapping_sail_00.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/docks_flapping_sail_01.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/docks_ship_creaking_01.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/docks_ship_creaking_02.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/docks_ship_creaking_03.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/docks_ship_creaking_04.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/docks_working_00.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/docks_working_01.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/docks_working_02.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/docks_working_03.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/docks_working_04.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/terrain/coast_seagull_00.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/terrain/coast_seagull_01.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/terrain/coast_seagull_02.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/terrain/coast_seagull_03.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/terrain/coast_seagull_04.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/terrain/coast_seagull_05.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/terrain/coast_small_waves_00.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/terrain/coast_small_waves_01.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/terrain/coast_small_waves_02.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/terrain/coast_small_waves_03.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/terrain/coast_small_waves_04.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/terrain/coast_small_waves_05.wav",
				Volume = 1.0,
				Pitch = 1.0
			}
		];
		this.m.SoundsAtNight = [
			{
				File = "ambience/buildings/docks_rope_00.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/docks_rope_01.wav",
				Volume = 1.0,
				Pitch = 1.0
			}
		];
	}

	function onClicked( _townScreen )
	{
		local z = this.World.Contracts.getActiveContract();
		if (z != null)
		{
			local a = z.getType();
			if (a == "contract.escort_caravan" || a == "contract.deliver_item" || a == "contract.escort_caravan")
			{
				return;
			}
		}

		_townScreen.getTravelDialogModule().setData(this.getUITravelRoster());
		_townScreen.showTravelDialog();
		this.pushUIMenuStack();
	}

	function onSettlementEntered()
	{
	}

	function getUITravelRoster()
	{
		local data = {
			Title = this.m.Name,
			SubTitle = this.m.Description,
			HeaderImage = null,
			Roster = []
		};
		local settlements = this.World.EntityManager.getSettlements();
		foreach( s in settlements )
		{
			if (s.getID() == this.m.Settlement.getID())
			{
				continue;
			}

			if (!s.isAlliedWithPlayer())
			{
				continue;
			}

			local dest = {
				ID = s.getID(),
				EntryID = data.Roster.len(),
				ListName = "Move to " + s.getName(),
				Name = s.getName(),
				Cost = 0,
				ImagePath = s.getImagePath(),
				ListImagePath = s.getImagePath(),
				FactionImagePath = s.getOwner().getUIBannerSmall(),
				BackgroundText = s.getDescription()
			};
			data.Roster.push(dest);
		}
		settlements = this.World.EntityManager.getLocations();
		foreach( s in settlements )
		{
			if (s.m.Name != "Fantasy Town" || s.m.VisibilityMult != 1.5)
			{
				continue;
			}

			local dest = {
				ID = s.getID(),
				EntryID = data.Roster.len(),
				ListName = "Move to " + s.getName(),
				Name = s.getName(),
				Cost = 0,
				ImagePath = s.getImagePath(),
				ListImagePath = s.getImagePath(),
				FactionImagePath = s.getOwner().getUIBannerSmall(),
				BackgroundText = s.getDescription()
			};
			data.Roster.push(dest);
		}
		return data;
	}

	function onSerialize( _out )
	{
		this.building.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.building.onDeserialize(_in);
	}

});

