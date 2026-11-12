this.fletcher_recovers_arrows_event <- this.inherit("scripts/events/event", {
	m = {
		Fletcher = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_fletcher_recovers_arrows";
		this.m.Title = "После битвы...";
		this.m.Cooldown = 10.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_22.png[/img][M] Вы мрачно осматриваете поле недавней жестокой бойни. Пробираясь сквозь груды безжизненной плоти и искорёженного снаряжения, вы замечаете, что у одного из трупов копошится %fletcher%. Тот бесцеремонно пинает мертвецов, ковыряясь в кровавой мешанине.%SPEECH_ON%Я смогу извлечь из этих покойников часть боеприпасов, которые мы здесь потратили, сэр. Мы сможем использовать их снова, чтобы убить ещё больше этих ублюдков.%SPEECH_OFF%С этими словами он резко дёргает за древко, вырывая застрявшую стрелу прямо из глазницы мертвеца. Это действие сопровождается омерзительным, тошнотворным чавканьем, когда вслед за наконечником наружу вываливается и лопнувшее глазное яблоко.",
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
				this.Characters.push(_event.m.Fletcher.getImagePath());
				local amount = this.Math.rand(10, 20);

				if (_event.m.Fletcher.getBackground().getID() == "background.hackflows_fletcher")
				{
					amount = amount + 15;
				}

				this.World.Assets.addAmmo(amount);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_ammo.png",
					text = "Вы получаете [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + amount + "[/color] боеприпасов."
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Statistics.getFlags().getAsInt("LastCombatResult") != 1)
		{
			return;
		}

		if (this.Time.getVirtualTimeF() - this.World.Events.getLastBattleTime() > 6.0)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates_fletcher = [];

		foreach( b in brothers )
		{
			if (b.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (b.getBackground().getID() == "background.hackflows_fletcher" || b.getBackground().getID() == "background.bowyer" || b.getBackground().getID() == "background.hackflows_atilliator")
			{
				candidates_fletcher.push(b);
			}
		}

		if (candidates_fletcher.len() == 0)
		{
			return;
		}

		this.m.Fletcher = candidates_fletcher[this.Math.rand(0, candidates_fletcher.len() - 1)];
		this.m.Score = candidates_fletcher.len() * 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"fletcher",
			this.m.Fletcher.getName()
		]);
	}

	function onClear()
	{
		this.m.Fletcher = null;
	}

});

