this.carpenter_lumberjack_quality_wood_event <- this.inherit("scripts/events/event", {
	m = {
		Carpenter = null,
		Lumberjack = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_carpenter_lumberjack_quality_wood";
		this.m.Title = "У леса...";
		this.m.Cooldown = 15.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_25.png[/img][M] Пока отряд отдыхает у опушки леса, %lumberjack% лениво потягивается и непринуждённо уходит в чащу. Прежде чем вы успеваете окликнуть его, из-за деревьев доносятся весёлое насвистывание и ритмичные удары топора. Спустя некоторое время на поляне снова появляется %lumberjack% - он тяжело дышит, но уверенно тащит на плечах охапку свежесрубленной древесины.\n\nЗавидев добычу, плотник %carpenter% заметно оживляется и тут же предлагает дело.%SPEECH_ON%Отличный строевой лес, из такого выходят превосходные луки! Я знаю, что нам нужны обычные дрова для костра, но что, если я пущу эти стволы на качественные заготовки, а в следующем городе мы загоним их местным купцам по хорошей цене?%SPEECH_OFF%Услышав это, %lumberjack% с глухим стуком сбрасывает ношу на землю и небрежно закидывает топор на плечо.%SPEECH_ON%Да я только за, могу и ещё раз сходить. Эта ходка меня даже толком не разогрела!%SPEECH_OFF%Здоровяк неторопливо возвращается под кроны деревьев, а плотник без лишних слов засучивает рукава и принимается за работу. Вскоре ваш инвентарь пополняется несколькими вязанками первоклассной древесины.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Превосходно!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Lumberjack.getImagePath());
				this.Characters.push(_event.m.Carpenter.getImagePath());
				local item = this.new("scripts/items/trade/quality_wood_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Вы получаете " + item.getName()
				});
				item = this.new("scripts/items/trade/quality_wood_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Вы получаете " + item.getName()
				});
				item = this.new("scripts/items/trade/quality_wood_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Вы получаете " + item.getName()
				});
				item = this.new("scripts/items/trade/quality_wood_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Вы получаете " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		if (this.World.Assets.getStash().getNumberOfEmptySlots() < 4)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates_carpenter = [];
		local candidates_lumberjack = [];

		foreach( b in brothers )
		{
			if (b.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (b.getBackground().getID() == "background.hackflows_carpenter")
			{
				candidates_carpenter.push(b);
			}

			if (b.getBackground().getID() == "background.lumberjack")
			{
				candidates_lumberjack.push(b);
			}
		}

		if (candidates_carpenter.len() == 0 || candidates_lumberjack.len() == 0)
		{
			return;
		}

		this.m.Carpenter = candidates_carpenter[this.Math.rand(0, candidates_carpenter.len() - 1)];
		this.m.Lumberjack = candidates_lumberjack[this.Math.rand(0, candidates_lumberjack.len() - 1)];
		this.m.Score = candidates_carpenter.len() * 20 + candidates_lumberjack.len() * 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"lumberjack",
			this.m.Lumberjack.getName()
		]);
		_vars.push([
			"carpenter",
			this.m.Carpenter.getName()
		]);
	}

	function onClear()
	{
		this.m.Lumberjack = null;
		this.m.Carpenter = null;
	}

});

