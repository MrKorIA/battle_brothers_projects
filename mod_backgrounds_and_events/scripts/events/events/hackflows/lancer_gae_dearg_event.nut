this.lancer_gae_dearg_event <- this.inherit("scripts/events/event", {
	m = {
		Lancer = null,
		Camp = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_lancer_gae_dearg";
		this.m.Title = "В лагере...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img][M] Ещё одна остановка, ещё один вечер у костра. Вы уже почти забыли о странном разговоре у походного стола, как вдруг к вам снова направляется %lancer%. На этот раз ветеран не скрывает возбуждения: его обычно сдержанное лицо светится нетерпением, а шаг такой стремительный, что он едва не опрокидывает котелок, висящий над огнём.%SPEECH_ON%Капитан! Я нашёл её. Я наконец узнал, где она!%SPEECH_OFF%Не дожидаясь вашего вопроса, копейщик расправляет над пламенем потрёпанный пергамент - судя по всему, очень старую карту, испещрённую пометками, сделанными не одной рукой.%SPEECH_ON%С того самого дня я не прекращал поисков ни на миг. Перерыл половину свитков в монастырских архивах, которые встречались нам по пути, за звонкую монету выкупил старые байки у гробокопателей и допросил каждого скупщика древностей отсюда и до самого моря. И вот теперь мне наконец удалось восстановить картину той проклятой ночи, когда Гэ Дерг бесследно исчезла из хроник.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Рассказывай всё как есть.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Lancer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_82.png[/img][M] %lancer% тяжело дышит, будто идёт в гору, хотя сидит на поваленном бревне прямо напротив вас.%SPEECH_ON%Много лет назад караван, вёзший копьё на великий королевский турнир, был перебит до последнего человека. Говорили - дикие звери или разбойники. Враньё. Это были мертвецы, капитан. Восставшие из гниющих могил. Некромант узнал о сокровище и отправил за ним свою проклятую свору. Гэ Дерг всё это время покоится в лапах нежити...%SPEECH_OFF%Копейщик тычет потрёпанным пергаментом в сторону темнеющего горизонта.%SPEECH_ON%Смотрите сюда. Вот здесь, в \'%camp%\', до сих пор стоит их логово. Я готов биться об заклад: копьё лежит там, среди их трофеев. Прошу вас, капитан - мы должны вернуть его. Мой род поколениями охотился за этой реликвией, и в одиночку мне с такой ордой не совладать... но под вашим знаменем я готов спуститься хоть в самую преисподнюю.%SPEECH_OFF%Вы вглядываетесь в карту. Путь и впрямь неблизкий, а дорога ведёт в гиблые земли, где мертвецы давно хозяйничают безраздельно. Вы делаете пометку о расположении логова в походном журнале, давая себе слово однажды вырвать Гэ Дерг из мёртвых рук.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Мы отправимся туда при первой возможности.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Lancer.getImagePath());
				local item = this.new("scripts/items/weapons/hackflows/gae_dearg");
				_event.m.Camp.getLoot().add(item);
				_event.m.Camp.setDiscovered(true);
				this.World.uncoverFogOfWar(_event.m.Camp.getTile().Pos, 500.0);
				this.World.getCamera().moveTo(_event.m.Camp.get());
				this.List.push({
					id = 10,
					icon = "ui/icons/special.png",
					text = "Отмечено местоположение лагеря нежити: " + _event.m.Camp.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.hackflows_lancer" && bro.isAlive() && bro.getFlags().has("gae_dearg_search") && this.World.getTime().Days - bro.getFlags().get("gae_dearg_search") >= 30)
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		local campTypes = {
			"location.undead_mass_grave" : true,
			"location.undead_necromancers_lair" : true,
			"location.undead_vampire_coven" : true,
			"location.undead_crypt" : true,
			"location.undead_necropolis" : true,
			"location.undead_buried_castle" : true
		};
		local camps = [];

		foreach( factionType in [this.Const.FactionType.Undead, this.Const.FactionType.Zombies] )
		{
			local faction = this.World.FactionManager.getFactionOfType(factionType);

			if (faction == null)
			{
				continue;
			}

			foreach( settlement in faction.getSettlements() )
			{
				if (settlement.getTypeID() in campTypes)
				{
					camps.push(settlement);
				}
			}
		}

		if (camps.len() == 0)
		{
			return;
		}

		this.m.Lancer = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Camp = camps[this.Math.rand(0, camps.len() - 1)];
		this.m.Score = 100.0;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"lancer",
			this.m.Lancer.getName()
		]);
		_vars.push([
			"camp",
			this.m.Camp.getName()
		]);
	}

	function onClear()
	{
		this.m.Lancer = null;
		this.m.Camp = null;
	}

});
