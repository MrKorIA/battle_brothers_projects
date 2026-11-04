this.drifter_joins_company_event <- this.inherit("scripts/events/event", {
	m = {
		Drifter = null,
		NewDrifter = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_drifter_joins_company";
		this.m.Title = "По пути...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_80.png[/img][M] Хотя бродяги по самой своей природе рассеяны по всем уголкам этого сурового мира, какая-то невидимая нить всегда тянет их друг к другу. Яркий пример тому - %drifter%. Кочевой брат по оружию явно чувствует себя на тракте как дома.\n\nКак выясняется, прямо во время перехода он умудрился заприметить на обочине и разговорить другого бездомного скитальца. Теперь этот чужак просится под ваше знамя. Похоже, ни один из них не станет лить слёзы в случае отказа, да и лишний клинок в строю никогда не помешает. С другой стороны, не стоит брать в свои ряды любого встречного...",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Добро пожаловать в отряд!",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.NewDrifter);
						this.World.getTemporaryRoster().clear();
						_event.m.NewDrifter.onHired();
						return 0;
					}

				},
				{
					Text = "Проходи мимо, странник.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.NewDrifter = roster.create("scripts/entity/tactical/player");
				_event.m.NewDrifter.setStartValuesEx([
					"hackflows/drifter_background"
				]);
				_event.m.NewDrifter.getBackground().buildDescription(true);

				if (_event.m.NewDrifter.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					_event.m.NewDrifter.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (_event.m.NewDrifter.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					_event.m.NewDrifter.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				if (_event.m.NewDrifter.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					_event.m.NewDrifter.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
				}

				this.Characters.push(_event.m.NewDrifter.getImagePath());
				this.Characters.push(_event.m.Drifter.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.hackflows_drifter")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Drifter = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 10 * candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"drifter",
			this.m.Drifter.getName()
		]);
	}

	function onClear()
	{
		this.m.Drifter = null;
		this.m.NewDrifter = null;
	}

});

