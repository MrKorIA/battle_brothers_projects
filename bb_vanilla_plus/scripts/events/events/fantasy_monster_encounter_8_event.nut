this.fantasy_monster_encounter_8_event <- this.inherit("scripts/events/event", {
	m = {
		HedgeKnight1 = null
	},
	function create()
	{
		this.m.ID = "event.fantasy_monster_encounter_8_event";
		this.m.Title = "Неожиданное событие...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_80.png[/img]{Когда ваша группа наемников вошла в соседнюю деревню, к нам подбежала плачущая девочка. %SPEECH_ON%Пожалуйста, помогите мне, сэр. Меня похитили. Если они снова поймают меня, я могу погибнуть. Пожалуйста, спасите меня! %SPEECH_OFF%Вскоре за ней прибежала группа вооруженных мужчин и столкнулась с вами.%SPEECH_ON%{Эй, я не знаю, что ты слышал от этой суки, но это все ложь. Мы ведем бизнес в городе на законных основаниях, и эта сука — наша собственность. Просто убирайся! | Сэр, не верьте ее лжи! Она злая ведьма. Мы просто выполняем свою работу по просьбе жителей деревни. Пожалуйста, уходите!}%SPEECH_OFF%Женщина плакала и кричала.%SPEECH_ON%Эти злобные ублюдки убили мою семью и сожгли мой дом. Я лучше покончу с собой здесь, чем позволю этим ублюдкам утащить меня!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Надо спасти эту женщину. Готовьтесь к бою.!",
					function getResult( _event )
					{
						local pp = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						pp.Music = this.Const.Music.BanditTracks;
						this.Const.World.Common.addUnitsToCombat(pp.Entities, this.Const.World.Spawn.BanditBoss, 200, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).getID());
						_event.registerToShowAfterCombat("Victory", "Defeat");
						this.World.State.startScriptedCombat(pp, false, false, true);
						return 0;
					}
				},
				{
					Text = "Это не наше дело.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.HedgeKnight1 = null;
						return 0;
					}
				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.HedgeKnight1 = roster.create("scripts/entity/tactical/player");
				_event.m.HedgeKnight1.setStartValuesEx([
					"xxi_female_background"
				]);
				_event.m.HedgeKnight1.getBackground().m.RawDescription = "Когда вы впервые встретили %name%, она была похищена. Похитители подожгли ее дом и жестоко убили всю ее семью. С вашей помощью она отомстила за свою семью, но ей некуда было обратиться. Она присоединилась к %companyname%, сказав, что ей больше некуда идти.";
				_event.m.HedgeKnight1.getBackground().buildDescription(true);
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
			}
		});
		this.m.Screens.push({
			ID = "Victory",
			Text = "[img]gfx/ui/events/event_91.png[/img]{После ожесточенной схватки все похитители были убиты. Это кровопролитие в деревне напугало людей. Спасенная женщина благодарна и хочет присоединиться к %companyname%, говоря, что ей больше некуда идти.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Добро пожаловать к нам. (Нужно свободное место в списке наемников)",
					function getResult( _event )
					{
						if (this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
						{
							this.World.getPlayerRoster().add(_event.m.HedgeKnight1);
							this.World.getTemporaryRoster().clear();
							_event.m.HedgeKnight1.onHired();
							_event.m.HedgeKnight1.m.MoodChanges = [];
							_event.m.HedgeKnight1.improveMood(1.0, "Стала наемницей");
							_event.m.HedgeKnight1 = null;
							return 0;
						}
						else
						{
							this.World.getTemporaryRoster().clear();
							_event.m.HedgeKnight1 = null;
							return 0;
						}
					}
				},
				{
					Text = "Нет, я не хочу, чтобы в нашей группе были незнакомцы.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.HedgeKnight1 = null;
						return 0;
					}
				}
			],
			function start( _event )
			{
				local xxmoney = this.Math.rand(500, 700);
				this.World.Assets.addMoney(xxmoney);
				this.List.push({
					id = 11,
					icon = "ui/items/supplies/money.png",
					text = "Вы получаете " + xxmoney + " золота"
				});
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
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
						this.World.getTemporaryRoster().clear();
						_event.m.HedgeKnight1 = null;
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
		this.m.Score = 5;
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

