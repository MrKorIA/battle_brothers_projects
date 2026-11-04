this.cobbler_creates_boots_event <- this.inherit("scripts/events/event", {
	m = {
		Cobbler = null,
		OtherBro1 = null,
		OtherBro2 = null,
		OtherBro3 = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_cobbler_creates_boots";
		this.m.Title = "По пути...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_134.png[/img][M] К вам уверенным шагом подходит %cobbler%. Сапожник широко улыбается и без лишних предисловий начинает разговор.%SPEECH_ON%Послушайте, капитан. Я уже порядочно провёл времени в отряде: попривык к схваткам, научился твёрдо держать щит в стене щитов и всё такое. Вот, выкроил пару свободных часов на привалах, чтобы смастерить несколько пар добротных боевых сапог. Кожа отличная, лёгкая, а подошва достаточно прочная, чтобы ноги не мёрзли на марше в холодных землях. В прежней жизни такие стоили больше, чем я зарабатывал за полгода, но благодаря нашему отряду мне удалось выгодно сбыть несколько пар на стороне. Рассудил, что в знак благодарности наши парни заслуживают лучшего снаряжения.%SPEECH_OFF%Мастер почтительно передаёт вам несколько пар обуви удивительного качества, после чего скромно добавляет.%SPEECH_ON%Это всё, сэр.%SPEECH_OFF%Вы лишь изумлённо качаете головой, глядя ему вслед. Неужели выдающиеся таланты этого умельца долгие годы были заживо погребены в беспросветной деревенской нищете?",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Чёрт, а в них удобно.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cobbler.getImagePath());
				_event.m.Cobbler.improveMood(1, "Применил свои навыки сапожника с пользой.");
				_event.m.OtherBro1.getBaseProperties().MeleeDefense += 5;
				_event.m.OtherBro2.getBaseProperties().MeleeDefense += 5;
				_event.m.OtherBro3.getBaseProperties().MeleeDefense += 5;
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_defense.png",
					text = _event.m.OtherBro1.getName() + " получает [color=" + this.Const.UI.Color.PositiveEventValue + "]+5[/color] к защите в ближнем бою"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_defense.png",
					text = _event.m.OtherBro2.getName() + " получает [color=" + this.Const.UI.Color.PositiveEventValue + "]+5[/color] к защите в ближнем бою"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_defense.png",
					text = _event.m.OtherBro3.getName() + " получает [color=" + this.Const.UI.Color.PositiveEventValue + "]+5[/color] к защите в ближнем бою"
				});
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 5)
		{
			return;
		}

		local candidates_cobbler = [];

		foreach( b in brothers )
		{
			if (b.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (b.getBackground().getID() == "background.hackflows_cobbler" && b.getLevel() >= 7)
			{
				candidates_cobbler.push(b);
			}
			else if (this.m.OtherBro1 == null)
			{
				this.m.OtherBro1 = b;
			}
			else if (this.m.OtherBro2 == null)
			{
				this.m.OtherBro2 = b;
			}
			else if (this.m.OtherBro3 == null)
			{
				this.m.OtherBro3 = b;
			}
		}

		if (candidates_cobbler.len() == 0 || this.m.OtherBro1 == null || this.m.OtherBro2 == null || this.m.OtherBro3 == null)
		{
			return;
		}

		this.m.Cobbler = candidates_cobbler[this.Math.rand(0, candidates_cobbler.len() - 1)];
		this.m.Score = candidates_cobbler.len() * 20;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"otherBro1",
			this.m.OtherBro1.getName()
		]);
		_vars.push([
			"otherBro2",
			this.m.OtherBro2.getName()
		]);
		_vars.push([
			"otherBro3",
			this.m.OtherBro3.getName()
		]);
		_vars.push([
			"cobbler",
			this.m.Cobbler.getName()
		]);
	}

	function onClear()
	{
		this.m.Cobbler = null;
		this.m.OtherBro1 = null;
		this.m.OtherBro2 = null;
		this.m.OtherBro3 = null;
	}

});

