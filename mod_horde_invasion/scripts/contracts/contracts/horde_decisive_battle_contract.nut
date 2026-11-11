this.horde_decisive_battle_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Destination = null,
		Warcamp = null,
		WarcampTile = null,
		Dude = null,
		IsPlayerAttacking = false
	},
	function create()
	{
		this.contract.create();
		local r = this.Math.rand(1, 100);

		if (r <= 70)
		{
			this.m.DifficultyMult = this.Math.rand(95, 105) * 0.01;
		}
		else
		{
			this.m.DifficultyMult = this.Math.rand(115, 135) * 0.01;
		}

		this.m.Type = "contract.horde_decisive_battle";
		this.m.Name = "Решающая битва";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	// Ближайший стан орды (Jurchen + Mgl, TZ §4) к заданному тайлу.
	function getNearestHordeSettlement( _tile )
	{
		local lowest_distance = 99999;
		local best;
		local factions = [
			this.World.FactionManager.getFactionOfType(this.Const.FactionType.Jurchen),
			this.World.FactionManager.getFactionOfType(this.Const.FactionType.Mgl)
		];

		foreach( f in factions )
		{
			foreach( s in f.getSettlements() )
			{
				local d = s.getTile().getDistanceTo(_tile);

				if (d < lowest_distance)
				{
					lowest_distance = d;
					best = s;
				}
			}
		}

		return best;
	}

	function start()
	{
		if (this.m.Home == null)
		{
			this.setHome(this.World.State.getCurrentTown());
		}

		if (this.m.WarcampTile == null)
		{
			local best_settlement = this.getNearestHordeSettlement(this.m.Home.getTile());
			this.m.WarcampTile = this.m.Home.getTile().getTileBetweenThisAnd(best_settlement.getTile());
			this.m.Flags.set("HordeFaction", best_settlement.getFaction());
		}

		this.m.Flags.set("CommanderName", this.Const.Strings.KnightNames[this.Math.rand(0, this.Const.Strings.KnightNames.len() - 1)]);
		this.m.Payment.Pool = 1600 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();
		local r = this.Math.rand(1, 2);

		if (r == 1)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else if (r == 2)
		{
			this.m.Payment.Completion = 1.0;
		}

		this.m.Flags.set("RequisitionCost", this.beautifyNumber(this.m.Payment.Pool * 0.25));
		this.m.Flags.set("Bribe", this.beautifyNumber(this.m.Payment.Pool * 0.35));
		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Отправиться в военный лагерь. %commander% ждёт вашего доклада",
					"Помочь войску нанимателя в решающей битве против Железной Орды"
				];

				if (this.Math.rand(1, 100) <= this.Const.Contracts.Settings.IntroChance)
				{
					this.Contract.setScreen("Intro");
				}
				else
				{
					this.Contract.setScreen("Task");
				}
			}

			function end()
			{
				this.World.Assets.addMoney(this.Contract.m.Payment.getInAdvance());

				if (this.Contract.m.WarcampTile == null)
				{
					local best_settlement = this.Contract.getNearestHordeSettlement(this.Contract.m.Home.getTile());
					this.Contract.m.WarcampTile = this.Contract.m.Home.getTile().getTileBetweenThisAnd(best_settlement.getTile());
				}

				local tile = this.Contract.getTileToSpawnLocation(this.Contract.m.WarcampTile, 1, 12, [
					this.Const.World.TerrainType.Shore,
					this.Const.World.TerrainType.Ocean,
					this.Const.World.TerrainType.Mountains,
					this.Const.World.TerrainType.Forest,
					this.Const.World.TerrainType.LeaveForest,
					this.Const.World.TerrainType.SnowyForest,
					this.Const.World.TerrainType.AutumnForest,
					this.Const.World.TerrainType.Swamp
				], false, false, true);
				tile.clear();
				this.Contract.m.WarcampTile = tile;
				this.Contract.m.Warcamp = this.WeakTableRef(this.World.spawnLocation("scripts/entity/world/locations/noble_camp_location", tile.Coords));
				this.Contract.m.Warcamp.onSpawned();
				this.Contract.m.Warcamp.getSprite("banner").setBrush(this.World.FactionManager.getFaction(this.Contract.getFaction()).getBannerSmall());
				this.Contract.m.Warcamp.setFaction(this.Contract.getFaction());
				this.Contract.m.Warcamp.setDiscovered(true);
				this.World.uncoverFogOfWar(this.Contract.m.Warcamp.getTile().Pos, 500.0);
				local r = this.Math.rand(1, 100);

				if (r <= 40)
				{
					this.Flags.set("IsScoutsSighted", true);
				}
				else
				{
					this.Flags.set("IsRequisitionSupplies", true);
					r = this.Math.rand(1, 100);

					if (r <= 33)
					{
						this.Flags.set("IsAmbush", true);
					}
					else if (r <= 66)
					{
						this.Flags.set("IsUnrulyFarmers", true);
					}
					else
					{
						this.Flags.set("IsCooperativeFarmers", true);
					}
				}

				// Ветка «перехват обоза» (из ванильного decisive_battle, адаптирована):
				// в оригинале обоз шёл между городами — понятно, где его ждать. Станов
				// орды игрок не знает, поэтому караван спавнится в открытой окрестности
				// военного лагеря и идёт в самый дальний стан, что дальше, чем игрок
				// от точки спавна — перехватывать его нужно в погоне (см. сцену
				// InterceptSupplies). Ветка активна, только если у орды есть стан.
				local hordeSettlements = [];

				foreach( f in [
					this.World.FactionManager.getFactionOfType(this.Const.FactionType.Jurchen),
					this.World.FactionManager.getFactionOfType(this.Const.FactionType.Mgl)
				] )
				{
					hordeSettlements.extend(f.getSettlements());
				}

				r = this.Math.rand(1, 100);

				if (r <= 40 && hordeSettlements.len() >= 1)
				{
					this.Flags.set("IsInterceptSupplies", true);
				}
				else if (r <= 80)
				{
					this.Flags.set("IsDeserters", true);
				}

				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Отправиться в военный лагерь. %commander% ждёт вашего доклада"
				];

				if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
				{
					this.Contract.m.Warcamp.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Warcamp) && !this.Flags.get("IsWarcampDay1Shown"))
				{
					this.Flags.set("IsWarcampDay1Shown", true);
					this.Contract.setScreen("WarcampDay1");
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "Running_WaitForNextDay",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Подождать в военном лагере, пока ваши услуги не понадобятся"
				];

				if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
				{
					this.Contract.m.Warcamp.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Warcamp))
				{
					if (this.World.getTime().Days > this.Flags.get("LastDay"))
					{
						if (this.Flags.get("NextDay") == 2)
						{
							this.Contract.setScreen("WarcampDay2");
						}
						else
						{
							this.Contract.setScreen("WarcampDay3");
						}

						this.World.Contracts.showActiveContract();
					}
				}
			}

		});
		this.m.States.push({
			ID = "Running_Scouts",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Перехватить разведчиков орды, замеченных к %direction% от лагеря",
					"Не дать им уйти живыми"
				];

				if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
				{
					this.Contract.m.Warcamp.getSprite("selection").Visible = false;
				}

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
					this.Contract.m.Destination.setOnCombatWithPlayerCallback(this.onCombatWithScouts.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Destination == null || this.Contract.m.Destination.isNull())
				{
					if (this.Flags.get("IsScoutsFailed"))
					{
						this.Contract.setScreen("ScoutsEscaped");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("ScoutsCaught");
						this.World.Contracts.showActiveContract();
					}
				}
				else if (this.Flags.get("IsScoutsRetreat"))
				{
					this.Flags.set("IsScoutsRetreat", false);
					this.Contract.m.Destination.die();
					this.Contract.m.Destination = null;
					this.Contract.setScreen("ScoutsEscaped");
					this.World.Contracts.showActiveContract();
				}
			}

			function onCombatWithScouts( _dest, _isPlayerAttacking = true )
			{
				local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
				properties.CombatID = "Scouts";
				properties.Music = this.Const.Music.JinTracks;
				// у фракций Jin/Mgl getBannerSmall() ванильно возвращает "" (не
				// переопределён) — баннер берём от ближайшего стана орды
				properties.EnemyBanners = [
					this.Contract.getNearestHordeSettlement(this.World.State.getPlayer().getTile()).getBanner()
				];
				this.World.Contracts.startScriptedCombat(properties, _isPlayerAttacking, true, true);
			}

			function onActorRetreated( _actor, _combatID )
			{
				if (_combatID == "Scouts")
				{
					this.Flags.set("IsScoutsFailed", true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Scouts")
				{
					this.Flags.set("IsScoutsRetreat", true);
				}
			}

		});
		this.m.States.push({
			ID = "Running_ReturnAfterScouts",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Вернуться в военный лагерь"
				];

				if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
				{
					this.Contract.m.Warcamp.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Warcamp) && !this.Flags.get("IsReportAfterScoutsShown"))
				{
					this.Flags.set("IsReportAfterScoutsShown", true);
					this.Contract.setScreen("WarcampDay1End");
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "Running_Requisition",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Добыть припасы в местечке %objective% к %direction% от лагеря"
				];

				if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
				{
					this.Contract.m.Warcamp.getSprite("selection").Visible = false;
				}

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Destination) && !this.TempFlags.get("IsReportAfterRequisitionShown"))
				{
					this.TempFlags.set("IsReportAfterRequisitionShown", true);
					this.Contract.setScreen("RequisitionSupplies2");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsRequisitionRetreat") && !this.Flags.get("IsRequisitionCombatDone"))
				{
					this.Flags.set("IsRequisitionCombatDone", true);
					this.Contract.setScreen("BeatenByFarmers");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsRequisitionVictory") && !this.Flags.get("IsRequisitionCombatDone"))
				{
					this.Flags.set("IsRequisitionCombatDone", true);
					this.Contract.setScreen("PoorFarmers");
					this.World.Contracts.showActiveContract();
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Ambush" || _combatID == "TakeItByForce")
				{
					this.Flags.set("IsRequisitionRetreat", true);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "Ambush" || _combatID == "TakeItByForce")
				{
					this.Flags.set("IsRequisitionVictory", true);
				}
			}

		});
		this.m.States.push({
			ID = "Running_ReturnAfterRequisition",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Вернуться в военный лагерь"
				];

				if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
				{
					this.Contract.m.Warcamp.getSprite("selection").Visible = true;
				}

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Warcamp))
				{
					if (this.Flags.get("IsInterceptSupplies") || this.Flags.get("IsDeserters"))
					{
						this.Contract.setScreen("WarcampDay1End");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("WarcampDay2End");
						this.World.Contracts.showActiveContract();
					}
				}
			}

		});
		this.m.States.push({
			ID = "Running_InterceptSupplies",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Догнать и уничтожить обоз орды, идущий к стану %supply_dest%"
				];

				if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
				{
					this.Contract.m.Warcamp.getSprite("selection").Visible = false;
				}

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
					this.Contract.m.Destination.setVisibleInFogOfWar(true);
				}
			}

			function update()
			{
				if (this.Flags.get("IsInterceptSuppliesSuccess"))
				{
					this.Contract.setScreen("SuppliesIntercepted");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.m.Destination == null || this.Contract.m.Destination != null && this.Contract.m.Destination.isNull())
				{
					this.Flags.set("IsInterceptSuppliesFailure", true);
					this.Contract.setScreen("SuppliesReachedEnemy");
					this.World.Contracts.showActiveContract();
				}
			}

			function onPartyDestroyed( _party )
			{
				if (_party.getFlags().has("ContractSupplies"))
				{
					this.Flags.set("IsInterceptSuppliesSuccess", true);
				}
			}

		});
		this.m.States.push({
			ID = "Running_ReturnAfterIntercept",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Вернуться в военный лагерь"
				];

				if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
				{
					this.Contract.m.Warcamp.getSprite("selection").Visible = true;
				}

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = false;
				}
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Warcamp))
				{
					this.Contract.setScreen("WarcampDay2End");
					this.World.Contracts.showActiveContract();
				}
			}

		});
		this.m.States.push({
			ID = "Running_Deserters",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Идти по следу и догнать дезертиров",
					"Убедить их вернуться или убейте"
				];

				if (this.Contract.m.Warcamp != null && !this.Contract.m.Warcamp.isNull())
				{
					this.Contract.m.Warcamp.getSprite("selection").Visible = false;
				}

				if (this.Contract.m.Destination != null && !this.Contract.m.Destination.isNull())
				{
					this.Contract.m.Destination.getSprite("selection").Visible = true;
				}
			}

			function update()
			{
				if (this.Flags.get("IsDesertersFailed"))
				{
					if (this.Contract.m.Destination != null)
					{
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
					}

					this.Contract.setState("Running_ReturnAfterIntercept");
				}
				else if (this.Contract.m.Destination == null || this.Contract.m.Destination != null && this.Contract.m.Destination.isNull())
				{
					this.Contract.setScreen("DesertersAftermath");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Contract.isPlayerNear(this.Contract.m.Destination, this.Const.World.CombatSettings.CombatPlayerDistance / 2) && !this.TempFlags.get("IsDeserterApproachShown"))
				{
					this.TempFlags.set("IsDeserterApproachShown", true);
					this.Contract.setScreen("Deserters2");
					this.World.Contracts.showActiveContract();
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "Deserters")
				{
					this.Flags.set("IsDesertersFailed", true);
				}
			}

		});
		this.m.States.push({
			ID = "Running_FinalBattle",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Выиграть решающую битву против Железной Орды"
				];
			}

			function update()
			{
				if (this.Flags.get("IsFinalBattleLost") && !this.Flags.get("IsFinalBattleLostShown"))
				{
					this.Flags.set("IsFinalBattleLostShown", true);
					this.Contract.m.Warcamp.die();
					this.Contract.m.Warcamp = null;
					this.Contract.setScreen("BattleLost");
					this.World.Contracts.showActiveContract();
				}
				else if (this.Flags.get("IsFinalBattleWon") && !this.Flags.get("IsFinalBattleWonShown"))
				{
					this.Flags.set("IsFinalBattleWonShown", true);
					this.Contract.m.Warcamp.die();
					this.Contract.m.Warcamp = null;
					this.Contract.setScreen("BattleWon");
					this.World.Contracts.showActiveContract();
				}
				else if (!this.TempFlags.get("IsFinalBattleStarted"))
				{
					this.TempFlags.set("IsFinalBattleStarted", true);
					local tile = this.Contract.getTileToSpawnLocation(this.Contract.m.Warcamp.getTile(), 3, 12, [
						this.Const.World.TerrainType.Shore,
						this.Const.World.TerrainType.Ocean,
						this.Const.World.TerrainType.Mountains,
						this.Const.World.TerrainType.Forest,
						this.Const.World.TerrainType.LeaveForest,
						this.Const.World.TerrainType.SnowyForest,
						this.Const.World.TerrainType.AutumnForest,
						this.Const.World.TerrainType.Swamp,
						this.Const.World.TerrainType.Hills
					], false);
					this.World.State.getPlayer().setPos(tile.Pos);
					this.World.getCamera().moveToPos(this.World.State.getPlayer().getPos());
					local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
					p.CombatID = "FinalBattle";
					p.Music = this.Const.Music.JinTracks;
					p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.Entities = [];
					p.AllyBanners = [
						this.World.Assets.getBanner(),
						this.World.FactionManager.getFaction(this.Contract.getFaction()).getBannerSmall()
					];
					// у фракций Jin/Mgl getBannerSmall() ванильно возвращает "" (не
					// переопределён) — баннер берём от ближайшего стана орды
					p.EnemyBanners = [
						this.Contract.getNearestHordeSettlement(this.World.State.getPlayer().getTile()).getBanner()
					];
					local allyStrength = 90;

					if (this.Flags.get("IsRequisitionFailure"))
					{
						allyStrength = allyStrength - 20;
					}

					if (this.Flags.get("IsDesertersFailed"))
					{
						allyStrength = allyStrength - 20;
					}

					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, allyStrength * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getFaction());
					p.Entities.push({
						ID = this.Const.EntityType.Knight,
						Variant = 0,
						Row = 2,
						Script = "scripts/entity/tactical/humans/knight",
						Faction = this.Contract.getFaction(),
						Callback = this.Contract.onCommanderPlaced.bindenv(this.Contract)
					});
					local enemyStrength = 150;

					if (this.Flags.get("IsScoutsFailed"))
					{
						enemyStrength = enemyStrength + 25;
					}

					if (this.Flags.get("IsInterceptSuppliesFailure"))
					{
						enemyStrength = enemyStrength + 25;
					}

					local hordeFaction = this.Flags.get("HordeFaction");
					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.HordeRaiders, enemyStrength * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), hordeFaction);
					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.HordeRoamers, 60 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), hordeFaction);
					p.Entities.push({
						ID = this.Const.EntityType.HordeGeneral,
						Variant = this.Const.DLC.Wildmen && this.Contract.getDifficultyMult() >= 1.15 ? 1 : 0,
						Name = this.Const.Strings.NomadCenturionNames[this.Math.rand(0, this.Const.Strings.NomadCenturionNames.len() - 1)],
						Row = 2,
						Script = "scripts/entity/tactical/humans/horde_general",
						Faction = hordeFaction,
						Callback = null
					});
					this.Contract.setState("Running_FinalBattle");
					this.World.Contracts.startScriptedCombat(p, false, true, true);
				}
			}

			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID == "FinalBattle")
				{
					this.Flags.set("IsFinalBattleLost", true);
				}
			}

			function onCombatVictory( _combatID )
			{
				if (_combatID == "FinalBattle")
				{
					this.Flags.set("IsFinalBattleWon", true);
				}
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Вернуться в " + this.Contract.m.Home.getName() + " за наградой"
				];
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					this.Contract.setScreen("Success1");
					this.World.Contracts.showActiveContract();
				}
			}

		});
	}

	function createScreens()
	{
		this.importScreens(this.Const.Contracts.NegotiationDefault);
		this.importScreens(this.Const.Contracts.Overview);
		this.m.Screens.push({
			ID = "Task",
			Title = "Переговоры",
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer% стоит над столом, уставленным картами. Чернила размазаны туда-сюда — кто-то, не раздумывая, водил по пергаменту грязным пальцем. Он не поднимает глаз, когда вы входите.%SPEECH_ON%Чурчжэни и их степные подельники. Говорят, у орды есть генерал, что ведёт все их полчища, как единое войско. Вот-вот он приведёт их сюда, и тогда эта карта сгорит вместе со всем, что на ней начерчено.%SPEECH_OFF%Он наконец смотрит на вас.%SPEECH_ON%Я не собираюсь ждать, пока это случится. Моё войско собирается к %direction% отсюда, и мой военачальник %commander% ждёт тех, кто умеет держать клинок. Справишься — плата не обидит.%SPEECH_OFF% | %employer% разглядывает степной колчан, выброшенный на стол, словно окурок в пепельницу. Луки у степняков дальнобойные, стрелы тяжёлые — любой доспех, как бумага.%SPEECH_ON%Орда жрёт всё на своём пути, наёмник. Мне нужны люди, способные ударить ей в зубы. Мой лагерь стоит к %direction% отсюда. Там тебя ждёт %commander%, он расскажет, что делать.%SPEECH_OFF% | %employer% встречает вас у самых дверей, не дав пройти дальше. Из зала слышны крики военачальников — спорят, выстоит ли собранное им войско против орды.%SPEECH_ON%Не буду тратить твоё время и своё. Орда идёт сюда, и я выйду навстречу ей со всеми, кого смог собрать. Лагерь мой стоит к %direction% отсюда. Найди там %commander% и сделай то, за что я тебе плачу.%SPEECH_OFF% | %employer% прижимает к груди тонкую деревянную шкатулку, пока клерк негромко что-то ему нашёптывает. Наконец дворянин кивает и обращается к вам.%SPEECH_ON%Деньги наёмникам. Вот что здесь написано. Деньги наёмникам, потому что чурчжэни выжигают мои земли, а своих людей мне не хватает, чтобы остановить их. Лагерь мой стоит к %direction% отсюда. %commander% объяснит детали. Иди.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "Великая битва, говоришь? Заманчиво.",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Отряд \'%companyname%\' не станет подчиняться чужим приказам. | Я вынужден отказаться. | Мы нужны в другом месте.}",
					function getResult()
					{
						this.World.Contracts.removeContract(this.Contract);
						return 0;
					}

				}
			],
			function start()
			{
			}

		});
		this.m.Screens.push({
			ID = "WarcampDay1",
			Title = "В военном лагере...",
			Text = "[img]gfx/ui/events/event_96.png[/img]{Военный лагерь раскинулся шире многих городков: ряды палаток, коновязи, кузницы на колёсах. Люди точат клинки, и от этого звона никуда не деться. Вас провожают к шатру военачальника, где %commander% стоит над картой, утыканной чёрными фишками.%SPEECH_ON%Добро пожаловать, наёмник. Ты пришёл как раз вовремя.%SPEECH_OFF% | Лагерь гудит, как растревоженный улей. Кузнецы куют, лучники меняют тетивы, кто-то молится, а кто-то блюёт в кусты от страха. %commander% лично приветствует вас и ведёт в свой шатёр, где на столе лежат карты и чужеземные стрелы, воткнутые в доски, словно гвозди.%SPEECH_ON%Вот, орда так метает. Рад, что ты пришёл.%SPEECH_OFF% | Сквозь ряды палаток вы пробираетесь к шатру командующего, и повсюду вам попадаются одни и те же глаза — недовольные, напуганные, злые. Один солдат кричит вслед.%SPEECH_ON%Эй, наёмник! Скажи своим людям — чурчжэней не берут в плен!%SPEECH_OFF%%randombrother% спрашивает, откуда тот это знает. Солдат молча закатывает рукав, обнажая руку, изуродованную пороховым ожогом. Больше вопросов нет. В шатре %commander% ждёт вас у карты.%SPEECH_ON%Ты видел моих людей. Они боятся. Это нормально — страх держит в живых. Слушай, что я скажу.%SPEECH_OFF% | Вы находите военачальника за необычным занятием: он в одиночеству играет в кости, кидая их снова и снова и записывая выпавшие числа. Заметив вас, %commander% стирает записи рукавом.%SPEECH_ON%Гадаю на костях, наёмник. Считаю, сколько из нас вернётся. Не смотди так — каждый здесь считает. Чем могу быть полезен?%SPEECH_OFF% | По прибытию в лагерь вы застаёте картину, от которой хмурится даже %randombrother%: солдаты сгребают в кучу и жгут захваченные у степняков вещи — луки, колчаны, развесистые шапки. Дым стоит столбом. %commander% хлопает вас по плечу.%SPEECH_ON%Верим в приметы. Лучше пусть горит их добро, чем наше. Иди за мной, расскажу, что нужно.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Что за поручение у тебя для отряда \'%companyname%\'?",
					function getResult()
					{
						if (this.Flags.get("IsScoutsSighted"))
						{
							return "ScoutsSighted";
						}
						else
						{
							return "RequisitionSupplies1";
						}
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "WarcampDay1End",
			Title = "В военном лагере...",
			Text = "[img]gfx/ui/events/event_96.png[/img]{Возвратившись в военный лагерь, вы приказываете людям отдыхать. Кто знает, что ждёт их завтра — вернее, кто ждёт: чурчжэни не любят ждать. | Поручение выполнено, но за ним наверняка последуют ещё. Нужно отдохнуть, пока есть возможность — и пока лагерь стоит там, где стоял. | Военный лагерь ничуть не изменился со времени вашего ухода. Только вы не уверены, хорошо это или плохо. Завтра будет больше хлопот, так что вы приказываете отряду \'%companyname%\' устраиваться на отдых.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Хорошо отдохните, скоро нас призовут вновь.",
					function getResult()
					{
						this.Flags.set("LastDay", this.World.getTime().Days);
						this.Flags.set("NextDay", 2);
						this.Contract.setState("Running_WaitForNextDay");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ScoutsSighted",
			Title = "В военном лагере...",
			Text = "[img]gfx/ui/events/event_54.png[/img]%commander% вводит вас в курс дела.%SPEECH_ON%{Разведчики степняков шныряют к %direction% отсюда. Лёгкие, быстрые, смотрят в оба. Если хоть один уйдёт — генерал орды узнает, где моё войско и сколько нас. Я не могу этого допустить. Убей их всех. | Наши дозорные заметили чурчжэнских лазутчиков к %direction% от лагеря. Они обшаривают окрестности и насчитывают наши штыки. Ты отправишься туда и убьёшь их, прежде чем они доложат о том, что уже разнюхали. | Степняки-разведчики к %direction% отсюда. Их послал кто-то поумнее — генерал их проклятый. Знаешь, что бывает, когда орда знает, где тебя искать? Она находит. Так что иди и убей их всех. | На войне нет ничего важнее осведомлённости. И недавно я узнал, что лазутчики орды ползают к %direction% отсюда, как вши по швам. Вымети их. Если хоть один уйдёт, генерал соберёт все свои полчища прямо у моих ворот.}%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Отряд выдвинется немедленно.",
					function getResult()
					{
						this.Contract.setState("Running_Scouts");
						return 0;
					}

				}
			],
			function start()
			{
				local playerTile = this.Contract.m.Warcamp.getTile();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 5, 8);
				local hordeFaction = this.World.FactionManager.getFaction(this.Flags.get("HordeFaction"));
				local party = hordeFaction.spawnEntity(tile, "Разведчики орды", false, this.Const.World.Spawn.HordeRoamers, 60 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				local hordeBase = this.Contract.getNearestHordeSettlement(playerTile);
				party.getSprite("banner").setBrush(hordeBase.getBanner());
				party.setDescription("Лёгкие разведчики Железной Орды, высматривающие войско нанимателя.");
				party.setFootprintType(this.Const.World.FootprintsType.Nomads);
				this.Contract.m.UnitsSpawned.push(party);
				party.getLoot().Money = this.Math.rand(50, 100);
				party.getLoot().ArmorParts = this.Math.rand(0, 10);
				party.getLoot().Medicine = this.Math.rand(0, 2);
				party.getLoot().Ammo = this.Math.rand(0, 20);
				local r = this.Math.rand(1, 6);

				if (r == 1)
				{
					party.addToInventory("supplies/bread_item");
				}
				else if (r == 2)
				{
					party.addToInventory("supplies/roots_and_berries_item");
				}
				else if (r == 3)
				{
					party.addToInventory("supplies/dried_fruits_item");
				}
				else if (r == 4)
				{
					party.addToInventory("supplies/ground_grains_item");
				}
				else if (r == 5)
				{
					party.addToInventory("supplies/pickled_mushrooms_item");
				}

				this.Contract.m.Destination = this.WeakTableRef(party);
				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setPivot(this.Contract.m.Warcamp);
				roam.setMinRange(4);
				roam.setMaxRange(9);
				roam.setAllTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
				roam.setTerrain(this.Const.World.TerrainType.Shore, false);
				roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
				c.addOrder(roam);
			}

		});
		this.m.Screens.push({
			ID = "ScoutsEscaped",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{К сожалению, одному или нескольким степнякам удалось ускользнуть. Теперь генерал орды знает, где стоит войско нанимателя. | Проклятье! Несколько лазутчиков сбежали и, без сомнения, уже несут генералу орды весть о том, сколько нас и где мы стоим.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Проклятье!",
					function getResult()
					{
						this.Contract.setState("Running_ReturnAfterScouts");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "ScoutsCaught",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Все разведчики мертвы. Всё, что они разнюхали, умерло вместе с ними. Генерал орды теперь слеп — по крайней мере, до завтра. | Степняки перебиты. Их вести не дойдут до орды, а это значит, что противник будет биться в темноте.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Победа!",
					function getResult()
					{
						this.Contract.setState("Running_ReturnAfterScouts");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "RequisitionSupplies1",
			Title = "В военном лагере...",
			Text = "[img]gfx/ui/events/event_96.png[/img]{%commander% вздыхает и разводит руками.%SPEECH_ON%Я не желаю тратить твои таланты попусту, наёмник, но мне нужен кто-то, кто выйдет из лагеря и добудет припасы. Чурчжэни жгут поля быстрее, чем мы успеваем их собирать, и мои обозы тают на глазах.%SPEECH_OFF%Эй, это не оскорбление — раз уж за это платят. | %commander% прикусывает высохший листок и скрещивает руки на груди.%SPEECH_ON%Знаю, знаю. Ты пришёл сражаться, резать степняков и получать за это хорошие деньги. Но прямо сейчас моё войско голодает, а голодное войско проигрывает чурчжэням ещё до того, как обнажит клинки. Кто-то должен пойти и добыть еды.%SPEECH_OFF%Он подходит к одной из карт и тычет в отметку пальцем.%SPEECH_ON%Ты должен посетить этих крестьян и забрать у них еду. Им известно о твоём приходе, затруднений быть не должно. Считай это лёгкой прогулкой перед битвой, ладно?%SPEECH_OFF% | %commander% постукивает по свитку, лежащему на карте. Сверток весь покрыт цифрами, и чем ниже строчка на пергаменте, тем меньше число.%SPEECH_ON%Запасы на исходе. Обычно мы пополняем их у крестьян к %direction% отсюда. Я хочу, чтобы ты отправился туда и проделал это ещё раз. Крестьяне ждут тебя — бояться тебя, вернее. Так что затруднений быть не должно.%SPEECH_OFF% | Вы разглядываете свою тарелку: ломоть чёрствого хлеба и кусок мяса, наполовину съеденный, наполовину отданный мухам. В углу, сытый и лоснящийся, дрыхнет пёс — видимо, %commander% кормит его лучше, чем войско. Сам военачальник тем временем разглядывает карту.%SPEECH_ON%Чурчжэни перерезали нам два обоза за неделю. У людей кончается еда, а если люди голодные — они не сражаются, а если они не сражаются, орда их просто смахнёт, как мух. Понимаешь?%SPEECH_OFF%Вы киваете. Верный расчёт. Он продолжает.%SPEECH_ON%Мы уже некоторое время берём продовольствие у крестьян к %direction% отсюда. Иди туда и проделай это ещё раз. Один из моих стражников отдаст тебе список того, что забрать. Крестьяне препятствовать не станут — они знают, что бывает с теми, кто препятствует.%SPEECH_OFF% | %commander% встречает вас у котлов, из которых поднимается пар, пахнущий водой и тоской. Повар помешивает похлёбку и смотрит на вас с надеждой, которую вы не можете оправдать.%SPEECH_ON%Видишь, чем нас кормят? А ведь это ещё праздник по сравнению с тем, что ждёт нас через неделю. Так что слушай: мне нужно продовольствие, и много. Крестьяне к %direction% отсюда уже в курсе. Иди и забери всё по списку. И да — не убивай никого без нужды. Мне ещё из этих крестьян людей в ополчение брать.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Отряд выступит в течение часа.",
					function getResult()
					{
						this.Contract.setState("Running_Requisition");
						return 0;
					}

				}
			],
			function start()
			{
				local settlements = this.World.EntityManager.getSettlements();
				local lowest_distance = 99999;
				local best_location;
				local myTile = this.Contract.m.Warcamp.getTile();

				foreach( s in settlements )
				{
					foreach( l in s.getAttachedLocations() )
					{
						if (l.getTypeID() == "attached_location.wheat_fields" || l.getTypeID() == "attached_location.pig_farm")
						{
							local d = myTile.getDistanceTo(l.getTile());

							if (d < lowest_distance)
							{
								lowest_distance = d;
								best_location = l;
							}
						}
					}
				}

				best_location.setActive(true);
				this.Contract.m.Destination = this.WeakTableRef(best_location);
			}

		});
		this.m.Screens.push({
			ID = "RequisitionSupplies2",
			Title = "На хуторе...",
			Text = "[img]gfx/ui/events/event_72.png[/img]{Хутор уже близко. Перед вами расстилаются поля, спелые колосья колышутся от ветра, словно морская гладь. %randombrother% проводит по ним рукой, и %randombrother2% тут же бьёт его кулаком в плечо.%SPEECH_ON%Грабли убери! Пилильщика подцепить захотел?%SPEECH_OFF%Наёмник потирает ушиб, затем отвечает.%SPEECH_ON%Отвали! Моя рука шарит, где захочет — можешь у своей мамочки поинтересоваться.%SPEECH_OFF%Обмен тычками быстро перерастает в драку, разрушая идиллию. | На горизонте уже виден хутор. Спелые колосья колышутся под свежим ветерком, батраки с косами прорубают путь сквозь плотные ряды пшеницы, вспомогательный отряд с вилами собирает солому. Замыкают строй ослы, тянущие телеги по неровной земле. Всё так мирно, что %randombrother% невольно оглядывается — неделю назад подобный хутор сгорел вместе с жатвой, и чурчжэни смеялись. | Хутор раскинулся средь холмов, здешняя земля слишком хороша, чтобы обращать внимание на её неровности. Поля полны урожая и батраков: косы и вилы равномерно поднимаются и опускаются, радостно вспыхивая на солнце. В отдалении вы замечаете землевладельцев, и, хоть они выглядят весьма недовольными, мало кто решится проявить гнев перед строем отряда \'%companyname%\'.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Заберём то, ради чего мы пришли сюда.",
					function getResult()
					{
						if (this.Flags.get("IsAmbush"))
						{
							return "Ambush";
						}
						else if (this.Flags.get("IsUnrulyFarmers"))
						{
							return "UnrulyFarmers";
						}
						else
						{
							return "CooperativeFarmers";
						}
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Ambush",
			Title = "На хуторе...",
			Text = "[img]gfx/ui/events/event_10.png[/img]{Вы уже почти подошли к крестьянам, как вдруг со стороны полей раздаётся рвущийся свист — тяжёлые степные стрелы впиваются в землю вокруг вас. Из колосьев, из канавы, из-за стогов поднимаются чурчжэни. Они прошли вдоль леса и поджидали здесь — это засада! | Подходя к хутору, вы замечаете, что крестьяне бегут прочь, бросая вёдра. %randombrother% обнажает оружие.%SPEECH_ON%Это засада!%SPEECH_OFF%Из заросшей канавы, обтекая поля, выходят цепи степняков — лёгкие лучники и железные латники позади них. Орда выследила обоз с продовольствием и пришла перерезать его. | Вы подходите к телегам с продовольствием и сдёргиваете полотно с одной из повозок. Внутри пусто. Внезапно в борт телеги с глухим стуком впивается стрела с развесистым оперением. Крестьяне с воплями разбегаются, а на их место из-за сенокосов выходят чурчжэни с тлеющими фитилями бомбард. Это засада!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "К оружию!",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "Ambush";
						p.Music = this.Const.Music.JinTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						p.Entities = [];
						local hordeBase = this.Contract.getNearestHordeSettlement(this.World.State.getPlayer().getTile());
						p.EnemyBanners = [
							hordeBase.getBanner()
						];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.HordeRoamers, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Jurchen).getID());
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.HordeRaiders, 40 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.World.FactionManager.getFactionOfType(this.Const.FactionType.Mgl).getID());
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "UnrulyFarmers",
			Title = "На хуторе...",
			Text = "[img]gfx/ui/events/event_43.png[/img]Вы приближаетесь к крестьянам, но они не обращают на вас особого внимания. Староста, скрестив руки на груди, качает головой.%SPEECH_ON%{Смотри, мои ребята уже погрузили всё в телеги. Но и ты пойди мне навстречу. Нам нужно кормить семьи, да и чурчжэней никто не отменял — они тоже от нас требуют. Как насчёт справедливой сделки: ты платишь нам %cost% крон, а военачальник получит то, что ему нужно. | Вы же наёмники, верно? Тогда ты побольше прочих понимаешь ценность золота. Мы простые крестьяне, а не ростовщики. Всё, что мы просим, — небольшое вознаграждение за нашу работу. Заплати нам %cost% крон, и мы отдадим тебе еду. Мы всё равно останемся в убытке, но это хоть сколько-то справедливо. | Ты пришёл сюда с надраенным оружием и думаешь, что этого достаточно, дабы согнуть нас в бараний рог? Военачальник и так забрал почти всё, а теперь ещё и чурчжэни пожаловали — жгут, грабят, требуют дань. И вот что я скажу: пришла пора платить за еду, как и положено! Я готов продать её за %cost% крон. Думаю, это справедливая цена.}%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Ты забыл своё место, смерд. Хочешь, чтобы мы забрали всё силой?",
					function getResult()
					{
						return "TakeItByForce";
					}

				},
				{
					Text = "Понимаю. Ты получишь свои %cost% крон за эту еду.",
					function getResult()
					{
						return "PayCompensation";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BeatenByFarmers",
			Title = "На хуторе...",
			Text = "[img]gfx/ui/events/event_22.png[/img]Противник был слишком силён! Вы собираете оставшихся людей и приказываете отступать. %commander% вместе со своим войском больше не получит этой еды, а слухи о том, что отряд \'%companyname%\' отступил и от крестьян, разнесутся шире, чем дым пожарищ от чурчжэнских факелов.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Проклятье!",
					function getResult()
					{
						this.Flags.set("IsRequisitionFailure", true);
						this.Contract.setState("Running_ReturnAfterRequisition");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "PoorFarmers",
			Title = "На хуторе...",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Крестьяне и их наёмные клинки повержены. Староста, придерживая вываливающиеся из распоротого живота внутренности, молит о пощаде. Вы качаете головой.%SPEECH_ON%Ты сам это выбрал, смерд. Вот тебе моё милосердие.%SPEECH_OFF%Клинок перерезает его глотку. Крестьянин хрипит и затихает. Вы приказываете людям собрать еду и готовиться к возвращению. %commander% ждёт. | Крестьяне убиты. Вы приказываете людям собрать еду. %commander%, да и всё его войско, будут рады вашему возвращению. | Некоторые продукты покрылись кровью, но её легко смыть водой. %commander%, да и всё его войско, оценят вашу работу. | %randombrother% поднимает крестьянина, притворявшегося мёртвым, и перерезает ему глотку. Тот, хрипя и содрогаясь, вырывается из хватки и ковыляет к одной из повозок, заливая кровью всё, что там лежит. Вы кричите.%SPEECH_ON%Проклятье, убери его оттуда!%SPEECH_OFF%От крестьянина быстро избавляются, но груз, без сомнения, уже испорчен. Вы качаете головой.%SPEECH_ON%Прикрой это тканью. Быть может, никто и не заметит.%SPEECH_OFF% | Добыча продовольствия оказалась немного сложнее, чем вы рассчитывали, но еда всё же оказывается в ваших руках. Право владеть этой землёй вы даруете одному из выживших батраков — тому, что в портянках из мешковины вместо сапог.%SPEECH_ON%Помни о том, что сегодня случилось с твоим хозяином. Ведь это непременно случится и с тобой, если забудешь своё место, понял?%SPEECH_OFF%Парень торопливо кивает. Вы приказываете отряду \'%companyname%\' готовиться к возвращению. %commander% ждёт.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Дураки.",
					function getResult()
					{
						this.Flags.set("RequisitionSuccess", true);
						this.Contract.setState("Running_ReturnAfterRequisition");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CooperativeFarmers",
			Title = "На хуторе...",
			Text = "[img]gfx/ui/events/event_55.png[/img]{Крестьяне тепло приветствуют вас.%SPEECH_ON%Дай-ка угадаю, тебя прислал %commander%?%SPEECH_OFF%Вы киваете. Крестьянин сплёвывает и кивает в ответ.%SPEECH_ON%Понятно. У тебя здесь проблем не будет. Ребята, помогите им погрузить еду.%SPEECH_OFF%Батраки помогают вашим людям грузить повозки. Пора возвращаться — %commander% ждёт. | Вы встречаетесь со старостой. Он пожимает вашу руку.%SPEECH_ON%%commander% отправил мне почтового голубя с вестью о приходе наёмников, но вы снаряжены получше любого другого отряда из виденных мной. Мои парни помогут загрузить повозки, чтобы вы поскорее отправились в путь.%SPEECH_OFF% | Крестьяне грузят продукты в повозки неподалёку от вас. Их староста выходит вперёд.%SPEECH_ON%Не скажу, что это мне по душе, но лучше я поработаю тут, в полях, чем буду сидеть в военном лагере, ожидая смерти от чурчжэньей бомбарды. Мои парни помогут тебе загрузить повозки, чтобы вы побыстрее отправились в путь. А когда %commander% встретит тебя, замолви за нас словечко, ладно? Я хочу сохранить этот хутор.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Я уверен, наниматель оценит это.",
					function getResult()
					{
						this.Flags.set("RequisitionSuccess", true);
						this.Contract.setState("Running_ReturnAfterRequisition");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "TakeItByForce",
			Title = "На хуторе...",
			Text = "[img]gfx/ui/events/event_43.png[/img]{Вы обнажаете меч. Крестьяне тут же отступают и, ощетинившись вилами, начинают переговариваться меж собой. Их староста сплёвывает и вытирает рот рукавом.%SPEECH_ON%Проклятье, хочешь ограбить нас? Чурчжэни уже обобрали, так что ты опоздал! Ну давай, попробуй!%SPEECH_OFF% | Вы качаете головой.%SPEECH_ON%Сделки не будет. Ты отдашь еду или познаешь наш гнев.%SPEECH_OFF%Крестьянин перебрасывает вилы из руки в руку. Его люди неспешно поднимают оружие. Он кивает.%SPEECH_ON%Мы крестьяне, сволочь. Мы сроднились с гневом ещё до того, как ты родился. А с чурчжэнями потренировались.%SPEECH_OFF% | Вы пришли сюда не для того, чтобы заключать сделки.%SPEECH_ON%Никакой платы не будет. %commander% отправил нас за провиантом, чтобы...%SPEECH_OFF%Крестьянин смеётся и перебивает вас.%SPEECH_ON%Он послал сюда несколько своих собачек на побегушках. Ну ладно, пёсик, давай посмотрим, сможешь ли ты не только лаять, но и кусаться!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Сказано — сделано.",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "TakeItByForce";
						p.Music = this.Const.Music.CivilianTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.Entities = [];
						p.EnemyBanners = [
							"banner_noble_11"
						];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Peasants, 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Const.Faction.Enemy);
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "PayCompensation",
			Title = "На хуторе...",
			Text = "[img]gfx/ui/events/event_55.png[/img]{У вас нет причин проливать кровь несчастных хуторян, просто пытающихся выжить — чурчжэни уже и так достаточно наломали дров. Передавая золото, вы советуете крестьянину быть поосторожнее с подобными сделками.%SPEECH_ON%Не все будут столь добры, чтобы договариваться с тобой.%SPEECH_OFF%Крестьянин поворачивает голову, показывая длинный шрам, идущий от макушки к плечу.%SPEECH_ON%Я знаю это на своём опыте. Спасибо за предостережение, наёмник.%SPEECH_OFF% | Вы убиваете крестьян только за плату. %commander% же платил не за это. Так что вы принимаете их предложение. Староста пожимает вашу руку.%SPEECH_ON%Благодарю тебя, наёмник. В наши дни редко встретишь человека, с которым можно договориться. Я уж было подумал, что ты лишь очередной громила, но в проницательности тебе явно не откажешь.%SPEECH_OFF% | Вы прошли весь этот путь не ради убийства несчастных крестьян, так что соглашаетесь на предложение старосты. Он же благодарит вас за то, что вы прошли весь этот путь не ради убийства несчастных крестьян. %randombrother%, меж тем, тихо замечает, что тоже прошёл весь этот путь не ради... Вы громко приказываете ему заткнуться и приступать к погрузке еды.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Нужно побыстрее вернуться в военный лагерь.",
					function getResult()
					{
						this.Flags.set("RequisitionSuccess", true);
						this.Contract.setState("Running_ReturnAfterRequisition");
						return 0;
					}

				}
			],
			function start()
			{
				this.World.Assets.addMoney(-this.Flags.get("RequisitionCost"));
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы потратили [color=" + this.Const.UI.Color.NegativeEventValue + "]" + this.Flags.get("RequisitionCost") + "[/color] крон"
				});
			}

		});
		this.m.Screens.push({
			ID = "WarcampDay2",
			Title = "В военном лагере...",
			Text = "[img]gfx/ui/events/event_96.png[/img]{Луч рассветного солнца проникает в ваш шатёр, попадая прямо в глаза, буквально тыкая вас носом в начало нового дня. | Вы встаёте и одеваете сапоги, вытряхивая пауков, что выбрали их местом для ночлега. | Неподалёку от вашего шатра петух громким кукареканьем напоминает миру, что он — самый мерзкий его представитель. Вы неохотно встаёте. | Вы пережили ещё один день. Чудесно. | Вы спали как убитый, да и выглядите сейчас точно так же. Луч солнца, что проник в ваш шатёр, светит вам прямо в лицо, так что невозможно дальше нежиться в постели, а откинутый полог слишком далеко, чтобы до него дотянуться. Ну да ладно, пора вставать. | Утро. В эту неотвратимую пору солнечный свет возвращает в разум тысячи сожалений прошедших дней.}\n\nУ порога вашего шатра мнётся паренёк со свитком. Он разворачивает его и пытается прочесть.%SPEECH_ON%{Сим по... по-ве... па-ви-ли-ва-ю... тьфу, просто сходи и узнай у военачальника, чего он там хочет. | %commander% же-ла-ет ви-деть тебя, он... по-ве-ле-ва... по-ве-ше... Чего? Слушай, я не умею читать. Просто сходи к нему сам. | Господин, этот свиток велит мне сказать тебе, что ты... э-э-э... ты... кхм, должен... сходить к военачальнику. Вот. Там вообще-то гораздо больше написано, но мне и дня не хватит, чтобы всё это прочитать. | Ну да, читать я не умею, но думаю, что военачальник хочет видеть тебя. | Та-ак, посмотрим, эта буква... Я ведь знаю эту букву... Это буква \'Я\'! Э-э-э... в общем, остальная часть этого дерьма не так уж и важна. Слушай, просто сходи к военачальнику. Думаю, он именно этого и хочет.}%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Пора посетить военачальника...",
					function getResult()
					{
						if (this.Flags.get("IsInterceptSupplies"))
						{
							return "InterceptSupplies";
						}
						else
						{
							return "Deserters1";
						}
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "InterceptSupplies",
			Title = "В военном лагере...",
			Text = "[img]gfx/ui/events/event_96.png[/img]%commander% встречает вас в своей палатке, возбуждённо сжимая в кулаке лоскут карты.%SPEECH_ON%Лазутчики принесли добрую весть: обоз орды — порох, стрелы, доспехи для генеральной битвы — прошёл мимо наших дозорных и теперь тащится к стану %supply_dest%. Он уже в открытом поле, вот здесь, недалеко от лагеря. Догони его, наёмник, и сожги вместе с грузом. Если обоз доберётся — чурчжэни в день битвы будут вооружены на все сто.%SPEECH_OFF% | %commander% указывает вам на карту, где свежим мелом отмечена дорога.%SPEECH_ON%Смотри сюда. Наши люди видели большой обоз орды: повозки с порохом и снаряжением для решающего удара. Он идёт в стан %supply_dest%. Пока он в открытой степи — он наш. Догони и уничтожь, пока груз не ушёл за частокол.%SPEECH_OFF% | У палатки военачальника вы застаёте его с запиской, прикреплённой к карте.%SPEECH_ON%Разведчики доложили: обоз со снаряжением орды вышел к открытой дороге и направляется к стану %supply_dest%. Порох, сталь, жаровни — всё, чтобы генерал орды сомневался не больше, чем мул в пустой хлев. Добудь мне этот обоз, наёмник, и клянусь: в день битвы чурчжэни будут драться палками.%SPEECH_OFF% | %commander% сам выходит вам навстречу — признак того, что дело не терпит.%SPEECH_ON%Обоз орды, наёмник. Большой. Порох, стрелы, всё такое. Наши разведчики засекли его неподалёку — он прошёл мимо дозорных и теперь ползёт к стану %supply_dest%. Ты понимаешь, что это значит? Если он доберётся, генерал получит всё необходимое для генерального сражения. Не дай ему добраться.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Отряд выдвинется немедленно.",
					function getResult()
					{
						this.Contract.setState("Running_InterceptSupplies");
						return 0;
					}

				}
			],
			function start()
			{
				// Караван спавнится в открытой окрестности лагеря (игрок знает эти
				// места) и идёт в самый дальний стан, что дальше, чем игрок от точки
				// спавна — иначе игрок физически не успеет его догнать.
				local warcampTile = this.Contract.m.Warcamp.getTile();
				local spawnTile = this.Contract.getTileToSpawnLocation(warcampTile, 4, 8);
				local dest;
				local bestD = 0;

				if (spawnTile != null)
				{
					local playerD = this.World.State.getPlayer().getTile().getDistanceTo(spawnTile);
					local hordeSettlements = [];

					foreach( f in [
						this.World.FactionManager.getFactionOfType(this.Const.FactionType.Jurchen),
						this.World.FactionManager.getFactionOfType(this.Const.FactionType.Mgl)
					] )
					{
						hordeSettlements.extend(f.getSettlements());
					}

					foreach( s in hordeSettlements )
					{
						if (s.isIsolated())
						{
							continue;
						}

						local d = s.getTile().getDistanceTo(spawnTile);

						if (d >= playerD && d > bestD)
						{
							bestD = d;
							dest = s;
						}
					}
				}

				if (spawnTile == null || dest == null)
				{
					// вырожденный случай: ветку сворачиваем в дезертиров
					this.Flags.set("IsInterceptSupplies", false);
					this.Flags.set("IsDeserters", true);
					this.Contract.setScreen("Deserters1");
					return;
				}

				this.Flags.set("InterceptSuppliesDest", dest.getID());
				local destTile = dest.getTile();
				local enemyFaction = this.World.FactionManager.getFaction(dest.getFaction());
				local party = enemyFaction.spawnEntity(spawnTile, "Обоз орды", false, this.Const.World.Spawn.HordeRaiders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.getSprite("base").Visible = false;
				party.getSprite("body").setBrush("horde_cart");
				party.getSprite("banner").setBrush(dest.getBanner());
				party.setMirrored(true);
				party.setVisibleInFogOfWar(true);
				party.setImportant(true);
				party.setDiscovered(true);
				party.setDescription("Обоз Железной Орды: повозки с порохом, стрелами и добычей, идущие к стану орды.");
				party.setFootprintType(this.Const.World.FootprintsType.Nomads);
				party.getFlags().set("IsCaravan", true);
				party.setAttackableByAI(false);
				party.getFlags().add("ContractSupplies");
				this.Contract.m.Destination = this.WeakTableRef(party);
				this.Contract.m.UnitsSpawned.push(party);
				party.getLoot().Money = this.Math.rand(50, 100);
				party.getLoot().ArmorParts = this.Math.rand(0, 10);
				party.getLoot().Medicine = this.Math.rand(0, 2);
				party.getLoot().Ammo = this.Math.rand(0, 20);
				local r = this.Math.rand(1, 6);

				if (r == 1)
				{
					party.addToInventory("supplies/bread_item");
				}
				else if (r == 2)
				{
					party.addToInventory("supplies/roots_and_berries_item");
				}
				else if (r == 3)
				{
					party.addToInventory("supplies/dried_fruits_item");
				}
				else if (r == 4)
				{
					party.addToInventory("supplies/ground_grains_item");
				}
				else if (r == 5)
				{
					party.addToInventory("supplies/pickled_mushrooms_item");
				}

				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local move = this.new("scripts/ai/world/orders/move_order");
				move.setDestination(destTile);
				move.setRoadsOnly(true);
				local despawn = this.new("scripts/ai/world/orders/despawn_order");
				c.addOrder(move);
				c.addOrder(despawn);
			}

		});
		this.m.Screens.push({
			ID = "SuppliesReachedEnemy",
			Title = "По пути...",
			Text = "[img]gfx/ui/events/event_55.png[/img]{Вы не смогли уничтожить обоз. Порох и стрелы, несомненно, уже в руках орды, так что в грядущей битве чурчжэни будут стрелять чаще и метче. | Обоз не был перехвачен. Будьте уверены: орда получила своё снаряжение и теперь полностью готова к решающему сражению. | Проклятье. Обоз ушёл. И теперь орда будет снаряжена на все сто в день битвы.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Мы должны вернуться в лагерь...",
					function getResult()
					{
						this.Contract.setState("Running_ReturnAfterIntercept");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "SuppliesIntercepted",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Вы рассчитывали поживиться на останках обоза, но охранники подожгли пороховые повозки вместе со всем, что могло иметь хоть какую-то ценность. К несчастью, удалось добиться лишь того, что снаряжение не попало к орде. | Вы уничтожили большую часть обоза, а остальное охранники взорвали сами, не желая отдавать добро во вражеские руки. %commander% будет очень доволен подобным исходом. | Сражение было нелёгким, но охрана обоза перебита. К сожалению, чурчжэни применили тактику выжженной земли и взорвали повозки, прежде чем вы добрались до груза. Они понимали: нельзя оставить порох недругам. Тем не менее %commander% останется доволен. | Нужно признать, охрана обоза дала хороший бой, но отряд \'%companyname%\' вырезал её до последнего человека. По крайней мере, вы так полагали, но в разгар битвы одному из чурчжэней удалось выскользнуть и показать отличное знание тактики выжженной земли. Повозки взлетели на воздух одна за другой. Видимо, орда рассудила: раз нам это снаряжение не досталось, то пусть его не получит никто. Мелочно, но умно. Тем не менее %commander%, да и всё его войско, будут довольны. | Обоз был вырезан. Вы рассчитывали захватить пару повозок и поживиться порохом и сталью, но один из чурчжэней успел поднести факел к бочкам, не желая, дабы ценности достались врагу. Тем не менее орда, вне всяких сомнений, ослаблена.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Это поможет нам в предстоящем сражении.",
					function getResult()
					{
						this.Contract.setState("Running_ReturnAfterIntercept");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Deserters1",
			Title = "В военном лагере...",
			Text = "[img]gfx/ui/events/event_96.png[/img]{При входе в шатёр военачальника вам приходится уклоняться от кружки, пущенной прямо в лицо. Она с глухим стуком приземляется в грязь, следом туда же кувырком летит стол, сопровождаемый картами. %commander%, багровый от гнева, тяжело дыша и уперев руки в бока, стоит в средоточии этого бардака. Он объясняется.%SPEECH_ON%Дезертиры! Сбежали! Накануне важнейшей битвы в моей жизни, когда против нас вся проклятая орда! Слушай, я не могу позволить моему войску развалиться. Настигни этих беглецов и верни их ко мне. Если откажутся возвращаться — убей. Один из часовых видел их уходящими к %direction% отсюда. Поспеши!%SPEECH_OFF% | Как только вы собрались войти в шатёр военачальника, оттуда вылетает незнакомец. %commander% выбегает вслед и швыряет его в грязь, затем хватает за шиворот и трясёт, словно тряпичную куклу.%SPEECH_ON%Куда они пошли? Клянусь древними богами, я заставлю тебя молить о смерти, если не получу честный ответ!%SPEECH_OFF%Незнакомец, крича, называет место.%SPEECH_ON%К %direction%! Они пошли туда, клянусь!%SPEECH_OFF%%commander% отпускает незнакомца — прямо в руки стражи, которая куда-то его уводит. Военачальник выпрямляется и приглаживает волосы.%SPEECH_ON%Несколько моих людей решили сбежать из лагеря. Найди их, наёмник. Верни их. Понял?%SPEECH_OFF%Вы киваете, но спрашиваете, как поступить, если они откажутся возвращаться. Военачальник пожимает плечами.%SPEECH_ON%Перережь им глотки, разумеется. Или сам сдохни от чурчжэньей бомбарды вместе с ними — мне всё равно, только вернись с результатом.%SPEECH_OFF% | Войдя в шатёр военачальника, вы застаёте его рядом с привязанным к стулу незнакомцем. %commander% сжимает в руках клещи, в зубцах которых белеет вырванный зуб. Пленник обессиленно обмяк на стуле, из его рта стекает струйка крови. Военачальник бросает клещи на стол и проводит красной от крови рукой по волосам.%SPEECH_ON%Несколько моих людей дезертировали. А я не могу рисковать целостностью войска, особенно сейчас, когда на нас надвигается орда. Мой пытливый друг здесь утверждает, что видел беглецов уходящими к %direction% отсюда. Проверь это. И, наёмник... возвращайся только с ними или без них.%SPEECH_OFF% | %commander% стоит над разорённым шатрём: порванные карты, опрокинутый сундук, разбросанная сушёная рыба — кто-то явно уходил торопливо и брал всё, что плохо лежало. Военачальник показывает на след, ведущий из лагеря.%SPEECH_ON%Трое. Может, четверо. Сбежали ночью, пока чурчжэни во сне виделись им ужаснее моего плахи. Они недалеко, к %direction% отсюда. Догони их. Поговори с ними. А если не поймут доброго слова — ты знаешь, что делать.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Отряд отправится в течение часа.",
					function getResult()
					{
						this.Contract.setState("Running_Deserters");
						return 0;
					}

				}
			],
			function start()
			{
				local playerTile = this.World.State.getPlayer().getTile();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 5, 10, [
					this.Const.World.TerrainType.Shore,
					this.Const.World.TerrainType.Mountains
				]);
				local party = this.World.FactionManager.getFaction(this.Contract.getFaction()).spawnEntity(tile, "Дезертиры", false, this.Const.World.Spawn.Noble, 80 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.getSprite("banner").setBrush("banner_deserters");
				party.setFootprintType(this.Const.World.FootprintsType.Nobles);
				party.setAttackableByAI(false);
				party.getController().getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				party.setFootprintSizeOverride(0.75);
				this.Const.World.Common.addFootprintsFromTo(playerTile, party.getTile(), this.Const.GenericFootprints, this.Const.World.FootprintsType.Nobles, 0.75);
				this.Contract.m.Destination = this.WeakTableRef(party);
				party.getLoot().Money = this.Math.rand(50, 100);
				party.getLoot().ArmorParts = this.Math.rand(0, 10);
				party.getLoot().Medicine = this.Math.rand(0, 2);
				party.getLoot().Ammo = this.Math.rand(0, 20);
				local r = this.Math.rand(1, 6);

				if (r == 1)
				{
					party.addToInventory("supplies/bread_item");
				}
				else if (r == 2)
				{
					party.addToInventory("supplies/roots_and_berries_item");
				}
				else if (r == 3)
				{
					party.addToInventory("supplies/dried_fruits_item");
				}
				else if (r == 4)
				{
					party.addToInventory("supplies/ground_grains_item");
				}
				else if (r == 5)
				{
					party.addToInventory("supplies/pickled_mushrooms_item");
				}

				local c = party.getController();
				local wait = this.new("scripts/ai/world/orders/wait_order");
				wait.setTime(9000.0);
				c.addOrder(wait);
			}

		});
		this.m.Screens.push({
			ID = "Deserters2",
			Title = "По мере приближения...",
			Text = "[img]gfx/ui/events/event_88.png[/img]{Вы застаёте дезертиров сидящими вокруг затухающего костра. Один ворошит угли, пытаясь вновь раздуть пламя. Заметив вас, он застывает. Остальные, проследив за его взглядом, поспешно вскакивают на ноги.%SPEECH_ON%Мы не вернёмся. Передай военачальнику, пусть сам встречает свою орду.%SPEECH_OFF% | Дезертиры спорят между собой, когда вы появляетесь и окружаете их. Один начинает пятиться.%SPEECH_ON%%commander% послал тебя? Передай ему, что пусть катится прямиком в преисподнюю!%SPEECH_OFF%Другой показывает неприличный жест.%SPEECH_ON%Да, мы не вернёмся! Чурчжэней я под пыткой не встречу!%SPEECH_OFF% | %randombrother% указывает на группу людей у путевого знака. Они увлечённо спорят, не слыша вашего приближения. Вы резко свистите, и они сразу замолкают, поворачиваясь к вам. Один подходит.%SPEECH_ON%Этот крысёнок военачальник послал наёмников по нашему следу?%SPEECH_OFF%Вы киваете и объясняете, что они должны вернуться с вами. Другой дезертир качает головой.%SPEECH_ON%Вернуться? А как насчёт того, чтобы ты смотался отсюда? Мы не собираемся гнить в земле ради дворянских амбиций, так что беги назад и сообщи это своему хозяину!%SPEECH_OFF% | Вы застаёте дезертиров за дележом еды из походной котомки. Завидев вас, они замирают, а один пытается проглотить свою долю целиком — и давится. Остальные стоят недвижимо. Подавившийся судорожно шарит вокруг в поисках помощи, его лицо постепенно багровеет. Нога опрокидывает котомку, вышвыривая еду. Вы киваете.%SPEECH_ON%Помогите своему товарищу.%SPEECH_OFF%Дезертиры спешно бросаются к задыхающемуся и что есть сил колотят его по спине, выбивая застрявший кусок. Он жадно хватает воздух. Объясняя, зачем %commander% вас послал, вы не успеваете и пары фраз, как один из беглецов перебивает вас.%SPEECH_ON%Нет. Мы не вернёмся. Эта война — полное дерьмо, а чурчжэни — самая дерьмовая её часть. Мы не хотим в ней участвовать.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Так вот кем вы хотите стать? Трусами, не желающими защищать свою землю?",
					function getResult()
					{
						return this.Math.rand(1, 100) <= 50 ? "DesertersAcceptMotivation" : "DesertersRefuseMotivation";
					}

				},
				{
					Text = "Выбор у вас простой. Сражайтесь за своего владыку или сдохните здесь.",
					function getResult()
					{
						return this.Math.rand(1, 100) <= 50 ? "DesertersAcceptThreats" : "DesertersRefuseThreats";
					}

				},
				{
					Text = "Давайте поступим по справедливости. Я предлагаю вам %bribe% крон за возвращение.",
					function getResult()
					{
						return "DesertersAcceptBribe";
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "DesertersAcceptBribe",
			Title = "По мере приближения...",
			Text = "[img]gfx/ui/events/event_88.png[/img]{Вы берёте сумку и насыпаете в неё %bribe% крон.%SPEECH_ON%Я заплачу вам за возвращение в военный лагерь. %commander% гневается на вас, даже не сомневайтесь, но сейчас, накануне битвы с ордой, ему нужен каждый клинок. Сражайтесь рядом с ним в грядущий день — и он простит ваш небольшой проступок.%SPEECH_OFF% | Вы предлагаете дезертирам %bribe% крон. Они переглядываются, затем отвечают.%SPEECH_ON%И как эти деньги нам помогут, когда военачальник прикажет нас всех повесить?%SPEECH_OFF%Вы киваете и отвечаете.%SPEECH_ON%Хороший вопрос. %commander% ведь не дурак. В день битвы ему потребуется каждый человек, что встанет в строй против чурчжэней. Проявите себя — и ваша небольшая шалость, несомненно, будет забыта.%SPEECH_OFF%}{Дезертиры обдумывают варианты и в конце концов соглашаются вернуться с вами. | Дезертиры совещаются и приходят к какому-то решению. Распихивая остальных, их вожак выходит вперёд.%SPEECH_ON%Несмотря на некоторые опасения, мы решили вернуться с тобой в военный лагерь. Надеюсь, я не пожалею об этом.%SPEECH_OFF% | После непродолжительного спора о том, как поступить, дезертиры решают вопрос голосованием. С большим трудом они приходят к соглашению: стоит вернуться к военачальнику. | Дезертиры спорят о том, что делать дальше. Как вы и ожидали, решают вопрос голосованием. Как вы и опасались, голоса разделяются поровну. Тогда они решают подбросить монету, доверив ей выбор — возвратиться в лагерь или уйти. Вожак подбрасывает золотой, все провожают его глазами. Выпало возвращение. Беглецы с облегчением вздыхают: слепой случай избавил их от великого бремени принятия собственного решения.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Это поможет нам в грядущей битве.",
					function getResult()
					{
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
						this.Contract.setState("Running_ReturnAfterIntercept");
						return 0;
					}

				}
			],
			function start()
			{
				this.World.Assets.addMoney(-this.Flags.get("Bribe"));
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы потратили [color=" + this.Const.UI.Color.NegativeEventValue + "]" + this.Flags.get("Bribe") + "[/color] крон"
				});
			}

		});
		this.m.Screens.push({
			ID = "DesertersAcceptThreats",
			Title = "По мере приближения...",
			Text = "[img]gfx/ui/events/event_88.png[/img]{%bigdog% шагает вперёд, со свистом взмахнув клинком и положив лезвие на плечо.%SPEECH_ON%%commander%. Вы боитесь его. Это понятно. Вы знаете его, знаете его мстительность, знаете, на что он способен. Но вопрос в том...%SPEECH_OFF%Наёмник ухмыляется, и его кривая улыбка отражается на лезвии.%SPEECH_ON%Знаете ли вы, на что способен я?%SPEECH_OFF% | Дезертиры собрались уходить, когда %bigdog% громко свистит.%SPEECH_ON%Эй вы, жалкие трусы, мой командир отдал приказ.%SPEECH_OFF%Один усмехается.%SPEECH_ON%Да ну? А ничего, что это — не наш командир? Так что возьми свой приказ и засунь его себе сам знаешь куда!%SPEECH_OFF%%bigdog% обнажает огромный клинок и упирает остриё в землю, кладя руки на рукоять.%SPEECH_ON%%commander% вы боитесь — это разумно. Но если продолжите держаться подзаборной шавкой, то вскоре узнаете, какого из командиров действительно стоит бояться.%SPEECH_OFF% | Дезертиры разворачиваются, собираясь уходить, но в этот миг %bigdog% обнажает свой огромный меч и со звоном ударяет им о доспех. Беглецы медленно поворачиваются обратно. %bigdog% широко улыбается.%SPEECH_ON%Кому-нибудь из вас уже приходилось обмачивать штанишки?%SPEECH_OFF%Один качает головой.%SPEECH_ON%Слушай, мужик, отвали вместе со своими разговорами.%SPEECH_OFF%%bigdog% указывает остриём на беглеца.%SPEECH_ON%Ух ты, хочешь, чтобы я заткнулся? Скажи мне ещё что-нибудь подобное — и тогда вы все здесь замолчите. Навечно. А чурчжэни поблагодарят меня за сэкономленные им стрелы.%SPEECH_OFF%}{Дезертиры, обсудив возможные решения, в конце концов соглашаются вернуться с вами. | Дезертиры совещаются и приходят к какому-то решению. Распихивая остальных, их вожак выходит вперёд.%SPEECH_ON%Несмотря на некоторые опасения, мы решили вернуться с тобой в военный лагерь. Надеюсь, я не пожалею об этом.%SPEECH_OFF% | После непродолжительного спора о том, как поступить, дезертиры решают вопрос голосованием. С большим трудом они приходят к соглашению: стоит вернуться к военачальнику. | Дезертиры спорят, но тут вперёд выходит %bigdog% — и решение приходит быстро. Они соглашаются вернуться в лагерь.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Вы сделали правильный выбор.",
					function getResult()
					{
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
						this.Contract.m.Dude = null;
						this.Contract.setState("Running_ReturnAfterIntercept");
						return 0;
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();
				local candidates = [];

				foreach( bro in brothers )
				{
					if (bro.getSkills().hasSkill("trait.player"))
					{
						continue;
					}

					if (bro.getSkills().hasSkill("trait.bloodthirsty") || bro.getSkills().hasSkill("trait.brute") || bro.getBackground().getID() == "background.raider" || bro.getBackground().getID() == "background.sellsword" || bro.getBackground().getID() == "background.hedge_knight" || bro.getBackground().getID() == "background.brawler")
					{
						candidates.push(bro);
					}
				}

				if (candidates.len() == 0)
				{
					candidates = brothers;
				}

				this.Contract.m.Dude = candidates[this.Math.rand(0, candidates.len() - 1)];
				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "DesertersAcceptMotivation",
			Title = "По мере приближения...",
			Text = "[img]gfx/ui/events/event_88.png[/img]{Дезертиры собираются уходить, но %motivator% выходит вперёд и прочищает горло.%SPEECH_ON%Так вот как это будет, да? Собираетесь забыть о своём долге, подобно змее, забывающей о сброшенной шкуре? Я знаю, что вы чувствуете. Знаю, вы не хотите рисковать шкурой ради дворянина, который понятия не имеет, через что вам пришлось пройти. Это справедливо. Но однажды, через много лет, внук попросит рассказать, как вы сражались, когда пришла орда. И вам придётся солгать своей родной крови.%SPEECH_OFF% | %motivator% засовывает пальцы в рот и резко свистит. Дезертиры поворачиваются к нему, и он начинает говорить.%SPEECH_ON%Вот и всё, да? Вы действительно собрались возложить на себя эту ношу? А что вы расскажете сыновьям? Что вы — дезертиры, бросившие соседей умирать? И не сомневайтесь: ваша трусость ляжет чужими смертями! Чурчжэни не спрашивают, кто встал в строй, а кто сбежал. Они жгут всех подряд!%SPEECH_OFF% | %motivator% взывает к беглецам.%SPEECH_ON%Допустим, вы уйдёте. Предав своё знамя и свой долг. Но что будет, когда орда двинется дальше, а?%SPEECH_OFF%Один пожимает плечами.%SPEECH_ON%Они меня не знают. Я вернусь в свою деревню, к семье.%SPEECH_OFF%%motivator% со смехом качает головой.%SPEECH_ON%Ты правда так думаешь? А что ты будешь делать, когда чурчжэни придут в твою деревню? Когда увидят твою жену и твоих детей? У степняков на всё свои планы, а у чурчжэней — порох. У тебя не будет дома, в который ты мог бы вернуться, дурак!%SPEECH_OFF%}{Дезертиры обсуждают своё положение и в конце концов соглашаются вернуться с вами. | Дезертиры совещаются и приходят к какому-то решению. Распихивая остальных, их вожак выходит вперёд.%SPEECH_ON%Несмотря на некоторые опасения, мы решили вернуться с тобой в военный лагерь. Надеюсь, я не пожалею об этом.%SPEECH_OFF% | После непродолжительного спора о том, как поступить, дезертиры решают вопрос голосованием. С большим трудом они приходят к соглашению: стоит вернуться к военачальнику. | Дезертиры спорят, но слова %motivator% ударили в цель. Они соглашаются вернуться в лагерь.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Вы сделали правильный выбор.",
					function getResult()
					{
						this.Contract.m.Destination.die();
						this.Contract.m.Destination = null;
						this.Contract.m.Dude = null;
						this.Contract.setState("Running_ReturnAfterIntercept");
						return 0;
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();
				local highest_bravery = 0;
				local best;

				foreach( bro in brothers )
				{
					if (bro.getCurrentProperties().getBravery() > highest_bravery)
					{
						best = bro;
					}
				}

				this.Contract.m.Dude = best;
				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "DesertersRefuseThreats",
			Title = "По мере приближения...",
			Text = "[img]gfx/ui/events/event_88.png[/img]{%bigdog% шагает вперёд, со свистом взмахнув клинком и положив лезвие на плечо.%SPEECH_ON%%commander%. Вы боитесь его. Это понятно. Вы знаете его, знаете его мстительность, знаете, на что он способен. Но вопрос в том...%SPEECH_OFF%Наёмник ухмыляется, и его кривая улыбка отражается на лезвии.%SPEECH_ON%Знаете ли вы, на что способен я?%SPEECH_OFF% | Дезертиры собрались уходить, когда %bigdog% громко свистит.%SPEECH_ON%Эй вы, жалкие трусы, мой командир отдал приказ.%SPEECH_OFF%Один усмехается.%SPEECH_ON%Да ну? А ничего, что это — не наш командир? Так что возьми свой приказ и засунь его себе сам знаешь куда!%SPEECH_OFF%%bigdog% обнажает огромный клинок и упирает остриё в землю, кладя руки на рукоять.%SPEECH_ON%%commander% вы боитесь — это разумно. Но если продолжите держаться подзаборной шавкой, то вскоре узнаете, какого из командиров действительно стоит бояться.%SPEECH_OFF% | Дезертиры разворачиваются, собираясь уходить, но в этот миг %bigdog% обнажает свой огромный меч и со звоном ударяет им о доспех. Беглецы медленно поворачиваются обратно. %bigdog% широко улыбается.%SPEECH_ON%Кому-нибудь из вас уже приходилось обмачивать штанишки?%SPEECH_OFF%Один качает головой.%SPEECH_ON%Слушай, мужик, отвали вместе со своими разговорами.%SPEECH_OFF%%bigdog% указывает остриём на беглеца.%SPEECH_ON%Ух ты, хочешь, чтобы я заткнулся? Скажи мне ещё что-нибудь подобное — и тогда вы все здесь замолчите. Навечно.%SPEECH_OFF%}{Дезертиры не смогли договориться меж собой и решают вопрос голосованием. Большая часть решила уходить. Их вожак сообщает вам о результатах и прощается. %commander% будет недоволен, вы же обнажаете клинок и говорите беглецам, что теперь для них есть лишь один путь. Вожак оборачивается с мечом в руке и кивает.%SPEECH_ON%Знаю. Я так и понял, что вы пришли сюда не ради разговоров. К оружию, ребята.%SPEECH_OFF% | %commander% будет кричать, но слова его, как вы понимаете, беглецов уже не испугают. Вожак дезертиров сплюнул вам под ноги.%SPEECH_ON%Чурчжэни нас точно убьют, а вот вы — только наверняка. Так что нет, наёмник. Мы не вернёмся.%SPEECH_OFF%Вы обнажаете клинок. | Дезертиры переглядываются, и в глазах у них вы читаете решение, принятое ещё до вашего прихода. Вожак тихо говорит.%SPEECH_ON%Мы сбежали от одной смерти. Не хочется встречать другую. Но раз уж выбор только такой...%SPEECH_OFF%Он обнажает меч.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Покончим с этим...",
					function getResult()
					{
						this.Contract.m.Dude = null;
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos(), true);
						p.CombatID = "Deserters";
						p.Music = this.Const.Music.CivilianTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.TemporaryEnemies = [
							this.Contract.getFaction()
						];
						p.AllyBanners = [
							this.World.Assets.getBanner()
						];
						p.EnemyBanners = [
							"banner_deserters"
						];
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();
				local candidates = [];

				foreach( bro in brothers )
				{
					if (bro.getSkills().hasSkill("trait.player"))
					{
						continue;
					}

					if (bro.getSkills().hasSkill("trait.bloodthirsty") || bro.getSkills().hasSkill("trait.brute") || bro.getBackground().getID() == "background.raider" || bro.getBackground().getID() == "background.sellsword" || bro.getBackground().getID() == "background.hedge_knight" || bro.getBackground().getID() == "background.brawler")
					{
						candidates.push(bro);
					}
				}

				if (candidates.len() == 0)
				{
					candidates = brothers;
				}

				this.Contract.m.Dude = candidates[this.Math.rand(0, candidates.len() - 1)];
				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "DesertersRefuseMotivation",
			Title = "По мере приближения...",
			Text = "[img]gfx/ui/events/event_88.png[/img]{Дезертиры собираются уходить, но %motivator% выходит вперёд и прочищает горло.%SPEECH_ON%Так вот как это будет, да? Собираетесь забыть о своём долге, подобно змее, забывающей о сброшенной шкуре? Я знаю, что вы чувствуете. Знаю, вы не хотите рисковать шкурой ради дворянина, который понятия не имеет, через что вам пришлось пройти. Это справедливо. Но однажды, через много лет, внук попросит рассказать, как вы сражались, когда пришла орда. И вам придётся солгать своей родной крови.%SPEECH_OFF% | %motivator% засовывает пальцы в рот и резко свистит. Дезертиры поворачиваются к нему, и он начинает говорить.%SPEECH_ON%Вот и всё, да? Вы действительно собрались возложить на себя эту ношу? А что вы расскажете сыновьям? Что вы — дезертиры, бросившие соседей умирать? И не сомневайтесь: ваша трусость ляжет чужими смертями! Чурчжэни не спрашивают, кто встал в строй, а кто сбежал. Они жгут всех подряд!%SPEECH_OFF% | %motivator% взывает к беглецам.%SPEECH_ON%Допустим, вы уйдёте. Предав своё знамя и свой долг. Но что будет, когда орда двинется дальше, а?%SPEECH_OFF%Один пожимает плечами.%SPEECH_ON%Они меня не знают. Я вернусь в свою деревню, к семье.%SPEECH_OFF%%motivator% со смехом качает головой.%SPEECH_ON%Ты правда так думаешь? А что ты будешь делать, когда чурчжэни придут в твою деревню? Когда увидят твою жену и твоих детей? У степняков на всё свои планы, а у чурчжэней — порох. У тебя не будет дома, в который ты мог бы вернуться, дурак!%SPEECH_OFF%}{Дезертиры не смогли договориться меж собой и решают вопрос голосованием. Большая часть решила уходить. Их вожак сообщает вам о результатах и прощается. %commander% будет недоволен, вы же обнажаете клинок и говорите беглецам, что теперь для них есть лишь один путь. Вожак оборачивается с мечом в руке и кивает.%SPEECH_ON%Знаю. Я так и понял, что вы пришли сюда не ради разговоров. К оружию, ребята.%SPEECH_OFF% | %commander% будет кричать, но слова его, как вы понимаете, беглецов уже не испугают. Вожак дезертиров сплюнул вам под ноги.%SPEECH_ON%Чурчжэни нас точно убьют, а вот вы — только наверняка. Так что нет, наёмник. Мы не вернёмся.%SPEECH_OFF%Вы обнажаете клинок. | Дезертиры переглядываются, и в глазах у них вы читаете решение, принятое ещё до вашего прихода. Вожак тихо говорит.%SPEECH_ON%Мы сбежали от одной смерти. Не хочется встречать другую. Но раз уж выбор только такой...%SPEECH_OFF%Он обнажает меч.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Покончим с этим...",
					function getResult()
					{
						this.Contract.m.Dude = null;
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos(), true);
						p.CombatID = "Deserters";
						p.Music = this.Const.Music.CivilianTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						p.TemporaryEnemies = [
							this.Contract.getFaction()
						];
						p.AllyBanners = [
							this.World.Assets.getBanner()
						];
						p.EnemyBanners = [
							"banner_deserters"
						];
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			],
			function start()
			{
				local brothers = this.World.getPlayerRoster().getAll();
				local highest_bravery = 0;
				local best;

				foreach( bro in brothers )
				{
					if (bro.getCurrentProperties().getBravery() > highest_bravery)
					{
						best = bro;
					}
				}

				this.Contract.m.Dude = best;
				this.Characters.push(this.Contract.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "DesertersAftermath",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{%randombrother% очищает клинок о накидку одного из мертвецов.%SPEECH_ON%Жаль, что они выбрали этот путь. Они могли бы жить. У них был выбор.%SPEECH_OFF%Вы пожимаете плечами и отвечаете.%SPEECH_ON%Их всё равно ждала смерть — от орды или от нас. Они просто выбрали палачей.%SPEECH_OFF% | Вокруг лежат дезертиры, мёртвые и умирающие. Один из них ползёт по земле, словно до сих пор пытаясь убежать от битвы с чурчжэнями. Вы склоняетесь над ним, сжимая кинжал, дабы закончить работу. Он смеётся, глядя на вас.%SPEECH_ON%Нет нужды марать клинок, наёмник. Просто дай мне немного времени. Это всё, что у меня осталось.%SPEECH_OFF%Струйка крови стекает по его подбородку. Глаза сужаются, рассматривая пустоту, затем он медленно валится на землю. Вы встаёте и приказываете отряду собираться в обратный путь. | Последний дезертир сидит, прислонившись к валуну, обессиленно распластав руки, словно бродяга, просящий подаяние. Из ран на его груди стекает кровь, пропитывая землю. Он разглядывает её.%SPEECH_ON%Со мной всё хорошо, благодарю, что спросил, наёмник.%SPEECH_OFF%Вы отвечаете, что ничего не говорили. Он в искреннем удивлении смотрит на вас.%SPEECH_ON%Не ты? Но...%SPEECH_OFF%Через мгновение его тело заваливается на бок, с застывшим навечно изумлением на лице. | Некоторые люди слишком уж ценят весёлую, но обречённую жизнь. Сделав свой выбор и лишившись свободы, что им остаётся, кроме как поприветствовать смехом свою жестокую судьбу? Каждый дезертир умер с выражением высокомерной самоуверенности на лице. | Последний оставшийся в живых дезертир смотрит в небо. Его рука бесцельно пытается что-то схватить в воздухе.%SPEECH_ON%Проклятье, я просто хочу увидеть хоть одну...%SPEECH_OFF%Вы спрашиваете, что он хочет увидеть. Он хохочет, хотя смех почти сразу перерастает в болезненный стон.%SPEECH_ON%Птицу. А, вот она! Такая огромная, такая прекрасная...%SPEECH_OFF%Он указывает вверх. Подняв взгляд, вы видите лишь серое небо. Когда вы снова смотрите на него — он мёртв. Наверное, ему всё же удалось её увидеть.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "К сожалению, это было необходимо.",
					function getResult()
					{
						this.Contract.setState("Running_ReturnAfterIntercept");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "WarcampDay2End",
			Title = "В военном лагере...",
			Text = "[img]gfx/ui/events/event_96.png[/img]{%commander% сообщает вам, что битва состоится завтра. Вы возвращаетесь в свою палатку для долгожданного и заслуженного отдыха. | Возвратившись к военачальнику, вы докладываете о произошедшем. %commander% подавлен, все его мысли поглощены предстоящим завтра сражением с ордой. Уже смеркается, так что вы решаете вернуться в свой шатёр и поспать до утра. | Вы сообщаете новости военачальнику, но %commander% не обращает на вас внимания. Он буквально зарылся в карты предстоящей битвы.%SPEECH_ON%Увидимся завтра, наёмник. Отдохни хорошенько, тебе это пригодится.%SPEECH_OFF% | %commander% приглашает вас в свой шатёр, но практически не слушает доклада. Вместо этого он разглядывает карты и советуется с капитанами о планах на завтрашнюю битву. Вы решаете пойти к себе и поспать. | %commander% кивает в такт докладу, но практически не слушает вас. Вместо этого он рассматривает планы сражения, лежащие на столе. Вы его понимаете: завтра решающая битва, и лучше подумать о ней заранее. Вы идёте спать.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Хорошенько отдохните этой ночью, завтра нас ждёт сражение!",
					function getResult()
					{
						this.Flags.set("LastDay", this.World.getTime().Days);
						this.Flags.set("NextDay", 3);
						this.Contract.setState("Running_WaitForNextDay");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "WarcampDay3",
			Title = "В военном лагере...",
			Text = "[img]gfx/ui/events/event_78.png[/img]{%commander% прохаживается перед строем своих воинов. Некоторые выглядят устало и явно не спали этой ночью. Другие дрожат от страха. Военачальник взывает к ним.%SPEECH_ON%Испугались? А ты? Это хорошо. Я вот испугался бы, если бы было не так.%SPEECH_OFF%Раскатившийся вокруг смех поднимает бойцам настроение. %commander% продолжает.%SPEECH_ON%Но сейчас я прошу вас бояться не за собственную шкуру, а за ваши семьи, за ваш род! Чурчжэни не оставят после себя ни домов, ни имени! Вот за кого мы сражаемся сегодня! Побеспокоимся о себе завтра, ибо сегодня мы будем воинами!%SPEECH_OFF%Смех перерастает в радостный рёв. | %commander% собрал своё разношёрстное войско перед битвой. Пехотинцы, лучники, обозники стоят, поёживаясь на стылом ветру. Военачальник оглядывает строй.%SPEECH_ON%Я знаю, о чём вы думаете: \'Что я здесь делаю, сражаясь за это жалкое ничтожество. Если он такой благородный, где же его стройная лошадь, чтобы смотреть на нас свысока?\'%SPEECH_OFF%Воины смеются, напряжение рассеивается. %commander% продолжает.%SPEECH_ON%Вот что, гад я там или нет, ничто я не люблю так, как славную битву! И вот где я буду, парни. Я встану рядом с вами, разя изо всех сил, сражаясь до конца, ибо это и есть предназначение воина!%SPEECH_OFF%Солдаты воздевают мечи и разражаются радостным рёвом. Военачальник разворачивается и указывает клинком вперёд.%SPEECH_ON%Идите за мной! Покажем этим чурчжэним и их степным псам, что такое настоящие мужчины!%SPEECH_OFF% | %commander% построил своё войско перед битвой. Прохаживаясь вдоль строя, военачальник начинает говорить.%SPEECH_ON%Некоторые из вас явно не выспались. Что такое, нервничаете? Я тоже! Глаз не смог сомкнуть.%SPEECH_OFF%Это подбадривает бойцов. Хорошо знать, что ты не одинок — и во плоти, и разумом. Военачальник продолжает.%SPEECH_ON%Но я не сомкнул глаз ради этой битвы. Ни за что на свете не пропустил бы её! Так что протрите глаза, ребята, ибо сегодня мы покажем орде, что ей стоило остаться в своей степи!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Вперёд, братья, пора выиграть эту битву!",
					function getResult()
					{
						this.Contract.setState("Running_FinalBattle");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BattleLost",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_86.png[/img]{Повсюду лежат мёртвые тела. Среди них выделяется %commander% — его доспехи сверкают, обрамляя бренную плоть. %employer%, без сомнений, будет опечален поражением, но с этим уже ничего не поделаешь. | Битва проиграна! %commander% погиб, как и большая часть его войска, лишь немногие смогли бежать. Стервятники уже кружат над полем боя, чурчжэни неспешно пробираются среди гор трупов, добивая пытающихся притвориться мёртвыми. Вы собираете остатки отряда \'%companyname%\' и отступаете. %employer%, без сомнений, будет в ужасе от итогов битвы, но с этим уже ничего не поделаешь.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Не каждая битва может быть выиграна...",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Проиграно решающее сражение с Железной Ордой");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BattleWon",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_87.png[/img]{Вы победили! Ну и %commander% со своим войском тоже, да. Битва выиграна — вот что главное. Вы пробираетесь через горы мертвецов, желая побыстрее вернуться к нанимателю. | Мёртвые тела лежат в несколько слоёв. Стервятники вырывают куски мяса из грудей трупов, раненые умоляют о помощи. На посторонний взгляд, здесь вообще нет победителей. Впрочем, %commander% подходит к вам, весело ухмыляясь.%SPEECH_ON%{Хорошая работа, наёмник. Тебе стоит вернуться к нанимателю и поведать ему о случившемся. | Хорошая работа — для наёмника. Я сомневался, что ты справишься. Тебе стоит вернуться к моему господину и поведать ему о случившемся.}%SPEECH_OFF% | Раненый у ваших ног молит о помощи. Вы не в силах определить, враг ли это или он из войска, что ведёт %commander%. Внезапно его голову протыкает стрела с развесистым оперением. Подняв взгляд, вы смотрите в глаза степняку, перезаряжающему лук. Тот указывает на вас пальцем.%SPEECH_ON%Ты тот самый наёмник, верно? %commander% велел передать тебе, что пора возвращаться к нанимателю. Я всё верно сказал?%SPEECH_OFF%Вы киваете. Из груды трупов раздаётся стон. Воин неспешно натягивает тетиву.%SPEECH_ON%Ну, пора за работу!%SPEECH_OFF% | Битва окончена, а %commander%, ревя, срывает с себя доспехи и поддоспешник. Он любуется своими ранами, сгибаясь так, чтобы они открывались, и кровь сочилась из них, словно из надрезанной кожуры спелого фрукта. Он требует от своих людей сделать то же самое, заставляя их поворачиваться и разглядывая их спины.%SPEECH_ON%Видите, смелые воины, подобные мне, получают раны здесь, здесь или здесь...%SPEECH_OFF%Он показывает на каждую рану на своём теле, а затем указывает на спину.%SPEECH_ON%Но здесь у настоящих мужчин ран быть не может! Потому что мы умираем, идя вперёд, а не отступая назад! Ведь так?%SPEECH_OFF%Воины радостным рёвом приветствуют его слова, хотя некоторые едва держатся на ногах, ослабев от потери крови. Вы не обращаете внимания на этот цирк и приказываете отряду \'%companyname%\' собираться. Пора за наградой. | Победа. Чурчжэни бегут, бросая железные латы, — с такими грузами недалеко уйдёшь. Степняки уходят быстрее всех, петляя между деревьями, как зайцы. %randombrother% подходит к вам, протягивая разбитую бомбарду.%SPEECH_ON%Командир, а это чудо можно продать?%SPEECH_OFF%Вы отвечаете, что сначала надо вернуться к нанимателю. %commander% ждёт доклада, и он, в отличие от бомбарды, взорвётся, если его долго ждать.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Победа!",
					function getResult()
					{
						local faction = this.World.FactionManager.getFaction(this.Contract.getFaction());
						local settlements = faction.getSettlements();
						local origin = settlements[this.Math.rand(0, settlements.len() - 1)];
						local party = faction.spawnEntity(this.World.State.getPlayer().getTile(), "Отряд города " + origin.getName(), true, this.Const.World.Spawn.Noble, 150);
						party.getSprite("body").setBrush(party.getSprite("body").getBrush().Name + "_" + faction.getBannerString());
						party.setDescription("Опытные воины на службе у местной знати.");
						this.Contract.setState("Return");
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% в стельку пьян. Он таращится на вас, не отрываясь от кубка, говоря между глотками.%SPEECH_ON%Проклятье, ты вернулся!%SPEECH_OFF%Кубок выпадает из его вялой руки. Вы кратко докладываете о своих достижениях. Дворянин улыбается, хотя он так пьян, что это выглядит жалко.%SPEECH_ON%Значит, всё закончилось. Орда бежит. Мои надежды сбылись. Надеюсь, немногие погибли ради моих желаний.%SPEECH_OFF%Он разражается хохотом. Один из стражей протягивает вам кошель и выпроваживает из залы. | %employer% приветствует вас, протягивая кошель, полный крон.%SPEECH_ON%{Мы победили. Благодарю, наёмник. | Прекрасная работа. Победа за нами, и благодарить за это нужно, в том числе, и тебя. Вот твои %reward_completion% золотых. | Сколько там было, %reward_completion% крон? Невеликая плата за победу над столь могучим войском и помощь в победном завершении этой проклятой войны. | Мои пташки нашептали о твоих достижениях, наёмник. А ещё они поведали о бегстве орды. Чего ещё желать? Вот обещанные %reward_completion% золотых.}%SPEECH_OFF% | Вы застаёте нанимателя за выкрикиванием приказов своим военачальникам. Заметив вас, %employer% немедленно показывает на вас.%SPEECH_ON%Видите этого парня, вон там? Вот человек, способный добиться своего! Стража! Отдайте ему %reward_completion% крон. Я был бы счастлив, если бы вы, жалкие псы, сделали хоть половину его свершений — за свою-то плату!%SPEECH_OFF% | %employer% расположился в своём саду, перешучиваясь со стайкой девиц. Вы врываетесь в их уютный мирок, весь пропитанный кровью, покрытый грязью. Женщины задыхаются и отшатываются. %employer% смеётся.%SPEECH_ON%О, возвращение наёмника! Да ты у нас настоящий дамский угодник! Хотел бы я познакомить тебя с этими прекрасными девами, но, боюсь, если ты посмеешь хотя бы дотронуться до них, их отцы оторвут тебе кое-что ненужное.%SPEECH_OFF%Одна из дам проводит рукой по груди.%SPEECH_ON%Он может дотронуться до меня...%SPEECH_OFF%%employer% хохочет и вручает вам кошель.%SPEECH_ON%Вот твои %reward_completion% крон, наёмник. Ты их честно заработал — чурчжэни, говорят, уже возвращаются в свою степь.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Заслуженная награда.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Выиграно решающее сражение с Железной Ордой");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isHordeInvasion())
						{
							this.World.FactionManager.addGreaterEvilStrength(this.Const.Factions.GreaterEvilStrengthOnCriticalContract);
						}

						return 0;
					}

				}
			],
			function start()
			{
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы получаете [color=" + this.Const.UI.Color.PositiveEventValue + "]" + this.Contract.m.Payment.getOnCompletion() + "[/color] крон"
				});
			}

		});
	}

	function onCommanderPlaced( _entity, _tag )
	{
		_entity.setName(this.m.Flags.get("CommanderName"));
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"commander",
			this.m.Flags.get("CommanderName")
		]);
		_vars.push([
			"objective",
			this.m.Destination == null || this.m.Destination.isNull() ? "" : this.m.Destination.getName()
		]);
		_vars.push([
			"cost",
			this.m.Flags.get("RequisitionCost")
		]);
		_vars.push([
			"bribe",
			this.m.Flags.get("Bribe")
		]);

		// InterceptSuppliesDest выбирается только в start() сцены InterceptSupplies —
		// раньше (экран Overview сразу после принятия) флага ещё нет, без гейта
		// getEntityByID(null).getName() падает
		if (this.m.Flags.get("IsInterceptSupplies") && this.m.Flags.has("InterceptSuppliesDest"))
		{
			_vars.push([
				"supply_dest",
				this.World.getEntityByID(this.m.Flags.get("InterceptSuppliesDest")).getName()
			]);
		}

		if (this.m.Dude != null)
		{
			_vars.push([
				"bigdog",
				this.m.Dude.getName()
			]);
			_vars.push([
				"motivator",
				this.m.Dude.getName()
			]);
		}

		if (this.m.Destination == null)
		{
			_vars.push([
				"direction",
				this.m.WarcampTile == null ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.WarcampTile)]
			]);
		}
		else
		{
			_vars.push([
				"direction",
				this.m.Destination == null || this.m.Destination.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Destination.getTile())]
			]);
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Destination != null && !this.m.Destination.isNull())
			{
				this.m.Destination.getSprite("selection").Visible = false;
				this.m.Destination.setOnCombatWithPlayerCallback(null);
			}

			if (this.m.Warcamp != null && !this.m.Warcamp.isNull())
			{
				this.m.Warcamp.die();
			}

			this.m.Home.getSprite("selection").Visible = false;
		}
	}

	function onIsValid()
	{
		if (!this.World.FactionManager.isHordeInvasion())
		{
			return false;
		}

		return true;
	}

	function onSerialize( _out )
	{
		if (this.m.Destination != null && !this.m.Destination.isNull())
		{
			_out.writeU32(this.m.Destination.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		if (this.m.Warcamp != null && !this.m.Warcamp.isNull())
		{
			_out.writeU32(this.m.Warcamp.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local destination = _in.readU32();

		if (destination != 0)
		{
			this.m.Destination = this.WeakTableRef(this.World.getEntityByID(destination));
		}

		local warcamp = _in.readU32();

		if (warcamp != 0)
		{
			this.m.Warcamp = this.WeakTableRef(this.World.getEntityByID(warcamp));
		}

		this.contract.onDeserialize(_in);
	}

});
