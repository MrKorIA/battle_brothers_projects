this.nggh_mod_luft_intro_event <- ::inherit("scripts/events/event", {
	m = {
		Luft = null,
		Foods = [],
		Food = null,
		Index = 0,
		DiscordMembers = [],
		DiscordMember = null,
		Weapon = null,
		IsReceivedBuff = false,
		HasPet = false,
		HasGivenWeapon = false,
		HasMeal = false,
		HasNewPerks = null,
	},
	function create()
	{
		this.m.ID = "event.luft_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_12.png[/img]%SPEECH_START%Где я? Это не мой подвал! %SPEECH_OFF%%SPEECH_START%Кто ты? Что значит, я в игре? %SPEECH_OFF%%SPEECH_START%Боже мой! Пожалуйста, не делайте мне больно, я просто милый начо с крысиным фетишем. Пожалуйста, не заставляйте меня делать странные вещи%SPEECH_OFF%%SPEECH_START%Кстати, можно тебя погладить? %SPEECH_OFF%",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				this.Banner = "ui/banners/" + ::World.Assets.getBanner() + "s.png";

				if (_event.m.Luft != null)
				{
					this.Characters.push(_event.m.Luft.getImagePath());
				}

				if (!_event.m.HasPet)
				{
					if (::Math.rand(1, 100) <= 50)
					{
						this.Options.push({
							Text = "Нет! Я поглажу тебя вместо этого.",
							function getResult( _event )
							{
								return "Pet1";
							}

						});
					}
					else
					{
						this.Options.push({
							Text = "Хорошо! Но только одну",
							function getResult( _event )
							{
								return "Pet2";
							}

						});
					}

					if (::Math.rand(1, 100) <= 40)
					{
						this.Options.push({
							Text = "Да, и благослови меня своей мудростью.",
							function getResult( _event )
							{
								return "Tips";
							}

						});
					}
				}

				if (_event.m.Index == 0)
				{
					_event.m.Index = ::Math.rand(1, 2);
				}

				if (!_event.m.HasMeal)
				{
					if (_event.m.Index == 1)
					{
						this.Options.push({
							Text = "Я слышал, что ты любишь перекусывать членами Дискорда, это правда?",
							function getResult( _event )
							{
								return "EatDiscordMember";
							}

						});
					}
					else 
					{
					    this.Options.push({
							Text = "Ты голоден, Люфт?",
							function getResult( _event )
							{
								return "Eat";
							}

						});
					}
				}

				/*
				if (!_event.m.HasNewPerks)
				{
					this.Options.push({
						Text = "Вы должны узнать .....",
						function getResult( _event )
						{
							return "PerkGroups";
						}

					});
				}
				*/

				if (_event.m.HasMeal || _event.m.HasNewPerks || _event.m.HasPet)
				{
					this.Options.push({
						Text = "Я освобожу тебя, Люфт!",
						function getResult( _event )
						{
							return 0;
						}

					});
				}
			}

		});

		this.m.Screens.push({
			ID = "PerkGroups",
			Text = "[img]gfx/ui/events/event_15.png[/img]%SPEECH_START%Что????? Пожалуйста, не возлагайте на меня больших надежд! %SPEECH_OFF%",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Как пользоваться оружием ближнего боя",
					function getResult( _event )
					{	
						local exclude = [];

						while (exclude.len() < 3)
						{
							local new = ::Const.Perks.MeleeWeaponTrees.getRandom(exclude);
							exclude.push(new.ID);
							_event.m.Luft.getBackground().addPerkGroup(new.Tree);
						}

						_event.m.Weapon = ::new("scripts/items/weapons/" + ::MSU.Array.rand([
							"wooden_stick",
							"wooden_flail",
							"legend_staff",
							"shortsword",
							"scramasax",
							"militia_spear",
							"hand_axe"
						]));
						_event.m.Luft.getItems().equip(_event.m.Weapon);

						if (::Is_PTR_Exist)
						{
							_event.m.Luft.getBackground().addPerkGroup(::Math.rand(1, 2) == 1 ? ::Const.Perks.OneHandedTree.Tree : ::Const.Perks.TwoHandedTree.Tree);
						}

						return "A";
					}

				},
				{
					Text = "Как пользоваться луком и стрелами",
					function getResult( _event )
					{
						_event.m.Luft.getBackground().addPerkGroup(::Const.Perks.BowTree.Tree);
						_event.m.Luft.getBackground().addPerkGroup(::Const.Perks.CrossbowTree.Tree);
						_event.m.Luft.getBackground().addPerk(::Const.Perks.PerkDefs.QuickHands, 1);
						_event.m.Luft.getTalents()[::Const.Attributes.RangedSkill] = 3;
						_event.m.Luft.m.Attributes = [];
						_event.m.Luft.fillAttributeLevelUpValues(::Const.XP.MaxLevelWithPerkpoints - 1);

						local choose = ::MSU.Array.rand([
							["short_bow", "quiver_of_arrows"],
							["light_crossbow", "quiver_of_bolts"],
						]);
						_event.m.Weapon = ::new("scripts/items/weapons/" + choose[0]);
						_event.m.Luft.getItems().equip(_event.m.Weapon);
						_event.m.Luft.getItems().equip(::new("scripts/items/ammo/" + choose[1]));

						if (::Is_PTR_Exist)
						{
							_event.m.Luft.getBackground().addPerkGroup(::Const.Perks.RangedTree.Tree);
						}

						return "A";
					}

				},
				{
					Text = "Как метать камень и пращу",
					function getResult( _event )
					{
						_event.m.Luft.getBackground().addPerkGroup(::Const.Perks.SlingTree.Tree);
						_event.m.Luft.getBackground().addPerkGroup(::Const.Perks.ThrowingTree.Tree);
						_event.m.Luft.getBackground().addPerk(::Const.Perks.PerkDefs.QuickHands, 1);
						_event.m.Luft.getTalents()[::Const.Attributes.RangedSkill] = 2;
						_event.m.Luft.m.Attributes = [];
						_event.m.Luft.fillAttributeLevelUpValues(::Const.XP.MaxLevelWithPerkpoints - 1);
						_event.m.Weapon = ::new("scripts/items/weapons/legend_sling");
						_event.m.Luft.getItems().equip(_event.m.Weapon);

						if (::Is_PTR_Exist)
						{
							_event.m.Luft.getBackground().addPerkGroup(::Const.Perks.RangedTree.Tree);
						}

						return "A";
					}

				},
				{
					Text = "Как ничего не делать",
					function getResult( _event )
					{
						_event.m.Luft.improveMood(1.0, "Ура!!! Стать бесполезным");
						return "A";
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + ::World.Assets.getBanner() + "s.png";

				if (_event.m.Luft != null)
				{
					this.Characters.push(_event.m.Luft.getImagePath());
				}

				_event.m.HasNewPerks = true;
			}

		});

		this.m.Screens.push({
			ID = "Eat",
			Text = "[img]gfx/ui/events/event_61.png[/img]%SPEECH_START%Боже! Как раз к завтраку. Что ты мне дашь? Какой ты хороший мальчик! %SPEECH_OFF%%SPEECH_START% За это я подарю тебе питомца.%SPEECH_OFF%",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				this.Banner = "ui/banners/" + ::World.Assets.getBanner() + "s.png";

				if (_event.m.Luft != null)
				{
					this.Characters.push(_event.m.Luft.getImagePath());
				}

				foreach (i, food in _event.m.Foods ) 
				{
				   	this.Options.insert(0, {
				   		Index = i,
						Text = ::MSU.Array.rand([
							"У меня есть",
							"Надеюсь, тебе понравится.",
							"Просто немного",
							"Хм, да!!!",
							"Как насчет",
							"Сюрприз! Это"
						]) + " [color=#bcad8c]" + food.getName() + "[/color]",

						function getResult( _event )
						{
							_event.m.Food = this.Index;
							return "E";
						}

					});
				}

				_event.m.HasMeal = true;
			}

		});

		this.m.Screens.push({
			ID = "EatDiscordMember",
			Text = "[img]gfx/ui/events/event_69.png[/img]%SPEECH_START%Конечно! Магда часто банит людей, не зная, что за это они будут отправлены в мой животик. Не говори об этом Магде, иначе ты тоже станешь моим обедом.%SPEECH_OFF%%SPEECH_START%Хочешь, я покажу тебе, как я это делаю? %SPEECH_OFF%",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				this.Banner = "ui/banners/" + ::World.Assets.getBanner() + "s.png";

				if (_event.m.Luft != null)
				{
					this.Characters.push(_event.m.Luft.getImagePath());
				}

				foreach (i, food in _event.m.DiscordMembers ) 
				{
				   	this.Options.insert(0, {
				   		Name = food,
						Text = ::MSU.Array.rand([
							"Давай попробуем с",
							"Я знаю человека, который тебе подойдет,",
							"Хм, да!!!",
							"Ты можешь получить",
							"Никаких обид, "
						]) + " [color=#bcad8c]" + food + "[/color]",
						
						function getResult( _event )
						{
							_event.m.DiscordMember = this.Name;
							return "EatDiscordMember2";
						}

					});
				}

				_event.m.HasMeal = true;
			}

		});

		this.m.Screens.push({
			ID = "EatDiscordMember2",
			Text = "[img]gfx/ui/events/event_12.png[/img]%SPEECH_START%Delicious! Теперь вы знаете, почему я так люблю vore. Видите ли, это деликатес Дискорда. Лучший ресторан быстрого питания, который я когда-либо знал.%SPEECH_OFF%",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Увидеть, чтобы поверить.",
					function getResult( _event )
					{
						return "A";
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + ::World.Assets.getBanner() + "s.png";
				//this.Text = "[img]gfx/ui/events/event_12.png[/img]%SPEECH_START% Мне так жаль, " + _event.m.DiscordMember + "! Но ты такой вкусный, я бы хотел, чтобы вас было двое, чтобы я мог насладиться больше.%SPEECH_OFF%";
				
				if (_event.m.Luft != null)
				{
					this.Characters.push(_event.m.Luft.getImagePath());
				}

				local def;

				switch (_event.m.DiscordMember)
				{
				case "Посс":
					def = ::Const.Perks.PerkDefObjects[::Const.Perks.PerkDefs.NggHMiscChampion];
					::World.Assets.getOrigin().addScenarioPerk(_event.m.Luft.getBackground(), ::Const.Perks.PerkDefs.NggHMiscChampion, 6);
					break;

				case "MuffledMagda":
					def = ::Const.Perks.PerkDefObjects[::Const.Perks.PerkDefs.LegendTeacher];
					::World.Assets.getOrigin().addScenarioPerk(_event.m.Luft.getBackground(), ::Const.Perks.PerkDefs.LegendTeacher, 4);
					break;

				case "Воин-альфа-самец (Люк)":
					def = ::Const.Perks.PerkDefObjects[::Const.Perks.PerkDefs.LegendFavouredEnemyBeast];
					::World.Assets.getOrigin().addScenarioPerk(_event.m.Luft.getBackground(), ::Const.Perks.PerkDefs.LegendFavouredEnemyBeast, 2);
					break;

				case "Некро":
					def = ::Const.Perks.PerkDefObjects[::Const.Perks.PerkDefs.NggHAlpShadowCopy];
					::World.Assets.getOrigin().addScenarioPerk(_event.m.Luft.getBackground(), ::Const.Perks.PerkDefs.NggHAlpShadowCopy, 5);
					break;

				case "LordMidas":
					def = ::Const.Perks.PerkDefObjects[::Const.Perks.PerkDefs.PTRDiscoveredTalent];
					::World.Assets.getOrigin().addScenarioPerk(_event.m.Luft.getBackground(), ::Const.Perks.PerkDefs.PTRDiscoveredTalent, 3);
					break;

				case "Эндуриэль":
					def = ::Const.Perks.PerkDefObjects[::Const.Perks.PerkDefs.LegendSkillfulStacking];
					::World.Assets.getOrigin().addScenarioPerk(_event.m.Luft.getBackground(), ::Const.Perks.PerkDefs.LegendSkillfulStacking, 4);
					break;

				case "TaroEld":
					def = ::Const.Perks.PerkDefObjects[::Const.Perks.PerkDefs.HoldOut];
					::World.Assets.getOrigin().addScenarioPerk(_event.m.Luft.getBackground(), ::Const.Perks.PerkDefs.HoldOut, 1);

					local trait = ::new("scripts/skills/traits/strong_trait");
					_event.m.Luft.getSkills().add(trait);
					this.List.push({
						id = 10,
						icon = trait.getIcon(),
						text = _event.m.Luft.getName() + " получает черту '" + trait.getName() + "'"
					});
					break;

				case "Убербагель":
					if (::Is_PTR_Exist)
					{
						def = ::Const.Perks.PerkDefObjects[::Const.Perks.PerkDefs.PTRRisingStar];
						::World.Assets.getOrigin().addScenarioPerk(_event.m.Luft.getBackground(), ::Const.Perks.PerkDefs.PTRRisingStar, 6);
					}
					else 
					{
						def = ::Const.Perks.PerkDefObjects[::Const.Perks.PerkDefs.Gifted];
						::World.Assets.getOrigin().addScenarioPerk(_event.m.Luft.getBackground(), ::Const.Perks.PerkDefs.Gifted, 2);
					}
					break;
				
				case "Вусяньцзиньсин":
					def = ::Const.Perks.PerkDefObjects[::Const.Perks.PerkDefs.LegendPackleader];
					::World.Assets.getOrigin().addScenarioPerk(_event.m.Luft.getBackground(), ::Const.Perks.PerkDefs.LegendPackleader, 5);
					break;
				}

				this.List.push({
					id = 10,
					icon = def.Icon,
					text = _event.m.Luft.getName() + " получает '" + def.Name + "' навык"
				});
				
				this.List.insert(0, {
					id = 10,
					icon = ::Const.MoodStateIcon[_event.m.Luft.getMoodState()],
					text = _event.m.Luft.getName() + " заполнен"
				});
			}

		});

		this.m.Screens.push({
			ID = "Weapons",
			Text = "[img]gfx/ui/events/event_62.png[/img]%SPEECH_START%Сегодня не мой день рождения, но у меня есть подарок из ниоткуда от таинственного человека по ту сторону экрана монитора. Спасибо! Я хочу погладить тебя побольше.%SPEECH_OFF%",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				this.Banner = "ui/banners/" + ::World.Assets.getBanner() + "s.png";

				if (_event.m.Luft != null)
				{
					this.Characters.push(_event.m.Luft.getImagePath());
				}

				if (_event.m.Weapon != null)
				{
					this.List.push({
						id = 10,
						icon = "ui/items/" + _event.m.Weapon.getIcon(),
						text = _event.m.Luft.getName() + " получает " + _event.m.Weapon.getName()
					});
				}

				if (_event.m.HasGivenWeapon)
				{
					this.Options.push({
						Text = "Сюрприз!!!",
						function getResult( _event )
						{
							return "A";
						}

					});

					if (_event.m.Weapon == null)
					{
						_event.m.Luft.worsenMood(0.5, "Меня троллили");

						this.List.push({
							id = 10,
							icon = ::Const.MoodStateIcon[_event.m.Luft.getMoodState()],
							text = _event.m.Luft.getName() + ::Const.MoodStateEvent[_event.m.Luft.getMoodState()]
						});
					}
				}
				else 
				{
				    this.Options.extend([
					    {
							Text = "Палка",
							function getResult( _event )
							{
							
								return "Weapons";
							}

						},
						{
							Text = "Длинная палка",
							function getResult( _event )
							{
								_event.m.Weapon = ::new("scripts/items/weapons/legend_staff");
								_event.m.Luft.getItems().equip(_event.m.Weapon);
								return "Weapons";
							}

						},
						{
							Text = "Острая палка",
							function getResult( _event )
							{
								_event.m.Weapon = ::new("scripts/items/weapons/militia_spear");
								_event.m.Luft.getItems().equip(_event.m.Weapon);
								return "Weapons";
							}

						},
						{
							Text = "Палка с веревкой",
							function getResult( _event )
							{
								

								return "Weapons";
							}

						},
						{
							Text = "Палка, которой трудно пользоваться",
							function getResult( _event )
							{
								_event.m.Weapon = ::new("scripts/items/weapons/wooden_flail");
								_event.m.Luft.getItems().equip(_event.m.Weapon);
								return "Weapons";
							}

						},
						{
							Text = "Ничего",
							function getResult( _event )
							{
								return "Weapons";
							}

						},
					]);

					_event.m.HasGivenWeapon = true;
				}
			}

		});

		this.m.Screens.push({
			ID = "Pet1",
			Text = "[img]gfx/ui/events/event_69.png[/img]",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Правильно! Кто такой хороший Люфт?",
					function getResult( _event )
					{
						_event.m.HasPet = true;
						return "A";
					}

				},
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + ::World.Assets.getBanner() + "s.png";

				if (_event.m.Luft != null)
				{
					this.Characters.push(_event.m.Luft.getImagePath());
				}

				_event.m.Luft.improveMood(4.0, "Погладили по голове");
				_event.m.Luft.addXP(100, false);
				
				this.List.push({
					id = 10,
					icon = ::Const.MoodStateIcon[_event.m.Luft.getMoodState()],
					text = _event.m.Luft.getName() + ::Const.MoodStateEvent[_event.m.Luft.getMoodState()]
				});
				this.List.push({
					id = 17,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Luft.getName() + " получает [color=" + ::Const.UI.Color.PositiveEventValue + "]250[/color] опыта"
				});
			}

		});

		this.m.Screens.push({
			ID = "Pet2",
			Text = "[img]gfx/ui/events/event_85.png[/img]",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Люблю это",
					function getResult( _event )
					{
						_event.m.HasPet = true;
						return "A";
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + ::World.Assets.getBanner() + "s.png";

				if (_event.m.Luft != null)
				{
					this.Characters.push(_event.m.Luft.getImagePath());
				}

				_event.m.Luft.improveMood(0.5, "Я только что погладил кого-то");
				_event.m.Luft.addXP(250, false);
				
				this.List.push({
					id = 10,
					icon = ::Const.MoodStateIcon[_event.m.Luft.getMoodState()],
					text = _event.m.Luft.getName() + ::Const.MoodStateEvent[_event.m.Luft.getMoodState()]
				});
				this.List.push({
					id = 17,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Luft.getName() + " получает [color=" + ::Const.UI.Color.PositiveEventValue + "]250[/color] опыта"
				});
			}

		});

		this.m.Screens.push({
			ID = "Tips",
			Text =  "",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Пожалуйста, расскажите мне больше!",
					function getResult( _event )
					{
						return "Tips";
					}

				},
				{
					Text = "Какой ты мудрый!",
					function getResult( _event )
					{
						return "A";
					}

				},
			],
			function start( _event )
			{
				this.Text = "[img]gfx/ui/events/event_40.png[/img]{";

				foreach (tip in ::Const.LuftTips)
				{
					this.Text += "%SPEECH_START%" + tip + "%SPEECH_OFF% | ";
				}

				this.Text += "}";
				this.Banner = "ui/banners/" + ::World.Assets.getBanner() + "s.png";

				if (_event.m.Luft != null)
				{
					this.Characters.push(_event.m.Luft.getImagePath());
				}

				if (!_event.m.IsReceivedBuff)
				{
					_event.m.Luft.improveMood(0.5, "Кто-то спросил о моей мудрости");
					_event.m.Luft.getBaseProperties().Bravery += 5;
					_event.m.Luft.getSkills().update();
					_event.m.IsReceivedBuff = true;
					_event.m.HasPet = true;
					
					this.List.extend([
						{
							id = 10,
							icon = ::Const.MoodStateIcon[_event.m.Luft.getMoodState()],
							text = _event.m.Luft.getName() + ::Const.MoodStateEvent[_event.m.Luft.getMoodState()]
						},
						{
							id = 17,
							icon = "ui/icons/bravery.png",
							text = _event.m.Luft.getName() + " получает [color=" + ::Const.UI.Color.PositiveEventValue + "]+5[/color] к решимости"
						}
					]);
				}
			}

		});

		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_61.png[/img]%SPEECH_START%Спасибо, чувак! Это восхитительно%SPEECH_OFF%",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				this.Banner = "ui/banners/" + ::World.Assets.getBanner() + "s.png";
				local option_text = "Не за что, Люфт";
				local isTrolled = false;
				local food = _event.m.Foods[_event.m.Food];
				_event.m.Luft.improveMood(0.5, "Приятного аппетита");
				_event.m.Luft.grow(true);

				local size = 9990 + _event.m.Luft.getSize();
				::World.Flags.set("looks", size);
				::World.Assets.updateLook(size);

				if (_event.m.Luft != null)
				{
					this.Characters.push(_event.m.Luft.getImagePath());
				}

				switch (food.getID()) 
				{
				case "supplies.black_marsh_stew":
					_event.m.Luft.getBaseProperties().Stamina += 5;
					_event.m.Luft.getBaseProperties().MeleeDefense += 3;
					this.List.extend([
						{
							id = 17,
							icon = "ui/icons/fatigue.png",
							text = _event.m.Luft.getName() + " получает [color=" + ::Const.UI.Color.PositiveEventValue + "]+5[/color] к выносливости"
						},
						{
							id = 17,
							icon = "ui/icons/melee_skill.png",
							text = _event.m.Luft.getName() + " получает [color=" + ::Const.UI.Color.PositiveEventValue + "]+3[/color] к навыку ближнего боя"
						},
					]);
					break;

				case "supplies.dried_lamb":
					_event.m.Luft.getBaseProperties().RangedSkill += 5;
					_event.m.Luft.getBaseProperties().RangedDefense += 5;
					this.List.extend([
						{
							id = 17,
							icon = "ui/icons/ranged_skill.png",
							text = _event.m.Luft.getName() + " получает [color=" + ::Const.UI.Color.PositiveEventValue + "]+5[/color] к навыку дальнего боя"
						},
						{
							id = 17,
							icon = "ui/icons/ranged_defense.png",
							text = _event.m.Luft.getName() + " усиление [color=" + ::Const.UI.Color.PositiveEventValue + "]+3[/color] к защите в дальнем бою"
						},
					]);
					break;

				case "supplies.pickled_mushrooms_item":
					_event.m.Luft.getBaseProperties().Initiative += 5;
					_event.m.Luft.getBaseProperties().Bravery += 3;
					this.List.extend([
						{
							id = 17,
							icon = "ui/icons/initiative.png",
							text = _event.m.Luft.getName() + " получает [color=" + ::Const.UI.Color.PositiveEventValue + "]+5[/color] к инициативе"
						},
						{
							id = 17,
							icon = "ui/icons/bravery.png",
							text = _event.m.Luft.getName() + " получает [color=" + ::Const.UI.Color.PositiveEventValue + "]+3[/color] к решимости"
						},
					]);
					break;

				case "supplies.fermented_unhold_heart":
					_event.m.Luft.getBaseProperties().Stamina += 5;
					_event.m.Luft.getBaseProperties().Bravery += 3;
					this.List.extend([
						{
							id = 17,
							icon = "ui/icons/fatigue.png",
							text = _event.m.Luft.getName() + " получает [color=" + ::Const.UI.Color.PositiveEventValue + "]+5[/color] к выносливости"
						},
						{
							id = 17,
							icon = "ui/icons/bravery.png",
							text = _event.m.Luft.getName() + " получает [color=" + ::Const.UI.Color.PositiveEventValue + "]+3[/color] к решимости"
						},
					]);
					break;

				case "supplies.legend_yummy_sausages":
					_event.m.Luft.getBaseProperties().Hitpoints += 5;
					_event.m.Luft.getBaseProperties().MeleeSkill += 3;
					this.List.extend([
						{
							id = 17,
							icon = "ui/icons/health.png",
							text = _event.m.Luft.getName() + " получает [color=" + ::Const.UI.Color.PositiveEventValue + "]+5[/color] к ОЗ"
						},
						{
							id = 17,
							icon = "ui/icons/melee_skill.png",
							text = _event.m.Luft.getName() + " получает [color=" + ::Const.UI.Color.PositiveEventValue + "]+3[/color] к навыку ближнего боя"
						},
					]);
					break;
				
				case "supplies.goat_cheese":
					_event.m.Luft.getBaseProperties().Hitpoints += 5;
					_event.m.Luft.getBaseProperties().Bravery += 2;
					this.List.extend([
						{
							id = 17,
							icon = "ui/icons/health.png",
							text = _event.m.Luft.getName() + " получает [color=" + ::Const.UI.Color.PositiveEventValue + "]+5[/color] к ОЗ"
						},
						{
							id = 17,
							icon = "ui/icons/bravery.png",
							text = _event.m.Luft.getName() + " получает [color=" + ::Const.UI.Color.PositiveEventValue + "]+2[/color] к решимости"
						},
					]);
					break;

				case "supplies.legend_pie":
					_event.m.Luft.getBaseProperties().Hitpoints += 5;
					_event.m.Luft.getBaseProperties().Stamina += 5;
					this.List.extend([
						{
							id = 17,
							icon = "ui/icons/health.png",
							text = _event.m.Luft.getName() + " получает [color=" + ::Const.UI.Color.PositiveEventValue + "]+5[/color] к ОЗ"
						},
						{
							id = 17,
							icon = "ui/icons/fatigue.png",
							text = _event.m.Luft.getName() + " получает [color=" + ::Const.UI.Color.PositiveEventValue + "]+7[/color] к выносливости"
						},
					]);
					break;

				case "supplies.strange_meat":
					this.Text = "[img]gfx/ui/events/event_14.png[/img]%SPEECH_START%Хмм да! Надеюсь, это не крысиное мясо%SPEECH_OFF%";
					option_text = "Это крысиное мясо";
					isTrolled = true;
					_event.m.Luft.getBaseProperties().Hitpoints += 2;
					_event.m.Luft.getBaseProperties().Bravery += 2;
					_event.m.Luft.getBaseProperties().Stamina += 2;
					_event.m.Luft.getBaseProperties().Initiative += 2;
					_event.m.Luft.getBaseProperties().MeleeSkill += 2;
					_event.m.Luft.getBaseProperties().RangedSkill += 2;
					_event.m.Luft.getBaseProperties().MeleeDefense += 2;
					_event.m.Luft.getBaseProperties().RangedDefense += 2;
					this.List.extend([
						{
							id = 17,
							icon = "ui/icons/health.png",
							text = _event.m.Luft.getName() + " получает [color=" + ::Const.UI.Color.PositiveEventValue + "]+2[/color] к ОЗ"
						},
						{
							id = 17,
							icon = "ui/icons/bravery.png",
							text = _event.m.Luft.getName() + " получает [color=" + ::Const.UI.Color.PositiveEventValue + "]+2[/color] к решимости"
						},
						{
							id = 17,
							icon = "ui/icons/fatigue.png",
							text = _event.m.Luft.getName() + " получает [color=" + ::Const.UI.Color.PositiveEventValue + "]+2[/color] к выносливости"
						},
						{
							id = 17,
							icon = "ui/icons/initiative.png",
							text = _event.m.Luft.getName() + " получает [color=" + ::Const.UI.Color.PositiveEventValue + "]+2[/color] к инициативе"
						},
						{
							id = 17,
							icon = "ui/icons/melee_skill.png",
							text = _event.m.Luft.getName() + " получает [color=" + ::Const.UI.Color.PositiveEventValue + "]+2[/color] к навыку ближнего боя"
						},
						{
							id = 17,
							icon = "ui/icons/ranged_skill.png",
							text = _event.m.Luft.getName() + " получает [color=" + ::Const.UI.Color.PositiveEventValue + "]+2[/color] к навыку дальнего боя"
						},
						{
							id = 17,
							icon = "ui/icons/melee_defense.png",
							text = _event.m.Luft.getName() + " получает [color=" + ::Const.UI.Color.PositiveEventValue + "]+2[/color] к защите в ближнем бою"
						},
						{
							id = 17,
							icon = "ui/icons/ranged_defense.png",
							text = _event.m.Luft.getName() + " получает [color=" + ::Const.UI.Color.PositiveEventValue + "]+2[/color] к защите в дальнем бою"
						},
					]);
					break;
				}
				
				
				this.List.insert(0, {
					id = 10,
					icon = ::Const.MoodStateIcon[_event.m.Luft.getMoodState()],
					text = _event.m.Luft.getName() + ::Const.MoodStateEvent[_event.m.Luft.getMoodState()]
				});
				_event.m.Luft.getSkills().update();

				this.Options.insert(0, {
					Text = option_text,
					function getResult( _event )
					{
						if (isTrolled)
						{
							_event.m.Luft.worsenMood(2.0, "Кто-то накормил меня крысиным мясом");
						}

						return "A";
					}

				});

			}

		});
	}

	function onPrepare()
	{
		this.m.Title = "Талисман бледного упыря";
		
		foreach (b in ::World.getPlayerRoster().getAll())
		{
			if (b.getFlags().has("luft"))
			{
				this.m.Luft = b;
				break;
			}
		}

		local foods = [
			"strange_meat_item",
			"legend_pie_item",
			"goat_cheese_item",
			"legend_yummy_sausages",
			"fermented_unhold_heart_item",
			"pickled_mushrooms_item",
			"dried_lamb_item",
			"black_marsh_stew_item"
		];

		while (foods.len() > 5)
		{
			foods.remove(::Math.rand(0, foods.len() - 1));
		}

		foreach ( f in foods )
		{
			this.m.Foods.push(::new("scripts/items/supplies/" + f));
		}
		
		local foods = [
			"Эндуриэль",
			"TaroEld",
			"MuffledMagda",
			"Воин-альфа-самец (Люк)",
			"Убербагель",
			"Вусяньцзиньсин",
			"Некро"
		];

		if (::Math.rand(1, 100) <= 25)
		{
			foods.push("Посс");
		}

		if (::Is_PTR_Exist)
		{
			foods.push("LordMidas");
		}

		while (foods.len() > 4)
		{
			foods.remove(::Math.rand(0, foods.len() - 1));
		}

		this.m.DiscordMembers.extend(foods);
	}

	function onPrepareVariables( _vars )
	{
	}

	function onUpdateScore()
	{
		return;
	}

	function onClear()
	{
		this.m.Luft = null;
		this.m.Food = null;
		this.m.IsReceivedBuff = false;
		this.m.Foods = [];
		this.m.Food = null;
		this.m.DiscordMembers = [];
		this.m.DiscordMember = null;
		this.m.Weapon = null;
		this.m.IsReceivedBuff = false;
		this.m.HasPet = false;
		this.m.HasGivenWeapon = false;
		this.m.HasMeal = false;
		this.m.HasNewPerks = null;
	}

});

