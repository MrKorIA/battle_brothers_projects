this.painter_provides_paint_event <- this.inherit("scripts/events/event", {
	m = {
		Painter = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_painter_provides_paint";
		this.m.Title = "По пути...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_128.png[/img][M] Отряд находится в пути, когда %painter% аккуратно касается вашего плеча и просит уделить ему минуту. Художник воодушевлённо делится новостями.%SPEECH_ON%Эй, капитан! Во время прошлой стоянки в поселении мне посчастливилось раздобыть отличные компоненты для смешивания пигментов - понимаете, у меня там ещё остались старые друзья по ремеслу. Может, для кого-то это и мелочь, но мне удалось приготовить несколько наборов красок точь-в-точь таких же оттенков, как наше знамя! Теперь парни смогут обновить свои щиты, украсив их цветами нашего отряда!%SPEECH_OFF%Вы искренне хвалите мастера за проявленную инициативу, и довольный %painter% возвращается в строй. Пускай подобные художества и могут показаться излишним лоском для суровых наёмников, но визуальное единство на поле боя со временем наверняка лишь укрепит узы боевого братства.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Очень ценю.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Painter.getImagePath());

				for( local i = 0; i < 6; i++ )
				{
					local item = this.new("scripts/items/misc/paint_set_item");
					this.World.Assets.getStash().add(item);
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "Вы получаете " + item.getName()
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		if (this.World.Assets.getStash().getNumberOfEmptySlots() < 6)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.hackflows_painter")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Painter = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 10.0 * candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"painter",
			this.m.Painter.getName()
		]);
	}

	function onClear()
	{
		this.m.Painter = null;
	}

});

