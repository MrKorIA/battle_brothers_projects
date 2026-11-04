this.cook_vs_ratcatcher_event <- this.inherit("scripts/events/event", {
	m = {
		Cook = null,
		Ratcatcher = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_cook_vs_ratcatcher";
		this.m.Title = "По пути...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_52.png[/img][M] Во время короткого привала до вашего слуха доносится яростная брань со стороны обозной повозки. Направившись туда, дабы навести порядок, вы обнаруживаете, что причиной шума стал %ratcatcher%. Крысолов ожесточённо спорит со своим оппонентом, а стоящий напротив %cook% уже буквально багровеет от злости.%SPEECH_ON%Слушай, мой маленький дружок всегда сидит у меня в нагрудном кармане! Я кормлю его объедками из своей же пайки, и он никуда далеко не убегает. Никто из остальных парней не жаловался, с какого перепугу ты-то так взбесился?%SPEECH_OFF%Присмотревшись к нарушителю спокойствия, вы замечаете, что в кармане его поношенной куртки действительно пригрелась ручная крыса - наружу свисает только голый хвост, да сама ткань слегка шевелится. В этот момент %cook% окончательно теряет самообладание от одной лишь мысли о грызуне возле еды.%SPEECH_ON%Держать этих писклявых тварей прямо возле нашей провизии?! Да ты с ума сошёл! Где крысы, там чума и зараза! В прежней жизни мы платили таким заморышам, как ты, чтобы вы истребляли эту гадость, а не дружили с пушистыми разносчиками болезней!%SPEECH_OFF%Оскорблённый %ratcatcher% тоже срывается на крик и хлёстко парирует.%SPEECH_ON%Мой крысёныш чище, чем ты сам, жирный ублюдок! Да даже если бы он и пробрался к мешкам, ущерб от него был бы ничтожным по сравнению с тем, что твои жирные лапы устроили в наших кладовых!%SPEECH_OFF%Вы оглядываетесь по сторонам: остальные наёмники у костра даже ухом не ведут, привыкнув к постоянным кухонным склокам. Рассудив, что на сей раз вмешиваться в эту глупость не стоит, вы молча отходите в сторону ближайших кустов, чтобы без лишних свидетелей справить нужду.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Лучше позволить им разобраться самим.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cook.getImagePath());
				this.Characters.push(_event.m.Ratcatcher.getImagePath());
				_event.m.Cook.worsenMood(1.0, "Вступил в спор по поводу санитарии на кухне");

				if (_event.m.Cook.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Cook.getMoodState()],
						text = _event.m.Cook.getName() + this.Const.MoodStateEvent[_event.m.Cook.getMoodState()]
					});
				}

				_event.m.Ratcatcher.worsenMood(1.0, "Вступил в спор по поводу санитарии на кухне");

				if (_event.m.Ratcatcher.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Ratcatcher.getMoodState()],
						text = _event.m.Ratcatcher.getName() + this.Const.MoodStateEvent[_event.m.Ratcatcher.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_cook = [];
		local candidates_ratcatcher = [];

		foreach( b in brothers )
		{
			if (b.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (b.getBackground().getID() == "background.ratcatcher")
			{
				candidates_ratcatcher.push(b);
			}
			else if (b.getBackground().getID() == "background.hackflows_cook")
			{
				candidates_cook.push(b);
			}
		}

		if (candidates_cook.len() == 0 || candidates_ratcatcher.len() == 0)
		{
			return;
		}

		this.m.Cook = candidates_cook[this.Math.rand(0, candidates_cook.len() - 1)];
		this.m.Ratcatcher = candidates_ratcatcher[this.Math.rand(0, candidates_ratcatcher.len() - 1)];
		this.m.Score = 15 * (candidates_cook.len() + candidates_ratcatcher.len());
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
		_vars.push([
			"ratcatcher",
			this.m.Ratcatcher.getName()
		]);
	}

	function onClear()
	{
		this.m.Cook = null;
		this.m.Ratcatcher = null;
	}

});

