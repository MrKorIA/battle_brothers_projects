this.player_is_sent_for_cultist_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null
	},
	function create()
	{
		this.m.ID = "event.player_is_sent_for_cultist";
		this.m.Title = "По дороге...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_92.png[/img]{Ваш отряд, похоже, привлёк внимание посыльного.%SPEECH_ON%{Наёмники, %settlement%, что к %direction% отсюда, остро нуждается в вашей пом....}%SPEECH_OFF%Курьер внезапно прерывается, его глаза широко раскрываются, а из неподвижных губ вырывается голос, пустой и безжизненный.%SPEECH_ON%{Только сильнейшие достойны служить Давкулу, а потому я жду тебя, наёмник, чтобы своим собственным ножом отправить тебя с позором во тьму. Приходи ко мне и встреть свою судьбу, иначе я найду тебя и тогда тоже убью, но уже не буду столь милосерден.}%SPEECH_OFF%Посыльный возвращается к реальности так же внезапно, как и расстался с ней. Что-то устало бормоча, он тронулся дальше, держась за голову и постоянно спотыкаясь.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Похоже, у нас есть соперник в погоне за благосклонностью Давкула.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getOrigin().getID() != "scenario.cultists")
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.World.Contracts.getActiveContract() != null)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearestTown;
		local nearestDist = 9000;

		foreach( t in towns )
		{
			if (t.isSouthern())
			{
				continue;
			}
			if (!t.hasSituation("situation.cultist_incursion")) continue
			local d = t.getTile().getDistanceTo(currentTile) + this.Math.rand(0, 10);

			if (d < nearestDist && t.isAlliedWithPlayer() && this.World.FactionManager.getFaction(t.getFaction()).getContracts().len() != 0)
			{
				nearestTown = t;
				nearestDist = d;
			}
		}

		if (nearestTown == null)
		{
			return;
		}

		this.m.Town = nearestTown;
		this.m.Score = 5
		
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"settlement",
			this.m.Town.getName()
		]);
		_vars.push([
			"direction",
			this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Town.getTile())]
		]);
	}

	function onClear()
	{
		this.m.Town = null;
	}

});

