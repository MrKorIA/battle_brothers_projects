this.retired_gladiator_paycut_event <- this.inherit("scripts/events/event", {
	m = {
		Gladiator = null
	},
	function create()
	{
		this.m.ID = "event.retired_gladiator_paycut";
		this.m.Title = "На привале...";
		this.m.Cooldown = 35.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_15.png[/img]%gladiator% входит в вашу палатку. Преисполнившись хвастовства и наглости, которыми он обычно славится, гладиатор прерывает ваши дела и усаживается, прежде чем вы успеваете что-либо сказать.%SPEECH_ON%Наставник, я вижу, что ты часами сидишь в этой палатке, покрывая чернилами свои бумаги - вместо того чтобы встать рядом с нами, тренирующимся в свете и тепле, как велит Златоликий...%SPEECH_OFF%Вы понимаете, к чему он ведёт, но позволяете ему договорить.%SPEECH_ON%... твое имя было покрыто славой, но мы не должны оставаться в прошлом вместе с тобой.%SPEECH_OFF%\n\n%gladiator% продолжать говорить, вы не мешаете, и он, конечно же, не останавливается. Вместо этого вы вычитаете часть его жалования в своей бухгалтерской книге - ведь снижение платы куда лучше заставит его понять своё место.\n\nЕсли он способен считать, конечно же...",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Неплохо.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gladiator.getImagePath());
				_event.m.Gladiator.getBaseProperties().DailyWage -= _event.m.Gladiator.getDailyCost() / 2;
				_event.m.Gladiator.getSkills().update();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_daily_money.png",
					text = _event.m.Gladiator.getName() + " теперь получает плату " + _event.m.Gladiator.getDailyCost() + " крон в день"
				});
				_event.m.Gladiator.getFlags().add("gladiator_paycut");
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 6 && bro.getBackground().getID() == "background.gladiator" && !bro.getFlags().has("gladiator_paycut") && !bro.getSkills().hasSkill("trait.old"))
			{
				candidates.push(bro);
			}
		}

		foreach( bro in this.World.getPlayerRoster().getAll() )
		{
			if (!bro.getSkills().hasSkill("perk.retglad_mentor")) // perk check
			{
				continue;
			}
		}

		if (candidates.len() > 0)
		{
			this.m.Gladiator = candidates[this.Math.rand(0, candidates.len() - 1)];
			this.m.Score = this.m.Gladiator.getLevel();
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"gladiator",
			this.m.Gladiator.getName()
		]);
	}

	function onClear()
	{
		this.m.Gladiator = null;
	}

});

