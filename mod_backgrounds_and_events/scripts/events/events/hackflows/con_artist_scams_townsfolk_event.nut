this.con_artist_scams_townsfolk_event <- this.inherit("scripts/events/event", {
	m = {
		ConArtist = null
	},
	function create()
	{
		this.m.ID = "event.";
		this.m.Title = "...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_128.png[/img][M]",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function onUpdateScore()
	{
		return // Broken
		local brothers = this.World.getPlayerRoster().getAll();
		this.m.Score = 1;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"conartist",
			this.m.ConArtist.getName()
		]);
	}

	function onClear()
	{
		this.m.ConArtist = null;
	}

});

