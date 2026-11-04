this.xxzzchaospotion_event <- this.inherit("scripts/events/event", {
	m = {
		LSK1 = 0,
		LSK2 = 0,
		Bought = 0,
		HedgeKnight1 = null
	},
	function create()
	{
		this.m.ID = "event.xxzzchaospotion_event";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "apage1",
			Text = "[img]gfx/ui/events/event_82.png[/img]{Select the stats %hedgeknight1% will gain.}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "%lsk1name%",
					function getResult( _event )
					{
						_event.m.Bought = _event.m.LSK1;
						return "GG";
					}
				},
				{
					Text = "%lsk2name%",
					function getResult( _event )
					{
						_event.m.Bought = _event.m.LSK2;
						return "GG";
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
			}
		});
		this.m.Screens.push({
			ID = "GG",
			Text = "[img]gfx/ui/events/event_74.png[/img]{The potion effect appears on %hedgeknight1%}",
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
			function start( _event )
			{
				local sk_type = [
		"+1 Hitpoints",
		"+1 Stamina (Fatigue)",
		"+1 Bravery",
		"+1 Initiative",
		"+1 Melee Skill",
		"+1 Ranged Skill",
		"+1 Melee Defense",
		"+1 Ranged Defense",
		"+1% Melee Damage",
		"+1% Ranged Damage",
		"+1% Damage (51% chance to gain)",
		"+1% Armor Damage"
		"+1% Armor Ignoring Damage (51% chance to gain)"
		"+2% Damage on a hit to the head"
		"+1% Chance to hit the head  (51% chance to gain)",
		"+2% Experience Gain",
		"+1% Chance of two defense rolls",
		"+1 HP recovery per turn (37% chance to gain)",
		"+1 Fatigue Recovery per turn  (27% chance to gain)",
		"-1 Daily Wage",
		"+2 Melee Skill, -1 Melee Defense",
		"+0~3 Stamina (Fatigue)",
		"+3 Ranged Skill, -3 Melee Skill",
		"+2 Melee Defense, +1 Ranged Defense, -1 Melee Skill, -1 Ranged Skill"
				];
				local rr = sk_type[_event.m.Bought]
				local actor = _event.m.HedgeKnight1;
				local gtxt = "Failed!";
				local gtxz = "Failed!";
				if (_event.m.Bought == 0)
				{
					actor.getFlags().increment("qzhp", 1);
					actor.getBaseProperties().Hitpoints += 1;
					gtxt = rr;
				}
				else	if (_event.m.Bought == 1)
				{
					actor.getFlags().increment("qzst", 1);
					actor.getBaseProperties().Stamina += 1;
					gtxt = rr;
				}
				else	if (_event.m.Bought == 2)
				{
					actor.getFlags().increment("qzbr", 1);
					actor.getBaseProperties().Bravery += 1;
					gtxt = rr;
				}
				else	if (_event.m.Bought == 3)
				{
					actor.getFlags().increment("qzin", 1);
					actor.getBaseProperties().Initiative += 1;
					gtxt = rr;
				}
				else	if (_event.m.Bought == 4)
				{
					actor.getFlags().increment("qzms", 1);
					actor.getBaseProperties().MeleeSkill += 1;
					gtxt = rr;
				}
				else	if (_event.m.Bought == 5)
				{
					actor.getFlags().increment("qzrs", 1);
					actor.getBaseProperties().RangedSkill += 1;
					gtxt = rr;
				}
				else	if (_event.m.Bought == 6)
				{
					actor.getFlags().increment("qzmd", 1);
					actor.getBaseProperties().MeleeDefense += 1;
					gtxt = rr;
				}
				else	if (_event.m.Bought == 7)
				{
					actor.getFlags().increment("qzrd", 1);
					actor.getBaseProperties().RangedDefense += 1;
					gtxt = rr;
				}
				else	if (_event.m.Bought == 8)
				{
					actor.getFlags().increment("xxcp8", 1);
					gtxt = rr;
				}
				else	if (_event.m.Bought == 9)
				{
					actor.getFlags().increment("xxcp9", 1);
					gtxt = rr;
				}
				else	if (_event.m.Bought == 10)
				{
					if (this.Math.rand(1, 100) <= 51)
					{
						actor.getFlags().increment("xxcp10", 1);
						gtxt = rr;
					}
				}
				else	if (_event.m.Bought == 11)
				{
					actor.getFlags().increment("xxcp11", 1);
					gtxt = rr;
				}
				else	if (_event.m.Bought == 12)
				{
					if (this.Math.rand(1, 100) <= 51)
					{
						actor.getFlags().increment("xxcp12", 1);
						gtxt = rr;
					}
				}
				else	if (_event.m.Bought == 13)
				{
					actor.getFlags().increment("xxcp13", 1);
					gtxt = rr;
				}
				else	if (_event.m.Bought == 14)
				{
					if (this.Math.rand(1, 100) <= 51)
					{
						actor.getFlags().increment("xxcp14", 1);
						gtxt = rr;
					}
				}
				else	if (_event.m.Bought == 15)
				{
					actor.getFlags().increment("xxcp15", 1);
					gtxt = rr;
				}
				else	if (_event.m.Bought == 16)
				{
					actor.getFlags().increment("xxcp16", 1);
					gtxt = rr;
				}
				else	if (_event.m.Bought == 17)
				{
					if (this.Math.rand(1, 100) <= 37)
					{
						actor.getFlags().increment("xxcp17", 1);
						gtxt = rr;
					}
				}
				else	if (_event.m.Bought == 18)
				{
					if (this.Math.rand(1, 100) <= 27)
					{
						actor.getFlags().increment("xxcp18", 1);
						gtxt = rr;
					}
				}
				else	if (_event.m.Bought == 19)
				{
					actor.getFlags().increment("qzwage", -1);
					if (actor.getCurrentProperties().DailyWage > 1)
					{
						actor.getBaseProperties().DailyWage += -1;
					}
					gtxt = rr;
				}
				else	if (_event.m.Bought == 20)
				{
					actor.getFlags().increment("qzms", 2);
					actor.getFlags().increment("qzmd", -1);
					actor.getBaseProperties().MeleeSkill += 2;
					actor.getBaseProperties().MeleeDefense += -1;
					gtxt = rr;
				}
				else	if (_event.m.Bought == 21)
				{
					local rz = this.Math.rand(0, 3)
					actor.getFlags().increment("qzst", rz);
					actor.getBaseProperties().Stamina += rz;
					gtxt = "+" + rz + " Stamina (Fatigue)";
				}
				else	if (_event.m.Bought == 22)
				{
					actor.getFlags().increment("qzrs", 3);
					actor.getFlags().increment("qzms", -3);
					actor.getBaseProperties().RangedSkill += 3;
					actor.getBaseProperties().MeleeSkill += -3;
					gtxt = rr;
				}
				else
				{
					actor.getFlags().increment("qzmd", 2);
					actor.getFlags().increment("qzrd", 1);
					actor.getFlags().increment("qzms", -1);
					actor.getFlags().increment("qzrs", -1);
					actor.getBaseProperties().MeleeDefense += 2;
					actor.getBaseProperties().RangedDefense += 1;
					actor.getBaseProperties().MeleeSkill += -1;
					actor.getBaseProperties().RangedSkill += -1;
					gtxt = rr;
				}
				if (!actor.getSkills().hasSkill("effects.xxzzchaospotion_skill"))
				{
					actor.getSkills().add(this.new("scripts/skills/actives/xxzzchaospotion_skill"));
				}
				actor.getSkills().removeByID("effects.xxzzcheck_skill");
				actor.getSkills().update();
				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = gtxt
				});
				if (gtxt == gtxz)
				{
					this.Sound.play("sounds/vomit_01.wav", this.Const.Sound.Volume.Inventory);
				}
				else
				{
					this.Sound.play("sounds/combat/drink_03.wav", this.Const.Sound.Volume.Inventory);
				}
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				return 0;
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
		local rr = 1;
		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("effects.xxzzcheck_skill"))
			{
				candidates.push(bro);
			}
		}
		if (candidates.len() < rr)
		{
			foreach( bro in brothers )
			{
				candidates.push(bro);
			}
		}
		rr = this.Math.rand(0, candidates.len() - 1);
		this.m.HedgeKnight1 = candidates[rr];
		candidates.remove(rr);
		local sk_type = [
		0,
		1,
		2,
		3,
		4,
		5,
		6,
		7,
		8,
		9,
		10,
		11,
		12,
		13,
		14,
		15,
		16,
		17,
		18,
		19,
		20,
		21,
		22,
		23
		];
		this.m.LSK1 = sk_type.remove(this.Math.rand(0, sk_type.len() - 1));
		this.m.LSK2 = sk_type.remove(this.Math.rand(0, sk_type.len() - 1));
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
		local sk_type = [
		"+1 Hitpoints",
		"+1 Stamina (Fatigue)",
		"+1 Bravery",
		"+1 Initiative",
		"+1 Melee Skill",
		"+1 Ranged Skill",
		"+1 Melee Defense",
		"+1 Ranged Defense",
		"+1% Melee Damage",
		"+1% Ranged Damage",
		"+1% Damage (51% chance to gain)",
		"+1% Armor Damage"
		"+1% Armor Ignoring Damage (51% chance to gain)"
		"+2% Damage on a hit to the head"
		"+1% Chance to hit the head  (51% chance to gain)",
		"+2% Experience Gain",
		"+1% Chance of two defense rolls",
		"+1 HP recovery per turn (37% chance to gain)",
		"+1 Fatigue Recovery per turn  (27% chance to gain)",
		"-1 Daily Wage",
		"+2 Melee Skill, -1 Melee Defense",
		"+0~3 Stamina (Fatigue)",
		"+3 Ranged Skill, -3 Melee Skill",
		"+2 Melee Defense, +1 Ranged Defense, -1 Melee Skill, -1 Ranged Skill"
		];
		local rr = sk_type[this.m.LSK1]		
		_vars.push([
			"lsk1name",
			rr
		]);
		rr = sk_type[this.m.LSK2]
		_vars.push([
			"lsk2name",
			rr
		]);
	}

	function onClear()
	{
		this.m.HedgeKnight1 = null;
	}
});

