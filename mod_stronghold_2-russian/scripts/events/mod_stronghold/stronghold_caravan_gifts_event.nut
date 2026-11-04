this.stronghold_caravan_gifts_event <- this.inherit("scripts/events/event", {
	//calls success when caravan arrives at destination, works as an event
	m = {
		News = null
	},
	function create()
	{
		this.m.ID = "event.caravan_gifts";
		this.m.Title = "Тем временем...";
		this.m.IsSpecial = true;
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_45.png[/img]Ваш караван прибыл в пункт назначения. Подарки были хорошо приняты, и ваша репутация с %destinationFaction% увеличилась на %reputation%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Превосходно.",
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
	
	function onPrepare()
	{
		this.m.News = this.World.Statistics.popNews("gifts_arrived_at_town");
	}
	function onUpdateScore()
	{
		if (this.World.Statistics.hasNews("gifts_arrived_at_town"))
		{
			this.m.Score = 2000;
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"destination",
			this.m.News.get("Destination")
		]);
		
		_vars.push([
			"reputation",
			this.m.News.get("Reputation")
		]);
		
		_vars.push([
			"destinationFaction",
			this.m.News.get("DestinationFaction")
		]);
	}

	function onClear()
	{
		this.m.News = null
	}

});

