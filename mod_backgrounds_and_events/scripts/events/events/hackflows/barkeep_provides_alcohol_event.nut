this.barkeep_provides_alcohol_event <- this.inherit("scripts/events/event", {
	m = {
		Barkeep = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_barkeep_provides_alcohol";
		this.m.Title = "По пути...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_24.png[/img][M] Останавливаясь с людьми на короткий привал, вы краем глаза замечаете несколько тёмных фигур, крадущихся прямиком к обозу с припасами. Вы кричите, выхватывая меч, и бежите к повозке, как вдруг трактирщик %barkeep% высовывает голову и дружелюбно машет вам. %SPEECH_ON%Что это вы так раскричались, капитан?%SPEECH_OFF%Вы ругаетесь и требуете объяснений, что здесь происходит, но вместо ответа видите нескольких незнакомцев, укладывающих ящики возле вашего лагеря. %barkeep% сияет. %SPEECH_ON%Не волнуйтесь, капитан. Когда мы в прошлый раз возвращались с контракта, я перекинулся парой слов с хозяином здешней таверны. Местные проведали, что наш отряд частенько оставляет у них прорву золота, и рассудили, что это чертовски хорошо для их заведения.%SPEECH_OFF%Он указывает на новые ящики. %SPEECH_ON%Так что следующие несколько кружек за их счёт!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "За это стоит выпить!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Barkeep.getImagePath());
				local beer = this.new("scripts/items/supplies/beer_item");
				this.World.Assets.getStash().add(beer);
				this.List.push({
					id = 10,
					icon = "ui/items/" + beer.getIcon(),
					text = "Вы получаете немного пива."
				});
				local preserved_mead = this.new("scripts/items/supplies/preserved_mead_item");
				this.World.Assets.getStash().add(preserved_mead);
				this.List.push({
					id = 10,
					icon = "ui/items/" + preserved_mead.getIcon(),
					text = "Вы получаете немного медовухи."
				});
				local wine = this.new("scripts/items/supplies/wine_item");
				this.World.Assets.getStash().add(wine);
				this.List.push({
					id = 10,
					icon = "ui/items/" + wine.getIcon(),
					text = "Вы получаете немного вина."
				});
				_event.m.Barkeep.improveMood(0.5, "Раздобыл хорошее пойло.");

				if (_event.m.Barkeep.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Barkeep.getMoodState()],
						text = _event.m.Barkeep.getName() + this.Const.MoodStateEvent[_event.m.Barkeep.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local towns = this.World.EntityManager.getSettlements();
		local playerTile = this.World.State.getPlayer().getTile();
		local nearTown = false;

		if (brothers.len() < 2)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		foreach( t in towns )
		{
			if (t.isMilitary() || t.isSouthern())
			{
				continue;
			}

			if (t.getFactionOfType(this.Const.FactionType.Settlement).getPlayerRelation() >= 70 && t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.hackflows_barkeep")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Barkeep = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"barkeep",
			this.m.Barkeep.getName()
		]);
	}

	function onClear()
	{
		this.m.Barkeep = null;
	}

});

