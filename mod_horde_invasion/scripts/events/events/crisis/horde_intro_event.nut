// Интро кризиса «Нашествие Железной Орды»: всплывает при старте Live-фазы
// (новость 'crisis_horde_start' добавляет хук faction_manager).
// Образец — data_014/scripts/events/events/crisis/greenskins_intro_event.nut.
this.horde_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.horde_intro";
		this.m.Title = "На привале...";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_59.png[/img]%randombrother% заходит в вашу палатку.%SPEECH_ON%Командир, у костра крестьяне с восточной границы. Говорят, у них для вас вести — и они в отчаянии.%SPEECH_OFF%Вы выходите к костру. Прибывшие и вправду выглядят так, словно гнали их через полцарства: лица изуродованы стужей, обуви на некоторых нет. Старший, однорукий мужчина, говорит хрипло.%SPEECH_ON%Вы, должно быть, тот самый командир, о котором толкуют в городах? Тогда слушайте. Чурчжэни и степняки Мгл больше не враждуют — они заключили союз под старыми знамёнами Железной Орды. Их армии идут вместе: железная пехота, лучники, обозы с чёрным порохом. Ни одно поселение на границе не устояло.%SPEECH_OFF%Он делает глоток из фляги и продолжает.%SPEECH_ON%Мой дед рассказывал о Битве Тысячи Имён. Мы все думали, что это сказки. А это был завтрашний день. Благородные дома дрожат и шлют друг другу гонцов — вся эта братва только сейчас поняла, что мир может сгореть. Мой вам совет, командир: держитесь подальше от востока, пока не выберется тот, кто силён достаточно, чтобы противостоять орде. Или...%SPEECH_OFF%Он смотрит на вас с хитрецой уставших глаз.%SPEECH_ON%Или станьте таким сами. За работу против орды сейчас платят золотом, а не обещаниями.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Железная Орда. Вот так встреча.",
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
		if (this.World.Statistics.hasNews("crisis_horde_start"))
		{
			this.m.Score = 6000;
		}
	}

	function onPrepare()
	{
		this.World.Statistics.popNews("crisis_horde_start");
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});
