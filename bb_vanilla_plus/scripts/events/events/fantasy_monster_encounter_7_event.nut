this.fantasy_monster_encounter_7_event <- this.inherit("scripts/events/event", {
	m = {
		SwornBroA = null,
		SwornBroB = null
	},
	function create()
	{
		this.m.ID = "event.fantasy_monster_encounter_7_event";
		this.m.Title = "На привале...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Вы становитесь свидетелем интимного разговора между %swornbroa% и %swornbrob%, которые долгое время были товарищами по оружию. Вопреки своему ветеранскому образу наемника, они обмениваются нежными словами, сопровождаемыми застенчивыми улыбками и неуловимой атмосферой. Любопытство к их тайному разговору охватывает вас, но вы все же размышляете над тем, будет ли правильным вмешательство в их личную жизнь.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Подслушать их разговор.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "С уважением относитесь к их личной жизни.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.SwornBroA.getImagePath());
				this.Characters.push(_event.m.SwornBroB.getImagePath());
			}
		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_172.png[/img]{%SPEECH_ON%Мы сражались бок о бок очень долго, друг. Если бы не ты, я бы сейчас вырывал маргаритки в холодной земле. Ты мне как семья, без сомнения. Когда ты будешь в опасности, я поставлю на карту все, чтобы спасти тебя.%SPEECH_OFF%Двое разделили теплую дружбу и стали побратимами.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Здесь действительно жарко, да??",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.SwornBroA.getImagePath());
				this.Characters.push(_event.m.SwornBroB.getImagePath());
				_event.m.SwornBroA.improveMood(10, "Обрел побратима");
				_event.m.SwornBroB.improveMood(10, "Обрел побратима");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.SwornBroA.getMoodState()],
					text = _event.m.SwornBroA.getName() + " нашел побратима (+5 ко всем статам)"
				});
				this.List.push({
					id = 11,
					icon = this.Const.MoodStateIcon[_event.m.SwornBroB.getMoodState()],
					text = _event.m.SwornBroB.getName() + " нашел побратима (+5 ко всем статам)"
				});
				local r = 5;
				_event.m.SwornBroA.getBaseProperties().MeleeSkill += r;
				_event.m.SwornBroA.getBaseProperties().RangedSkill += r;
				_event.m.SwornBroA.getBaseProperties().MeleeDefense += r;
				_event.m.SwornBroA.getBaseProperties().RangedDefense += r;
				_event.m.SwornBroA.getBaseProperties().Hitpoints += r;
				_event.m.SwornBroA.getBaseProperties().Stamina += r;
				_event.m.SwornBroA.getBaseProperties().Initiative += r;
				_event.m.SwornBroA.getBaseProperties().Bravery += r;
				_event.m.SwornBroA.getSkills().update();
				_event.m.SwornBroB.getBaseProperties().MeleeSkill += r;
				_event.m.SwornBroB.getBaseProperties().RangedSkill += r;
				_event.m.SwornBroB.getBaseProperties().MeleeDefense += r;
				_event.m.SwornBroB.getBaseProperties().RangedDefense += r;
				_event.m.SwornBroB.getBaseProperties().Hitpoints += r;
				_event.m.SwornBroB.getBaseProperties().Stamina += r;
				_event.m.SwornBroB.getBaseProperties().Initiative += r;
				_event.m.SwornBroB.getBaseProperties().Bravery += r;
				_event.m.SwornBroB.getSkills().update();
				_event.m.SwornBroA.getFlags().add("SwornBrotherS");
				_event.m.SwornBroB.getFlags().add("SwornBrotherS");
				_event.m.SwornBroA.setTitle("Побратим");
				_event.m.SwornBroB.setTitle("Побратим");
			}
		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 100)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (!bro.getSkills().hasSkill("trait.player") && !bro.getFlags().has("SwornBrotherS") && bro.getLevel() >= 10)
			{
				candidates.push(bro);
			}
		}
		if (candidates.len() < 2)
		{
			return;
		}

		this.m.SwornBroA = candidates.remove(this.Math.rand(0, candidates.len() - 1));
		this.m.SwornBroB = candidates.remove(this.Math.rand(0, candidates.len() - 1));
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"swornbroa",
			this.m.SwornBroA.getName()
		]);
		_vars.push([
			"swornbrob",
			this.m.SwornBroB.getName()
		]);
	}

	function onClear()
	{
		this.m.SwornBroA = null;
		this.m.SwornBroB = null;
	}

});

