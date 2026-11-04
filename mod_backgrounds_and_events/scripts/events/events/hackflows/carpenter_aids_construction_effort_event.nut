this.carpenter_aids_construction_effort_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null,
		Carpenter = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_carpenter_aids_construction_effort";
		this.m.Title = "В городе...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_77.png[/img][M] Неподалеку от поселения %townname% к вашему отряду приближается местный староста в сопровождении нескольких измождённых крестьян. Люди выглядят испуганно и безобидно, поэтому вы ваши люди оставляете оружие в ножнах и соглашаетесь выслушать пришедших. Староста говорит первым.%SPEECH_ON%Доброго дня вам, господа наёмники. Сразу видно, что вы - люди бывалые, крепкие и повидавшие мир.%SPEECH_OFF%Вы сухо говорите мужчине не тратить ваше время и сразу перейти к делу. Староста тяжело вздыхает.%SPEECH_ON%Дело вот в чём, сэр. Сегодня на рассвете у нас подкосились опоры и рухнула крыша главного амбара. У нас нет недостатка в крепких мужчинах или в древесине, но нам не хватает человека, который умеет правильно и ровно распиливать брёвна на доски. Быть может, среди ваших бойцов сыщется умелец..?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "%carpenter%, похоже, ты идеально подходишь для этой работы.",
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
			Text = "[img]gfx/ui/events/event_77.png[/img][M] Вы оборачиваетесь к плотнику и киваете. %carpenter% тут же делает шаг вперёд.%SPEECH_ON%Я готов, капитан. Если отпустите меня на пару часов, я помогу этим бедолагам.%SPEECH_OFF%Крестьяне заметно оживляются и уводят мастера в сторону разрушенного амбара.\n\nСпустя некоторое время %carpenter% возвращается - живой, здоровый и весело подбрасывающий на ладони увесистый мешочек с монетами. Он довольно заявляет.%SPEECH_ON%Здешние пареньки оказались смышлёными и схватывали всё на лету! Мне почти не пришлось напрягаться - только показал им, как правильно держать пилу и пилить бревно. Да и заплатили они на удивление щедро. Сегодня вечером выпивка за мой счёт!%SPEECH_OFF%",
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
				this.Characters.push(_event.m.Carpenter.getImagePath());
				this.World.Assets.addMoney(100);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы получаете [color=" + this.Const.UI.Color.PositiveEventValue + "]100[/color] крон"
				});
				_event.m.Carpenter.improveMood(1.0, "Использовал свой прошлый опыт, чтобы заработать лёгкие кроны");

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

		if (brothers.len() < 3)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isMilitary() || t.isSouthern())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				town = t;
				nearTown = true;
				break;
			}
		}

		if (!nearTown)
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

			if (b.getBackground().getID() == "background.hackflows_carpenter")
			{
				candidates_carpenter.push(b);
			}
		}

		if (candidates_carpenter.len() == 0)
		{
			return;
		}

		this.m.Town = town;
		this.m.Carpenter = candidates_carpenter[this.Math.rand(0, candidates_carpenter.len() - 1)];
		this.m.Score = candidates_carpenter.len() * 35;
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
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
		this.m.Carpenter = null;
	}

});

