this.fantasy_monster_encounter_7b_event <- this.inherit("scripts/events/event", {
	m = {
		SwornBroA = null
	},
	function create()
	{
		this.m.ID = "event.fantasy_monster_encounter_7b_event";
		this.m.Title = "На привале...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img]{%swornbroa% подходит к тебе.%SPEAK_ON% Я устал, босс. Мой брат тоже ушел, а жизнь наемника стала отвратительной. Отныне я ухожу в отставку. Свое снаряжение я оставлю здесь, так что поступай, как хочешь.%SPEECH_OFF%Ты хотел отговорить его, но вместо этого решил уважать его выбор, попросив пожать руку.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Прощай!",
					function getResult( _event )
					{
						_event.m.SwornBroA.getItems().transferToStash(this.World.Assets.getStash());
						_event.m.SwornBroA.getSkills().onDeath(this.Const.FatalityType.None);
						this.World.getPlayerRoster().remove(_event.m.SwornBroA);
						_event.m.SwornBroA = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.SwornBroA.getImagePath());
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.SwornBroA.getName() + " покидает " + this.World.Assets.getName()
				});
			}
		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 100)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local check = 0;
		foreach( bro in brothers )
		{
			if (bro.getFlags().has("SwornBrotherS"))
			{
				check = check + 1;
				this.m.SwornBroA = bro;
			}
		}
		if (check != 1)
		{
			return;
		}
		this.m.Score = 100;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"swornbroa",
			this.m.SwornBroA.getName()
		]);
	}

	function onClear()
	{
		this.m.SwornBroA = null;
	}

});

