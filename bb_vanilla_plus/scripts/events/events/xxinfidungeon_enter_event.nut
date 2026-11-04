this.xxinfidungeon_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.xxinfidungeon_enter_event";
		this.m.Title = "По мере приближения...";
		this.m.Cooldown = 0.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_132.png[/img]{Это злое место — бедствие, вызванное бесконечными желаниями волшебников. Здесь материализуются галлюцинации, и те, кто ступает сюда, никогда не возвращаются. Кажется, что здесь скрываются зловещие существа. \n\n%SPEECH_START%Черт, только дураки могут быть одержимы сокровищами и приходить сюда!%SPEECH_OFF%%randombrother% ворчит. Вы киваете и горько улыбаетесь. Многие искатели приключений и злодеи приходили сюда в поисках чего-то ценного, но встретили здесь свою смерть. Теперь вы исследуете эту местность, чтобы подтвердить слухи.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Будем осторожны и оглядимся вокруг.",
					function getResult( _event )
					{
						local pp = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						pp.CombatID = "Event";
						pp.Music = [
						"music/noble_01.ogg",
						"music/noble_02.ogg",
						"music/undead_01.ogg",
						"music/undead_02.ogg",
						"music/undead_03.ogg",
						"music/orcs_01.ogg",
						"music/orcs_02.ogg",
						"music/orcs_03.ogg",
						"music/goblins_01.ogg",
						"music/goblins_02.ogg",
						"music/beasts_01.ogg",
						"music/beasts_02.ogg",
						"music/civilians_01.ogg"
						];
						pp.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						local btile = [
							"tactical.autumn",
							"tactical.forest",
							"tactical.forest_leaves",
							"tactical.forest_snow",
							"tactical.hills",
							"tactical.hills_snow",
							"tactical.hills_steppe",
							"tactical.hills_tundra",
							"tactical.mountain",
							"tactical.plains",
							"tactical.quarry",
							"tactical.steppe",
							"tactical.snow",
							"tactical.swamp",
							"tactical.tundra"
						];
						if (this.Const.DLC.Desert)
						{
							btile.push("tactical.desert");
							btile.push("tactical.hills_desert");
							btile.push("tactical.oasis");
							btile.push("tactical.sinkhole");
						}			
						pp.TerrainTemplate = btile[this.Math.rand(0, btile.len() - 1)];
						local qq = this.Math.rand(0, 11);
						if (qq == 1)
						{
							pp.LocationTemplate.Template[0] = "tactical.graveyard";
						}
						else
						if (qq == 2)
						{
							pp.LocationTemplate.Template[0] = "tactical.ruins";
						}
						else
						if (qq == 3)
						{
							pp.LocationTemplate.Template[0] = "tactical.human_camp";
						}
						else
						if (qq == 4)
						{
							pp.LocationTemplate.Template[0] = "tactical.orc_camp";
						}
						else
						if (qq == 5)
						{
							pp.LocationTemplate.Template[0] = "tactical.goblin_camp";
						}
						else
						if (qq == 6)
						{
							pp.LocationTemplate.Template[0] = "tactical.barbarian_camp";
						}
						else
						if (qq == 7)
						{
							pp.TerrainTemplate = "tactical.steppe";
							pp.LocationTemplate.Template[0] = "tactical.southern_ruins";
						}
						else
						if (qq == 8)
						{
							pp.LocationTemplate.Template[0] = "tactical.xxtactical_ruintown";
						}
						else
						if (qq == 9)
						{
							pp.LocationTemplate.Template[0] = "tactical.xxtactical_knighttown";
						}
						else
						if (qq == 10)
						{
							pp.TerrainTemplate = "tactical.quarry";
						}
						if (this.Math.rand(1, 3) == 2);
						{
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
							}
						}

						pp.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						pp.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						pp.IsAutoAssigningBases = false;
						pp.IsLootingProhibited = true;
						pp.IsWithoutAmbience = true;
						if (this.Const.DLC.Desert)
						{
							pp.IsArenaMode = true;
							this.Const.Sound.Volume.Arena = 0;
							this.Const.Sound.ArenaStart = [ "sounds/cloth_01.wav" ];
							this.Const.Sound.ArenaEnd = [ "sounds/cloth_01.wav" ];
							this.Const.Sound.ArenaOutro = [ "sounds/cloth_01.wav" ];
						}
						pp.Entities = [];
						for( local i = 0; i < 12; i = ++i )
						{
							pp.Entities.push({
								ID = this.Const.EntityType.AlpShadow,
								Variant = 0,
								Row = this.Math.rand(0, 2),
								Script = "scripts/entity/tactical/enemies/xxmob_clone",
								Faction = this.Const.Faction.Enemy
							});
						}
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
			Text = "[img]gfx/ui/events/event_132.png[/img]{Жестокая битва закончилась. Вы и ваши товарищи обыскали местность в поисках ценностей. Собрав все ценности, группа решила уйти.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Это того стоило.",
					function getResult( _event )
					{
						this.Const.Sound.Volume.Arena = 0.6;
						return 0;
					}
				}
			],
			function start( _event )
			{
				_event.m.Title = "Псле битвы...";
				this.World.Assets.getStash().makeEmptySlots(2);
				local item = this.new("scripts/items/misc/xxsbook_se");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Вы получаете "  + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/misc/xxchaospotion");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 11,
					icon = "ui/items/" + item.getIcon(),
					text = "Вы получаете "  + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().die();
				}
			}
		});
		this.m.Screens.push({
			ID = "Defeat",
			Text = "[img]gfx/ui/events/event_88.png[/img]{Что это за безумное место? Увидев возможность сбежать, вы решаете отступить отсюда.}",
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

