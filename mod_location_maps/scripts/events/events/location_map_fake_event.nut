this.location_map_fake_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location_map_fake";
		this.m.Title = "Старая карта";
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_58.png[/img]Вы разворачиваете карту и внимательно изучаете её. Пометки расплывчаты, названия ничего не говорят, а обозначенный путь обрывается посреди диких земель. Судя по всему, эта карта — подделка, нарисованная неумелой рукой для лёгкого заработка на доверчивых наёмниках. Стоившая немало крон, она теперь не стоит и лоскута, которым и является.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Мошенники! Хотя кто я такой, чтобы судить...",
					function getResult( _event )
					{
						return 0;
					}
				}
			]
		});
	}
});
