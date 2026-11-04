this.ret_gladiator_slave_learns_event <- this.inherit("scripts/events/event", {
	m = {
		Apprentice = null,
		Gladiator = null
	},
	function create()
	{
		this.m.ID = "event.ret_gladiator_slave_learns";
		this.m.Title = "На привале...";
		this.m.Cooldown = 55.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]%apprentice% с трудом поспевает за вами с тех пор, как вы взяли его в бой. Но в пылу сражения он не может не смотреть, как вы убиваете врага за врагом, как дровосек валит деревья. С тех пор его отношение изменилось, %apprentice% стал подходить ближе и следить за вашими движениями, словно тень. С тех пор как вы впервые встретились, %apprentice% сделал много шагов вперед, и ему есть чем похвастаться.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Всё, что ему нужно, - это небольшой толчок в правильном направлении...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Apprentice.getImagePath());
				this.Characters.push(_event.m.Gladiator.getImagePath());
				local meleeSkill = this.Math.rand(7, 10);
				local hitpoints = this.Math.rand(10, 15);
				local stamina = this.Math.rand(5, 8);
				local bravery = this.Math.rand(8, 14);
				_event.m.Apprentice.getBaseProperties().MeleeSkill += meleeSkill;
				_event.m.Apprentice.getBaseProperties().Hitpoints += hitpoints;
				_event.m.Apprentice.getBaseProperties().Stamina += stamina;
				_event.m.Apprentice.getBaseProperties().Bravery += bravery;
				_event.m.Apprentice.getSkills().update();
				_event.markAsLearned();
				_event.m.Apprentice.improveMood(1.0, "Обучился у товарища по имени " + _event.m.Gladiator.getName());
				_event.m.Gladiator.improveMood(0.25, "Обучил товарища по имени " + _event.m.Apprentice.getName() + " кое-чему нужному");
				this.List = [
					{
						id = 16,
						icon = "ui/icons/melee_skill.png",
						text = _event.m.Apprentice.getName() + " получает [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeSkill + "[/color] к навыку ближнего боя"
					},
					{
						id = 17,
						icon = "ui/icons/health.png",
						text = _event.m.Apprentice.getName() + " получает [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + hitpoints + "[/color] к ОЗ"
					},
					{
						id = 17,
						icon = "ui/icons/fatigue.png",
						text = _event.m.Apprentice.getName() + " получает [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + stamina + "[/color] к выносливости"
					},
					{
						id = 17,
						icon = "ui/icons/bravery.png",
						text = _event.m.Apprentice.getName() + " получает [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + bravery + "[/color] к решимости"
					}
				];

				if (_event.m.Apprentice.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Apprentice.getMoodState()],
						text = _event.m.Apprentice.getName() + this.Const.MoodStateEvent[_event.m.Apprentice.getMoodState()]
					});
				}
			}

		});
	}

	function markAsLearned()
	{
		this.m.Apprentice.getFlags().add("learned");
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		local apprentice_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.slave" && !bro.getFlags().has("learned"))
			{
				apprentice_candidates.push(bro);
			}
		}

		if (apprentice_candidates.len() < 1)
		{
			return;
		}

		local gladiator_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() < 6)
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.retired_gladiator")
			{
				gladiator_candidates.push(bro);
			}
		}

		if (gladiator_candidates.len() < 1)
		{
			return;
		}

		this.m.Apprentice = apprentice_candidates[this.Math.rand(0, apprentice_candidates.len() - 1)];
		this.m.Gladiator = gladiator_candidates[this.Math.rand(0, gladiator_candidates.len() - 1)];
		this.m.Score = (apprentice_candidates.len() + gladiator_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"apprentice",
			this.m.Apprentice.getNameOnly()
		]);
		_vars.push([
			"gladiator",
			this.m.Gladiator.getNameOnly()
		]);
	}

	function onDetermineStartScreen()
	{
		if (this.m.Gladiator.getBackground().getID() == "background.retired_gladiator")
		{
			return "A";
		}
	}

	function onClear()
	{
		this.m.Apprentice = null;
		this.m.Gladiator = null;
	}

});

