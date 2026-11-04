this.xxogretown_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.xxogretown_enter_event";
		this.m.Title = "По мере приближения...";
		this.m.Cooldown = 0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_123.png[/img]{В воздухе витает запах смерти и страха. Это место правит гигантское зло, существующее с мифических времен. Существо, наполненное невообразимой злобой и жаждой, не проявит пощады ни к кому, кто осмелится вторгнуться в его владения.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Готовьтесь к битве!",
					function getResult( _event )
					{
						local pp = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						pp.CombatID = "Event";
						pp.Music = this.Const.Music.BeastsTracks;
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
									if (this.Math.rand(1, 100) <= 50)
									{
										tile.removeObject();
										tile.clear();
										tile.Level = this.Math.min(0, tile.Level);
									}
									else
									{
										tile.Level = this.Math.min(1, tile.Level);
									}
								}
							}
						};
						pp.Entities = [];
						pp.Entities.push({
							ID = this.Const.EntityType.AlpShadow,
							Variant = 0,
							Row = 3,
							Script = "scripts/entity/tactical/enemies/xxmob_ogre",
							Faction = this.Const.Faction.Enemy
						});
						_event.registerToShowAfterCombat("Victory", "Defeat");
						this.World.State.startScriptedCombat(pp, false, false, true);
						return 0;
					}
				},
				{
					Text = "Отступаем!",
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
			ID = "Victory",
			Text = "[img]gfx/ui/events/event_134.png[/img]{Жестокая битва закончилась. Вы и ваши товарищи обыскали местность в поисках ценностей. Собрав все ценности, группа решила уйти.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Это стоило того.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "После битвы...";
				this.World.Assets.getStash().makeEmptySlots(2);
				local item = this.new("scripts/items/weapons/named/xxorc_axe_two_handed");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Вы получаете "  + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/special/fountain_of_youth_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 11,
					icon = "ui/items/" + item.getIcon(),
					text = "Вы получаете "  + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				this.World.Assets.addMoney(10000);
				this.List.push({
					id = 12,
					icon = "ui/items/supplies/money.png",
					text = "Вы получаете 10000 крон"
				});
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
					Text = "Не стоило сюда приходить....",
					function getResult( _event )
					{
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

