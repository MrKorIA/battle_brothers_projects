// Аутро кризиса «Нашествие Великой Орды»: всплывает на дороге после победы
// (новость 'crisis_horde_end' добавляет хук faction_manager).
// Образец — data_014/scripts/events/events/crisis/greenskins_outro_event.nut.
this.horde_outro_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.crisis.horde_outro";
		this.m.Title = "По дороге...";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_78.png[/img]На тракте вы встречаете патруль солдат дома %randomnoblehouse%. Завидев знамя вашего отряда, бойцы приветствуют вас громкими криками — впервые за долгие месяцы в их голосах не слышно привычного страха. К вам выходит молодой десятник, на ходу стягивая латную перчатку для крепкого рукопожатия.%SPEECH_ON%Так это вы и есть — тот самый отряд, что переломил хребет Великой Орде! Нам только что гонец донёс прекрасную весть: чжурчжэни спешно сняли лагеря и откатились обратно в глубь степей, кочевники Железной Орды раскололись и перегрызлись за остатки добычи, а их пороховые обозы догорают на восточных трактах. Война окончена!%SPEECH_OFF%Он хлопает вас по наплечнику, словно старого боевого товарища.%SPEECH_ON%Благородные лорды, само собой, теперь раструбят по всем городам, будто эта победа — целиком их заслуга. Но мы-то, кто месил грязь в поле, прекрасно знаем, кто на самом деле выгрыз её зубами. Будь моя воля — велел бы отлить вам памятник из бронзы на главной площади. А пока — уступите-ка дорогу, герои: теперь разгребать всю эту падаль и наводить порядок на пепелищах придётся нам, простым солдатам!%SPEECH_OFF%",
			Image = "",
			Characters = [],
			Options = [
				{
					Text = "Пропустим героев королевства.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Поставь его на место, %dude%.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_78.png[/img]Вы молча киваете солдатам и отводите отряд на обочину, уступая тракт. Лейтенант бодро ускоряет шаг, уводя своих людей на восток, а %dude% провожает его взглядом, полным нескрываемого презрения.%SPEECH_ON%Памятник, значит. Почему не из золота.%SPEECH_OFF%Пожалуй, так оно даже лучше: каменного истукана на хлеб не намажешь, а чеканные кроны не крошатся от ветра и дождя. Вы бросаете взгляд на восток, где над бескрайней степью больше не клубится чёрный дым пожарищ — лишь стелется привычный, мирный утренний туман. Этот жестокий мир снова уцелел. Великая Орда разбита...\n\nЗадумавшись, вы спрашиваете себя, не пора ли наконец оставить кровавое ремесло наёмника. С другой стороны, если сейчас оставить пост, какие приключения вы пропустите?\r\n\r\n%OOC%Вы победили! \'Battle Brothers\' разрабатывалась как игра, к которой можно возвращаться снова и снова. Обычно прохождения длятся, пока вы не переживёте один или два кризиса. Следующая кампания позволит получить иной опыт в новом мире.\r\n\r\nВпрочем, вы вправе продолжать текущее прохождение столь долго, сколько захотите. Просто имейте в виду, что кампания не предназначена для бесконечной игры, и рано или поздно у вас не останется вызовов, которые можно было бы превзойти.%OOC_OFF%",
			Image = "",
			Characters = [],
			Options = [
				{
					Text = "Отряду \'%companyname%\' нужен командир!",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "Пришла пора оставить жизнь наёмника. (Завершить кампанию)",
					function getResult( _event )
					{
						this.World.State.getMenuStack().pop(true);
						this.World.State.showGameFinishScreen(true);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_78.png[/img]Десятник самодовольно ухмыляется, заметив ваш сдержанный кивок, но улыбка мгновенно сползает с его лица, когда %dude% делает шаг вперёд. Закалённый наёмник буравит солдата долгим взглядом, презрительно оценивая его нетронутые мозолями ладони и чистый, наглаженный воротник.%SPEECH_ON%Послушай-ка сюда, вояка. Мы жгли их стойбища тогда, когда твои благородные господа ещё только переставали грызть друг другу глотки и ломали голову, как бы договориться для общего отпора. Мы видели, как рвётся чёрный порох и как степняки сжигают своих мёртвых вождей. Так что подбирай слова поосторожнее, пока я не решил, что у тебя в башке вместо мозгов одна дешёвая бравада.%SPEECH_OFF%Лейтенант прячется за спины своих солдат, и его отряд поспешно исчезает за поворотом. %dude% с отвращением сплёвывает им вслед.%SPEECH_ON%Вот так-то лучше. Пускай теперь у своего каменного истукана защиты просят — а не у нас.%SPEECH_OFF%Вы хрипло смеётесь, но где-то глубоко внутри снова шевелится старая назойливая мысль: не пора ли наконец повесить меч на гвоздь, пока бескрайняя степь не породила новую орду?\r\n\r\n%OOC%Вы победили! \'Battle Brothers\' разрабатывалась как игра, к которой можно возвращаться снова и снова. Обычно прохождения длятся, пока вы не переживёте один или два кризиса. Следующая кампания позволит получить иной опыт в новом мире.\r\n\r\nВпрочем, вы вправе продолжать текущее прохождение столь долго, сколько захотите. Просто имейте в виду, что кампания не предназначена для бесконечной игры, и рано или поздно у вас не останется вызовов, которые можно было бы превзойти.%OOC_OFF%",
			Image = "",
			Characters = [],
			Options = [
				{
					Text = "Отряду \'%companyname%\' нужен командир!",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "Пришла пора оставить жизнь наёмника. (Завершить кампанию)",
					function getResult( _event )
					{
						this.World.State.getMenuStack().pop(true);
						this.World.State.showGameFinishScreen(true);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Statistics.hasNews("crisis_horde_end"))
		{
			local currentTile = this.World.State.getPlayer().getTile();

			if (!currentTile.HasRoad)
			{
				return;
			}

			local brothers = this.World.getPlayerRoster().getAll();
			local most_days_with_company = -9000.0;
			local most_days_with_company_bro;

			foreach( bro in brothers )
			{
				if (bro.getDaysWithCompany() > most_days_with_company)
				{
					most_days_with_company = bro.getDaysWithCompany();
					most_days_with_company_bro = bro;
				}
			}

			this.m.Dude = most_days_with_company_bro;
			this.m.Score = 6000;
		}
	}

	function onPrepare()
	{
		this.World.Statistics.popNews("crisis_horde_end");
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"dude",
			this.m.Dude.getNameOnly()
		]);
		local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		_vars.push([
			"randomnoblehouse",
			nobles[this.Math.rand(0, nobles.len() - 1)].getName()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});
