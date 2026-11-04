this.decisive_battle_b_contract <- this.inherit("scripts/contracts/contract", {
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

		this.m.Type = "contract.decisive_battle";
		this.m.Name = "Битва";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importNobleIntro();
	}

	function start()
	{
		if (this.m.Home == null)
		{
			this.setHome(this.World.State.getCurrentTown());
		}

		if (this.m.WarcampTile == null)
		{
			local settlements = this.World.EntityManager.getSettlements();
			local lowest_distance = 99999;
			local best_settlement;
			local myTile = this.m.Home.getTile();

			foreach( s in settlements )
			{
				if (this.World.FactionManager.isAllied(this.getFaction(), s.getFaction()))
				{
					continue;
				}

				if (s.isLocationType(this.Const.World.LocationType.Unique))
				{
					continue;
				}

				local d = s.getTile().getDistanceTo(myTile);
				if (d < lowest_distance)
				{
					lowest_distance = d;
					best_settlement = s;
				}
			}

			this.m.WarcampTile = myTile.getTileBetweenThisAnd(best_settlement.getTile());
			this.m.Flags.set("EnemyNobleHouse", best_settlement.getOwner().getID());
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
					"Помочь армии в битве против дома %feudfamily%"
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
				this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).addPlayerRelation(-99.0, "Выбрал не ту сторону в войне");

				if (this.Contract.m.WarcampTile == null)
				{
					local settlements = this.World.EntityManager.getSettlements();
					local lowest_distance = 99999;
					local best_settlement;
					local myTile = this.Contract.m.Home.getTile();

					foreach( s in settlements )
					{
						if (this.World.FactionManager.isAllied(this.Contract.getFaction(), s.getFaction()))
						{
							continue;
						}

						if (s.isLocationType(this.Const.World.LocationType.Unique))
						{
							continue;
						}

						local d = s.getTile().getDistanceTo(myTile);
						if (d < lowest_distance)
						{
							lowest_distance = d;
							best_settlement = s;
						}
					}

					this.Contract.m.WarcampTile = myTile.getTileBetweenThisAnd(best_settlement.getTile());
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

				r = this.Math.rand(1, 100);

				if (r <= 40)
				{
					if (this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).getSettlements().len() >= 2)
					{
						this.Flags.set("IsInterceptSupplies", true);
						local myTile = this.Contract.m.Warcamp.getTile();
						local settlements = this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).getSettlements();
						local lowest_distance = 99999;
						local highest_distance = 0;
						local best_start;
						local best_dest;

						foreach( s in settlements )
						{
							if (s.isIsolated())
							{
								continue;
							}

							if (s.isLocationType(this.Const.World.LocationType.Unique))
							{
								continue;
							}

							local d = s.getTile().getDistanceTo(myTile);

							if (d < lowest_distance)
							{
								lowest_distance = d;
								best_dest = s;
							}

							if (d > highest_distance)
							{
								highest_distance = d;
								best_start = s;
							}
						}

						this.Flags.set("InterceptSuppliesStart", best_start.getID());
						this.Flags.set("InterceptSuppliesDest", best_dest.getID());
					}
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
					"Перехватить разведчиков дома %feudfamily%, замеченных к %direction% от лагеря",
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
				properties.Music = this.Const.Music.NobleTracks;
				properties.EnemyBanners = [
					this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).getBannerSmall()
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
					"Перехватить обоз, идущий из города %supply_start% в поселение %supply_dest%"
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
					"Идти по следу и догоните дезертиров",
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
					"Выиграть битву для дома %noblehouse%"
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
					p.Music = this.Const.Music.NobleTracks;
					p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
					p.Entities = [];
					p.AllyBanners = [
						this.World.Assets.getBanner(),
						this.World.FactionManager.getFaction(this.Contract.getFaction()).getBannerSmall()
					];
					p.EnemyBanners = [
						this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).getBannerSmall()
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

					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Noble, enemyStrength * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyNobleHouse"));
					this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Mercenaries, 60 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Flags.get("EnemyNobleHouse"));
					p.Entities.push({
						ID = this.Const.EntityType.Knight,
						Variant = this.Const.DLC.Wildmen && this.Contract.getDifficultyMult() >= 1.15 ? 1 : 0,
						Name = this.Const.Strings.KnightNames[this.Math.rand(0, this.Const.Strings.KnightNames.len() - 1)],
						Row = 2,
						Script = "scripts/entity/tactical/humans/knight",
						Faction = this.Flags.get("EnemyNobleHouse"),
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
			Text = "[img]gfx/ui/events/event_45.png[/img]{%employer% приглашает вас к себе. Он облачается в доспехи, а его военачальники пытаются отговорить его от участия в сражении. Даже в такой обстановке дворянин сердечно приветствует вас и быстро объясняет, чего он хочет.%SPEECH_ON%Мы собираемся завершить эту дурацкую войну. Мои главные силы собираются к %direction% отсюда. Я желаю, чтобы ты отправился туда и встретился с моим военачальником. %commander% же более подробно объяснит вашу задачу. Если твоему отряду удастся помочь нам победить вражеское войско - получишь щедрую плату, наёмник.%SPEECH_OFF% | Войдя в залу, вы видите, как %employer% дразнит собак знаменем дома %feudfamily%. Псы со злобой рвут ткань. %employer% переводит взгляд на вас.%SPEECH_ON%А, наёмник. Рад, что ты наконец пришёл. Я желаю, дабы ты и %commander% встретились к %direction% отсюда. Судьба этой проклятой войны скоро решится и, как я полагаю, люди твоего сорта помогут ускорить её окончание. Не могу сказать, чего стоит ожидать, кроме одного - все эти войны обычно заканчиваются весьма зрелищно. Да и плата твоя тоже будет впечатляющей.%SPEECH_OFF% | %employer% сидит в окружении своих военачальников, когда вы входите в залу. Они смотрят на карту, на которой расставлено огромное количество фигурок. Дворянин переводит взгляд на вас.%SPEECH_ON%А, наёмник. Отправишься вот сюда.%SPEECH_OFF%Он показывает место на карте.%SPEECH_ON%%commander% тебя встретит. Мы готовимся положить конец этой войне, раз и навсегда, и твоя помощь будет иметь решающее значение.%SPEECH_OFF%Вы киваете, но остаётесь на месте. Дворянин поднимает брови, а затем и палец.%SPEECH_ON%Ах да, твоя помощь будет оплачена! Не сомневайся в этом.%SPEECH_OFF% | %employer% никого не принимает. Впрочем, один из его военачальников с картой и свитком контракта наперевес останавливает вас. Он объясняет, что идёт великая битва и нужна ваша помощь. Если предложение будет принято, то %commander%, что даст вам дальнейшие инструкции, уже ждёт вас к %direction% отсюда. | Перед кабинетом нанимателя вас останавливает стражник. Он внимательно рассматривает знак отряда \'%companyname%\', вышитый на вашей груди, затем произносит.%SPEECH_ON%Мне приказано передать тебе это.%SPEECH_OFF%Он перекидывает вам свиток. В нём написано, что грядёт решающая битва и, если вы решите помочь, то конкретные приказы отдаст %commander% в своём лагере. Вы интересуетесь у стража, с кем стоит поговорить о цене - с нанимателем или же с ним самим? Тот нервно сглатывает, по его щеке стекает капля пота.%SPEECH_ON%Если уж так хочешь обсудить цену, обсуди её со мной.%SPEECH_OFF% | %employer% приветствует вас и ведёт к своему псарю. Собаки послушно сидят, когда он проходит мимо них. Он нежно проводит рукой по их головам.%SPEECH_ON%%commander%, возглавляющий моих людей к %direction% отсюда, докладывает, что грядёт решающая битва.%SPEECH_OFF%Дворянин останавливается и поворачивается к вам.%SPEECH_ON%Он полагает, что она положит конец войне с домом %feudfamily%. Поэтому я желаю, дабы ты отправился туда и помог завершить эту ужасную бойню.%SPEECH_OFF% | %employer% обнаруживается в зале, в окружении своих военачальников. Они с подозрением разглядывают вас, дворянин же отводит вас в сторону, желая поговорить наедине.%SPEECH_ON%Не обращай на них внимания. В общем, моё войско - его возглавляет %commander% - сейчас к %direction% отсюда. Я желаю, чтобы ты встретился с ним, а он объяснит, что делать дальше. Мои военачальники полагают, что грядёт решающая битва, так что нам понадобится любая помощь, которую мы сможем получить. Если это сражение действительно закончит войну, ты будешь вознаграждён соответственно.%SPEECH_OFF% | Стражник позволяет вам войти в залу, где %employer% восседает в окружении своих напыщенных военачальников. Они кричат друг на друга, переставляя фигурки на карте, больше занимаясь спорами, чем планированием сражения. %employer% встаёт и отводит вас в сторону.%SPEECH_ON%Не обращай внимания на шум. Вояки на грани, ведь мы, вполне возможно, близки к завершению этой проклятой войны с домом %feudfamily%. %commander%, а с ним и большая часть моего войска, находится к %direction% отсюда. Ему нужны любые подкрепления, в том числе и наёмники. Если ты согласишься отправиться туда и поможешь положить конец этой грёбаной войне, то будешь достойно вознаграждён%SPEECH_OFF% | %employer% ведёт вас на улицу, прямо к свинарнику. Вы видите свинью, лакомящуюся мертвецом. Неподалёку, пара козлов пережёвывают знамя дома %feudfamily%. %employer% с усмешкой обращается к вам.%SPEECH_ON%Лазутчик. Был. Сам понимаешь, как оно бывает. Ладно, %commander% сообщил мне, что он уверен в неизбежности скорой битвы с домом %feudfamily%. Он просит любых подкреплений, каких только возможно, и я намереваюсь их выслать. Если ты отправишься туда, встретишься с ним и выполнишь его приказы, то будешь щедро награждён.%SPEECH_OFF% | Вас встречает один из стражей нанимателя и ведёт к нему на личную встречу. %employer% расположился в небольшой комнатке, своеобразном убежище от тревог внешнего мира. Он читает книгу в окружении мерцающих свечей. Не поднимая на вас взгляда, он произносит.%SPEECH_ON%Приветствую, наёмник. %commander%, мой воевода, прислал весть, что войска дома %feudfamily% могут объединиться. Он считает, что у нас появилась возможность прекратить эту войну раз и навсегда.%SPEECH_OFF%Дворянин слюнявит большой палец и неспешно переворачивает страницу. Затем продолжает.%SPEECH_ON%Я желаю, чтобы ты отправился туда и присоединился к нему. Плата, разумеется, будет соответствовать твоим талантам, а они, как я подозреваю, велики.%SPEECH_OFF% | Один из стражников ведёт вас на вершину башни, где вы встречаете дворянина. %employer% переводит взгляд на вас.%SPEECH_ON%Отличный вид, а?%SPEECH_OFF%Вы оглядываете окрестности. Земля далеко внизу, люди смотрятся словно мелкие букашки, кишащие на ней. Маленькая тележка, запряжённая ослом, грохоча по булыжной мостовой, въезжает в ворота под башней, везя товар в %townname%. Вы пожимаете плечами. %employer% кивает.%SPEECH_ON%Я подумал, тебе может понравиться этот вид, но, по зрелом размышлении, деловые люди не позволяют подобным мыслям посещать разум, не обсудив прежде само дело. А оно не ждёт, наёмник. Один из моих военачальников сообщил, что войска дома %feudfamily% собираются вместе. Он полагает, что мы сможем завершить эту войну одной решающей битвой. Понимаешь?%SPEECH_OFF%Вы киваете. Он продолжает.%SPEECH_ON%Если будешь следовать приказам, твои услуги будут щедро оплачены. Я не знаю, доводилось ли тебе, наёмник, когда-либо побеждать в войне, но большинство заплатили бы огромные деньги за подобную услугу.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_96.png[/img]{По прибытию в лагерь, больше похожий на огромный палаточный город, вы находите военачальника. Он приглашает вас в свой шатёр с огромной картой внутри, показывающей как его войско, так и то место, где, как он полагает, находится войско дома %feudfamily%.%SPEECH_ON%Добро пожаловать, наёмник. Ты прибыл как раз вовремя.%SPEECH_OFF% | Военный лагерь заполнен скучающими людьми. Они помешивают рагу или играют в карты. Самая захватывающая вещь тут - битва между жуком и червём, бой, который ни для одной из сторон не представляет особого интереса. %commander% лично приветствует вас и приглашает в свой шатёр, заваленный картами, фигурками и другими подобными вещами. | Сквозь ряды палаток, вы направляетесь к шатру командующего, встречая не самую доброжелательную группу людей. Один кричит.%SPEECH_ON%Вы не похожи на девок, которых мы просили.%SPEECH_OFF%Солдаты смеются. %randombrother% орёт в ответ.%SPEECH_ON%Твоя мамочка уже позаботилась о нас, не волнуйся.%SPEECH_OFF%Как и ожидалось, оба тут же хватаются за оружие. Сам %commander% вынужден вмешаться, чтобы не допустить кровопролития. Он зовёт вас в свой шатёр.%SPEECH_ON%Рад, что ты пришёл. Хотя твоим людям не стоит нарываться, если мы хотим выиграть эту проклятую войну.%SPEECH_OFF% | Вы входите в лагерь, где застаёте воинов, наблюдающих за жучиными бегами. Они кричат, подгоняя одного из жучков, который, пройдя пол-пути по выстланной сеном дорожке, решает сразиться с другим бегуном. Азартные крики лишь усиливаются. %commander% находит вас в толпе и ведёт в свой шатёр.%SPEECH_ON%Рад, что ты пришёл, наёмник. У меня для тебя неотложное дело.%SPEECH_OFF% | По прибытию в военный лагерь, вы обнаруживаете толпу солдат, радостными воплями приветствующих полураздетую женщину, подъезжающую к ним на осле. Дама вкупе с ишаком заезжает в шатёр, который затем быстро заполняется мужчинами. %randombrother% спрашивает, не может ли он туда отлучиться. Вы отвечаете, что и сами не прочь присоединиться, так что вперёд! В то же мгновение вас останавливает %commander%. И ведёт в свой шатёр.%SPEECH_ON%Поверь мне, ты не захочешь на это смотреть.%SPEECH_OFF%Вы не верите ему. | Лагерь, которым управляет %commander%, превратил все окрестные земли в грязь. Все близлежащие леса вырублены, вместо них возведены хилые лачуги, проваливающиеся под своим весом в раскисшей почве. Ряды шатров тянутся до самого горизонта. Костры сияют, словно звёзды в ночном небе.\n\n %commander% встречает вас в своём шатре, полном карт и младших командиров, ожидающих приказов. | Военный лагерь полон звона и лязга. Кузнецы перековывают снаряжение, повара готовят своё жуткое варево, да ещё и называют его едой, простые воины вбивают опорные столбы для своих палаток. %commander% ждёт вас в своём шатре. Укрывшись от гула лагеря, он вместо этого почти оглох от \'доводов\' своих подчинённых. Он качает головой.%SPEECH_ON%В преддверии большого сражения люди беспокоятся. Не обращай внимания на эту перебранку.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_96.png[/img]{Возвратившись в военный лагерь, вы приказываете своим людям отдыхать. Кто знает, что ждёт вас завтра. | Итак, вы выполнили приказ, что отдал %commander%, но за ним наверняка последуют ещё. Нужно отдохнуть, пока есть возможность! | Военный лагерь ничуть не изменился со времени вашего ухода. Только вы не уверены, хорошо это или плохо. Завтра будет больше хлопот, так что вы приказываете отряду \'%companyname%\' устраиваться на отдых.}",
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
			Text = "[img]gfx/ui/events/event_54.png[/img]%commander% вводит вас в курс дела.%SPEECH_ON%{Наши разведчики повстречали вражеских. К сожалению, я не готовил своих следопытов к битвам, поэтому им нужна помощь. Противник расположился к %direction% отсюда. Убей их всех - и дом %feudfamily% останется в неведении относительно целей моего войска. | Несколько моих следопытов обнаружили разведчиков дома %feudfamily% к %direction% отсюда. Они обшаривают окрестности в поисках нашего войска, но найти его они не смогут, ибо ты отправишься туда и убьёшь их всех. Понял? | Разведчики дома %feudfamily% были замечены к %direction% отсюда. Я желаю, чтобы ты отправился туда и убил их, прежде чем они найдут лагерь или сообщат о том, что уже узнали за прошлые дни. | На войне нет ничего важнее осведомлённости. И недавно я узнал о том, что разведчики дома %feudfamily% шныряют к %direction% отсюда. Если я смогу выведать то, о чём им известно, а затем уничтожить то, что они выведали о нас, то в грядущих боях у нас будет преимущество.}%SPEECH_OFF%",
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
				local party = this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).spawnEntity(tile, "Разведчики", false, this.Const.World.Spawn.Noble, 60 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.getSprite("banner").setBrush(this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).getBannerSmall());
				party.setDescription("Опытные воины на службе у местной знати.");
				party.setFootprintType(this.Const.World.FootprintsType.Nobles);
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
			Text = "[img]gfx/ui/events/event_22.png[/img]{К сожалению, одному или нескольким разведчикам удалось ускользнуть. Вся информация, которую они собрали, теперь в руках дома %feudfamily%. | Проклятье! Нескольким разведчикам удалось сбежать и, без сомнения, вернуться к войску дома %feudfamily%.}",
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
			Text = "[img]gfx/ui/events/event_22.png[/img]{Все разведчики были убиты. Всё, что они разузнали, умерло вместе с ними. В грядущей битве это поможет нам. | Разведчики мертвы, и всё, что они знали, умерло вместе с ними.}",
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
			Text = "[img]gfx/ui/events/event_96.png[/img]{Вздохнув, %commander% произносит.%SPEECH_ON%Я не желаю тратить твои таланты попусту, наёмник, но мне нужен кто-то, кто выйдет из лагеря и соберёт припасы для войска. У нас заканчивается продовольствие и нам нужна вся возможная помощь.%SPEECH_OFF%Эй, это не оскорбление, раз уж за это платят. | %commander% прикусывает высохший листок и скрещивает руки на груди.%SPEECH_ON%Проклятье, я знаю, что ты пришёл сражаться. Я знаю, ты здесь, чтобы убивать людей и получать за это хорошую плату. Но прямо сейчас моё войско голодает, так что кто-то должен пойти и добыть еды.%SPEECH_OFF%Он подходит к одной из своих карт и указывает на отметку.%SPEECH_ON%Ты должен посетить этих крестьян и забрать у них еду. Им известно о твоём приходе, так что затруднений быть не должно. Считай это лёгкой прогулкой перед битвой, ладно?%SPEECH_OFF% | %commander% указывает на свиток, лежащий на одной из карт. Он весь покрыт цифрами, числа тем меньше, чем ниже расположены на пергаменте.%SPEECH_ON%У нас кончается продовольствие. Обычно мы пополняем запасы у крестьян к %direction% отсюда. Я хочу, чтобы ты отправился туда и проделал это ещё раз. Они будут ждать тебя, так что затруднений быть не должно.%SPEECH_OFF% | Вы разглядываете тарелку и лежащий на ней ломоть чёрствого хлеба. Рядом с ним лежит мясо, наполовину съеденное, наполовину отданное мухам. Сытый лоснящийся пёс весело машет хвостом в углу. %commander% подходит к одной из своих карт.%SPEECH_ON%У нас заканчиваются запасы еды. Если мои люди начнут голодать, то не смогут сражаться, а если они не будут сражаться - мы проиграем!%SPEECH_OFF%Вы киваете. Верный расчёт. Он продолжает.%SPEECH_ON%Уже некоторое время мы берём продовольствие у крестьян к %direction% отсюда. Я хочу, чтобы ты отправился туда и проделал это ещё раз. Один из моих стражников отдаст тебе список того, что нужно забрать. Сами крестьяне не будут препятствовать тебе. Им известно, что произойдёт, если они воспротивятся.%SPEECH_OFF% | В углу шатра вы замечаете учёного мужа. Он ведёт пером по свитку, покачивая головой. Внезапно, он вскакивает на ноги и отдаёт пергамент военачальнику. %commander% несколько раз кивает, затем переводит взгляд на вас.%SPEECH_ON%Некоторым наёмникам это покажется оскорбительным, но мне необходимо, чтобы отряд \'%companyname%\' отправился на хутор к %direction% и \'изъял\' их запасы пищи. Наше войско уже не в первый раз тревожит этих крестьян. В прошлый раз они пытались сопротивляться, но... думаю, эти холопы усвоили урок. Мой писарь передаст тебе список того, в чём мы нуждаемся. Воспринимай это как прогулку за покупками.%SPEECH_OFF%Лицо командующего искажает кривая усмешка.}",
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
			Text = "[img]gfx/ui/events/event_72.png[/img]{Хутор уже близко. Перед вами расстилаются бескрайние поля пшеницы, спелые колосья колышутся от ветра, словно морская гладь. %randombrother% проводит по ним рукой. %randombrother2% тут же бьёт его в плечо кулаком.%SPEECH_ON%Грабли убери! Пилильщика подцепить захотел?%SPEECH_OFF%Наёмник потирает ушиб, затем отвечает.%SPEECH_ON%Отвали! Моя рука шарит, где захочет, можешь у своей мамочки поинтересоваться.%SPEECH_OFF%Обмен тычками быстро перерастает в драку, разрушая безмятежную сценку. | На горизонте уже виден хутор. Спелые колосья на полях колышутся под свежим ветерком, словно морская гладь. Батраки с косами прорубают путь сквозь плотные ряды пшеницы, вспомогательный отряд с вилами собирает солому. Замыкают строй ослы, тянущие телеги по неровной земле. | Хутор широко раскинулся средь холмов, здешняя земля слишком хороша, чтобы обращать внимание на её неровную поверхность. Поля полны урожаем и наводнены батраками: косы и вилы равномерно поднимаются и опускаются, радостно вспыхивая на солнце. В отдалении вы замечаете землевладельцев, но, хоть они выглядят весьма недовольными, мало кто решится проявить свой гнев перед строем отряда \'%companyname%\'.}",
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
			Text = "[img]gfx/ui/events/event_10.png[/img]{Как только вы приблизились к крестьянам, звучит боевой клич, а со всех сторон появляются вооружённые до зубов люди. Это засада! | Подойдя ближе к хутору, вы замечаете, что нагруженные едой телеги откатываются назад, открывая отряд вооружённых до зубов людей. Крестьяне тут же испаряются. %randombrother% обнажает оружие.%SPEECH_ON%Это засада!%SPEECH_OFF% | Вы подходите к телегам с продовольствием. Крестьяне расступаются при виде того, как %randombrother% выходит вперёд и сдёргивает полотно с одной из повозок. Внутри ничего нет. Внезапно в стенку телеги с глухим стуком впивается стрела. Крестьяне пригибаются и бросаются врассыпную, а их место занимают вооружённые до зубов люди. Это засада!}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "К оружию!",
					function getResult()
					{
						local p = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						p.CombatID = "Ambush";
						p.Music = this.Const.Music.CivilianTracks;
						p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Center;
						p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Circle;
						local n = 0;

						do
						{
							n = this.Math.rand(1, this.Const.PlayerBanners.len());
						}
						while (n == this.World.Assets.getBannerID());

						p.Entities = [];
						p.EnemyBanners = [
							this.Const.PlayerBanners[n - 1],
							"banner_noble_11"
						];
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.Mercenaries, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Const.Faction.Enemy);
						this.Const.World.Common.addUnitsToCombat(p.Entities, this.Const.World.Spawn.PeasantsArmed, 40 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Const.Faction.Enemy);
						this.World.Contracts.startScriptedCombat(p, false, true, true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "UnrulyFarmers",
			Title = "На хуторе...",
			Text = "[img]gfx/ui/events/event_43.png[/img]Вы приближаетесь к крестьянам, но они не обращают на вас особого внимания. Староста, скрестив руки на груди, качает головой.%SPEECH_ON%{Смотри, мои ребята уже погрузили всё в телеги. Но и ты пойди мне навстречу. Нам нужно кормить семьи, да и податей никто не отменял. Как насчёт справедливой сделки: ты платишь нам %cost% крон, а %commander% получит то, что ему нужно. | Вы же наёмники, верно? Тогда ты побольше прочих понимаешь ценность золота. Мы простые крестьяне, а не ростовщики. Всё, что мы просим - это небольшое вознаграждение за нашу работу. Заплати нам %cost% крон, а мы отдадим тебе еду. Мы всё равно останемся в убытке, но это будет хоть сколько-то справедливо. | Ты пришёл сюда со своим надраенным оружием и думаешь, что этого достаточно, дабы согнуть нас в бараний рог? %commander% и так забрал почти всё. И вот что я скажу - пришла пора платить за еду, как и положено! Так что вот тебе моё предложение: я готов продать еду за %cost% крон. Думаю, это справедливая цена.}%SPEECH_OFF%",
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
			Text = "[img]gfx/ui/events/event_22.png[/img]Противник был слишком силён! Вы собираете оставшихся людей и приказываете отступать. %commander% вместе со своим войском больше не получит еды, а слухи о поражении отряда \'%companyname%\' разнесутся широко.",
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
			Text = "[img]gfx/ui/events/event_60.png[/img]{Крестьяне и их наёмные клинки повержены. Староста, придерживая вываливающиеся из распоротого живота внутренности, молит о пощаде. Вы качаете головой.%SPEECH_ON%Ты сам это выбрал, смерд. Вот тебе моё милосердие.%SPEECH_OFF%Клинок перерезает его глотку. Крестьянин хрипит, но быстро затихает. Вы же приказываете своим людям собрать еду и готовиться к возвращению. %commander% ждёт. | Крестьяне и их наёмники убиты. Вы приказываете своим людям собрать еду. %commander%, да и всё его войско, будут рады вашему возвращению. | Некоторые продукты покрылись кровью, но её легко смыть водой. %commander%, да и всё его войско, оценят вашу работу. | %randombrother% поднимает крестьянина, что пытался притвориться мёртвым, и перерезает ему глотку. Тот, хрипя и содрогаясь, вырывается из хватки наёмника. Он ковыляет к одной из повозок, заливая кровью все продукты, лежащие там. Вы кричите.%SPEECH_ON%Проклятье, убери его оттуда!%SPEECH_OFF%От крестьянина быстро избавляются, но груз, без сомнений, уже испорчен. Вы качаете головой.%SPEECH_ON%Прикрой это тканью. Быть может, никто и не заметит.%SPEECH_OFF% | Добыча продовольствия оказалась немного сложней, чем вы рассчитывали, но еда всё же оказывается в ваших руках. Право владеть этой землёй вы даруете одному из выживших батраков - тому, что с портянками из мешковины вместо сапог.%SPEECH_ON%Помни о том, что сегодня случилось с твоим хозяином, ведь это непременно случится и с тобой, если забудешь своё место, понял?%SPEECH_OFF%Парень торопливо кивает. Вы же приказываете отряду \'%companyname%\' готовиться к возвращению. %commander% ждёт.}",
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
			Text = "[img]gfx/ui/events/event_55.png[/img]{Крестьяне тепло приветствуют вас.%SPEECH_ON%Дай-ка угадаю, тебя прислал %commander%?%SPEECH_OFF%Вы киваете. Крестьянин сплёвывает и кивает в ответ.%SPEECH_ON%Понятно. У тебя здесь проблем не будет. Ребята, помогите им погрузить еду.%SPEECH_OFF%Батраки помогают вашим людям загрузить продовольствие в телеги. Пора возвращаться. %commander% ждёт. | Вы встречаетесь со старостой. Он пожимает вашу руку.%SPEECH_ON%%commander% отправил мне почтового голубя с посланием о приходе наёмников, но вы снаряжены получше любого другого отряда из виденных мной. Мои парни помогут загрузить повозки, чтобы вы поскорее отправились в путь.%SPEECH_OFF% | Крестьяне грузят продукты в повозки неподалёку от вас. Их староста выходит вперёд.%SPEECH_ON%Не скажу, что это мне по душе, но лучше уж я поработаю тут, в полях, чем буду сидеть в каком-нибудь военном лагере, ожидая смерти в войне, о которой ничего и не знаю. Мои парни помогут тебе загрузить повозки, чтобы вы побыстрее отправились в путь. А когда %commander% встретит тебя, замолви на нас словечко, ладно? Я хочу сохранить этот хутор.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Я уверен, дом %noblehouse% оценит это.",
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
			Text = "[img]gfx/ui/events/event_43.png[/img]{Вы обнажаете меч. Крестьяне тут же отступают назад и, ощетинившись вилами, начинают переговариваться меж собой. Их староста сплёвывает и вытирает рот рукавом.%SPEECH_ON%Проклятье, хочешь ограбить нас? Ну давай, попробуй!%SPEECH_OFF% | Вы качаете головой.%SPEECH_ON%Сделки не будет. Ты отдашь еду или познаешь наш гнев.%SPEECH_OFF%Крестьянин перебрасывает вилы из руки в руку. Его люди неспешно поднимают своё оружие. Он кивает.%SPEECH_ON%Мы крестьяне, сволочь. Мы сроднились с гневом уже очень, очень давно.%SPEECH_OFF% | Вы пришли сюда не ради того, чтобы заключать сделки.%SPEECH_ON%Никакой платы не будет. %commander% отправил нас сюда, чтобы...%SPEECH_OFF%Крестьянин смеётся и перебивает вас.%SPEECH_ON%Он послал сюда несколько своих собачек на побегушках. Ну ладно, пёсик, давай посмотрим, сможешь ли ты не только лаять, но и кусаться!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Сказано - сделано.",
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
			Text = "[img]gfx/ui/events/event_55.png[/img]{У вас нет причин проливать кровь несчастных хуторян, просто пытающихся выжить. Передавая золото, вы советуете крестьянину быть поосторожнее с подобными сделками.%SPEECH_ON%Не все будут столь добры, чтобы договариваться с тобой.%SPEECH_OFF%Крестьянин поворачивает голову, показывая длинный шрам, идущий от макушки к плечу.%SPEECH_ON%Я знаю это на своём опыте. Спасибо за предостережение, наёмник.%SPEECH_OFF% | Вы убиваете крестьян только за плату. %commander% же платил не за это. Так что вы принимаете их предложение. Староста пожимает вашу руку.%SPEECH_ON%Благодарю тебя, наёмник. В наши дни редко встретишь человека, с которым можно договориться. Я уж было подумал, что ты лишь очередной громила, но в проницательности тебе явно не откажешь. | Вы прошли весь это путь не ради убийства несчастных крестьян, так что соглашаетесь на предложение старосты. Он же благодарит вас за то, что вы прошли весь это путь не ради убийства несчастных крестьян. %randombrother%, меж тем, тихо замечает, что тоже прошёл весь это путь не ради... Вы громко приказываете ему заткнуться и приступать к погрузке еды.}",
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
			Text = "[img]gfx/ui/events/event_96.png[/img]{Луч рассветного солнца проникает в ваш шатёр, попадая прямо в глаза, буквально тыкая вас носом в начало нового дня. | Вы встаёте и одеваете сапоги, вытряхивая пауков, которые выбрали их в качестве места для ночлега. | Неподалёку от вашего шатра, петух громким кукареканьем напоминает миру о том, что он - самый мерзкий его представитель. Вы неохотно встаёте. | Вы пережили ещё один день. Чудесно. | Вы спали как убитый, да и выглядите сейчас точно так же. Луч солнца, что проник в ваш шатёр, светит вам прямо в лицо, так, что невозможно дальше нежиться в постели, а откинутый полог шатра слишком далеко от вас, чтобы до него можно было дотянуться. Ну да ладно, пора вставать. | Утро. В эту неотвратимую пору солнечный свет возвращает в разум тысячи сожалений прошедших дней.}\n\nУ порога вашего шатра мнётся паренёк со свитком. Он разворачивает его и пытается прочесть.%SPEECH_ON%{Сим по... по-ве... па-ви-ли-ва-ю... тьфу, просто сходи и узнай у воеводы, чего он там хочет. | %commander% же-ла-ет ви-деть тебя, он... по-ве-ле-ва... по-ве-ше... Чего? Слушай, я не умею читать. Просто сходи к нему сам. | Господин, этот свиток говорит мне сказать тебе, что ты... э-э-э... ты... кхм, должен... сходить к воеводе. Вот. Там вообще-то гораздо больше написано, но мне и дня не хватит, чтобы всё это прочитать. | Ну да, читать я не умею, но думаю, что воевода хочет видеть тебя. | Та-ак, посмотрим, эта буква... Я ведь знаю эту букву... Это буква \'Я\'! Э-э-э... в общем, остальная часть этого дерьма не так уж и важна. Слушай, просто сходи к воеводе. Думаю, он именно этого и хочет.}%SPEECH_OFF%",
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
			Text = "[img]gfx/ui/events/event_96.png[/img]%commander% встречает вас в своей палатке. Выглядит он довольно возбуждённым. Рядом с ним стоит невысокого роста мужчина с хитрым и внимательным взглядом. Командир говорит скороговоркой.%SPEECH_ON%{Сорока - вот эта вот сорока, принесла на хвосте весть о том, что обоз со снаряжением следует в лагерь войска дома %feudfamily%. Если мы сможем перехватить и уничтожить его, то ослабим их в грядущих битвах! | Здравствуй, наёмник. Мои лазутчики сообщили, что обоз со снаряжением, столь необходимым дому %feudfamily%, следует в их лагерь. Я хочу, чтобы ты перехватил и уничтожил его. | Разве лазутчики не чудесны? Взгляни на этого парня. Он сказал мне: господин, большой обоз отправился в лагерь дома %feudfamily%. Оружие, доспехи, еда и многое, многое другое. А я на это ответил: у меня есть именно тот человек, что сможет извлечь пользу из этих новостей. И этот человек - ты! Отправляйся, перехвати этот обоз и сожги его дотла. | Ты ведь понимаешь, наёмник, что сражения зачастую выигрываются ещё до их начала, не так ли? Мой верный лазутчик разузнал, что прямо сейчас в лагерь дома %feudfamily% направляется большой обоз с оружием и доспехами. Если ты со своими людьми сможешь перехватить его, то войско противника будет куда хуже подготовлено к решающему сражению. | Известно ли тебе, что однажды я выиграл битву, даже не обнажив клинка? Мне удалось перехватить обоз со снаряжением, столь необходимый вражескому войску, из-за чего они были просто не в силах сражаться - и сдались. Мой верный лазутчик поведал мне, что дом %feudfamily% сейчас ожидает подобный караван. Если ты перехватишь и уничтожишь обоз, то войну это, полагаю, не закончит, но мы получим весомое преимущество. | Известно ли тебе, что войско без снаряжения - это и не войско вовсе? Меж тем, у армии дома %feudfamily% заканчиваются запасы. Собственно, они до сих пор не напали именно потому, что ожидают большой груз оружия и доспехов! А мой дорогой лазутчик обнаружил этот обоз. И я желаю, дабы ты перехватил и уничтожил его. | У меня отличные новости, наёмник. Дом %feudfamily% ожидает большой обоз с оружием и доспехами - и нам известно, какой дорогой он пойдёт! Я же хочу, дабы ты уничтожил этот караван, нанеся моему врагу рану, от которой он уже не сможет оправиться.}%SPEECH_OFF%",
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
				local startTile = this.World.getEntityByID(this.Flags.get("InterceptSuppliesStart")).getTile();
				local destTile = this.World.getEntityByID(this.Flags.get("InterceptSuppliesDest")).getTile();
				local enemyFaction = this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse"));
				local party = enemyFaction.spawnEntity(startTile, "Караван снабжения", false, this.Const.World.Spawn.NobleCaravan, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
				party.getSprite("base").Visible = false;
				party.getSprite("banner").setBrush(this.World.FactionManager.getFaction(this.Flags.get("EnemyNobleHouse")).getBannerSmall());
				party.setMirrored(true);
				party.setVisibleInFogOfWar(true);
				party.setImportant(true);
				party.setDiscovered(true);
				party.setDescription("Караван с вооружённой охраной, перевозящий провизию, припасы и снаряжение между поселениями.");
				party.setFootprintType(this.Const.World.FootprintsType.Caravan);
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
			Text = "[img]gfx/ui/events/event_55.png[/img]{Вы не смогли уничтожить обоз. Снаряжение, несомненно, уже в руках войск дома %feudfamily%, так что в будущем они будут сражаться лучше. | Обоз не был уничтожен. Вы можете быть уверены, что армия дома %feudfamily% будет полностью готова к предстоящему сражению. | Проклятье. Обоз не был уничтожен. И теперь войско дома %feudfamily% будет готово к грядущей битве.}",
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
			Text = "[img]gfx/ui/events/event_60.png[/img]{Вы рассчитывали поживиться на останках каравана, но его охранники подожгли всё, что могло имело хоть какую-то ценность. К несчастью, удалось добиться лишь того, что снаряжение не попало в руки войска дома %feudfamily%. | Вы уничтожили большую часть обоза, а остальное подожгли сами охранники, не желая отдавать добро во вражеские руки. %commander% будет очень доволен подобным результатом. | Сражение было нелёгким, но вам удалось умертвить охранников каравана. К сожалению, они применили тактику \'выжженной земли\' и сожгли повозки, прежде чем вы смогли до них добраться. Они понимали, что нельзя отдать снаряжение во вражеские руки. Тем не менее, %commander% будет доволен результатом. | Нужно признать, охранники каравана дали хороший бой, но отряд \'%companyname%\' вырезал их до последнего человека. По крайней мере, вы так полагали, но в разгаре битвы одному из них удалось выскользнуть и показать в деле отличное знание тактики выжженной земли. Все повозки сгорели дотла. Видимо, дом %feudfamily% полагает, что если уж он не получит это снаряжение, то никто его не получит. Мелочно, но умно. Тем не менее, %commander%, да и всё его войско, будут довольны результатом. | Караван был вырезан. Вы рассчитывали захватить несколько повозок и поживится снаряжением, но один из охранников сумел поджечь все телеги, не желая, дабы ценности попали во вражеские руки. Тем не менее, войско дома %feudfamily% было, вне всяких сомнений, ослаблено.}",
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
			Text = "[img]gfx/ui/events/event_96.png[/img]{При входе в шатёр воеводы вам приходится уклоняться от свечи, пущенной прямо в лицо. Она с шипением приземляется в грязь, следом туда же кувырком летит стол, сопровождаемый картами. %commander% с багровым от гнева лицом, тяжело дыша и уперев руки в бока, стоит в средоточии этого бардака. Он объясняется.%SPEECH_ON%Дезертиры! Они сбежали! Близится важнейшая битва в моей жизни, а я не могу сдержать в узде моих проклятых людей! Слушай, я не могу позволить моему войску развалиться. Я хочу, чтобы ты настиг этих беглецов и вернул их ко мне. Если же они откажутся возвращаться - убей их. Один из часовых утверждает, что видел их уходящими к %direction% отсюда. Поспеши!%SPEECH_OFF% | Как только вы собрались войти в шатёр воеводы, оттуда вылетает незнакомец. %commander% выбегает вслед за ним и швыряет его в грязь. Затем хватает за шиворот и трясёт, словно тряпичную куклу.%SPEECH_ON%Куда они пошли? Клянусь древними богами, я заставлю тебя молить о смерти, если не получу честный ответ!%SPEECH_OFF%Незнакомец, крича, называет место.%SPEECH_ON%К %direction%! Они пошли туда, я клянусь!%SPEECH_OFF%%commander% отпускает незнакомца - прямо в руки стражей, которые куда-то его уводят. Воевода выпрямляется и приглаживает волосы.%SPEECH_ON%Несколько моих людей решили сбежать из лагеря. Найди их, наёмник. Верни их. Понял?%SPEECH_OFF%Вы киваете, но спрашиваете, как поступить, если они откажутся возвращаться. Воевода пожимает плечами.%SPEECH_ON%Перережь им глотки, разумеется.%SPEECH_OFF% | Войдя в шатёр военачальника, вы застаёте его стоящим рядом с привязанным к стулу незнакомцем. %commander% сжимает в руках клещи, в зубцах которых белеет вырванный зуб. Пленник обессиленно обмяк на стуле, из его рта стекает струйка крови. %commander% бросает клещи на стол и проводит красной от крови рукой по волосам.%SPEECH_ON%Несколько моих людей дезертировали. А я не могу рисковать целостностью моего войска, особенно сейчас, когда близится сражение. Мой приятель, сидящий здесь, пока был в силах говорить, поведал мне, что его товарищи собирались бежать к %direction% отсюда. Иди, наёмник, и приведи ко мне этих дезертиров.%SPEECH_OFF%Уходя, вы спрашиваете, как поступить, если беглецы откажутся возвращаться. Военачальник с изумлением отвечает.%SPEECH_ON%А ты как думаешь? Убей их всех!%SPEECH_OFF% | Вы обнаруживаете военачальника разглядывающим карты. Его пальцы, сжимающие столешницу, побелели от напряжения, по ногам пробегают судороги. %commander% переводит взгляд на вас. Его глаза блестят от едва сдерживаемой ярости.%SPEECH_ON%Несколько моих людей решили сбежать от грядущей битвы. Часовые доложили, что видели их уходящими к %direction% отсюда. Найди их. Верни их.%SPEECH_OFF%Вы спрашиваете, хочет ли он видеть их живыми. Он задумчиво кивает.%SPEECH_ON%Я хочу, чтобы они вернулись назад в полном здравии, чтобы лучше потом почувствовали, какие последствия грядут за бегством из моего войска. Впрочем, если они откажутся возвращаться - принеси мне их головы. Это тоже будет всем хорошим уроком, напоминающим, что не стоит дезертировать, верно?%SPEECH_OFF% | %commander% приказал привязать одного из младших командиров к опоре шатра. Воевода, взяв в руки длинную палку, обрушивает на него град ударов. Несчастный кричит от боли, отворачивается, желая закрыться от ударов, но это приводит лишь к тому, что палка теперь бьёт по его спине. Когда его багровое лицо вновь поворачивается к вам, командир уже теряет сознание.\n\n %commander% отбрасывает палку и начинает вытаскивать занозы из ладони.%SPEECH_ON%Рад, что ты пришёл, наёмник. Несколько моих людей дезертировали, так что я хочу, чтобы ты выследил их. Приведи их сюда живьём или убей, если они откажутся возвращаться. Мой друг, висящий здесь, поведал, что они собирались бежать к %direction% отсюда. Ему же будет лучше, если он сказал правду.%SPEECH_OFF%Вы тоже надеетесь, что он сказал правду.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Отряд отправится в течении часа.",
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
			Text = "[img]gfx/ui/events/event_88.png[/img]{Вы застаёте дезертиров сидящими вокруг затухающего костра, один из них ворошит угли, пытаясь вновь раздуть пламя. Заметив вас, он застывает. Остальные беглецы, проследив за его взглядом, поспешно вскакивают на ноги.%SPEECH_ON%Мы не вернёмся. Передай воеводе, чтобы он катился в преисподнюю.%SPEECH_OFF% | Дезертиры спорят между собой, когда вы появляетесь и окружаете их. Один из беглецов начинает пятиться.%SPEECH_ON%%commander% послал тебя? Передай ему, чтобы он катился прямиком в преисподнюю!%SPEECH_OFF%Другой дезертир показывает неприличный жест.%SPEECH_ON%Да, мы не вернёмся!%SPEECH_OFF%Несомненно, дезертиры не хотят вас слушать.. | %randombrother% указывает на группу людей, стоящих у путевого знака. Они увлечённо спорят между собой, не слыша вашего приближения. Вы резко свистите, после чего они сразу же замолкают и поворачиваются. Один из них подходит к вам.%SPEECH_ON%Этот крысюк-командир послал наёмников по нашему следу?%SPEECH_OFF%Вы киваете и объясняете, что они должны вернуться с вами. Другой дезертир качает головой.%SPEECH_ON%Вернуться? А как насчёт того, чтобы ты смотался отсюда? Мы не собираемся возвращаться, так что беги назад и сообщи это воеводе!%SPEECH_OFF% | Вы застаёте дезертиров за дележом еды из походной котомки. Завидев вас, они замирают, а один пытается проглотить свою долю целиком. И давится. Остальные беглецы стоят недвижимо. Подавившийся судорожно шарит вокруг в поисках помощи, его лицо постепенно багровеет. Его нога опрокидывает походную котомку, вышвыривая оттуда еду. Вы киваете.%SPEECH_ON%Помогите своему товарищу.%SPEECH_OFF%Дезертиры спешно бросаются к задыхающемуся и что есть сил колотят его по спине, выбивая застрявший кусок. Он жадно хватает воздух. Вы же начинаете объяснять, зачем %commander% вас послал, но один из дезертиров перебивает вас.%SPEECH_ON%Нет. Мы не вернёмся. Эта война - полное дерьмо. Мы не хотим в ней участвовать.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_88.png[/img]{Вы берёте сумку и насыпаете в неё %bribe% крон.%SPEECH_ON%Я заплачу вам за возвращение в военный лагерь. %commander% гневается на вас, даже не сомневайтесь, но у него сейчас каждый человек на счету. Если вы будете сражаться за него в грядущей битве, то он, без сомнений, простит ваш небольшой проступок.%SPEECH_OFF% | Вы предлагаете дезертирам %bribe% крон. Они переглядываются между собой, а затем отвечают.%SPEECH_ON%И как эти деньги нам помогут, когда воевода прикажет нас всех повесить?%SPEECH_OFF%Вы киваете и отвечаете.%SPEECH_ON%Хороший вопрос. %commander% ведь не дурак. В грядущей битве ему потребуются все люди, что встанут рядом с ним. Проявите себя в этой битве и ваша небольшая шалость, несомненно, будет забыта.%SPEECH_OFF%}{Дезертиры обдумывают варианты и в конце концов соглашаются вернуться с вами. | Дезертиры совещаются и приходят к какому-то решению. Распихивая остальных, их вожак выходит вперёд.%SPEECH_ON%Несмотря на некоторые опасения, мы решили вернуться с тобой в военный лагерь. Надеюсь, я не пожалею об этом.%SPEECH_OFF% | После непродолжительного спора о том, как поступить, дезертиры решили его голосованием. С большим трудом они приходят к соглашению: стоит вернуться к военачальнику. | Дезертиры спорят о том, что делать дальше. Как вы и ожидали, они решают вопрос голосованием. Как вы и опасались, голоса разделяются поровну. Тогда они решают подбросить монету, доверив ей выбор - возвратиться в лагерь или уйти. Вожак беглецов подбрасывает золотой, все провожают его глазами. Выпало возвращение. Все дезертиры с облегчением вздыхают, ведь слепой случай освободил их от великого бремени принятия собственного решения.}",
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
			Text = "[img]gfx/ui/events/event_88.png[/img]{%bigdog% шагает вперёд, со свистом взмахнув клинком и положив лезвие на плечо.%SPEECH_ON%%commander%. Вы боитесь его. Это понятно. Вы знаете его, знаете его мстительность, знаете, на что он способен. Но вопрос в том...%SPEECH_OFF%Наёмник ухмыляется, его кривая улыбка отражается на лезвии клинка.%SPEECH_ON%Знаете ли вы, на что способен я?%SPEECH_OFF% | Дезертиры собрались уходить, когда %bigdog% громко свистит.%SPEECH_ON%Эй вы, жалкие трусы, мой командир отдал приказ.%SPEECH_OFF%Один из дезертиров усмехается.%SPEECH_ON%Да ну? А ничего, что это - не наш командир? Так что возьми этот приказ и засунь его себе сам знаешь куда!%SPEECH_OFF%%bigdog% обнажает свой огромный клинок и упирает остриё в землю, положив руки на рукоять.%SPEECH_ON%%commander% - ты боишься его, это разумно. Но если продолжишь вести себя как подзаборная шавка, то вскоре узнаешь, какого из командиров действительно стоит бояться.%SPEECH_OFF% | Дезертиры разворачиваются, собираясь уходить, но в этот же миг %bigdog% обнажает свой огромный меч и со звоном ударяет им о доспех. Дезертиры медленно поворачиваются обратно, %bigdog% широко улыбается.%SPEECH_ON%Кому-нибудь из вас уже приходилось обмачивать штанишки?%SPEECH_OFF%Один из дезертиров качает головой.%SPEECH_ON%Слушай, мужик, отвали вместе со своими разговорами.%SPEECH_OFF%%bigdog% указывает остриём клинка на беглеца.%SPEECH_ON%Ух ты, хочешь, чтобы я заткнулся? Ты лучше скажи мне ещё что-нибудь подобное - и тогда вы все здесь замолчите. Навечно.%SPEECH_OFF%}{Дезертиры, обсудив возможные решения, в конце концов соглашаются вернуться с вами. | Дезертиры совещаются и приходят к какому-то решению. Распихивая остальных, их вожак выходит вперёд.%SPEECH_ON%Несмотря на некоторые опасения, мы решили вернуться с тобой в военный лагерь. Надеюсь, я не пожалею об этом.%SPEECH_OFF% | После непродолжительного спора о том, как поступить, дезертиры решили его голосованием. С большим трудом они приходят к соглашению: стоит вернуться к военачальнику. | Дезертиры спорят о том, что делать дальше. Как вы и ожидали, они решают вопрос голосованием. Как вы и опасались, голоса разделяются поровну. Тогда они решают подбросить монету, доверив ей выбор - возвратиться в лагерь или уйти. Вожак беглецов подбрасывает золотой, все провожают его глазами. Выпало возвращение. Все дезертиры с облегчением вздыхают, ведь слепой случай освободил их от великого бремени принятия собственного решения.}",
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
			Text = "[img]gfx/ui/events/event_88.png[/img]{Дезертиры собираются уходить, но %motivator% выходит вперёд и прочищает горло.%SPEECH_ON%Так вот как это будет, да? Собираетесь забыть о своём долге, подобно змее, забывающей о сброшенной шкуре? Я знаю, что вы чувствуете. Я знаю, вы не видите смысла в этой войне, не хотите рисковать своими жизнями во имя какого-то самодовольного дворянина, который понятия не имеет, через что вам пришлось пройти. Это справедливо. Но однажды, через много лет, когда вы будете держать на руках своего внука, он попросит рассказать, как вы сражались на войне. И вам придётся солгать своей родной крови.%SPEECH_OFF% | %motivator% засовывает пальцы в рот и резко свистит. Дезертиры поворачиваются к нему, а он начинает говорить.%SPEECH_ON%Вот и всё, да? Вы действительно собрались возложить на себя эту ношу? А что вы расскажете своим сыновьям, когда придёт время? Что вы - дезертиры, бросившие своих братьев умирать вместо себя? И не сомневайтесь, ваше бегство неминуемо приведёт к гибели людей, что не должны были пасть! Ваша трусость ляжет на душу неизмеримой тяжестью!%SPEECH_OFF% | %motivator% взывает к беглецам.%SPEECH_ON%Допустим, вы сейчас уйдёте. Предав своё знамя и свой долг. Но что будет, когда дом %feudfamily% победит, а?%SPEECH_OFF%Один из дезертиров пожимает плечами.%SPEECH_ON%Они меня не знают. Я просто вернусь в свою деревню к семье.%SPEECH_OFF%%motivator% со смехом качает головой.%SPEECH_ON%Ты правда так думаешь? А что ты будешь делать, когда эти чужаки придут в твою деревню? Когда они увидят твою жену и твоих детей? Ты что, не понимаешь, во что может перерасти эта война? У тебя не будет дома, в который ты мог бы вернуться, дурак!%SPEECH_OFF%}{Дезертиры обсуждают своё положение и в конце концов соглашаются вернуться с вами. | Дезертиры совещаются и приходят к какому-то решению. Распихивая остальных, их вожак выходит вперёд.%SPEECH_ON%Несмотря на некоторые опасения, мы решили вернуться с тобой в военный лагерь. Надеюсь, я не пожалею об этом.%SPEECH_OFF% | После непродолжительного спора о том, как поступить, дезертиры решили его голосованием. С большим трудом они приходят к соглашению: стоит вернуться к военачальнику. | Дезертиры спорят о том, что делать дальше. Как вы и ожидали, они решают вопрос голосованием. Как вы и опасались, голоса разделяются поровну. Тогда они решают подбросить монету, доверив ей выбор - возвратиться в лагерь или уйти. Вожак беглецов подбрасывает золотой, все провожают его глазами. Выпало возвращение. Все дезертиры с облегчением вздыхают, ведь слепой случай освободил их от великого бремени принятия собственного решения.}",
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
			Text = "[img]gfx/ui/events/event_88.png[/img]{%bigdog% шагает вперёд, со свистом взмахнув клинком и положив лезвие на плечо.%SPEECH_ON%%commander%. Вы боитесь его. Это понятно. Вы знаете его, знаете его мстительность, знаете, на что он способен. Но вопрос в том...%SPEECH_OFF%Наёмник ухмыляется, его кривая улыбка отражается на лезвии клинка.%SPEECH_ON%Знаете ли вы, на что способен я?%SPEECH_OFF% | Дезертиры собрались уходить, когда %bigdog% громко свистит.%SPEECH_ON%Эй вы, жалкие трусы, мой командир отдал приказ.%SPEECH_OFF%Один из дезертиров усмехается.%SPEECH_ON%Да ну? А ничего, что это - не наш командир? Так что возьми этот приказ и засунь его себе сам знаешь куда!%SPEECH_OFF%%bigdog% обнажает свой огромный клинок и упирает остриё в землю, положив руки на рукоять.%SPEECH_ON%%commander% - ты боишься его, это разумно. Но если продолжишь вести себя как подзаборная шавка, то вскоре узнаешь, какого из командиров действительно стоит бояться.%SPEECH_OFF% | Дезертиры разворачиваются, собираясь уходить, но в этот же миг %bigdog% обнажает свой огромный меч и со звоном ударяет им о доспех. Дезертиры медленно поворачиваются обратно, %bigdog% широко улыбается.%SPEECH_ON%Кому-нибудь из вас уже приходилось обмачивать штанишки?%SPEECH_OFF%Один из дезертиров качает головой.%SPEECH_ON%Слушай, мужик, отвали вместе со своими разговорами.%SPEECH_OFF%%bigdog% указывает остриём клинка на беглеца.%SPEECH_ON%Ух ты, хочешь, чтобы я заткнулся? Ты лучше скажи мне ещё что-нибудь подобное - и тогда вы все здесь замолчите. Навечно.%SPEECH_OFF%}{Дезертиры не смогли договориться меж собой и решают вопрос голосованием. Большая часть решила уходить. Их вожак сообщает вам о результатах голосования и прощается с вами. %commander% будет недоволен, вы же обнажаете клинок и говорите беглецам, что теперь для них есть лишь один путь. Вожак оборачивается с мечом в руке и кивает.%SPEECH_ON%Знаю, я так и понял, что вы пришли сюда не ради разговоров. К оружию, ребята.%SPEECH_OFF% | %commander% будет крайне недоволен, но дезертиры отказываются возвращаться. Они не видят причин участвовать в этой бойне. Вы желаете их вожаку удачи. Он начинает благодарить вас, но тут же замолкает, видя, как вы обнажаете клинок, а остальные воины отряда \'%companyname%\' следуют вашему примеру. Вожак дезертиров тяжело вздыхает.%SPEECH_ON%Да, я был уверен, что всё так и закончится.%SPEECH_OFF%Вы киваете.%SPEECH_ON%Ничего личного. Мне плевать на ваш проступок, но у нас есть работа - и мы её сделаем.%SPEECH_OFF% | Дезертиры не в силах прийти к решению, так что они оставляют всё на волю случая. Их вожак достаёт монету и подбрасывает её в воздух. От того, как она выпадет, зависит, вернуться они в лагерь или уйдут. Им суждено уйти. Дезертиры с облегчением вздыхают. Их вожак хлопает вас по плечу.}{%SPEECH_ON%Судьба решила за нас, наёмник.%SPEECH_OFF%Вы киваете и обнажаете клинок, вашему примеру следует остальной отряд.%SPEECH_ON%Помни об этом, умирая от моего клинка.%SPEECH_OFF%Лицо вожака беглецов озаряет слабая усмешка. Он обнажает меч.%SPEECH_ON%Да будет так. Лучше погибнуть на пути к свободе, чем вернуться и сдохнуть в той бойне.%SPEECH_OFF% | Вожак спокойно отказывается вернуться.%SPEECH_ON%Мы не искали лёгкого пути, нарушая присягу. Мы не вернёмся.%SPEECH_OFF%Вы приказываете отряду \'%companyname%\' обнажить клинки. Вожак беглецов вздыхает, затем понимающе кивает.%SPEECH_ON%Я предполагал, что так и будет. Мы обсуждали это - и мы предпочтём погибнуть здесь, на пути к своей мечте, чем сдохнуть там, по дурацкому приказу. Для нас это важнее всего на свете.%SPEECH_OFF%Пожав плечами, вы отвечаете.%SPEECH_ON%А для нас - это всего лишь работа.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_88.png[/img]{Дезертиры собираются уходить, но %motivator% выходит вперёд и прочищает горло.%SPEECH_ON%Так вот как это будет, да? Собираетесь забыть о своём долге, подобно змее, забывающей о сброшенной шкуре? Я знаю, что вы чувствуете. Я знаю, вы не видите смысла в этой войне, не хотите рисковать своими жизнями во имя какого-то самодовольного дворянина, который понятия не имеет, через что вам пришлось пройти. Это справедливо. Но однажды, через много лет, когда вы будете держать на руках своего внука, он попросит рассказать, как вы сражались на войне. И вам придётся солгать своей родной крови.%SPEECH_OFF% | %motivator% засовывает пальцы в рот и резко свистит. Дезертиры поворачиваются к нему, а он начинает говорить.%SPEECH_ON%Вот и всё, да? Вы действительно собрались возложить на себя эту ношу? А что вы расскажете своим сыновьям, когда придёт время? Что вы - дезертиры, бросившие своих братьев умирать вместо себя? И не сомневайтесь, ваше бегство неминуемо приведёт к гибели людей, что не должны были пасть! Ваша трусость ляжет на душу неизмеримой тяжестью!%SPEECH_OFF% | %motivator% взывает к беглецам.%SPEECH_ON%Допустим, вы сейчас уйдёте. Предав своё знамя и свой долг. Но что будет, когда дом %feudfamily% победит, а?%SPEECH_OFF%Один из дезертиров пожимает плечами.%SPEECH_ON%Они меня не знают. Я просто вернусь в свою деревню к семье.%SPEECH_OFF%%motivator% со смехом качает головой.%SPEECH_ON%Ты правда так думаешь? А что ты будешь делать, когда эти чужаки придут в твою деревню? Когда они увидят твою жену и твоих детей? Ты что, не понимаешь, во что может перерасти эта война? У тебя не будет дома, в который ты мог бы вернуться, дурак!%SPEECH_OFF%}{Дезертиры не смогли договориться меж собой и решают вопрос голосованием. Большая часть решила уходить. Их вожак сообщает вам о результатах голосования и прощается с вами. %commander% будет недоволен, вы же обнажаете клинок и говорите беглецам, что теперь для них есть лишь один путь. Вожак оборачивается с мечом в руке и кивает.%SPEECH_ON%Знаю, я так и понял, что вы пришли сюда не ради разговоров. К оружию, ребята.%SPEECH_OFF% | %commander% будет крайне недоволен, но дезертиры отказываются возвращаться. Они не видят причин участвовать в этой бойне. Вы желаете их вожаку удачи. Он начинает благодарить вас, но тут же замолкает, видя, как вы обнажаете клинок, а остальные воины отряда \'%companyname%\' следуют вашему примеру. Вожак дезертиров тяжело вздыхает.%SPEECH_ON%Да, я был уверен, что всё так и закончится.%SPEECH_OFF%Вы киваете.%SPEECH_ON%Ничего личного. Мне плевать на ваш проступок, но у нас есть работа - и мы её сделаем.%SPEECH_OFF% | Дезертиры не в силах прийти к решению, так что они оставляют всё на волю случая. Их вожак достаёт монету и подбрасывает её в воздух. От того, как она выпадет, зависит, вернуться они в лагерь или уйдут. Им суждено уйти. Дезертиры с облегчением вздыхают. Их вожак хлопает вас по плечу.}{%SPEECH_ON%Судьба решила за нас, наёмник.%SPEECH_OFF%Вы киваете и обнажаете клинок, вашему примеру следует остальной отряд.%SPEECH_ON%Помни об этом, умирая от моего клинка.%SPEECH_OFF%Лицо вожака беглецов озаряет слабая усмешка. Он обнажает меч.%SPEECH_ON%Да будет так. Лучше погибнуть на пути к свободе, чем вернуться и сдохнуть в той бойне.%SPEECH_OFF% | Вожак спокойно отказывается вернуться.%SPEECH_ON%Мы не искали лёгкого пути, нарушая присягу. Мы не вернёмся.%SPEECH_OFF%Вы приказываете отряду \'%companyname%\' обнажить клинки. Вожак беглецов вздыхает, затем понимающе кивает.%SPEECH_ON%Я предполагал, что так и будет. Мы обсуждали это - и мы предпочтём погибнуть здесь, на пути к своей мечте, чем сдохнуть там, по дурацкому приказу. Для нас это важнее всего на свете.%SPEECH_OFF%Пожав плечами, вы отвечаете.%SPEECH_ON%А для нас - это всего лишь работа.%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_22.png[/img]{%randombrother% очищает свой клинок от крови накидкой одного из мертвецов.%SPEECH_ON%Жаль, что они выбрали этот путь. Они могли бы жить. У них был выбор.%SPEECH_OFF%Вы пожимаете плечами и отвечаете.%SPEECH_ON%Их везде поджидала смерть. Они просто выбрали нас в качестве палачей.%SPEECH_OFF% | Вокруг лежат дезертиры, мёртвые и умирающие. Один из них ползёт по земле, словно до сих пор стараясь убежать от войска, что возглавляет %commander%. Вы склоняетесь над ним, сжимая в руке кинжал, дабы закончить работу. Он смеётся, глядя на вас.%SPEECH_ON%Нет нужды марать клинок, наёмник. Просто дай мне немного времени. Это всё, что у меня осталось.%SPEECH_OFF%Струйка крови стекает по его подбородку. Его глаза сужаются, рассматривая пустоту, затем он медленно валится на землю. Вы встаёте и приказываете отряду собираться в обратный путь. | Последний дезертир сидит, прислонившись к валуну, обессиленно распластав руки, словно бродяга, просящий подаяние. Из ран на его груди стекает кровь, пропитывая землю вокруг. Он разглядывает её.%SPEECH_ON%Со мной всё хорошо, благодарю, что спросил, наёмник.%SPEECH_OFF%Вы отвечаете ему, что ничего не говорили. Он в искреннем удивлении смотрит на вас.%SPEECH_ON%Не ты? Но...%SPEECH_OFF%Через мгновение его тело заваливается на бок, с застывшим навечно изумлением на лице. | Некоторые люди слишком уж ценят весёлую, но обречённую жизнь. Сделав свой выбор, лишившись свободы, что ещё им остаётся, кроме как поприветствовать смехом свою жестокую судьбу? Каждый дезертир умер с выражением высокомерной самоуверенности на лице. | Последний оставшийся в живых дезертир смотрит в небо. Его рука бесцельно пытается что-то схватить в воздухе.%SPEECH_ON%Проклятье, я просто хочу увидеть хоть одну...%SPEECH_OFF%Вы спрашиваете, что он хочет увидеть. Он хохочет, хотя смех почти сразу перерастает в болезненный стон.%SPEECH_ON%Птицу. А, вот она! Такая огромная, такая прекрасная...%SPEECH_OFF%Он указывает вверх. Подняв взгляд, вы видите стервятника. Когда вы вновь смотрите на дезертира, тот уже мёртв.}",
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
			Text = "[img]gfx/ui/events/event_96.png[/img]{%commander% сообщает вам, что сражение состоится завтра. Вы возвращаетесь в свою палатку для долгожданного и заслуженного отдыха. | Возвратившись к военачальнику, вы сообщаете ему новости. %commander% подавлен, все его мысли поглощены предстоящим завтра решающим сражением. Уже смеркается, так что вы решаете вернуться в свой шатёр и поспать до утра. | Вы сообщаете новости военачальнику, но %commander% не обращает на вас внимания. Он буквально зарылся в карты предстоящего сражения.%SPEECH_ON%Увидимся завтра, наёмник. Отдохни хорошенько, тебе это пригодится.%SPEECH_OFF% | %commander% приглашает вас в свой шатёр, но практически не слушает доклада. Вместо этого он разглядывает карты и советуется со своими капитанами о планах на завтрашнюю битву. Вы решаете пойти к себе и поспать. | %commander% кивает в такт докладу, но практически не обращает на вас внимания. Вместо этого он рассматривает лежащие на столе планы сражения. Вы понимаете его - завтра будет решающая битва, так что лучше подумать о ней. Вы идёте спать.}",
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
			Text = "[img]gfx/ui/events/event_78.png[/img]{%commander% прохаживается перед строем своих воинов. Некоторые их них выглядят устало, они явно не спали этой ночью. Другие дрожат от страха. Военачальник взывает к ним.%SPEECH_ON%Испугался? А ты? Это хорошо. Я вот испугался, если бы это было не так.%SPEECH_OFF%Раскатившийся вокруг смех поднимает настроение бойцов. %commander% продолжает.%SPEECH_ON%Но сейчас я прошу вас бояться не за собственную шкуру, а за ваши семьи, за ваш род! Вот за кого мы сражаемся сегодня! Побеспокоимся о себе завтра, ибо сегодня мы будем воинами!%SPEECH_OFF%Смех перерастает в радостный рёв. | %commander% собрал своих людей перед собой. Пехотинцы, лучники, обозники стоят, поёживаясь на стылом ветру. Военачальник оглядывает строй.%SPEECH_ON%Я знаю, о чём вы думаете: \'Что я здесь делаю, сражаясь за это жалкое ничтожество. Если он такой благородный, где же его стройная лошадь, чтобы смотреть на нас свысока?\'%SPEECH_OFF%Воины смеются, напряжение рассеивается. %commander% продолжает.%SPEECH_ON%Вот что, гад я там или нет, ничто я не люблю так, как славную битву! И вот где я буду, парни. Я встану рядом с вами, разя изо всех сил, сражаясь до конца, ибо это и есть предназначение воина!%SPEECH_OFF%Солдаты воздевают мечи и разражаются радостным рёвом. Военачальник разворачивается и указывает клинком вперёд.%SPEECH_ON%Идите за мной! Покажем дому %feudfamily%, что такое настоящие мужчины!%SPEECH_OFF% | %commander% построил свою разношёрстное войско перед битвой. Прохаживаясь вдоль строя, военачальник начинает говорить.%SPEECH_ON%Некоторые из вас явно не выспались. Что такое, нервничаете? Я тоже! Глаз не смог сомкнуть.%SPEECH_OFF%Это подбадривает некоторых бойцов. Хорошо знать, что ты не одинок - и во плоти и разумом. Военачальник продолжает.%SPEECH_ON%Но я не сомкнул глаз ради этой битвы. Ни за что на свете не пропустил бы её! Так что протрите глаза, ребята, ибо сегодня мы покажем этим ублюдкам из дома %feudfamily%, что им стоило остаться в своих кроватках!%SPEECH_OFF% | %commander% взывает к своим людям, готовящимся к бою. Вы пропускаете его слова мимо ушей. Вместо этого, вы готовите своих людей к грядущей битве. | Вы наблюдаете, как %commander% взывает к своим людям, пытаясь вдохновить их. Многие фразы вы уже слышали раньше. Быть может, его слова взяты из какого-то древнего свитка? Увещевания, передающиеся из поколения в поколение? %randombrother%, посмеиваясь, подходит к вам.%SPEECH_ON%Слушай, командир, вот понимаю, что его слова пусты, а всё равно прям потянуло сделать пару отжиманий.%SPEECH_OFF%Улыбнувшись, вы советуете ему встать обратно в строй. Он острит в ответ.%SPEECH_ON%А речь-то будет?%SPEECH_OFF%Вы с напускной суровостью толкаете бойца, пока он смеётся. | %commander% прохаживается перед строем своих воинов. Он подходит к юнцу, столь сильно дрожащему, что его доспехи стучат.%SPEECH_ON%Знаешь, парень, ты сейчас напомнил мне меня самого. Думаешь, я не был на твоём месте? Ха, не опускай голову, и однажды ты можешь оказаться на моём!%SPEECH_OFF%Глаза паренька озаряются внутренним сиянием. Он выпрямляется и решительно кивает. Военачальник повышает голос, приказывая своим людям готовиться к битве не на жизнь, а на смерть. | %commander% идёт вдоль строя своих воинов, крича, что грядущая битва - важнейшее событие в их жизни. В этом вы сомневаетесь, а вот в чём нет сомнений - так это в том, что для многих из них это зрелище станет последним в их жизни. Впрочем, жестокая правда войны не слишком подходит для поднятия боевого духа, поэтому вы держите язык за зубами. | Вы натягиваете сапоги, а %commander% пытается воодушевить своих людей длинной высокопарной речью о величии войны меж благородными домами. И ему удаётся их убедить. Он вынужден это сделать, чтобы люди, которые от этого сражения могут получить лишь погибель, были готовы в нём умирать. | %commander% встаёт перед строем своих воинов. Он облачён в изукрашенные доспехи, смотрясь среди остальных, словно жемчужина на грязном песчаном пляже. %commander% говорит, что они должны выиграть эту битву, ведь проигрыш может обернуться поражением в войне. Впрочем, нет сомнений - он скажет всё, что угодно, дабы воодушевить своих людей. А вот вы не собираетесь погибать за изнеженных дворянчиков только потому, что какой-то ищущий славы воевода блеет о \'великой чести\'. Впрочем, именно поэтому вы и стали наёмником. | Война похожа на преисподнюю. Как можно заманить на неё людей? %commander%, взывая к своим людям, делает всё возможное, рассказывая о множестве причин. Для начала, он заявляет, что это почётно. Затем - замечает, что столь огромный размер войска означает, что вместо них скорее погибнет какой-нибудь тупица. Сила в числе! После он говорит, что проигрыш в этой битве означает смерть для их жён, детей, для всей их родины. Это последнее утверждение, кажется, сработало лучше всего, люди ревут от ярости и переполняющей их мощи. | %commander% обращается к своим людям глубоким сильным голосом.%SPEECH_ON%Ха, некоторые из вас явно потеряли голову. Хотите побыстрее пойти резать людей дома %feudfamily%, а? Мне знакомо это чувство.%SPEECH_OFF%Вымученный смех разносится вдоль строя. Военачальник продолжает.%SPEECH_ON%Помните о своих семьях, парни, ибо их жизни сейчас в ваших руках!%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_86.png[/img]{Повсюду лежат мёртвые тела. Среди них выделяется %commander%, его доспехи сверкают, обрамляя бренную плоть. %employer%, без сомнений, будет опечален поражением в битве, но с этим уже ничего не поделаешь. | Битва проиграна! %commander% погиб, как и большая часть его войска, лишь немногие смогли бежать. Стервятники уже кружат над полем боя, люди дома %feudfamily% неспешно пробираются среди гор трупов, убивая пытающихся притвориться мёртвыми. Вы собираете остатки отряда \'%companyname%\' и отступаете. %employer%, без сомнений, будет в ужасе от итогов битвы, но с этим уже ничего не поделаешь.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Не каждая битва может быть выиграна...",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractFail);
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "Проиграно важное сражение");
						this.World.Contracts.finishActiveContract(true);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "BattleWon",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_87.png[/img]{Вы победили! Ну и %commander% со своим войском тоже, да. Битва выиграна - вот что самое главное. Вы пробираетесь через горы мертвецов, желая побыстрее вернуться к нанимателю. | Мёртвые тела лежат в несколько слоёв. Стервятники вырывают куски мяса из груд трупов. Раненые умоляют о помощи. На посторонний взгляд здесь вообще нет победителей. Впрочем, %commander% подходит к вам, весело ухмыляясь.%SPEECH_ON%{Хорошая работа, наёмник. Тебе стоит вернуться к нанимателю и поведать ему о случившемся. | Хорошая работа - для наёмника. Я сомневался, что ты справишься. Тебе стоит вернуться к моему господину и поведать ему о случившемся.}%SPEECH_OFF% | Раненый у ваших ног молит о помощи. Вы не в силах определить, враг ли это или он из войска, что ведёт %commander%. Внезапно, его голову протыкают копьём, оставляя навеки косоглазым. Подняв взгляд, вы смотрите в довольные глаза копейщика. Он указывает на вас пальцем.%SPEECH_ON%Ты тот самый наёмник, верно? %commander% велел передать тебе, что пора возвращаться к нанимателю. Я всё верно сказал?%SPEECH_OFF%Вы киваете. Из груды трупов раздаётся стон. Воин выдёргивает своё копьё, перехватывая его другой рукой.%SPEECH_ON%Ну, пора за работу!%SPEECH_OFF% | Битва окончена, а %commander%, ревя, срывает свои доспехи и поддоспешник. Он любуется своими ранами, сгибаясь так, чтобы они открывались и из них сочилась кровь, словно из надрезанной кожуры спелого фрукта. Он требует от своих людей сделать то же самое, заставляя их поворачиваться и разглядывая их спины.%SPEECH_ON%Видите ли, смелые воины, подобные мне, получают раны здесь, здесь или здесь...%SPEECH_OFF%Он показывает на каждую рану на своём теле, а затем указывает на спину.%SPEECH_ON%Но здесь у настоящих мужчин не может быть ран! Потому что мы умираем, идя вперёд, а не отступая назад! Ведь так?%SPEECH_OFF%Воины радостным рёвом приветствуют его слова, хотя некоторые из них едва держатся на ногах, ослабев от потери крови. Вы не обращаете внимания на это представление и собираете отряд \'%companyname%\'. Ваш наниматель, без сомнений, будет счастлив услышать новости о произошедшем - а это всё, что вас интересует. | %commander% поздравляет вас с победой. Он весь покрыт кровью, словно, отрезав чью-то голову, искупался в извергающемся алом потоке. Он улыбается, сверкая белоснежными зубами.%SPEECH_ON%Вот что я называю доброй дракой!%SPEECH_OFF%Вы спрашиваете, что бы он сказал, окажись сегодня удача не на его стороне. Военачальник смеётся.%SPEECH_ON%О, да ты у нас философ, как я посмотрю. Нет, я не намеревался проигрывать в этой битве, а если бы и проиграл, то не собирался оставаться в живых, чтобы не стать свидетелем собственного поражения.%SPEECH_OFF%Вы киваете и отвечаете.%SPEECH_ON%Мало кто пожелает стать свидетелем своего величайшего поражения. Был рад сражаться рядом с тобой, но теперь я должен вернуться к нанимателю.%SPEECH_OFF%Военачальник кивает, а затем оборачивается и кричит, чтобы ему принесли полотенце. | %commander% склонился над раненым вражеским воином. Он водит кинжалом по груди бедняги, высекая искры из его доспеха. Военачальник переводит взгляд на вас.%SPEECH_ON%Что думаешь, наёмник? Следует ли мне даровать ему жизнь%SPEECH_OFF%Пленник с мольбой уставился на вас, он наклоняет голову и часто моргает. Вы полагаете, он просит ответить \'Да\'. Но пожимаете плечами.%SPEECH_ON%Это не моё дело. Слушай, рад был сражаться рядом с тобой, но теперь пришла пора вернуться к нанимателю.%SPEECH_OFF%%commander% кивает.%SPEECH_ON%Увидимся.%SPEECH_OFF%Когда вы уезжаете, командир всё ещё сидит в задумчивости, склонившись над своим пленником, лезвие звенит, идя взад-вперёд, взад-вперёд, взад-вперёд. | Когда вы замечаете его, %commander% как раз вонзает кинжал под ребро раненого вражеского воина. Тот бьётся в конвульсиях, но быстро затихает. Из раны струится поток крови, а военачальник очищает кинжал о штанину мертвеца.%SPEECH_ON%Точно в сердце - быстрая и лёгкая смерть. Не каждому так везёт.%SPEECH_OFF%Вы киваете и говорите военачальнику, что отправляетесь к нанимателю за своей платой. | Вы видите, как %commander% со сворой своих подручных бродит по полю битвы, добивая раненых врагов. %randombrother% спрашивает, стоит ли идти к нему на доклад. Вы качаете головой.%SPEECH_ON%Нет. Мы доложим своему нанимателю. К чертям это место, отправляемся за своим золотом.%SPEECH_OFF% | Поле брани заполнено мёртвыми и теми, кто ныне им завидует. %commander% со своими людьми собирают своих раненых и добивают чужих. Военачальник хлопает вас по плечу, брызги крови летят вам на щеку.%SPEECH_ON%Хорошая работа, наёмник. Я сомневался, что ваш отряд сдержит своё слово, но ты чертовски хорошо проявил себя. Уверен, мой господин будет рад вновь увидеть тебя.%SPEECH_OFF% | Вы собираете воинов отряда \'%companyname%\'. %commander% подходит к вам, протирая клинок куском ткани, счищая налипшие куски полусвернувшейся крови.%SPEECH_ON%Уже уходишь?%SPEECH_OFF%Вы киваете.%SPEECH_ON%Твой господин должен заплатить за работу, так что пора отправляться к нему.%SPEECH_OFF%Военачальник убирает меч в ножны и кивает.%SPEECH_ON%Справедливо. Рад был сражаться рядом с тобой, наёмник. Жаль только, что ты не останешься в моём войске. Полагаю, вы, парни, продолжите свою погоню за золотом, не так ли?%SPEECH_OFF%}",
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% в стельку пьян. Он таращится на вас, не отрываясь от кубка, говоря между глотками.%SPEECH_ON%Проклятье, ты вернулся!%SPEECH_OFF%Кубок выпадает из его вялой руки. Вы кратко докладываете о своих достижениях. Дворянин улыбается, хотя он так пьян, что это выглядит жалко.%SPEECH_ON%Значит, всё закончилось. Я победил. Мои надежды сбылись. Надеюсь, немногие погибли ради моих желаний.%SPEECH_OFF%Он разражается хохотом. Один из стражей протягивает вам кошель и выпроваживает из залы. | %employer% приветствует вас, протягивая кошель, полный крон.%SPEECH_ON%{Мы победили. Благодарю, наёмник. | Прекрасная работа, наёмник. Победа за нами, и благодарить за это нужно, в том числе, и тебя. Там твои %reward_completion% золотых. | Сколько там было, %reward_completion% крон? Невеликая плата за победу над столь могучим войском и помощью в победном завершении этой войны. | Мои пташки нашептали о твоих достижениях, наёмник. А ещё они поведали об отступлении войска дома %feudfamily%. Чего ещё мне желать? Вот обещанные %reward_completion% золотых.}%SPEECH_OFF% | Вы застаёте нанимателя за выкрикиванием приказов своим военачальникам. Заметив наблюдателя, %employer% немедленно показывает на вас.%SPEECH_ON%Видите этого парня, вон там? Вот человек, способный добиться своего! Стража! Отдайте ему %reward_completion% крон. Я был бы счастлив, если бы вы, жалкие псы, сделали хоть половину от его свершений - за свою-то плату!%SPEECH_OFF% | %employer% расположился в своём саду, перешучиваясь со стайкой девиц. Вы врываетесь в их уютный мирок, весь пропитанный кровью, покрытый грязью. Женщины задыхаются и отшатываются. %employer% смеётся.%SPEECH_ON%О, возвращение наёмника! Да ты у нас настоящий дамский угодник! Хотел бы я познакомить тебя с этими прекрасными девами, но, боюсь, если ты посмеешь хотя бы дотронутся до них, их отцы оторвут тебе кое-что ненужное.%SPEECH_OFF%Одна из дам проводит рукой по груди.%SPEECH_ON%Он может дотронуться до меня, если пожелает.%SPEECH_OFF%%employer% снова смеётся.%SPEECH_ON%Голубушка, разве ты сегодня не достаточно мужчин заманила в неприятности? Ступайте, дамы - и велите кому-нибудь из моих стражников принести кошель с %reward_completion% кронами.%SPEECH_OFF% | Вы застаёте нанимателя за попыткой внушить своему коту должное почтение.%SPEECH_ON%Ты только взгляни на этого мелкого негодника! Он даже в глаза мне ленится посмотреть! А когда я его кормлю, ведёт себя так, будто оказывает мне величайшее одолжение! Так и хочется вышвырнуть эту мелкую дрянь в то грёбаное окно.%SPEECH_OFF%Вы отвечаете.%SPEECH_ON%Он ведь всё равно приземлится на лапы.%SPEECH_OFF%Дворянин кивает.%SPEECH_ON%Это самая противная часть.%SPEECH_OFF%%employer% хватает отчаянно вырывающегося кота и вышвыривает его из окна. Затем отряхивает руки и протягивает вам кошель с %reward_completion% кронами.%SPEECH_ON%Не обращай внимание на это происшествие. Ты хорошо поработал. Войско дома %feudfamily% отступает, а большего в наши времена и желать нельзя.%SPEECH_OFF% | %employer% судит одного из своих военачальников, когда вы входите. Вы не уверены, что произошло, но воевода ведёт себя довольно дерзко. Когда всё заканчивается, его грубо хватают и тащат вон из залы. %employer% подзывает вас к себе.%SPEECH_ON%{Благодарю, наёмник. Мы победили - и не уверен, что это случилось бы без твоей помощи. И разумеется, твоя награда - %reward_completion% крон, как и обещано. | Этот подлец отказался выполнить мой приказ, вот что случилось! Ты же, впрочем, прекрасно справился! Вот, %reward_completion% крон, как и было обещано. | Этот подлец отказался биться за меня! Сказал, что не поднимет меча на единокровного брата, сражающегося на вражьей стороне. Что за вздор! А вот ты преуспел, наёмник. Вот твои %reward_completion% крон, как и было обещано.}%SPEECH_OFF% | %employer% встречает вас в окружении своих военачальников.%SPEECH_ON%{Благодарю, наёмник. Теперь победа наша. Вот твои %reward_completion% крон, как и было обещано. | Война продолжится, но её завершение стало ближе - благодаря тебе. Вражеское войско разбито, а мы на шаг подошли к окончанию этого бедствия. Вот твои %reward_completion% крон, ты честно их заработал, наёмник.}%SPEECH_OFF% | Один из стражников нанимателя останавливает вас. Он держит в руках кошель с %reward_completion% кронами, которые незамедлительно передаются вам.%SPEECH_ON%Мой повелитель, %employer%, сказал, что ты доблестно сражался в бою.%SPEECH_OFF%Охранник неловко оглядывается.%SPEECH_ON%Вот... вот и всё, что я должен был сказать.%SPEECH_OFF% | %employer% приглашает вас в свой кабинет, в то время как его военачальники выходят оттуда.%SPEECH_ON%Рад видеть тебя, наёмник. Уверен, тебе уже известно, что войско дома %feudfamily% отступает. И одни боги ведают, как повернулась бы битва, если бы не ты со своими парнями. Как я и обещал, твоя награда ждёт тебя.%SPEECH_OFF% | %employer% кормит огромную, глупо выглядящую птицу. Вам не приходилось раньше видеть птиц подобных размеров, так что вы стараетесь держаться от неё подальше. Позабавленный дворянин обращается к вам, одновременно кормя живность с руки.%SPEECH_ON%Здесь нечего бояться, наёмник. Знай, до меня уже дошли слухи о твоих свершениях. Войско дома %feudfamily% отступает, а мы на шаг ближе к завершению этой проклятой войны. Страж, вон тот, что сжимает кошель, отдаст тебе заслуженные %reward_completion% крон.%SPEECH_OFF%Когда вы уходите, птица хлопает крыльями и пронзительно кричит. | %employer% купается в искусственной заводи, развлекаясь вылавливанием лягушек. Слизистые твари извиваются и спрыгивают.%SPEECH_ON%Победа за нами. Я бы сказал, просто отличная работа, наёмник. Я даровал тебе прекрасную возможность, а ты попросту... запрыгнул на неё.%SPEECH_OFF%Ваше лицо, должно быть, заметно скривилось в омерзении, потому что дворянин быстро поднимается на ноги и вытирает руки о штаны, лежащие у края пруда.%SPEECH_ON%Проклятье, чего тут такого страшного? Ладно, вон тот страж заплатит тебе %reward_completion% крон.%SPEECH_OFF%}",
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
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationNobleContractSuccess, "Выиграно важное сражение");
						this.World.Contracts.finishActiveContract();

						if (this.World.FactionManager.isCivilWar())
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
			"noblehouse",
			this.World.FactionManager.getFaction(this.getFaction()).getName()
		]);
		_vars.push([
			"feudfamily",
			this.World.FactionManager.getFaction(this.m.Flags.get("EnemyNobleHouse")).getName()
		]);
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

		if (this.m.Flags.get("IsInterceptSupplies"))
		{
			_vars.push([
				"supply_start",
				this.World.getEntityByID(this.m.Flags.get("InterceptSuppliesStart")).getName()
			]);
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
		if (!this.World.FactionManager.isCivilWar())
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

