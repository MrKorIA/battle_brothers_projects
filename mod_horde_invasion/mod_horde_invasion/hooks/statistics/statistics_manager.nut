// Перенаправление ванильной новости об уничтоженном городе на ключ кризиса Орды.
// Ванильный destroy_order пушит "crisis_greenskins_town_destroyed" без привязки к фракции —
// в кризис Орды ванильное greenskins_town_destroyed_event срабатывало бы с текстом про
// зеленокожих. Поэтому в Live-фазе Орды пушим ту же новость под своим ключом, её ловит
// scripts/events/events/crisis/horde_town_destroyed_event.nut. В остальных кризисах —
// ванильный ключ проходит как есть.
::HordeInvasion.HooksMod.hook("scripts/statistics/statistics_manager", function(q) {
	q.addNews = @(__original) { function addNews( _type, _news )
	{
		if (_type == "crisis_greenskins_town_destroyed"
			&& this.World.FactionManager.isHordeInvasion())
		{
			_type = "crisis_horde_town_destroyed";
		}

		__original(_type, _news);
	}}.addNews;
});
