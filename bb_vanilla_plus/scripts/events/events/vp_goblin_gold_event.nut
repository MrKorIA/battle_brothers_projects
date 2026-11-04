this.vp_goblin_gold_event <- this.inherit("scripts/events/event", {
	m = {
		Goblin = null
	},
	function create()
	{
		this.m.ID = "event.vp_goblin_gold_event";
		this.m.Title = "На привале...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]Прошло достаточно времени. Гоблин %goblin_name% всё ещё с вами — чистит обувь, ворует еду, путается под ногами и иногда даже бывает полезен. Но обещанное сокровище так и не появилось. Вы решаете припереть его к стенке. Вы застаёте %goblin_name%а за перебиранием ваших вещей. Он вздрагивает, роняет чужой кошелёк и пытается изобразить невинность.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Хватит. Пришло время поговорить.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Goblin.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_06.png[/img]%SPEECH_ON%Слушай сюда, зелёный, — рычит один из наёмников, хватая гоблина за шкирку. — Где сокровища?%SPEECH_OFF%%goblin_name% болтается в воздухе, перебирая ногами, и пытается улыбнуться своей самой подобострастной улыбкой. %SPEECH_ON%Не было никакого золота, — выдавливает он. Быстро, как отрезает. Смотрит вам прямо в глаза — впервые за всё время. — Никакого. Ни серебра. Ни амулетов. Ни пещеры за болотами. Всё враньё. От начала до конца.%SPEECH_OFF%В лагере воцаряется тишина.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Братья уже тянутся к оружию.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Goblin.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_48.png[/img]Гоблин сглатывает, но продолжает, будто решил выговориться раз и навсегда. %SPEECH_ON%Я врал. Конечно врал. А что мне оставалось? Вы только что перебили всех моих сородичей. Вы бы меня убили, если бы я не сказал про сокровище. Я хотел жить. Очень хотел. И я знал, что люди... люди падки на золото. Вы все падки на золото. Даже те, кто говорит, что нет.%SPEECH_OFF%Он замолкает и сжимается в комок, готовый к удару. Глаза закрыты.%SPEECH_ON%Можете убить, — шепчет он. Но это не хорошо. Я теперь даже к людям привык.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ты врал с первого дня. Умри.",
					function getResult( _event )
					{
                        return "D";
					}
				},
				{
					Text = "Ты нас обманывал всё это время? Пошёл вон из отряда.",
					function getResult( _event )
					{
                        return "F";
					}
				},
				{
					Text = "Ха-ха. А чего мы хотели? Но ты приносишь пользу, оставайся в отряде.",
					function getResult( _event )
					{
                        local brothers = this.World.getPlayerRoster().getAll();

                        foreach( bro in brothers )
                        {
                            if (this.Math.rand(1, 100) <= 66)
                            {
                                bro.worsenMood(1.0, "Не наказали гоблина за обман");
                            }
                        }
						return 0;
					}
				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Goblin.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

                foreach( bro in brothers )
                {
                    if (bro.getBackground().getID() == "vp.goblin.background")
                    {
                        bro.improveMood(1.0, "Удалось остаться живым");
                        continue;
                    }
                    if (this.Math.rand(1, 100) <= 66)
                    {
                        bro.worsenMood(1.0, "Гоблин-обманщик");
                    }
                }
			}
		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_02.png[/img]Вы киваете. Двум наёмникам не нужно объяснять дважды. Они хватают %goblin_name%а за шкирку и тощие ноги, поднимают над землёй, будто мешок с гнилой репой. Гоблин визжит, но не сопротивляется. Слишком поздно. Слишком поздно для всего. Его волокут к обозу. Кто-то уже скидывает верёвку с ближайшего ящика. %goblin_name% вдруг перестаёт кричать и затихает — так затихает крыса, понявшая, что капкан захлопнулся. %SPEECH_ON%Гоблин есть гоблин, — сплёвывает седой ветеран, набрасывая петлю на тощую шею. — Хоть год корми, хоть два — всё равно укусит, как только отвернёшься. И врать не перестанет. Это у них в крови.%SPEECH_OFF%Верёвка натягивается. %goblin_name% смотрит на вас снизу вверх — и в его жёлтых глазах нет ничего. Ни страха. Ни ненависти. Только усталое понимание: он всегда знал, что это кончится именно так. %SPEECH_ON%Я... я правда привык... — хрипит он, прежде чем верёвка дёргается, обрывая слова. Тело дёргается в воздухе, болтается над телегой, как чучело на огороде. Кто-то смеётся. Кто-то прячет глаза. Большинство молча смотрит в костёр. Вы отворачиваетесь. В конце концов, он обманывал вас с первой минуты. И всё равно что-то в этой сцене заставляет вас чувствовать себя не героем, а палачом.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Гоблин есть гоблин. Но сегодня вы — не лучше.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			    this.Characters.push(_event.m.Goblin.getImagePath());
                local brothers = this.World.getPlayerRoster().getAll();
                foreach( bro in brothers )
                {
                    if (this.Math.rand(1, 100) <= 20)
                    {
                        bro.worsenMood(1.0, "Жалко гоблинца");
                    }
                }
                local dead = _event.m.Goblin;
                local fallen = {
                    Name = dead.getName(),
                    Time = this.World.getTime().Days,
                    TimeWithCompany = this.Math.max(1, dead.getDaysWithCompany()),
                    Kills = dead.getLifetimeStats().Kills,
                    Battles = dead.getLifetimeStats().Battles,
                    KilledBy = "Повешен",
                    Expendable = false
                };
                this.World.Statistics.addFallen(fallen);
                this.List.push({
                    id = 13,
                    icon = "ui/icons/kills.png",
                    text = _event.m.Goblin.getName() + " повешен"
                });
                _event.m.Goblin.getItems().transferToStash(this.World.Assets.getStash());
                _event.m.Goblin.getSkills().onDeath(this.Const.FatalityType.None);
                this.World.getPlayerRoster().remove(_event.m.Goblin);
			}
		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_33.png[/img]Вы смотрите на %goblin_name%а долгим, тяжёлым взглядом. Он ёжится, будто от удара. Он уже понял — до того, как вы открыли рот. %SPEECH_ON%Собирай свои тряпки, зелёный, — говорите вы тихо, но так, что слышат все. — Ты выжил только потому, что пообещал золото. Золота нет. Значит, и тебе здесь не место.%SPEECH_OFF%Гоблин открывает рот, хочет что-то сказать — но не находит слов. Он просто кивает. Один раз. Медленно. Кто-то из наёмников пинает его под зад, выталкивая из лагеря. %goblin_name% спотыкается, падает в грязь, быстро встаёт и оглядывается. Его лицо — лицо существа, которое потеряло последний дом. Даже если этот дом вонял потом, кровью и немытыми сапогами. %SPEECH_ON%Вы... вы правда не... не убьёте? — шепчет он, не веря своим ушам.%SPEECH_OFF%Вы молчите. Один из наёмников бросает ему за спину рваный мешок с жалким скарбом. %SPEECH_ON%Вали, пока я не передумал, — рычит другой, сжимая рукоять топора.%SPEECH_OFF%%goblin_name% больше не ждёт. Он бежит. Сначала быстро, потом медленнее. Останавливается на краю света от костра, оборачивается. Его силуэт — маленькая горбатая тень на фоне звёзд. Он что-то кричит. Ветер уносит слова, но вы почти слышите: «Спасибо». Или «Проклятье». Или что-то среднее. А может, вам просто кажется. Гоблин исчезает в темноте. Кто-то вздыхает с облегчением. Кто-то пожимает плечами. Кто-то бормочет проклятия. Вы смотрите на пустоту, где только что стоял %goblin_name%, и вдруг понимаете, что лагерь стал тише. Не лучше. Тише.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Зато теперь в лагере пахнуть станет лучше.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			    this.Characters.push(_event.m.Goblin.getImagePath());

                this.List.push({
                    id = 13,
                    icon = "ui/icons/initiative.png",
                    text = _event.m.Goblin.getName() + " выгнан с позором"
                });
                _event.m.Goblin.getItems().transferToStash(this.World.Assets.getStash());
                _event.m.Goblin.getSkills().onDeath(this.Const.FatalityType.None);
                this.World.getPlayerRoster().remove(_event.m.Goblin);
			}
		});
	}

	function onUpdateScore()
	{
        local brothers = this.World.getPlayerRoster().getAll();
        local isFind = false;

        foreach( bro in brothers )
        {
            if (bro.getBackground().getID() == "vp.goblin.background")
            {
                if (this.World.getTime().Days > (bro.getDaysWithCompany() + 50))
                {
                    this.m.Goblin = bro;
                    isFind = true;
		            this.m.Score = 250000;
                }
                else
                {
                    return;
                }
            }
        }
        if (!isFind) return;
    }

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"goblin_name",
			this.m.Goblin.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Goblin = null;
	}

});

