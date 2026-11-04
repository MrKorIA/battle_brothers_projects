this.retired_gladiator_converts_slave_event <- this.inherit("scripts/events/event", {
	m = {
		retiredgladiator = null,
		slave = null
	},
	function create()
	{
		this.m.ID = "event.retired_gladiator_converts_slave";
		this.m.Title = "На привале...";
		this.m.Cooldown = 28.0 * this.World.getTime().SecondsPerDay; 
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]Вы давно положили глаз на него, %slave% демонстрирует боевой потенциал и правильное мышление для дальнейшего развития. Вы можете лично обучать его, как это делал ваш мастер, но это означает, что вы должны принять его как равного, включая жалование и уважение...",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Время пришло.",
					function getResult( _event )
					{
						return "B"; //accept
					}

				},
				{
					Text = "Он не готов.",
					function getResult( _event )
					{
						return "D"; //Decline
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.retiredgladiator.getImagePath());
				this.Characters.push(_event.m.slave.getImagePath());
			}

		});
		this.m.Screens.push({ //accept
			ID = "B",
			Text = "[img]gfx/ui/events/event_15.png[/img]Хотя %slave% и радуется своей свободе, ему есть куда совершенствоваться, чтобы стать по-настоящему грозным бойцом, навыки и учения которого выходят за рамки современных гладиаторов. Как вы думаете, в какой области он должен специализироваться?",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Он укрепит свою решимость",
					function getResult( _event )
					{
						return "C1"; //glorious resolve
					}
				},
				{
					Text = "Он станет непоколебимым",
					function getResult( _event )
					{
						return "C2"; //glorious endurance
					}
				},
				{
					Text = "Он станет недосягаемым",
					function getResult( _event )
					{
						return "C3"; //glorious quickness
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.slave.getImagePath());
				local bg = this.new("scripts/skills/backgrounds/converted_gladiator_background");
				bg.m.IsNew = false;
//				local oldPerkTree = _event.m.slave.getBackground().m.CustomPerkTree;
				_event.m.slave.getSkills().removeByID("background.slave");
				_event.m.slave.getSkills().add(bg);
				// _event.m.slave.getBackground().m.RawDescription = "TO DO";
				_event.m.slave.getBackground().buildDescription(true);
//				_event.m.slave.getBackground().rebuildPerkTree(oldPerkTree);
//				_event.m.slave.resetPerks();


                local perks = _event.m.slave.m.PerkPointsSpent;
                local hasStudent = false;

                if (_event.m.slave.getLevel() >= 11 && _event.m.slave.getSkills().hasSkill("perk.student"))
                {
                    perks = perks - 1;
                    hasStudent = true;
                }

                _event.m.slave.m.PerkPoints += perks;
                _event.m.slave.m.PerkPointsSpent = hasStudent ? 1 : 0;
                _event.m.slave.getSkills().removeByType(this.Const.SkillType.Perk);

                if (!_event.m.slave.getSkills().hasSkill("perk.retglad_path"))
                {
                    _event.m.slave.getSkills().add(this.new("scripts/skills/perks/perk_retglad_path"));
                }
                if (!_event.m.slave.getSkills().hasSkill("perk.legend_throw_sand"))
                {
                    _event.m.slave.getSkills().add(this.new("scripts/skills/perks/perk_legend_throw_sand"));
                }
                if (hasStudent)
                {
                    _event.m.slave.getSkills().add(this.new("scripts/skills/perks/perk_student"));
                }

				_event.m.slave.improveMood(2.0, "Освободился от долгой жизни в рабстве");

				if (_event.m.slave.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.slave.getMoodState()],
						text = _event.m.slave.getName() + this.Const.MoodStateEvent[_event.m.slave.getMoodState()]
					});
				}

				_event.m.slave.getBaseProperties().MeleeSkill += 10;
				_event.m.slave.getBaseProperties().RangedSkill += 15;
				_event.m.slave.getBaseProperties().MeleeDefense += 7;
				_event.m.slave.getBaseProperties().RangedDefense += 8;
				_event.m.slave.getBaseProperties().Hitpoints += 15;
				_event.m.slave.getBaseProperties().Bravery += 20;
				_event.m.slave.getBaseProperties().Stamina += 12;
				_event.m.slave.getBaseProperties().Initiative += 25;
				_event.m.slave.getSkills().update();
				
				this.List.push({
					id = 16,
					icon = "ui/icons/health.png",
					text = _event.m.slave.getName() + " получает [color=" + this.Const.UI.Color.PositiveEventValue + "]+15[/color] к ОЗ"
				});				
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.slave.getName() + " получает [color=" + this.Const.UI.Color.PositiveEventValue + "]+20[/color] к решимости"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/fatigue.png",
					text = _event.m.slave.getName() + " получает [color=" + this.Const.UI.Color.PositiveEventValue + "]+12[/color] к максимальной выносливости"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.slave.getName() + " получает [color=" + this.Const.UI.Color.PositiveEventValue + "]+10[/color] к навыку ближнего боя"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.slave.getName() + " получает [color=" + this.Const.UI.Color.PositiveEventValue + "]+15[/color] к навыку дальнего боя"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_defense.png",
					text = _event.m.slave.getName() + " получает [color=" + this.Const.UI.Color.PositiveEventValue + "]+7[/color] к защите в ближнем бою"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/ranged_defense.png",
					text = _event.m.slave.getName() + " получает [color=" + this.Const.UI.Color.PositiveEventValue + "]+8[/color] к защите в дальнем бою"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/initiative.png",
					text = _event.m.slave.getName() + " получает [color=" + this.Const.UI.Color.PositiveEventValue + "]+25[/color] к инициативе"
				});
				this.List.push({
					id = 16,
					icon = "ui/icons/special.png",
					text = _event.m.slave.getName() + " теперь имеет жалование"
				});
			}

		});
		this.m.Screens.push({ //—
			ID = "C1", //trait pick
			Text = "[img]gfx/ui/events/event_155.png[/img]%slave% показал многообещающую храбрость в бою, он стоит высоко и твердо против любой угрозы и будет продолжать делать это ещё с большей силой!",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Славная решимость!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.slave.getImagePath());
				local glorious_resolve_trait = this.new("scripts/skills/traits/glorious_resolve_trait");
				_event.m.slave.getSkills().add(glorious_resolve_trait);
				_event.m.slave.getBaseProperties().Bravery += 8;
				this.List = [
					{
						id = 13,
						icon = glorious_resolve_trait.getIcon(),
						text = _event.m.slave.getName() + " получил славу и дополнительно [color=" + this.Const.UI.Color.PositiveEventValue + "]+8[/color] к решимости"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "C2", //trait pick
			Text = "[img]gfx/ui/events/event_155.png[/img]%slave% демонстрирует огромное упорство перед лицом непреодолимых трудностей, его тело покрыто шрамами, но он продолжает стоять на ногах не хуже самых выносливых, что когда-либо выходили на поле боя!",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Великолепная стойкость!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.slave.getImagePath());
				local glorious_endurance_trait = this.new("scripts/skills/traits/glorious_endurance_trait");
				_event.m.slave.getSkills().add(glorious_endurance_trait);
				_event.m.slave.getBaseProperties().Hitpoints += 4;
				_event.m.slave.getBaseProperties().MeleeDefense += 3;
				_event.m.slave.getBaseProperties().RangedDefense += 3;
				this.List = [
					{
						id = 13,
						icon = glorious_endurance_trait.getIcon(),
						text = _event.m.slave.getName() + " приобрел славу и дополнительно [color=" + this.Const.UI.Color.PositiveEventValue + "]+4[/color] к ОЗ, [color=" + this.Const.UI.Color.PositiveEventValue + "]+3[/color] к защите в ближнем и дальнем бою"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "C3", //trait pick
			Text = "[img]gfx/ui/events/event_155.png[/img]%slave% до сих пор демонстрировал высокую скорость и точность в каждом бою, часто нанося первый удар - снова и снова. И его скорость будет только выше.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Невероятная быстрота!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.slave.getImagePath());
				local glorious_quickness_trait = this.new("scripts/skills/traits/glorious_quickness_trait");
				_event.m.slave.getSkills().add(glorious_quickness_trait);
				_event.m.slave.getBaseProperties().Stamina += 10;
				_event.m.slave.getBaseProperties().Initiative += 15;
				this.List = [
					{
						id = 13,
						icon = quickness_quickness_trait.getIcon(),
						text = _event.m.slave.getName() + " приобрел славу и дополнительно [color=" + this.Const.UI.Color.PositiveEventValue + "]+10[/color] к выносливости и [color=" + this.Const.UI.Color.PositiveEventValue + "]+15[/color] к инициативе"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_05.png[/img]Вы чувствуете, что время ещё не пришло, %slave% еще многому должен научиться, и всегда будет другая возможность.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Скоро. Но не сейчас.",
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
		if (!this.World.Assets.getOrigin().getID() == "scenario.ret_gladiator")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 4)
		{
			return;
		}

		local retiredgladiator_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("perk.retglad_mentor"))
			// if (bro.getBackground().getID() == "background.retired_gladiator")
			{
				retiredgladiator_candidates.push(bro);
				break;
			}
		}

		if (retiredgladiator_candidates.len() == 0)
		{
			return;
		}

		local slave_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.slave") //Indebted, both normal, north and south.
			{
				slave_candidates.push(bro);
			}
		}

		if (slave_candidates.len() == 0)
		{
			return;
		}

		this.m.retiredgladiator = retiredgladiator_candidates[this.Math.rand(0, retiredgladiator_candidates.len() - 1)];
		this.m.slave = slave_candidates[this.Math.rand(0, slave_candidates.len() - 1)];
		this.m.Score = (retiredgladiator_candidates.len() + slave_candidates.len()) * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"retiredgladiator",
			this.m.retiredgladiator.getName()
		]);
		_vars.push([
			"slave",
			this.m.slave.getName()
		]);
	}

	function onClear()
	{
		this.m.retiredgladiator = null;
		this.m.slave = null;
	}

});

