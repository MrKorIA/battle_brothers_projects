this.roaming_beasts_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		Target = null,
		IsPlayerAttacking = true
	},
	function create()
	{
		this.contract.create();
		this.m.Type = "contract.roaming_beasts";
		this.m.Name = "Охота на чудовищ";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function start()
	{
		this.m.Payment.Pool = 500 * this.getPaymentMult() * this.Math.pow(this.getDifficultyMult(), this.Const.World.Assets.ContractRewardPOW) * this.getReputationToPaymentMult();

		if (this.Math.rand(1, 100) <= 33)
		{
			this.m.Payment.Completion = 0.75;
			this.m.Payment.Advance = 0.25;
		}
		else
		{
			this.m.Payment.Completion = 1.0;
		}

		this.contract.start();
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Offer",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Выследить угрозу городу " + this.Contract.m.Home.getName()
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

				if (this.Math.rand(1, 100) <= 5 && this.World.Assets.getBusinessReputation() > 500)
				{
					this.Flags.set("IsHumans", true);
				}
				else
				{
					local village = this.Contract.getHome().get();
					local twists = [];
					local r;
					r = 50;

					if (this.isKindOf(village, "small_lumber_village") || this.isKindOf(village, "medium_lumber_village"))
					{
						r = r + 50;
					}
					else if (this.isKindOf(village, "small_tundra_village") || this.isKindOf(village, "medium_tundra_village"))
					{
						r = r + 50;
					}
					else if (this.isKindOf(village, "small_snow_village") || this.isKindOf(village, "medium_snow_village"))
					{
						r = r + 50;
					}
					else if (this.isKindOf(village, "small_steppe_village") || this.isKindOf(village, "medium_steppe_village"))
					{
						r = r - 25;
					}
					else if (this.isKindOf(village, "small_swamp_village") || this.isKindOf(village, "medium_swamp_village"))
					{
						r = r - 25;
					}

					twists.push({
						F = "IsDirewolves",
						R = r
					});
					r = 50;

					if (this.isKindOf(village, "small_steppe_village") || this.isKindOf(village, "medium_steppe_village"))
					{
						r = r + 50;
					}
					else if (this.isKindOf(village, "small_farming_village") || this.isKindOf(village, "medium_farming_village"))
					{
						r = r + 25;
					}
					else if (this.isKindOf(village, "small_tundra_village") || this.isKindOf(village, "medium_tundra_village"))
					{
						r = r - 25;
					}
					else if (this.isKindOf(village, "small_snow_village") || this.isKindOf(village, "medium_snow_village"))
					{
						r = r - 50;
					}
					else if (this.isKindOf(village, "small_swamp_village") || this.isKindOf(village, "medium_swamp_village"))
					{
						r = r + 25;
					}

					twists.push({
						F = "IsGhouls",
						R = r
					});

					r = 50;

                    if (this.isKindOf(village, "small_lumber_village") || this.isKindOf(village, "medium_lumber_village"))
                    {
                        r = r + 75;
                    }
					else if (this.isKindOf(village, "small_steppe_village") || this.isKindOf(village, "medium_steppe_village"))
					{
						r = r + 50;
					}
					else if (this.isKindOf(village, "small_farming_village") || this.isKindOf(village, "medium_farming_village"))
					{
						r = r + 50;
					}
					else if (this.isKindOf(village, "small_tundra_village") || this.isKindOf(village, "medium_tundra_village"))
					{
						r = r + 50;
					}
					else if (this.isKindOf(village, "small_snow_village") || this.isKindOf(village, "medium_snow_village"))
					{
						r = r + 50;
					}
					else if (this.isKindOf(village, "small_swamp_village") || this.isKindOf(village, "medium_swamp_village"))
					{
						r = r + 50;
					}

					twists.push({
						F = "IsBoar",
						R = r
					});

					r = 50;

                    if (this.isKindOf(village, "small_lumber_village") || this.isKindOf(village, "medium_lumber_village"))
                    {
                        r = r - 50;
                    }
					else if (this.isKindOf(village, "small_steppe_village") || this.isKindOf(village, "medium_steppe_village"))
					{
						r = r + 75;
					}
					else if (this.isKindOf(village, "small_farming_village") || this.isKindOf(village, "medium_farming_village"))
					{
						r = r - 50;
					}
					else if (this.isKindOf(village, "small_tundra_village") || this.isKindOf(village, "medium_tundra_village"))
					{
						r = r - 50;
					}
					else if (this.isKindOf(village, "small_snow_village") || this.isKindOf(village, "medium_snow_village"))
					{
						r = r - 50;
					}
					else if (this.isKindOf(village, "small_swamp_village") || this.isKindOf(village, "medium_swamp_village"))
					{
						r = r - 50;
					}

					twists.push({
						F = "IsAnkheg",
						R = r
					});

					r = 50;

                    if (this.isKindOf(village, "small_lumber_village") || this.isKindOf(village, "medium_lumber_village"))
                    {
                        r = r + 100;
                    }
					else if (this.isKindOf(village, "small_steppe_village") || this.isKindOf(village, "medium_steppe_village"))
					{
						r = r + 50;
					}
					else if (this.isKindOf(village, "small_farming_village") || this.isKindOf(village, "medium_farming_village"))
					{
						r = r - 50;
					}
					else if (this.isKindOf(village, "small_tundra_village") || this.isKindOf(village, "medium_tundra_village"))
					{
						r = r - 50;
					}
					else if (this.isKindOf(village, "small_snow_village") || this.isKindOf(village, "medium_snow_village"))
					{
						r = r - 50;
					}
					else if (this.isKindOf(village, "small_swamp_village") || this.isKindOf(village, "medium_swamp_village"))
					{
						r = r - 50;
					}

					twists.push({
						F = "IsTiger",
						R = r
					});

					r = 50;

                    if (this.isKindOf(village, "small_lumber_village") || this.isKindOf(village, "medium_lumber_village"))
                    {
                        r = r - 50;
                    }
					else if (this.isKindOf(village, "small_steppe_village") || this.isKindOf(village, "medium_steppe_village"))
					{
						r = r + 100;
					}
					else if (this.isKindOf(village, "small_farming_village") || this.isKindOf(village, "medium_farming_village"))
					{
						r = r - 50;
					}
					else if (this.isKindOf(village, "small_tundra_village") || this.isKindOf(village, "medium_tundra_village"))
					{
						r = r - 50;
					}
					else if (this.isKindOf(village, "small_snow_village") || this.isKindOf(village, "medium_snow_village"))
					{
						r = r - 50;
					}
					else if (this.isKindOf(village, "small_swamp_village") || this.isKindOf(village, "medium_swamp_village"))
					{
						r = r - 50;
					}

					twists.push({
						F = "IsLion",
						R = r
					});

                    if (::mods_getRegisteredMod("mod_warhammer") != null )
                    {
                        r = 50;

                        if (this.isKindOf(village, "small_lumber_village") || this.isKindOf(village, "medium_lumber_village"))
                        {
                            r = r + 50;
                        }
                        else if (this.isKindOf(village, "small_tundra_village") || this.isKindOf(village, "medium_tundra_village"))
                        {
                            r = r + 50;
                        }
                        else if (this.isKindOf(village, "small_snow_village") || this.isKindOf(village, "medium_snow_village"))
                        {
                            r = r + 50;
                        }
                        else if (this.isKindOf(village, "small_steppe_village") || this.isKindOf(village, "medium_steppe_village"))
                        {
                            r = r - 25;
                        }
                        else if (this.isKindOf(village, "small_swamp_village") || this.isKindOf(village, "medium_swamp_village"))
                        {
                            r = r - 25;
                        }

                        twists.push({
                            F = "IsWolfRat",
                            R = r
                        });
                    }

					if (this.Const.DLC.Unhold)
					{
						r = 50;

						if (this.isKindOf(village, "small_lumber_village") || this.isKindOf(village, "medium_lumber_village"))
						{
							r = r + 100;
						}
						else if (this.isKindOf(village, "small_tundra_village") || this.isKindOf(village, "medium_tundra_village"))
						{
							r = r - 25;
						}
						else if (this.isKindOf(village, "small_steppe_village") || this.isKindOf(village, "medium_steppe_village"))
						{
							r = r - 25;
						}
						else if (this.isKindOf(village, "small_snow_village") || this.isKindOf(village, "medium_snow_village"))
						{
							r = r - 50;
						}
						else if (this.isKindOf(village, "small_swamp_village") || this.isKindOf(village, "medium_swamp_village"))
						{
							r = r + 25;
						}

						twists.push({
							F = "IsSpiders",
							R = r
						});
					}

					local maxR = 0;

					foreach( t in twists )
					{
						maxR = maxR + t.R;
					}

					local r = this.Math.rand(1, maxR);

					foreach( t in twists )
					{
						if (r <= t.R)
						{
							this.Flags.set(t.F, true);
							  // [346]  OP_JMP            0      5    0    0
						}
						else
						{
							r = r - t.R;
						}
					}
				}

				local playerTile = this.World.State.getPlayer().getTile();
				local tile = this.Contract.getTileToSpawnLocation(playerTile, 5, 10);
				local party;

				if (this.Flags.get("IsHumans"))
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).spawnEntity(tile, "Лютоволки", false, this.Const.World.Spawn.BanditsDisguisedAsDirewolves, 100 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
					party.setDescription("Стая свирепых лютоволков в поисках жертвы.");
					party.setFootprintType(this.Const.World.FootprintsType.Direwolves);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Direwolves, 0.75);
				}
				else if (this.Flags.get("IsGhouls"))
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Нахцереры", false, this.Const.World.Spawn.Ghouls, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
					party.setDescription("Стая питающихся мертвечиной нахцереров.");
					party.setFootprintType(this.Const.World.FootprintsType.Ghouls);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Ghouls, 0.75);
				}
				else if (this.Flags.get("IsWolfRat"))
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.RatBeast).spawnEntity(tile, "Волкокрысы", false, this.Const.World.Spawn.WolfRat, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult());
					party.setDescription("Стая свирепых волкокрысов в поисках жертвы.");
					party.setFootprintType(this.Const.World.FootprintsType.Direwolves);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.SkavenFootprints, this.Const.World.FootprintsType.Skavens, 0.75);
				}
				else if (this.Flags.get("IsSpiders"))
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Сетеплеты", false, this.Const.World.Spawn.Spiders, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
					party.setDescription("Рой суетящихся сетеплётов.");
					party.setFootprintType(this.Const.World.FootprintsType.Spiders);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Spiders, 0.75);
				}
				else if (this.Flags.get("IsLion"))
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Прайд Львов", false, this.Const.World.Spawn.XXMobLion, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
					party.setDescription("Прайд агрессивных львов.");
					party.setFootprintType(this.Const.World.FootprintsType.Direwolves);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Spiders, 0.75);
				}
				else if (this.Flags.get("IsTiger"))
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Тигры", false, this.Const.World.Spawn.XXMobTiger, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
					party.setDescription("Стая агрессивных тигров.");
					party.setFootprintType(this.Const.World.FootprintsType.Direwolves);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Spiders, 0.75);
				}
				else if (this.Flags.get("IsAnkheg"))
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Анхеги", false, this.Const.World.Spawn.XXMobAnkheg, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
					party.setDescription("Рой агрессивных Анхегов.");
					party.setFootprintType(this.Const.World.FootprintsType.Direwolves);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Spiders, 0.75);
				}
				else if (this.Flags.get("IsBoar"))
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Шиповепри", false, this.Const.World.Spawn.XXMobBoar, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
					party.setDescription("Стая агрессивных шиповепрей.");
					party.setFootprintType(this.Const.World.FootprintsType.Direwolves);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Spiders, 0.75);
				}
				else
				{
					party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).spawnEntity(tile, "Лютоволки", false, this.Const.World.Spawn.Direwolves, 110 * this.Contract.getDifficultyMult() * this.Contract.getScaledDifficultyMult(), this.Contract.getMinibossModifier());
					party.setDescription("Стая свирепых лютоволков в поисках жертвы.");
					party.setFootprintType(this.Const.World.FootprintsType.Direwolves);
					this.Const.World.Common.addFootprintsFromTo(this.Contract.m.Home.getTile(), party.getTile(), this.Const.BeastFootprints, this.Const.World.FootprintsType.Direwolves, 0.75);
				}

				party.setAttackableByAI(false);
				party.setFootprintSizeOverride(0.75);
				this.Contract.m.Target = this.WeakTableRef(party);
				party.getSprite("banner").setBrush("banner_beasts_01");
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				local roam = this.new("scripts/ai/world/orders/roam_order");
				roam.setPivot(this.Contract.m.Home);
				roam.setMinRange(2);
				roam.setMaxRange(8);
				roam.setAllTerrainAvailable();
				roam.setTerrain(this.Const.World.TerrainType.Ocean, false);
				roam.setTerrain(this.Const.World.TerrainType.Shore, false);
				roam.setTerrain(this.Const.World.TerrainType.Mountains, false);
				c.addOrder(roam);
				this.Contract.m.Home.setLastSpawnTimeToNow();
				this.Contract.setScreen("Overview");
				this.World.Contracts.setActiveContract(this.Contract);
			}

		});
		this.m.States.push({
			ID = "Running",
			function start()
			{
				if (this.Contract.m.Target != null && !this.Contract.m.Target.isNull())
				{
					this.Contract.m.Target.getSprite("selection").Visible = true;
					this.Contract.m.Target.setOnCombatWithPlayerCallback(this.onTargetAttacked.bindenv(this));
				}
			}

			function update()
			{
				if (this.Contract.m.Target == null || this.Contract.m.Target.isNull() || !this.Contract.m.Target.isAlive())
				{
					if (this.Flags.get("IsHumans"))
					{
						this.Contract.setScreen("CollectingProof");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsGhouls"))
					{
						this.Contract.setScreen("CollectingGhouls");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsWolfRat"))
					{
						this.Contract.setScreen("CollectingWolfRat");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsSpiders"))
					{
						this.Contract.setScreen("CollectingSpiders");
						this.World.Contracts.showActiveContract();
					}
					else if (this.Flags.get("IsAnkheg"))
					{
						this.Contract.setScreen("CollectingAnkheg");
						this.World.Contracts.showActiveContract();
					}
					else
					{
						this.Contract.setScreen("CollectingPelts");
						this.World.Contracts.showActiveContract();
					}

					this.Contract.setState("Return");
				}
				else if (!this.Flags.get("IsWorkOfBeastsShown") && this.World.getTime().IsDaytime && this.Contract.m.Target.isHiddenToPlayer() && this.Math.rand(1, 9000) <= 1)
				{
					this.Flags.set("IsWorkOfBeastsShown", true);
					this.Contract.setScreen("WorkOfBeasts");
					this.World.Contracts.showActiveContract();
				}
			}

			function onTargetAttacked( _dest, _isPlayerAttacking )
			{
				if (this.Flags.get("IsHumans") && !this.Flags.get("IsAttackDialogTriggered"))
				{
					this.Flags.set("IsAttackDialogTriggered", true);
					local troops = this.Contract.m.Target.getTroops();

					foreach( t in troops )
					{
						t.ID = this.Const.EntityType.BanditRaider;
					}

					this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
					this.Contract.setScreen("Humans");
					this.World.Contracts.showActiveContract();
				}
				else
				{
					this.World.Contracts.showCombatDialog(_isPlayerAttacking);
				}
			}

		});
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = [
					"Вернуться в " + this.Contract.m.Home.getName()
				];
				this.Contract.m.Home.getSprite("selection").Visible = true;
			}

			function update()
			{
				if (this.Contract.isPlayerAt(this.Contract.m.Home))
				{
					if (this.Flags.get("IsHumans"))
					{
						this.Contract.setScreen("Success2");
					}
					else if (this.Flags.get("IsGhouls"))
					{
						this.Contract.setScreen("Success3");
					}
					else if (this.Flags.get("IsWolfRat"))
					{
						this.Contract.setScreen("Success4");
					}
					else if (this.Flags.get("IsSpiders"))
					{
						this.Contract.setScreen("Success5");
					}
					else if (this.Flags.get("IsAnkheg"))
					{
						this.Contract.setScreen("Success6");
					}
					else
					{
						this.Contract.setScreen("Success1");
					}

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
			Text = "[img]gfx/ui/events/event_43.png[/img]{Вы терпеливо ждёте, пока наниматель объяснит, зачем позвал. В поселении царит тревожная тишина. Наконец, %employer% начинает.%SPEECH_ON%Боги отвернулись от этих земель. По ночам приходят чудовища с красными глазами и убивают всё живое. Скот перерезан, люди пропадают. Мы посылали лучших охотников... они не вернулись. Отправляйся на %direction%, выследи тварей и убей их. Плата не велика, но это всё, что мы смогли собрать.%SPEECH_OFF% | %employer% стоит у окна, в руке — пустой кубок. Он оборачивается.%SPEECH_ON%Заметил, наёмник, как здесь тихо?%SPEECH_OFF%Вы отвечаете, что привыкли к настороженности. Он криво усмехается.%SPEECH_ON%Дело не в тебе. Уже несколько недель по округе рыщут твари. Люди исчезают. Лорд нам не поможет... слишком занят своими войнами. Сможешь ли ты избавить нас от этого кошмара?%SPEECH_OFF% | Вы входите, и %employer% жестом отпускает перепуганных крестьян. Он вертит в руках тощий кошель.%SPEECH_ON%Вот, собрали всем миром. Люди боятся выходить из домов. Тела тех, кто пропал... они не просто мертвы. Их растерзали. Надеюсь, тебе это будет интересно, наёмник.%SPEECH_OFF% | %employer% протягивает вам мятый список имён.%SPEECH_ON%Попробуй прочесть. Это те, кто исчез за последнюю неделю.%SPEECH_OFF%Вы с трудом разбираете корявые буквы. Слишком много имён для одной недели.%SPEECH_ON%Чудовища, — голос нанимателя дрожит. — Мы не знаем, кто они. Но мы хотим, чтобы ты их нашёл и уничтожил. Сделаешь?%SPEECH_OFF% | У ног %employer% лежат измождённые гончие, высунув языки.%SPEECH_ON%Они искали пропавших несколько дней. Без толку. Люди не просто уходят — их утаскивают.%SPEECH_OFF%Он чешет пса за ухом, но тот даже не виляет хвостом.%SPEECH_ON%Возможно, ты найдёшь кого-то живым... но я в это не верю. Ступай по следу, наёмник.%SPEECH_OFF% | %employer% держит кошель с чужим именем на бирке.%SPEECH_ON%Знаешь этого?%SPEECH_OFF%Вы киваете. Это известный дворянин.%SPEECH_ON%Он ушёл на охоту за чудовищами неделю назад. Кошелёк остался у меня. Думаешь, почему?%SPEECH_OFF%Вы пожимаете плечами.%SPEECH_ON%Потому что он не вернулся.%SPEECH_OFF%%employer% кидает мешочек на стол.%SPEECH_ON%Верно. И теперь мне нужен кто-то вродше тебя. Кто-то, кто не боится испачкать руки. Берёшься?%SPEECH_OFF% | %employer% смахивает пыль со старой книги.%SPEECH_ON%Ты веришь в чудовищ, наёмник?%SPEECH_OFF%Вы киваете.%SPEECH_ON%И не только верю, я их убивал.%SPEECH_OFF%%employer% открывает книгу на нужной странице.%SPEECH_ON%Мы думаем, что они поселились в округе. Именно поэтому люди из %townname% пропадают. Я хочу, чтобы ты отыскал этих «предполагаемых» тварей и истребил их, как и прочих. Справишься?%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			ShowDifficulty = true,
			Options = [
				{
					Text = "{Какова оплата? | Сколько же %townname% готов заплатить? | Обсудим оплату.}",
					function getResult()
					{
						return "Negotiation";
					}

				},
				{
					Text = "{Мы не берёмся за такую работу. | Желаю вам удачи, мы не будем в этом участвовать.}",
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
			ID = "Humans",
			Title = "Перед битвой...",
			Text = "[img]gfx/ui/events/event_07.png[/img]{Это вовсе не чудища, лишь люди, облачившиеся в волчьи шкуры! Увидев истинное \'лицо\' этого зла, люди вздыхают с облегчением, ведь такой противник им хорошо знаком. | Подойдя к монстрам поближе, вы понимаете, что эти отвратительные существа вовсе никакие не чудовища, а переодетые люди! Вы не знаете, что за нелепую игру с переодеваниями они затеяли, но они обнажают оружие. Насколько вам известно, будь то зверь или человек - все они погибают одинаково. | Вы натыкаетесь на человека, снимающего волчью голову со своих плеч. Он смотрит на вас, держа маску в руках, затем быстро натягивает её обратно. Вы обнажаете меч.%SPEECH_ON%Поздновато притворяться, приятель.%SPEECH_OFF%Взмах вашего клинка срывает маску с головы незнакомца, он пятится назад. Прежде чем вы успеваете схватить его, он разворачивается и бежит в сторону подобных ему переодетых людей. Увидев вас, они обнажают оружие. И теперь уже совершенно не важно, с какой стати эти идиоты решили устроить маскарад. | Вы натыкаетесь на мёртвое чудовище, из спины которого торчат несколько стрел. Раны не выглядят смертельными... и когда вы дотрагиваетесь кончиком меча до загривка странного существа, его \'голова\' тут же слезает, обнаруживая человека, скрывающегося под ней.%SPEECH_ON%Твоих рук дело?%SPEECH_OFF%Голос доносится откуда-то спереди. Вы видите нескольких человек, снимающих маски, изображающие чудовищ, которых вы преследовали. Тот, что стоит во главе, кричит, повышая голос.%SPEECH_ON%Убить их! Убить их всех!%SPEECH_OFF%Нет, это всё же чудища, только ростом пониже.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Готовьтесь к бою!",
					function getResult()
					{
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, this.Contract.m.IsPlayerAttacking);
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "WorkOfBeasts",
			Title = "По пути...",
			Text = "[img]gfx/ui/events/event_60.png[/img]{Вы переступаете через мертвеца, лежащего в траве. Обычно, мёртвые не выглядят сколь-нибудь примечательно, людей повсюду хватает, так что встреча с очередным телом, здесь или там - лишь вопрос времени. Этот всё же отличается от них огромной раной на спине и отсутствующими внутренностями.\n\n%helpfulbrother% встаёт рядом с вами.%SPEECH_ON%Внутренностей нет, это работа волков... а может и кроликов. Что, ты никогда не сталкивался с по-настоящему оголодавшим кроликом?%SPEECH_OFF%Он сплёвывает и грызёт свой ноготь.%SPEECH_ON%Как бы там ни было, отметины не указывают ни на кролика, ни на пса, ни на кого другого, подобного им. Это нечто гораздо более... крупное... и опасное.%SPEECH_OFF%Вы благодарите собеседника за ценные наблюдения и отсылаете его к остальным. | К вам подходит крестьянин в изорванной в клочья одежде, стеснительно прикрывая руками пах.%SPEECH_ON%Прошу вас, господин, вам нужно взглянуть на этот... ужас.%SPEECH_OFF%Когда вы спрашиваете его, о чём он толкует, он поднимает руки вверх и оттопыривает зад. Затем кружится на месте, словно марионетка, после же убегает, свистя и улюлюкая. Когда вы отошли от увиденного безумия, к вам подходит женщина. Её руки скрещены на груди.%SPEECH_ON%Он свихнулся из-за того, что его брата разорвали на части чудовища.%SPEECH_OFF%Вы поворачиваетесь к ней, отчасти ожидая, что она вот-вот сорвёт с себя одежду и ускачет в одном ей известном направлении. Однако, вместо этого она просто смотрит на вас.%SPEECH_ON%Ходят слухи, что город %townname% нанял нескольких человек, чтобы позаботиться об этих чудищах, а ты, определённо, один из них. Прошу, господин, защити нас от этого зла... и от того зла, что они оставляют за собой...%SPEECH_OFF% | Вы проходите мимо выпотрошенной коровы, половина туши которой лежит на меже, а другая растащена по лугу, насколько позволяют внутренности. Всё вокруг покрыто запёкшейся кровью.\n\nКрестьянин подходит к вам, снимая шапку, закрывающую глаза.%SPEECH_ON%Чудовища сделали это. Сам-то я их не видел, если тебе интересно, но прекрасно слышал, что случилось с охотниками, потерпевшими неудачу до вас. И этих звуков было вполне достаточно, чтобы я затаился и не стремился что-либо увидеть. Если ты собираешься поохотиться на этих тварей, прошу - поторопись, не хочу потерять ещё одно стадо.%SPEECH_OFF% | Крестьянин, рубящий дрова, распрямляет спину.%SPEECH_ON%О боги, рад видеть вас, господа. Кажется, я слыхал о наёмниках, отправившихся на поиски чудовищ, держащих в страхе эти земли.%SPEECH_OFF%Вы интересуетесь, не видел ли он чего-либо, что могло бы помочь. Он кладёт руки на обух топора.%SPEECH_ON%Видел? Нет. Но кое-что слышал. Слыхал я, что неподалёку отсюда пропали мужик с бабой. Ну, вместе пропали. Балакают, сдохли они где-то в лесу. Висят, поди, на каком-то дереве, подвешенные на своих кишках, представляешь, а? Эй, а может они просто убежали, чтобы... ну... побыть друг с другом? Проклятье... проклятье! Эта девчонка ненавидела своего папашу, а парнишка был просто никем, всё, что у него было - смазливое личико да подвешенный язык. Да, в этом есть смысл.%SPEECH_OFF%Он замолкает и смотрит на вас.%SPEECH_ON%В общем, я уверен, что эти чудовища где-то неподалёку. Будь начеку, наёмник.%SPEECH_OFF% | Женщина выбегает из своей хибары и останавливает вас. Запыхавшись, она спрашивает, не встречали ли вы парнишку. Вы отрицательно киваете головой. Она протягивает руки.%SPEECH_ON%Он высок. У него густые коричневые волосы. Это не настоящий цвет, но парнишке очень уж нравится та грязь. Когда он улыбается, его зубы прямо как звёзды, яркие и редкие.%SPEECH_OFF%Вы вновь качаете головой.%SPEECH_ON%Он способен швырнуть приличного размера камень. Швырнуть далеко. Я велела ему не показывать свою силу, когда люди лорда находятся поблизости, иначе они заберут его в армию.%SPEECH_OFF%Она фыркает, пытаясь сдуть непослушную прядь волос, упавшую на её глаза.%SPEECH_ON%Дерьмо... ну, если вдруг увидишь его, дай мне знать. Думаю, это будет он самый. Вот ещё что, опасайся темноты. Чудища уволакивают местных жителей в чащу.%SPEECH_OFF%Прежде чем вы успеваете хоть что-то сказать, женщина поднимает подол своего длинного платья и спешит обратно в хижину. | Вы натыкаетесь на человека, склонившегося над телом истерзанного пса. Присаживаетесь рядом с ним.%SPEECH_ON%Это сделали чудовища?%SPEECH_OFF%Он отрицательно кивает головой.%SPEECH_ON%Проклятье, это сделал я. Наконец-то. Проклятая шавка больше не будет мешать мне спать.%SPEECH_OFF%Дверь ближайшей хижины вдруг резко отворяется и оттуда выбегает вопящий человек.%SPEECH_ON%Ах ты сукин сын, что ты сделал с моей собакой?%SPEECH_OFF%Убийца собаки быстро вскакивает на ноги.%SPEECH_ON%Чудовища! Этой ночью они снова приходили!%SPEECH_OFF%Вы тихо покидаете ссору, разгорающуюся над собачьим трупом.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Двигаемся дальше.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CollectingPelts",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_56.png[/img]{Чудовища пали, вы приказываете своим людям снять с них шкуры в качестве доказательства. Ваш наниматель, %employer%, будет рад их увидеть. | Покончив с мерзкими тварями, вы сдираете с них шкуры. Отвратительные существа требуют не менее отвратительных доказательств. Иначе ваш наниматель, %employer%, попросту может вам не поверить. | После боя ваши люди начинают сдирать шкуры, чтобы предъявить их в качестве доказательства нанимателю. | Ваш наниматель, %employer%, вполне может не поверить в то, что произошло, если не будет доказательств. Вы отдаёте команду своим людям собирать шкуры, когти, зубы, словом, всё, что может послужить свидетельством вашей славной победы.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Покончим с этим побыстрее, нам нужно ещё забрать золото.",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CollectingProof",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_22.png[/img]{Ваши люди собирают волчьи шкуры, в которые были облачены убитые глупцы, поскольку ваш наниматель, %employer%, вряд ли поверит в то, что здесь произошло, без доказательств. | Ваш наниматель может не поверить в то, что здесь произошло. Вы приказываете своим людям собрать волчьи шкуры, в которые были облачены поверженные враги. %bro1% стягивает маску с одного из убитых и начинает её изучать.%SPEECH_ON%Похоже они наряжались так, чтобы заманить нас - и теперь они все мертвы. Надеюсь, они не думали, что это какая-то игра.%SPEECH_OFF%%bro2% вытирает лезвие клинка об одну из волчьих шкур.%SPEECH_ON%Что ж, если это была игра - уверен, они сполна ею насладились.%SPEECH_OFF% | %randombrother% кивком указывает на убитого.%SPEECH_ON%Вполне возможно, %employer% не поверит, что это была всего лишь шайка разбойников, переодетых в чудовищ.%SPEECH_OFF%Соглашаясь, вы отдаёте своим людям приказ собрать маски и другие части маскировочных одеяний в качестве доказательств. | Вам потребуются доказательства, чтобы %employer% поверил в ваш рассказ. Это явно не те чудовища, которых вы думали найти, но они были облачены в волчьи шкуры, на которые вашему нанимателю будет крайне любопытно взглянуть. Один из ваших людей громко спрашивает.%SPEECH_ON%Так для чего они играли во все эти переодевания?%SPEECH_OFF%%bro2% собирает волчьи шкуры, перекидывая их через руку.%SPEECH_ON%Какой-нибудь самоубийственный ритуал? В конце концов, их весёлые танцы и впрямь смогли привлечь наше внимание.%SPEECH_OFF%Он поднимает одну из масок - и из неё вываливается голова мертвеца! Наёмник смеётся, отбрасывая её пинком.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Возвращаемся в %townname%!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CollectingGhouls",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_131.png[/img]{Битва окончена. Вы подходите к мёртвому нахцереру и опускаетесь на колено. Если бы не цепочка жутких, искривлённых клыков, то вы бы без труда смогли просунуть голову в утробу чудовища. Вместо того, чтобы любоваться воплощённой мечтой зубодёра, вы берёте нож и отпиливаете голову чудища. Разрезать толстую шкуру оказывается непросто, однако мышцы и сухожилия под ней поддаются на удивление легко. Вы поднимаете отрезанную голову и предлагаете своим людям последовать вашему примеру. В конце концов, %employer% ожидает увидеть что-то в качестве доказательства. | Распластавшаяся на земле неподвижная туша нахцерера больше походит на камень, нежели на чудовище. Мухи уже вовсю копошатся в его приоткрытой пасти, сея новую жизнь в мёртвых останках. Вы приказываете своим людям захватить с собой эту голову. %employer% определённо захочет увидеть доказательства. | Повсюду разбросаны тела мёртвых нахцереров. Вы опускаетесь на колено рядом с телом одной из бестий и смотрите прямо в её пасть. Что бы там ни было в её лёгких, оно всё ещё выходит наружу, издавая жуткую вонь. Прикрыв нос куском ткани, вы отпиливаете голову чудовища и поднимаете её, веля нескольким братьям последовать вашему примеру. %employer% определённо потребует доказательств. | Мёртвый нахцерер выглядит весьма любопытно. Удивительно, как подобное создание вообще возникло в природе. Он похож на человека со звериными мускулами, а его корявая голова с наростами и ужасными рогами, будто бы порождена кошмарами безумца. Вы приказываете своим людям приступить к сбору голов мерзких созданий, %employer% наверняка ожидает увидеть доказательства.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Возвращаемся в %townname%!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CollectingWolfRat",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/rat_event_06.png[/img]{Вы встаёте на колено перед мёртвым волкокрысом. Эта помесь крысы и волка выглядит мерзко даже после смерти. Вы отрубаете голову, прорубаясь сквозь жёсткую шерсть, и велите %companyname% последовать примеру. %employer% должен увидеть, кого мы завалили. | Туша волкокрыса уже начала разлагаться. В пасти копошатся личинки. %randombrother% морщится, но отрубает голову по вашему приказу. Доказательства нужны всегда. | Вы рассматриваете поверженного зверя. Он похож на кошмар пьяного крысолова. Вы приказываете братьям собирать трофеи — чем больше, тем увесистее кошелёк вам отсчитает %employer%.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Возвращаемся в %townname%!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CollectingSpiders",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_123.png[/img]{Вы приказываете своим людям прочесать поле и собрать как можно больше паучьих останков. Некоторые братья совершают большую ошибку, дотронувшись до волосков на паучьих лапах, их руки тут же начинают неистово зудеть и опухать. | Пауки заполонили поле, словно тёмный угол чердака. Их останки похожи на огромные перчатки, сжатые в кулак. Вы приказываете своим людям выдрать паучьи лапы - доказательства кончины чудовищ. | Наёмники прочёсывают поле, отламывают и отпиливают куски закоченевших пауков, чтобы отнести их нанимателю. Даже после смерти сетеплёты отвратительны, они выглядят так, будто готовы ожить в следующий миг, вцепившись мёртвой хваткой в ближайшее живое существо. Их ужасающий вид и огромный размер не останавливают некоторых наёмников от победных танцев. Они кривляются, пощёлкивают языками и шипят, устрашая тех, кто так и не осмелился приблизиться к проклятым тварям.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Возвращаемся в %townname%!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CollectingLion",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_56.png[/img]{Чудовища пали, вы приказываете своим людям снять с них шкуры в качестве доказательства. Ваш наниматель, %employer%, будет рад их увидеть. | Покончив с мерзкими тварями, вы сдираете с них шкуры. Отвратительные существа требуют не менее отвратительных доказательств. Иначе ваш наниматель, %employer%, попросту может вам не поверить. | После боя ваши люди начинают сдирать шкуры, чтобы предъявить их в качестве доказательства нанимателю. | Ваш наниматель, %employer%, вполне может не поверить в то, что произошло, если не будет доказательств. Вы отдаёте команду своим людям собирать шкуры, когти, зубы, словом, всё, что может послужить свидетельством вашей славной победы.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Возвращаемся в %townname%!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CollectingTiger",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_56.png[/img]{Чудовища пали, вы приказываете своим людям снять с них шкуры в качестве доказательства. Ваш наниматель, %employer%, будет рад их увидеть. | Покончив с мерзкими тварями, вы сдираете с них шкуры. Отвратительные существа требуют не менее отвратительных доказательств. Иначе ваш наниматель, %employer%, попросту может вам не поверить. | После боя ваши люди начинают сдирать шкуры, чтобы предъявить их в качестве доказательства нанимателю. | Ваш наниматель, %employer%, вполне может не поверить в то, что произошло, если не будет доказательств. Вы отдаёте команду своим людям собирать шкуры, когти, зубы, словом, всё, что может послужить свидетельством вашей славной победы.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Возвращаемся в %townname%!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CollectingBoar",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_56.png[/img]{Чудовища пали, вы приказываете своим людям снять с них шкуры в качестве доказательства. Ваш наниматель, %employer%, будет рад их увидеть. | Покончив с мерзкими тварями, вы сдираете с них шкуры. Отвратительные существа требуют не менее отвратительных доказательств. Иначе ваш наниматель, %employer%, попросту может вам не поверить. | После боя ваши люди начинают сдирать шкуры, чтобы предъявить их в качестве доказательства нанимателю. | Ваш наниматель, %employer%, вполне может не поверить в то, что произошло, если не будет доказательств. Вы отдаёте команду своим людям собирать шкуры, когти, зубы, словом, всё, что может послужить свидетельством вашей славной победы.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Возвращаемся в %townname%!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "CollectingAnkheg",
			Title = "После битвы...",
			Text = "[img]gfx/ui/events/event_56.png[/img]{Чудовища пали, вы приказываете своим людям снять с них пластины хитина в качестве доказательства. Ваш наниматель, %employer%, будет рад их увидеть. | Покончив с мерзкими тварями, вы снимаете с них пластины хитина. Отвратительные существа требуют не менее отвратительных доказательств. Иначе ваш наниматель, %employer%, попросту может вам не поверить. | После боя ваши люди начинают сдирать пластины хитина, чтобы предъявить их в качестве доказательства нанимателю. | Ваш наниматель, %employer%, вполне может не поверить в то, что произошло, если не будет доказательств. Вы отдаёте команду своим людям собирать хитин, клешни, словом, всё, что может послужить свидетельством вашей славной победы.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Возвращаемся в %townname%!",
					function getResult()
					{
						return 0;
					}

				}
			]
		});
		this.m.Screens.push({
			ID = "Success1",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Вы возвращаетесь к нанимателю и бросаете одну из шкур прямо на его стол. Безвольные когти ударяются о край дубовой столешницы. %employer% поднимает один из когтей, затем отпускает, позволяя упасть снова.%SPEECH_ON%Вижу, ты всё же нашёл чудовищ, которых мы искали.%SPEECH_OFF%Вы рассказываете ему о битве. Он выглядит почти довольным, доставая небольшой деревянный сундучок с книжной полки и протягивая его вам.%SPEECH_ON%%reward_completion% крон, как и условились. Жители города %townname% заслуживают передышку, которую ты даровал им, избавив от этого ужаса.%SPEECH_OFF% | Когда вы входите в кабинет нанимателя, %employer% мгновенно отскакивает от вас.%SPEECH_ON%Что за дрянь, во имя всех богов, у тебя в руках, наёмник?%SPEECH_OFF%Вы поднимаете шкуру, держа её за загривок. Чёрная кровь стекает с шеи и разбрызгивается по полу.%SPEECH_ON%Одна из тех тварей, что ты искал. Если же нужны доказательства смерти всех остальных, они ожидают снаружи...%SPEECH_OFF%%employer% поднимает руки, останавливая вас.%SPEECH_ON%Достаточно и одной, чтобы я поверил. Очень хорошая работа, наёмник. Плату тебе отдаст %randomname%, он из городского совета, быть может, вы даже пересекались с ним в коридорах. У него столь уродливое рыло, что ни с кем нельзя спутать. %reward_completion% крон, как и договаривались.%SPEECH_OFF%Он вновь рассматривает чудовище, затем неспешно склоняет голову.%SPEECH_ON%Пусть же мёртвые и выжившие обретут успокоение в избавлении от этих мерзких исчадий.%SPEECH_OFF% | %employer% приветствует вас, протягивая кубок, полный вина.%SPEECH_ON%Выпей же, истребитель чудовищ.%SPEECH_OFF%Вы интересуетесь, как он прознал о вашем успехе. Он удовлетворяет ваше любопытство.%SPEECH_ON%У меня много глаз и ушей, разбросанных по окрестностям - не шпионы, конечно, просто у местных жителей весьма длинные языки. Я точно знаю, сам такой! Ты прекрасно справился, наёмник, а теперь можешь и выпить. Очень хорошее вино.%SPEECH_OFF%И в самом деле, неплохое. Хотя награда, %reward_completion% крон, за которой вы прибыли - куда как лучше. %employer% останавливает вас.%SPEECH_ON%Просто чтоб ты знал, наёмник, эти твари убили множество хороших мужчин и женщин. Мои люди могут бояться тебя, видя в тебе наёмника, коим ты и являешься, но они всё равно бесконечно тебе благодарны.%SPEECH_OFF%Вы взвешиваете полученные кроны в руке, оценивая степень их благодарности. И впрямь довольно неплохо... | %employer% делает несколько шагов назад.%SPEECH_ON%Ох, вижу, ты покончил с этими тварями. Должен признать, ты добыл весьма неплохую шкуру.%SPEECH_OFF%Вы сбрасываете то, что принесли с собой. Толстая, тяжёлая звериная шкуря складывается в гору меха и плоти. %employer%, слишком испуганный, чтобы приблизиться, бросает вам причитающийся кошель.%SPEECH_ON%%reward_completion% крон, как договаривались ранее. Я, пожалуй, выйду к людям и поведаю им о твоём успехе. Наконец-то к нам вернулся мир.%SPEECH_OFF% | %employer% сидит, запрокинув ноги на стол. Его глаза устремлены в потолок, а усталое лицо испещрено морщинами. Он смотрит на вас.%SPEECH_ON%С возвращением, наёмник. Слышал, слышал о твоих свершениях... славная, наверное, вышла битва.%SPEECH_OFF%Вы киваете, оглядываясь вокруг в поисках вашей награды. Он указывает на дверь.%SPEECH_ON%%randomname% из городского совета ждёт тебя снаружи. Он передаст тебе %reward_completion% крон, как и было условлено. И хотя жители города %townname% вполне заслуженно опасаются тебе подобных, твоему прибытию они безмерно рады. Спасибо тебе, наёмник.%SPEECH_OFF% | Когда вы входите, %employer% кормит одну из своих собак. Псина выпускает кость из пасти и настороженно принюхивается к тому, что вы принесли. Мужчина указывает на шкуру.%SPEECH_ON%Что это за мерзкая штуковина?%SPEECH_OFF%Вы пожимаете плечами и швыряете её на стол. Пёс тычет носом в один из когтей, рычит, затем начинает облизывать его. %employer% коротко улыбается, затем подходит к книжной полке, достаёт оттуда деревянный ларец и протягивает его вам.%SPEECH_ON%%reward_completion% крон, всё верно? Тебе стоит знать, что ты принёс спокойствие жителям города %townname%.%SPEECH_OFF%Вы киваете.%SPEECH_ON%А их спокойствие, совершенно случайно, не измеряется в кронах?%SPEECH_OFF%%employer% хмурится, не слишком оценив вашу алчную шуточку.%SPEECH_ON%Нет, не измеряется. Хорошего дня, наёмник.%SPEECH_OFF%}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Удачная охота.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Избавил город от лютоволков");
						this.World.Contracts.finishActiveContract();
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
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success2",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% приветствует вас по возвращении.%SPEECH_ON%Я уже слышал, что ты принёс, как полагаю, радостные новости. Впрочем, я с трудом могу в них поверить. Кучка разбойников, промышлявших переодеваниями. Волки... в волчьих шкурах?%SPEECH_OFF%Он ухмыляется вам, должно быть ожидая, что вы посмеётесь над его дрянной хохмой. Вы пожимаете плечами. Он делает то же самое.%SPEECH_ON%Ну да ладно. Твоя плата, %reward_completion% крон, ожидает тебя снаружи. Я расскажу жителями города %townname%, что монстры, которых они так боялись - всего лишь люди.%SPEECH_OFF% | Вы возвращаетесь к нанимателю вместе с одеяниями незадачливых разбойников, которых покарали ранее. %employer% вертит части маскировки в руках, поворачивая их то так, то эдак.%SPEECH_ON%Интересно. Они необыкновенно хорошо сделаны. Я бы сказал, что в этом деле эти разбойники были весьма искусны.%SPEECH_OFF%Он поднимает одну из масок, кажется, что он вот-вот примерит её, однако вовремя останавливается, понимая, что было бы не разумно делать это при посторонних. Он кладёт маску на место и улыбается вам.%SPEECH_ON%Что ж, в любом случае, наёмник... хорошая работа. Твоя награда, %reward_completion% крон ожидает тебя снаружи, можешь забрать её у члена городского совета. Он сам найдёт тебя. Наконец-то жители города %townname% смогут похоронить мёртвых и обрести мир.%SPEECH_OFF% | %employer% заливается смехом, едва вы появляетесь.%SPEECH_ON%Люди? Это были всего лишь люди?%SPEECH_OFF%Вы киваете, но пытаетесь вернуть разговор в нужное русло.%SPEECH_ON%Они убили множество крестьян - и они крайне опасны.%SPEECH_OFF%Ваш наниматель кивает.%SPEECH_ON%Конечно, конечно! Я не собирался умалять ничьих заслуг. Даже не смей думать так обо мне, наёмник, ведь это мои друзья и родичи погибали там! В любом случае, ты сделал всё, что было велено и за это я тебе благодарен.%SPEECH_OFF%Он протягивает вам кошель, наполненный монетами. Вы насчитываете %reward_completion% крон, затем идёте к выходу. %employer% окликает вас.%SPEECH_ON%Ты наверняка понимаешь, почему я пытаюсь найти хотя бы крупицу юмора в этом ужасном мире? Ведь это я был на похоронах всех этих убитых бедняг. И я не собираюсь слечь в могилу с хмурым лицом, вне зависимости от того, сколь сильно это проклятое место пытается принудить меня к этому.%SPEECH_OFF% | Вы показываете нанимателю свидетельства бесчинств разбойников. %employer% ворошит ошмётки маскировочных плащей, вытирает запёкшуюся кровь с пальцев.%SPEECH_ON%Это и вправду похоже на человеческую кровь. Ты уверен, что они не просто развлекались, притворяясь чудищами, в то время как настоящие монстры всё ещё бродят где-то там?%SPEECH_OFF%Вы поджимаете губы и объясняете, что напали они на вас, размахивая отнюдь не игрушечным оружием. %employer% кивает, по-видимому соглашаясь, хотя и с некоторым сомнением.%SPEECH_ON%Ну, полагаю, я могу просто подождать, проследить, не появятся ли чудища снова. Если же появятся, что ж, предатели и есть самые ужасные чудовища на этой земле, разве не так?%SPEECH_OFF%Вы просто предлагаете нанимателю расплатиться с вами, а уж потом подождать и посмотреть, если он настолько недоверчив. Он кивает, выплачивает заработанные %reward_completion% крон и провожает вас к выходу.%SPEECH_ON%Я искренне надеюсь на то, что сказанное тобой правда, наёмник. %townname% благодарен передышке от тех ужасов, которые с необычайной регулярностью подкидывает нам этот проклятый мир.%SPEECH_OFF% | %employer% проводит пальцем по краю маски.%SPEECH_ON%Мех столь мягок на ощупь. Очень похож на настоящий...%SPEECH_OFF%Он смотрит на вас.%SPEECH_ON%Интересно, убили ли они настоящих чудовищ, а затем... решили нацепить на себя их шкуры? Но зачем? Быть может, они были прокляты?%SPEECH_OFF%Вы пожимаете плечами и отвечаете.%SPEECH_ON%Всё, что я могу сказать - это то, что они носили личину чудовищ и вели себя соответствующе. Они напали на нас и поплатились за это. Кто-либо из местных жителей заметил каких-либо чудищ за последнее время?%SPEECH_OFF%Наниматель достаёт кошель с %reward_completion% крон и толкает его к вам.%SPEECH_ON%Нет, не видели. На самом деле, они только начинают отваживаться выбираться наружу. Я вовсе не дороги имею в виду, даже открыть входную дверь для многих - уже смелый поступок! Ты несомненно принёс нам спокойствие, наёмник, и мы благодарим тебя за это.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Чудовища, люди... золото - вот что важно!",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Избавил город от разбойников, маскирующихся под лютоволков");
						this.World.Contracts.finishActiveContract();
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
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success3",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{%employer% справляет нужду, когда вы находите его. Он встаёт, натягивает штаны, позволяя слуге забрать ведро, на котором он сидел. Несчастный прислужник быстро выбегает из комнаты. %employer% указывает на голову нахцерера, кружащуюся в вашей руке.%SPEECH_ON%Какая отвратительная вещь. %randomname% выдаст тебе твою плату. %reward% крон, всё верно?%SPEECH_OFF% | Вы кладёте голову нахцерера на стол перед нанимателем. По какой-то причине, кровь всё ещё сочится из его шеи, растекаясь по дубовой столешнице. %employer% откидывается назад, складывая руки на животе.%SPEECH_ON%Нахцереры? А что дальше, призраки?%SPEECH_OFF%Он тихо смеётся.%SPEECH_ON%Всё это слишком просто для тебя, наёмник. Верно?%SPEECH_OFF%Он щёлкает пальцами. Появляется слуга, который протягивает вам кошель. %reward% крон. | Между битвой и появлением у нанимателя прошло немало времени, пасть нахцерера заполонили мухи, его язык превратился в бесформенный, пульсирующий, гудящий чёрный комок. %employer% бросает на него взгляд и прикрывает рот платком.%SPEECH_ON%Да, мне всё ясно, а теперь убери это, пожалуйста.%SPEECH_OFF%Взмахом руки он подзывает одного из стражей, вручающего вам кошель. %reward% крон. | С суровым выражением лица, %employer% склоняется к голове нахцерера, которую вы принесли, дабы получше её рассмотреть.%SPEECH_ON%Весьма примечательно, наёмник. Я рад, что ты принёс это мне.%SPEECH_OFF%Он выпрямляется.%SPEECH_ON%Оставь голову здесь. Возможно мне удастся напугать ею детишек. Как по мне, эти несносные сорванцы слишком уж изнежены.%SPEECH_OFF%Он щёлкает пальцами и появившийся на зов слуга вручает вам %reward% крон. | Вы отдаёте голову нахцерера нанимателю. %employer% пристально её разглядывает.%SPEECH_ON%Она напомнила мне кое-кого. Не могу только вспомнить, кого именно, да и не уверен, что стоит вспоминать. Прости, наёмник, я отнимаю твоё время, не заплатив за него. Слуга, передай этому человеку его деньги!%SPEECH_OFF%Вы получаете плату, как и было обещано. | %employer% берёт голову нахцерера и поднимает её. Словно бы из ниоткуда возникает несколько мяукающих кошек, которые трутся у его ног, напоминая стервятников, кружащих над головой. Он выбрасывает голову в окно и кошки убегают.%SPEECH_ON%Хорошая работа, наёмник. Вот твои %reward% крон, как обещано.%SPEECH_OFF% | Вы кладёте голову нахцерера на стол нанимателя. %employer% отрывает взгляд от обеденной тарелки, смотрит на голову, затем переводит взгляд на вас.%SPEECH_ON%Наёмник, я вообще-то обедаю.%SPEECH_OFF%Столовое серебро звенит, когда наниматель с отвращением отпихивает тарелку в сторону. Слуга уносит еду прочь, чтобы потом доесть её самостоятельно. %employer% достаёт кошель и кладёт его на стол.%SPEECH_ON%Вот твои %reward_completion% крон, как и было обещано.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Удачная охота.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Избавил город от нахцереров");
						this.World.Contracts.finishActiveContract();
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
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success4",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Вы находите %employer% почивающим на лаврах. Он встаёт и натягивает штаны, слуга быстро убирает ведро, на котором он сидел. Бедный слуга быстро выбегает из комнаты. %employer% указывает на голову Волкокрыса, свисающую с вашей руки.%SPEECH_ON%Это абсолютно отвратительно. %randomname%, дай этому человеку его плату. %reward% монет, так?%SPEECH_OFF% | Вы кладёте голову Волкокрыса на стол %employer%. По какой-то причине жидкости всё ещё сочатся из её шеи, капая по боку дубового стола и, несомненно, пачкая его. Мужчина откидывается назад, складывая пальцы домиком на животе.%SPEECH_ON%Волкокрыс? А что ещё, Скавены?%SPEECH_OFF%Мужчина посмеивается про себя.%SPEECH_ON%Для тебя нет ничего слишком сложного, наёмник.%SPEECH_OFF%Он щёлкает пальцами, и слуга подходит, вручая вам мешок с %reward% монетами. | Пока вы шли от битвы до жилища %employer%, пасть Волкокрыса наполнилась мухами, его язык заменился бесформенным, пульсирующим чёрным шаром, который больше жужжит, чем кусает. %employer% бросает на него один взгляд и прижимает ткань ко рту.%SPEECH_ON%Да, понял, уберите это, пожалуйста.%SPEECH_OFF%Он машет одному из своих стражников, и вам вручают мешок с %reward% монетами. | Стальной взгляд %employer% наклоняется вперёд, чтобы хорошенько рассмотреть голову Волкокрыса, которую вы принесли.%SPEECH_ON%Впечатляющее зрелище, наёмник. Я рад, что ты принёс её мне.%SPEECH_OFF%Он откидывается назад.%SPEECH_ON%Оставь её на моём столе. Может, я смогу пугать ей детей. Мелкие ублюдки, кажется, слишком привыкают к роскоши.%SPEECH_OFF%Он щёлкает пальцами, и слуга приходит, чтобы отдать вам %reward% монет. | Вы приносите голову Волкокрыса %employer%, который долго на неё смотрит.%SPEECH_ON%Кого-то напоминает. Не могу точно понять, кого, и не уверен, что должен. Извини, наёмник, я отнимаю твоё время бесплатно. Слуга, дай этому человеку его деньги!%SPEECH_OFF%Вы получаете обещанную награду. | %employer% берёт голову Волкокрыса и поднимает её. Откуда ни возьмись появляются несколько мяукающих кошек, кружа под ней, как стервятники в небе. Он выбрасывает её в окно, и кошки убегают.%SPEECH_ON%Хорошая работа, наёмник. %reward% монет, как и обещал.%SPEECH_OFF% | Вы кладёте голову Волкокрыса на стол %employer%. Он отрывается от тарелки с едой, смотрит на голову, затем на вас.%SPEECH_ON%Я ел, наёмник.%SPEECH_OFF%Столовые приборы гремят, когда брезгливый мужчина отодвигает тарелку. Слуга уносит еду, вероятно, чтобы съесть её самому. %employer% достаёт мешок и кладёт его на стол.%SPEECH_ON%%reward_completion% монет, как и обещал.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Удачная охота.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Избавил город от волкокрыс");
						this.World.Contracts.finishActiveContract();
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
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success5",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Вы входите в кабинет нанимателя, неся за спиной дохлого паука. %employer% кричит и падает вместе со своим креслом. Вскочив на ноги, он хватает кухонный нож со стола. Вы сбрасываете мёртвого сетеплёта на пол, брюхом кверху. Горожанин опасливо приближается. Он втыкает нож обратно в буханку хлеба и качает головой.%SPEECH_ON%Клянусь древними богами, у меня чуть сердце не прихватило.%SPEECH_OFF%Кивнув, вы рассказываете ему, что одного большого башмака недостаточно, чтобы прихлопнуть этих тварей. %employer% качает головой.%SPEECH_ON%Разумеется, наёмник. Разумеется! Вон в том углу лежит твоя награда, как договаривались. И, прошу, забери с собой эту чёртову тварь, когда будешь уходить.%SPEECH_OFF% | Кошки, шипя, разбегаются, когда вы входите в кабинет нанимателя. Несколько псов, всегда охочих до нового, суетятся возле ваших ног, обнюхивая паучью тушу. Их носы морщатся и отдёргиваются, но тут же возвращаются. %employer%, с трудом веря своим глазам, делает заметки. Он опускает перо в чернильницу.%SPEECH_ON%Это гигантский паук?%SPEECH_OFF%Вы киваете. Он улыбается и вновь поднимает перо.%SPEECH_ON%Мне стоило посоветовать тебе одеть сапоги побольше. Твоё вознаграждение, %reward_completion% крон, вон в том кошеле. Давай, бери его, сумма верна. И оставь тушу. Я хочу поближе рассмотреть это существо.%SPEECH_OFF% | %employer% празднует свой день рождения, когда вы входите в его дом, таща за собой огромного паука. Брошенный на пол, покрытый жёсткой щетиной паук со странным шелестом скользит по каменному полу, его лапы - все восемь - качаются из стороны в сторону. Он катится, ударяется о книжную полку и вновь оказывается на ногах, словно готовый броситься за добычей. Гости кричат и разбегаются в ужасе, бросаясь кто в двери, а кто - в раскрытые окна, выпадая на улицу, словно цветное конфетти. Староста в одиночестве стоит посреди опустевшей комнаты, поджав губы.%SPEECH_ON%Наёмник, скажи, это действительно было так уж необходимо?%SPEECH_OFF%Кивнув, вы отвечаете, что нанять вас было точно необходимо, да и платить вам тоже будет необходимо. %employer% качает головой и взмахом руки указывает в угол комнаты.%SPEECH_ON%Там твой кошель. %reward_completion% крон, как и обещано. А теперь убери отсюда эту ужасную вещь и скажи тем замечательным людям, что праздник ещё не законен.%SPEECH_OFF% | Вы не думаете, что сможете уместить паучью тушу в кабинете нанимателя, поэтому кидаете его в окно с улицы. Слышен ужасный крик и грохот упавшей мебели. Чуть позже распахивается соседнее окно. %employer% перевешивается через подоконник.%SPEECH_ON%Очень смешно, наёмник. Просто обхохочешься! Пусть древние боги даруют тебе за это тысячелетие полного безденежья!%SPEECH_OFF%Кивнув, вы спрашиваете о своей плате. Он неохотно бросает вам кошель.%SPEECH_ON%В нём %reward_completion% крон. Теперь возьми эту ужасную вещь и убирайся!%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Удачная охота.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Rid the town of webknechts");
						this.World.Contracts.finishActiveContract();
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
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
		this.m.Screens.push({
			ID = "Success6",
			Title = "По возвращении...",
			Text = "[img]gfx/ui/events/event_04.png[/img]{Вы возвращаетесь к нанимателю и бросаете хитин Анхега прямо на его стол. %employer% трогает её, затем вытирает палец о штаны.%SPEECH_ON%Вижу, ты всё же нашёл чудовищ, которых мы искали.%SPEECH_OFF%Вы рассказываете ему о битве. Он выглядит почти довольным, доставая небольшой деревянный сундучок с книжной полки и протягивая его вам.%SPEECH_ON%%reward_completion% крон, как и условились. Жители города %townname% заслуживают передышку, которую ты даровал им, избавив от этого ужаса.%SPEECH_OFF% | Когда вы входите в кабинет нанимателя, %employer% мгновенно отскакивает от вас.%SPEECH_ON%Что за дрянь, во имя всех богов, у тебя в руках, наёмник?%SPEECH_OFF%Вы поднимаете хитин, держа его на вытянутой руке. Чёрная кровь стекает с него и разбрызгивается по полу.%SPEECH_ON%Одна из тех тварей, что ты искал. Если же нужны доказательства смерти всех остальных, они ожидают снаружи...%SPEECH_OFF%%employer% поднимает руки, останавливая вас.%SPEECH_ON%Достаточно и одной, чтобы я поверил. Очень хорошая работа, наёмник. Плату тебе отдаст %randomname%, он из городского совета, быть может, вы даже пересекались с ним в коридорах. У него столь уродливое рыло, что ни с кем нельзя спутать. %reward_completion% крон, как и договаривались.%SPEECH_OFF%Он вновь рассматривает чудовище, затем неспешно склоняет голову.%SPEECH_ON%Пусть же мёртвые и выжившие обретут успокоение в избавлении от этих мерзких исчадий.%SPEECH_OFF% | %employer% приветствует вас, протягивая кубок, полный вина.%SPEECH_ON%Выпей же, истребитель чудовищ.%SPEECH_OFF%Вы интересуетесь, как он прознал о вашем успехе. Он удовлетворяет ваше любопытство.%SPEECH_ON%У меня много глаз и ушей, разбросанных по окрестностям - не шпионы, конечно, просто у местных жителей весьма длинные языки. Я точно знаю, сам такой! Ты прекрасно справился, наёмник, а теперь можешь и выпить. Очень хорошее вино.%SPEECH_OFF%И в самом деле, неплохое. Хотя награда, %reward_completion% крон, за которой вы прибыли - куда как лучше. %employer% останавливает вас.%SPEECH_ON%Просто чтоб ты знал, наёмник, эти твари убили множество хороших мужчин и женщин. Мои люди могут бояться тебя, видя в тебе наёмника, коим ты и являешься, но они всё равно бесконечно тебе благодарны.%SPEECH_OFF%Вы взвешиваете полученные кроны в руке, оценивая степень их благодарности. И впрямь довольно неплохо... | %employer% делает несколько шагов назад.%SPEECH_ON%Ох, вижу, ты покончил с этими тварями. Должен признать, ты добыл весьма неплохую шкуру.%SPEECH_OFF%Вы сбрасываете то, что принесли с собой. Толстая, тяжёлая звериная шкуря складывается в гору меха и плоти. %employer%, слишком испуганный, чтобы приблизиться, бросает вам причитающийся кошель.%SPEECH_ON%%reward_completion% крон, как договаривались ранее. Я, пожалуй, выйду к людям и поведаю им о твоём успехе. Наконец-то к нам вернулся мир.%SPEECH_OFF% | %employer% сидит, запрокинув ноги на стол. Его глаза устремлены в потолок, а усталое лицо испещрено морщинами. Он смотрит на вас.%SPEECH_ON%С возвращением, наёмник. Слышал, слышал о твоих свершениях... славная, наверное, вышла битва.%SPEECH_OFF%Вы киваете, оглядываясь вокруг в поисках вашей награды. Он указывает на дверь.%SPEECH_ON%%randomname% из городского совета ждёт тебя снаружи. Он передаст тебе %reward_completion% крон, как и было условлено. И хотя жители города %townname% вполне заслуженно опасаются тебе подобных, твоему прибытию они безмерно рады. Спасибо тебе, наёмник.%SPEECH_OFF% | Когда вы входите, %employer% кормит одну из своих собак. Псина выпускает кость из пасти и настороженно принюхивается к тому, что вы принесли. Мужчина указывает на шкуру.%SPEECH_ON%Что это за мерзкая штуковина?%SPEECH_OFF%Вы пожимаете плечами и швыряете её на стол. Пёс тычет носом в один из когтей, рычит, затем начинает облизывать его. %employer% коротко улыбается, затем подходит к книжной полке, достаёт оттуда деревянный ларец и протягивает его вам.%SPEECH_ON%%reward_completion% крон, всё верно? Тебе стоит знать, что ты принёс спокойствие жителям города %townname%.%SPEECH_OFF%Вы киваете.%SPEECH_ON%А их спокойствие, совершенно случайно, не измеряется в кронах?%SPEECH_OFF%%employer% хмурится, не слишком оценив вашу алчную шуточку.%SPEECH_ON%Нет, не измеряется. Хорошего дня, наёмник.%SPEECH_OFF%}",
			Image = "",
			List = [],
			ShowEmployer = true,
			Options = [
				{
					Text = "Удачная охота.",
					function getResult()
					{
						this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractSuccess);
						this.World.Assets.addMoney(this.Contract.m.Payment.getOnCompletion());
						this.World.FactionManager.getFaction(this.Contract.getFaction()).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Rid the town of webknechts");
						this.World.Contracts.finishActiveContract();
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
				this.Contract.m.SituationID = this.Contract.resolveSituation(this.Contract.m.SituationID, this.Contract.m.Home, this.List);
			}

		});
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_helpful = [];
		local candidates_bro1 = [];
		local candidates_bro2 = [];
		local helpful;
		local bro1;
		local bro2;

		foreach( bro in brothers )
		{
			if (bro.getBackground().isLowborn() && !bro.getBackground().isOffendedByViolence() && !bro.getSkills().hasSkill("trait.bright") && bro.getBackground().getID() != "background.hunter")
			{
				candidates_helpful.push(bro);
			}

			if (!bro.getSkills().hasSkill("trait.player"))
			{
				candidates_bro1.push(bro);

				if (!bro.getBackground().isOffendedByViolence() && bro.getBackground().isCombatBackground())
				{
					candidates_bro2.push(bro);
				}
			}
		}

		if (candidates_helpful.len() != 0)
		{
			helpful = candidates_helpful[this.Math.rand(0, candidates_helpful.len() - 1)];
		}
		else
		{
			helpful = brothers[this.Math.rand(0, brothers.len() - 1)];
		}

		if (candidates_bro1.len() != 0)
		{
			bro1 = candidates_bro1[this.Math.rand(0, candidates_bro1.len() - 1)];
		}
		else
		{
			bro1 = brothers[this.Math.rand(0, brothers.len() - 1)];
		}

		if (candidates_bro2.len() > 1)
		{
			do
			{
				bro2 = candidates_bro2[this.Math.rand(0, candidates_bro2.len() - 1)];
			}
			while (bro2.getID() == bro1.getID());
		}
		else if (brothers.len() > 1)
		{
			do
			{
				bro2 = brothers[this.Math.rand(0, brothers.len() - 1)];
			}
			while (bro2.getID() == bro1.getID());
		}
		else
		{
			bro2 = bro1;
		}

		_vars.push([
			"helpfulbrother",
			helpful.getName()
		]);
		_vars.push([
			"bro1",
			bro1.getName()
		]);
		_vars.push([
			"bro2",
			bro2.getName()
		]);
		_vars.push([
			"direction",
			this.m.Target == null || this.m.Target.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Target.getTile())]
		]);
	}

	function onHomeSet()
	{
		if (this.m.SituationID == 0)
		{
			this.m.SituationID = this.m.Home.addSituation(this.new("scripts/entity/world/settlements/situations/disappearing_villagers_situation"));
		}
	}

	function onClear()
	{
		if (this.m.IsActive)
		{
			if (this.m.Target != null && !this.m.Target.isNull())
			{
				this.m.Target.getSprite("selection").Visible = false;
				this.m.Target.setOnCombatWithPlayerCallback(null);
			}

			this.m.Home.getSprite("selection").Visible = false;
		}

		if (this.m.Home != null && !this.m.Home.isNull() && this.m.SituationID != 0)
		{
			local s = this.m.Home.getSituationByInstance(this.m.SituationID);

			if (s != null)
			{
				s.setValidForDays(3);
			}
		}
	}

	function onIsValid()
	{
		return true;
	}

	function onSerialize( _out )
	{
		if (this.m.Target != null && !this.m.Target.isNull())
		{
			_out.writeU32(this.m.Target.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		this.contract.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		local target = _in.readU32();

		if (target != 0)
		{
			this.m.Target = this.WeakTableRef(this.World.getEntityByID(target));
		}

		this.contract.onDeserialize(_in);
	}

});

