this.legend_qiyan_dances_encounter <- this.inherit("scripts/events/event", {
	m = {
		Qiyan = null
	},
	function create()
	{
		this.m.ID = "event.legend_qiyan_dances";
		this.m.Title = "В лагере...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_39.png[/img]Вы сидите у лагерного костра вместе с остальными наёмниками отряда. Ваши мысли лениво плетутся в такт лижущим небо языкам пламени, пока вы отрешённо смотрите на груду пылающих поленьев и тлеющего хвороста. Почти весь отряд точно так же заворожена этим зрелищем: тихая походная меланхолия увлекла мужчин в плен воспоминаний о тяготах последних дней. Внезапно набежавшая тень резко вырывает вас из оцепенения. Подняв глаза, вы видите циянь. %qiyan% медленно кружит у огня, скользя стопами по гравию между замершими бойцами и костровищем. Будто бы невзначай, внимание большинства мужчин переключается на южанку. Плавными, но на удивление чёткими движениями она расчищает себе круг у костра, аккуратно отбрасывая носком обуви мелкие камни и заставляя наёмников убрать вытянутые ноги. Заинтригованные её поведением, брутальные рубаки охотно подчиняются, отодвигаясь назад и освобождая место для таинственной танцовщицы.\n\nКогда её импровизированная сцена освободилась от мешающих элементов, а вокруг собралась максимально благодарная аудитория, циянь начинает своё представление. Она заводит низкий, гортанный напев, переходящий в неторопливый ритмичный танец. Девушка методично обходит костёр по кругу. Длинные тени от её силуэта скользят по лицам наёмников, уползая во тьму тракта. Вскоре её речитатив превращается в нежную, протяжную песню. Вы не понимаете ни единого слова из этого южного наречия, но этот мотив пробуждает в груди щемящее чувство утраты и глубокой тоски. Спустя пару минут вам начинает казаться, что выступление подходит к концу, но внезапный всплеск неистовой энергии разрушает эти иллюзии: её неспешное кружение взрывается движениями, которые можно описать лишь как яростные, грациозные прыжки. Она раз за разом взмывает прямо над бушующим костром. На лицах наёмников застывает благоговейный трепет: они одновременно поражены музыкальным тактом её движений и всерьёз напуганы тем, что один неверный шаг сбросит её прямо на раскалённые угли. Словно играя на страхах своей публики, %qiyan% подходит к самому краю пекла. Она кружится и извивается в настолько элегантных, безумных пируэтах, что кажется единым целым с бушующим пламенем, отбрасывая на притихшую роту хаотичные тени. Мужчины сидят затаив дыхание, полностью поглощённые этим опасным и пугающе прекрасным зрелищем.\n\nИ как раз в тот миг, когда вам начинает казаться, что танцовщица окончательно превратилась в тот самый огонь, с которым заигрывала, резкое движение её руки взметает облако пыли. Земля накрывает угли, утихомиривая бушующую бурю. Этот единственный хлёсткий жест ознаменовал собой одновременный финал и её танца, и главенства пламени над ночной темнотой. Сделав скромный поклон и одарив отряд обворожительной улыбкой, блистательная артистка благодарит мужчин за компанию и желает всем доброй ночи. Потрескивание укрощённого костра идеально подчёркивает общее настроение: большинство наёмников сидят с разинутыми ртами, потрясённые увиденным. Для кого-то это становится отличным знаком, чтобы наконец отправиться спать, другие же остаются у костра, погружённые в новые, глубокие думы. А рядом с ними, тихо пощёлкивая искрами, костёр начинает вновь разгораться."
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Превосходно.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Qiyan.getImagePath());

				local v = this.Math.rand(1, 2);
                _event.m.Qiyan.getBaseProperties().MeleeDefense += v;
                this.List.push({
                    id = 16,
                    icon = "ui/icons/melee_defense.png",
                    text = _event.m.Qiyan.getName() + " получает [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + v + "[/color] к защите в ближнем бою"
                });
                v = 2;
                _event.m.Qiyan.getBaseProperties().Bravery += v;
                this.List.push({
                    id = 16,
                    icon = "ui/icons/bravery.png",
                    text = _event.m.Qiyan.getName() + " получает [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + v + "[/color] к решительности"
                });
                v = this.Math.rand(2, 4);
                _event.m.Qiyan.getBaseProperties().Initiative += v;
                this.List.push({
                    id = 16,
                    icon = "ui/icons/шnitiative.png",
                    text = _event.m.Qiyan.getName() + " получает [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + v + "[/color] к инициативе"
                });
                _event.m.Qiyan.improveMood(2.0, "Довольна произведённым впечатлением");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Qiyan.getMoodState()],
					text = _event.m.Qiyan.getName() + this.Const.MoodStateEvent[_event.m.Qiyan.getMoodState()]
				});

				foreach (bro in ::World.getPlayerRoster().getAll()) {
					if (_event.m.Qiyan.getID() == bro.getID())
						continue;
					if (::Math.rand(1, 100) <= 50) {
                        bro.improveMood(1.0, "Поражен завораживающим выступлением Циянь!");
                        this.List.push({
                            id = 10,
                            icon = this.Const.MoodStateIcon[bro.getMoodState()],
                            text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
                        });
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 4 && bro.getBackground().getID() == "background.legend_qiyan")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Qiyan = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 5.0 * candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push(["qiyan", this.m.Qiyan.getName()]);
	}

	function onClear()
	{
		this.m.Qiyan = null;
	}

});

