this.nggh_mod_hexe_origin_ritual_event <- ::inherit("scripts/events/event", {
	m = {
		Hexe = null,
		Town = null,

		// ambush factors
		AmbushChance = 5,
		DifficultyMult = 0.0,
		DifficultyMultScale = 0.0,
		ChampionChance = 0,
		ResourceBoost = 0,

		// processing ritual
		IsSucceed = false,
		ChosenItems = [],
		Offerings = [],
		Simps = [],
		Money = 0,
	},
	function getAmbushChance()
	{
		return this.m.AmbushChance;
	}

	function isAmbushed()
	{
		local rolled = ::Math.rand(1, 100);

		if (rolled > this.getAmbushChance())
		{
			::logInfo("Ритуал ведьмы - Сегодня нет атаки из засады (шанс: " + this.getAmbushChance() + ", выпало: " + rolled + ")");
			return false;
		}

		::logInfo("Ритуал ведьмы - Время засады!!! (шанс: " + this.getAmbushChance() + ", выпало: " + rolled + ")");
		return true;
	}

	function create()
	{
		this.m.ID = "event.hexe_origin_ritual";
		this.m.Title = "В некоем месте...";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_36.png[/img]%hexe% заканчивает подготовку к жертвоприношению. Её слуги выстраиваются рядом, для начала ритуала остаётся лишь произнести заклинание.\n\nВо время произнесения нечестивых строк порыв чистой черноты поглощает и вас и ваших рабов. Это происходит столь быстро, но подношения тут же исчезают в чёрной пустоте. И тут сзади послышался шёпот %SPEECH_ON%Твои подношения радуют меня...%SPEECH_OFF%%hexe% испускает вздох облегчения. Так вот что нужно делать каждую неделю... Стоит ли такая цена вечной красоты и могущества?",
			Image = "",
			List = [],
			Characters = [],
			Banner = [],
			Options = [
				{
					Text = "Цена, что должно платить.",
					function getResult( _event )
					{
						if (_event.m.ChosenItems.len() != 0)
						{
							return "LevelupSimp";
						}

						if (_event.isAmbushed())
						{
							
							return "Ambush";
						}

						return 0;
					}

				},
				
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Hexe.getImagePath());
				
				if (_event.m.Money != 0)
				{
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Вы жертвуете [color=" + ::Const.UI.Color.NegativeEventValue + "]" + _event.m.Money + "[/color] крон"
					});
					
					::World.Assets.addMoney(-_event.m.Money);
				}
				
				local Stash = ::World.Assets.getStash();
				
				foreach ( _item in _event.m.Offerings )
				{	
					this.List.push({
						id = 4,
						icon = "ui/items/" + _item.getIcon(),
						text = "Вы жертвуете " + _item.getName()
					});
					
					Stash.remove(_item);
				}
				
				if (::World.Flags.get("isExposed"))
				{
					this.List.push({
						id = 10,
						icon = "skills/status_effect_49.png",
						text = _event.m.Hexe.getName() + " освобождается от проклятия"
					});
					
					_event.m.Hexe.improveMood(6.0, "Проклятие снято. Я вновь обрела свою красоту");
					this.List.push({
						id = 10,
						icon = ::Const.MoodStateIcon[_event.m.Hexe.getMoodState()],
						text = _event.m.Hexe.getName() + ::Const.MoodStateEvent[_event.m.Hexe.getMoodState()]
					});
					
					_event.m.Hexe.getFlags().remove("isCursed");
					_event.m.Hexe.getSkills().removeByID("effects.cursed");
					_event.m.Hexe.getSkills().removeByID("effects.cursed_badly");
					::World.Flags.set("looks", ::Math.rand(9995, 9997));
					::World.Flags.set("isExposed", false);
					::World.Assets.updateLook();

					foreach ( bro in ::World.getPlayerRoster().getAll() )
					{
						local skill = bro.getSkills().getSkillByID("effects.simp");

						if (skill == null)
						{
							continue;
						}

						if (!bro.getFlags().get("isCursed"))
						{
							continue;
						}

						if (::Math.rand(1, 100) <= 66)
						{
							skill.gainSimpLevel();

							this.List.push({
								id = 10,
								icon = bro.getBackground().getIcon(),
								text = bro.getNameOnly() + " восстанавливает утраченный уровень простака"
							});
						}

						bro.getFlags().set("isCursed", false);
					}

					return;
				}
				
				local effect = ::new("scripts/skills/effects_world/nggh_mod_blessed_effect");
				_event.m.Hexe.improveMood(1.0, "Благословлён");
				_event.m.Hexe.getSkills().add(effect);

				this.List.extend([
					{
						id = 10,
						icon = "skills/status_effect_73.png",
						text = _event.m.Hexe.getName() + " наделена силой"
					},
					{
						id = 10,
						icon = ::Const.MoodStateIcon[_event.m.Hexe.getMoodState()],
						text = _event.m.Hexe.getName() + ::Const.MoodStateEvent[_event.m.Hexe.getMoodState()]
					}
				]);
			}

		});
		
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_12.png[/img]%hexe% поспешно заканчивает подготовку к подношениям, но все идет не так, как надо. У %hexe% возникает ощущение, что она собрала недостаточно подношений для ритуала. Она думает о том, что может случиться, если она вызовет гнев своего хозяина.\n\nВдруг подул черный ветер. По ее позвоночнику пробегает холодок, сначала она слышит шепот в своем сознании, но через мгновение шепот превращается в крики ярости. %SPEECH_ON%Такое жалкое подношение, ты смеешь думать, что это достойно моего внимания! %SPEECH_OFF%По всему телу %hexe% чувствуется боль, она кричит от агонии. %hexe% чувствует, как ее ложная молодость отрывается от нее, наблюдая, как ее руки морщатся и быстро стареют. Даже ее собственная сила становится все слабее и слабее. %hexe% ломается и просит прощения, она желает, чтобы ее бог пожалел ее и дал ей еще один шанс.%SPEECH_ON%Следующего раза не будет. В следующий раз я жду достойного подношения. Если ты подведешь меня, смерть будет благословением, когда я покончу с тобой. %SPEECH_OFF% Все еще дрожа, %hexe% заставляет себя встать. Ее истинная форма была раскрыта, а ее сила истощена, поэтому собирать подношения будет немного труднее, но у нее нет другого выбора. Она должна собрать больше подношений, иначе ее ждут вечные муки.",
			Image = "",
			List = [],
			Characters = [],
			Banner = [],
			Options = [
				{
					Text = "Нет! Этого не может быть.",
					function getResult( _event )
					{
						if (_event.isAmbushed())
						{
							return "Ambush";
						}

						return 0;
					}

				},
				
			],
			function start( _event )
			{
				local effect = ::new("scripts/skills/effects_world/nggh_mod_world_cursed_badly_effect");
				local Factions = [];
				local FactionIDs = [];
				local RelationShips = [];
				Factions.extend(::World.FactionManager.getFactionsOfType(::Const.FactionType.NobleHouse));
				Factions.extend(::World.FactionManager.getFactionsOfType(::Const.FactionType.Settlement));
				
				foreach ( f in Factions )
				{
					FactionIDs.push(f.getID());
					RelationShips.push(f.getPlayerRelation());
				}
				
				effect.m.Factions = FactionIDs;
				effect.m.PlayerRelations = RelationShips;
				_event.m.Hexe.worsenMood(3.0, "Проклята за жалкое подношение");
				_event.m.Hexe.getSkills().add(effect);

				if (::Nggh_MagicConcept.Mod.ModSettings.getSetting("ritual_lose_level").getValue())
				{
					foreach ( bro in ::World.getPlayerRoster().getAll() )
					{
						local skill = bro.getSkills().getSkillByID("effects.simp");

						if (skill == null)
						{
							continue;
						}

						if (skill.getSimpLevel() <= 0)
						{
							continue;
						}

						_event.decreaseSimpLevel(bro);
					}
				}

				::World.FactionManager.makeNoblesUnfriendlyToPlayer();
				::World.FactionManager.makeSettlementsUnfriendlyToPlayer();
				::World.Flags.add("isExposed", true);
				::World.Assets.updateLook();

				this.List.extend([
					{
						id = 10,
						icon = effect.getIcon(),
						text = _event.m.Hexe.getName() + " проклята"
					},
					{
						id = 10,
						icon = ::Const.MoodStateIcon[_event.m.Hexe.getMoodState()],
						text = _event.m.Hexe.getName() + ::Const.MoodStateEvent[_event.m.Hexe.getMoodState()]
					}
				]);

				this.Characters.push(_event.m.Hexe.getImagePath());
			}

		});

		this.m.Screens.push({
			ID = "LevelupSimp",
			Text = "[img]gfx/ui/events/event_140.png[/img] В дополнение к благословению вы можете предложить ещё подношений, дабы один из ваших последователей получил дар силы. Каков будет ваш ответ? И кого вы выберете?",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Быть может позже.",
					function getResult( _event )
					{
						if (_event.isAmbushed())
						{
							return "Ambush";
						}

						return 0;
					}

				},
			],
			function start( _event )
			{
				foreach (i, s in _event.m.Simps)
				{
					this.Options.push({
						Actor = s,
						Text = s.getName() + " - " + s.getSkills().getSkillByID("effects.simp").getName(),
						function getResult( _e )
						{
							::logInfo("Ритуал ведьмы - выбрать этот параметр: '" + this.Text + "'");
							_e.increaseSimpLevel(this.Actor);
							_e.consumeChosenItems();

							if (_e.isAmbushed())
							{
								return "Ambush";
							}

							return 0;
						}

					});

					this.Characters.push(s.getImagePath());
				}

				this.List.push({
					id = 1,
					icon = "ui/icons/dub.png",
					text = "[color=" + ::Const.UI.Color.DamageValue + "]--- Востребованные предложения ---[/color]"
				});

				foreach (item in _event.m.ChosenItems)
				{
					this.List.push({
						id = 1,
						icon = "ui/items/" + item.getIcon(),
						text = item.getName()
					});
				}
			}

		});

		this.m.Screens.push({
			ID = "Ambush",
			Text = "[img]gfx/ui/events/event_43.png[/img]%SPEECH_START%Вот оно! Мы застигли тебя на месте преступления, ведьма! Сжечь её! Повесить её! Не дайте ей принести свое злое проклятие в наш город.%SPEECH_OFF%Кричит незнакомец.\n\nВооружённые люди начинают окружать вас со всех сторон - должно быть, это охотники за ведьмами, нанятые городом %town%. %hexe% молча думает.%SPEECH_ON%Эти ублюдки точно хотят моей смерти - им это даже нравится. Временно.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "К оружию!",
					function getResult( _event )
					{
						_event.spawnWitchHunterParty(::World.State.getPlayer().getTile());
						return 0;
					}

				},
			],
			function start( _event )
			{
			}

		});
	}

	function onPrepare()
	{
		this.calcDifficultyMult();
		this.m.ResourceBoost = this.calcResourceBoost();
		this.m.DifficultyMultScale = this.getScaledDifficultyMult();
		local brothers = ::World.getPlayerRoster().getAll();
		
		foreach (bro in brothers)
		{
			if (!bro.getFlags().has("isBonus") && bro.getFlags().has("Hexe"))
			{
				this.m.Hexe = bro;
				break;
			}
		}
		
		local days = ::World.getTime().Days;
		local modifier = this.getModifier(days);
		local randomness = ::Math.rand(::Nggh_MagicConcept.HexeOriginRitual.RandomizeMin, ::Nggh_MagicConcept.HexeOriginRitual.RandomizeMax) * 0.01;
		local party_strength = ::World.State.getPlayer().getStrength();
		::logInfo("Ритуал ведьмы - Текущая сила отряда? " + party_strength);
		local Required = ::Math.max(1, ::Math.ceil(party_strength * (::Nggh_MagicConcept.HexeOriginRitual.Mult + modifier) * randomness));
		::logInfo("Ритуал ведьмы - Необходимое значение? " + Required);

		if (!::World.Flags.get("isExposed"))
		{
			if (::Math.rand(1, 100) <= ::Math.ceil(::Nggh_MagicConcept.HexeOriginRitual.UnluckyChance + ::World.Flags.getAsInt("HexeOriginLucky") * 1.5))
			{
				Required = ::Math.ceil(Required * ::Nggh_MagicConcept.HexeOriginRitual.UnluckyMult);
				::logInfo("Ритуал ведьмы - Требуемое значение подношения увеличивается! " + Required + " - новое значение (Вам очень не повезло)");
				::World.Flags.set("HexeOriginLucky", 0);
			}
			else
			{
				::World.Flags.increment("HexeOriginLucky");
			}
		}

		local Money = ::Math.ceil(Required * 0.33);
		::logInfo("Ритуал ведьмы - Заплатить часть золотом: " + Money);
		Required = ::Math.max(0, Required - Money);
		local QualifiedItems = this.onPrepareOfferings();
		local List = [];
		local NumList = [];
		local Has = 0;
		
		if (::World.Assets.getMoney() >= Money)
		{
			this.m.Money += Money;
			::logInfo("Ритуал ведьмы - Достаточно денег, 33% оплачивается в первую очередь");
		}
		else
		{
			this.m.Money += ::World.Assets.getMoney();
			Required += Money - ::World.Assets.getMoney();
			::logInfo("Ритуал ведьмы - Недостаточно денег! Это все, что у вас есть, " + (Money - ::World.Assets.getMoney()));
		}
		
		foreach ( a in QualifiedItems.First )
		{
			if (Has >= Required)
			{
				break;
			}

			local i = List.find(a.Item.getName());

			if (i != null)
			{
				++NumList[i];
			}
			else
			{
				List.push(a.Item.getName());
				NumList.push(1);
			}
			
			this.m.Offerings.push(a.Item);
			Has += a.Value;
		}

		if (Has < Required && QualifiedItems.Second.len() != 0)
		{
			local tries = 0;

			while (QualifiedItems.Second.len() > 0 && tries < 100)
			{
				local index = ::Math.rand(0, QualifiedItems.Second.len() - 1);
				local find = QualifiedItems.Second.remove(index);

				if (find != null)
				{
					this.m.Offerings.push(find.Item);
					Has += find.Value;
				}
				else
				{
				    ++tries;
				}

				if (Has >= Required)
				{
					break;
				}
			}
		}

		foreach (i, name in List)
		{
			::logInfo("Ритуал ведьмы - Пожертвовать предмет: " + name + (NumList[i] > 1 ? " (x" + NumList[i] + ")" : ""));
		}
		
		if (Has < Required && ::World.Assets.getMoney() > Required - Has)
		{
			::logInfo("Ритуал ведьмы - Оплатить остальное деньгами - 100% оплачено");
			this.m.Money += Required - Has;
			Has = Required;
		}
		
		this.m.IsSucceed = Has >= Required;

		if (this.m.IsSucceed)
		{
			local candidates = [];

			foreach (bro in brothers)
			{
				local skill = bro.getSkills().getSkillByID("effects.simp");

				if (skill == null)
				{
					continue;
				}

				if (skill.getSimpLevel() >= ::Const.Simp.MaximumLevel)
				{
					continue;
				}

				candidates.push(bro);
			}

			if (candidates.len() != 0)
			{
				local num = ::Math.min(2, candidates.len());
				local selectedID = [];
				local lv = 0;

				while (this.m.Simps.len() < num)
				{
					local index = ::Math.rand(0, candidates.len() - 1);
					local pick = candidates.remove(index);

					if (pick != null)
					{
						lv += pick.getSkills().getSkillByID("effects.simp").getSimpLevel();
						this.m.Simps.push(pick);
					}

					/*
					if (selectedID.find(pick.getID()) == null)
					{
						lv += pick.getSkills().getSkillByID("effects.simp").getSimpLevel();
						selectedID.push(pick.getID());
						this.m.Simps.push(pick);
					}
					*/
				}

				// get the average simp level
				lv = ::Math.max(1, ::Math.ceil(lv / num));
				local v = lv >= 7 ? 2450 + 500 * (lv - 7) : 350 * lv;
				local items = [];
				local all = [];
				all.extend(QualifiedItems.First);
				all.extend(QualifiedItems.Second);

				while(v > 0 && all.len() != 0)
				{
					local index = ::Math.rand(0, all.len() - 1);
					local find = all.remove(index);

					if (find != null)
					{
						::logInfo("Ритуал ведьмы - предмет для повышения уровня простака: " + find.Item.getName());
						items.push(find.Item);
						v -= find.Value;
					}
				}

				if (v <= 0)
				{
					this.m.ChosenItems.extend(items);
				}
			}
		}

		this.m.AmbushChance = this.recalculateAmbushChance();
	}
	
	function getModifier( _days )
	{
		if (_days <= 50)
		{
			return 0;
		}
		
		return ::Math.min(6, ::Math.max(1, ::Math.floor(_days / 80)));
	}

	function recalculateAmbushChance()
	{
		local playerTile = ::World.State.getPlayer().getTile();
		local towns = ::World.EntityManager.getSettlements();
		local nearest = 9999;
		local best;

		foreach( t in towns )
		{
			if (t.isMilitary() || ::isKindOf(t, "city_state"))
			{
				continue;
			}

			local faction = t.getFactionOfType(::Const.FactionType.Settlement);

			if (faction == null)
			{
				continue;
			}

			if (faction.getPlayerRelation() >= 90.0)
			{
				continue;
			}

			local d = playerTile.getDistanceTo(t.getTile());

			if (d >= 7)
			{
				continue;
			}

			if (d <= nearest)
			{
				nearest = d;
				best = t;
			}
		}

		if (best == null)
		{
			return 0;
		}

		this.m.Town = best;
		local randomness = ::Math.rand(80, 120) * 0.01;
		local chance = ::Math.ceil(7.5 * (8 - nearest) * randomness);
		local ret = ::Math.max(5, ::Math.min(95, chance));
		::logInfo("Ритуал ведьмы - Расчет шанса попасть в засаду... Готово! -> Результат: " + ret + "%");
		return ret;
	}
	
	function onPrepareOfferings()
	{
		local table = {
			QualifiedItems = [],
			TradeGood = [],
			Crafting = [],
			Loot = []
		};
		
		foreach ( _item in ::World.Assets.getStash().getItems() )
		{
			if (_item == null)
			{
				continue;
			}
			
			this.processThisItemValue(_item, table);
		}
		
		if (table.TradeGood.len() != 0)
		{
			table.QualifiedItems.extend(table.TradeGood);
		}
		
		if (table.Loot.len() != 0)
		{
			table.QualifiedItems.extend(table.Loot);
		}
		
		if (table.QualifiedItems.len() > 1)
		{
			table.QualifiedItems.sort(this.onSortByValueAscend);
		}
		
		return {
			First = table.QualifiedItems,
			Second = table.Crafting,
		};
	}
	
	function processThisItemValue( _item , _table )
	{
		if (_item.isItemType(::Const.Items.ItemType.Loot))
		{
			_table.Loot.push({
				Item = _item,
				Value = ::Math.floor(_item.m.Value * 1.25),
			});
		}
		else if (_item.isItemType(::Const.Items.ItemType.Crafting))
		{
			_table.Crafting.push({
				Item = _item,
				Value = ::Math.floor(_item.m.Value * 1.1),
			});
		}
		else if (_item.isItemType(::Const.Items.ItemType.TradeGood) && _item.getID().find("tent.") == null)
		{
			_table.TradeGood.push({
				Item = _item,
				Value = ::Math.floor(_item.m.Value * 1.5),
			});
		}
	}
	
	function onSortByValueAscend( _a, _b )
	{
		if (_a.Value > _b.Value)
		{
			return -1;
		}
		else if (_a.Value < _b.Value)
		{
			return 1;
		}

		return 0;
	}
	
	function onSortByValueDescend( _a, _b )
	{
		if (_a.Value > _b.Value)
		{
			return 1;
		}
		else if (_a.Value < _b.Value)
		{
			return -1;
		}

		return 0;
	}
	
	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hexe",
			this.m.Hexe.getNameOnly()
		]);

		if (this.m.Town != null)
		{
			_vars.push([
				"town",
				this.m.Town.getName()
			]);
		}
	}
	
	function onDetermineStartScreen()
	{
		::logInfo("Ритуал ведьмы - удался ли?" + this.m.IsSucceed);
		return this.m.IsSucceed ? "A" : "B";
	}

	function onClear()
	{
		this.m.Hexe = null;
		this.m.Town = null;
		this.m.IsSucceed = false;
		this.m.ChosenItems = [];
		this.m.Simps = [];
		this.m.Money = 0;
		this.m.Offerings = [];
		this.m.AmbushChance = 5;
		this.m.DifficultyMult = 0.0;
		this.m.DifficultyMultScale = 0.0;
		this.m.ResourceBoost = 0;
	}

	function increaseSimpLevel( _bro )
	{
		_bro.getSkills().getSkillByID("effects.simp").gainSimpLevel();
		_bro.improveMood(1.0, this.m.Hexe.getName() + " любит меня");
		_bro.getSkills().add(::new("scripts/skills/effects_world/nggh_mod_blessed_effect"));
		::logInfo("Ритуал ведьмы - " + _bro.getNameOnly() + " простак получает уровень");
		//return charm;
	}

	function decreaseSimpLevel( _bro )
	{
		_bro.getFlags().set("isCursed", true);
		_bro.getSkills().getSkillByID("effects.simp").loseSimpLevel();
		_bro.worsenMood(1.0, this.m.Hexe.getNameOnly() + " пугает меня");
		//return charm;
	}

	function consumeChosenItems()
	{
		foreach( item in this.m.ChosenItems )
		{
			::World.Assets.getStash().remove(item);
		}

		this.m.ChosenItems = [];
	}

	function spawnWitchHunterParty( _tile )
	{
		::World.State.setPause(true);
		local faction = this.m.Town.getFactionOfType(::Const.FactionType.Settlement);
		
		if (faction == null)
			faction = ::World.FactionManager.getFaction(this.m.Town.getFaction());
		
		local party = faction.spawnEntity(_tile, "Охотники на ведьм", false, null, 0);
		local template = ::Const.World.Common.buildDynamicTroopList(::Const.World.Spawn.Nggh_WitchHunter, this.getResources());
		local troopMbMap = {};

		party.getSprite("banner").setBrush(this.m.Town.getBanner());
		party.getSprite("body").setBrush(template.Body);
		party.setMovementSpeed(::Const.World.MovementSettings.Speed * template.MovementSpeedMult);
		party.setVisibilityMult(template.VisibilityMult);
		party.setVisionRadius(::Const.World.Settings.Vision * template.VisionMult);
		party.setDescription("Храбрые люди, посланные из [color=" + ::Const.UI.Color.NegativeValue + "]" + this.m.Town.getName() + "[/color], чтобы победить еретиков.");
		party.setFootprintType(::Const.World.FootprintsType.Militia);
		party.setAttackableByAI(false);
		party.setAlwaysAttackPlayer(true);
		party.setUsingGlobalVision(true);
		party.getFlags().set("WitchHunters", true);
		party.getLoot().Money = ::Math.rand(100, 200);
		party.getLoot().ArmorParts = ::Math.rand(0, 25);
		party.getLoot().Medicine = ::Math.rand(0, 5);
		party.getLoot().Ammo = ::Math.rand(0, 30);
		
		// have to manually add the additional champion from the event
		foreach( troop in template.Troops )
		{
			local key = "Enemy" + troop.Type.ID;

			if (!(key in troopMbMap))
				troopMbMap[key] <- ::Const.LegendMod.GetFavEnemyBossChance(troop.Type.ID);

			local mb = troopMbMap[key];

			for( local i = 0; i != troop.Num; ++i )
			{
				::Const.World.Common.addTroop(party, troop, false, this.m.ChampionChance + mb);
			}
		}

		faction.addPlayerRelation(-faction.getPlayerRelation() + 10, "Heretics");
		party.updatePlayerRelation();
		party.updateStrength();
		local c = party.getController();
		c.getBehavior(::Const.World.AI.Behavior.ID.Flee).setEnabled(false);
		local attack = ::new("scripts/ai/world/orders/intercept_order");
		attack.setTarget(::World.State.getPlayer());
		c.addOrder(attack);
	}

	function getResources()
	{
		return (100 + this.m.ResourceBoost) * this.m.DifficultyMult * this.m.DifficultyMultScale;
	}

	function calcDifficultyMult()
	{
		local r;

		if (::World.getTime().Days < 20)
			r = ::Math.rand(1, 30);
		else if (::World.getTime().Days < 40)
			r = ::Math.rand(1, 80);
		else
			r = ::Math.rand(1, 100);

		if (r <= 30)
		{
			this.m.ChampionChance = 0;
			this.m.DifficultyMult = ::Math.rand(60, 65) * 0.01;
		}
		else if (r <= 80)
		{
			this.m.ChampionChance = 1;
			this.m.DifficultyMult = ::Math.rand(85, 95) * 0.01;
		}
		else
		{
			this.m.ChampionChance = 4;
			this.m.DifficultyMult = ::Math.rand(105, 125) * 0.01;
		}

		this.m.ChampionChance += this.getAdditionalChampionChance();
	}

	function getAdditionalChampionChance()
	{
		if (::World.getTime().Days < 50)
			return 0;
		else if (::World.getTime().Days < 90)
			return 1;
		else
			return 3;
	}

	function getScaledDifficultyMult()
	{
		local s = ::Math.maxf(0.75, ::Math.pow(0.01 * ::World.State.getPlayer().getStrength(), 0.85));
		local d = ::Math.minf(5.0, s);
		return d * ::Const.Difficulty.EnemyMult[::World.Assets.getCombatDifficulty()];
	}

	function calcResourceBoost()
	{
		local defaultBoost = -10;
		local dayModifier = ::Math.min(::World.getTime().Days / 6, 30);
		return defaultBoost + dayModifier;
	}

});

