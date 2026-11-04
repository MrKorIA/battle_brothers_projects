this.fear_hate_cultists_event <- this.inherit("scripts/events/event", {
	m = {
		Casualty = null,
		SkillToAdd= ""
	},
	function create()
	{
		this.m.ID = "event.fear_hate_cultists";
		this.m.Title = "После битвы...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "fear",
			Text = "[img]gfx/ui/events/event_26.png[/img]{%brother% сидит возле костра, смотря на собственные ладони.%SPEECH_ON%Проклятье, командир. Я не знаю, хватит ли мне сил снова встретиться с этими безумцами на поле боя. Они сумасшедшие! Им начхать на всё, даже на свои жизни! Ты видел, что они делают с людьми? Не дай бог мне испытать те страдания, которые ощутили эти несчастные, попавшие в руки культистов. Подумать только, они носят одежду из кожи. Человеческой кожи! Пускают людей как скот под нож, будто те звери, а после шьют себе из них дублеты! Я не хочу закончить так, как их жертвы! Не хочу быть заживо освежёванным... Не хочу... Пожалуйста, командир, давай обходить их десятой дорогой!%SPEECH_OFF%Вы киваете, а после говорите одному из наёмников, чтобы тот следил за спятившим собратом. Не хватало ещё, чтобы его страхи разошлись по отряду. Вы согласны со всеми его словами, но вы солдаты, а эта работа не из лёгких.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Результат пережитых ужасов.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Casualty.getImagePath());
				local trait = this.new("scripts/skills/traits/fear_cultists_trait");
				_event.m.Casualty.getSkills().add(trait);
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.Casualty.getName() + " теперь боится культистов"
				});
			}

		});
		this.m.Screens.push({
			ID = "hate",
			Text = "[img]gfx/ui/events/event_26.png[/img]{Во время марша наёмники треплются о самых разных вещах, но затянувшийся разговор про культистов внезапно вывел из себя одного из ваших людей. %brother% начал размахивать руками и рычать, подобно первобытному человеку, охваченному яростью.%SPEECH_ON%В бездну этих злобных ублюдков! В бездну этих сраных культистов! Если я ещё раз увижу этих злобных тварей, то повыдёргиваю им ноги! Покромсаю их книги и наложу кучу посреди каждого проклятого храма! А их главарю запихаю колонну в сраку! Давкул, Шмавкул - зубы у всех вылетают одинаково!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Не слишком ли много экспрессии?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Casualty.getImagePath());
				local trait = this.new("scripts/skills/traits/hate_cultists_trait");
				_event.m.Casualty.getSkills().add(trait);
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.Casualty.getName() + " теперь ненавидит культистов"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}
		if (this.World.Assets.getOrigin().getID() == "scenario.cultists") return

		if (this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() > 5.0)
		{
			return;
		}

		local fallen = this.World.Statistics.getFallen();

		if (fallen.len() < 2)
		{
			return;
		}

		if (fallen[0].Time < this.World.getTime().Days || fallen[1].Time < this.World.getTime().Days)
		{
			return;
		}

		if (this.World.Statistics.getFlags().getAsInt("LastCombatFaction") != this.World.FactionManager.getFactionOfType(this.Const.FactionType.Cultists).getID())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		//70% to be hate, 30% to be hate
		local newTrait = this.Math.rand(0, 10) > 2 ? "hate" : "fear"
		local skillToAdd = this.new("scripts/skills/traits/" + newTrait + "_cultists_trait")
		foreach( bro in brothers )
		{
			if (bro.getLevel() > 7) continue
			local isExcluded = false;
			//also checks for cultist background
			foreach(skill in skillToAdd.m.Excluded){
				if (bro.hasSkill(skill)){
					isExcluded = true
				}
			}
			if (!isExcluded) candidates.push(bro);	
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Casualty = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.SkillToAdd = newTrait
		this.m.Score = 50;
	}
	function onDetermineStartScreen()
	{
		return this.m.SkillToAdd;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"brother",
			this.m.Casualty.getName()
		]);
	}

	function onClear()
	{
		this.m.Casualty = null;
		this.m.SkillToAdd = ""
	}

});

