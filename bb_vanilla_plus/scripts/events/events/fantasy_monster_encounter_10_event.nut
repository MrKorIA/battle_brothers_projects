this.fantasy_monster_encounter_10_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.fantasy_monster_encounter_10_event";
		this.m.Title = "На привале...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_78.png[/img]{Человек, одетый в роскошную одежду и сопровождаемый вооруженными людьми, похожими на телохранителей, прибыл в ваш лагерь. Несмотря на кратковременную напряженность в воздухе, мужчина сумел успокоить своих охранников и продолжил говорить благородным и достоинством тоном о цели своего визита. \n\nПо его словам, он был членом королевской семьи и проявил значительный интерес к нашей наемнической компании, желая стать ее покровителем. Однако в качестве условия он заявил, что хочет получить разнообразный опыт, проходящий через жизнь наемника, и попросил принять его в наш отряд.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Добро пожаловать, Ваше Высочество.",
					function getResult( _event )
					{
						return "B";
					}
				},
				{
					Text = "Я отклоняю это предложение, Ваше Высочество.",
					function getResult( _event )
					{
						return "C";
					}
				}
			],
			function start( _event )
			{
			}
		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_78.png[/img]{Когда вы дали ему разрешение присоединиться, вперед выступил человек, который, по всей видимости, был главой его охраны. Он строго предупредил вас, что будет следить за вами и не простит, если вы причините вред этому человеку, а затем ушел вместе с остальными.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Жизнь наемника не будет легкой, Ваше Высочество.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				local roster = this.World.getPlayerRoster();
				local xxlonexx = roster.create("scripts/entity/tactical/player");
				xxlonexx.setStartValuesEx([
					"xxheroroyal_background"
				]);
				xxlonexx.m.HireTime = this.Time.getVirtualTimeF();
				xxlonexx.m.PerkPoints = 1;
				xxlonexx.m.LevelUps = 1;
				xxlonexx.m.Level = 2;
				xxlonexx.m.Talents = [];
				xxlonexx.m.Attributes = [];
				local talents = xxlonexx.getTalents();
				talents.resize(this.Const.Attributes.COUNT, 0);
//				talents[this.Const.Attributes.Hitpoints] = 3;
//				talents[this.Const.Attributes.Bravery] = 3;
//				talents[this.Const.Attributes.Fatigue] = 3;
				talents[this.Const.Attributes.MeleeSkill] = 3;
//				talents[this.Const.Attributes.RangedSkill] = 3;
				talents[this.Const.Attributes.MeleeDefense] = 3;
//				talents[this.Const.Attributes.RangedDefense] = 3;
				talents[this.Const.Attributes.Initiative] = 3;
				xxlonexx.fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
				this.Characters.push(xxlonexx.getImagePath());
				return 0;
			}
		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_78.png[/img]{Когда вы отклонили предложение этого человека, его охранники возмутились и положили руки на рукояти своего оружия. Но тот человек широко улыбнулся, остановил своих телохранителей и попрощался с вами.%SPEECH_ON%Очень жаль. На самом деле, я хотел сделать вас своими людьми. Надеюсь, мы еще встретимся как друзья, а не как враги, мои друзья наемники.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Прощайте, Ваше Высочество.",
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
		if (this.World.getTime().Days < 100)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}
		local brothers = this.World.getPlayerRoster().getAll();
		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.xxheroroyal")
			{
				return;
				break;
			}
		}
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

