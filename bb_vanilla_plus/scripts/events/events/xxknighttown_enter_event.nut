this.xxknighttown_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.xxknighttown_enter_event";
		this.m.Title = "По мере приближения...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_78.png[/img]{Этот регион имеет плодородные земли и милосердного монарха, что делает людей счастливыми. Было много врагов, которые стремились заполучить эти плодородные земли, но лорд и народ преодолели испытание, действуя как одно целое. К сожалению, Орден Грифона, называемый сильнейшими рыцарями на континенте, вторгся в эту землю. Лорд и народ обратились к вам за помощью, чтобы победить их. Готовы ли вы сделать своего злейшего врага ради небольшого сочувствия и ценных материальных вознаграждений?}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Мы защитим ваш народ",
					function getResult( _event )
					{
						return "AA";
					}
				},
				{
					Text = "Чепуха! Мы не можем пойти на такой риск.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(false);
				}
			}
		});
		this.m.Screens.push({
			ID = "AA",
			Text = "[img]gfx/ui/events/event_78.png[/img]{Лорд и его народ очень благодарны вам за ваше мужественное решение. Сейчас самое время готовиться к великой битве. Вы хотите отправиться в бой вместе с ними? Или вы пойдете только со своими войсками?}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Давайте вместе победим врага",
					function getResult( _event )
					{
						local pp = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						pp.CombatID = "Event";
						pp.Music = this.Const.Music.NobleTracks;
						pp.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						if (this.Math.rand(1, 3) == 1)
						{
							pp.LocationTemplate.Template[0] = "tactical.xxtactical_knighttown";
						}
						pp.TerrainTemplate = "tactical.steppe";
						pp.IsAutoAssigningBases = false;
						pp.IsLootingProhibited = true;
						pp.IsWithoutAmbience = true;
						pp.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						pp.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						pp.BeforeDeploymentCallback = function ()
						{
							local size = this.Tactical.getMapSize();
							for( local x = 0; x < size.X; x = ++x )
							{
								for( local y = 0; y < size.Y; y = ++y )
								{
									local tile = this.Tactical.getTileSquare(x, y);
									tile.Level = this.Math.min(1, tile.Level);
								}
							}
						};
						if (this.Const.DLC.Desert)
						{
							pp.IsArenaMode = true;
							this.Const.Sound.Volume.Arena = 0;
							this.Const.Sound.ArenaStart = [ "sounds/cloth_01.wav" ];
							this.Const.Sound.ArenaEnd = [ "sounds/cloth_01.wav" ];
							this.Const.Sound.ArenaOutro = [ "sounds/cloth_01.wav" ];
						}
						pp.Entities = [];
						for( local i = 0; i < 10; i = ++i )
						{
							pp.Entities.push({
								ID = this.Const.EntityType.AlpShadow,
								Variant = 0,
								Row = 0,
								Script = "scripts/entity/tactical/enemies/xxmob_horseman_a",
								Faction = this.Const.Faction.PlayerAnimals
							});
						}
						for( local i = 0; i < 3; i = ++i )
						{
							pp.Entities.push({
								ID = this.Const.EntityType.AlpShadow,
								Variant = 0,
								Row = 1,
								Script = "scripts/entity/tactical/humans/bounty_hunter",
								Faction = this.Const.Faction.PlayerAnimals
							});
							pp.Entities.push({
								ID = this.Const.EntityType.AlpShadow,
								Variant = 0,
								Row = 1,
								Script = "scripts/entity/tactical/humans/militia_veteran",
								Faction = this.Const.Faction.PlayerAnimals
							});
							pp.Entities.push({
								ID = this.Const.EntityType.AlpShadow,
								Variant = 0,
								Row = 2,
								Script = "scripts/entity/tactical/humans/militia_captain",
								Faction = this.Const.Faction.PlayerAnimals
							});
						}
						for( local i = 0; i < 2; i = ++i )
						{
							pp.Entities.push({
								ID = this.Const.EntityType.AlpShadow,
								Variant = 0,
								Row = 2,
								Script = "scripts/entity/tactical/humans/master_archer",
								Faction = this.Const.Faction.PlayerAnimals
							});
						}
						pp.Entities.push({
							ID = this.Const.EntityType.AlpShadow,
							Variant = 0,
							Row = 1,
							Script = "scripts/entity/tactical/humans/swordmaster",
							Faction = this.Const.Faction.PlayerAnimals
						});
						pp.Entities.push({
							ID = this.Const.EntityType.AlpShadow,
							Variant = 0,
							Row = 1,
							Script = "scripts/entity/tactical/enemies/xxmob_battlemaster",
							Faction = this.Const.Faction.PlayerAnimals
						});

						for( local i = 0; i < 8; i = ++i )
						{
							pp.Entities.push({
								ID = this.Const.EntityType.AlpShadow,
								Variant = 0,
								Row = 3,
								Script = "scripts/entity/tactical/enemies/xxmob_horseman_b",
								Faction = this.Const.Faction.Enemy
							});
							pp.Entities.push({
								ID = this.Const.EntityType.AlpShadow,
								Variant = 0,
								Row = 4,
								Script = "scripts/entity/tactical/enemies/xxmob_horseman_b",
								Faction = this.Const.Faction.Enemy
							});
						}
						_event.registerToShowAfterCombat("VictoryA", "Defeat");
						this.World.State.startScriptedCombat(pp, false, false, true);
						return 0;
					}
				},

				{
					Text = "У нас достаточно войск, чтобы победить их. Вы и ваши люди сосредоточьтесь на обороне.",
					function getResult( _event )
					{
						local pp = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						pp.CombatID = "Event";
						pp.Music = this.Const.Music.NobleTracks;
						pp.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						if (this.Math.rand(1, 3) == 1)
						{
							pp.LocationTemplate.Template[0] = "tactical.xxtactical_knighttown";
						}
						pp.TerrainTemplate = "tactical.steppe";
						pp.IsAutoAssigningBases = false;
						pp.IsLootingProhibited = true;
						pp.IsWithoutAmbience = true;
						pp.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						pp.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						pp.BeforeDeploymentCallback = function ()
						{
							local size = this.Tactical.getMapSize();
							for( local x = 0; x < size.X; x = ++x )
							{
								for( local y = 0; y < size.Y; y = ++y )
								{
									local tile = this.Tactical.getTileSquare(x, y);
									tile.Level = this.Math.min(1, tile.Level);
								}
							}
						};
						if (this.Const.DLC.Desert)
						{
							pp.IsArenaMode = true;
							this.Const.Sound.Volume.Arena = 0;
							this.Const.Sound.ArenaStart = [ "sounds/cloth_01.wav" ];
							this.Const.Sound.ArenaEnd = [ "sounds/cloth_01.wav" ];
							this.Const.Sound.ArenaOutro = [ "sounds/cloth_01.wav" ];
						}
						pp.Entities = [];
						for( local i = 0; i < 8; i = ++i )
						{
							pp.Entities.push({
								ID = this.Const.EntityType.AlpShadow,
								Variant = 0,
								Row = 3,
								Script = "scripts/entity/tactical/enemies/xxmob_horseman_b",
								Faction = this.Const.Faction.Enemy
							});
							pp.Entities.push({
								ID = this.Const.EntityType.AlpShadow,
								Variant = 0,
								Row = 4,
								Script = "scripts/entity/tactical/enemies/xxmob_horseman_b",
								Faction = this.Const.Faction.Enemy
							});
						}
						_event.registerToShowAfterCombat("VictoryB", "Defeat");
						this.World.State.startScriptedCombat(pp, false, false, true);
						return 0;
					}
				}
			],
			function start( _event )
			{
			}
		});
		this.m.Screens.push({
			ID = "VictoryA",
			Text = "[img]gfx/ui/events/event_87.png[/img]{Вы одержали победу над величайшей армией в истории. Лорд и его народ восхваляют вас за ваши подвиги. Эта битва будет помниться вечно. Но для наемника гораздо важнее достойное вознаграждение.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Это стоило того.",
					function getResult( _event )
					{
						this.Const.Sound.Volume.Arena = 0.6;
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "После битвы...";
				this.World.Assets.getStash().makeEmptySlots(2);
				local item = this.new("scripts/items/accessory/xxsilvertrophy");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 11,
					icon = "ui/items/" + item.getIcon(),
					text = "Вы получаете "  + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/special/fountain_of_youth_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 12,
					icon = "ui/items/" + item.getIcon(),
					text = "Вы получаете "  + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				this.World.Assets.addMoney(10000);
				this.List.push({
					id = 14,
					icon = "ui/items/supplies/money.png",
					text = "Вы получаете 10000 крон"
				});
				local brothers = this.World.getPlayerRoster().getAll();
				foreach( bro in brothers )
				{
					bro.improveMood(1.5, "Мораль повысилась.");

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().die();
				}
			}

		});
		this.m.Screens.push({
			ID = "VictoryB",
			Text = "[img]gfx/ui/events/event_24.png[/img]{Вы без посторонней помощи победили величайшую армию в истории. Лорд и его народ восхваляют вас за ваши подвиги. Эта битва будет помниться вечно. Но для наемника гораздо важнее достойное вознаграждение.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Получил больше наград, чем было обещано.",
					function getResult( _event )
					{
						this.Const.Sound.Volume.Arena = 0.6;
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "После битвы...";
				this.World.Assets.getStash().makeEmptySlots(3);
				local item = this.new("scripts/items/accessory/xxsilvertrophy");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 11,
					icon = "ui/items/" + item.getIcon(),
					text = "Вы получаете "  + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/special/fountain_of_youth_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 12,
					icon = "ui/items/" + item.getIcon(),
					text = "Вы получаете "  + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/special/spiritual_reward_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 13,
					icon = "ui/items/" + item.getIcon(),
					text = "Вы получаете "  + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				this.World.Assets.addMoney(20000);
				this.List.push({
					id = 14,
					icon = "ui/items/supplies/money.png",
					text = "Вы получаете 20000 крон"
				});
				local brothers = this.World.getPlayerRoster().getAll();
				foreach( bro in brothers )
				{
					bro.improveMood(1.5, "Воодушевление.");

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().die();
				}
			}

		});
		this.m.Screens.push({
			ID = "Defeat",
			Text = "[img]gfx/ui/events/event_88.png[/img]{Что это за место? Увидев возможность сбежать, вы решаете убежать отсюда.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Не стоило сюда приходить...",
					function getResult( _event )
					{
						this.Const.Sound.Volume.Arena = 0.6;
						return 0;
					}
				}
			],
			function start( _event )
			{
				_event.m.Title = "После битвы...";
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
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
	}

});

