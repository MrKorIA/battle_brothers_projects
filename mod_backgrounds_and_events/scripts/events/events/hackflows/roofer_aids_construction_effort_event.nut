this.roofer_aids_construction_effort_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null,
		Roofer = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_roofer_aids_construction_effort";
		this.m.Title = "В городе...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_77.png[/img][M] Неподалеку от поселения %townname% к вашему отряду приближается местный староста в сопровождении нескольких крестьян. Люди выглядят испуганно и безобидно, поэтому вы с парнями оставляете оружие в ножнах и соглашаетесь выслушать пришедших. Староста боязливо кланяется и говорит первым.%SPEECH_ON%Доброго дня вам, господа наёмники. Сразу видно, что вы - люди бывалые, крепкие и повидавшие мир.%SPEECH_OFF%Вы сухо просите не тратить ваше время и сразу перейти к делу. Староста тяжело вздыхает.%SPEECH_ON%Дело вот в чём, милсдарь капитан. Сегодня на рассвете у нас подкосились опоры и рухнула крыша главного амбара. В сильных руках да в строевом лесе у нас нужды нет, а вот человека, который умеет правильно и надёжно класть черепицу, во всей деревне не сыскать. Быть может, среди ваших бойцов сыщется такой умелец..?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "%roofer%, похоже, ты идеально подходишь для этой работы.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Это не наша проблема.",
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
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_77.png[/img][M] Вы киваете в сторону кровельщика. %roofer% тут же делает шаг вперёд.%SPEECH_ON%Я готов, капитан. Если отпустите меня на пару часов, я помогу этим бедолагам.%SPEECH_OFF%Крестьяне заметно оживляются и уводят мастера в сторону разрушенного амбара.\n\nСпустя некоторое время %roofer% возвращается в лагерь - живой, здоровый и весело подбрасывающий на ладони увесистый мешочек с монетами.%SPEECH_ON%Здешние пареньки оказались смышлёными и схватывали всё на лету! Мне почти не пришлось напрягаться - только показал им, как правильно укладывать черепицу. Хорошо, что эти шустрики залезли на крышу быстрее меня. Да и заплатили они на удивление щедро. Капитан, парни, сегодня вечером выпивка за мой счёт!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Превосходно!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Roofer.getImagePath());
				this.World.Assets.addMoney(100);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы получаете [color=" + this.Const.UI.Color.PositiveEventValue + "]100[/color] крон"
				});
				_event.m.Roofer.improveMood(1.0, "Использовал свой прошлый опыт, чтобы заработать лёгкие деньги");

				if (_event.m.Roofer.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Roofer.getMoodState()],
						text = _event.m.Roofer.getName() + this.Const.MoodStateEvent[_event.m.Roofer.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 4)
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates_roofer = [];

		foreach( b in brothers )
		{
			if (b.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (b.getBackground().getID() == "background.hackflows_roofer")
			{
				candidates_roofer.push(b);
			}
		}

		if (candidates_roofer.len() == 0)
		{
			return;
		}

		this.m.Town = town;
		this.m.Roofer = candidates_roofer[this.Math.rand(0, candidates_roofer.len() - 1)];
		this.m.Score = candidates_roofer.len() * 50;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"roofer",
			this.m.Roofer.getName()
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
		this.m.Roofer = null;
	}

});

