this.witness_true_necromancer_event <- this.inherit("scripts/events/event", {
	m = {
		Necromancer = null,
		Representative = null,
		SelectedNamed = null,
		PlayerNamed = null,
		AvailableNamed = [],
		NamedLoots = [],
		SpawnList = null,
	},
	function create()
	{
		this.m.ID = "event.witness_true_necromancer";
		this.m.Title = "В некоем месте...";
		this.m.Cooldown = 25.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "Meet",
			Text = "[img]gfx/ui/events/event_76.png[/img]На дороге из ниоткуда возникает незнакомец в плаще, приветствуя вас кривой ухмылкой.%SPEECH_ON%Приветствую вас, наёмники, и прошу уделить мне немного вашего времени. Обещаю - оно того стоит.%SPEECH_OFF%В долгой тишине вы со своими братьями с опаской рассматриваете незнакомца. Его внешность вполне нормальна для благородного дворянина, но по неведомой причине вызывает неописуемый страх. Ваш взгляд постоянно возвращается к руке незнакомца, украшенной перстнем в виде черепа, рубиновые глаза которого сверкают огнём. Наконец вы вырвались из наводящего страх молчания и начали разговор.%SPEECH_ON%Чего ты хочешь, старик?%SPEECH_OFF%Пожилой дворянин с усмешкой отвечает.%SPEECH_ON%Я простой искатель реликвий, а у вас, добрый люди, есть нужное мне.%SPEECH_OFF%В замешательстве вы уставились на него. Обычно вы рады выгодной сделке, но от этого человека веет смертью. Его слова, быть может, и приятны, но от него самого пахнет гнилью. Ваш взгляд обегает окрестности в поисках угрозы, вы не знаете, ловушка это или просто недоразумение. Старик радушно усмехается, после чего произносит.%SPEECH_ON%Не нужно подозрений, добрый люди, я не ищу схватки - лишь торговли%SPEECH_OFF%Вместе с братьями вы наблюдаете за тем, как дворянин вытаскивает несколько больших предметов из маленького мешочка, завязанного на бедре, который никак не мог их вместить.%SPEECH_ON%Что это за трюк!%SPEECH_OFF%Старик не произносит ни слова, но самодовольная ухмылка на его лице говорит о многом. Показанные вам вещи выглядят шедеврами, а мастерство их изготовления - непревзойдённым. Пока вы со своими людьми алчно рассматриваете их, один из ваших братьев шепчет вам на ухо. %SPEECH_ON%Эти вещи выглядят очень дорого, командир, быть может просто зарежем дворянина и заберём их все? %SPEECH_OFF%Мысль привлекательная, но все же запах смерти, исходящий от предполагаемого дворянина, говорит о том, что лучше всего проявить осторожность.",
			Image = "",
			List = [],
			Characters = [],
			Banner = [],
			Options = [
				{
					Text = "Конечно! Посмотрим, что ты можешь предложить.",
					function getResult( _event )
					{
						return "Trade";
					}

				},
				/*
				{
					Text = "Предлагаю более выгодную сделку. Отдавай-ка все свои ценности!",
					function getResult( _event )
					{
						return "Rob";
					}

				},
				*/
				{
					Text = "Это прекрасное предложение. Но я вынуждена отказаться.",
					function getResult( _event )
					{
						return 0;
					}

				},
				
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Representative.getImagePath());
				this.Characters.push(_event.m.Necromancer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Trade",
			Text = "Широко улыбаясь, старик говорит.%SPEECH_ON%Чудесно! Вот, смотри и выбирай! Ты можешь выбрать один из них, а взамен я заберу ваш %item%. Справедливый обмен, не так ли?%SPEECH_OFF%Все эти предметы удивительны, но и %item% тоже, и вы задаетесь вопросом, действительно ли он стоит этой сделки. Не говоря уже о том, что вы сомневаетесь, можно ли доверять человеку, от которого несёт смертью, а ведь по его взгляду на %item% очевидно, что он действительно жаждет его получить.",
			Image = "",
			List = [],
			Characters = [],
			Banner = [],
			Options = [],
			function start( _event )
			{
				this.Characters.push(_event.m.Representative.getImagePath());
				this.Characters.push(_event.m.Necromancer.getImagePath());
				
				this.List.extend([
					{
						id = 1,
						//icon = "ui/icons/dub.png",
						text = "[color=" + this.Const.UI.Color.DamageValue + "]--- Обменяйте свой ---[/color]"
					},
					{
						id = 2,
						icon = "ui/items/" + _event.m.PlayerNamed.getIcon(),
						text = _event.m.PlayerNamed.getName()
					},
					{
						id = 3,
						//icon = "ui/icons/dub.png",
						text = "[color=" + this.Const.UI.Color.DamageValue + "]--- На один из этих ---[/color]"
					},
				]);
				
				local quotes = [
					"Давай обменяемся на ",
					"Я возьму ",
					"Безусловно ",
				];

				foreach(i, item in _event.m.AvailableNamed)
				{
					this.Options.push({
						Index = i,
						Text = ::MSU.Array.rand(quotes) + item.getName(),
						function getResult( _event )
						{
							_event.m.SelectedNamed = _event.m.AvailableNamed[this.Index];
							return "FinishTrade";
						}
					});

					this.List.extend([
						{
							id = 4 + i,
							icon = "ui/items/" + item.getIcon(),
							text = item.getName() + " (" + (::MSU.isKindOf(item, "weapon") ? item.m.Categories : "Shield") + ")"
						},
						{
							id = 1,
							//icon = "ui/icons/dub.png",
							text = ""
						},
					]);
				}
				
				this.Options.push({
					Text = "Я передумала.",
					function getResult( _event )
					{
						return "Meet";
					}

				});
				
			}

		});
		this.m.Screens.push({
			ID = "FinishTrade",
			Text = "[img]gfx/ui/events/event_76.png[/img]Вы получаете выбранное, а взамен старик забирает ваш %item%. Несколько мгновений вы ожидаете ловушки или какого-нибудь проклятия, но, к некоторому разочарованию, все проходит гладко. Быть может, это излишняя осторожность, он кажется лишь дружелюбным стариком. Старик радостно говорит.%SPEECH_ON%Истинное удовольствие иметь с вами дело, наёмники! Внезапный порыв верта ослепляет вас и ваш отряд, а когда зрение проясняется, вы уже стоите в одиночестве, без каких-либо следов старика, но с новым товаром в руках.",
			Image = "",
			List = [],
			Characters = [],
			Banner = [],
			Options = [
				{
					Text = "Прощай!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local yourItem = _event.m.PlayerNamed;
				local tradeItem = _event.m.SelectedNamed;
				
				this.Characters.push(_event.m.Representative.getImagePath());
				this.Characters.push(_event.m.Necromancer.getImagePath());
				this.World.Assets.getStash().remove(yourItem);
				this.World.Assets.getStash().add(tradeItem);
				this.List.extend([
					{
						id = 10,
						icon = "ui/items/" + tradeItem.getIcon(),
						text = "Вы [color=" + this.Const.UI.Color.DamageValue + "]получаете[/color] " + tradeItem.getName()
					},
					{
						id = 1,
						//icon = "ui/icons/dub.png",
						text = ""
					},
					{
						id = 1,
						//icon = "ui/icons/dub.png",
						text = ""
					},
					{
						id = 11,
						icon = "ui/items/" + yourItem.getIcon(),
						text = "Вы [color=" + this.Const.UI.Color.DamageValue + "]теряете[/color] " + yourItem.getName()
					},
				]);				
			}

		});
		
		this.m.Screens.push({
			ID = "Rob",
			Text = "[img]gfx/ui/events/event_29.png[/img]Старик хохочет, словно услышав шутку.%SPEECH_ON%Пожалуй, твоё истинное в роли наёмника - веселить окружающих. Ты действительно величайший шут, виденный в моей жизни, раз предлагаешь такую нелепость. В любом случае - продолжим же это выступление! Если вам так будет удобнее, можете напасть все сразу. Не хотел бы, чтобы происходящее было нечестным. %SPEECH_OFF%Ваши глаза округляются - не такие слова вы ожидали услышать от старика. Вам доводилось видеть умелое притворство, но здесь происходит что-то иное, от старик излучает странную уверенность в себе. Подтверждая опасения, один из ваших людей указывает на четыре тени, появившиеся вдалеке. По вашему хребту пробегает холодок, словно подул ледяной ветер. Вы начинаете жалеть об своём решении.",
			Image = "",
			List = [],
			Characters = [],
			Banner = [],
			Options = [
				{
					Text = "Во что мы ввязались!",
					function getResult( _event )
					{
						local properties = this.World.State.getLocalCombatProperties(this.World.State.getPlayer().getPos());
						properties.CombatID = "Event";
						properties.Music = this.Const.Music.UndeadTracks;
						properties.PlayerDeploymentType = this.Const.Tactical.DeploymentType.Line;
						properties.EnemyDeploymentType = this.Const.Tactical.DeploymentType.Line;
						properties.Loot = [];
						properties.Loot.extend(_event.m.NamedLoots);
						properties.Loot.extend(_event.onPrepareRewards());
						properties.Entities = [];
						properties.Entities.push(clone _event.m.SpawnList.Necromancer);
						properties.Entities.push(clone _event.m.SpawnList.SwordSaint);
						properties.Entities.push(clone _event.m.SpawnList.SwordSaint);
						properties.Entities.push(clone _event.m.SpawnList.Wraith);
						properties.Entities.push(clone _event.m.SpawnList.Wraith);

						local f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID();

						for( local i = 0; i < properties.Entities.len(); i = ++i )
						{
							properties.Entities[i].Faction <- f;
						}
						
						this.World.State.startScriptedCombat(properties, false, false, true);
						return 0;
					}
				},
				{
					Text = "Прости меня! Это была безвкусная шутка.",
					function getResult( _event )
					{
						return 0;
					}

				},
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Representative.getImagePath());
				this.Characters.push(_event.m.Necromancer.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (::World.getTime().Days < 50)
			return;
		
		local count = 0;
		
		foreach ( _item in ::World.Assets.getStash().getItems() )
		{
			if (_item == null)
				continue;
			
			if (!_item.isItemType(this.Const.Items.ItemType.Named))
				continue;
			
			if (_item.isItemType(this.Const.Items.ItemType.Weapon) || _item.isItemType(this.Const.Items.ItemType.Shield))
				++count;
		}

		if (count <= 0)
			return;

		local score = 25 * count, diff = ::World.getTime().Days - ::World.Statistics.getFlags().getAsInt("MeetNamedTrader");

		if (diff <= 30)
			score = ::Math.max(0, score - 15 * diff);

		this.m.Score = score;
	}

	function onPrepare()
	{
		local NamedItems = [];
		
		foreach ( _item in ::World.Assets.getStash().getItems() )
		{
			if (_item == null)
				continue;
			
			if (!_item.isItemType(this.Const.Items.ItemType.Named))
				continue;
			
			if (_item.isItemType(this.Const.Items.ItemType.Weapon) || _item.isItemType(this.Const.Items.ItemType.Shield))
				NamedItems.push(_item);
		}
		
		this.m.PlayerNamed = NamedItems[this.Math.rand(0, NamedItems.len() - 1)];
		
		local scriptFiles = this.IO.enumerateFiles(this.isKindOf(this.m.PlayerNamed, "weapon") ? "scripts/items/weapons/named/" : "scripts/items/shields/named/");
		local selectedScripts = [];
		local s;
		scriptFiles.remove(scriptFiles.find(this.isKindOf(this.m.PlayerNamed, "weapon") ? "scripts/items/weapons/named/named_weapon" : "scripts/items/shields/named/named_shield"));
		
		while (selectedScripts.len() < 5)
		{
			s = scriptFiles[this.Math.rand(0, scriptFiles.len() - 1)];
			selectedScripts.push(s);
		}
		
		foreach ( script in selectedScripts )
		{
			local _i = this.new(script);
			_i.onAddedToStash(null);
			this.m.AvailableNamed.push(_i);
			this.m.NamedLoots.push(script);
		}
		
		for ( local i = 0; i < 4; i = ++i )
		{
			this.m.NamedLoots.push(scriptFiles[this.Math.rand(0, scriptFiles.len() - 1)]);
		}
		
		local roster = this.World.getTemporaryRoster();
		local brothers = this.World.getPlayerRoster().getAll();
		local candidate;

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				candidate = bro;
				break;
			}
		}
		
		if (candidate == null)
			candidate = brothers[this.Math.rand(0, brothers.len() - 1)];
		
		this.m.Representative = candidate;
		this.m.Necromancer = roster.create("scripts/entity/tactical/enemies/true_necromancer");
		this.m.Necromancer.assignRandomEquipment();
		/*
		this.m.SpawnList = {
			Necromancer = {
				ID = this.Const.EntityType.Necromancer,
				Variant = 0,
				Strength = 999999999,
				Cost = 10,
				Row = 3,
				Script = "scripts/entity/tactical/enemies/true_necromancer",
			},
			SwordSaint = {
				ID = this.Const.EntityType.ZombieBetrayer,
				Variant = 0,
				Strength = 50000,
				Cost = 10,
				Row = 0,
				Script = "scripts/entity/tactical/enemies/zombie_swordsaint",
			},
			Wraith = {
				ID = this.Const.EntityType.Ghost,
				Variant = 0,
				Strength = 10000,
				Cost = 10,
				Row = 2,
				Script = "scripts/entity/tactical/enemies/wraith",
			},
		};
		*/

		::World.Statistics.getFlags().set("MeetNamedTrader", ::World.getTime().Days);
	}

	function onPrepareRewards()
	{
		local ret = [];
		local num = this.Math.rand(2, 7);

		for (local i = 0; i < num; i++) 
		{
		    ret.push("scripts/items/misc/legend_ancient_scroll_item");
		}

		local potions = [
			"cat_potion_item",
			"cat_potion_item",
			"iron_will_potion_item",
			"iron_will_potion_item",
			"recovery_potion_item",
			"recovery_potion_item",
			"lionheart_potion_item",
			"lionheart_potion_item",
			"night_vision_elixir_item",
			"night_vision_elixir_item",
			"legend_heartwood_sap_flask_item",
			"legend_hexen_ichor_potion_item",
			"legend_skin_ghoul_blood_flask_item",
			"legend_stollwurm_blood_flask_item",
		];

		for (local i = 0; i < 3; i++) 
		{
		    ret.push("scripts/items/accessory/" + potions[this.Math.rand(0, potions.len() - 1)]);
		}

		ret.push("scripts/items/loot/ornate_tome_item");
		ret.push("scripts/items/special/fountain_of_youth_item");
		ret.push("scripts/items/special/trade_jug_01_item");
		return ret;
	}
	
	function onDetermineStartScreen()
	{
		return "Meet";
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"leader",
			this.m.Representative.getName()
		]);
		
		_vars.push([
			"me",
			this.m.Necromancer.getName()
		]);
		
		_vars.push([
			"item",
			this.m.PlayerNamed.getName()
		]);
	}

	function onClear()
	{
		this.m.Necromancer = null;
		this.m.Representative = null;
		this.m.SpawnList = null;
		this.m.PlayerNamed = null;
		this.m.SelectedNamed = null;
		this.m.AvailableNamed = [];
		this.m.NamedLoots = [];
		this.World.getTemporaryRoster().clear();
	}

});

