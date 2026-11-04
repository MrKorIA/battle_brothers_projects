this.atilliator_crafts_masterwork_crossbow_event <- this.inherit("scripts/events/event", {
	m = {
		Atilliator = null,
		OtherBro1 = null,
		OtherBro2 = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_atilliator_crafts_masterwork_crossbow";
		this.m.Title = "Рядом с городом...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_82.png[/img][M] К вам подходит %atilliator%. Мастер осадного дела смиренно мнёт в руках снятую шляпу и явно не знает, с чего начать разговор. Как выясняется, он уже долгие годы за свой счёт собирал редчайшие компоненты, мечтая создать легендарный арбалет невиданного качества, но теперь ему отчаянно не хватает монет на покупку последних ключевых деталей.\n\nПять тысяч крон - сумма, безусловно, колоссальная для казны любого отряда, но %atilliator% уже полностью выверил все чертежи и клянётся своей головой, что этот шедевр превзойдёт любые ожидания.\n\nИнтуиция подсказывает вам: если вы откажете мастеру сейчас, то у него больше не будет шанса собрать остальные части для своего изобретения.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Создай арбалет, способный пробить самую толстую броню!",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Сейчас у нас нет на это денег.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Atilliator.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_82.png[/img][M] Поначалу этот шедевр не кажется чем-то из ряда вон выходящим. Своими размерами он ничуть не превосходит обычный тяжёлый арбалет, и хотя полированное дерево и кованые замки выглядят превосходно, с виду в нём нет никаких разительных отличий.\n\nВсё меняется, когда вы лично заправляете в ложе воронёный болт, взводите тугую тетиву и стреляете в одинокое дерево вдалеке. Хлёсткий, сухой звук удара раздаётся куда быстрее, чем вы ожидали. Подойдя ближе, вы с изумлением обнаруживаете, что арбалетный болт почти целиком ушёл в прочную, вековую древесину ствола. Сдерживая довольную улыбку, вы крепко жмёте оружейнику руку и поздравляем его с блестящей работой.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Такое чувство, будто я держу пушку...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Atilliator.getImagePath());
				this.World.Assets.addMoney(-5000);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы тратите [color=" + this.Const.UI.Color.NegativeEventValue + "]5.000[/color] Крон"
				});
				local item = this.new("scripts/items/weapons/hackflows/masterwork_crossbow");
				item.m.Name = "Арбалет высшего качества " + _event.m.Atilliator.getNameOnly();
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Вы получаете " + item.getName()
				});
				_event.m.Atilliator.improveMood(2.0, "Создал оружие исключительного качества");

				if (_event.m.Atilliator.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Atilliator.getMoodState()],
						text = _event.m.Atilliator.getName() + this.Const.MoodStateEvent[_event.m.Atilliator.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getMoney() < 12500)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 8 && bro.getBackground().getID() == "background.hackflows_atilliator")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Atilliator = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 30;
	}

	function onPrepare()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.Atilliator.getID())
			{
				this.m.OtherBro1 = bro;
				break;
			}
		}

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.Atilliator.getID() && bro.getID() != this.m.OtherBro1.getID())
			{
				this.m.OtherBro2 = bro;
				break;
			}
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"atilliator",
			this.m.Atilliator.getNameOnly()
		]);
		_vars.push([
			"otherbro1",
			this.m.OtherBro1.getName()
		]);
		_vars.push([
			"otherbro2",
			this.m.OtherBro2.getName()
		]);
	}

	function onClear()
	{
		this.m.Atilliator = null;
		this.m.OtherBro1 = null;
		this.m.OtherBro2 = null;
	}

});

