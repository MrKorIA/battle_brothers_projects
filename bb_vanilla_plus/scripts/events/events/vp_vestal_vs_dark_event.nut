this.vp_vestal_vs_dark_event <- this.inherit("scripts/events/event", {
	m = {
		Vestals = [],
		Darks = [],
		Messenger = null,
		DarkIsPlayer = false,
		Majority = "none",
		VestalDead = null,
		DarkDead = null,
		Survivor = null
	},
	function create()
	{
		this.m.ID = "event.vp_vestal_vs_dark_event";
		this.m.Title = "На привале...";
		this.m.Cooldown = 10.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]%messenger% вбегает в вашу палатку, не успев отдышаться. За спиной у него — крики.%SPEECH_ON%Командир, вам лучше выйти. Если не пойдёте, будет хуже. %vestal% в ярости: сорвала с шеи оберег, порвала освящённые ленты и кричит, что не потерпит зла в этом отряде. Братья встали полукругом, но ближе не подходят — в её поднятой руке тлеет очищающее пламя, а взгляд у неё такой, что травяным отваром его не успокоишь.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Пойдём разбираться.",
					function getResult( _event )
					{
						if (_event.m.DarkIsPlayer)
						{
							return "B";
						}
						if (_event.m.Majority != "none")
						{
							return "C";
						}
						return "D";
					}

				},
				{
					Text = "Сами как-нибудь разберутся.",
					function getResult( _event )
					{
						if (_event.m.DarkIsPlayer)
						{
							return "E";
						}
						return "F";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Messenger.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_76.png[/img]Вы выходите к костру. %vestal% оборачивается раньше, чем вы успеваете открыть рот, и смотрит на вас — не как на командира.%SPEECH_ON%Я молчала, пока гниль держалась в тени. Молчала дольше, чем следовало, но моему терпению пришёл конец. Вы пустили её к себе, вы кормите её из своих рук. Неужели вы не видите, во что превращается ваш отряд? Раз не видите, значит, и вы часть этого зла. Просто зло, которое ещё не поняло, кем стало.%SPEECH_OFF%Она опускает руку, и пламя в её ладони гаснет. Без единого слова она уходит в ночь — прямо, не оглядываясь, туда, где кончается свет костров. Братья стоят молча. Кто-то пинает угли. Никто не смеет поднять взгляд на вас.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Пусть идёт.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Vestals[0].getImagePath());
				_event.leaveCompany(_event.m.Vestals[0], "Покинула отряд, назвав командира злом");
				this.List.push({
					id = 10,
					icon = "ui/icons/kills.png",
					text = _event.m.Vestals[0].getName() + " покидает отряд"
				});
				_event.dismoralAll("Потрясён открытым разрывом в отряде", 100, 1.0);
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_39.png[/img]Вы опоздали — наверное, всего на пару минут, но и этого хватило. У потухшего костра два трупа: %darkdeadname% лежит лицом вниз, а рядом, вскинув руки, словно до последнего что-то отгоняя, — %vestaldeadname%. Пахнет палёным мясом и грозой. Единственный оставшийся в живых, %survivor%, сидит на бревне и не спеша вычищает нож о траву. Он сплёвывает.%SPEECH_ON%Совсем спятила. Мой единомышленник кинулся на неё с уговорами на устах, а она прожгла ему грудь до костей, прежде чем я успел шаг сделать. Что мне оставалось? Пришлось взяться за нож. Сама виновата: никто её сюда не звал.%SPEECH_OFF%Он молча смотрит на вас, на трупы и уходит спать, будто всё уже сказано.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Похороним мёртвых.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Survivor.getImagePath());
				_event.killBrother(_event.m.VestalDead, _event.m.DarkDead.getName());
				_event.killBrother(_event.m.DarkDead, _event.m.VestalDead.getName());
				_event.dismoralAll("Потрясён кровавой развязкой свары", 100, 1.0);
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_39.png[/img]Картина перед вами — как алтарь, с которого содрали позолоту. %vestal% стоит на коленях посреди разлитой похлёбки и опрокинутого котелка, и вокруг её согнутых пальцев дрожит свет, от которого слепит глаза. Напротив, спиной к мёртвому костру, невозмутимо устраивается поудобнее %dark% — и эта небрежность бесит весталку сильнее любых криков. Вокруг уже два лагеря: кто-то встал на сторону света, а кто-то на сторону тьмы, и многие держат руки на эфесах. Дело уже не в молитвах: это два противоположных мировозрения, которые не могут делить один костёр.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Слушай мой приказ - всем разойтись!",
					function getResult( _event )
					{
						return "F";
					}

				},
				{
					Text = "%vestal% заслуживает поддержки. Зло не должно остаться без ответа.",
					function getResult( _event )
					{
						return "G";
					}

				},
				{
					Text = "%dark% не виноват в том, чем он является. Я на его стороне.",
					function getResult( _event )
					{
						return "H";
					}

				},
				{
					Text = "Вот тысяча крон. Вспомните, зачем вы здесь.",
					function getResult( _event )
					{
						return "I";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Vestals[0].getImagePath());
				this.Characters.push(_event.m.Darks[0].getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_58.png[/img]Вы не идёте. Ссора за костром затихает сама собой — слишком быстро, и от этой поспешной тишины у вас ноет затылок. Утром %vestal% собрана и спокойна: вещи уложены, посох в руке. Она подходит к вам и останавливается напротив.%SPEECH_ON%Вы выбрали тьму. Значит, нам не по пути. Простите.%SPEECH_OFF%Она уходит по дороге, что ведёт прочь от лагеря. Никто не пытается её удержать. Впервые за долгое время вам нечего сказать отряду.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Пусть идёт.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Vestals[0].getImagePath());
				_event.leaveCompany(_event.m.Vestals[0], "Ушла из отряда");
				this.List.push({
					id = 10,
					icon = "ui/icons/kills.png",
					text = _event.m.Vestals[0].getName() + " покидает отряд"
				});
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_06.png[/img]Ваш голос тонет в криках — а может, вы просто кричите недостаточно громко. Всё начинается так: сначала только слова, потом толчок, потом кто-то слишком быстро тянется к ножу. Дальше всё распадается на куски: вспышка очищающего пламени, ухмылка сквозь зубы, рука, вонзающая нож в чужой бок раз за разом... Когда всё кончается, над костром стоит тишина, и пахнет палёным. Остался один труп. Остальные возятся с раненым — живым, но потребуется много времени что бы вернуться в строй.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Немного земли, немного молитвы — и вперёд.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local dead = _event.m.Vestals[this.Math.rand(0, _event.m.Vestals.len() - 1)];
				if (this.Math.rand(1, 100) <= 50 && _event.m.Darks.len() > 0)
				{
					dead = _event.m.Darks[this.Math.rand(0, _event.m.Darks.len() - 1)];
				}
				local killerPool = dead.getBackground().getID() == "vp.vestal.background" ? _event.m.Darks : _event.m.Vestals;
				local killer = killerPool[this.Math.rand(0, killerPool.len() - 1)];
				_event.killBrother(dead, killer.getName());

				local woundedPool = dead.getBackground().getID() == "vp.vestal.background" ? _event.m.Vestals : _event.m.Darks;
				if (woundedPool.len() > 0)
				{
					local wounded = woundedPool[this.Math.rand(0, woundedPool.len() - 1)];
					local injury = wounded.addInjury(this.Const.Injury.Brawl);
					this.List.push({
						id = 10,
						icon = injury.getIcon(),
						text = wounded.getName() + " получает травму " + injury.getNameOnly()
					});
					this.Characters.push(wounded.getImagePath());
				}
				_event.dismoralAll("Потрясён смертью соратника в сваре", 100, 1.0);
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_133.png[/img]Вы встаёте рядом с весталкой, и ваши люди выстраиваются следом — не все, но многие. %dark% смотрит на вас долго, с неожиданным уважением, потом разводит руками.%SPEECH_ON%Значит, так. Я думал, здесь терпят иные пути. Оказывается — нет.%SPEECH_OFF%Он закидывает сумку на плечо и уходит в темноту. Его не провожают взглядом — все смотрят на весталку. %vestal% медленно выпрямляется, гасит пламя в ладони и кланяется вам так низко, как никому прежде.%SPEECH_ON%Вы встали на сторону света. Я этого не забуду.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Всё познаётся в сравнении.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Vestals[0].getImagePath());
				_event.leaveCompany(_event.m.Darks[0], "Изгнан из отряда за тёмную сущность");
				this.List.push({
					id = 10,
					icon = "ui/icons/kills.png",
					text = _event.m.Darks[0].getName() + " покидает отряд"
				});
				_event.m.Vestals[0].improveMood(2.0, "Командир встал на её сторону против тьмы");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Vestals[0].getMoodState()],
					text = _event.m.Vestals[0].getName() + this.Const.MoodStateEvent[_event.m.Vestals[0].getMoodState()]
				});
				_event.dismoralAll("Сомневается в изгнании соратника", 25, 1.0);
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_174.png[/img]%dark% остаётся в стороне, и вы встаёте рядом с ним. Несколько человек, видимо, видевших его в бою, перебегают к вам. %vestal% смотрит на вас так, как смотрят на потерянного человека.%SPEECH_ON%Значит, и вы видите в нём только оружие. Я молилась, чтобы ошибиться.%SPEECH_OFF%Она не гасит пламя. Оно гаснет само, когда она поворачивается от вас. Её уход тих — слишком тих для человека, который минуту назад пылал яростью. %dark% провожает её взглядом и пожимает плечами.%SPEECH_ON%Она бы меня не поняла. Никогда. Но ты — понял. Это дорогого стоит.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Всё познаётся в сравнении.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Darks[0].getImagePath());
				_event.leaveCompany(_event.m.Vestals[0], "Ушла из отряда, когда командир защитил тьму");
				this.List.push({
					id = 10,
					icon = "ui/icons/kills.png",
					text = _event.m.Vestals[0].getName() + " покидает отряд"
				});
				_event.m.Darks[0].improveMood(2.0, "Командир защитил его от весталки");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Darks[0].getMoodState()],
					text = _event.m.Darks[0].getName() + this.Const.MoodStateEvent[_event.m.Darks[0].getMoodState()]
				});
				_event.dismoralAll("Сомневается в защите тьмы", 25, 1.0);
			}

		});
		this.m.Screens.push({
			ID = "I",
			Text = "[img]gfx/ui/events/event_12.png[/img]Вы достаёте мешочек с кронами и звонко бросаете его на камень. Спор замирает — звон золота умеет унимать споры лучше проповедей. %dark% первым подходит, поднимает мешок и, ухмыльнувшись весталке через плечо, начинает пересчитывать.%SPEECH_ON%Разумное решение. Мы все здесь ради...%SPEECH_OFF%Он не договаривает. Очищающее пламя проходит сквозь него раньше, чем он успевает закончить — ослепительно, беззвучно и совершенно безжалостно. Мешок падает и обгоревшие монеты рассыпаются. %vestal% стоит над углями, где ещё секунду назад был человек, и смотрит на вас.%SPEECH_ON%Я иду за вами не за деньги. Как вы могли подумать, что меня можно купить?%SPEECH_OFF%Она разворачивается и уходит, не оглядываясь, пока над углями ещё стелется дым.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Этого следовало ожидать.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Vestals[0].getImagePath());
				_event.killBrother(_event.m.Darks[0], _event.m.Vestals[0].getName());
				_event.leaveCompany(_event.m.Vestals[0], "Убила одержимого и ушла из отряда");
				this.List.push({
					id = 10,
					icon = "ui/icons/kills.png",
					text = _event.m.Vestals[0].getName() + " покидает отряд"
				});
				this.World.Assets.addMoney(-1000);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы теряете [color=" + this.Const.UI.Color.NegativeEventValue + "]1000[/color] крон"
				});
				_event.dismoralAll("Потрясён смертью соратника", 100, 1.0);
			}

		});
	}

	function killBrother( _bro, _killedBy )
	{
		local fallen = {
			Name = _bro.getName(),
			Time = this.World.getTime().Days,
			TimeWithCompany = this.Math.max(1, _bro.getDaysWithCompany()),
			Kills = _bro.getLifetimeStats().Kills,
			Battles = _bro.getLifetimeStats().Battles,
			KilledBy = "Убит в сваре с " + _killedBy,
			Expendable = false
		};
		this.World.Statistics.addFallen(fallen);
		_bro.getItems().transferToStash(this.World.Assets.getStash());
		_bro.getSkills().onDeath(this.Const.FatalityType.None);
		this.World.getPlayerRoster().remove(_bro);
	}

	function leaveCompany( _bro, _reason )
	{
		local fallen = {
			Name = _bro.getName(),
			Time = this.World.getTime().Days,
			TimeWithCompany = this.Math.max(1, _bro.getDaysWithCompany()),
			Kills = _bro.getLifetimeStats().Kills,
			Battles = _bro.getLifetimeStats().Battles,
			KilledBy = _reason,
			Expendable = false
		};
		this.World.Statistics.addFallen(fallen);
		_bro.getItems().transferToStash(this.World.Assets.getStash());
		_bro.getSkills().onDeath(this.Const.FatalityType.None);
		this.World.getPlayerRoster().remove(_bro);
	}

	function dismoralAll( _reason, _chance, _amount )
	{
		local brothers = this.World.getPlayerRoster().getAll();

		foreach( bro in brothers )
		{
			if (this.Math.rand(1, 100) > _chance)
			{
				continue;
			}

			bro.worsenMood(_amount, _reason);
			this.List.push({
				id = 10,
				icon = this.Const.MoodStateIcon[bro.getMoodState()],
				text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
			});
		}
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getMoney() < 1000)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local vestals = [];
		local darks = [];
		local others = [];
		local hasNecroMod = ::mods_getRegisteredMod("mod_necro") != null;

		foreach( bro in brothers )
		{
			local id = bro.getBackground().getID();

			if (id == "vp.vestal.background")
			{
				vestals.push(bro);
			}
			else if (id == "vp.demon.background" || hasNecroMod && id == "background.necro")
			{
				darks.push(bro);
			}
			else
			{
				others.push(bro);
			}
		}

		if (vestals.len() == 0 || darks.len() == 0 || others.len() == 0)
		{
			return;
		}

		this.m.Vestals = vestals;
		this.m.Darks = darks;
		this.m.Messenger = others[this.Math.rand(0, others.len() - 1)];

		foreach( bro in darks )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				this.m.DarkIsPlayer = true;
				break;
			}
		}

		if (vestals.len() >= 2 && darks.len() == 1)
		{
			this.m.Majority = "light";
		}
		else if (darks.len() >= 2 && vestals.len() == 1)
		{
			this.m.Majority = "dark";
		}
		else
		{
			this.m.Majority = "none";
		}

		// пререшаем исход сцены C заранее: один погибший с каждой стороны + выживший большинства
		this.m.VestalDead = vestals[this.Math.rand(0, vestals.len() - 1)];
		this.m.DarkDead = darks[this.Math.rand(0, darks.len() - 1)];

		if (this.m.Majority == "light")
		{
			local pool = [];

			foreach( bro in vestals )
			{
				if (bro.getID() != this.m.VestalDead.getID())
				{
					pool.push(bro);
				}
			}

			this.m.Survivor = pool.len() > 0 ? pool[this.Math.rand(0, pool.len() - 1)] : this.m.VestalDead;
		}
		else if (this.m.Majority == "dark")
		{
			local pool = [];

			foreach( bro in darks )
			{
				if (bro.getID() != this.m.DarkDead.getID())
				{
					pool.push(bro);
				}
			}

			this.m.Survivor = pool.len() > 0 ? pool[this.Math.rand(0, pool.len() - 1)] : this.m.DarkDead;
		}
		else
		{
			this.m.Survivor = vestals[0];
		}

		this.m.Score = 500 + (vestals.len() + darks.len()) * 100;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"vestal",
			this.m.Vestals[0].getName()
		]);
		_vars.push([
			"dark",
			this.m.Darks[0].getName()
		]);
		_vars.push([
			"messenger",
			this.m.Messenger.getName()
		]);
		_vars.push([
			"vestaldeadname",
			this.m.VestalDead != null ? this.m.VestalDead.getName() : ""
		]);
		_vars.push([
			"darkdeadname",
			this.m.DarkDead != null ? this.m.DarkDead.getName() : ""
		]);
		_vars.push([
			"survivor",
			this.m.Survivor != null ? this.m.Survivor.getName() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Vestals = [];
		this.m.Darks = [];
		this.m.Messenger = null;
		this.m.DarkIsPlayer = false;
		this.m.Majority = "none";
		this.m.VestalDead = null;
		this.m.DarkDead = null;
		this.m.Survivor = null;
	}

});
