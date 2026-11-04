this.cultist_ritual_in_woods_event <- this.inherit("scripts/events/event", {
	m = {
		Cultist = null
	},
	function create()
	{
		this.m.ID = "event.ritual_woods";
		this.m.Title = "По пути...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_33.png[/img]Пробираясь сквозь тёмный лес, вы слышите бормотание и пение где-то в густом кустарнике. Внезапно ночь пронзает крик, и пение обрывается.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Надо разобраться.",
					function getResult( _event )
					{
						return "Arrival";
					}

				},
				{
					Text = "Убираемся отсюда.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Arrival",
			Text = "[img]gfx/ui/events/event_140.png[/img]Вы приказываете своим людям тихо пробираться вперед. В конце концов вы подбираетесь к месту преступления и видите нескольких культистов, собравшихся вокруг тела дворянина и начинающих расчленять его.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Схватим их, пока они увлеклись своим делом!",
					function getResult( _event )
					{
						return "Attack1";
					}

				},
				{
					Text = "Сначала окружим их, а затем атакуем.",
					function getResult( _event )
					{
						return "Attack2";
					}

				},
				{
					Text = "Время уходить. Немедленно.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Attack1",
			Text = "[img]gfx/ui/events/event_140.png[/img]Вы отдаете приказ атаковать.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "К оружию!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						#properties.CombatID = "Event";
						properties.Music = this.Const.Music.CivilianTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.LineBack;
						properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Center;

						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.CultistRoamers, 150*_event.getReputationToDifficultyLightMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Cultists).getID());
						_event.registerToShowAfterCombat( "Victory", "Defeat" )


						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Attack2",
			Text = "[img]gfx/ui/events/event_140.png[/img]Ваши люди окружают врагов, соблюдая тишину. После этого вы громко приказываете атаковать.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "К оружию!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						#properties.CombatID = "Event";
						properties.Music = this.Const.Music.CivilianTracks;
						properties.IsAutoAssigningBases = false;
						properties.Entities = [];
						properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Center;

						this.Const.World.Common.addUnitsToCombat(properties.Entities, this.Const.World.Spawn.CultistRoamers, 150*_event.getReputationToDifficultyLightMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Cultists).getID());

						_event.registerToShowAfterCombat( "Victory", "Defeat" )
						this.World.State.startScriptedCombat(properties, false, false, false);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Victory",
			Text = "[img]gfx/ui/events/event_140.png[/img]Вашим людям удаётся уничтожить культистов. Спасти их жертву уже невозможно, но, по крайней мере, наёмникам удаётся стащить кое-какие ценности с его трупа.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Мы отомстили за тебя, дворянин.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local loot =
				[
					"scripts/items/loot/signet_ring_item",
					"scripts/items/loot/valuable_furs_item",
					"scripts/items/armor/linen_tunic"
				]
				foreach (script in loot){
				    if (this.World.Assets.getStash().getNumberOfEmptySlots() < 1) continue;
					local item = this.new(script)
					this.World.Assets.getStash().add(this.new(item));
					this.List.push({
						id = 10,
						icon = "ui/items/" + item.getIcon(),
						text = "Вы получаете " + item.getName()
					});

				}

			}

		});
		this.m.Screens.push({
			ID = "Defeat",
			Text = "[img]gfx/ui/events/event_140.png[/img]Культисты оказались слишком сильны для вашего отряда. Вы крадётесь сквозь кусты, потерпев поражение, и понимаете, что ваших павших братьев теперь постигнет та же участь, что и этого дворянина.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Позорное поражение.",
					function getResult( _event )
					{
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
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.AutumnForest)
		{
			return;
		}

		this.m.Score = 100;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{

	}

	function onClear()
	{

	}

});

