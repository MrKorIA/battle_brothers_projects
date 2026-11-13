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
			Text = "[img]gfx/ui/events/event_05.png[/img]Вы встречаете отряд солдат дома %randomnoblehouse%. Они узнают ваши знамёна и приветствуют вас — впервые за долгое время без страха в голосе. Лейтенант выходит вперёд, снимая перчатку для рукопожатия.%SPEECH_ON%Так это вы — отряд, что сломил Великую Орду! Мы только что получили гонца: Чурчжэни сняли лагеря и ушли за степь, степняки Железной Орды раскололись и перегрызлись между собой, а обозы с порохом догорают на дорогах. Война окончена!%SPEECH_OFF%Он хлопает вас по плечу, словно старого знакомого.%SPEECH_ON%Благородные дома, разумеется, теперь расскажут, что всё это было их заслугой. Но мы-то с полей знаем, кто вышагал сквозь этот ад первым. Будь у меня власть — я бы вам памятник поставил. А пока — освобождайте дорогу, герои: теперь всю эту грязь будем разгребать мы, настоящие солдаты!%SPEECH_OFF%",
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
			Text = "[img]gfx/ui/events/event_05.png[/img]Вы улыбаетесь и киваете солдатам, давая им дорогу. Лейтенант довольно ускоряется, а %dude% смотрит ему вслед с нескрываемым презрением.%SPEECH_ON%Памятник, значит. Жаль, что не кронами.%SPEECH_OFF%Возможно, так оно и лучше: памятники не кормят, а кроны не ломаются от дождя. Вы смотрите на восток, где над степью больше нет чёрного дыма — только обычный, мирный туман. Человеческий мир уцелел. Орда разбита, и её страх ушёл вместе с нею.\r\n\r\nЗадумавшись, вы спрашиваете себя, не пора ли оставить эту жизнь. С другой стороны — сколько ещё дорог не пройдено?\r\n\r\n%OOC%Вы победили! \'Battle Brothers\' разрабатывалась как игра, к которой можно возвращаться снова и снова. Обычно прохождения длятся, пока вы не переживёте один или два кризиса. Следующая кампания позволит получить иной опыт в новом мире.\r\n\r\nВпрочем, вы вправе продолжать текущее прохождение столь долго, сколько захотите. Просто имейте в виду, что кампания не предназначена для бесконечной игры, и рано или поздно у вас не останется вызовов, которые можно было бы превзойти.%OOC_OFF%",
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
			Text = "[img]gfx/ui/events/event_05.png[/img]Лейтенант ухмыляется, замечая ваш кивок, но ухмылка сползает, когда %dude% делает шаг вперёд. Наёмник смотрит на солдата долгим взглядом, оценивая мягкие ладони и отутюженный воротник.%SPEECH_ON%Послушай, герой. Мы ходили в их лагеря, когда твои господа ещё переписывались грамотами. Мы видели, как горит порох, и как степняки хоронят своих вождей. Так что выбери слова понежнее, пока я не решил, что в твоей фляге не вода, а бравада.%SPEECH_OFF%Лейтенант прячется за спины своих солдат, и отряд торопливо исчезает за поворотом. %dude% сплёвывает им вслед.%SPEECH_ON%Вот так-то лучше. Им бы победу у памятника просить — не у нас.%SPEECH_OFF%Вы смеётесь, но внутри шевелится старая мысль: не пора ли кончать с этим ремеслом, пока степь снова не родила новую орду?\r\n\r\n%OOC%Вы победили! \'Battle Brothers\' разрабатывалась как игра, к которой можно возвращаться снова и снова. Обычно прохождения длятся, пока вы не переживёте один или два кризиса. Следующая кампания позволит получить иной опыт в новом мире.\r\n\r\nВпрочем, вы вправе продолжать текущее прохождение столь долго, сколько захотите. Просто имейте в виду, что кампания не предназначена для бесконечной игры, и рано или поздно у вас не останется вызовов, которые можно было бы превзойти.%OOC_OFF%",
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
