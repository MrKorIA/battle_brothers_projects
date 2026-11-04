this.xxruinedtown_enter_event <- this.inherit("scripts/events/event", {
	m = {
		RewardItem = 1
	},
	function create()
	{
		this.m.ID = "event.xxruinedtown_enter_event";
		this.m.Title = "По мере приближения...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_71.png[/img]{Город разрушен, превращен в пепел. Ни одного жителя не видно. Вы чувствуете, что что-то не так. Бесконечная злоба медленно приближается. Это ни что иное, как...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Бандиты!",
					function getResult( _event )
					{
						_event.m.RewardItem = 1;
						local pp = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						pp.CombatID = "Event";
						pp.Music = this.Const.Music.BanditTracks;
						pp.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						pp.LocationTemplate.Template[0] = "tactical.xxtactical_ruintown";
						pp.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
						pp.LocationTemplate.ForceLineBattle = false;
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
						local unit;
						pp.Entities.push({
							ID = this.Const.EntityType.AlpShadow,
							Variant = 0,
							Row = 2,
							Script = "scripts/entity/tactical/enemies/xxmob_unknown",
							Faction = this.Const.Faction.Enemy
						});
						for( local i = 0; i < 5; i = ++i )
						{
							unit = clone this.Const.World.Spawn.Troops.Mercenary;
							unit.Faction <- this.Const.Faction.Enemy;
							pp.Entities.push(unit);
							unit = clone this.Const.World.Spawn.Troops.MercenaryRanged;
							unit.Faction <- this.Const.Faction.Enemy;
							pp.Entities.push(unit);
						}
						for( local i = 0; i < 2; i = ++i )
						{
							unit = clone this.Const.World.Spawn.Troops.MercenaryLOW;
							unit.Faction <- this.Const.Faction.Enemy;
							pp.Entities.push(unit);
							unit = clone this.Const.World.Spawn.Troops.BountyHunter;
							unit.Faction <- this.Const.Faction.Enemy;
							pp.Entities.push(unit);
							unit = clone this.Const.World.Spawn.Troops.BountyHunterRanged;
							unit.Faction <- this.Const.Faction.Enemy;
							pp.Entities.push(unit);
							unit = clone this.Const.World.Spawn.Troops.BanditRaiderWolf;
							unit.Faction <- this.Const.Faction.Enemy;
							pp.Entities.push(unit);
							unit = clone this.Const.World.Spawn.Troops.BanditRaider;
							unit.Faction <- this.Const.Faction.Enemy;
							pp.Entities.push(unit);
							unit = clone this.Const.World.Spawn.Troops.BanditMarksman;
							unit.Faction <- this.Const.Faction.Enemy;
							pp.Entities.push(unit);
						}
						unit = clone this.Const.World.Spawn.Troops.MasterArcher;
						unit.Faction <- this.Const.Faction.Enemy;
						pp.Entities.push(unit);
						unit = clone this.Const.World.Spawn.Troops.HedgeKnight;
						unit.Faction <- this.Const.Faction.Enemy;
						pp.Entities.push(unit);
						unit = clone this.Const.World.Spawn.Troops.BanditLeader;
						unit.Faction <- this.Const.Faction.Enemy;
						pp.Entities.push(unit);
						_event.registerToShowAfterCombat("Victory", "Defeat");
						this.World.State.startScriptedCombat(pp, false, false, true);
						return 0;
					}
				}, //Bandits End
				{
					Text = "Мертвецы!",
					function getResult( _event )
					{
						_event.m.RewardItem = 2;
						local pp = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						pp.CombatID = "Event";
						pp.Music = this.Const.Music.UndeadTracks;
						pp.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						pp.LocationTemplate.Template[0] = "tactical.xxtactical_ruintown";
						pp.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
						pp.LocationTemplate.ForceLineBattle = false;
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
						pp.Entities = [];
						local unit;
						pp.Entities.push({
							ID = this.Const.EntityType.AlpShadow,
							Variant = 0,
							Row = 4,
							Script = "scripts/entity/tactical/enemies/xxmob_archlich",
							Faction = this.Const.Faction.Enemy
						});
						for( local i = 0; i < 6; i = ++i )
						{
							pp.Entities.push({
								ID = this.Const.EntityType.AlpShadow,
								Variant = 0,
								Row = 0,
								Script = "scripts/entity/tactical/enemies/zombie_treasure_hunter",
								Faction = this.Const.Faction.Enemy
							});
							unit = clone this.Const.World.Spawn.Troops.ZombieBetrayer;
							unit.Faction <- this.Const.Faction.Enemy;
							pp.Entities.push(unit);
							unit = clone this.Const.World.Spawn.Troops.ZombieKnight;
							unit.Faction <- this.Const.Faction.Enemy;
							pp.Entities.push(unit);
							unit = clone this.Const.World.Spawn.Troops.SkeletonHeavyPolearm;
							unit.Faction <- this.Const.Faction.Enemy;
							pp.Entities.push(unit);

						}
						_event.registerToShowAfterCombat("Victory", "Defeat");
						this.World.State.startScriptedCombat(pp, false, false, true);
						return 0;
					}
				}, //Undeads End
				{
					Text = "Орки!",
					function getResult( _event )
					{
						_event.m.RewardItem = 3;
						local pp = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						pp.CombatID = "Event";
						pp.Music = this.Const.Music.OrcsTracks;
						pp.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						pp.LocationTemplate.Template[0] = "tactical.xxtactical_ruintown";
						pp.LocationTemplate.Fortification = this.Const.Tactical.FortificationType.Walls;
						pp.LocationTemplate.ForceLineBattle = false;
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
						local unit;
						pp.Entities.push({
							ID = this.Const.EntityType.AlpShadow,
							Variant = 0,
							Row = 4,
							Script = "scripts/entity/tactical/enemies/xxmob_orcking",
							Faction = this.Const.Faction.Enemy
						});
						for( local i = 0; i < 5; i = ++i )
						{
							unit = clone this.Const.World.Spawn.Troops.OrcWarrior;
							unit.Faction <- this.Const.Faction.Enemy;
							pp.Entities.push(unit);
						}
						for( local i = 0; i < 4; i = ++i )
						{
							unit = clone this.Const.World.Spawn.Troops.OrcBerserker;
							unit.Faction <- this.Const.Faction.Enemy;
							pp.Entities.push(unit);
						}
						for( local i = 0; i < 2; i = ++i )
						{
							unit = clone this.Const.World.Spawn.Troops.OrcYoung;
							unit.Faction <- this.Const.Faction.Enemy;
							pp.Entities.push(unit);
							unit = clone this.Const.World.Spawn.Troops.OrcYoungLOW;
							unit.Faction <- this.Const.Faction.Enemy;
							pp.Entities.push(unit);
							unit = clone this.Const.World.Spawn.Troops.OrcWarriorLOW;
							unit.Faction <- this.Const.Faction.Enemy;
							pp.Entities.push(unit);
						}
						for( local i = 0; i < 2; i = ++i )
						{
							pp.Entities.push({
								ID = this.Const.EntityType.OrcWarlord,
								Variant = 0,
								Row = 3,
								Script = "scripts/entity/tactical/enemies/orc_warlord",
								Faction = this.Const.Faction.Enemy
							});
							pp.Entities.push({
								ID = this.Const.EntityType.AlpShadow,
								Variant = 0,
								Row = 2,
								Script = "scripts/entity/tactical/enemies/xxmob_orclong",
								Faction = this.Const.Faction.Enemy
							});
							pp.Entities.push({
								ID = this.Const.EntityType.AlpShadow,
								Variant = 0,
								Row = 2,
								Script = "scripts/entity/tactical/enemies/xxmob_orchunter",
								Faction = this.Const.Faction.Enemy
							});
						}
						_event.registerToShowAfterCombat("Victory", "Defeat");
						this.World.State.startScriptedCombat(pp, false, false, true);
						return 0;
					}
				}, //Orcs End
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
			Text = "[img]gfx/ui/events/event_68.png[/img]{Кровавая битва закончилась. Лучше всего собрать полезные предметы и покинуть это место.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Готово",
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
				local ww = [
						"weapons/named/named_axe",
						"weapons/named/named_billhook",
						"weapons/named/named_cleaver",
						"weapons/named/named_crossbow",
						"weapons/named/named_crypt_cleaver",
						"weapons/named/named_dagger",
						"weapons/named/named_flail",
						"weapons/named/named_goblin_falchion",
						"weapons/named/named_goblin_heavy_bow",
						"weapons/named/named_goblin_pike",
						"weapons/named/named_goblin_spear",
						"weapons/named/named_greataxe",
						"weapons/named/named_greatsword",
						"weapons/named/named_javelin",
						"weapons/named/named_khopesh",
						"weapons/named/named_longaxe",
						"weapons/named/named_mace",
						"weapons/named/named_orc_axe",
						"weapons/named/named_orc_cleaver",
						"weapons/named/named_pike",
						"weapons/named/named_spear",
						"weapons/named/named_sword",
						"weapons/named/named_warhammer",
						"weapons/named/named_throwing_axe",
						"weapons/named/named_warbow",
						"weapons/named/named_warbrand",
						"weapons/named/named_warhammer",
						"weapons/named/named_warscythe"
				];
				if (this.Const.DLC.Unhold && this.Const.DLC.Wildmen && this.Const.DLC.Desert)
				{
					ww.extend([
						"weapons/named/named_bardiche",
						"weapons/named/named_battle_whip",
						"weapons/named/named_bladed_pike",
						"weapons/named/named_fencing_sword",
						"weapons/named/named_handgonne",
						"weapons/named/named_heavy_rusty_axe",
						"weapons/named/named_polehammer",
						"weapons/named/named_polemace",
						"weapons/named/named_qatal_dagger",
						"weapons/named/named_rusty_warblade",
						"weapons/named/named_shamshir",
						"weapons/named/named_skullhammer",
						"weapons/named/named_spetum",
						"weapons/named/named_swordlance",
						"weapons/named/named_three_headed_flail",
						"weapons/named/named_two_handed_flail",
						"weapons/named/named_two_handed_hammer",
						"weapons/named/named_two_handed_mace",
						"weapons/named/named_two_handed_scimitar",
						"weapons/named/named_two_handed_spiked_mace"
					]);
				}
				local item1 = this.new("scripts/items/" + ww[this.Math.rand(0, ww.len() - 1)]);
				local item2 = this.new("scripts/items/weapons/named/xxorc_flail_two_handed");
				local money = 10000;
				if (_event.m.RewardItem == 1)
				{
					item2 = this.new("scripts/items/special/spiritual_reward_item");
					money = 5000;
				}
				else if (_event.m.RewardItem == 2)
				{
					item2 = this.new("scripts/items/special/fountain_of_youth_item");
				}
				this.World.Assets.getStash().add(item1);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item1.getIcon(),
					text = "Вы получаете "  + this.Const.Strings.getArticle(item1.getName()) + item1.getName()
				});
				this.World.Assets.getStash().add(item2);
				this.List.push({
					id = 11,
					icon = "ui/items/" + item2.getIcon(),
					text = "Вы получаете "  + this.Const.Strings.getArticle(item2.getName()) + item2.getName()
				});
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 12,
					icon = "ui/items/supplies/money.png",
					text = "Вы получаете " + money + " крон"
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

