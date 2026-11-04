this.blacksmith_crafts_masterwork_weapon_event <- this.inherit("scripts/events/event", {
	m = {
		Blacksmith = null,
		OtherBro1 = null,
		OtherBro2 = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_blacksmith_crafts_masterwork_weapon";
		this.m.Title = "Рядом с городом...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_82.png[/img][M] Неподалеку от поселения %townname%, пока вы заняты разбором лагерного инвентаря, к вам нерешительно приближается %blacksmith%. Кузнец нервно перебирает мозолистыми пальцами, что выглядит крайне странно для мужчины его почтенного возраста и грозного телосложения.\n\nВы откладываете записи и выжидательно смотрите на него в предвкушении скверных новостей. Однако мастер вместо жалоб внезапно выпаливает, что его обуяло такое неистовое творческое вдохновение, какого он не испытывал уже долгие годы.\n\nПо его словам, если выделите ему шесть тысяч крон на редкие материалы и зарезервируете городские горны, которые использует местный город %townname% всего на один день, он сумеет выковать легендарный двуручный меч.\n\nОдин лишь взгляд на лицо ремесленника доказывает, что он настроен серьёзно как никогда. И всё же шесть тысяч монет - это колоссальное состояние, на которое можно было бы безбедно снабжать весь отряд провизией, инструментами и медикаментами на протяжении многих недель.\n\nОднако интуиция настойчиво твердит: если упустить этот редкий шанс сейчас, %blacksmith% больше никогда не поймает эту ускользающую искру кузнечного вдохновения.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Зажигай горны! Нам нужен клинок, которому позавидуют и короли",
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
				this.Characters.push(_event.m.Blacksmith.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_82.png[/img][M] %blacksmith% в конце концов возвращается из кузницы. Результат его титанических трудов имеет настолько величественный вид, что вы на миг застываете в оцепенении, просто разглядывая это совершенное оружие.\n\nЗатем %blacksmith% почтительно протягивает вам клинок - точно преданный оруженосец благородному рыцарю. Несколько обескураженный столь изысканными манерами сурового ремесленника, вы с некоторой неловкостью принимаете рукоять из его рук.\n\nДвуручный меч оказывается невероятно лёгким, словно продолжение руки. Вы делаете несколько пробных выпадов в воздухе: пускай вы и далеки от истинного мастерства фехтования, рассекающие удары выходят на удивление стремительными, хлёсткими и точными.\n\nСтоящий неподалёку %otherbro1% одобрительно свистит, завидев блеск стали, а находящийся рядом %otherbro2% просто застывает в благоговейном трепете. Вскоре весь отряд, толкаясь и шумно переговариваясь, обступает вас, желая воочию полюбоваться этим шедевром.\n\nВеличественное выражение лица кузнеца тут же сменяется довольной, широкой ухмылкой, когда наёмники один за другим принимаются хлопать мастера по плечу под бурные, одобрительные возгласы отряда.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "С таким талантом... почему ты ушёл в наёмники?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Blacksmith.getImagePath());
				this.World.Assets.addMoney(-6000);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы тратите [color=" + this.Const.UI.Color.NegativeEventValue + "]6.000[/color] крон"
				});
				local item = this.new("scripts/items/weapons/hackflows/masterwork_greatsword");
				item.m.Name = "Двуручный меч высшего качества: мастер " + _event.m.Blacksmith.getNameOnly();
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Вы получаете " + item.getName()
				});
				_event.m.Blacksmith.improveMood(2.0, "Создал оружие исключительного качества");

				if (_event.m.Blacksmith.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Blacksmith.getMoodState()],
						text = _event.m.Blacksmith.getName() + this.Const.MoodStateEvent[_event.m.Blacksmith.getMoodState()]
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

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 4 && (t.isMilitary() || t.isSouthern()))
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
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
			if (bro.getLevel() >= 8 && bro.getBackground().getID() == "background.hackflows_blacksmith")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Blacksmith = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = candidates.len() * 2000;
	}

	function onPrepare()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.Blacksmith.getID())
			{
				this.m.OtherBro1 = bro;
				break;
			}
		}

		foreach( bro in brothers )
		{
			if (bro.getID() != this.m.Blacksmith.getID() && bro.getID() != this.m.OtherBro1.getID())
			{
				this.m.OtherBro2 = bro;
				break;
			}
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"blacksmith",
			this.m.Blacksmith.getNameOnly()
		]);
		_vars.push([
			"otherbro1",
			this.m.OtherBro1.getName()
		]);
		_vars.push([
			"otherbro2",
			this.m.OtherBro2.getName()
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Blacksmith = null;
		this.m.OtherBro1 = null;
		this.m.OtherBro2 = null;
		this.m.Town = null;
	}

});

