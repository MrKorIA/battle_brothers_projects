this.nggh_mod_simps_fight_each_other_event <- ::inherit("scripts/events/event", {
	m = {
		Hexe = null,
		Simp1 = null,
		Simp2 = null,
	},
	function create()
	{
		this.m.ID = "event.simps_fight_each_other";
		this.m.Title = "В лагере...";
		this.m.Cooldown = 25.0 * ::World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_06.png[/img]Раздающиеся крики и громкий шум напоминают драку забулдыг в таверне. Сначала вы, %hexe%, не обращаете внимания на происходящее, но через несколько минут понимаете, что этот гвалт скоро не закончится, а дело может дойти и до убийств. Выйдя из шатра, вы видите, как %randomsimp1% и %randomsimp2% сцепились в драке, подобно диким зверям в гоне. Часть окружающих безуспешно пытается растащить их, прочие же с интересом наблюдают за происходящим.%SPEECH_ON%Что происходит? Немедленно прекратите это безумие, идиоты! %SPEECH_OFF%В наступившей тишине все смотрят на вас, %randomsimp1% и %randomsimp2% перестают драться, с видом детей, которых собираются отругать. Они сбивчиво начинают объяснять причину драки, а вы с суровым видом продолжаете слушать. Вы тихо думаете:%SPEECH_ON%Эти глупцы подрались из-за такой мелочи? Какие милашки. Простые умы, неудивительно, почему они так легко поддаются моему обаянию. Что мне теперь делать? Выбрать одного из них, чтобы положить этому конец? %SPEECH_OFF%%hexe% улыбается.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				/*
				{
					Text = "Бросьте эту ерунду и возвращайтесь к работе.",
					function getResult( _event )
					{
						return 0;
					}

				},
				*/
				{
					Text = "Вы оба неправы, вы оба мне не нравитесь.",
					function getResult( _event )
					{
						return "RejectAll";
					}

				},
				{
					Text = "%randomsimp1% - мой любимый, все это знают.",
					function getResult( _event )
					{
						return "ChooseSimp1";
					}

				},
				{
					Text = "Иди сюда %randomsimp2%, любовь моя!",
					function getResult( _event )
					{
						return "ChooseSimp2";
					}

				},
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Simp1.getImagePath());
				this.Characters.push(_event.m.Simp2.getImagePath());
				local injuries = [
					{
						ID = "injury.crushed_finger",
						Threshold = 0.25,
						Script = "injury/crushed_finger_injury"
					},
					{
						ID = "injury.bruised_leg",
						Threshold = 0.25,
						Script = "injury/bruised_leg_injury"
					},
					{
						ID = "injury.broken_nose",
						Threshold = 0.25,
						Script = "injury/broken_nose_injury"
					},
					{
						ID = "injury.grazed_neck",
						Threshold = 0.25,
						Script = "injury/grazed_neck_injury"
					},
					{
						ID = "injury.stabbed_guts",
						Threshold = 0.5,
						Script = "injury/stabbed_guts_injury"
					},
					{
						ID = "injury.injured_shoulder",
						Threshold = 0.25,
						Script = "injury/injured_shoulder_injury"
					}
				];

				local injury = _event.m.Simp1.addInjury(injuries);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Simp1.getName() + " получает травму " + injury.getNameOnly()
				});

				injury = _event.m.Simp2.addInjury(injuries);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Simp2.getName() + " получает травму " + injury.getNameOnly()
				});
			}

		});
		this.m.Screens.push({
			ID = "ChooseSimp1",
			Text = "[img]gfx/ui/events/event_85.png[/img]%randomsimp1% ухмыляется, а затем изо всех сил начинает издеваться над %randomsimp2%. Все быстро следуют его примеру, чтобы принять участие в этой новой игре. Удовлетворенные увиденным, вы возвращаетесь в свою палатку, а %randomsimp1% следует рядом.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Это весело",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Simp1.getImagePath());
				local up = _event.increaseSimpLevel(_event.m.Simp1);
				local down = _event.decreaseSimpLevel(_event.m.Simp2);

				if (up != null)
				{
					this.List.push({
						id = 10,
						icon = up.getIcon(),
						text = _event.m.Simp1.getName() + " уровень простака повышен"
					});
				}

				_event.m.Simp1.improveMood(1.0, _event.m.Hexe.getName() + " любит меня");
				
				this.List.push({
					id = 10,
					icon = ::Const.MoodStateIcon[_event.m.Simp1.getMoodState()],
					text = _event.m.Simp1.getName() + ::Const.MoodStateEvent[_event.m.Simp1.getMoodState()]
				});

				if (down != null)
				{
					this.List.push({
						id = 10,
						icon = down.getIcon(),
						text = _event.m.Simp2.getName() + " сердце разбито"
					});
				}

				_event.m.Simp2.worsenMood(2.5, "Сердце разбито словами, что произнесла " + _event.m.Hexe.getName() + "");

				this.List.push({
					id = 10,
					icon = ::Const.MoodStateIcon[_event.m.Simp2.getMoodState()],
					text = _event.m.Simp2.getName() + ::Const.MoodStateEvent[_event.m.Simp2.getMoodState()]
				});

				_event.m.Hexe.improveMood(1.0, "Поиздевалась над чувствами некоторых глупцов");

				this.List.push({
					id = 10,
					icon = ::Const.MoodStateIcon[_event.m.Hexe.getMoodState()],
					text = _event.m.Hexe.getName() + ::Const.MoodStateEvent[_event.m.Hexe.getMoodState()]
				});
			}

		});
		this.m.Screens.push({
			ID = "ChooseSimp2",
			Text = "[img]gfx/ui/events/event_85.png[/img]%randomsimp2% ухмыляется, а затем изо всех сил начинает издеваться над %randomsimp1%. Все быстро следуют его примеру, чтобы принять участие в этой новой игре. Удовлетворенные увиденным, вы возвращаетесь в свою палатку, а %randomsimp2% следует рядом.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Это весело",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Simp2.getImagePath());
				local up = _event.increaseSimpLevel(_event.m.Simp2);
				local down = _event.decreaseSimpLevel(_event.m.Simp1);

				if (up != null)
				{
					this.List.push({
						id = 10,
						icon = up.getIcon(),
						text = _event.m.Simp2.getName() + " уровень простака повышен"
					});
				}

				_event.m.Simp2.improveMood(1.0, _event.m.Hexe.getName() + " любит меня");
				
				this.List.push({
					id = 10,
					icon = ::Const.MoodStateIcon[_event.m.Simp2.getMoodState()],
					text = _event.m.Simp2.getName() + ::Const.MoodStateEvent[_event.m.Simp2.getMoodState()]
				});

				if (down != null)
				{
					this.List.push({
						id = 10,
						icon = down.getIcon(),
						text = _event.m.Simp1.getName() + " сердце разбито"
					});
				}

				_event.m.Simp1.worsenMood(2.5, "Сердце разбито словами, что произнесла " + _event.m.Hexe.getName() + "");

				this.List.push({
					id = 10,
					icon = ::Const.MoodStateIcon[_event.m.Simp1.getMoodState()],
					text = _event.m.Simp1.getName() + ::Const.MoodStateEvent[_event.m.Simp1.getMoodState()]
				});

				_event.m.Hexe.improveMood(1.0, "Поиздевалась над чувствами некоторых глупцов");

				this.List.push({
					id = 10,
					icon = ::Const.MoodStateIcon[_event.m.Hexe.getMoodState()],
					text = _event.m.Hexe.getName() + ::Const.MoodStateEvent[_event.m.Hexe.getMoodState()]
				});
			}

		});
		this.m.Screens.push({
			ID = "RejectAll",
			Text = "[img]gfx/ui/events/event_120.png[/img]Слова %hexe%, подобно ледяной воде, окатывают лица %randomsimp1% и %randomsimp2%. Оглянувшись вокруг, они видят лишь жалостливые взгляды, униженные столь жалкой дракой.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Будут ли они снова бороться?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Hexe.getImagePath());
				local down;

				if (::Math.rand(1, 100) <= 50)
				{
					down = _event.decreaseSimpLevel(_event.m.Simp1);

					if (down != null)
					{
						this.List.push({
							id = 10,
							icon = down.getIcon(),
							text = _event.m.Simp1.getName() + " сердце разбито"
						});
					}

					_event.m.Simp1.worsenMood(2.5, "Сердце разбито словами, что произнесла " + _event.m.Hexe.getName() + "");
				}
				else 
				{
				    _event.m.Simp1.worsenMood(0.5, _event.m.Hexe.getName() + " не любит меня");
				}

				this.List.push({
					id = 10,
					icon = ::Const.MoodStateIcon[_event.m.Simp1.getMoodState()],
					text = _event.m.Simp1.getName() + ::Const.MoodStateEvent[_event.m.Simp1.getMoodState()]
				});

				if (::Math.rand(1, 100) <= 50)
				{
					down = _event.decreaseSimpLevel(_event.m.Simp2);

					if (down != null)
					{
						this.List.push({
							id = 10,
							icon = down.getIcon(),
							text = _event.m.Simp2.getName() + " сердце разбито"
						});
					}

					_event.m.Simp2.worsenMood(2.5, "Сердце разбито словами, что произнесла " + _event.m.Hexe.getName() + "");
				}
				else 
				{
				    _event.m.Simp2.worsenMood(0.5, _event.m.Hexe.getName() + " не любит меня");
				}

				this.List.push({
					id = 10,
					icon = ::Const.MoodStateIcon[_event.m.Simp2.getMoodState()],
					text = _event.m.Simp2.getName() + ::Const.MoodStateEvent[_event.m.Simp2.getMoodState()]
				});

				_event.m.Hexe.improveMood(1.0, "Поиздевалась над чувствами некоторых глупцов");

				this.List.push({
					id = 10,
					icon = ::Const.MoodStateIcon[_event.m.Hexe.getMoodState()],
					text = _event.m.Hexe.getName() + ::Const.MoodStateEvent[_event.m.Hexe.getMoodState()]
				});
			}

		});
	}		

	function onUpdateScore()
	{
		local hasHexe = false;
		local simps = 0;

		foreach( bro in ::World.getPlayerRoster().getAll() )
		{
			if (bro.getFlags().has("Hexe"))
			{
				hasHexe = true;
				continue;
			}
			
			if (bro.getSkills().hasSkill("effects.simp"))
			{
				++simps;
				continue;
			}
		}

		if (!hasHexe || simps < 2)
			return;

		this.m.Score = simps * 10;
	}

	function onPrepare()
	{
		local hexen = [];
		local simps = [
			[],
			[],
			[],
			[],
			[]
		];

		foreach( bro in ::World.getPlayerRoster().getAll() )
		{
			if (bro.getFlags().has("Hexe"))
			{
				hexen.push(bro);
				continue;
			}
			
			local charm = bro.getSkills().getSkillByID("effects.simp");

			if (charm != null)
			{
				local lv = charm.getSimpLevel();

				if (lv > 3)
				{
					simps[4].push(bro);
				}
				else
				{
					simps[lv].push(bro);
				}
				
				continue;
			}
		}

		local candidates = [];
		this.m.Hexe = ::MSU.Array.rand(hexen);

		if (simps[0].len() > 0)
		{
			candidates.extend(simps[0]);
		}

		if (simps[1].len() > 0)
		{
			candidates.extend(simps[1]);
		}

		if (simps[2].len() > 0)
		{
			candidates.extend(simps[2]);
		}

		if (simps[3].len() > 0)
		{
			if (candidates.len() <= 10)
			{
				candidates.extend(simps[3]);
			}
			else if (::Math.rand(1, 100) <= 67)
			{
				candidates.extend(simps[3]);
			}
		}

		if (simps[4].len() > 0)
		{
			if (candidates.len() <= 10)
			{
				candidates.extend(simps[4]);
			}
			else if (::Math.rand(1, 100) <= 34)
			{
				candidates.extend(simps[4]);
			}
		}

		local r = ::Math.rand(0, candidates.len() - 1);
		this.m.Simp1 = candidates[r];
		candidates.remove(r);

		this.m.Simp2 = ::MSU.Array.rand(candidates);
	}

	function increaseSimpLevel( _bro )
	{
		local charm = _bro.getSkills().getSkillByID("effects.simp");
		charm.gainSimpLevel();
		return charm;
	}

	function decreaseSimpLevel( _bro )
	{
		local charm = _bro.getSkills().getSkillByID("effects.simp");
		charm.loseSimpLevel();
		return charm;
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hexe",
			this.m.Hexe.getName()
		]);
		_vars.push([
			"randomsimp1",
			this.m.Simp1 != null ? this.m.Simp1.getName() : ""
		]);
		_vars.push([
			"randomsimp2",
			this.m.Simp2 != null ? this.m.Simp2.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Hexe = null;
		this.m.Simp1 = null;
		this.m.Simp2 = null;
	}

});

