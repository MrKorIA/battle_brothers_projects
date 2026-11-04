this.fantasy_monster_encounter_12_event <- this.inherit("scripts/events/event", {
	m = {
		Title1 = "Warrior",
		HedgeKnight1 = null
	},
	function create()
	{
		this.m.ID = "event.fantasy_monster_encounter_12_event";
		this.m.Title = "На привале...";
		this.m.Cooldown = 15.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]{Люди с опасными и необычными профессиями, такие как наемники и авантюристы, часто имеют свое прошлое. Во время перерыва, разговаривая с членами группы, вы услышали историю об одном из них. История была настолько интересной, что вы слушали ее до тех пор, пока не принесли еду, и благодаря ей вы узнали, что с ним произошло в прошлом. | Пока вы беседовали с одним из членов группы, вам случайно удалось услышать историю из его прошлого. Он спокойным тоном продолжил рассказ о том, чем занимался до того, как стал авантюристом и наемником, и это была довольно интересная история. Когда длинный рассказ закончился, он посмотрел прямо на вас и заговорил.%SPEECH_ON%It\'s Давно я не вел с кем-то столь глубокую беседу. Спасибо, что выслушали, босс.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Это была интересная история.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight1.getImagePath());
				_event.m.HedgeKnight1.improveMood(0.5, "Чувствует себя лучше");
				_event.m.HedgeKnight1.getFlags().add("PastDone");
				if (this.Math.rand(1, 100) <= 67)
				{
					local back_type = [
					"gambler_background",
					"thief_background",
					"graverobber_background",
					"killer_on_the_run_background",
					"raider_background",
					"wildman_background",
					"brawler_background",
					"militia_background",
					"squire_background",
					"apprentice_background",
					"retired_soldier_background",
					"vagabond_background",
					"refugee_background",
					"miner_background",
					"farmhand_background",
					"fisherman_background",
					"lumberjack_background",
					"poacher_background",
					"hunter_background",
					"sellsword_background"
					];
					local back_name = [
					"Gambler",
					"Thief",
					"Graverobber",
					"Killer",
					"Raider",
					"Wildman",
					"Brawler",
					"Militia",
					"Squire",
					"Apprentice",
					"Ex-Soldier",
					"Vagabond",
					"Refugee",
					"Miner",
					"Farmhand",
					"Fisherman",
					"Lumberjack",
					"Poacher",
					"Hunter",
					"Sellsword"
					];
					local back_check = [
					"background.gambler",
					"background.thief",
					"background.graverobber",
					"background.killer_on_the_run",
					"background.raider",
					"background.wildman",
					"background.brawler",
					"background.militia",
					"background.squire",
					"background.apprentice",
					"background.retired_soldier",
					"background.vagabond",
					"background.refugee",
					"background.miner",
					"background.farmhand",
					"background.fisherman",
					"background.lumberjack",
					"background.poacher",
					"background.hunter",
					"background.sellsword"
					];
					back_type = this.new("scripts/skills/backgrounds/" + back_type[this.Math.rand(0, back_type.len() - 1)]);
					back_type.m.RawDescription = _event.m.HedgeKnight1.getBackground().m.RawDescription + " Вы слышали о прошлом %name%, но это не важно. Важно то, что %name% является членом %companyname%.";
					_event.m.HedgeKnight1.getSkills().removeByID(_event.m.HedgeKnight1.getBackground().getID());
					_event.m.HedgeKnight1.getSkills().add(back_type);
					for( local i = 0; i < back_check.len(); i = ++i )
					{
						if (_event.m.HedgeKnight1.getSkills().hasSkill(back_check[i]))
						{
							_event.m.Title1 = back_name[i];
						}
					}
					_event.m.HedgeKnight1.getSkills().update();
				}
				else
				{
					local back_type = [
					"Warrior",
					"Runaway",
					"Inquisitor",
					"Orphan",
					"Tax Evader",
					"Revenger",
					"Prizefighter",
					"Proxy Duelist",
					"Craftsman",
					"Pirate",
					"Cheater",
					"Villager",
					"Ex-Convict",
					"Bookworm",
					"Outlaw",
					"Lover",
					"Romanticist",
					"Adulterer",
					"Bodyguard",
					"Hangman",
					"Daydreamer",
					"Vigilante",
					"Pacifist",
					"Collector",
					"Fixer",
					"Dancer",
					"Singer",
					"Trainer"
					];
					_event.m.Title1 = back_type[this.Math.rand(0, back_type.len() - 1)];
					back_type = this.new("scripts/skills/backgrounds/companion_1h_background");
					back_type.m.RawDescription = _event.m.HedgeKnight1.getBackground().m.RawDescription + " Вы слышали о прошлом %name%, но это не важно. Важно то, что %name% является членом %companyname%.";
					_event.m.HedgeKnight1.getSkills().removeByID(_event.m.HedgeKnight1.getBackground().getID());
					_event.m.HedgeKnight1.getSkills().add(back_type);
					_event.m.HedgeKnight1.getSkills().update();
				}
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.HedgeKnight1.getMoodState()],
					text = _event.m.HedgeKnight1.getName() + " was a " + _event.m.Title1
				});
				_event.m.HedgeKnight1.setTitle(_event.m.Title1);
			}
		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 10)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		local rr = 1;
		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getLevel() < 5)
			{
				continue;
			}

			if (bro.getSkills().hasSkill("effects.xxzzfantasy_skill") && !bro.getFlags().has("PastDone"))
			{
				candidates.push(bro);
			}
		}
		if (candidates.len() < rr)
		{
			return;
		}
		rr = this.Math.rand(0, candidates.len() - 1);
		this.m.HedgeKnight1 = candidates[rr];
		candidates.remove(rr);
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
		this.m.Title1 = "Warrior";
		this.m.HedgeKnight1 = null;
	}

});

