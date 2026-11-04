this.xxarena_building <- this.inherit("scripts/entity/world/settlements/buildings/building", {
	m = {	},
	function refreshCooldown()
	{
	}

	function isClosed()
	{
	}

	function create()
	{
		this.building.create();
		this.m.ID = "building.xxarena";
		this.m.Name = "Гильдия авантюристов";
		this.m.Description = "Место, где днем организуют работу для искателей приключений, а ночью предоставляют развлечения.";
		this.m.UIImage = "ui/xbuilding_01";
		this.m.UIImageNight = "ui/xbuilding_01_night";
		this.m.Tooltip = "world-town-screen.main-dialog-module.AdventurersGuild";
		this.m.TooltipIcon = "ui/icons/special.png";
		this.m.IsClosedAtNight = false;
		this.m.Sounds = [
			{
				File = "ambience/buildings/tavern_laugh_00.wav",
				Volume = 0.75,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/tavern_laugh_01.wav",
				Volume = 0.75,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/tavern_laugh_02.wav",
				Volume = 0.75,
				Pitch = 1.0
			},
		{
				File = "ambience/buildings/tavern_laugh_03.wav",
				Volume = 0.75,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/tavern_laugh_04.wav",
				Volume = 0.75,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/tavern_laugh_05.wav",
				Volume = 0.75,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/tavern_laugh_06.wav",
				Volume = 0.75,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/tavern_laugh_08.wav",
				Volume = 0.75,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/tavern_laugh_09.wav",
				Volume = 0.75,
				Pitch = 1.0
			}
		];
		this.m.SoundsAtNight = [
			{
				File = "ambience/buildings/tavern_laugh_00.wav",
				Volume = 0.5,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/tavern_laugh_01.wav",
				Volume = 0.5,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/tavern_laugh_02.wav",
				Volume = 0.5,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/tavern_laugh_03.wav",
				Volume = 0.5,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/tavern_laugh_04.wav",
				Volume = 0.5,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/tavern_laugh_05.wav",
				Volume = 0.5,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/tavern_laugh_06.wav",
				Volume = 0.5,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/tavern_laugh_08.wav",
				Volume = 0.5,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/tavern_laugh_09.wav",
				Volume = 0.5,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/tavern_drunk_00.wav",
				Volume = 0.5,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/tavern_drunk_01.wav",
				Volume = 0.5,
				Pitch = 1.0
			}
		];
	}

	function onClicked( _townScreen )
	{
	        ::World.State.getMenuStack().popAll(true);
		::World.Events.fire("event.xxzzarena_event");
	}

	function onSettlementEntered()
	{
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

