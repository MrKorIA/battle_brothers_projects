this.cultist_legendary_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.cultist_legendary_enter";
		this.m.Title = "По мере приближения...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_119.png[/img]{По мере того, как вы приближаетесь к месту проведения великого ритуала, вы начинаете ощущать, как вокруг вас сгущается странное, тревожное чувство. Вскоре вашему оку открывается равнина, где возле высокого идола бродит множество фигур. Самодельные доспехи, сшитые из человеческой кожи, не оставляют сомнений в том, что перед вами поклонники Давкула. Среди них выделялся лишь один, облачённый в сверкающие доспехи. %randombrother%, взглянув на происходящее, коротким жестом подзывает вас к себе.%SPEECH_ON%Командир, когда-то мне доводилось слышать об этом месте, но я и не мог думать, что судьба занесёт меня сюда. Вон тот, в доспехах - это верховный жрец. Земное вместилище их омерзительного божества. Их лидер и основа их культа. По легенде, сам Давкул наделил его своими тёмными силами, которые позволяют ему вершить жертвенные ритуалы. На этих землях должны быть и его меньшие послушники, один к %direction0%, а другой к %direction1% отсюда. В руках этих адептов находятся могущественные артефакты, которые могли бы оградить нас от чар верховного жреца. К тому же, послушники будут мгновенно присылать подкрепления верховному жрецу в случае опасности. Так что, быть может, нам стоит сначала избавиться от этих адептов.%SPEECH_OFF%Он замолчал, ожидая вашего решения, в то время как вы пытаетесь понять, откуда тот вообще знает обо всём этом.}", 
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Атакуем немедленно!",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setAttackable(true);
							this.World.State.getLastLocation().setFaction(this.getCultists().getID());
						}

						this.World.Events.showCombatDialog(true, false, true);
						return 0;
					}

				},
				{
					Text = "Отступаем. Сначала навестим этих послушников.",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						return 0;
					}

				}
			],
			function start( _event )
			{
			}
		});
		this.m.Screens.push({
			ID = "one_visited",
			Text = "[img]gfx/ui/events/event_119.png[/img]{По мере того, как вы приближаетесь к месту проведения великого ритуала, вы начинаете ощущать, как вокруг вас сгущается странное, тревожное чувство. Вскоре вашему оку открывается равнина, где возле высокого идола бродит множество фигур. Самодельные доспехи, сшитые из человеческой кожи, не оставляют сомнений в том, что перед вами поклонники Давкула. Среди них выделялся лишь один, облачённый в сверкающие доспехи. %randombrother%, взглянув на происходящее, коротким жестом подзывает вас к себе.%SPEECH_ON%Командир, когда-то мне доводилось слышать об этом месте, но я и не мог думать, что судьба занесёт меня сюда. Вон тот, в доспехах - это верховный жрец. Земное вместилище их омерзительного божества. Их лидер и основа их культа. По легенде, сам Давкул наделил его своими тёмными силами, которые позволяют ему вершить жертвенные ритуалы. На этих землях должны быть и его меньшие послушники. К счастью, один из них уже не доставит нам проблем, остался лишь второй, который находится к %direction0% отсюда. Артефакт, которым владеет этот послушник, мог бы оградить нас от чар верховного жреца. Так что, быть может, нам стоит сначала избавиться от этого адепта.%SPEECH_OFF%Он замолчал, ожидая вашего решения, в то время как вы пытаетесь понять, откуда тот вообще знает обо всём этом.}", 
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Атакуем немедленно!",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setAttackable(true);
							this.World.State.getLastLocation().setFaction(this.getCultists().getID());
						}

						this.World.Events.showCombatDialog(true, false, true);
						return 0;
					}

				},
				{
					Text = "Отступаем. Сначала навестим этого послушника.",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						return 0;
					}

				}
			],
			function start( _event )
			{
			}
		});
		this.m.Screens.push({
			ID = "two_visited",
			Text = "[img]gfx/ui/events/event_119.png[/img]{По мере того, как вы приближаетесь к месту проведения Великого Ритуала, вы начинаете ощущать, как вокруг вас сгущается странное, тревожное чувство. Вскоре вашему оку открывается равнина, где возле высокого идола бродит множество фигур. Самодельные доспехи, сшитые из человеческой кожи, не оставляют сомнений в том, что перед вами поклонники Давкула. Среди них выделялся лишь один, облачённый в сверкающие доспехи. %randombrother%, взглянув на происходящее, коротким жестом подзывает вас к себе.%SPEECH_ON%Командир, когда-то мне доводилось слышать об этом месте, но я и не мог думать, что судьба занесёт меня сюда. Вон тот, в доспехах - это верховный жрец. Земное вместилище их омерзительного божества. Их лидер и основа их культа. По легенде, сам Давкул наделил его своими тёмными силами, которые позволяют ему вершить жертвенные ритуалы. На этих землях были и его меньшие послушники, которых, к счастью, мы уже успели навестить. Древние артефакты, которые мы у них отняли, помогут нам защититься от чар верховного жреца.%SPEECH_OFF%}", 
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Атакуем немедленно!",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setAttackable(true);
							this.World.State.getLastLocation().setFaction(this.getCultists().getID());
						}

						this.World.Events.showCombatDialog(true, false, true);
						return 0;
					}

				},
				{
					Text = "Отступаем.",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

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
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		local ritualsites = []
		foreach (settlement in this.getCultists().getSettlements()){
			if (settlement.m.TypeID == "location.cultist_minor_ritual_site"){
				ritualsites.push(settlement)
			}
		}
		foreach (i, sett in ritualsites)
		{
			_vars.push([
			"direction" + i,
			this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(sett.getTile())]
			]);
		}

	}

	function onDetermineStartScreen()
	{

		local ritualsites = this.getCultists().m.Flags.get("RitualSitesBeat")
		this.printDebug("RitualSitesBeat " + ritualsites, "mod_cultists")
		if (ritualsites == 1 ) return "one_visited"
		else if (ritualsites == 0) return "A"
		else return "two_visited"
	}

	function onClear()
	{
	}

});

