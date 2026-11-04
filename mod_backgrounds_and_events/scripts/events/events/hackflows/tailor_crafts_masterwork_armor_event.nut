this.tailor_crafts_masterwork_armor_event <- this.inherit("scripts/events/event", {
	m = {
		Tailor = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_tailor_crafts_masterwork_armor";
		this.m.Title = "По пути...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_41.png[/img][M] Отряд находится в пути, когда %tailor% подходит к вам. Портной широко улыбается и говорит.%SPEECH_ON%Приветствую, капитан! Я тут приметил, что мы таскаем в обозе шкуры лютоволков ещё с тех самых пор, как знатно потрепали тех клыкастых тварей. Как по-вашему, идея пустить шкуры убитых тварей на защиту от клинков следующих невезучих ублюдков, которых мы встретим в бою - это безумие или здравый расчёт? У меня как раз припрятаны базовые заготовки для доспехов. Если выделите мне из казны немного крон на сопутствующие расходы и, само собой, отдадите шкуры, я смогу сшить для отряда чертовски хороший кожаный доспех!%SPEECH_OFF%Ремесленник смотрит на вас с азартным блеском в глазах. Вы понимаете: если отказать ему прямо сейчас, он вряд ли когда-нибудь снова поднимет эту тему. А потому вы решаете хорошенько взвесить все за и против, прежде чем давать портному возможность заняться этим проектом.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Шкуры твои, и вот монеты. Приступай к работе.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Забудь о портняжном деле и сосредоточься на том, чтобы быть наемником.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Tailor.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_41.png[/img][M] В самом деле, что плохого в том, чтобы %tailor% попробовал свои силы в старом ремесле? Вы всё равно не планировали пускать эти волчьи шкуры в ход в ближайшее время. Более того, они лишь зря пылились в обозе, занимая порядочно свободного места, которое пригодилось бы для хранения более ценной добычи и припасов. Вы киваете мастеру, и тот на радостях резво убегает к обозным повозкам.\n\nСпустя некоторое время ремесленник возвращается и с гордостью демонстрирует вам свой шедевр. Доспех сшит на удивление искусно и ощущается исключительно лёгким, учитывая его завидную прочность. Волчья голова грозно накинута на плечи в качестве накидки - поистине жуткое, гротескное зрелище, которое непременно вселит ужас в сердца врагов отряда \'%companyname%\'. Вы крепко хлопаете умельца по плечу и хвалите его за великолепную работу!",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Будь я проклят, но это действительно отличный образец лёгкой брони.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Tailor.getImagePath());
				local stash = this.World.Assets.getStash().getItems();
				local numPelts = 0;

				foreach( i, item in stash )
				{
					if (item != null && item.getID() == "misc.werewolf_pelt")
					{
						numPelts = ++numPelts;
						numPelts = numPelts;
						stash[i] = null;
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "Вы теряете " + item.getName()
						});

						if (numPelts >= 2)
						{
							break;
						}
					}
				}

				this.World.Assets.addMoney(-500);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы тратите [color=" + this.Const.UI.Color.NegativeEventValue + "]500[/color] крон"
				});
				local item = this.new("scripts/items/armor/named/black_leather_armor");
				item.m.Name = "Доспех высшего качества: мастер " + _event.m.Tailor.getNameOnly();
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Вы получаете " + item.getName()
				});
				_event.m.Tailor.improveMood(2.0, "Создал лёгкий доспех исключительного качества");

				if (_event.m.Tailor.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Tailor.getMoodState()],
						text = _event.m.Tailor.getName() + this.Const.MoodStateEvent[_event.m.Tailor.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.Const.DLC.Unhold)
		{
			return;
		}

		if (this.World.Assets.getMoney() < 5000)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 8 && bro.getBackground().getID() == "background.tailor")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();
		local numPelts = 0;

		foreach( item in stash )
		{
			if (item != null && item.getID() == "misc.werewolf_pelt")
			{
				numPelts = ++numPelts;
				numPelts = numPelts;

				if (numPelts >= 2)
				{
					break;
				}
			}
		}

		if (numPelts < 2)
		{
			return;
		}

		this.m.Tailor = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 100;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"tailor",
			this.m.Tailor.getName()
		]);
	}

	function onClear()
	{
		this.m.Tailor = null;
	}

});

