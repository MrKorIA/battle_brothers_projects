this.barkeep_provides_rounds_event <- this.inherit("scripts/events/event", {
	m = {
		Barkeep = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.hackflows_barkeep_provides_rounds";
		this.m.Title = "Рядом с городом...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_24.png[/img][M] На подходе к городу %townname% к вам подходит %barkeep%. Бывший трактирщик весело заводит разговор. %SPEECH_ON%Я уже не первый год крепко дружу с хозяином здешней таверны. Оказывается, слухи о нашем отряде вовсю гремят в этих краях. Всякий раз, когда мы заявляемся в город, дела у него начинают процветать, а медовуха льётся рекой!%SPEECH_OFF% На ваш логичный вопрос, к чему этот разговор именно сейчас, %barkeep% лишь хитро ухмыляется. %SPEECH_ON%Да к тому, капитан, что торговля шла настолько лихо, что старик смог полностью обновить свои погреба. Теперь у него припрятано то, что действительно приятно пить! Он хочет, чтобы мы первыми сняли пробу, когда он откупорит свой особый резерв. И уверяю вас, отказа он не примет. Ну так что, уважим старика? Наведаемся?%SPEECH_OFF% Вы даёте добро, и вскоре весь отряд уже вовсю кутит в таверне, травя наёмнические байки и капля за каплей осушая бочонки с первоклассным алкоголем.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "За это стоит выпить!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getSkills().hasSkill("trait.ailing"))
					{
						continue;
					}
					else if (bro.getSkills().hasSkill("trait.addict") || bro.getSkills().hasSkill("trait.drunkard"))
					{
						bro.improveMood(2.0, "Впечатлён угощением выпивкой.");
					}
					else
					{
						bro.improveMood(1.0, "Оценил угощение выпивкой.");
					}

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}

				_event.m.Barkeep.improveMood(0.5, "Раздобыл хорошее пойло.");

				if (_event.m.Barkeep.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Barkeep.getMoodState()],
						text = _event.m.Barkeep.getName() + this.Const.MoodStateEvent[_event.m.Barkeep.getMoodState()]
					});
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
		local towns = this.World.EntityManager.getSettlements();
		local playerTile = this.World.State.getPlayer().getTile();
		local nearTown = false;
		local town;

		if (brothers.len() < 2)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		foreach( t in towns )
		{
			if (t.isMilitary() || t.isSouthern())
			{
				continue;
			}

			local f = t.getFactionOfType(this.Const.FactionType.Settlement);
			this.logInfo(f);

			if (f.getPlayerRelation() >= 70 && t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.hackflows_barkeep")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Town = town;
		this.m.Barkeep = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 20;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"barkeep",
			this.m.Barkeep.getName()
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Barkeep = null;
		this.m.Town = null;
	}

});

