this.cobbler_cures_clubfooted_event <- this.inherit("scripts/events/event", {
	m = {
		Cobbler = null,
		ClubfootedBro = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_cobbler_cures_clubfooted";
		this.m.Title = "В пути...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_61.png[/img][M] Во время очередного перехода отряд снова замедляет ход: %clubfootedBro% предсказуемо отстаёт из-за своих извечно ноющих, деформированных ног. Ваши люди привыкли грубо высмеивать и подкалывать друг друга по любому поводу, поэтому вы невольно задаётесь вопросом, почему к этому бедолаге все относятся с молчаливым пониманием.\n\nОднако один взгляд на соратника расставляет всё по местам. Лицо, которое имеет %clubfootedBro%, сейчас сводит мрачная, стоическая гримаса боли: он мужественно превозмогает каждый шаг, изо всех сил стараясь не задерживать товарищей. Остальные бойцы выжидательно поглядывают на вас. Вы уже собираетесь скомандовать привал, как вдруг %cobbler% решительно выходит из общего строя, подходит к отстающему и протягивает ему пару с виду ничем не примечательных сапог.%SPEECH_ON%Я сшил их специально для тебя, брат. Мой старик научил меня этому особому ремеслу давным-давно. Эта обувь выровняет твою походку и навсегда избавит от изнуряющей боли.%SPEECH_OFF%Суровый взгляд, который демонстрировал %clubfootedBro%, мгновенно теплеет, когда он принимает и натягивает обнову. Его лицо расплывается в широкой, искренней улыбке, стоит ему сделать первые несколько шагов без прежней хромоты. Ошеломлённый ветеран запинается.%SPEECH_ON%%cobbler%, я... я даже не знаю, какими словами благодарить тебя, я...%SPEECH_OFF%Сапожник %cobbler% со смехом перебивает товарища.%SPEECH_ON%Да просто шагай быстрее, и будем считать, что мы квиты. Уверен, на поле боя ты ещё не раз прикроешь мою шкуру.%SPEECH_OFF%Отряд возобновляет путь - теперь наёмники движутся куда стремительнее и сплочённее, чем прежде.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Нам повезло, что с нами сапожник.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cobbler.getImagePath());
				this.Characters.push(_event.m.ClubfootedBro.getImagePath());
				_event.m.ClubfootedBro.getSkills().removeByID("trait.clubfooted");
				this.List = [
					{
						id = 10,
						icon = "ui/traits/trait_icon_23.png",
						text = _event.m.ClubfootedBro.getName() + " больше не косолапый"
					}
				];
				_event.m.Cobbler.improveMood(0.5, "Смастерил сапоги, которые помогли брату.");

				if (_event.m.Cobbler.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Cobbler.getMoodState()],
						text = _event.m.Cobbler.getName() + this.Const.MoodStateEvent[_event.m.Cobbler.getMoodState()]
					});
				}

				_event.m.ClubfootedBro.improveMood(1.5, "Получил особую обувь, которая помогает ему ходить.");

				if (_event.m.ClubfootedBro.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.ClubfootedBro.getMoodState()],
						text = _event.m.ClubfootedBro.getName() + this.Const.MoodStateEvent[_event.m.ClubfootedBro.getMoodState()]
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

		local candidates_cobbler = [];
		local candidates_clubfootedBro = [];

		foreach( b in brothers )
		{
			if (b.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (b.getSkills().hasSkill("trait.clubfooted"))
			{
				candidates_clubfootedBro.push(b);
			}
			else if (b.getBackground().getID() == "background.hackflows_cobbler" && b.getLevel() >= 2)
			{
				candidates_cobbler.push(b);
			}
		}

		if (candidates_clubfootedBro.len() == 0 || candidates_cobbler.len() == 0)
		{
			return;
		}

		this.m.Cobbler = candidates_cobbler[this.Math.rand(0, candidates_cobbler.len() - 1)];
		this.m.ClubfootedBro = candidates_clubfootedBro[this.Math.rand(0, candidates_clubfootedBro.len() - 1)];
		this.m.Score = 15 * candidates_cobbler.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cobbler",
			this.m.Cobbler.getName()
		]);
		_vars.push([
			"clubfootedBro",
			this.m.ClubfootedBro.getName()
		]);
	}

	function onClear()
	{
		this.m.Cobbler = null;
		this.m.ClubfootedBro = null;
	}

});

