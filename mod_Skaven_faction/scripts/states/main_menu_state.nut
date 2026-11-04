this.main_menu_state <- this.inherit("scripts/states/state", {
	m = {
		MainMenuScreen = null,
		MenuStack = null,
		SelectedScenarioID = null,
		SelectedCampaignFileName = null,
		ScenarioManager = null,
		NewCampaignSettings = null,
		IsShown = false,
		IsBooting = true
	},
	function onInit()
	{
		this.m.ScenarioManager <- this.new("scripts/scenarios/scenario_manager");
		this.Const.ScenarioManager <- this.m.ScenarioManager;
		this.m.MenuStack <- this.new("scripts/ui/global/menu_stack");
		this.m.MenuStack.setEnviroment(this);
		this.m.MainMenuScreen <- this.new("scripts/ui/screens/menu/main_menu_screen");
		this.m.MainMenuScreen.setOnScreenShownListener(this.main_menu_screen_onScreenShown.bindenv(this));
		this.m.MainMenuScreen.setOnConnectedListener(this.main_menu_screen_onConnected.bindenv(this));
		local mainMenuModule = this.m.MainMenuScreen.getMainMenuModule();

		if (!this.isScenarioDemo())
		{
			mainMenuModule.setOnNewCampaignPressedListener(this.main_menu_module_onNewCampaignPressed.bindenv(this));
			mainMenuModule.setOnLoadCampaignPressedListener(this.main_menu_module_onLoadCampaignPressed.bindenv(this));
		}

		mainMenuModule.setOnScenariosPressedListener(this.main_menu_module_onScenariosPressed.bindenv(this));
		mainMenuModule.setOnOptionsPressedListener(this.main_menu_module_onOptionsPressed.bindenv(this));
		mainMenuModule.setOnCreditsPressedListener(this.main_menu_module_onCreditsPressed.bindenv(this));
		mainMenuModule.setOnQuitPressedListener(this.main_menu_module_onQuitPressed.bindenv(this));
		local loadCampaignMenuModule = this.m.MainMenuScreen.getLoadCampaignMenuModule();
		loadCampaignMenuModule.setOnLoadButtonPressedListener(this.campaign_menu_module_onLoadPressed.bindenv(this));
		loadCampaignMenuModule.setOnCancelButtonPressedListener(this.campaign_menu_module_onCancelPressed.bindenv(this));
		local newCampaignMenuModule = this.m.MainMenuScreen.getNewCampaignMenuModule();
		newCampaignMenuModule.setOnStartButtonPressedListener(this.campaign_menu_module_onStartPressed.bindenv(this));
		newCampaignMenuModule.setOnCancelButtonPressedListener(this.campaign_menu_module_onCancelPressed.bindenv(this));
		local scenarioMenuModule = this.m.MainMenuScreen.getScenarioMenuModule();
		scenarioMenuModule.setOnPlayButtonPressedListener(this.scenario_menu_module_onPlayPressed.bindenv(this));
		scenarioMenuModule.setOnCancelButtonPressedListener(this.scenario_menu_module_onCancelPressed.bindenv(this));
		scenarioMenuModule.setOnQueryDataListener(this.scenario_menu_module_onQueryData.bindenv(this));
		local optionsMenuModule = this.m.MainMenuScreen.getOptionsMenuModule();
		optionsMenuModule.setOnOkButtonPressedListener(this.options_menu_module_onOkPressed.bindenv(this));
		optionsMenuModule.setOnCancelButtonPressedListener(this.options_menu_module_onCancelPressed.bindenv(this));
		local creditsModule = this.m.MainMenuScreen.getCreditsModule();
		creditsModule.setOnDoneListener(this.credits_module_onDone.bindenv(this));
		this.m.MainMenuScreen.connect();
		this.initLoadingScreenHandler();
		this.show();
	}

	function main_menu_screen_onConnected()
	{
		if (this.isScenarioDemo())
		{
			this.m.MainMenuScreen.setScenarioDemoModus();
		}

		this.m.MainMenuScreen.getNewCampaignMenuModule().setBanners(this.Const.PlayerBanners);
		this.m.MainMenuScreen.getNewCampaignMenuModule().setStartingScenarios(this.m.ScenarioManager.getScenariosForUI());
		this.m.MainMenuScreen.getNewCampaignMenuModule().setCrusadeCampaignAvailable(this.Const.DLC.Desert);
	}

	function onFinish()
	{
		this.m.MenuStack.destroy();
		this.m.MenuStack = null;
		this.m.MainMenuScreen.destroy();
		this.m.MainMenuScreen = null;
	}

	function onShow()
	{
		this.Sound.stopAmbience();
		this.Music.setTrackList(this.Const.Music.MenuTracks, this.Const.Music.CrossFadeTime + 2000);
		this.World.getPlayerRoster().clear();
		this.Cursor.setCursor(this.Const.UI.Cursor.Hand);
		local vm = this.Settings.getVideoMode();
		local animate = this.m.IsBooting && vm.Width >= 1920 && vm.Height >= 1080;
		this.m.IsBooting = false;
		this.m.MainMenuScreen.show(animate);
		this.LoadingScreen.hide();

		if (!this.m.IsShown)
		{
			this.m.IsShown = true;
		}
		else
		{
			this.storeStatistics();
		}
	}

	function onHide()
	{
		this.m.MainMenuScreen.hide();
	}

	function onSiblingAdded( _stateName )
	{
		if (_stateName == "TacticalState")
		{
			local tacticalState = this.RootState.get(_stateName);

			if (tacticalState != null)
			{
				switch(this.m.SelectedScenarioID)
				{
				case 0:
					tacticalState.setScenario(this.new("scripts/scenarios/tactical/scenario_combat_basics"));
					break;

				case 1:
					tacticalState.setScenario(this.new("scripts/scenarios/tactical/scenario_swipe"));
					break;

				case 2:
					tacticalState.setScenario(this.new("scripts/scenarios/tactical/scenario_defend_the_hill"));
					break;

				case 3:
					tacticalState.setScenario(this.new("scripts/scenarios/tactical/scenario_advanced_combat"));
					break;

				case 4:
					tacticalState.setScenario(this.new("scripts/scenarios/tactical/scenario_early_game"));
					break;

				case 6:
					tacticalState.setScenario(this.new("scripts/scenarios/tactical/scenario_line_battle"));
					break;

				case 7:
					tacticalState.setScenario(this.new("scripts/scenarios/tactical/scenario_vampire_hunt"));
					break;

				case 8:
					tacticalState.setScenario(this.new("scripts/scenarios/tactical/scenario_canyon"));
					break;

				case 9:
					tacticalState.setScenario(this.new("scripts/scenarios/tactical/scenario_line_battle_orcs"));
					break;

				case 10:
					tacticalState.setScenario(this.new("scripts/scenarios/tactical/scenario_line_battle_goblins"));
					break;

				case 13:
					tacticalState.setScenario(this.new("scripts/scenarios/tactical/scenario_wolfriders"));
					break;

				case 14:
					tacticalState.setScenario(this.new("scripts/scenarios/tactical/scenario_line_battle_lindwurm"));
					break;

				case 15:
					tacticalState.setScenario(this.new("scripts/scenarios/tactical/scenario_ghouls"));
					break;

				case 16:
					tacticalState.setScenario(this.new("scripts/scenarios/tactical/scenario_archers"));
					break;

				case 20:
					tacticalState.setScenario(this.new("scripts/scenarios/tactical/scenario_test_bed"));
					break;

				case 21:
					tacticalState.setScenario(this.new("scripts/scenarios/tactical/scenario_test_bed_orc"));
					break;

				case 22:
					tacticalState.setScenario(this.new("scripts/scenarios/tactical/scenario_test_bed_human"));
					break;

				case 23:
					tacticalState.setScenario(this.new("scripts/scenarios/tactical/scenario_skaven"));
					break;

				default:
					tacticalState.setScenario(this.new("scripts/scenarios/tactical/scenario_combat_basics"));
					break;
				}
			}
		}
		else if (_stateName == "WorldState")
		{
			local worldState = this.RootState.get(_stateName);

			if (worldState != null)
			{
				if (this.m.SelectedCampaignFileName != null)
				{
					worldState.setCampaignToLoadFileName(this.m.SelectedCampaignFileName);
					this.m.SelectedCampaignFileName = null;
				}
				else if (this.m.NewCampaignSettings != null)
				{
					worldState.setNewCampaignSettings(this.m.NewCampaignSettings);
					this.m.NewCampaignSettings = null;
				}
			}
		}
	}

	function onSiblingSentMessage( _stateName, _message )
	{
		this.logDebug("ScenarioState::onSiblingSentMessage(" + _stateName + " : " + _message + ");");

		if ((_stateName == "TacticalState" || _stateName == "WorldState") && _message == "AboutToFinish" || _message == "ExitToMenu" || _message == "QuitToMenu")
		{
			this.initLoadingScreenHandler();
			this.show();
		}
	}

	function onMouseInput( _mouse )
	{
		if (_mouse.getID() == 6)
		{
			this.Cursor.setPosition(_mouse.getX(), _mouse.getY());
		}

		if (this.m.MainMenuScreen != null && (!this.m.MainMenuScreen.isVisible() || this.m.MainMenuScreen.isAnimating()))
		{
			return true;
		}

		return false;
	}

	function onKeyInput( _key )
	{
		if (_key.getState() == 0)
		{
			if (!this.isKeyInputPermitted())
			{
				return true;
			}

			if (_key.getKey() == 41)
			{
				if (this.m.MenuStack.pop())
				{
					return true;
				}

				this.finish();
				return true;
			}
		}

		return false;
	}

	function isKeyInputPermitted()
	{
		if (this.m.MainMenuScreen != null && (!this.m.MainMenuScreen.isVisible() || this.m.MainMenuScreen.isAnimating()))
		{
			return false;
		}

		if (this.isInLoadingScreen())
		{
			return false;
		}

		return true;
	}

	function initLoadingScreenHandler()
	{
		this.LoadingScreen.clearEventListener();
		this.LoadingScreen.setOnScreenShownListener(this.loading_screen_onScreenShown.bindenv(this));
		this.LoadingScreen.setOnQueryDataListener(this.loading_screen_onQueryData.bindenv(this));
	}

	function isInLoadingScreen()
	{
		if (this.LoadingScreen != null && (this.LoadingScreen.isAnimating() || this.LoadingScreen.isVisible()))
		{
			return true;
		}

		return false;
	}

	function loading_screen_onScreenShown()
	{
		this.m.MenuStack.popAll();

		if (this.m.SelectedScenarioID < 100)
		{
			this.RootState.add("TacticalState", "scripts/states/tactical_state");
		}
		else if (!this.isScenarioDemo())
		{
			this.RootState.add("WorldState", "scripts/states/world_state");
		}

		this.hide();
	}

	function loading_screen_onQueryData()
	{
		return {
			imagePath = this.Const.LoadingScreens[this.Math.rand(0, this.Const.LoadingScreens.len() - 1)],
			text = this.Const.TipOfTheDay[this.Math.rand(0, this.Const.TipOfTheDay.len() - 1)]
		};
	}

	function main_menu_screen_onScreenShown()
	{
		this.sendMessageToSiblings("FullyLoaded");
	}

	function main_menu_module_onNewCampaignPressed()
	{
		this.m.MainMenuScreen.showNewCampaignMenu();
		this.m.MenuStack.push(function ()
		{
			this.m.MainMenuScreen.hideNewCampaignMenu();
		}, function ()
		{
			return !this.m.MainMenuScreen.isAnimating();
		});
	}

	function main_menu_module_onLoadCampaignPressed()
	{
		this.m.MainMenuScreen.showLoadCampaignMenu();
		this.m.MenuStack.push(function ()
		{
			this.m.MainMenuScreen.hideLoadCampaignMenu();
		}, function ()
		{
			return !this.m.MainMenuScreen.isAnimating();
		});
	}

	function main_menu_module_onScenariosPressed()
	{
		this.m.MainMenuScreen.showScenarioMenu();
		this.m.MenuStack.push(function ()
		{
			this.m.MainMenuScreen.hideScenarioMenu();
		}, function ()
		{
			return !this.m.MainMenuScreen.isAnimating();
		});
	}

	function main_menu_module_onOptionsPressed()
	{
		this.m.MainMenuScreen.showOptionsMenu();
		this.m.MenuStack.push(function ()
		{
			this.m.MainMenuScreen.hideOptionsMenu();
		}, function ()
		{
			return !this.m.MainMenuScreen.isAnimating();
		});
	}

	function main_menu_module_onCreditsPressed()
	{
		this.m.MainMenuScreen.showCredits();
		this.m.MenuStack.push(function ()
		{
			this.m.MainMenuScreen.hideCredits();
		}, function ()
		{
			return !this.m.MainMenuScreen.isAnimating();
		});
	}

	function credits_module_onDone()
	{
		this.m.MenuStack.pop();
	}

	function main_menu_module_onQuitPressed()
	{
		this.finish();
	}

	function campaign_menu_module_onStartPressed( _settings )
	{
		this.m.NewCampaignSettings = _settings;
		this.m.NewCampaignSettings.StartingScenario = this.m.NewCampaignSettings.StartingScenario == "scenario.random" ? this.m.ScenarioManager.getRandomScenario() : this.m.ScenarioManager.getScenario(this.m.NewCampaignSettings.StartingScenario);

		if (this.m.NewCampaignSettings.StartingScenario == null)
		{
			this.m.NewCampaignSettings.StartingScenario = this.m.ScenarioManager.getScenario("scenario.tutorial");
		}

		this.m.SelectedScenarioID = 999;
		this.LoadingScreen.show();
	}

	function campaign_menu_module_onLoadPressed( _campaignFileName )
	{
		if (!this.isKeyInputPermitted)
		{
			this.logWarning("Экран загрузки кампании виден не полностью. Минутку!");
			return;
		}

		this.m.SelectedScenarioID = 999;
		this.m.SelectedCampaignFileName = _campaignFileName;
		this.LoadingScreen.show();
	}

	function campaign_menu_module_onCancelPressed()
	{
		this.m.MenuStack.pop();
	}

	function scenario_menu_module_onPlayPressed( _scenarioId )
	{
		if (!this.isKeyInputPermitted)
		{
			this.logWarning("Экран сценария виден не полностью. Минутку!");
			return;
		}

		this.m.SelectedScenarioID = _scenarioId;
		this.LoadingScreen.show();
	}

	function scenario_menu_module_onCancelPressed()
	{
		this.m.MenuStack.pop();
	}

	function scenario_menu_module_onQueryData()
	{
		local result = [
			{
				id = 0,
				name = "Основы боя",
				description = "[p=c][img]gfx/ui/events/event_28.png[/img][/p]\n[p=c]Сценарий обучения основам боя. Низкая сложность.[/p]"
			},
			{
				id = 1,
				name = "Стычка",
				description = "[p=c][img]gfx/ui/events/event_133.png[/img][/p]\n[p=c]Несколько простых соперников на карте с разнообразной местностью, ограничивающей обзор. Подходит для ознакомления с линией видимости, туманом войны и дальним боем. Низкая сложность.[/p]"
			},
			{
				id = 4,
				name = "Ранняя игра",
				description = "[p=c][img]gfx/ui/events/event_09.png[/img][/p]\n[p=c]Вероятная стычка из ранней игры с соответствующими противниками и снаряжением. Средняя сложность.[/p]"
			},
			{
				id = 15,
				name = "Царь горы",
				description = "[p=c][img]gfx/ui/events/event_22.png[/img][/p]\n[p=c]Продержитесь против бесчисленных врагов, укрепившись на вершине холма. Подходит для ознакомления с преимуществами высоты, ее влияния на видимость и другие аспекты. Высокая сложность.[/p]"
			},
			{
				id = 6,
				name = "Линия фронта (Нежить)",
				description = "[p=c][img]gfx/ui/events/event_143.png[/img][/p]\n[p=c]Бой двух построений друг против друга в ближнем бою. Высокая сложность.[/p]"
			},
			{
				id = 9,
				name = "Линия фронта (Орки)",
				description = "[p=c][img]gfx/ui/events/event_49.png[/img][/p]\n[p=c]ОРКИ, ОРКИ, ОРКИ! Высокая сложность.[/p]"
			},
			{
				id = 10,
				name = "Линия фронта (Гоблины)",
				description = "[p=c][img]gfx/ui/events/event_48.png[/img][/p]\n[p=c]Бой двух построений друг против друга в ближнем бою. Высокая сложность.[/p]"
			},
			{
				id = 13,
				name = "Волчьи всадники",
				description = "[p=c][img]gfx/ui/events/event_60.png[/img][/p]\n[p=c]Защищайтесь от своры злобных гоблинов-всадников. Не позвольте им окружить себя! Средняя сложность.[/p]"
			},
			{
				id = 3,
				name = "Прогулка по лесам",
				description = "[p=c][img]gfx/ui/events/event_127.png[/img][/p]\n[p=c]Возможный вариант поздней игры в окружении врагов. Высокая сложность.[/p]"
			},
            {
                id = 23,
                name = "Битва со скавенами",
                description = "[p=c][img]gfx/ui/events/event_127.png[/img][/p]\n[p=c]Возможный вариант поздней игры в окружении врагов. Высокая сложность.[/p]"
            }
		];

		if (!this.isReleaseBuild())
		{
			result.push({
				id = 20,
				name = "Тест",
				description = "[p=c]Пустая карта для проверки ИИ. Расставьте бойцов вручную и дайте им сразиться.[/p]"
			});
		}

		return result;
	}

	function options_menu_module_onOkPressed()
	{
		this.m.MenuStack.pop();
	}

	function options_menu_module_onCancelPressed()
	{
		this.m.MenuStack.pop();
	}

});

