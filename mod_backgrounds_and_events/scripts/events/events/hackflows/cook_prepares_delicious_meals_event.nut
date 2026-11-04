this.cook_prepares_delicious_meals_event <- this.inherit("scripts/events/event", {
	m = {
		Cook = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_cook_prepares_delicious_meals";
		this.m.Title = "По пути...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_61.png[/img][M] За последнее время боевой дух отряда взлетел до небывалых высот. Разумеется, это можно списать на самые разные причины: недавние славные победы, регулярную выплату жалованья или банальную жажду наживы по мере того, как слава отряда гремит всё громче.\n\nОднако вы откровенно солгали бы самому себе, не признай одну простую и очевидную истину: всё дело в жратве.\n\nС тех пор как %cook% пополнил ряды отряда %companyname%, повар с особым рвением применяет секреты своего прежнего ремесла на благо боевых товарищей. Сказать, что этот человек творит чудеса у костра - значит не сказать ничего. Даже в те чёрные дни, когда припасы скудны или откровенно безвкусны, %cook% умудряется превратить пресную похлёбку в кулинарный шедевр. Он ловко использует такие методы и специи, которые абсолютно недоступны пониманию кулинарных простаков.\n\nЕго титанические старания не остались незамеченными: всё чаще %cook% получает заманчивые предложения от других наёмников отстоять за него ночной караул в знак искренней признательности. \n\nВ конце концов, ни одно приличное воинство не способно маршировать на пустой желудок!",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Удивительно, какое влияние может оказать хороший повар на боевой дух.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getSkills().hasSkill("trait.spartan"))
					{
						continue;
					}
					else if (bro.getSkills().hasSkill("trait.gluttonous") || bro.getSkills().hasSkill("trait.fat"))
					{
						bro.improveMood(2.0, "Очень оценил еду, приготовленную поваром");
					}
					else
					{
						bro.improveMood(1.0, "Оценил еду, приготовленную поваром");
					}

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates_cook = [];

		foreach( b in brothers )
		{
			if (b.getBackground().getID() == "background.hackflows_cook" && b.getLevel() >= 4)
			{
				candidates_cook.push(b);
			}
		}

		if (candidates_cook.len() == 0)
		{
			return;
		}

		this.m.Cook = candidates_cook[this.Math.rand(0, candidates_cook.len() - 1)];
		this.m.Score = 15 * candidates_cook.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cook",
			this.m.Cook.getName()
		]);
	}

	function onClear()
	{
		this.m.Cook = null;
	}

});

