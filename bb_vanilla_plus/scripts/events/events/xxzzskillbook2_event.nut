this.xxzzskillbook2_event <- this.inherit("scripts/events/event", {
	m = {
		Bought = 0,
		HedgeKnight1 = null,
		RandomSkills = []
	},
	function create()
	{
		this.m.ID = "event.xxzzskillbook2_event";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "apage1",
			Text = "Выберите навык, который вы хотите, чтобы %hedgeknight1% выучил.",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				foreach (skillID in _event.m.RandomSkills)
				{
					local skillIDD = skillID;
					local skillPath = "scripts/skills/actives/" + skillIDD;
					this.Options.push({
						Text = this.new(skillPath).getName(),
						function getResult(_event)
						{
							_event.m.Bought = skillIDD;
							return "GG";
						}
					});
				}
				this.Options.push({
					Text = "[color=#3fcc69]Следующая страница[/color]",
					function getResult(_event)
					{
						return "apage2";
					}
				});
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
			}
		});
		this.m.Screens.push({
			ID = "apage2",
			Text = "Выберите навык, который вы хотите, чтобы %hedgeknight1% выучил.",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				this.Options.push({
					Text = "[color=#5ca3ed]Просмотреть описание навыка[/color]",
					function getResult(_event) { return "viewskill"; }
				});
				this.Options.push({
					Text = "[color=#f55951]Случайный навык[/color]",
					function getResult(_event)
					{
						_event.m.Bought = 9999977;
						return "GG";
					}
				});
				this.Options.push({
					Text = "[color=#b8b8b8]Не изучено (книга навыков потрачена впустую)[/color]",
					function getResult(_event)
					{
						local ax = _event.m.HedgeKnight1.getFlags().getAsInt("xxSkillBookTraining");
						if (ax > 0)
						{
							_event.m.HedgeKnight1.getFlags().increment("xxSkillBookTraining", -1);
						}
						return 0;
					}
				});
				this.Options.push({
					Text = "[color=#3fcc69]Следующая страница[/color]",
					function getResult(_event)
					{
						return "apage1";
					}
				});
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
			}
		});
		this.m.Screens.push({
			ID = "viewskill",
			Text = this.Const.Strings.FT.SkillList,
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Назад",
					function getResult( _event )
					{
						return "apage2";
					}
				}
			],
			function start( _event )
			{
			}
		});
		this.m.Screens.push({
			ID = "GG",
			Text = "",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Хорошо",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start(_event)
			{
				local actor = _event.m.HedgeKnight1;
				local chk = actor.getSkills();
				local sk_type = this.FantasySkillList;
				if (_event.m.Bought == 9999977)
				{
					sk_type = sk_type[this.Math.rand(0, sk_type.len() - 1)];
				}
				else
				{
					sk_type = _event.m.Bought;
				}
				if (actor.getSkills().hasSkill("actives." + sk_type))
				{
					sk_type = "sbp_allrounder_skill";
				}
				local sk_path = this.new("scripts/skills/actives/" + sk_type);
				chk.add(sk_path);
				actor.getSkills().removeByID("effects.xxzzcheck_skill");
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				this.Text = "%hedgeknight1% освоил новый навык.\n\n[color=#3fcc69]" + sk_path.getName() + "[/color]";
			}
		});
	}

	function onDetermineStartScreen()
	{
		return "apage1";
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("effects.xxzzcheck_skill"))
			{
				candidates.push(bro);
			}
		}
		if (candidates.len() == 0)
		{
			candidates = brothers;
		}
		this.m.HedgeKnight1 = candidates[this.Math.rand(0, candidates.len() - 1)];
		local sbn;
		local sk_type = [];
		this.m.RandomSkills = [];
		foreach (s in this.FantasySkillList)
		{
			sk_type.append(s);
		}
		sbn = 3;		// Num Skill Button
		if (this.Math.rand(6, 7) == 7)
		{
			sbn = this.Math.rand(3, 5);		// Num Skill Button
		}
		for (local i = 0; i < sbn; i++)
		{
             		local skillID = sk_type.remove(this.Math.rand(0, sk_type.len() - 1));
                	this.m.RandomSkills.push(skillID);
		}
		return;
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

