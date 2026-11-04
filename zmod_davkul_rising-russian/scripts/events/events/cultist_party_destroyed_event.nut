this.cultist_party_destroyed_event <- this.inherit("scripts/events/event", {
	m = {
			SlavesFreed = 0,
			Reward = 0,
			DudeBackground = "",
			DudeName = null,
			Dude = null
		},
	function create()
	{
		this.m.ID = "event.party.cultist_destroyed";
		this.m.Title = "После битвы...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_53.png[/img]{Единственный выживший из жертв культистов поднимается, распутывая связывающие его верёвки. Он благодарен вам за своё освобождение, и отдаёт все кроны, которые ему удалось сохранить.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Мы были рады помочь тебе.",
					function getResult( _event )
					{
						this.World.Assets.addMoney(_event.m.Reward)
						_event.clearVars()
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы получаете [color=" + this.Const.UI.Color.PositiveEventValue + "]" + _event.m.Reward + "[/color] крон"
				});
			}

		});

		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_53.png[/img]{Выжившие жертвы культистов поднимаются, распутывая связывающие их верёвки. Они благодарны вам за своё освобождение, и отдают все кроны, которые им удалось сохранить.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Мы были рады помочь вам.",
					function getResult( _event )
					{
						this.World.Assets.addMoney(_event.m.Reward);
						_event.clearVars()
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы получаете [color=" + this.Const.UI.Color.PositiveEventValue + "]" + _event.m.Reward + "[/color] крон"
				});
			}

		});

		this.m.Screens.push({
			ID = "one_volunteer",
			Text = "[img]gfx/ui/events/event_53.png[/img]{Единственный выживший из жертв культистов поднимается, распутывая связывающие его верёвки. Он благодарен вам за своё освобождение, и отдаёт все кроны, которые ему удалось сохранить. Более того, он желает присоединиться к вашему отряду. С его слов, он %background%, по крайней мере, был им раньше.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Конечно, ты можешь присоединиться.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						_event.m.Dude.onHired();
						this.World.Assets.addMoney(_event.m.Reward);
						_event.clearVars()
						return 0;
					}
				},
				{
					Text = "Тебе придётся найти свой собственный путь.",
					function getResult( _event )
					{
						_event.clearVars()
						return 0;
					}
				}
			],
			function start( _event )
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы получаете [color=" + this.Const.UI.Color.PositiveEventValue + "]" + _event.m.Reward + "[/color] крон"
				});

				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					_event.m.DudeBackground
				]);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});


		this.m.Screens.push({
			ID = "two_volunteer",
			Text = "[img]gfx/ui/events/event_53.png[/img]{Выжившие жертвы культистов поднимаются, распутывая связывающие их верёвки. Они благодарны вам за своё освобождение, и отдают все кроны, которые им удалось сохранить. Более того, один из них желает присоединиться к вашему отряду. С его слов, он %background%, по крайней мере, был им раньше.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Конечно, ты можешь присоединиться.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						_event.m.Dude.onHired();
						this.World.Assets.addMoney(_event.m.Reward);

						_event.clearVars()
						return 0;
					}
				},
				{
					Text = "Тебе придётся найти свой собственный путь.",
					function getResult( _event )
					{
						_event.clearVars()
						return 0;
					}
				}
			],
			function start( _event )
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы получаете [color=" + this.Const.UI.Color.PositiveEventValue + "]" + _event.m.Reward + "[/color] крон"
				});
				
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					_event.m.DudeBackground
				]);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
		this.printDebug("Подготовка к событию с рабами: " + this.m.SlavesFreed, "mod_cultists")
		this.m.Reward = 0
		for (local x = 0; x < this.m.SlavesFreed; x++) this.m.Reward += this.Math.rand(50, 150)

		local cheapBackgrounds = 
		[
			["apprentice_background","Подмастерье"],
			["beggar_background","Попрошайка"],
			["bowyer_background","Мастер по изготовлению луков"],
			["brawler_background","Дебошир"],
			["butcher_background","Мясник"],
			["caravan_hand_background","Караванщик"],
			["daytaler_background","Подёнщик"],
			["deserter_background","Дезертир"],
			["eunuch_background","Евнух"],
			["farmhand_background","Батрак"],
			["fisherman_background","Рыбак"],
			["flagellant_background","Флагеллант"],
			["gambler_background","Азартный игрок"],
			["gravedigger_background","Могильщик"],
			["graverobber_background","Расхититель могил"],
			["historian_background","Летописец"],
			["houndmaster_background","Псарь"],
			["juggler_background","Жонглёр"],
			["killer_on_the_run_background","Беглый убийца"],
			["lumberjack_background","Лесоруб"],
			["mason_background","Каменщик"],
			["messenger_background","Гонец"],
			["militia_background","Ополченец"],
			["miller_background","Мельник"],
			["miner_background","Шахтёр"],
			["minstrel_background","Менестрель"],
			["monk_background","Монах"],
			["nomad_background","Кочевник"],
			["peddler_background","Лоточник"],
			["poacher_background","Браконьер"],
			["raider_background","Разбойник"],
			["ratcatcher_background","Крысолов"],
			["refugee_background","Беженец"],
			["servant_background","Слуга"],
			["shepherd_background","Пастух"],
			["tailor_background","Портной"],
			["thief_background","Вор"],
			["vagabond_background","Бродяга"],

		]
		local mediumBackgrounds =
		[
			["bastard_background","Бастард"],
			["beast_hunter_background","Зверобой"],
			["hunter_background","Охотник"],
			["pimp_background","Сутенёр"],
			["wildman_background","Дикарь"],
			["witchhunter_background","Охотник на ведьм"]
		]
		local premiumBackgrounds = [
			["adventurous_noble_background","Благородный авантюрист"],
			["assassin_background","Наёмный убийца"],
			["assassin_southern_background","Ассасин"],
			["gladiator_background","Гладиатор"],
			["hedge_knight_background","Межевой рыцарь"],
			["sellsword_background","Наёмник"],
			["squire_background","Оруженосец"],
			["swordmaster_background","Мастер меча"],
			["disowned_noble_background","Лишённый титула"],
			["retired_soldier_background","Старый вояка"],
		]
		local background;
		local rng =this.Math.rand(0, 100)
		if (rng < 3) {
		    background = this.Math.randArray(premiumBackgrounds)
		}
		else if(rng < 15){
			background =this.Math.randArray(mediumBackgrounds)
		}
		else{
			background =this.Math.randArray(cheapBackgrounds)
		}

		this.m.DudeBackground = background[0]
		this.m.DudeName = background[1]
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"background",
			this.m.DudeName
		]);
	}

	function onDetermineStartScreen()
	{
		local volunteer = (this.Math.rand(0, 100) < (this.m.SlavesFreed * 2.5)) && (this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())

		if (this.m.SlavesFreed == 1){
			if (volunteer) return "one_volunteer"
			return "A";
		}
		else{
			if (volunteer) return "two_volunteer"
			return "B"
		}
	}
	function clearVars()
	{
		this.m.SlavesFreed = 0
		this.m.Reward = 0
		this.m.DudeBackground = ""
		this.m.DudeName = null
		this.m.Dude = null
		this.World.getTemporaryRoster().clear();
	}

	function onClear()
	{
		this.m.DudeBackground = ""
		this.m.DudeName = null
		this.m.Dude = null
		this.World.getTemporaryRoster().clear();
	}

});
