this.fantasy_monster_encounter_4_event <- this.inherit("scripts/events/event", {
	m = {
		Champion = null
	},
	function create()
	{
		this.m.ID = "event.fantasy_monster_encounter_4_event";
		this.m.Title = "Неожиданные событие...";
		this.m.Cooldown = 100 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A1",
			Text = "[img]gfx/ui/events/event_65.png[/img]{Город переполнен возбужденной толпой. Причина, по которой толпа собралась, заключалась в том, что под присмотром городских властей и стражи проходил законный фестиваль убийств. Фестиваль называется \'Смертельная битва\' в которой сражаются до смерти один на один. Иногда на фестивале лучше участвовать, чем просто смотреть. Причина, конечно же, в призовых деньгах.\n\n[color=#999999]Из этой битвы нельзя отступить, как только она началась.[/color]}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();
				local roster = [];

				foreach( bro in brothers )
				{
					roster.push(bro);
				}

				roster.sort(function ( _a, _b )
				{
					if (_a.getXP() > _b.getXP())
					{
						return -1;
					}
					else if (_a.getXP() < _b.getXP())
					{
						return 1;
					}
					return 0;
				});

				local e = this.Math.min(5, roster.len());
				for( local i = 0; i < e; i = ++i )
				{
					local bro = roster[i];
					this.Options.push({
						Text = bro.getName() + " присоединится к смертельной битве",
						function getResult( _event )
						{
							_event.m.Champion = bro;
							return "B1";
						}
					});
				}

				this.Options.push({
					Text = "Мы не участвуем",
					function getResult( _event )
					{
						return 0;
					}
				});
			}
		});
		this.m.Screens.push({
			ID = "B1",
			Text = "[img]gfx/ui/events/event_64.png[/img]{%chosen% заканчивает подготовку к бою и выходит на арену. Толпа смеется, болтает и аплодирует. На другой стороне вы видите вооруженного крепкого парня. Вероятно, один из них завтра не увидит восхода солнца.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.Music = this.Const.Music.NobleTracks;
						properties.Entities = [];
						local moba = [
							"scripts/entity/tactical/enemies/bandit_thug",
							"scripts/entity/tactical/enemies/bandit_raider_low",
							"scripts/entity/tactical/enemies/bandit_raider",
							"scripts/entity/tactical/enemies/bandit_raider_wolf",
							"scripts/entity/tactical/enemies/bandit_leader",
							"scripts/entity/tactical/humans/peasant",
							"scripts/entity/tactical/humans/peasant_armed",
							"scripts/entity/tactical/humans/caravan_guard",
							"scripts/entity/tactical/humans/caravan_hand",
							"scripts/entity/tactical/humans/militia",
							"scripts/entity/tactical/humans/militia_captain",
							"scripts/entity/tactical/humans/mercenary_low",
							"scripts/entity/tactical/humans/mercenary",
							"scripts/entity/tactical/humans/bounty_hunter",
							"scripts/entity/tactical/humans/cultist",
							"scripts/entity/tactical/humans/gladiator",
							"scripts/entity/tactical/humans/noble_greatsword",
							"scripts/entity/tactical/humans/noble_sergeant",
							"scripts/entity/tactical/humans/knight",
							"scripts/entity/tactical/humans/hedge_knight",
							"scripts/entity/tactical/humans/swordmaster"
						];
						moba = moba[this.Math.rand(0, moba.len() - 1)];
						properties.Entities.push({
							ID = this.Const.EntityType.AlpShadow,
							Variant = 0,
							Row = 0,
							Script = moba,
							Faction = this.Const.Faction.Enemy
						});
						properties.Players.push(_event.m.Champion);
						properties.IsUsingSetPlayers = true;
						properties.IsFleeingProhibited = true;
						properties.IsLootingProhibited = true;
						properties.IsWithoutAmbience = true;
						properties.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						properties.LocationTemplate.Template[0] = "tactical.xxtactical_knighttown";
						properties.TerrainTemplate = "tactical.steppe";
						properties.BeforeDeploymentCallback = function ()
						{
							local size = this.Tactical.getMapSize();
							for( local x = 0; x < size.X; x = ++x )
							{
								for( local y = 0; y < size.Y; y = ++y )
								{
									local tile = this.Tactical.getTileSquare(x, y);
									tile.Level = 0;
									tile.removeObject();
								}
							}
							local centerTile = this.Tactical.getTileSquare(size.X / 2, size.Y / 2);
							centerTile.Level = 1;
							centerTile.removeObject();
							centerTile.spawnObject("entity/tactical/objects/xx_statue");
							centerTile.setBrush("tile_autumn_04");
						};
						properties.AfterDeploymentCallback = function ()
						{
							local size = this.Tactical.getMapSize();
							local center = {
								X = size.X / 2,
								Y = size.Y / 2
							};
							local centerTile = this.Tactical.getTileSquare(center.X, center.Y);
							for( local x = 0; x < size.X; x = ++x )
							{
								for( local y = 0; y < size.Y; y = ++y )
								{
									local tile = this.Tactical.getTileSquare(x, y);
									local d = centerTile.getDistanceTo(tile);
									if (d >= 9 && d <= 10 && this.Math.rand(1, 100) <= 60)
									{
										tile.removeObject();
										local o = tile.spawnObject("entity/tactical/objects/xx_spectator");
										if (o != null && tile.Coords.X > center.X)
										{
											o.setFlipped(true);
										}
									}
								}
							}
						};
						_event.registerToShowAfterCombat("Victory", "Defeat");
						this.World.State.startScriptedCombat(properties, false, false, false);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Options[0].Text = "Ты можешь взять его., %chosen%!";
				this.Characters.push(_event.m.Champion.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Victory",
			Text = "[img]gfx/ui/events/event_58.png[/img]{После смертельного удара %chosen%а мужчина спотыкается и падает. Он не дышит и не двигается. %chosen% в полном порядке, он самодовольно кивает, убирая оружие в ножны.%SPEECH_ON%Ничего страшного. Я даже не вспотел, убивая этого ублюдка.%SPEECH_OFF%Вы не знаете, правда это или нет, но одно можно сказать наверняка. Он победил и получил приз.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ты хорошо справился, %chosen%.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Champion.getImagePath());
				local xxmoney = this.Math.min(this.World.getTime().Days * 10 + 500, 3000);
				this.World.Assets.addMoney(xxmoney);
				this.List.push({
					id = 11,
					icon = "ui/items/supplies/money.png",
					text = "Вы получаете " + xxmoney + " крон"
				});
			}

		});
		this.m.Screens.push({
			ID = "Defeat",
			Text = "[img]gfx/ui/events/event_12.png[/img]{Вы беспомощно наблюдали, как мужчина резал %chosen%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Проклятье!",
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
					if (this.Math.rand(1, 100) <= 50)
					{
						bro.worsenMood(2, "в ярости из-за неудачного решения командира");
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 50)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();
		local nearTown = false;
		local towns = this.World.EntityManager.getSettlements();
		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 3)
			{
				nearTown = true;
				break;
			}
		}
		if (!nearTown)
		{
			return;
		}
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"chosen",
			this.m.Champion != null ? this.m.Champion.getName() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		return "A1";
	}

	function onClear()
	{
		this.m.Champion = null;
	}

});

