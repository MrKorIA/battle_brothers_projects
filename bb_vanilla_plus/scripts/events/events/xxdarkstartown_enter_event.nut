this.xxdarkstartown_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.xxdarkstartown_enter_event";
		this.m.Title = "По мере приближения...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_154.png[/img]{Давным-давно существовал великий город с блестящей цивилизацией. Он процветал веками, но однажды был разрушен темной звездой, упавшей с неба. Это разрушенное место долгое время оставалось заброшенным, а теперь его заняли фанатики, поклоняющиеся Темной Звезде.}",
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
						pp.Music = this.Const.Music.NobleTracks;
						pp.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
						pp.LocationTemplate.Template[0] = "tactical.xxtactical_knighttown";
						pp.TerrainTemplate = "tactical.quarry";
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
						pp.Entities.push({
							ID = this.Const.EntityType.AlpShadow,
							Variant = 0,
							Row = 0,
							Script = "scripts/entity/tactical/enemies/xxmob_cosmicsummoner",
							Faction = this.Const.Faction.Enemy
						});
						for( local i = 0; i < 3; i = ++i )
						{
							pp.Entities.push({
								ID = this.Const.EntityType.AlpShadow,
								Variant = 0,
								Row = 2,
								Script = "scripts/entity/tactical/enemies/bandit_thug",
								Faction = this.Const.Faction.Enemy
							});
							pp.Entities.push({
								ID = this.Const.EntityType.AlpShadow,
								Variant = 0,
								Row = 3,
								Script = "scripts/entity/tactical/enemies/bandit_raider_low",
								Faction = this.Const.Faction.Enemy
							});
							pp.Entities.push({
								ID = this.Const.EntityType.AlpShadow,
								Variant = 0,
								Row = 4,
								Script = "scripts/entity/tactical/enemies/bandit_raider",
								Faction = this.Const.Faction.Enemy
							});
						}
						_event.registerToShowAfterCombat("VictoryA", "Defeat");
						this.World.State.startScriptedCombat(pp, false, false, true);
						return 0;
					}
				},
				{
					Text = "Отступить!",
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
			ID = "VictoryA",
			Text = "[img]gfx/ui/events/event_36.png[/img]{Вы победили аватара, рожденного из сущности Темной Звезды. Мир теперь в безопасности. Вы вздыхаете с облегчением и оглядываетесь вокруг. Фанатики, следовавшие за Темной Звездой, похитили множество жертв для своих ритуалов. Теперь вам предстоит решить, искать ли оставшихся в живых или собирать останки павших.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Поиск выживших.",
					function getResult( _event )
					{
						if (this.World.getPlayerRoster().getSize() < this.World.Assets.getBrothersMax())
						{
							return "VictoryB";
						}
						else
						{
							return "VictoryC";
						}
					}
				},
				{
					Text = "Собрать погибших.",
					function getResult( _event )
					{
						return "VictoryC";
					}
				}
			],
			function start( _event )
			{
				_event.m.Title = "После битвы...";
				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().die();
				}
			}

		});
		this.m.Screens.push({
			ID = "VictoryB",
			Text = "[img]gfx/ui/events/event_35.png[/img]{Вы обнаруживаете связанного выжившего, существо с птичьим лицом и длинной бородой, не обычного человека. Он настороженно относится к вашему приближению, но вскоре понимает, что вы не принадлежите к фанатичной орде, и, кажется, облегченно вздыхает. Он принадлежит к забытой расе эльфов, известной своей долговечностью и воинственным, но врожденно мудрым характером, которых часто называют «боевыми мудрецами». Когда вы в шутку замечаете, что настоящий мудрец не должен быть пленен и связан в таком опасном месте, он от души смеется, говоря, что это была драматическая постановка для нашего впечатляющего первого знакомства. Вы вспоминаете, что боевые мудрецы занесены в историю как свободные воины, которые на протяжении веков сражались за великие дела и, как правило, заслужили хорошую репутацию. Вы освобождаете его от пут и приглашаете присоединиться к вашей банде наемников. Он говорит, что давно не ел, и просит сытную еду в качестве аванса за контракт.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "У меня есть хорошая еда, брат.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getPlayerRoster();
				local xxlonexx = roster.create("scripts/entity/tactical/player");
				xxlonexx.setStartValuesEx([
					"xxheroroc_background"
				]);
				xxlonexx.m.HireTime = this.Time.getVirtualTimeF();
				xxlonexx.m.PerkPoints = 1;
				xxlonexx.m.LevelUps = 1;
				xxlonexx.m.Level = 2;
				xxlonexx.m.Talents = [];
				xxlonexx.m.Attributes = [];
				local talents = xxlonexx.getTalents();
				talents.resize(this.Const.Attributes.COUNT, 0);
				talents[this.Const.Attributes.Hitpoints] = 3;
				talents[this.Const.Attributes.Bravery] = 3;
				talents[this.Const.Attributes.Fatigue] = 3;
				talents[this.Const.Attributes.MeleeSkill] = 3;
				talents[this.Const.Attributes.RangedSkill] = 3;
				talents[this.Const.Attributes.MeleeDefense] = 3;
				talents[this.Const.Attributes.RangedDefense] = 3;
				talents[this.Const.Attributes.Initiative] = 3;
				xxlonexx.fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
				return 0;
			}
		});
		this.m.Screens.push({
			ID = "VictoryC",
			Text = "[img]gfx/ui/events/event_154.png[/img]{Вы получаете полезные предметы. Среди них были редкие вещи, о которых вы раньше не слышали и не видели. Набрав достаточно добычи, вы готовитесь к отходу.}",
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
				this.World.Assets.getStash().makeEmptySlots(2);
				local item = this.new("scripts/items/misc/xxmysteriouspotion");
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

