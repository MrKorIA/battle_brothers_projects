this.random_four_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.hackflows_random_four_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_134.png[/img][M] Вы понятия не имеете, какая чертовщина свела вас пятерых вместе, и уж тем более не понимаете, с какого перепугу именно вам поручили вести этот сброд за собой. Из вашей памяти стёрто почти всё - прошлое скрыто густым, непроницаемым туманом.\n\nВ голове настойчиво бьётся лишь одна смутная мысль: у этого отряда есть некое великое предназначение. Пока к вам не вернутся воспоминания, нет причин глушить это внутреннее чутьё - на войне инстинкты редко обманывают.",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Интересно, какое будущее нас ждёт.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
				local brothers = this.World.getPlayerRoster().getAll();
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "Новое начало";
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local settlements = this.World.EntityManager.getSettlements();
		local closest;
		local distance = 9999;

		foreach( s in settlements )
		{
			local d = s.getTile().getDistanceTo(this.World.State.getPlayer().getTile());

			if (d < distance)
			{
				closest = s;
				distance = d;
			}
		}
	}

	function onClear()
	{
	}

});

