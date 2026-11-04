this.fantasy_monster_encounter_21_event <- this.inherit("scripts/events/event", {
	m = {
		HedgeKnight1 = null
	},
	function create()
	{
		this.m.ID = "event.fantasy_monster_encounter_21_event";
		this.m.Title = "Неожиданные события...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{%hedgeknight1% подходит к вам.%SPEECH_ON%Я хочу рассказать вам одну важную историю, хотя она и носит личный характер. Я слышал слухи, что моя {сестра | друг детства}, которую я потерял много лет назад, находится в этой деревне. Когда мы были маленькими, в нашу деревню пришла группа воров, и я думаю, что они похитили ее и продали сюда. Я был бы очень благодарен, если бы вы помогли мне найти ее.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Конечно. Давайте вместе ее найдем.",
					function getResult( _event )
					{
						return "Fight";
					}
				},
				{
					Text = "Не поддавайтесь влиянию слухов",
					function getResult( _event )
					{
						_event.m.HedgeKnight1.worsenMood(1.0, "Disappointed with the recent decision.");
						return 0;
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
			}
		});
		this.m.Screens.push({
			ID = "Fight",
			Text = "[img]gfx/ui/events/event_80.png[/img]{Во время расследования в деревне %hedgeknight1% поспешно подбежал к вам. %SPEECH_ON% Я нашел этих ублюдков. Я никогда не забуду их лица, даже спустя столько лет. Они по-прежнему занимаются торговлей людьми, а некоторых из похищенных ими женщин используют в качестве проституток здесь, в этой деревне. Пришло время отомстить этим гребаным ублюдкам.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To arms!",
					function getResult( _event )
					{
						local pp = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						pp.Music = this.Const.Music.BanditTracks;
						this.Const.World.Common.addUnitsToCombat(pp.Entities, this.Const.World.Spawn.Mercenaries, 300, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
						_event.registerToShowAfterCombat("Victory", "Defeat");
						this.World.State.startScriptedCombat(pp, false, false, true);
						return 0;
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
			}
		});
		this.m.Screens.push({
			ID = "Victory",
			Text = "[img]gfx/ui/events/event_91.png[/img]{После ожесточенной битвы %hedgeknight1% допрашивает одну из выживших, но оказывается, что женщина, которую он искал, уже умерла. %hedgeknight1% пришел в ярость, убил всех оставшихся в живых и освободил женщин, которых привезли сюда силой. Это кровопролитие в деревне напугало людей. Одна из освобожденных женщин хочет присоединиться к группе наемников, говоря, что ей больше некуда идти.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Приглашаем присоединиться. (Нужно свободное место в вашем списке наемников)",
					function getResult( _event )
					{
						if (this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
						{
							local roster = this.World.getPlayerRoster();
							local xxlonexx = roster.create("scripts/entity/tactical/player");
							xxlonexx.setStartValuesEx([
								"xxi_female_background"
							]);
							xxlonexx.m.HireTime = this.Time.getVirtualTimeF();
							xxlonexx.getBackground().m.RawDescription = "Когда вы впервые встретили %name%, она была похищена. Похитители подожгли ее дом и жестоко убили всю ее семью. С вашей помощью она отомстила за свою семью, но ей некуда было обратиться. Она присоединилась к %companyname%, сказав, что ей больше некуда идти.";
							xxlonexx.getBackground().buildDescription(true);
							return 0;
						}
						else
						{
							return 0;
						}
					}
				},
				{
					Text = "Нет, я не хочу, чтобы в нашей группе были посторонние люди.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				local xxmoney = this.Math.rand(800, 900);
				this.World.Assets.addMoney(xxmoney);
				this.List.push({
					id = 11,
					icon = "ui/items/supplies/money.png",
					text = "Вы получаете " + xxmoney + " крон"
				});
				_event.m.Title = "После битвы...";
			}
		});
		this.m.Screens.push({
			ID = "Defeat",
			Text = "[img]gfx/ui/events/event_88.png[/img]{Ваша группа потерпела поражение и сумела сбежать. Это кровопролитие в деревне напугало людей.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Проклятье!",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				_event.m.Title = "После битвы...";
			}
		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 50)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();
		local nearTown = false;
		local towns = this.World.EntityManager.getSettlements();
		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 3)
			{
				nearTown = true;
				break;
			}
		}
		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}
			candidates.push(bro);
		}
		if (candidates.len() < 1)
		{
			return;
		}
		this.m.HedgeKnight1 = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hedgeknight1",
			this.m.HedgeKnight1.getName()
		]);
	}

	function onClear()
	{
		this.m.HedgeKnight1 = null;
	}

});

