this.cultist_legendary_destroyed_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.cultist_legendary_destroyed";
		this.m.Title = "После битвы...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_119.png[/img]Вам удалось победить верховного жреца и его подданных. Для надежности вы приказываете своим людям уничтожить их реликвии и сжечь всё, что создали их нечестивые руки. Все чувствуют, как гнетущее присутствие уменьшается по мере того, как падает влияние Давкула.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Пора двигаться дальше.",
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
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		return "A"
	}

	function onClear()
	{
	}

});

