::HordeInvasion.HooksMod.hook("scripts/ui/screens/tooltip/tooltip_events", function(q) {
	q.general_queryUIElementTooltipData = @(__original) { function general_queryUIElementTooltipData( _entityId, _elementId, _elementOwner )
	{
		switch (_elementId)
		{
            case "menu-screen.new-campaign.EvilHorde":
                return [
                    {
                        id = 1,
                        type = "title",
                        text = "Нашествие Великой Орды"
                    },
                    {
                        id = 2,
                        type = "description",
                        text = "Первым глобальным кризисом поздней стадии игры станет нашествие Великой Орды — объединённых сил чурчжэней и степняков Мгл, угрожающих смести человеческий мир. Если вы продержитесь достаточно долго, то случайным образом будет выбран следующий кризис."
                    }
                ];
		}

		return __original(_entityId, _elementId, _elementOwner);
	}}.general_queryUIElementTooltipData;
});
