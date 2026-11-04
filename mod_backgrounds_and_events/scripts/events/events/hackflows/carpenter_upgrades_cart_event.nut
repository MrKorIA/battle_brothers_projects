this.carpenter_upgrades_cart_event <- this.inherit("scripts/events/event", {
	m = {
		Carpenter = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_carpenter_upgrades_cart";
		this.m.Title = "В пути...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_128.png[/img][M] Во время перехода вы замечаете, что %carpenter% внезапно ныряет за обозную повозку. Когда спустя несколько минут он так и не возвращается в строй, вы решаете лично проверить, чем обусловлена такая задержка.\n\nЗа повозкой вы обнаруживаете мастера в самом разгаре работы: он искусно вставляет хорошо обтёсанные доски в пазы и намертво прибивает их к каркасу. И хотя телега казалась уже забитой под завязку, после того как %carpenter% завершает свои манипуляции, внутри каким-то чудом освобождается порядочно свободного места. Вы искренне благодарите умельца за хорошо сделанную работу.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Всегда хорошо иметь под рукой мастера на все руки.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Carpenter.getImagePath());
				this.World.Assets.getStash().resize(this.World.Assets.getStash().getCapacity() + 18);
				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = "Вы получаете место в инвентаре"
				});
				_event.m.Carpenter.improveMood(1.0, "Улучшил обозную повозку");

				if (_event.m.Carpenter.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Carpenter.getMoodState()],
						text = _event.m.Carpenter.getName() + this.Const.MoodStateEvent[_event.m.Carpenter.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (!this.World.Ambitions.getAmbition("ambition.cart").isDone())
		{
			return;
		}

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates_carpenter = [];

		foreach( b in brothers )
		{
			if (b.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (b.getBackground().getID() == "background.hackflows_carpenter" && b.getLevel() >= 6)
			{
				candidates_carpenter.push(b);
			}
		}

		if (candidates_carpenter.len() == 0)
		{
			return;
		}

		this.m.Carpenter = candidates_carpenter[this.Math.rand(0, candidates_carpenter.len() - 1)];
		this.m.Score = candidates_carpenter.len() * 20;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"carpenter",
			this.m.Carpenter.getName()
		]);
	}

	function onClear()
	{
		this.m.Carpenter = null;
	}

});

