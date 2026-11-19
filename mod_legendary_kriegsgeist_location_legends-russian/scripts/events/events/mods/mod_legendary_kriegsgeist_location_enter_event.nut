this.mod_legendary_kriegsgeist_location_enter_event <- ::inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.legendary_kriegsgeist_location_enter";
		this.m.Title = "По мере приближения...";
		this.m.Cooldown = 999999.0 * ::World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_99.png[/img]{Перед вами - твердыня забытого прошлого. По слухам, в этих руинах замка хранятся великие сокровища, к которым не прикоснулись охотники за сокровищами, поскольку никто из них не вернулся живым и не сохранил здравый рассудок.\n\nРаньше вы думали, что такие истории - это ерунда, но теперь вы добрались сюда. Холодный воздух, жуткое ощущение, мысль о том, что за вами кто-то наблюдает. Это правда, как и то, что говорили слухи, заставляя вас все больше беспокоиться.%SPEECH_ON%Не слишком ли вы параноидальны? Вы хотите войти в это проклятое место? Что вы здесь ищете?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Легендарный меч.",
					function getResult( _event )
					{
						return "Sword";
					}
				},
				{
					Text = "Артефакт, напоминающий череп.",
					function getResult( _event )
					{
						return "Skull";
					}
				},
				{
					Text = "Оба.",
					function getResult( _event )
					{
						return "Both";
					}
				},
				{
					Text = "Лучше не будем беспокоить то, что покоится здесь.",
					function getResult( _event )
					{
						if (::World.State.getLastLocation() != null)
						{
							::World.State.getLastLocation().setVisited(false);
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
			ID = "Sword",
			Text = "[img]gfx/ui/events/event_89.png[/img]{%SPEECH_START%Нарушители, вам не следовало сюда приходить. Теперь вы заплатите за свою глупость жизнью!%SPEECH_OFF%}"
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Бейтесь за свои жизни! Бейтесь, как никогда прежде не бились!",
					function getResult( _event )
					{
						if (::World.State.getLastLocation() != null)
						{
							::World.State.getLastLocation().setVisited(false);
						}

						local p = ::World.State.getLocalCombatProperties(::World.State.getPlayer().getPos());
						p.LocationTemplate = clone ::Const.Tactical.LocationTemplate;
						p.Entities = [{
							ID = ::Const.EntityType.ZombieBoss,
							Variant = 0,
							Strength = 5000.0,
							Row = 3,
							Script = "scripts/entity/tactical/enemies/mod_ghost_knight_boss",
							Name = ""
						}];

						_event.finishCombatInfo(p);
						_event.registerToShowAfterCombat("Victory", "Defeat");
						::World.State.startScriptedCombat(p, false, false, false);
						return 0;
					}
				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Skull",
			Text = "[img]gfx/ui/events/event_89.png[/img]{%SPEECH_START%Нарушители, вам не следовало сюда приходить. Теперь вы заплатите за свою глупость жизнью!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Бейтесь за свои жизни! Бейтесь, как никогда прежде не бились!",
					function getResult( _event )
					{
						if (::World.State.getLastLocation() != null)
						{
							::World.State.getLastLocation().setVisited(false);
						}

						local p = ::World.State.getLocalCombatProperties(::World.State.getPlayer().getPos());
						p.LocationTemplate = clone ::Const.Tactical.LocationTemplate;
						p.Entities = [{
							ID = ::Const.EntityType.SkeletonLichMirrorImage,
							Variant = 0,
							Strength = 5000.0,
							Row = 3,
							Script = "scripts/entity/tactical/enemies/mod_ghost_mage_boss",
							Name = ""
						}];

						_event.finishCombatInfo(p);
						_event.registerToShowAfterCombat("Victory", "Defeat");
						::World.State.startScriptedCombat(p, false, false, false);
						return 0;
					}
				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "Both",
			Text = "[img]gfx/ui/events/event_89.png[/img]{%SPEECH_START%Нарушители, вам не следовало сюда приходить. Теперь вы заплатите за свою глупость жизнью!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Бейтесь за свои жизни! Бейтесь, как никогда прежде не бились!",
					function getResult( _event )
					{
						if (::World.State.getLastLocation() != null)
						{
							::World.State.getLastLocation().setVisited(false);
						}

						local p = ::World.State.getLocalCombatProperties(::World.State.getPlayer().getPos());
						p.LocationTemplate = clone ::Const.Tactical.LocationTemplate;
						p.Entities = [
							{
								ID = ::Const.EntityType.ZombieBoss,
								Variant = 0,
								Strength = 5000.0,
								Row = 3,
								Script = "scripts/entity/tactical/enemies/mod_ghost_knight_boss",
								Name = ""
							},
							{
								ID = ::Const.EntityType.SkeletonLichMirrorImage,
								Variant = 0,
								Strength = 5000.0,
								Row = 3,
								Script = "scripts/entity/tactical/enemies/mod_ghost_mage_boss",
								Name = ""
							},
						];

						_event.finishCombatInfo(p);
						_event.registerToShowAfterCombat("Victory", "Defeat");
						::World.State.startScriptedCombat(p, false, false, false);
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
			Text = "[img]gfx/ui/events/event_65.png[/img]{}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Мы выжили",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "После битвы...";

				if (::World.State.getLastLocation() != null)
				{
					::World.State.getLastLocation().die();
				}
			}

		});
		this.m.Screens.push({
			ID = "Defeat",
			Text = "[img]gfx/ui/events/event_99.png[/img]",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Возможно когда-нибудь...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Title = "После битвы...";

				if (::World.State.getLastLocation() != null)
				{
					::World.State.getLastLocation().setVisited(false);
				}
			}

		});
	}

	function finishCombatInfo( _properties )
	{
		local f = ::World.FactionManager.getFactionOfType(::Const.FactionType.Zombies).getID();
		_properties.CombatID = "Kriegsgeist";
		//_properties.TerrainTemplate = "tactical.plains_camp";
		_properties.LocationTemplate.Template[0] = "tactical.ruins";
		_properties.LocationTemplate.Fortification = ::Const.Tactical.FortificationType.Walls;
		_properties.LocationTemplate.OwnedByFaction = ::Const.Faction.Player;
		_properties.LocationTemplate.CutDownTrees = true;
		_properties.LocationTemplate.AdditionalRadius = 4;
		_properties.PlayerDeploymentType = ::Const.Tactical.DeploymentType.Center;
		_properties.EnemyDeploymentType = ::Const.Tactical.DeploymentType.Circle;
		_properties.Music = ::Const.Music.UndeadTracks;

		for( local i = 0; i < _properties.Entities.len(); i = ++i )
		{
			_properties.Entities[i].Faction <- f;
		}

		_properties.AfterDeploymentCallback = function ()
		{
			// make the weather a bit bad
			local clouds = ::Tactical.getWeather().createCloudSettings();
			clouds.Type = this.getconsttable().CloudType.Fog;
			clouds.MinClouds = 20;
			clouds.MaxClouds = 20;
			clouds.MinVelocity = 3.0;
			clouds.MaxVelocity = 9.0;
			clouds.MinAlpha = 0.35;
			clouds.MaxAlpha = 0.45;
			clouds.MinScale = 2.0;
			clouds.MaxScale = 3.0;
			::Tactical.getWeather().buildCloudCover(clouds);
			::Tactical.getWeather().setAmbientLightingPreset(5);
			::Tactical.getWeather().setAmbientLightingSaturation(0.9);
		};
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

	function onClear()
	{
	}

});

