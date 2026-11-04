this.fantasy_monster_encounter_14_event <- this.inherit("scripts/events/event", {
	m = {
		HedgeKnight1 = null
	},
	function create()
	{
		this.m.ID = "event.fantasy_monster_encounter_14_event";
		this.m.Title = "Неожиданное событие...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_43.png[/img]{Вы слышали слухи о том, что {сельские жители | девочки | женщины | дети} в городе, который вы посещали ранее, были жестоко убиты. Некоторые люди, похоже, считают, что это сделала ваша группа наемников, внешняя сила. Такие недоразумения и плохая репутация являются обычным явлением для групп наемников. Вы вспомнили, что несколько членов группы вели себя подозрительно, но вскоре отбросили эту мысль.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "%hedgeknight1% может иметь к этому какое-то отношение, но это не наше дело.",
					function getResult( _event )
					{
						local r = 2;
						_event.m.HedgeKnight1.getBaseProperties().MeleeSkill += r;
						_event.m.HedgeKnight1.getBaseProperties().RangedSkill += r;
						_event.m.HedgeKnight1.getBaseProperties().Initiative += r;
						_event.m.HedgeKnight1.getBaseProperties().Bravery += r;
						_event.m.HedgeKnight1.improveMood(10, "Чувствует себя лучше");
						_event.m.HedgeKnight1.getSkills().update();
						this.List.push({
							id = 11,
							icon = "ui/icons/plus.png",
							text = _event.m.HedgeKnight1.getName() + "Навыки ближнего боя, навыки дальнего боя, инициатива и храбрость +2."
						});
						return 0;
					}
				},
				{
					Text = "Мы продолжим идти вперед.",
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
		if (this.World.getTime().Days < 10)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		foreach( bro in brothers )
		{
			if (!bro.getSkills().hasSkill("trait.player") && bro.getBackground().getID() == "background.killer_on_the_run")
			{
				candidates.push(bro);
			}
		}
		if (candidates.len() < 1)
		{
			return;
		}
		this.m.HedgeKnight1 = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hedgeknight1",
			this.m.HedgeKnight1.getName()
		]);
	}

	function onClear()
	{
		this.m.HedgeKnight1 = null;
	}

});

