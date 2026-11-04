this.bounty_hunter_joins_company_event <- this.inherit("scripts/events/event", {
	m = {
		NewBountyHunter = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_bounty_hunter_joins_company";
		this.m.Title = "По пути...";
		this.m.Cooldown = 75.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_80.png[/img][M] Отряд совершает переход, когда дорогу вам внезапно преграждает суровый, крепко сбитый незнакомец с грозным, видавшим виды оружием в руках. Ваши люди тут же инстинктивно напрягаются, берясь за рукояти мечей, а вы лихорадочно осматриваете окрестности в поисках засады. Однако чужак не выказывает враждебности - он делает шаг вперёд и представляется охотником за головами.\n\nКак выясняется, известность отряда \'%companyname%\' гремит уже настолько громко, что этот мужчина решил лично предложить вам свои услуги. Невиданная щедрость: он готов полностью отказаться от подъёмных за найм, если вы просто дадите ему шанс проявить себя в деле. Взглянув на его изрубленный доспех и хладнокровный взор, вы понимаете - этот охотник за головами определённо знает, как пускать кровь и выживать в бою...",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Добро пожаловать в отряд!",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.NewBountyHunter);
						this.World.getTemporaryRoster().clear();
						_event.m.NewBountyHunter.onHired();
						return 0;
					}

				},
				{
					Text = "Сейчас мы не ищем новых рекрутов.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.NewBountyHunter = roster.create("scripts/entity/tactical/player");
				_event.m.NewBountyHunter.setStartValuesEx([
					"hackflows/bounty_hunter_background"
				]);
				_event.m.NewBountyHunter.getBackground().buildDescription(true);
				this.Characters.push(_event.m.NewBountyHunter.getImagePath());
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

		if (this.World.Assets.getBusinessReputation() < 2250)
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
		this.m.NewBountyHunter = null;
	}

});

