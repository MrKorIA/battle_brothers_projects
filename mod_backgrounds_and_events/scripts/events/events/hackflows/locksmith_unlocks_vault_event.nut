this.locksmith_unlocks_vault_event <- this.inherit("scripts/events/event", {
	m = {
		Locksmith = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_locksmith_unlocks_vault";
		this.m.Title = "После битвы...";
		this.m.Cooldown = 20.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_30.png[/img][M] Стоило вашим людям прикончить последнего разбойника, не успевшего вовремя унести ноги, как вы невольно задаётесь вопросом: зачем вообще эти головорезы решили разбить лагерь именно здесь? Оглядевшись по сторонам, вы примечаете как минимум три холма в паре сотен шагов, которые подошли бы для обороны куда лучше этой низины.\n\nОднако все вопросы отпадают, когда отряд принимается прочёсывать стоянку в поисках наживы. Из глубины лагеря доносится удивлённый и громкий возглас вашего взломщика.%SPEECH_ON%Чёрт меня дери! Капитан, парни, это, должно быть, самая огромная железная дверь, которую я видел в своей жизни!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Давайте посмотрим, что он нашёл.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Locksmith.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_30.png[/img][M] Вы с парнями поспешно направляетесь на звук возгласа взломщика, и стоит вам добежать до места, как все прошлые вопросы отпадают сами собой. Перед вами высится массивная кованая дверь. Она более чем вдвое превосходит вас ростом и достаточно широка, чтобы шестеро крепких мужчин могли пройти сквозь неё плечом к плечу. Конструкция слегка утоплена в землю и намертво вделана в цельный кусок скалы.\n\nМногочисленные царапины и груды сломанных отмычек у порога красноречиво говорят о том, что убитые вами разбойники не жалели сил, пытаясь прорваться внутрь. Словно читая ваши мысли, %locksmith% самодовольно усмехается.%SPEECH_ON%Да, дура здоровая, спору нет. Но не дай себя обмануть, капитан - замочная скважина тут самого обычного размера. Зато эту заразу было чертовски трудно отыскать в тени скалы. Неудивительно, что бандиты ковырялись не там, где нужно, и так ничего и не добились.%SPEECH_OFF%Он присаживается на корточки и указывает пальцем на крошечную, хитро замаскированную щель на уровне колена.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Думаешь, сможешь ее открыть?",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Locksmith.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_30.png[/img][M] Вы интересуетесь, под силу ли взломщику вскрыть эту дверь. Он лишь самоуверенно усмехается в ответ.%SPEECH_ON%Само собой под силу, капитан! Но учтите - мне понадобится время. Эта хитроумная зараза - вам не дешёвый сундук заплывшего жиром купца и не заржавевший замок в тюремной камере!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Не торопись.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Locksmith.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_04.png[/img][M] Оставив взломщика один на один с древним механизмом, вы с остальными возвращаетесь к лагерным делам: чините помятые доспехи, переводите дух и наспех перекусываете. Спустя пару часов %locksmith% издаёт победный, ликующий клич, и вся рота снова срывается с мест на этот зов.\n\nВы прибегаете как раз вовремя, чтобы воочию увидеть, как массивная кованая дверь с глухим скрежетом сдвигается в сторону под действием скрытых противовесов, обнажая вековой тайник. В этот момент %locksmith% понимает, что его титанические усилия окупились сторицей! Вы оба застываете в немом изумлении, глядя на тускло блестящие груды древних монет и тяжелые оружейные стойки, забитые клинками в превосходном состоянии. Не сдерживая ликования, вы мёртвой хваткой вцепляетесь в ладонь взломщика, энергично трясёте её и приказываете ему первому набить карманы золотом в награду за блестящую службу.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Сокровище!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Locksmith.getImagePath());
				this.World.Assets.addMoney(2000);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы получаете [color=" + this.Const.UI.Color.PositiveEventValue + "]2.000[/color] крон"
				});
				local item1 = this.new("scripts/items/weapons/three_headed_flail");
				this.World.Assets.getStash().add(item1);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item1.getIcon(),
					text = "Вы получаете " + item1.getName()
				});
				local item2 = this.new("scripts/items/weapons/ancient/crypt_cleaver");
				this.World.Assets.getStash().add(item2);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item2.getIcon(),
					text = "Вы получаете " + item2.getName()
				});
				local item3 = this.new("scripts/items/weapons/two_handed_hammer");
				this.World.Assets.getStash().add(item3);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item3.getIcon(),
					text = "Вы получаете " + item3.getName()
				});
				_event.m.Locksmith.improveMood(2.0, "Применил свои навыки, чтобы обнаружить большое сокровище");

				if (_event.m.Locksmith.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Locksmith.getMoodState()],
						text = _event.m.Locksmith.getName() + this.Const.MoodStateEvent[_event.m.Locksmith.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (this.World.Statistics.getFlags().getAsInt("LastCombatResult") != 1 || this.World.Statistics.getFlags().getAsInt("LastLocationDestroyedFaction") != this.Const.Faction.Bandits)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		if (this.World.Assets.getStash().getNumberOfEmptySlots() < 4)
		{
			return;
		}

		if (this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() > 6.0)
		{
			return;
		}

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates_locksmith = [];

		foreach( b in brothers )
		{
			if (b.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (b.getBackground().getID() == "background.hackflows_locksmith")
			{
				candidates_locksmith.push(b);
			}
		}

		if (candidates_locksmith.len() == 0)
		{
			return;
		}

		this.m.Locksmith = candidates_locksmith[this.Math.rand(0, candidates_locksmith.len() - 1)];
		this.m.Score = candidates_locksmith.len() * 100;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"locksmith",
			this.m.locksmith.getName()
		]);
	}

	function onClear()
	{
		this.m.Locksmith = null;
	}

});

