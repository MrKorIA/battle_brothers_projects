this.leper_gets_sick_event <- this.inherit("scripts/events/event", {
	m = {
		Leper = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_leper_gets_sick";
		this.m.Title = "По пути...";
		this.m.Cooldown = 20.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_18.png[/img][M] Прямо во время пути вы замечаете, что от общего строя начинает отставать %leper%. Прокажённый плетётся в самом хвосте колонны: его плечи тяжело опущены, а спину сотрясает крупная дрожь. Похоже, страшный недуг, заживо сжирающий его плоть, также делает несчастного уязвимым для любых повседневных болезней.\n\nВы сочувственно качаете головой, глядя на мучения боевого товарища, но на всякий случай держитесь от него на безопасном расстоянии. Как по команде, уже спустя пару мгновений %leper% судорожно сгибается пополам, и недавно съеденная лагерная похлёбка бурным потоком извергается на обочину тракта. К счастью, грязные брызги безвредно падают на сырую землю. В профессии, которая и без того насквозь пропитана вонью потрохов и нечистот, избавление от очередного источника смрада - это уже подлинное благословение.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Мерзость...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Leper.getImagePath());
				local effect = this.new("scripts/skills/injury/sickness_injury");
				_event.m.Leper.getSkills().add(effect);
				this.List = [
					{
						id = 10,
						icon = effect.getIcon(),
						text = _event.m.Leper.getName() + " заболел"
					}
				];
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.hackflows_leper")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Leper = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 20 * candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"leper",
			this.m.Leper.getName()
		]);
	}

	function onClear()
	{
		this.m.Leper = null;
	}

});

