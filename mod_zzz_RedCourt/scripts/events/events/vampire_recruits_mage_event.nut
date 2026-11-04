this.vampire_recruits_mage_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.vampire_recruits_mage";
		this.m.Title = "Древние знания";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({ //-
			ID = "A",
			Text = "[img]gfx/ui/events/event_173.png[/img]{Хотя пустыня напоминает вам о доме, многое изменилось с тех пор, как вы были здесь в последний раз. Холмы и горы теперь лишены искусственных насаждений, реки и ручьи давно высохли, а дикие животные, исследующие пески, стали более агрессивны, чем тогда. Ещё через мгновение вы начинаете понимать, где находитесь, и при этом испытываете жуткое чувство страха, когда, взобравшись на очередную дюну, видите старые мерцающие золотые купола, которые остались в вашей памяти с тех пор.\n\n Вы находитесь в правильном месте, просто гораздо выше, чем обычно.\n\n У главного купола есть ответвление, которое кажется более привлекательным, чем основной корпус, на котором всё ещё натянуты веревки, свисающие вниз из брошенного лагеря недалеко от тени вершины купола. Вы не стали возиться с верёвкой, а просто спустились внутрь пристройки.\n Внутри гораздо больше порядка, чем вы могли себе представить - свитки и книги разложены по категориям правильно и аккуратно, а большие полки давно отремонтированы и поддерживаются в рабочем состоянии.\n Многие полки были построены друг над другом и уходят вверх на несколько ростов человека.\n Остановившись на мгновение, вы замечаете, что несколько высушенных останков были сметены в самый тёмный угол главного зала, и что они всё ещё сжимают своё оружие в страхе.\n\n Внезапно предчувствие появляется в вашем сознании, как будто булавочный укол света сквозь каменную стену проник в вашу голову. Вы вслепую бьёте в темноту, и на пол падает одетый в мантию каррион, его голова неестественно повёрнута в другую сторону. В тени слышится шарканье, но когда вы вглядываетесь в темноту, фигуры предпочитают изучать вас со сдержанностью.\n\n Из тёмного угла раздается шарканье другого рода. Оно перемещается по комнате со сверхъестественной скоростью, за которой трудно уследить, нечто осматривает вас со всех сторон и в конце концов укладывается на высокой полке прямо над вами, сверкая глазами.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Смотрите в оба!",
					function getResult( _event ) 
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_89.png[/img]{Похожее на горгулью существо присматривается, изучая вас, словно не верит своим глазам. После нескольких неловких мгновений оно прочищает горло, собираясь говорить, но вы опережаете и говорите первым.%SPEECH_ON%Я знаю, кто ты!%SPEECH_OFF%Нависшая фигура не кажется удивленной, и спокойно отвечает со своего безопасного места.%SPEECH_ON%Я тоже знаю, кто я, но тот, кем был ты, и тот, кем ты являешься сейчас - разница огромна!%SPEECH_OFF%Фигура осторожно перемещается в тень ближайшего факела, но не слезает с книжной полки. Часть вас намеревается подняться туда самостоятельно, однако вас останавливает то, что до сих пор незнакомец проявлял удивительное отсутствие агрессии к вам и тем, с кем вы путешествуете.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Пойдём с нами.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}
				},
				{
					Text = "Мне нужны бойцы, а не наставники...",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}
				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"hemovore_magic_background"
				]);
				_event.m.Dude.getSkills().add(this.new("scripts/skills/traits/bright_trait"));
                ::TheRedCourt.AddRedCourtTalents(_event.m.Dude);
				this.Characters.push(_event.m.Dude.getImagePath());
			}
		});
	}

	function onUpdateScore()
	{
		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.hemovores" && this.World.Assets.getOrigin().getID() != "scenario.hemovores_avatar") //THIS WORKS
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();
		local locations = this.World.EntityManager.getLocations();
		local nearSite = false;

		foreach( v in locations )
		{
			if (v.getTypeID() == "location.sunken_library" && v.getTile().getDistanceTo(currentTile) < 5)
			{
				nearSite = true;
				break;
			}
		}

		if (!nearSite)
		{
			return;
		}

		this.m.Score = 25;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		// _vars.push([
		// 	"joiner",
		// 	this.m.Dude.getName()
		// ]);
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

