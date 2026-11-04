this.xxdragontown_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.xxdragontown_enter_event";
		this.m.Title = "По мере приближения...";
		this.m.Cooldown = 0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_12.png[/img]{На земле видны глубокие шрамы и ожоги. Это место, где нет никаких форм жизни и царит только тишина, должно быть, является драконьим гнездом из рассказов стариков. Люди говорят, что драконы вымерли давным-давно, но жара свидетельствует о том, что хозяин гнезда оставался там до недавнего времени. Вскоре раздался звук, похожий на гром, и огромная тень поглотила землю. Если старые сказки стариков правдивы, хозяин этого гнезда безжалостно атакует вторгшихся.}",
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
							Script = "scripts/entity/tactical/enemies/xxmob_dragon",
							Faction = this.Const.Faction.Enemy
						});
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
			Text = "[img]gfx/ui/events/event_36.png[/img]{Раненный дракон в мгновение ока взлетел высоко в небо и исчез. Вы сожалеете, что не довели до конца сражение с этим легендарным существом, но, возможно, вам повезло. Вы не знали, чем закончилась бы битва, если бы вы сражались до конца. \nВы и ваша группа передохнули и осмотрели окрестности драконьего гнезда в поисках чего-нибудь полезного. \nВо время осмотра вы нашли раненого рыцаря. Гигантский медведь лежит мертвый у ног рыцаря в красных доспехах.%SPEECH_ON%Это ты убил этого зверя?%SPEECH_OFF%На твой вопрос мужчина кивнул, на его лице было видно усталость. Тело медведя было ужасно разорвано. Личность мужчины неизвестна, но его боевые навыки не вызывают сомнений. Сможешь ли ты убедить его присоединиться к твоей группе?}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Давайте наймем его. (Нужно свободное место в отряде наемников)",
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
					Text = "Нет, я не хочу, чтобы в нашей группе были посторонние люди.",
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
			Text = "[img]gfx/ui/events/event_35.png[/img]{Мужчина горько улыбается в ответ на ваше предложение. \n\n%SPEECH_START%Забавно. Никогда не думал, что так получится. Наверное, я слишком мало знал о людях. Надо воспользоваться случаем и снова изучить человеческую природу.%SPEECH_OFF% \n\nМужчина принял ваше предложение. Он будет очень полезен для нашего дела в будущем.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Добро пожаловать в отряд, брат.",
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
					"xxherocrimson_background"
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
			Text = "[img]gfx/ui/events/event_04.png[/img]{После того, как мужчина ушел, ваша группа осмотрелась и нашла несколько полезных вещей.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Это того стоило.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(50000);
				this.List.push({
					id = 11,
					icon = "ui/items/supplies/money.png",
					text = "Вы получаете 50000 крон"
				});
				local brothers = this.World.getPlayerRoster().getAll();
				foreach( bro in brothers )
				{
					bro.improveMood(10, "Воодушевление.");

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}
		});
		this.m.Screens.push({
			ID = "Defeat",
			Text = "[img]gfx/ui/events/event_88.png[/img]{Что это за место? Увидев возможность сбежать, вы решаете убежать отсюда..}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Не следовало сюда приходить...",
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

