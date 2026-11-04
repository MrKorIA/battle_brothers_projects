this.tailor_cures_clumsy_event <- this.inherit("scripts/events/event", {
	m = {
		Tailor = null,
		ClumsyBro = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_tailor_cures_clumsy";
		this.m.Title = "По пути...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_13.png[/img][M] Отряд \'%companyname%\' находится в пути. Для наёмников день выдался на редкость спокойным... пожалуй, даже слишком спокойным. Вскоре вы ловите себя на мысли, что больше не слышите привычного грохота снаряжения. В любое другое время %clumsybro% уже в который раз за день уронил бы своё оружие на дорогу, но сейчас на тракте царит тишина.\n\nКак выяснилось, %tailor% взялся за обучение неуклюжего балбеса и показал ему убийственно простой, но действенный трюк. Портной подсказал отличное решение, и теперь %clumsybro% уверенно держит кусок плотной пурпурной ткани, туго обмотанный вокруг его ладони и рукояти меча. Этой немудрёной уловки оказалось вполне достаточно, чтобы обделённый грацией боец наконец-то начал размахивать клинком не хуже любого другого брата в строю. Косолапить и спотыкаться на ровном месте он, конечно, не перестал, но его взмахи оружием отныне должны стать менее беспорядочными.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Звучит слишком хорошо, чтобы быть правдой.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.ClumsyBro.getImagePath());
				this.Characters.push(_event.m.Tailor.getImagePath());
				_event.m.ClumsyBro.getSkills().removeByID("trait.clumsy");
				this.List = [
					{
						id = 10,
						icon = "ui/traits/trait_icon_36.png",
						text = _event.m.ClumsyBro.getName() + " больше не неуклюжий"
					}
				];
				_event.m.Tailor.improveMood(0.5, "Использовал кусок ткани и хитрый психологический прием, чтобы помочь брату");

				if (_event.m.Tailor.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Tailor.getMoodState()],
						text = _event.m.Tailor.getName() + this.Const.MoodStateEvent[_event.m.Tailor.getMoodState()]
					});
				}

				_event.m.ClumsyBro.improveMood(0.5, "Больше не страдает от неуклюжести в той же степени, что и раньше");

				if (_event.m.ClumsyBro.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.ClumsyBro.getMoodState()],
						text = _event.m.ClumsyBro.getName() + this.Const.MoodStateEvent[_event.m.ClumsyBro.getMoodState()]
					});
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

		local candidates_tailor = [];
		local candidates_clumsybro = [];

		foreach( b in brothers )
		{
			if (b.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (b.getSkills().hasSkill("trait.clumsy"))
			{
				candidates_clumsybro.push(b);
			}
			else if (b.getBackground().getID() == "background.tailor" && b.getLevel() >= 5)
			{
				candidates_tailor.push(b);
			}
		}

		if (candidates_clumsybro.len() == 0 || candidates_tailor.len() == 0)
		{
			return;
		}

		this.m.Tailor = candidates_tailor[this.Math.rand(0, candidates_tailor.len() - 1)];
		this.m.ClumsyBro = candidates_clumsybro[this.Math.rand(0, candidates_clumsybro.len() - 1)];
		this.m.Score = 25 * candidates_tailor.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"tailor",
			this.m.Tailor.getName()
		]);
		_vars.push([
			"clumsybro",
			this.m.ClumsyBro.getName()
		]);
	}

	function onClear()
	{
		this.m.Tailor = null;
		this.m.ClumsyBro = null;
	}

});

