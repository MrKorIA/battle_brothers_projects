this.aging_master_archer_preview_event <- this.inherit("scripts/events/event", {
	m = {
		Master_Archer = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_aging_master_archer_preview";
		this.m.Title = "По пути...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_128.png[/img][M] У кромки лагеря %master_archer% одиноко стоит и всматривается в серую даль. Заметив вас, он негромко произносит. %SPEECH_ON%Много воды утекло с тех пор, как я в последний раз выигрывал турнир стрелков. Стрельба по мишеням на потеху толпе давно потеряла для меня всякий шарм. Я уже и сам не заметил, как променял яблочко мишени на чужие головы, а старость тем временем подкралась незаметно. Я просто состарился, капитан. Наверное, за свою жизнь я пустил в расход куда больше людей, чем поразил учебных целей... и всех их, ну, или почти всех, я настиг с безопасного расстояния.%SPEECH_OFF% Вы подходите ближе и закладываете руки за спину. Он продолжает. %SPEECH_ON%Я обокрал этих людей, капитан. Обокрал не только на остаток их жизни, но и на достойную смерть. Я редко вижу их лица, когда они падают, молча, позади своих товарищей, их последние слова остаются неуслышанными, когда они падают лицом вниз, в грязь и землю. Когда-нибудь и меня настигнет шальной снаряд, или что ещё хуже, какой-нибудь шустрый ублюдок доберется до меня и вспорет мне брюхо. Как бы я ни подох, это будет ничем не лучше той участи, на которую я обрёк сотни других...%SPEECH_OFF% Его последние слова затихают в тревожном молчании, и вы оба молча возвращаетесь в строй.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Надеюсь, он воспрянет духом.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Master_Archer.getImagePath());
				_event.m.Master_Archer.worsenMood(1.0, "Осознал, что стареет");

				if (_event.m.Master_Archer.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Master_Archer.getMoodState()],
						text = _event.m.Master_Archer.getName() + this.Const.MoodStateEvent[_event.m.Master_Archer.getMoodState()]
					});
				}

				_event.m.Master_Archer.getFlags().add("aging_preview");
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 6
				&& bro.getBackground().getID() == "background.hackflows_master_archer"
				&& !bro.getFlags().has("aging_preview")
				&& !bro.getSkills().hasSkill("trait.old")
				&& !bro.getFlags().has("IsRejuvinated"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() > 0)
		{
			this.m.Master_Archer = candidates[this.Math.rand(0, candidates.len() - 1)];
			this.m.Score = this.m.Master_Archer.getLevel();
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"master_archer",
			this.m.Master_Archer.getName()
		]);
	}

	function onClear()
	{
		this.m.Master_Archer = null;
	}

});

