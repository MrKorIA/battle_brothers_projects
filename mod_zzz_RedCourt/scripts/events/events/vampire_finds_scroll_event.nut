this.vampire_finds_scroll_event <- this.inherit("scripts/events/event", {
	m = {
		Vampire = null,
		FoundItem = null
	},
	function create()
	{
		this.m.ID = "event.vampire_finds_scroll";
		this.m.Title = "Шёпот прошлого";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",

			Text = "%terrainImage%{Во время патрулирования вы обнаружили лагерь у древней дороги, которая уже давно отвоевана у природы. Стоящая рядом с повозкой фигура в капюшоне, кажется, чувствует вас на расстоянии, на котором не должен видеть ни один человек. Взгляд незнакомца пронзает воздух и проникает прямо в вас, как будто он каким-то образом знает, кто вы.\n\nЧеловек медленно отодвигает череп, лежащий рядом с ним у костра, и бросает в вас какой-то предмет. %vampire% замирает на месте, ожидая, что его тело будет сковано сетью, но сеть так и не появляется. Вместо неё в ближайший куст приземляется ранец с пергаментом и бумагами.\n%vampire% открывает перевязанный кожей мешок, но когда возвращает взгляд к телеге, там нет ничего, кроме давно прогоревшего костра...}",
			Image = "",
			List = [],
			Characters = [], 
			Options = [
				{
					Text = "Нам стоит уйти.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Vampire.getImagePath());
				this.World.Assets.getStash().add(_event.m.FoundItem);
				this.List.push({
					id = 10,
					icon = "ui/items/" + _event.m.FoundItem.getIcon(),
					text = "Вы получаете " + this.Const.Strings.getArticle(_event.m.FoundItem.getName()) + _event.m.FoundItem.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.hemovores" && this.World.Assets.getOrigin().getID() != "scenario.hemovores_avatar") //THIS WORKS
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.hemovore"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Vampire = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
		this.m.FoundItem = this.new("scripts/items/loot/ornate_tome_item");
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"vampire",
			this.m.Vampire.getNameOnly()
		]);
		_vars.push([
			"finding",
			this.Const.Strings.getArticle(this.m.FoundItem.getName()) + this.m.FoundItem.getName()
		]);
	}

	function onClear()
	{
		this.m.Vampire = null;
		this.m.FoundItem = null;
	}

});

