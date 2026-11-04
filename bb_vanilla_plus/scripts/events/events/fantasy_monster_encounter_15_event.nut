this.fantasy_monster_encounter_15_event <- this.inherit("scripts/events/event", {
	m = {
		HedgeKnight1 = null
	},
	function create()
	{
		this.m.ID = "event.fantasy_monster_encounter_15_event";
		this.m.Title = "Неожиданное событие...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_92.png[/img]{Во время отдыха в соседней деревне %hedgeknight1% и несколько его единомышленников выступили перед жителями деревни. К счастью, выступление этих друзей, любящих искусство, было хорошо принято жителями деревни. Жители деревни вознаградили великолепное выступление.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Эти ребята талантливы.",
					function getResult( _event )
					{
						return "B";
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();
				foreach( bro in brothers )
				{
					bro.improveMood(1, "Чувствует себя лучше");
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[bro.getMoodState()],
						text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
					});
				}
				local xxmoney = this.Math.rand(100, 500);
				this.World.Assets.addMoney(xxmoney);
				this.List.push({
					id = 11,
					icon = "ui/items/supplies/money.png",
					text = "Вы получаете " + xxmoney + " крон"
				});
			}
		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_65.png[/img]{Когда представление приближалось к кульминации, %hedgeknight1% возбудился и громко крикнул толпе. %SPEECH_ON%Дамы и господа, это еще не конец. Главная изюминка сегодняшнего представления! Самый опасный трюк в мире! Быть или не быть, вот в чем вопрос!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Звучит интересно. Давай!",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 50)
						{
							return "C";
						}
						else
						{
							return "D";
						}
					}
				},
				{
					Text = "Хватит рисковать! Это приказ!",
					function getResult( _event )
					{
						_event.m.HedgeKnight1.worsenMood(2, "Чувствует себя хуже");
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
			ID = "C",
			Text = "[img]gfx/ui/events/event_85.png[/img]{%hedgeknight1%Опасное для жизни представление началось с оваций зрителей. Когда представление, которое очень нервировало зрителей, закончилось успешно, раздались громкие овации и аплодисменты.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ты лучший!",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				local r = 3;
				_event.m.HedgeKnight1.getBaseProperties().MeleeSkill += r;
				_event.m.HedgeKnight1.getBaseProperties().RangedSkill += r;
				_event.m.HedgeKnight1.getBaseProperties().MeleeDefense += r;
				_event.m.HedgeKnight1.getBaseProperties().RangedDefense += r;
				_event.m.HedgeKnight1.getBaseProperties().Hitpoints += r;
				_event.m.HedgeKnight1.getBaseProperties().Stamina += r;
				_event.m.HedgeKnight1.getBaseProperties().Initiative += r;
				_event.m.HedgeKnight1.getBaseProperties().Bravery += r;
				_event.m.HedgeKnight1.getSkills().update();
				this.List.push({
					id = 11,
					icon = "ui/icons/plus.png",
					text = _event.m.HedgeKnight1.getName() + "Все характеристики увеличены на +3."
				});
			}
		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_12.png[/img]{%hedgeknight1% Опасное для жизни выступление началось с оваций зрителей. Выступление %hedgeknight1% закончилось катастрофой, когда он потерял равновесие и упал. Люди в ужасе закричали, увидев трагическое завершение выступления.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Нет!",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				local fallen = {
					Name = _event.m.HedgeKnight1.getName(),
					Time = this.World.getTime().Days,
					TimeWithCompany = this.Math.max(1, _event.m.HedgeKnight1.getDaysWithCompany()),
					Kills = _event.m.HedgeKnight1.getLifetimeStats().Kills,
					Battles = _event.m.HedgeKnight1.getLifetimeStats().Battles,
					KilledBy = "Погиб по неосторожности",
					Expendable = false
				};
				this.World.Statistics.addFallen(fallen);
				this.List.push({
					id = 10,
					icon = "ui/icons/kills.png",
					text = _event.m.HedgeKnight1.getName() + " умер"
				});
				_event.m.HedgeKnight1.getItems().transferToStash(this.World.Assets.getStash());
				_event.m.HedgeKnight1.getSkills().onDeath(this.Const.FatalityType.None);
				this.World.getPlayerRoster().remove(_event.m.HedgeKnight1);
			}
		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 10)
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
		local xsong = [];
		local xdance = [];
		foreach( bro in brothers )
		{
			if (!bro.getSkills().hasSkill("trait.player") && bro.getBackground().getID() == "background.minstrel")
			{
				xsong.push(bro);
			}
			if (!bro.getSkills().hasSkill("trait.player") && bro.getBackground().getID() == "background.juggler")
			{
				xdance.push(bro);
			}
		}
		if (xsong.len() < 1)
		{
			return;
		}
		if (xdance.len() < 1)
		{
			return;
		}
		this.m.HedgeKnight1 = xdance[this.Math.rand(0, xdance.len() - 1)];
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

