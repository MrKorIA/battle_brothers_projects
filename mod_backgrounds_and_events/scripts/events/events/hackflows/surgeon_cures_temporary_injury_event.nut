this.surgeon_cures_temporary_injury_event <- this.inherit("scripts/events/event", {
	m = {
		Surgeon = null,
		InjuredBro = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_surgeon_cures_temporary_injury";
		this.m.Title = "По пути...";
		this.m.Cooldown = 15.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_34.png[/img][M] Зная, что %injuredbro% недавно получил тяжёлую травму в бою, вы выкраиваете свободную минуту, чтобы лично проведать раненого. В конце концов, простое понимание того, что капитан помнит о своих людях, изрядно поднимает боевой дух отряда. Однако на месте вы застаёте удивительную картину: наш боец весело хохочет, дружески приобняв за плечи лекаря, и выглядит при этом совершенно здоровым. Завидев вас, %injuredbro% радостно восклицает.%SPEECH_ON%Сэр, тот день, когда вы наняли этого человека, стал днём, когда сами боги улыбнулись отряду \'%companyname%\'! То, что он сотворил с моими ранами - чистое волшебство. Я и сам толком не понял, как всё произошло!%SPEECH_OFF%Он свободной рукой указывает на хирурга, а %surgeon% лишь скромно улыбается в ответ.%SPEECH_ON%Люди в здешних краях выкованы из весьма прочного материала, капитан. Могу заверить, что %injuredbro% в любом случае поправился бы со временем... Я просто самую малость ускорил этот естественный процесс.%SPEECH_OFF%Вы с облегчением возвращаетесь к своим обязанностям, мысленно отмечая неоценимое влияние нашего хирурга на здоровье и боеспособность всего отряда.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Нам повезло, что с нами хирург.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.InjuredBro.getImagePath());
				this.Characters.push(_event.m.Surgeon.getImagePath());
				local injuries = _event.m.InjuredBro.getSkills().query(this.Const.SkillType.TemporaryInjury);
				local injury = injuries[this.Math.rand(0, injuries.len() - 1)];
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.InjuredBro.getName() + " больше не страдает от " + injury.getNameOnly()
					}
				];
				injury.removeSelf();
				_event.m.InjuredBro.updateInjuryVisuals();
				_event.m.InjuredBro.getSkills().update();
				_event.m.Surgeon.improveMood(1.0, "Помог вылечить рану, используя свой хирургический опыт");

				if (_event.m.Surgeon.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Surgeon.getMoodState()],
						text = _event.m.Surgeon.getName() + this.Const.MoodStateEvent[_event.m.Surgeon.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_injured = [];
		local candidates_surgeon = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() != "background.slave" && bro.getBackground().getID() != "background.hackflows_surgeon" && bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidates_injured.push(bro);
			}
			else if (bro.getBackground().getID() == "background.hackflows_surgeon")
			{
				candidates_surgeon.push(bro);
			}
		}

		if (candidates_injured.len() == 0 || candidates_surgeon.len() == 0)
		{
			return;
		}

		this.m.Surgeon = candidates_surgeon[this.Math.rand(0.0, candidates_surgeon.len() - 1)];
		this.m.InjuredBro = candidates_injured[this.Math.rand(0, candidates_injured.len() - 1)];
		this.m.Score = candidates_injured.len() * 10 + candidates_surgeon.len() * 20;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"surgeon",
			this.m.Surgeon.getName()
		]);
		_vars.push([
			"injuredbro",
			this.m.InjuredBro.getName()
		]);
	}

	function onClear()
	{
		this.m.Surgeon = null;
		this.m.InjuredBro = null;
	}

});

