this.leper_becomes_famous_event <- this.inherit("scripts/events/event", {
	m = {
		Leper = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_leper_becomes_famous";
		this.m.Title = "В городе...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			// BROKEN vars ???
			Text = "[img]gfx/ui/events/event_92.png[/img][M] Известность отряда %companyname% неуклонно растёт, а вести о подвигах ваших людей разносятся далеко и широко. Проходя через очередной город, вы замечаете, что горожане показывают пальцами в сторону прокажённого. %leper% привлёк к себе всеобщее внимание, и толпа вокруг начинает возбуждённо перешёптываться. Вдруг вперед выходит молодой человек и с благоговением приближается к ветерану.%SPEECH_ON%Неужели это правда? Это тот самый монстр, который в одиночку противостоял вождю орков и обратил всю их орду в бегство? Тот самый человек, который получил топор прямо в плечо, зарубил того, кто его туда воткнул, и закончил битву, так и не вытащив лезвия?! Тот, кто потерял абсолютно всё из-за страшной болезни, прежде чем возродиться, как феникс, в отряде %companyname%?%SPEECH_OFF%Обычно хмурое и подавленное лицо %leper% в этот момент кривится в довольной ухмылке.%SPEECH_ON%В нашем отряде точно нет никого уродливее меня, парень. Ты прав, это был я. Но насчёт топора ты ошибаешься - то был тяжёлый тесак.%SPEECH_OFF%Глаза юноши округляются от священного трепета, а остальные горожане приходят в неописуемый восторг.\n\nВы и ваши люди продолжаете заниматься своими делами, но ловите момент, чтобы украдкой покоситься на калеку. Когда он только вступил в отряд %companyname%, то являл собой поистине жалкое зрелище: проклинал судьбу и злобно скалился на каждого прохожего, кто посмел случайно на него взглянуть. Теперь же он уверенно стоит среди ваших братьев, полностью преображённый. Его тело всё ещё изуродовано болезнью, но дух обрёл абсолютную стойкость. %leper% выглядит несокрушимым стоиком. Время, проведённое под вашим началом, пошло ему на пользу, и теперь он сам продолжает поднимать славу отряда на новые высоты.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Да здравствует %leper% и %companyname%!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Leper.getImagePath());
				_event.m.Leper.improveMood(1.5, "Осознал, что стал знаменит по всей земле");
				this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
				_event.m.Leper.getBaseProperties().Bravery += 20;
				_event.m.Leper.getBaseProperties().Hitpoints += 10;
				_event.m.Leper.getBaseProperties().Stamina += 4;
				_event.m.Leper.getBaseProperties().MeleeDefense += 4;
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Leper.getName() + " получает [color=" + this.Const.UI.Color.PositiveEventValue + "]+20[/color] к решимости"
				});
				this.List.push({
					id = 17,
					icon = "ui/icons/health.png",
					text = _event.m.Leper.getName() + " получает [color=" + this.Const.UI.Color.PositiveEventValue + "]+10[/color] к ОЗ"
				});
				this.List.push({
					id = 17,
					icon = "ui/icons/fatigue.png",
					text = _event.m.Leper.getName() + " получает [color=" + this.Const.UI.Color.PositiveEventValue + "]+4[/color] к выносливости"
				});
				this.List.push({
					id = 17,
					icon = "ui/icons/melee_defense.png",
					text = _event.m.Leper.getName() + " получает [color=" + this.Const.UI.Color.PositiveEventValue + "]+4[/color] к защите в ближнем бою"
				});
				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = "Отряд получил известность"
				});

				if (_event.m.Leper.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Leper.getMoodState()],
						text = _event.m.Leper.getName() + this.Const.MoodStateEvent[_event.m.Leper.getMoodState()]
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

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getSize() <= 1 || t.isMilitary() || t.isSouthern())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 4 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 11 && bro.getBackground().getID() == "background.hackflows_leper")
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

