// Событие входа в легендарную локацию «Гнездо Рогатой Крысы».
this.rat_god_camp_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.rat_god_camp_enter";
		this.m.Title = "По мере приближения...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;

		this.m.Screens.push({
			ID = "Start",
			Text = "[img]gfx/ui/events/rat_event_10.png[/img]{Лагерь открывается вашему взору целиком, едва отряд поднимается на гребень последнего холма. Это не просто стоянка, а два огромных стана, разбитых вплотную друг к другу. Северную сторону занимают варвары — грубые шатры из невыделанных шкур, тотемы из выбеленных костей, густой дым множества костров и рослые фигуры дикарей в рогатых шлемах. Восточную же часть захватили скавены: горы вонючего хлама, тошнотворный смрад гнили, непрерывный лязг железа и пронзительный писк, доносящийся даже сюда, а также юркие сгорбленные тени, снующие меж нагромождений краденых тюков и разбитых повозок.\n\nВаш взгляд невольно цепляется за две зловещие фигуры. В варварском стане, у самого главного костра, возвышается исполин — на голову выше любого из соплеменников. Он закован в шипастый доспех, отливающий болезненным зеленоватым свечением — диковинный металл инородной, явно не человеческой ковки. В лагере скавенов, на грубом алтаре из черепов, замерла другая тварь — рогатая, сутулая, с вытянутой крысиной мордой. Варвары и крысолюди по очереди склоняются перед ней, принося кровавые дары. Вожди обоих племён переговариваются через пламя костров, сбивают дикарей и крыс в единые боевые отряды и сверяют планы по расстеленной на земле медвежьей шкуре. Это не обычный привал — здесь собирается великий поход. Пока орда не набрала полную силу, пока её основные полчища ещё не выползли из подземных нор, у вас есть шанс нанести стремительный удар и разом обезглавить это нечестивое сборище.}",

			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "В атаку!",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						return _event.startBattle();
					}
				},
				{
					Text = "Такой лагерь штурмовать без подготовки — самоубийство. Отойдём.",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
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
			ID = "Victory",
			Text = "[img]gfx/ui/events/rat_event_08.png[/img]{Лагерь мёртв. Последние уцелевшие скавены в панике бросились обратно в свои норы, но ваши люди уже завалили выходы камнями и телами павших — никто из забившихся во тьму тварей больше не выберется наружу. Северяне, отрёкшиеся от рода людского, лежат в грязи вперемешку с крысолюдами, которым продали свои души. Их нечестивый поход закончился, едва успев начаться.\n\nВы стоите посреди разгромленного стойбища. Густой дым догорающих костров всё ещё тянется к серому небу, у подножия опрокинутого костяного идола валяются брошенные подношения, а прямо у главного кострища лежит тяжёлый шипастый доспех из варп-камня, содранный с трупа исполина-чемпиона. Металл глухо звенит под пальцами — вещь живая, злобная, и она послужит лишь тому, кто осмелится её носить.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Достойная цена за достойную битву.",
					function getResult( _event )
					{
						return 0;
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
			ID = "Defeat",
			Text = "[img]gfx/ui/events/rat_event_11.png[/img]{Отступление стремительно превращается в бегство, а бегство — в настоящую бойню. Озверевшие скавены вперемешку с отрёкшимися варварами гонят вас по пятам до самой кромки леса, и лишь спасительный мрак чащи укрывает израненные остатки отряда от преследования. Где-то за спиной, в низине у вражеского лагеря, вспыхивают всё новые костры — к орде продолжают стекаться подкрепления. Время играет против вас. Один из братьев произносит.%SPEECH_ON%Нам нужно больше людей. Или меньше совести — чтобы нанять их, что бы сюда вернуться.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Мы ещё вернёмся.",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				_event.m.Title = "После битвы...";

				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(false);
				}
			}
		});
	}

	// Экипировка чемпиона варваров и эффект первой стадии Повелителя тварей.
	// Инстансы создаются ЗДЕСЬ (метод инстанса события): в getResult и в
	// callback'ах CombatInfo this.new недоступен — захватываем локалами.
	function createChampionGear()
	{
		return {
			NamedWeapon = this.new("scripts/items/" + this.Const.Items.NamedBarbarianWeapons[this.Math.rand(0, this.Const.Items.NamedBarbarianWeapons.len() - 1)]),
			Helmet = this.new("scripts/items/helmets/warp_shard_helmet"),
			Armor = this.new("scripts/items/armor/warp_shard_armor_01")
		};
	}

	function startBattle()
	{
		local p = this.Const.Tactical.CombatInfo.getClone();
		p.LocationTemplate = clone this.Const.Tactical.LocationTemplate;
		p.CombatID = "RatGodCamp";
		p.TerrainTemplate = "tactical.plains";
		p.LocationTemplate.Template[0] = "tactical.rat_camp";
		p.Music = this.Const.Music.RatTracks;
		p.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Custom;
		p.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Center;
		p.IsWithoutAmbience = true;
		p.Entities = [];

		local location = this.World.State.getLastLocation();
		local f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Rat).getID();
		location.setFaction(f);
		p.Parties.push(location);

		local gear = this.createChampionGear();
		local godEffect = this.new("scripts/skills/effects/rat_god_reincarnation_effect");

		// варвары — север; скавены — восток. Координаты квадратные
		// (getTileSquare). Спавним с fallback'ом: занятый тайл → свободный
		// сосед из зоны (паттерн сбора площадок — khan enter event).
		p.BeforeDeploymentCallback = function ()
		{
			local function freeTileIn( _x, _y, _x0, _x1, _y0, _y1 )
			{
				local tile = this.Tactical.getTileSquare(_x, _y);

				if (tile.IsEmpty && !tile.IsOccupiedByActor && !tile.IsSpecialTerrain && tile.Level == 0)
				{
					return tile;
				}

				local spots = [];

				for (local x = _x0; x <= _x1; x = ++x)
				{
					for (local y = _y0; y <= _y1; y = ++y)
					{
						if (!this.Tactical.isValidTileSquare(x, y))
						{
							continue;
						}

						local t = this.Tactical.getTileSquare(x, y);

						if (t.IsEmpty && !t.IsOccupiedByActor && !t.IsSpecialTerrain && t.Level == 0)
						{
							spots.push(t);
						}
					}
				}

				if (spots.len() == 0)
				{
					return null;
				}

				return spots[this.Math.rand(0, spots.len() - 1)];
			}

			local function spawnAt( _script, _x, _y, _x0, _x1, _y0, _y1 )
			{
				local tile = freeTileIn(_x, _y, _x0, _x1, _y0, _y1);

				if (tile == null)
				{
					return null;
				}

				local e = this.Tactical.spawnEntity(_script, tile.Coords);
				e.setFaction(f);
				e.assignRandomEquipment();
				return e;
			}

			// ---- варвары, север (x 4..13, y 3..8) ----
			local champion = spawnAt("scripts/entity/tactical/humans/barbarian_champion", 9, 5, 4, 13, 3, 8);

			if (champion != null)
			{
				// именное варварское оружие + шлем и доспех из варп-осколков.
				// Выпадение в 0 прочности гарантирует флаг ItemType.Named:
				// armor.nut/helmet.nut режут isDroppedAsLoot по прочности,
				// но для Named-вещей врага условия нет
				local mainhand = champion.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

				if (mainhand != null)
				{
					mainhand.removeSelf();
				}

				local offhand = champion.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);

				if (offhand != null)
				{
					offhand.removeSelf();
				}

				local head = champion.getItems().getItemAtSlot(this.Const.ItemSlot.Head);

				if (head != null)
				{
					head.removeSelf();
				}

				local body = champion.getItems().getItemAtSlot(this.Const.ItemSlot.Body);

				if (body != null)
				{
					body.removeSelf();
				}

				champion.getItems().equip(gear.NamedWeapon);
				champion.getItems().equip(gear.Helmet);
				champion.getItems().equip(gear.Armor);
				champion.setName(this.Const.Strings.BarbarianNames[this.Math.rand(0, this.Const.Strings.BarbarianNames.len() - 1)]);
			}

			spawnAt("scripts/entity/tactical/humans/barbarian_champion", 6, 4, 4, 13, 3, 8);
			spawnAt("scripts/entity/tactical/humans/barbarian_champion", 12, 4, 4, 13, 3, 8);
			spawnAt("scripts/entity/tactical/humans/barbarian_champion", 7, 7, 4, 13, 3, 8);
			spawnAt("scripts/entity/tactical/humans/barbarian_champion", 11, 7, 4, 13, 3, 8);
			spawnAt("scripts/entity/tactical/humans/barbarian_drummer", 9, 8, 4, 13, 3, 9);
			spawnAt("scripts/entity/tactical/humans/barbarian_marauder", 5, 5, 4, 13, 3, 9);
			spawnAt("scripts/entity/tactical/humans/barbarian_marauder", 5, 7, 4, 13, 3, 9);
			spawnAt("scripts/entity/tactical/humans/barbarian_marauder", 13, 5, 4, 13, 3, 9);
			spawnAt("scripts/entity/tactical/humans/barbarian_marauder", 13, 7, 4, 13, 3, 9);

			// ---- скавены, восток (x 23..30, y 6..22) ----
			local god = spawnAt("scripts/entity/tactical/enemies/rat_god_01", 27, 13, 23, 30, 6, 22);

			if (god != null)
			{
				// после гибели — подкрепление со следующей стадией (rat_god_02 → 03)
				god.getSkills().add(godEffect);
			}

			spawnAt("scripts/entity/tactical/enemies/rat_warlord", 24, 9, 23, 30, 6, 22);
			spawnAt("scripts/entity/tactical/enemies/rat_greyseer", 24, 17, 23, 30, 6, 22);
			spawnAt("scripts/entity/tactical/enemies/rat_banner_men", 25, 13, 23, 30, 6, 22);
			spawnAt("scripts/entity/tactical/enemies/rat_warrior", 26, 8, 23, 30, 6, 22);
			spawnAt("scripts/entity/tactical/enemies/rat_warrior", 26, 10, 23, 30, 6, 22);
			spawnAt("scripts/entity/tactical/enemies/rat_warrior", 26, 16, 23, 30, 6, 22);
			spawnAt("scripts/entity/tactical/enemies/rat_warrior", 26, 18, 23, 30, 6, 22);
			spawnAt("scripts/entity/tactical/enemies/rat_clanrat", 25, 11, 23, 30, 6, 22);
			spawnAt("scripts/entity/tactical/enemies/rat_clanrat", 25, 15, 23, 30, 6, 22);
			spawnAt("scripts/entity/tactical/enemies/rat_clanrat", 28, 11, 23, 30, 6, 22);
			spawnAt("scripts/entity/tactical/enemies/rat_clanrat", 28, 15, 23, 30, 6, 22);
			spawnAt("scripts/entity/tactical/enemies/rat_monk", 24, 13, 23, 30, 6, 22);
			spawnAt("scripts/entity/tactical/enemies/rat_packmaster", 29, 13, 23, 30, 6, 22);
		};

		p.AfterDeploymentCallback = function ()
		{
			// высадка отряда у южного края, паттерн tutorial_contract:
			// addEntityToMap принимает ГЕКСОВЫЕ координаты (y - x/2)
			local bros = this.World.getPlayerRoster().getAll();
			local spots = [];
			local function gatherSpots( _x0, _x1, _y0, _y1 )
			{
				for (local x = _x0; x <= _x1; x = ++x)
				{
					for (local y = _y0; y <= _y1; y = ++y)
					{
						if (!this.Tactical.isValidTileSquare(x, y))
						{
							continue;
						}

						local tile = this.Tactical.getTileSquare(x, y);

						if (!tile.IsEmpty || tile.IsOccupiedByActor)
						{
							continue;
						}

						if (tile.IsSpecialTerrain || tile.Level != 0)
						{
							continue;
						}

						local dup = false;

						foreach (s in spots)
						{
							if (s.ID == tile.ID)
							{
								dup = true;
								break;
							}
						}

						if (!dup)
						{
							spots.push(tile);
						}
					}
				}
			}
			gatherSpots(10, 15, 24, 29);

			if (spots.len() < this.World.Assets.getBrothersMaxInCombat())
			{
				gatherSpots(8, 17, 22, 30);
			}

			local num = 0;

			foreach (bro in bros)
			{
				if (spots.len() == 0)
				{
					break;
				}

				local idx = this.Math.rand(0, spots.len() - 1);
				local spot = spots[idx];
				spots.remove(idx);
				this.Tactical.addEntityToMap(bro, spot.SquareCoords.X, spot.SquareCoords.Y - spot.SquareCoords.X / 2);
				num = ++num;

				if (num >= this.World.Assets.getBrothersMaxInCombat())
				{
					break;
				}
			}

			local clouds = this.Tactical.getWeather().createCloudSettings();
			clouds.Type = this.getconsttable().CloudType.Fog;
			clouds.MinClouds = 15;
			clouds.MaxClouds = 15;
			clouds.MinVelocity = 3.0;
			clouds.MaxVelocity = 9.0;
			clouds.MinAlpha = 0.25;
			clouds.MaxAlpha = 0.35;
			clouds.MinScale = 2.0;
			clouds.MaxScale = 3.0;
			this.Tactical.getWeather().buildCloudCover(clouds);
			this.Tactical.getWeather().setAmbientLightingPreset(5);
			this.Tactical.getWeather().setAmbientLightingSaturation(0.9);
		};

		this.registerToShowAfterCombat("Victory", "Defeat");
		this.World.State.startScriptedCombat(p, false, false, false);
		return 0;
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
