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
			Text = "[img]gfx/ui/events/event_173.png[/img]{Хотя пустыня напоминает вам о доме, многое изменилось с тех пор, как вы были здесь в последний раз. Холмы и горы теперь совершенно голы, реки и ручьи давно высохли, а дикие звери, бродящие по пескам, стали злее, чем прежде. Ещё мгновение - и вы понимаете, где находитесь: взобравшись на очередную дюну, вы видите старые мерцающие золотые купола, запечатлевшиеся в вашей памяти с тех давних времён, - и вас пробирает жуткий страх.\n\n Вы в нужном месте - просто гораздо выше, чем следовало бы.\n\n У главного купола есть пристройка, которая кажется более привлекательной, чем основной корпус: от брошенного лагеря у вершины купола к ней всё ещё тянутся свисающие верёвки. Вы не стали возиться с верёвкой, а просто спустились внутрь пристройки.\n Внутри гораздо больше порядка, чем вы могли себе представить - свитки и книги аккуратно разложены по разделам, а большие полки давно починены и крепки.\n Многие полки возвышаются одна над другой на несколько человеческих ростов.\n Остановившись на мгновение, вы замечаете несколько высохших тел, сметённых в самый тёмный угол главного зала, - и они всё ещё до смерти сжимают своё оружие.\n\n Внезапно в вашем сознании вспыхивает предчувствие, словно игла света пронзила каменную стену и вонзилась вам в голову. Вы вслепую бьёте в темноту, и на пол падает закутанный в мантию труп, его голова неестественно повёрнута в сторону. В тени слышится шарканье, но, вглядываясь в темноту, вы различаете лишь фигуры, которые предпочитают изучать вас издалека.\n\n Из тёмного угла раздаётся шарканье другого рода. Нечто движется по залу со сверхъестественной скоростью, осматривает вас со всех сторон и в конце концов устраивается на высокой полке прямо над вами, сверкая глазами.}",
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
			Text = "[img]gfx/ui/events/event_89.png[/img]{Похожее на горгулью существо присматривается, изучая вас, словно не верит своим глазам. После нескольких неловких мгновений оно прочищает горло, собираясь говорить, но вы опережаете его и говорите первым.%SPEECH_ON%Я знаю, кто ты!%SPEECH_OFF%Нависшая фигура не кажется удивлённой и спокойно отвечает со своего безопасного места.%SPEECH_ON%Я тоже знаю, кто я, но тот, кем был ты, и тот, кем ты являешься сейчас - разница огромна!%SPEECH_OFF%Фигура осторожно перебирается в тень ближайшего факела, но не слезает с книжной полки. Часть вас намеревается подняться туда самой, однако вас сдерживает то, что незнакомец до сих пор удивительно миролюбив - и к вам, и к тем, с кем вы путешествуете.}",
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

