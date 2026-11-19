this.nggh_mod_found_spider_eggs_event <- ::inherit("scripts/events/event", {
	m = {
		Egg = null,
		Spider = null,
		SpiderRecruit = null,
		JustRecruit = 0,
		Count = 0,
	},
	function create()
	{
		this.m.ID = "event.found_spider_eggs";
		this.m.Title = "Глубоко в лесу...";
		this.m.Cooldown = 45.0 * ::World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_110.png[/img]%guide%, похоже, знает этот лес, без слов предлагая вам следовать за ним. Он останавливается в одном из самых тёмных мест в лесу. Во мраке вы замечаете гигантских пауков, таких же, как %guide%, снующих повсюду. Они не нападают, будто признав в вас одного из своих. Хотя большинство из них ведут себя так, будто вас не существует, некоторые, похоже, следуют за %guide%. Кажется, они хотят присоединиться к вашему отряду.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Время возвращаться",
					function getResult( _event )
					{
						::World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = ::World.getTemporaryRoster();
				this.Characters.push(_event.m.Spider.getImagePath());
				
				if (_event.m.SpiderRecruit == null && _event.m.Count < 5)
				{
					_event.m.SpiderRecruit = roster.create("scripts/entity/tactical/player_beast/nggh_mod_spider_player");
					_event.m.SpiderRecruit.improveMood(1.0, "Нашёл новую королеву");
					_event.m.SpiderRecruit.setStartValuesEx();
				}
				
				if (_event.m.SpiderRecruit != null && ::World.getPlayerRoster().getSize() < ::World.Assets.getBrothersMax())
				{
					Options.insert(0, {
						Text = "Нам всегда пригодится ещё один сетеплёт",
						function getResult( _event )
						{
							::World.getPlayerRoster().add(_event.m.SpiderRecruit);
							_event.m.SpiderRecruit.onHired();
							_event.m.SpiderRecruit = null;
							_event.m.JustRecruit = 1;
							_event.m.Count += 1; 
							return "A";
						}

					});
				}

				if (_event.m.Egg != null && ::World.getPlayerRoster().getSize() < ::World.Assets.getBrothersMax())
				{
					Options.insert(0, {
						Text = "Яйца сетеплёта, безусловно, полезны",
						function getResult( _event )
						{
							::World.getPlayerRoster().add(_event.m.Egg);
							_event.m.Egg.onHired();
							_event.m.Egg = null;
							_event.m.JustRecruit = 2;
							return "A";
						}
					});
					
					this.Characters.push(_event.m.Egg.getImagePath());
				}

				this.List.push({
					id = 4,
					icon = "ui/icons/asset_brothers.png",
					text = "Ваш состав: [color=" + ::Const.UI.Color.PositiveValue + "]" + ::World.getPlayerRoster().getSize() + "[/color]/[color=" + ::Const.UI.Color.NegativeValue + "]" + ::World.Assets.getBrothersMax() + "[/color]",
				});
				
				if (_event.m.JustRecruit == 2)
				{
					this.List.push({
						id = 4,
						icon = "ui/orientation/spider_02_orientation.png",
						text = "Яйца сетеплёта присоединились к " + ::World.Assets.getName(),
					});
				}
				else if (_event.m.JustRecruit == 1)
				{
					this.List.push({
						id = 4,
						icon = "ui/orientation/spider_01_orientation.png",
						text = "Сетеплёт присоединился к " + ::World.Assets.getName() + " (" + _event.m.Count + ")",
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (::World.getTime().Days < 25)
		{
			return;
		}

		if ([
			::Const.World.TerrainType.Forest,
			::Const.World.TerrainType.LeaveForest,
			::Const.World.TerrainType.AutumnForest
		].find(::World.State.getPlayer().getTile().Type) == null)
		{
			return;
		}
		
		if (::World.getPlayerRoster().getSize() >= ::World.Assets.getBrothersMax())
		{
			return;
		}
		
		local hasSpider = false;
		local totalEggs = 0;

		foreach( bro in ::World.getPlayerRoster().getAll() )
		{
			if (bro.getFlags().has("spider"))
			{
				hasSpider = true;
				continue;
			}

			if (bro.getFlags().has("egg"))
			{
				++totalEggs;
			}
		}
		
		if (!hasSpider)
		{
			return;
		}
		
		if (totalEggs >= 5)
		{
			return;
		}

		this.m.Score = 120 - totalEggs * 25;
	}

	function onPrepare()
	{
		local roster = ::World.getTemporaryRoster();
		roster.clear();
		local candidates = [];
		
		foreach( bro in ::World.getPlayerRoster().getAll() )
		{
			if (bro.getFlags().has("spider"))
			{
				candidates.push(bro);
			}
		}
		
		this.m.Spider = ::MSU.Array.rand(candidates);

		this.m.Egg = roster.create("scripts/entity/tactical/player_beast/nggh_mod_spider_eggs_player");
		this.m.Egg.improveMood(1.0, "..........");
		this.m.Egg.setStartValuesEx();

		this.m.SpiderRecruit = roster.create("scripts/entity/tactical/player_beast/nggh_mod_spider_player");
		this.m.SpiderRecruit.improveMood(1.0, "Нашёл новую королеву");
		this.m.SpiderRecruit.setStartValuesEx();
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"guide",
			this.m.Spider.getName()
		]);
	}

	function onClear()
	{
		this.m.JustRecruit = 0;
		this.m.Egg = null;
		this.m.Spider = null;
		this.m.SpiderRecruit = null;
		this.m.Count = 0;
	}

});

