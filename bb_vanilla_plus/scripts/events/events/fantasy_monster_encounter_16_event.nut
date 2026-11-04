this.fantasy_monster_encounter_16_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.fantasy_monster_encounter_16_event";
		this.m.Title = "По пути...";
		this.m.Cooldown = 20.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_158.png[/img]{Вы сталкиваетесь с группой {беженцев | наемников | ополченцев | торговцев | крестьян | солдат | людей}. Обе стороны на мгновение напряглись, но вскоре убедились, что между ними нет вражды.%SPEECH_ON%{Эй, наемники. Как ваши доходы в последнее время? Давайте поделимся немного о своей жизни. | Приветствуем вас. Мы прибыли из {востока | запада | севера | юга}. В последнее время {варвары | орки | гоблины | бандиты} устраивают набеги, и мы бежим от их атак. А как у вас дела? Есть какие-нибудь хорошие новости?}%SPEECH_OFF%Вы поговорили с ними некоторое время, обменявшись информацией. После разговора они сказали, что ваша информация была им полезна, и дали вам немного еды.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Прощайте",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				local food = [
					"scripts/items/supplies/beer_item",
					"scripts/items/supplies/bread_item",
					"scripts/items/supplies/black_marsh_stew_item",
					"scripts/items/supplies/cured_rations_item",
					"scripts/items/supplies/cured_venison_item",
					"scripts/items/supplies/dates_item",
					"scripts/items/supplies/dried_fish_item",
					"scripts/items/supplies/dried_fruits_item",
					"scripts/items/supplies/dried_lamb_item",
					"scripts/items/supplies/fermented_unhold_heart_item",
					"scripts/items/supplies/goat_cheese_item",
					"scripts/items/supplies/ground_grains_item",
					"scripts/items/supplies/mead_item",
					"scripts/items/supplies/pickled_mushrooms_item",
					"scripts/items/supplies/preserved_mead_item",
					"scripts/items/supplies/rice_item",
					"scripts/items/supplies/roots_and_berries_item",
					"scripts/items/supplies/smoked_ham_item",
					"scripts/items/supplies/strange_meat_item",
					"scripts/items/supplies/wine_item",
					"scripts/items/supplies/ground_grains_item",
					"scripts/items/supplies/ground_grains_item",
					"scripts/items/supplies/ground_grains_item",
					"scripts/items/supplies/strange_meat_item",
					"scripts/items/supplies/strange_meat_item"
				];
				food = this.new(food[this.Math.rand(0, food.len() - 1)]);
				this.World.Assets.getStash().add(food);
				this.List.push({
					id = 10,
					icon = "ui/items/" + food.getIcon(),
					text = "Вы получаете " + food.getName()
				});
			}
		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 10)
		{
			return;
		}

		this.m.Score = 3;
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

