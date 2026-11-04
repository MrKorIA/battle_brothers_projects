this.xxzzskillbook_event <- this.inherit("scripts/events/event", {
	m = {
		Bought = 0,
		HedgeKnight1 = null
	},

	function create()
	{
		this.m.ID = "event.xxzzskillbook_event";
		this.m.IsSpecial = true;
		local skills = this.FantasySkillList;
		local totalSkills = skills.len();
		local skillsInFirstPage = 2;	/// Num Skill Button
		local skillsPerPage = 4;	/// Num Skill Button
		local remainingSkills = totalSkills - skillsInFirstPage;
		local totalPages = ceil(remainingSkills.tofloat() / skillsPerPage) + 1;
		for (local page = 0; page < totalPages; page++)
		{
			local currentPage = page + 1;
			local screen = {
				ID = "apage" + currentPage,
				Text = "Выберите навык, который вы хотите, чтобы %hedgeknight1% выучил.",
				Image = "",
				Banner = "",
				List = [],
				Characters = [],
				Options = [],
				function start(_event)
				{
					_event.m.Title = "Page " + currentPage;
					this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				}
			};
			if (currentPage == 1)
			{
				screen.Options.push({
					Text = "[color=#5ca3ed]Просмотреть описание навыка[/color]",
					function getResult(_event) { return "viewskill"; }
				});
				screen.Options.push({
					Text = "[color=#f55951]Случайный навык[/color]",
					function getResult(_event) {
						_event.m.Bought = 9999977;
						return "GG";
					}
				});
				for (local i = 0; i < skillsInFirstPage; i++)
				{
					local idx = i;
					local skillPath = "scripts/skills/actives/" + skills[idx];
					local skillName = this.new(skillPath).getName();
					screen.Options.push({
						Text = skillName,
						function getResult(_event) {
							_event.m.Bought = skills[idx];
							return "GG";
						}
					});
				}
			}
			else
			{
				for (local i = 0; i < skillsPerPage; i++)
				{
					local index = skillsInFirstPage + (page - 1) * skillsPerPage + i;
					if (index >= totalSkills) break;
					local idx = index;
					local skillPath = "scripts/skills/actives/" + skills[idx];
					local skillName = this.new(skillPath).getName();
					screen.Options.push({
						Text = skillName,
						function getResult(_event) {
							_event.m.Bought = skills[idx];
							return "GG";
						}
					});
				}
			}
			local prevPage = (currentPage - 2 + totalPages) % totalPages + 1;
			screen.Options.push({
				Text = "[color=#3fcc69]Предыдущая страница[/color]",
				function getResult(_event) { return "apage" + prevPage; }
			});
			local nextPage = (currentPage % totalPages) + 1;
			screen.Options.push({
				Text = "[color=#3fcc69]Следующая страница[/color]",
				function getResult(_event) { return "apage" + nextPage; }
			});
			this.m.Screens.push(screen);
		}
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
					function getResult(_event) {
						return "apage1";
					}
				}
			],
			function start(_event) {}
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
		foreach (bro in brothers)
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
		local rr = this.Math.rand(0, candidates.len() - 1);
		this.m.HedgeKnight1 = candidates[rr];
	}

	function onPrepare()
	{
	}

	function onPrepareVariables(_vars)
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
