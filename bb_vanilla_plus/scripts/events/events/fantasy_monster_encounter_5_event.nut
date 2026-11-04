this.fantasy_monster_encounter_5_event <- this.inherit("scripts/events/event", {
	m = {
		Xprice = null,
		Xitem = null
	},
	function create()
	{
		this.m.ID = "event.fantasy_monster_encounter_5_event";
		this.m.Title = "Неожиданное событие...";
		this.m.Cooldown = 100 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_174.png[/img]{По прибытии в соседний город вы встретили странствующего мага, который продавал загадочные предметы. Маги — редкое явление в этом мире, поэтому из любопытства вы подошли к нему, чтобы посмотреть на товары, которые он продавал.%SPEECH_ON%Здравствуйте. Я привез с собой коллекцию редких и экзотических предметов. Позвольте мне показать их вам.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Покажите мне, что вы продаете?",
					function getResult( _event )
					{
						if (this.World.Flags.get("AngryMage") == 1)
						{
							return "Fight2";
						}
						else
						{
							return "B1";
						}
					}
				},
				{
					Text = "Неинтересно",
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
			ID = "B1",
			Text = "[img]gfx/ui/events/event_174.png[/img]{Маг достает свои предметы.%SPEECH_ON%Эти предметы не так легко найти в других местах%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Зелье знания: 650 крон",
					function getResult( _event )
					{
						_event.m.Xitem = this.new("scripts/items/misc/potion_of_knowledge_item");
						_event.m.Xprice = -650;
						return "C";
					}
				},
				{
					Text = "Порошок радости: 300 крон",
					function getResult( _event )
					{
						_event.m.Xitem = this.new("scripts/items/misc/happy_powder_item");
						_event.m.Xprice = -300;
						return "C";
					}
				},
				{
					Text = "Эликсир совы: 250 крон",
					function getResult( _event )
					{
						_event.m.Xitem = this.new("scripts/items/accessory/night_vision_elixir_item");
						_event.m.Xprice = -250;
						return "C";
					}
				},
				{
					Text = "Зелье второго дыхания: 250 крон",
					function getResult( _event )
					{
						_event.m.Xitem = this.new("scripts/items/accessory/recovery_potion_item");
						_event.m.Xprice = -250;
						return "C";
					}
				},
				{
					Text = "Посмотреть что есть еще",
					function getResult( _event )
					{
						return "B2";
					}
				},
				{
					Text = "Неинтересно",
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
			ID = "B2",
			Text = "[img]gfx/ui/events/event_174.png[/img]{Маг достает свои предметы.%SPEECH_ON%Эти предметы нелегко найти в других местах.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Зелье львиного сердца: 200 крон",
					function getResult( _event )
					{
						_event.m.Xitem = this.new("scripts/items/accessory/lionheart_potion_item");
						_event.m.Xprice = -200;
						return "C";
					}
				},
				{
					Text = "Кошачье зелье: 250 крон",
					function getResult( _event )
					{
						_event.m.Xitem = this.new("scripts/items/accessory/cat_potion_item");
						_event.m.Xprice = -250;
						return "C";
					}
				},
				{
					Text = "Зелье железной воли: 200 крон",
					function getResult( _event )
					{
						_event.m.Xitem = this.new("scripts/items/accessory/iron_will_potion_item");
						_event.m.Xprice = -200;
						return "C";
					}
				},
				{
					Text = "Поводок волка: 500 крон",
					function getResult( _event )
					{
						_event.m.Xitem = this.new("scripts/items/accessory/wolf_item");
						_event.m.Xprice = -500;
						return "C";
					}
				},
				{
					Text = "Посмотреть что есть еще",
					function getResult( _event )
					{
						return "B3";
					}
				},
				{
					Text = "Неинтересно",
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
			ID = "B3",
			Text = "[img]gfx/ui/events/event_174.png[/img]{Маг достает свои предметы.%SPEECH_ON%Эти предметы нелегко найти в других местах.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Укреплённая ловчая сеть: 100 крон",
					function getResult( _event )
					{
						_event.m.Xitem = this.new("scripts/items/tools/reinforced_throwing_net");
						_event.m.Xprice = -100;
						return "C";
					}
				},
				{
					Text = "Фляга святой воды: 300 крон",
					function getResult( _event )
					{
						_event.m.Xitem = this.new("scripts/items/tools/holy_water_item");
						_event.m.Xprice = -300;
						return "C";
					}
				},
				{
					Text = "Фляга с кислотой: 300 крон",
					function getResult( _event )
					{
						_event.m.Xitem = this.new("scripts/items/tools/acid_flask_item");
						_event.m.Xprice = -300;
						return "C";
					}
				},
				{
					Text = "Если не хочешь умереть, бросай все, что имеешь, и убирайся отсюда!",
					function getResult( _event )
					{
						return "Fight1";
					}
				},
				{
					Text = "Посмотреть что есть еще",
					function getResult( _event )
					{
						return "B1";
					}
				},
				{
					Text = "Неинтересно",
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
			ID = "C",
			Text = "[img]gfx/ui/events/event_174.png[/img]{Вы и маг пришли к соглашению по поводу предметов. Обменявшись монетами и товарами, вы покидаете это место для следующих гостей.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Это была хорошая сделка",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				this.World.Assets.getStash().add(_event.m.Xitem);
				this.World.Assets.addMoney(_event.m.Xprice);
				this.List.push({
					id = 10,
					icon = "ui/items/" + _event.m.Xitem.getIcon(),
					text = "Вы получаете " + this.Const.Strings.getArticle(_event.m.Xitem.getName()) + _event.m.Xitem.getName()
				});
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Вы тратите " + (_event.m.Xprice * -1) + " крон"
				});
			}

		});
		this.m.Screens.push({
			ID = "Fight1",
			Text = "[img]gfx/ui/events/event_50.png[/img]{Выражение лица мага сморщилось от вашего запугивания.%SPEECH_ON%Как ты смеешь угрожать магу? Вы выбрали не того противника!%SPEECH_OFF%Когда маг произносит заклинание, вызывается группа монстров, а люди разбегаются с криками от ужаса.\n\n[color=#999999]От этой битвы нельзя отступать, как только она началась.[/color]}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "К оружию!",
					function getResult( _event )
					{
						this.World.Flags.set("AngryMage", 1);
						local pp = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						pp.Music = this.Const.Music.NobleTracks;
						pp.Entities = [];
						local moba;
						local mobv;
						if (this.Math.rand(1, 100) <= 50)
						{
							moba = [
								"scripts/entity/tactical/enemies/wolf",
								"scripts/entity/tactical/enemies/direwolf",
								"scripts/entity/tactical/enemies/direwolf_high",
								"scripts/entity/tactical/warwolf",
								"scripts/entity/tactical/wardog",
								"scripts/entity/tactical/warhound",
								"scripts/entity/tactical/armored_wardog",
								"scripts/entity/tactical/armored_warhound"
							];
							mobv = 7;
						}
						else
						{
							moba = [
								"scripts/entity/tactical/enemies/zombie",
								"scripts/entity/tactical/enemies/zombie_yeoman",
								"scripts/entity/tactical/enemies/xxmob_fungal_a"
							];
							mobv = 8;
						}
						for( local i = 0; i < mobv; i = ++i )
						{
							pp.Entities.push({
								ID = this.Const.EntityType.AlpShadow,
								Variant = 0,
								Row = 0,
								Script = moba[this.Math.rand(0, moba.len() - 1)],
								Faction = this.Const.Faction.Enemy
							});
							pp.Entities.push({
								ID = this.Const.EntityType.AlpShadow,
								Variant = 0,
								Row = 1,
								Script = moba[this.Math.rand(0, moba.len() - 1)],
								Faction = this.Const.Faction.Enemy
							});
							pp.Entities.push({
								ID = this.Const.EntityType.AlpShadow,
								Variant = 0,
								Row = 2,
								Script = moba[this.Math.rand(0, moba.len() - 1)],
								Faction = this.Const.Faction.Enemy
							});
						}
						pp.Entities.push({
							ID = this.Const.EntityType.AlpShadow,
							Variant = 0,
							Row = 3,
							Script = "scripts/entity/tactical/enemies/xxmob_mage",
							Faction = this.Const.Faction.Enemy
						});
						pp.BeforeDeploymentCallback = function ()
						{
							local size = this.Tactical.getMapSize();

							for( local x = 0; x < size.X; x = ++x )
							{
								for( local y = 0; y < size.Y; y = ++y )
								{
									local tile = this.Tactical.getTileSquare(x, y);
									tile.Level = this.Math.min(1, tile.Level);
									if (this.Math.rand(0, 3) != 1)
									{
										tile.removeObject();
										tile.clear();
									}
								}
							}
						};
						pp.IsFleeingProhibited = true;
						pp.IsLootingProhibited = true;
						pp.IsWithoutAmbience = true;
						_event.registerToShowAfterCombat("Victory", "Defeat");
						this.World.State.startScriptedCombat(pp, false, false, true);
						return 0;
					}
				}
			],
			function start( _event )
			{
			}
		});
		this.m.Screens.push({
			ID = "Fight2",
			Text = "[img]gfx/ui/events/event_50.png[/img]{Маг внимательно посмотрел на твое лицо, и его выражение лица ухудшилось.%SPEECH_ON%О, я знаю тебя! Это тот человек, которого искала гильдия магов с наградой! %SPEECH_OFF%Как только маг произнес свое заклинание, его союзники были мгновенно вызваны.%SPEECH_ON%За их головы назначена награда. Захватить или убить!%SPEECH_OFF%\n\n[color=#999999]От этой битвы нельзя отступать, если она началась.[/color]}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "К оружию!",
					function getResult( _event )
					{
						local pp = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						pp.Music = this.Const.Music.NobleTracks;
						pp.Entities = [];
						for( local i = 0; i < 4; i = ++i )
						{
							pp.Entities.push({
								ID = this.Const.EntityType.AlpShadow,
								Variant = 0,
								Row = 0,
								Script = "scripts/entity/tactical/humans/bounty_hunter",
								Faction = this.Const.Faction.Enemy
							});
							pp.Entities.push({
								ID = this.Const.EntityType.AlpShadow,
								Variant = 0,
								Row = 0,
								Script = "scripts/entity/tactical/humans/mercenary",
								Faction = this.Const.Faction.Enemy
							});
						}
						for( local i = 0; i < 2; i = ++i )
						{
							pp.Entities.push({
								ID = this.Const.EntityType.AlpShadow,
								Variant = 0,
								Row = 1,
								Script = "scripts/entity/tactical/enemies/xxmob_subzero",
								Faction = this.Const.Faction.Enemy
							});
							pp.Entities.push({
								ID = this.Const.EntityType.AlpShadow,
								Variant = 0,
								Row = 1,
								Script = "scripts/entity/tactical/humans/bounty_hunter_ranged",
								Faction = this.Const.Faction.Enemy
							});
							pp.Entities.push({
								ID = this.Const.EntityType.AlpShadow,
								Variant = 0,
								Row = 1,
								Script = "scripts/entity/tactical/humans/mercenary_ranged",
								Faction = this.Const.Faction.Enemy
							});
						}
						pp.Entities.push({
							ID = this.Const.EntityType.AlpShadow,
							Variant = 0,
							Row = 2,
							Script = "scripts/entity/tactical/enemies/xxmob_mage",
							Faction = this.Const.Faction.Enemy
						});
						pp.BeforeDeploymentCallback = function ()
						{
							local size = this.Tactical.getMapSize();

							for( local x = 0; x < size.X; x = ++x )
							{
								for( local y = 0; y < size.Y; y = ++y )
								{
									local tile = this.Tactical.getTileSquare(x, y);
									tile.Level = this.Math.min(1, tile.Level);
									if (this.Math.rand(0, 3) != 1)
									{
										tile.removeObject();
										tile.clear();
									}
								}
							}
						};
						pp.IsFleeingProhibited = true;
						pp.IsLootingProhibited = true;
						pp.IsWithoutAmbience = true;
						_event.registerToShowAfterCombat("Victory", "Defeat");
						this.World.State.startScriptedCombat(pp, false, false, true);
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
			Text = "[img]gfx/ui/events/event_60.png[/img]{Ожесточенная битва закончилась. Вы и ваши спутники обыскали местность в поисках ценностей. Собрав все ценности, группа решила уйти.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Давайте возьмем то, что может быть деньгами, и уйдем отсюда.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				_event.m.Title = "После битвы...";
				local xxmoney = this.Math.rand(2000, 3000);
				this.World.Assets.addMoney(xxmoney);
				this.List.push({
					id = 11,
					icon = "ui/items/supplies/money.png",
					text = "Вы получаете " + xxmoney + " золота"
				});
			}
		});
		this.m.Screens.push({
			ID = "Defeat",
			Text = "[img]gfx/ui/events/event_88.png[/img]{Ваша партия потерпела поражение и смогла сбежать.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Проклятье!",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				_event.m.Title = "После боя...";
			}
		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 50)
		{
			return;
		}

		if (this.World.Assets.getMoney() < 3000)
		{
			return;
		}

		if (this.World.Assets.getStash().getNumberOfEmptySlots() < 1)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();
		local nearTown = false;
		local towns = this.World.EntityManager.getSettlements();
		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 3)
			{
				nearTown = true;
				break;
			}
		}
		if (!nearTown)
		{
			return;
		}
		this.m.Score = 5;
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

