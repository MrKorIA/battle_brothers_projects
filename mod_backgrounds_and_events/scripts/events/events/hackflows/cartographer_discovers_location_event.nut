this.cartographer_discovers_location_event <- this.inherit("scripts/events/event", {
	m = {
		Cartographer = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_cartographer_discovers_location";
		this.m.Title = "В лагере...";
		this.m.Cooldown = 5.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_45.png[/img][M] Во время очередного ночного обхода лагеря вы проверяете, как устроились ваши люди. Проходя мимо палатки, где расположился %cartographer%, вы замечаете, что внутри всё ещё теплится свет. Он глубоко задумался: сидит над небольшой скамьёй, сжимая в руке палочку для черчения, а перед ним разложены несколько старых свитков. Заметив вас, картограф поднимает уставший взор и уважительно кивает.%SPEECH_ON%Здравия желаю, капитан. Я тут внимательно изучал карты, которые успел набросать во время наших былых странствий. Да и вдобавок мне посчастливилось раздобыть пару новых чертежей у местных купцов. Знаете, сопоставив все ориентиры, я, кажется, сумел вычислить координаты одного крайне любопытного места...%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "И что же это за место?",
					function getResult( _event )
					{
						local randomNum = this.Math.rand(0, 2);

						if (randomNum == 0)
						{
							return "B";
						}
						else if (randomNum == 1)
						{
							return "C";
						}
						else
						{
							return "D";
						}
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cartographer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_45.png[/img][M] Картограф сосредоточенно хмурит брови, после чего аккуратно постукивает грифелем по нескольким листам пергамента в строго определённых местах.%SPEECH_ON%Если сопоставить карту набегов разбойников и варваров с теми ориентирами, которые описывали немногие выжившие после этих нападений, то вот здесь, судя по всему, и скрывается их главное логово...%SPEECH_OFF%Вы внимательно выслушиваете его доводы и делаете подробные пометки в своём походном журнале, фиксируя координаты обнаруженной стоянки.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Отлично. Теперь мы знаем, где искать их логово",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cartographer.getImagePath());
				local banditSettlements = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getSettlements();
				local barbarianSettlements = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).getSettlements();
				local undiscoveredDestinations = [];

				foreach( settlement in banditSettlements )
				{
					local destination = this.WeakTableRef(settlement);

					if (!destination.isDiscovered())
					{
						undiscoveredDestinations.push(destination);
					}
				}

				foreach( settlement in barbarianSettlements )
				{
					local destination = this.WeakTableRef(settlement);

					if (!destination.isDiscovered())
					{
						undiscoveredDestinations.push(destination);
					}
				}

				local finalDestination = undiscoveredDestinations[this.Math.rand(0, undiscoveredDestinations.len() - 1)];

				if (finalDestination != null)
				{
					finalDestination.setDiscovered(true);
					this.World.uncoverFogOfWar(finalDestination.getTile().Pos, 500.0);
					this.World.getCamera().moveTo(finalDestination.get());
					this.List.push({
						id = 10,
						icon = "ui/icons/special.png",
						text = "Картограф обнаружил местоположение лагеря"
					});
				}
				else
				{
					this.List.push({
						id = 10,
						icon = "ui/icons/special.png",
						text = "Картограф обнаружил лагерь, но вы уже знали о его существовании"
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_45.png[/img][M] Картограф сосредоточенно хмурит брови, после чего аккуратно постукивает грифелем по нескольким листам пергамента в строго определённых местах.%SPEECH_ON%Я сопоставил обрывки местных карт и сравнил расположение крупных ориентиров с той картой мира, которую черчу по ходу нашего похода. Мои расчёты показывают, что вот в этом самом районе должна скрываться древняя гробница или иное крупное захоронение восставших мертвецов...%SPEECH_OFF%.Вы внимательно выслушиваете его доводы и делаете подробные пометки в своём походном журнале, фиксируя координаты обнаруженного склепа.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Хорошо, что мы знаем об источнике нежити.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cartographer.getImagePath());
				local zombieSettlements = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getSettlements();
				local undeadSettlements = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getSettlements();
				local undiscoveredDestinations = [];

				foreach( settlement in zombieSettlements )
				{
					local destination = this.WeakTableRef(settlement);

					if (!destination.isDiscovered())
					{
						undiscoveredDestinations.push(destination);
					}
				}

				foreach( settlement in undeadSettlements )
				{
					local destination = this.WeakTableRef(settlement);

					if (!destination.isDiscovered())
					{
						undiscoveredDestinations.push(destination);
					}
				}

				local finalDestination = undiscoveredDestinations[this.Math.rand(0, undiscoveredDestinations.len() - 1)];

				if (finalDestination != null)
				{
					finalDestination.setDiscovered(true);
					this.World.uncoverFogOfWar(finalDestination.getTile().Pos, 500.0);
					this.World.getCamera().moveTo(finalDestination.get());
					this.List.push({
						id = 10,
						icon = "ui/icons/special.png",
						text = "Картограф обнаружил местоположение лагеря"
					});
				}
				else
				{
					this.List.push({
						id = 10,
						icon = "ui/icons/special.png",
						text = "Картограф обнаружил лагерь, но вы уже знали о его существовании"
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_45.png[/img][M] Картограф сосредоточенно хмурит брови, после чего аккуратно постукивает грифелем по нескольким листам пергамента в строго определённых местах.%SPEECH_ON%Сразу несколько независимых источников сходятся в одном: этот район стал настоящим рассадником активности зеленокожих. Я могу практически со стопроцентной уверенностью утверждать, что где-то здесь скрывается их укреплённый лагерь...%SPEECH_OFF%Вы внимательно выслушиваете его доводы и делаете подробные пометки в своём походном журнале, фиксируя координаты обнаруженной стоянки.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Хорошо знать об угрозе зеленокожих в этом районе.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cartographer.getImagePath());
				local goblinSettlements = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getSettlements();
				local orcSettlements = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getSettlements();
				local undiscoveredDestinations = [];

				foreach( settlement in orcSettlements )
				{
					local destination = this.WeakTableRef(settlement);

					if (!destination.isDiscovered())
					{
						undiscoveredDestinations.push(destination);
					}
				}

				foreach( settlement in goblinSettlements )
				{
					local destination = this.WeakTableRef(settlement);

					if (!destination.isDiscovered())
					{
						undiscoveredDestinations.push(destination);
					}
				}

				local finalDestination = undiscoveredDestinations[this.Math.rand(0, undiscoveredDestinations.len() - 1)];

				if (finalDestination != null)
				{
					finalDestination.setDiscovered(true);
					this.World.uncoverFogOfWar(finalDestination.getTile().Pos, 500.0);
					this.World.getCamera().moveTo(finalDestination.get());
					this.List.push({
						id = 10,
						icon = "ui/icons/special.png",
						text = "Картограф обнаружил местоположение лагеря"
					});
				}
				else
				{
					this.List.push({
						id = 10,
						icon = "ui/icons/special.png",
						text = "Картограф обнаружил лагерь, но вы уже знали о его существовании"
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.hackflows_cartographer")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Cartographer = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 40 * candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cartographer",
			this.m.Cartographer.getName()
		]);
	}

	function onClear()
	{
		this.m.Cartographer = null;
	}

});

