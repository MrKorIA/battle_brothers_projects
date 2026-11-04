this._add_item3_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.hackflows__add_item3";
		this.m.Title = "...";
		this.m.Cooldown = 10.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_128.png[/img][M] Тестовое событие для добавления новых предметов в ваш инвентарь",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Отлично.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/weapons/legendary/gae_dearg");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Вы получаете " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		return;

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		this.m.Score = 5000;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

