this.vampire_joins_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null,
	},
	function create()
	{
		this.m.ID = "event.vampire_joins";
		this.m.Title = "Слухи расходятся...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay; 
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_76.png[/img]Краем глаза вы замечаете фигуру - её плоть бледна и костлява, как и ваша собственная. По правде говоря, вы не знаете, как долго она за вами наблюдает. По вашей команде отряд останавливается и рассматривает существо на горизонте, которое движется к вам с уверенной скоростью.\n\n Это действительно один из ваших, возможно ещё один, кто устал от совета и от их бесконечных оправданий.\n Ещё один из вашего рода, который увеличит количество рук и облегчит выполнение будущих задач...",
			Image = "", 
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Нам всегда нужны такие, как мы.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
				        ::TheRedCourt.AddRedCourtTalents(_event.m.Dude);
						_event.m.Dude.onHired();
						return 0;
					}

				},
				{
					Text = "Мы тебя не возьмём.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],

			function start( _event ) //1 = least likely to generate.
			{
				local backgrounds = [
					[1,	"hemovore_HIGH_background"],
					[2, "hemovore_MED_background"],
					[3, "hemovore_LOW_background"]
				];
				local totalWeight = 0;
				local result = []
				foreach (background in backgrounds)
				{
				    totalWeight += background[0];
				}
				local r = this.Math.rand(0, totalWeight);
				foreach (background in backgrounds)
				{
				    r = r - background[0];
				    if (r <= 0)
				    {
				       result.push(background[1])
				      break;
				    }
				}
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx(result);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.hemovores" && this.World.Assets.getOrigin().getID() != "scenario.hemovores_avatar") //THIS WORKS
		{
			return;
		}

		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

