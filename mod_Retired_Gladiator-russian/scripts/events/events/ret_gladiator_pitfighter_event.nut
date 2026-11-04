this.ret_gladiator_pitfighter_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.ret_gladiator_pitfighter"; //—
		this.m.Title = "%townname%";
		this.m.Cooldown = 35.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%townImage%Вдалеке снова звучит рог арены, и на мгновение вы чувствуете, как ваше тело приходит в движение, прежде чем осознать, что вы находитесь по иную сторону стен арены. Мимо проходит одинокий мужчина, держащий цепь, идущую к ошейнику раба, дергающий её, словно пастух, ведущий козу по рынку. Некоторые прохожие наблюдают за ним, прочие открыто презирают человека и его питомца на поводке.\n\nВы не собираетесь связываться с ним и хотите обойти незнакомца, однако он замечает вас в последний миг, и случайное пересечение взглядов даёт ему повод пробиться сквозь толпу к вам.%SPEECH_ON%Я вижу по твоей походке и снаряжению, что ты - свободный гладиатор, прокладывающий себе путь в этом мире...%SPEECH_OFF%Что ж, отчасти это правда.%SPEECH_ON%...и всего за %money% крон ты можешь освободить этого гладиатора, ибо я готов с ним расстаться - и даже отдать его старое снаряжение, если мы заключим сделку!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Хорошо, я куплю его за %money% крон.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Прости, друг, но, похоже, тебе придется ещё немного побыть пленником.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						return 0;
					}

				}
			],
			function start( _event )
			{
				// this.Characters.push(_event.m.Dude.getImagePath());
				local money = this.Math.rand(715, 965);
				// local roster = this.World.getTemporaryRoster(); ///needed?
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "%townImage%Боец стряхивает с себя кандалы, как только рабовладелец расстегивает их, и бросает на мужчину суровый взгляд, пока тот идёт к вам.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Лишние руки никогда не помешают.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"pit_fighter_background"
				]);
				this.Characters.push(_event.m.Dude.getImagePath());
				_event.m.Dude.getSkills().add(this.new("scripts/skills/perks/perk_retglad_path"));

				local money = this.Math.rand(715, 965);
				this.World.Assets.addMoney(-money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы потратили [color=" + this.Const.UI.Color.NegativeEventValue + "]" + money + "[/color] крон"
				});
			}
		});
	}

	function onUpdateScore()
	{

		if (this.World.Assets.getOrigin().getID() != "scenario.ret_gladiator")
		{
			return;
		}

		if (this.World.Assets.getMoney() < 1300) //above 1300 crowns to trigger
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local currentTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() && t.getTile().getDistanceTo(currentTile) <= 4 && t.isAlliedWithPlayer() && t.hasBuilding("building.arena")) //only happens near arena
			{
				this.m.Town = t;
				break;
			}
		}

		if (this.m.Town == null)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
        	if (bro.getLevel() < 6 && bro.getBackground().getID() == "background.retired_gladiator") //only unlocks beyond lvl 6
			{
				candidates.push(bro);
			}
		}

		// this.m.Name = this.Const.Strings.SouthernNames[this.Math.rand(0, this.Const.Strings.SouthernNames.len() - 1)];
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"town",
			this.m.Town.getNameOnly()
		]);
		_vars.push([
			"townname",
			this.m.Town.getNameOnly()
		]);
		_vars.push([
			"money",
			this.Math.rand(715, 965)//;
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
		this.m.Town = null;
	}

});

