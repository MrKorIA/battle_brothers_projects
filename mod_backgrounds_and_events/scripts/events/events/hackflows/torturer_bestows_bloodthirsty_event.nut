this.torturer_bestows_bloodthirsty_event <- this.inherit("scripts/events/event", {
	m = {
		Torturer = null,
		OtherBro1 = null,
		OtherBro2 = null,
		OtherBro3 = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_torturer_bestows_bloodthirsty";
		this.m.Title = "В пути...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_81.png[/img][M] Вы определённо не ожидали этого, когда %torturer% только пополнил ряды отряда, но этот человек оказался на редкость словоохотливым малым. Как выясняется, дружеские беседы со своими обречёнными жертвами на дыбе были лишь одним из излюбленных способов, которыми %torturer% развлекал себя во время пыток.\n\nПрямо сейчас этот болтун травит у костра леденящие душу истории о вырывании ногтей, дроблении костей и искусном срезании плоти с таким будничным видом, словно заезжий торговец пересчитывает выручку. Что самое поразительное, вокруг него уже успел сколотиться настоящий круг преданных слушателей: затаив дыхание, %otherbro1%, %otherbro2% и %otherbro3% слушают его с нарастающим злорадным восторгом. Похоже, за последнее время ваши люди стали куда более кровожадными и безжалостными. Остаётся лишь надеяться, что эта растущая тяга к насилию выльется в куда более яростную и эффективную рубку на полях грядущих сражений.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Похоже, наш отряд стал гораздо кровожаднее.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Torturer.getImagePath());
				this.Characters.push(_event.m.OtherBro1.getImagePath());
				local trait = this.new("scripts/skills/traits/bloodthirsty_trait");
				_event.m.OtherBro1.getSkills().add(trait);
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.OtherBro1.getName() + " теперь кровожадный"
				});
				_event.m.OtherBro2.getSkills().add(trait);
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.OtherBro2.getName() + " теперь кровожадный"
				});
				_event.m.OtherBro3.getSkills().add(trait);
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.OtherBro3.getName() + " теперь кровожадный"
				});
			}

		});
	}

	function onUpdateScore()
	{
		function canBecomeBloodthirsty( brother )
		{
			local skills = brother.getSkills();
			return !(skills.hasSkill("trait.craven") || skills.hasSkill("trait.weasel") || skills.hasSkill("trait.fainthearted") || skills.hasSkill("trait.hesistant") || skills.hasSkill("trait.insecure") || skills.hasSkill("trait.craven") || skills.hasSkill("trait.paranoid") || skills.hasSkill("trait.fear_beasts") || skills.hasSkill("trait.fear_undead") || skills.hasSkill("trait.fear_greenskins") || skills.hasSkill("trait.teamplayer") || skills.hasSkill("trait.bloodthirsty"));
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 5)
		{
			return;
		}

		local candidates_torturer = [];

		foreach( b in brothers )
		{
			if (b.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (b.getBackground().getID() == "background.hackflows_torturer" && b.getLevel() >= 3)
			{
				candidates_torturer.push(b);
			}
			else if (this.m.OtherBro1 == null && canBecomeBloodthirsty(b))
			{
				this.m.OtherBro1 = b;
			}
			else if (this.m.OtherBro2 == null && canBecomeBloodthirsty(b))
			{
				this.m.OtherBro2 = b;
			}
			else if (this.m.OtherBro3 == null && canBecomeBloodthirsty(b))
			{
				this.m.OtherBro3 = b;
			}
		}

		if (candidates_torturer.len() == 0 || this.m.OtherBro1 == null || this.m.OtherBro2 == null || this.m.OtherBro3 == null)
		{
			return;
		}

		this.m.Torturer = candidates_torturer[this.Math.rand(0, candidates_torturer.len() - 1)];
		this.m.Score = candidates_torturer.len() * 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"torturer",
			this.m.Torturer.getName()
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
			"otherbro3",
			this.m.OtherBro3.getName()
		]);
	}

	function onClear()
	{
		this.m.Torturer = null;
		this.m.OtherBro1 = null;
		this.m.OtherBro2 = null;
		this.m.OtherBro3 = null;
	}

});

