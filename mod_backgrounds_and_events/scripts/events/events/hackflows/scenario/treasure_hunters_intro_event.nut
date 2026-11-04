this.treasure_hunters_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.hackflows_treasure_hunters_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_04.png[/img][M] Последние несколько лет вы со своими спутниками промышляли охотой за древними сокровищами. За это время через ваше братство прошло немало отчаянных, искавших наживы голов: одни мирно уходили на покой, скопив безбедное состояние, другие - находили бесславный конец во время очередных приключений вашей команды.\n\nПосле последней, невероятно рискованной и прибыльной затеи большая часть отряда погибла или ушла с добычей, которой хватило бы на всю оставшеюся жизнь. Когда они разошлись в разные стороны, дух приключений остался в вас четверых: историке, картографе, сокольничем и, конечно же, в вас самих. Вы решаете продолжить поиски реликвий, полагаясь на свою проверенную хватку, но теперь планируете заявить о себе и как о полноценном наёмном отряде. В конце концов, какой смысл в золоте и подвигах, если в тавернах о них никто не споёт?",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "За сокровища и славу!",
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
		this.m.Title = "Конец и начало";
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

