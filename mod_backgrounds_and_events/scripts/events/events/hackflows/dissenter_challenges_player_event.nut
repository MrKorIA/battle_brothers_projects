this.dissenter_challenges_player_event <- this.inherit("scripts/events/event", {
	m = {
		Dissenter = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_dissenter_challenges_player";
		this.m.Title = "В лагере...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img][M] Стоило вам подойти к костру, как %dissenter% резко вскакивает на ноги. Смутьян тяжело дышит, его лицо багровеет от ярости, а голос срывается на крик.%SPEECH_ON%Я не знаю, о чём думают остальные, но лично я считаю, что в последнее время командование нашим отрядом стало откровенно дерьмовым!%SPEECH_OFF%Он бесцеремонно тычет в вашу сторону пальцем.%SPEECH_ON%Мы воюем, исходим кровью и подыхаем в канавах ради заветных крон! Но что насчёт него? Наш капитан ничем не лучше зажравшихся дворян, которые прячутся в своих высоких башнях и за крепостными стенами, наживаясь на чужом горбу! Нам нужно избавиться от этой пиявки, вытряхнуть из него казну и честно разделить всю добычу между собой!%SPEECH_OFF%Вы молча присаживаетесь на бревно у огня и берётесь за рукоять меча. Наёмники застывают, переводя взгляд со смутьяна на вас в ожидании неминуемой развязки.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ты абсолютно прав. Я покину отряд прямо сейчас.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Время поставить тебя на место.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Я здесь главный! Это мой отряд!",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dissenter.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_26.png[/img][M] Вы невозмутимо вытягиваете ноги, упираетесь руками в бока и спокойно кладёте ладони на колени. Слегка кивнув, вы обращаетесь прямо к зачинщику мятежа.%SPEECH_ON%Что ж, %dissenter%. Я сделаю так, как ты требуешь. На рассвете я соберу вещи и уйду в ближайшее поселение. Но пока солнце не взошло, давай проясним пару деталей. Полагаю, с этого момента именно тебе придётся вести учёт каждое утро и вечер, пересчитывая припасы. Будет паршиво, если эти славные парни отправятся на передовую без пары стрел в колчанах. Кстати, о делёжке: я ведь тоже рассчитываю, что мою долю вы выплатите мне сполна и поровну, верно? Как мы это решим?%SPEECH_OFF%Вы делаете широкий жест рукой, так что пляшущие языки пламени костра отбрасывают тени на каждого из наёмников, сидящих вокруг огня.%SPEECH_ON%Ещё тебе придётся денно и нощно следить за своими людьми. Нашим сбродом чертовски нелегко управлять, и ты, возможно, скоро углядишь в этом горькую иронию - а может и нет.%SPEECH_OFF%.Вы медленно разжимаете ладонь, сжимаете её в кулак, а затем приставляете указательный палец к своему виску.%SPEECH_ON%И главное: тебе понадобится кто-то, кто способен бритвенно-чётко принимать решения и отдавать приказы в самом пекле битвы. Те приказы, которые сохранят людям жизни, чтобы они вообще имели шанс потратить своё честно заработанное золото после резни. Похоже, раз ты заварил эту кашу, у тебя уже готова достойная замена моей голове? Что ж, тогда на рассвете я с чистой совестью уступлю тебе это место.%SPEECH_OFF%Стоит вам замолчать, как у костра повисает гнетущая тишина. Несколько братьев неодобрительно качают головами, а другие принимаются нервно теребить ремни своего снаряжения, осознав правоту ваших слов. Не найдя весомых контраргументов против этих доводов, посрамлённый %dissenter% лишь злобно сплёвывает, пятится назад и уходит в свою палатку до самого утра.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "То-то же. Знай своё место",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dissenter.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getMoodState() < this.Const.MoodState.Neutral && this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(1.0, "Укрепил уверенность в руководстве отрядом");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_26.png[/img][M] Языки пламени костра отбрасывают багровые блики на ваше лицо. Спокойно кивнув, вы медленно поднимаетесь на ноги. В этот момент %dissenter% понимает, что вы идёте прямо к нему, и инстинктивно пытается отпрянуть назад, но вы мёртвой хваткой впиваетесь ему в плечо. Секундный рывок вперёд, хлёсткая подсечка - и вот смутьян уже летит навзничь, с глухим стуком впечатываясь в сырую землю. Вы наваливаетесь сверху, намертво прижимая его к костру и сдавив коленом горло, а свободной рукой грозно указываете на притихших наёмников.%SPEECH_ON%Я погляжу, кое-кто из вас внезапно посчитал моё командование откровенно дерьмовым! Но прежде чем ваши загребущие лапы потянутся к капитанской казне в попытке оспорить мою власть, хорошенько поразмыслите: благодаря кому вы вообще до сих пор живы и имеете возможность открывать свои рты? Наш %dissenter% - парень смелый, раз у него хватило духу высказать всё наболевшее, когда дела пошли к чёрту. Но бунтовать, не имея ни малейшего понятия о том, что делать дальше - это чистой воды кретинизм! Я заявляю прямо: без моего чутья как тактика и без моей хватки как квартирмейстера вас всех, ублюдков, вырежут в первой же канаве в течение двух недель!%SPEECH_OFF%Вы поднимаетесь на ноги, хватаете смустьяна за шкирку и рывком ставите на ноги. Ошарашенный %dissenter% лишь кривится в ответ, утирает кровь с разбитой губы и поспешно уходит прочь, бесцеремонно расталкивая стоящих на пути наёмников. Бойцы молча смотрят смутьяну в спину, а после - бросают на вас смущённые и полные уважения взгляды. Никто не осмеливается вставить ни слова. Вы спокойно усаживаетесь на своё место у огня.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Всё ещё в форме!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(this._event_m.Dissenter.getImagePath());
				this._event_m.Dissenter.worsenMood(3.0, "Унижен перед всем отрядом");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[this._event_m.Dissenter.getMoodState()],
					text = this._event_m.Dissenter.getName() + this.Const.MoodStateEvent[this._event_m.Dissenter.getMoodState()]
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_26.png[/img][M] Вы мгновенно вскакиваете на ноги и срываетесь на неистовый крик.%SPEECH_ON%Я здесь главный! Я, и никто другой! У кого в руках казна отряда?! У меня! Если бы не моя воля, вас, ублюдков, здесь вообще бы не было! Вы бы до сих пор прозябали в говне и нищете своих прежних никчёмных жизней! Да вы на коленях должны ползать у моих ног за те возможности, которые я вам предоставил! И ты, %dissenter%... Если ты ещё хоть раз посмеешь раскрыть пасть и оспорить мои приказы, клянусь старыми богами - я велю содрать с тебя шкуру, а остатки вздёрнуть на ближайшем суку! Ты меня понял?!%SPEECH_OFF%Эта яростная вспышка безумного гнева мгновенно заставляет лагерь утихомириться. Побелевший от страха %dissenter% лишь безмолвно кивает и испуганно пятится назад, растворяясь в темноте. Пока вы тяжело дыша возвращаетесь на своё место, за вашей спиной наёмники начинают тревожно перешёптываться друг с другом.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Неплохо получилось, правда?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(this._event_m.Dissenter.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 33)
					{
						bro.worsenMood(1.0, "Потерял уверенность в руководстве отрядом");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];
		local grumpy = 0;

		foreach( bro in brothers )
		{
			if (bro.getMoodState() < this.Const.MoodState.Neutral)
			{
				grumpy = ++grumpy;
				grumpy = grumpy;

				if (bro.getBackground().getID() == "background.hackflows_dissenter")
				{
					candidates.push(bro);
				}
			}
		}

		if (candidates.len() == 0 || grumpy < 3)
		{
			return;
		}

		this.m.Dissenter = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 10 + grumpy * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"dissenter",
			this.m.Dissenter.getName()
		]);
	}

	function onClear()
	{
		this.m.Dissenter = null;
	}

});

