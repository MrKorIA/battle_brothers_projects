this.retired_gladiator_tale_event <- this.inherit("scripts/events/event", {
	m = {
		Gladiator = null
	},
	function create()
	{
		this.m.ID = "event.retired_gladiator_tale";
		this.m.Title = "На привале...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]На закате очередного дня ваши мысли устремляются в прошлое. Ещё один день превзойдённых испытаний и поверженных врагов.\n\n%randombro% пристально смотрит на вас, изучая каждый ваш шаг. Поначалу он задаёт вам вопросы, пытаясь перенять ваши знания, начиная от дел в городе и заканчивая разведением коз. Вы рассказываете ему историю, в которой присутствует {коза | копьё | колодец | крепость | арена | маленькая ферма | лесной король | морской монстр | странный предмет | дыра в земле} и как вы {познали смысл жизни | нашли красивую женщину | стали на день пастухом | убили кочевника | убили дворянина | нашли пропавшего раба | убили гигантскую змею | убили охотника | нашли оазис | съели слишком много грибов}, что привело к тому, что вы {получили хорошую плату | были приняты за убийцу | стали гордым владельцем курицы | усыновили кошку | сбежали из города | возглавили стаю диких собак}. Отряд %companyname% сидит у костра, и даже сама тьма подкрадывается поближе, всё больше и больше интересуясь вашим рассказом.\n\nВоодушевленные, ваши ученики готовы снова отправиться в путь, дабы сложить собственные истории.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Убийство людей и зверей - отличная сказка на ночь.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gladiator.getImagePath());
				_event.m.Gladiator.improveMood(0.25, "Рассказал одну из своих историй");

				if (_event.m.Gladiator.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Gladiator.getMoodState()],
						text = _event.m.Gladiator.getName() + this.Const.MoodStateEvent[_event.m.Gladiator.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();
				local xp = this.Math.rand(120, 400)

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Gladiator.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50) //applies to 50% of the party excluding the avatar
					{
						_event.m.bro.addXP(xp);
						_event.m.bro.updateLevel();
						this.List.push({
							id = 16,
							icon = "ui/icons/xp_received.png",
							text = bro.getName() + " получает [color=" + this.Const.UI.Color.PositiveEventValue + "]"+ xp +"[/color] опыта"
						});
					}
				}
			}
		});
	}

	function onUpdateScore()
	{

		if (this.World.getTime().IsDaytime) //if daytime, skip this event
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3) //must have at least 3 brothers
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{						//must be lvl 8 or higher to trigger
			if (bro.getLevel() >= 8 && bro.getBackground().getID() == "background.ret_gladiator")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Gladiator = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"retiredgladiator",
			this.m.Gladiator.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Gladiator = null;
	}

});
