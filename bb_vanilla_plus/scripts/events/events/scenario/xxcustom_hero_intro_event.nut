this.xxcustom_hero_intro_event <- this.inherit("scripts/events/event", {
	m = {
		Bought = 0
	},
	function create()
	{
		this.m.ID = "event.xxcustom_hero_intro_event";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "apage1",
			Text = "[img]gfx/ui/events/event_62.png[/img]{Мир — опасное место. Разбойники и грабители устраивают засады у дорог, дикие звери бродят по тёмным лесам, а племена орков неспокойны на границах цивилизации. Ходят слухи даже о том, что действует тёмная магия — мёртвые восстают из могил и снова ходят. Есть много возможностей заработать хорошие деньги, будь то выполнение контрактов, которые можно найти в деревнях и городах по всей земле, или самостоятельные вылазки для исследования и грабежа. \n\n[color=#56e64c]Выберите своего персонажа-аватара[/color]}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Мужской Персонаж + Книга Умений",
					function getResult( _event )
					{
						_event.m.Bought = 1;
						return "GG";
					}
				},
				{
					Text = "Женский Персонаж + Книга Умений",
					function getResult( _event )
					{
						_event.m.Bought = 2;
						return "GG";
					}
				},
				{
					Text = "Орк Персонаж + Книга Умений",
					function getResult( _event )
					{
						_event.m.Bought = 3;
						return "GG";
					}
				},
				{
					Text = "Гоблин Персонаж + Книга Умений",
					function getResult( _event )
					{
						_event.m.Bought = 4;
						return "GG";
					}
				},
				{
					Text = "Нежить Персонаж + Книга Умений",
					function getResult( _event )
					{
						_event.m.Bought = 5;
						return "GG";
					}
				},
				{
					Text = "[color=#04c949]Продолжить[/color]",
					function getResult( _event )
					{
						return "apage2";
					}

				}
			],
			function start( _event )
			{
			}
		});

		this.m.Screens.push({
			ID = "apage2",
			Text = "[img]gfx/ui/events/event_62.png[/img]{Мир — опасное место. Разбойники и грабители устраивают засады у дорог, дикие звери бродят по тёмным лесам, а племена орков неспокойны на границах цивилизации. Ходят слухи даже о том, что действует тёмная магия — мёртвые восстают из могил и снова ходят. Есть много возможностей заработать хорошие деньги, будь то выполнение контрактов, которые можно найти в деревнях и городах по всей земле, или самостоятельные вылазки для исследования и грабежа. \n\n[color=#56e64c]Выберите своего персонажа-аватара[/color]}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Баку Персонаж + Книга Умений",
					function getResult( _event )
					{
						_event.m.Bought = 6;
						return "GG";
					}
				},
				{
					Text = "Эльф Персонаж + Книга Умений",
					function getResult( _event )
					{
						_event.m.Bought = 7;
						return "GG";
					}
				},
				{
					Text = "Лизардмен Персонаж + Книга Умений",
					function getResult( _event )
					{
						_event.m.Bought = 8;
						return "GG";
					}
				},
				{
					Text = "Случайный Персонаж + Книга Умений",
					function getResult( _event )
					{
						_event.m.Bought = 100;
						return "GG";
					}
				},
				{
					Text = "[color=#04c949]Продолжить[/color]",
					function getResult( _event )
					{
						return "apage3";
					}

				}
			],
			function start( _event )
			{
			}
		});

		this.m.Screens.push({
			ID = "apage3",
			Text = "[img]gfx/ui/events/event_62.png[/img]{Мир — опасное место. Разбойники и грабители устраивают засады у дорог, дикие звери бродят по тёмным лесам, а племена орков неспокойны на границах цивилизации. Ходят слухи даже о том, что действует тёмная магия — мёртвые восстают из могил и снова ходят. Есть много возможностей заработать хорошие деньги, будь то выполнение контрактов, которые можно найти в деревнях и городах по всей земле, или самостоятельные вылазки для исследования и грабежа. \n\n[color=#56e64c]Выберите своего персонажа-аватара[/color]}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Королевских кровей(avatar) + Королевская Стража",
					function getResult( _event )
					{
						_event.m.Bought = 101;
						return "GG";
					}
				},
				{
					Text = "Паладин(avatar) + 2 Крестоносца",
					function getResult( _event )
					{
						_event.m.Bought = 102;
						return "GG";
					}
				},
				{
					Text = "Случайный Персонаж + 3 Книги Умений",
					function getResult( _event )
					{
						_event.m.Bought = 200;
						return "GG";
					}
				},
				{
					Text = "12 Персонажей с разными бэкграундами",
					function getResult( _event )
					{
						return "bpage1";
					}
				},
				{
					Text = "Test (cheat)",
					function getResult( _event )
					{
//						this.World.Assets.getStash().add(this.new("scripts/items/weapons/xxtorch"));
//						this.World.Assets.getStash().add(this.new("scripts/items/weapons/xxcestus"));
//						this.World.Assets.getStash().add(this.new("scripts/items/weapons/xxcestusb"));
//						this.World.Assets.getStash().add(this.new("scripts/items/weapons/xxarcanespear"));
//						this.World.Assets.getStash().add(this.new("scripts/items/weapons/xxbamboospear"));
//						this.World.Assets.getStash().add(this.new("scripts/items/weapons/xxkusarigama"));
//						this.World.Assets.getStash().add(this.new("scripts/items/weapons/xxrifle"));
//						this.World.Assets.getStash().add(this.new("scripts/items/weapons/xxdeadbook"));
//						this.World.Assets.getStash().add(this.new("scripts/items/weapons/xxringblade"));
//						this.World.Assets.getStash().add(this.new("scripts/items/weapons/xxnodachi"));
//						this.World.Assets.getStash().add(this.new("scripts/items/weapons/xxruneblade"));
//						this.World.Assets.getStash().add(this.new("scripts/items/weapons/xxkatar"));
//						this.World.Assets.getStash().add(this.new("scripts/items/weapons/xxdragonsw"));
//						this.World.Assets.getStash().add(this.new("scripts/items/weapons/xxmeteor"));
//						this.World.Assets.getStash().add(this.new("scripts/items/weapons/xxmstaff"));
//						this.World.Assets.getStash().add(this.new("scripts/items/weapons/xxlefts"));
//						this.World.Assets.getStash().add(this.new("scripts/items/weapons/xxshuriken"));
//						this.World.Assets.getStash().add(this.new("scripts/items/weapons/xxheavylance"));
//						this.World.Assets.getStash().add(this.new("scripts/items/weapons/xxmagicstaff"));
//						this.World.Assets.getStash().add(this.new("scripts/items/weapons/legendary/obsidian_dagger"));
//						this.World.Assets.getStash().add(this.new("scripts/items/shields/xxhorse_shield"));
//						this.World.Assets.getStash().add(this.new("scripts/items/shields/xxheavyhorse_shield"));
//						this.World.Assets.getStash().add(this.new("scripts/items/weapons/named/xxcrosslance"));
//						this.World.Assets.getStash().add(this.new("scripts/items/weapons/named/xxorc_flail_two_handed"));
//						this.World.Assets.getStash().add(this.new("scripts/items/weapons/named/xxorc_axe_two_handed"));
//						this.World.Assets.getStash().add(this.new("scripts/items/weapons/named/xxscythe"));
//						this.World.Assets.getStash().add(this.new("scripts/items/ammo/legendary/xxuquiver"));
//						this.World.Assets.getStash().add(this.new("scripts/items/accessory/xxsilvertrophy"));
//						this.World.Assets.getStash().add(this.new("scripts/items/accessory/xxgoldtrophy"));
//						this.World.Assets.getStash().add(this.new("scripts/items/accessory/xxdefring"));
//						this.World.Assets.getStash().add(this.new("scripts/items/accessory/xxatkring"));
//						this.World.Assets.getStash().add(this.new("scripts/items/accessory/xxbloodring"));
//						this.World.Assets.getStash().add(this.new("scripts/items/accessory/xx_potion_nice"));
//						this.World.Assets.getStash().add(this.new("scripts/items/helmets/xxhat_hairband"));
//						this.World.Assets.getStash().add(this.new("scripts/items/helmets/xxhat_hunshat"));
//						this.World.Assets.getStash().add(this.new("scripts/items/helmets/xxhat_hunshelm"));
//						this.World.Assets.getStash().add(this.new("scripts/items/helmets/xxhat_hwaranghat"));
//						this.World.Assets.getStash().add(this.new("scripts/items/helmets/xxhat_kasa"));
//						this.World.Assets.getStash().add(this.new("scripts/items/helmets/xxhat_samurai"));
//						this.World.Assets.getStash().add(this.new("scripts/items/helmets/xxknighthelm"));
//						this.World.Assets.getStash().add(this.new("scripts/items/armor/xxdress"));
//						this.World.Assets.getStash().add(this.new("scripts/items/armor/xxmonkrobe"));
//						this.World.Assets.getStash().add(this.new("scripts/items/armor/xxsamuraiarmor"));
//						this.World.Assets.getStash().add(this.new("scripts/items/armor/xxwokoulightarmor"));
//						this.World.Assets.getStash().add(this.new("scripts/items/misc/xxsbook"));
//						this.World.Assets.getStash().add(this.new("scripts/items/misc/xxsbook"));
//						this.World.Assets.getStash().add(this.new("scripts/items/misc/xxsbook"));
//						this.World.Assets.getStash().add(this.new("scripts/items/misc/xxsbook"));
//						this.World.Assets.getStash().add(this.new("scripts/items/misc/xxsbook_se"));
//						this.World.Assets.getStash().add(this.new("scripts/items/misc/xxsbook_se"));
//						this.World.Assets.getStash().add(this.new("scripts/items/misc/xxsbook_se"));
//						this.World.Assets.getStash().add(this.new("scripts/items/misc/xxsbook_se"));
//						this.World.Assets.getStash().add(this.new("scripts/items/misc/xxchaospotion"));
//						this.World.Assets.getStash().add(this.new("scripts/items/misc/xxchaospotion"));
//						this.World.Assets.getStash().add(this.new("scripts/items/misc/xxchaospotion"));
//						this.World.Assets.getStash().add(this.new("scripts/items/misc/xxchaospotion"));
//						this.World.Assets.getStash().add(this.new("scripts/items/misc/xxu_armor"));
//						this.World.Assets.getStash().add(this.new("scripts/items/misc/xxu_armor"));
//						this.World.Assets.getStash().add(this.new("scripts/items/misc/xxu_armor"));
//						this.World.Assets.getStash().add(this.new("scripts/items/misc/xxu_helmet"));
//						this.World.Assets.getStash().add(this.new("scripts/items/misc/xxu_helmet"));
//						this.World.Assets.getStash().add(this.new("scripts/items/misc/xxu_helmet"));
//						this.World.Assets.getStash().add(this.new("scripts/items/misc/xxu_weapon"));
//						this.World.Assets.getStash().add(this.new("scripts/items/misc/xxu_weapon"));
//						this.World.Assets.getStash().add(this.new("scripts/items/misc/xxu_weapon"));
//						this.World.Assets.getStash().add(this.new("scripts/items/misc/xx11_lvlpotion"));
//						this.World.Assets.getStash().add(this.new("scripts/items/misc/xx11_lvlpotion"));
//						this.World.Assets.getStash().add(this.new("scripts/items/misc/xxmysteriouspotion"));
//						this.World.Assets.getStash().add(this.new("scripts/items/misc/xxmysteriouspotion"));
//						this.World.Assets.getStash().add(this.new("scripts/items/misc/xxreputation"));
//						this.World.Assets.getStash().add(this.new("scripts/items/misc/xxreputation"));
//						this.World.Assets.getStash().add(this.new("scripts/items/misc/xxlimitpotion"));
//						this.World.Assets.getStash().add(this.new("scripts/items/misc/xxlimitpotion"));
						this.World.Assets.getStash().add(this.new("scripts/items/weapons/named/named_goblin_pike"));
						this.World.Assets.getStash().add(this.new("scripts/items/weapons/greenskins/orc_javelin"));
						this.World.Assets.getStash().add(this.new("scripts/items/weapons/lute"));
						this.World.Assets.getStash().add(this.new("scripts/items/armor_upgrades/boar_hide_upgrade"));
						this.World.Assets.getStash().add(this.new("scripts/items/armor_upgrades/leather_shoulderguards_upgrade"));
						this.World.Assets.getStash().add(this.new("scripts/items/armor_upgrades/leather_shoulderguards_upgrade"));
						this.World.Assets.getStash().add(this.new("scripts/items/armor_upgrades/metal_pauldrons_upgrade"));
						this.World.Assets.getStash().add(this.new("scripts/items/armor_upgrades/metal_pauldrons_upgrade"));
						this.World.Assets.getStash().add(this.new("scripts/items/tools/bear_trap_item"));
						this.World.Assets.getStash().add(this.new("scripts/items/armor_upgrades/lion_hide_upgrade"));
						this.World.Assets.getStash().add(this.new("scripts/items/armor_upgrades/tiger_hide_upgrade"));
						this.World.Assets.getStash().add(this.new("scripts/items/armor/named/named_wushi_armor02"));
						this.World.Assets.getStash().add(this.new("scripts/items/armor/named/named_wushi_armor08"));
						this.World.Assets.getStash().add(this.new("scripts/items/armor/named/named_wushi_armor09"));
						this.World.Assets.getStash().add(this.new("scripts/items/armor/named/named_wushi_armor10"));
						this.World.Assets.getStash().add(this.new("scripts/items/armor/named/named_wushi_armor11"));
						this.World.Assets.getStash().add(this.new("scripts/items/armor/named/named_wushi_armor12"));
						this.World.Assets.getStash().add(this.new("scripts/items/armor/named/named_wushi_armor13"));
						this.World.Assets.getStash().add(this.new("scripts/items/armor/named/named_wushi_armor14"));
						this.World.Assets.getStash().add(this.new("scripts/items/armor/named/named_wushi_armor16"));
						this.World.Assets.getStash().add(this.new("scripts/items/armor/named/named_wushi_armor17"));
						this.World.Assets.getStash().add(this.new("scripts/items/armor/wushi_armor03"));
						this.World.Assets.getStash().add(this.new("scripts/items/armor/wushi_armor04"));
						this.World.Assets.getStash().add(this.new("scripts/items/armor/wushi_armor05"));
						this.World.Assets.getStash().add(this.new("scripts/items/armor/wushi_armor06"));
						this.World.Assets.getStash().add(this.new("scripts/items/armor/wushi_armor07"));
						this.World.Assets.getStash().add(this.new("scripts/items/armor/wushi_armor15"));
						this.World.Assets.getStash().add(this.new("scripts/items/armor/wushi_armor18"));
						this.World.Assets.getStash().add(this.new("scripts/items/armor/wushi_armor19"));
						this.World.Assets.getStash().add(this.new("scripts/items/armor/wushi_armor20"));
						this.World.Assets.getStash().add(this.new("scripts/items/helmets/named/named_wushi_helmet02"));
						this.World.Assets.getStash().add(this.new("scripts/items/helmets/named/named_wushi_helmet08"));
						this.World.Assets.getStash().add(this.new("scripts/items/helmets/named/named_wushi_helmet10"));
						this.World.Assets.getStash().add(this.new("scripts/items/helmets/named/named_wushi_helmet12"));
						this.World.Assets.getStash().add(this.new("scripts/items/helmets/named/named_wushi_helmet18"));
						this.World.Assets.getStash().add(this.new("scripts/items/helmets/named/named_wushi_helmet19"));
						this.World.Assets.getStash().add(this.new("scripts/items/helmets/named/named_wushi_helmet20"));
						this.World.Assets.getStash().add(this.new("scripts/items/helmets/named/named_wushi_helmet21"));
						this.World.Assets.getStash().add(this.new("scripts/items/helmets/named/named_wushi_helmet22"));
						this.World.Assets.getStash().add(this.new("scripts/items/helmets/wushi_helmet03"));
						this.World.Assets.getStash().add(this.new("scripts/items/helmets/wushi_helmet04"));
						this.World.Assets.getStash().add(this.new("scripts/items/helmets/wushi_helmet05"));
						this.World.Assets.getStash().add(this.new("scripts/items/helmets/wushi_helmet06"));
						this.World.Assets.getStash().add(this.new("scripts/items/helmets/wushi_helmet07"));
						this.World.Assets.getStash().add(this.new("scripts/items/helmets/wushi_helmet09"));
						this.World.Assets.getStash().add(this.new("scripts/items/helmets/wushi_helmet11"));
						this.World.Assets.getStash().add(this.new("scripts/items/helmets/wushi_helmet13"));
						this.World.Assets.getStash().add(this.new("scripts/items/helmets/wushi_helmet14"));
						this.World.Assets.getStash().add(this.new("scripts/items/helmets/wushi_helmet15"));
						this.World.Assets.getStash().add(this.new("scripts/items/helmets/wushi_helmet16"));
						this.World.Assets.getStash().add(this.new("scripts/items/helmets/wushi_helmet17"));
						this.World.Assets.getStash().add(this.new("scripts/items/helmets/wushi_helmet23"));
						this.World.Assets.getStash().add(this.new("scripts/items/helmets/wushi_helmet24"));
						this.World.Assets.getStash().add(this.new("scripts/items/accessory/sacrificial_collar_item"));
						local roster = this.World.getPlayerRoster();
						local xxlonexx;
						xxlonexx = roster.create("scripts/entity/tactical/player");
						xxlonexx.setStartValuesEx([
							"xxherocrimson_background"
						]);
						xxlonexx.getSkills().removeByID("trait.survivor");
						xxlonexx.getSkills().removeByID("trait.greedy");
						xxlonexx.getSkills().removeByID("trait.loyal");
						xxlonexx.getSkills().removeByID("trait.disloyal");
						xxlonexx.getSkills().add(this.new("scripts/skills/traits/player_character_trait"));
						xxlonexx.setPlaceInFormation(4);
						xxlonexx.getFlags().set("IsPlayerCharacter", true);
						xxlonexx.m.HireTime = this.Time.getVirtualTimeF();
						xxlonexx.m.PerkPoints = 1;
						xxlonexx.m.LevelUps = 1;
						xxlonexx.m.Level = 2;
						xxlonexx.getBaseProperties().Hitpoints += 1;
						xxlonexx.getBaseProperties().Bravery += 1;
						xxlonexx.getBaseProperties().Stamina += 1;
						xxlonexx.getBaseProperties().MeleeSkill += 1;
						xxlonexx.getBaseProperties().RangedSkill += 1;
						xxlonexx.getBaseProperties().MeleeDefense += 1;
						xxlonexx.getBaseProperties().RangedDefense += 1;
						xxlonexx.getBaseProperties().Initiative += 1;
						xxlonexx.m.Talents = [];
						xxlonexx.m.Attributes = [];
						local talents = xxlonexx.getTalents();
						talents.resize(this.Const.Attributes.COUNT, 0);
						talents[this.Const.Attributes.Hitpoints] = 3;
						talents[this.Const.Attributes.Bravery] = 3;
						talents[this.Const.Attributes.Fatigue] = 3;
						talents[this.Const.Attributes.MeleeSkill] = 3;
						talents[this.Const.Attributes.RangedSkill] = 3;
						talents[this.Const.Attributes.MeleeDefense] = 2;
						talents[this.Const.Attributes.RangedDefense] = 2;
						talents[this.Const.Attributes.Initiative] = 3;
						xxlonexx.fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);

						xxlonexx = roster.create("scripts/entity/tactical/player");
						xxlonexx.setStartValuesEx([
							"xxherohighelf_background"
						]);
						xxlonexx = roster.create("scripts/entity/tactical/player");
						xxlonexx.setStartValuesEx([
							"xxheroroyal_background"
						]);
						xxlonexx = roster.create("scripts/entity/tactical/player");
						xxlonexx.setStartValuesEx([
							"xxheroroc_background"
						]);

						xxlonexx = roster.create("scripts/entity/tactical/player");
						xxlonexx.setStartValuesEx([
							"xxhero_male_background"
						]);
						xxlonexx.getSkills().add(this.new("scripts/skills/actives/sb_firebomb_skill"));
						xxlonexx.getSkills().add(this.new("scripts/skills/actives/sb_waterbomb_skill"));
						xxlonexx.getSkills().add(this.new("scripts/skills/actives/sb_rain_skill"));
						xxlonexx.getSkills().add(this.new("scripts/skills/actives/sb_demon_skill"));

						xxlonexx = roster.create("scripts/entity/tactical/player");
						xxlonexx.setStartValuesEx([
							"xxhero_female_background"
						]);
						xxlonexx.getSkills().add(this.new("scripts/skills/actives/sb_firebomb_skill"));
						xxlonexx.getSkills().add(this.new("scripts/skills/actives/sb_waterbomb_skill"));
						xxlonexx.getSkills().add(this.new("scripts/skills/actives/sb_rain_skill"));
						xxlonexx.getSkills().add(this.new("scripts/skills/actives/sb_demon_skill"));

//						xxlonexx = roster.create("scripts/entity/tactical/player");
//						xxlonexx.setStartValuesEx([
//							"xxi_female_background"
//						]);
						xxlonexx = roster.create("scripts/entity/tactical/player");
						xxlonexx.setStartValuesEx([
							"vp_demon_background"
						]);
						xxlonexx.m.PerkPoints = 10;
						xxlonexx.m.LevelUps = 10;
						xxlonexx.m.Level = 11;
						xxlonexx = roster.create("scripts/entity/tactical/player");
						xxlonexx.setStartValuesEx([
							"druid_background"
						]);
						xxlonexx.m.PerkPoints = 8;
						xxlonexx.m.LevelUps = 8;
						xxlonexx.m.Level = 9;
						xxlonexx = roster.create("scripts/entity/tactical/player");
						xxlonexx.setStartValuesEx([
							"vp_vestal_background"
						]);
						xxlonexx.m.PerkPoints = 8;
						xxlonexx.m.LevelUps = 8;
						xxlonexx.m.Level = 9;
						xxlonexx = roster.create("scripts/entity/tactical/player");
						xxlonexx.setStartValuesEx([
							"vp_electro_background"
						]);
						xxlonexx = roster.create("scripts/entity/tactical/player");
						xxlonexx.setStartValuesEx([
							"xxhero_baku_background"
						]);
						xxlonexx = roster.create("scripts/entity/tactical/player");
						xxlonexx.setStartValuesEx([
							"xxhero_undead_background"
						]);

						local xxbrothers = this.World.getPlayerRoster().getAll();
						foreach(zxz in xxbrothers)
						{
							zxz.m.HireTime = this.Time.getVirtualTimeF();
							if (zxz.getBackground().getID() == "background.beggar")
							{
								zxz.setName("DummyStarter");
								if (this.Const.DLC.Desert)
								{
									zxz.getSkills().onDeath(this.Const.FatalityType.None);
								}
								this.World.getPlayerRoster().remove(zxz);
								break;
							}
						}
						return 0;
					}
				},
				{
					Text = "[color=#04c949]Продолжить[/color]",
					function getResult( _event )
					{
						return "apage1";
					}

				}
			],
			function start( _event )
			{
			}
		});

		this.m.Screens.push({
			ID = "GG",
			Text = "[img]gfx/ui/events/event_74.png[/img]{Think carefully and act wisely to survive in this wild and dangerous world. Good luck. \n\n[color=#56e64c]The game is over when the avatar character dies.[/color]}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Start",
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
				local hero_type = [
					"xxhero_male_background",
					"xxhero_female_background",
					"xxhero_elf_background",
					"xxhero_undead_background",
					"xxhero_baku_background",
					"xxhero_orc_background",
					"xxhero_goblin_background",
					"xxhero_lizard_background"
				];
				if (_event.m.Bought == 1)
				{
					xxlonexx.setStartValuesEx([
						"xxhero_male_background"
					]);

					// === Тестовый суперотряд: аватар + 11 бойцов, 13 уровень, именная экипировка ===
					local horde_bgs = [
						"xxhero_female_background",
						"xxhero_elf_background",
						"xxhero_undead_background",
						"xxhero_baku_background",
						"xxhero_orc_background",
						"xxhero_goblin_background",
						"xxhero_lizard_background",
						"xxherocrimson_background",
						"xxherohighelf_background",
						"xxheroroyal_background",
						"xxheroroc_background"
					];
					local horde_bros = [xxlonexx];
					foreach (bg in horde_bgs)
					{
						local b = roster.create("scripts/entity/tactical/player");
						b.setStartValuesEx([
							bg
						]);
						horde_bros.push(b);
					}

					// роли: 0-5 — щит/одноручное, 6-7 — двуручники, 8 — биллхук, 9-10 — лучники, 11 — арбалетчик
					local horde_oh = ["named_sword", "named_mace", "named_axe", "named_warhammer", "named_cleaver", "named_khopesh"];
					local horde_sh = ["named_full_metal_heater_shield", "named_lindwurm_shield", "named_wing_shield", "named_bandit_kite_shield", "named_dragon_shield", "named_sipar_shield"];
					local horde_th = ["named_greataxe", "named_greatsword", "named_billhook"];
					local horde_ar = ["black_and_gold_armor", "lindwurm_armor", "green_coat_of_plates_armor", "named_golden_lamellar_armor"];
					local horde_hm = ["lindwurm_helmet", "named_nordic_helmet_with_closed_mail", "wolf_helmet", "golden_feathers_helmet", "named_steppe_helmet_with_mail", "heraldic_mail_helmet"];

					foreach (idx, b in horde_bros)
					{
						b.getSkills().removeByID("trait.survivor");
						b.getSkills().removeByID("trait.greedy");
						b.getSkills().removeByID("trait.loyal");
						b.getSkills().removeByID("trait.disloyal");
						b.getSkills().add(this.new("scripts/skills/traits/player_character_trait"));
						b.m.HireTime = this.Time.getVirtualTimeF();
						b.m.Level = 13;
						b.m.LevelUps = 0;
						b.m.PerkPoints = 0;
						local bp = b.getBaseProperties();
						bp.Hitpoints += 30;
						bp.Bravery += 20;
						bp.Stamina += 30;
						bp.MeleeSkill += 20;
						bp.RangedSkill += 20;
						bp.MeleeDefense += 15;
						bp.RangedDefense += 15;
						b.m.Talents = [];
						b.m.Attributes = [];
						local talents = b.getTalents();
						talents.resize(this.Const.Attributes.COUNT, 0);
						talents[this.Const.Attributes.Hitpoints] = 3;
						talents[this.Const.Attributes.Bravery] = 3;
						talents[this.Const.Attributes.Fatigue] = 3;
						talents[this.Const.Attributes.MeleeSkill] = 3;
						talents[this.Const.Attributes.RangedSkill] = 3;
						talents[this.Const.Attributes.MeleeDefense] = 3;
						talents[this.Const.Attributes.RangedDefense] = 3;
						talents[this.Const.Attributes.Initiative] = 3;
						b.fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);

						local horde_perks;
						if (idx <= 5)
							horde_perks = ["perk_colossus", "perk_adrenalin", "perk_recover", "perk_steel_brow", "perk_hold_out", "perk_battle_forged", "perk_shield_expert", "perk_berserk", "perk_killing_frenzy", "perk_pathfinder"];
						else if (idx <= 7)
							horde_perks = ["perk_colossus", "perk_adrenalin", "perk_recover", "perk_steel_brow", "perk_hold_out", "perk_battle_forged", "perk_berserk", "perk_killing_frenzy", "perk_reach_advantage", "perk_pathfinder"];
						else if (idx == 8)
							horde_perks = ["perk_colossus", "perk_adrenalin", "perk_recover", "perk_steel_brow", "perk_hold_out", "perk_battle_forged", "perk_mastery_polearm", "perk_killing_frenzy", "perk_overwhelm", "perk_pathfinder"];
						else if (idx <= 10)
							horde_perks = ["perk_colossus", "perk_anticipation", "perk_dodge", "perk_relentless", "perk_adrenalin", "perk_recover", "perk_mastery_bow", "perk_bullseye", "perk_pathfinder", "perk_nine_lives"];
						else
							horde_perks = ["perk_colossus", "perk_anticipation", "perk_dodge", "perk_relentless", "perk_adrenalin", "perk_recover", "perk_mastery_crossbow", "perk_bullseye", "perk_pathfinder", "perk_nine_lives"];
						foreach (p in horde_perks)
							b.getSkills().add(this.new("scripts/skills/perks/" + p));

						local items = b.getItems();
						items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Body));
						items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Head));
						items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
						items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Offhand));
						items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Ammo));
						items.equip(this.new("scripts/items/armor/named/" + horde_ar[idx % horde_ar.len()]));
						items.equip(this.new("scripts/items/helmets/named/" + horde_hm[idx % horde_hm.len()]));
						if (idx <= 5)
						{
							items.equip(this.new("scripts/items/weapons/named/" + horde_oh[idx]));
							items.equip(this.new("scripts/items/shields/named/" + horde_sh[idx]));
						}
						else if (idx <= 8)
						{
							items.equip(this.new("scripts/items/weapons/named/" + horde_th[idx - 6]));
						}
						else if (idx <= 10)
						{
							items.equip(this.new("scripts/items/weapons/named/named_warbow"));
							items.equip(this.new("scripts/items/ammo/large_quiver_of_arrows"));
						}
						else
						{
							items.equip(this.new("scripts/items/weapons/named/named_crossbow"));
							items.equip(this.new("scripts/items/ammo/large_quiver_of_bolts"));
						}
					}

					xxlonexx.setPlaceInFormation(4);
					xxlonexx.getFlags().set("IsPlayerCharacter", true);

					local xxbrothers = this.World.getPlayerRoster().getAll();
					foreach(zxz in xxbrothers)
					{
						if (zxz.getBackground().getID() == "background.beggar")
						{
							zxz.setName("DummyStarter");
							if (this.Const.DLC.Desert)
							{
								zxz.getSkills().onDeath(this.Const.FatalityType.None);
							}
							this.World.getPlayerRoster().remove(zxz);
							break;
						}
					}
					this.World.Assets.getStash().add(this.new("scripts/items/misc/xxsbook_se"));
					return 0;
				}
				else if (_event.m.Bought == 2)
				{
					xxlonexx.setStartValuesEx([
						"xxhero_female_background"
					]);
				}
				else if (_event.m.Bought == 3)
				{
					xxlonexx.setStartValuesEx([
						"xxhero_orc_background"
					]);
				}
				else if (_event.m.Bought == 4)
				{
					xxlonexx.setStartValuesEx([
						"xxhero_goblin_background"
					]);
				}
				else if (_event.m.Bought == 5)
				{
					xxlonexx.setStartValuesEx([
						"xxhero_undead_background"
					]);
				}
				else if (_event.m.Bought == 6)
				{
					xxlonexx.setStartValuesEx([
						"xxhero_baku_background"
					]);
				}
				else if (_event.m.Bought == 7)
				{
					xxlonexx.setStartValuesEx([
						"xxhero_elf_background"
					]);
				}
				else if (_event.m.Bought == 8)
				{
					xxlonexx.setStartValuesEx([
						"xxhero_lizard_background"
					]);
				}
				else if (_event.m.Bought == 101)
				{
					xxlonexx.setStartValuesEx([
						"squire_background"
					]);
					xxlonexx.m.Talents = [];
					xxlonexx.m.Attributes = [];
					xxlonexx.setPlaceInFormation(5);
					xxlonexx.m.HireTime = this.Time.getVirtualTimeF();
					xxlonexx.m.PerkPoints = 0;
					xxlonexx.m.LevelUps = 0;
					xxlonexx.m.Level = 1;
					local talentss = xxlonexx.getTalents();
					talentss.resize(this.Const.Attributes.COUNT, 0);
					talentss[this.Const.Attributes.Hitpoints] = 3;
					talentss[this.Const.Attributes.Bravery] = 3;
					talentss[this.Const.Attributes.Fatigue] = 3;
					talentss[this.Const.Attributes.MeleeSkill] = 3;
					talentss[this.Const.Attributes.RangedSkill] = 3;
					talentss[this.Const.Attributes.MeleeDefense] = 3;
					talentss[this.Const.Attributes.RangedDefense] = 3;
					talentss[this.Const.Attributes.Initiative] = 3;
					xxlonexx.fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
					local items = xxlonexx.getItems();
					items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Body));
					items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Head));
					items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
					items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Offhand));
					items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Ammo));
					items.equip(this.new("scripts/items/armor/mail_hauberk"));
					items.equip(this.new("scripts/items/weapons/shortsword"));
					xxlonexx.setTitle("Royal Guard");
					xxlonexx.getBackground().m.RawDescription = "As a seasoned and highly-trained Royal Guard, %name% has devoted his life to safeguarding the royal family, carrying out his duties with poise and unwavering loyalty.";
					xxlonexx.getBackground().buildDescription(true);

					xxlonexx = roster.create("scripts/entity/tactical/player")
					xxlonexx.setStartValuesEx([
						"xxheroroyal_background"
					]);
				}
				else if (_event.m.Bought == 102)
				{
					xxlonexx.setStartValuesEx([
						"monk_background"
					]);
					xxlonexx.m.Talents = [];
					xxlonexx.m.Attributes = [];
					xxlonexx.setPlaceInFormation(3);
					xxlonexx.m.HireTime = this.Time.getVirtualTimeF();
					xxlonexx.m.PerkPoints = 0;
					xxlonexx.m.LevelUps = 0;
					xxlonexx.m.Level = 1;
					local talentss = xxlonexx.getTalents();
					talentss.resize(this.Const.Attributes.COUNT, 0);
					talentss[this.Const.Attributes.Hitpoints] = 3;
					talentss[this.Const.Attributes.Bravery] = 3;
					talentss[this.Const.Attributes.Fatigue] = 3;
					talentss[this.Const.Attributes.MeleeSkill] = 3;
					talentss[this.Const.Attributes.RangedSkill] = 3;
					talentss[this.Const.Attributes.MeleeDefense] = 3;
					talentss[this.Const.Attributes.RangedDefense] = 3;
					talentss[this.Const.Attributes.Initiative] = 3;
					xxlonexx.getBaseProperties().RangedSkill += 15;
					xxlonexx.getBaseProperties().MeleeSkill += 9;
					xxlonexx.fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
					xxlonexx.getSkills().add(this.new("scripts/skills/actives/sb_pincer_skill"));
					xxlonexx.getSkills().add(this.new("scripts/skills/actives/sb_holyspear_skill"));
					local items = xxlonexx.getItems();
					items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Body));
					items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Head));
					items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
					items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Offhand));
					items.equip(this.new("scripts/items/armor/patched_mail_shirt"));
					items.equip(this.new("scripts/items/helmets/rusty_mail_coif"));
					items.equip(this.new("scripts/items/weapons/militia_spear"));
					items.equip(this.new("scripts/items/shields/wooden_shield_old"));
					xxlonexx.getFlags().increment("xxSkillBookTraining", 9999989);
					xxlonexx.setTitle("Templar");

					xxlonexx = roster.create("scripts/entity/tactical/player")
					xxlonexx.setStartValuesEx([
						"monk_background"
					]);
					xxlonexx.m.Talents = [];
					xxlonexx.m.Attributes = [];
					xxlonexx.setPlaceInFormation(5);
					xxlonexx.m.HireTime = this.Time.getVirtualTimeF();
					xxlonexx.m.PerkPoints = 0;
					xxlonexx.m.LevelUps = 0;
					xxlonexx.m.Level = 1;
					local talentss = xxlonexx.getTalents();
					talentss.resize(this.Const.Attributes.COUNT, 0);
					talentss[this.Const.Attributes.Hitpoints] = 3;
					talentss[this.Const.Attributes.Bravery] = 3;
					talentss[this.Const.Attributes.Fatigue] = 3;
					talentss[this.Const.Attributes.MeleeSkill] = 3;
					talentss[this.Const.Attributes.RangedSkill] = 3;
					talentss[this.Const.Attributes.MeleeDefense] = 3;
					talentss[this.Const.Attributes.RangedDefense] = 3;
					talentss[this.Const.Attributes.Initiative] = 3;
					xxlonexx.getBaseProperties().RangedSkill += 15;
					xxlonexx.getBaseProperties().MeleeSkill += 9;
					xxlonexx.fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
					xxlonexx.getSkills().add(this.new("scripts/skills/actives/sb_pincer_skill"));
					xxlonexx.getSkills().add(this.new("scripts/skills/actives/sb_holyspear_skill"));
					items = xxlonexx.getItems();
					items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Body));
					items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Head));
					items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
					items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Offhand));
					items.equip(this.new("scripts/items/armor/patched_mail_shirt"));
					items.equip(this.new("scripts/items/helmets/rusty_mail_coif"));
					items.equip(this.new("scripts/items/weapons/militia_spear"));
					items.equip(this.new("scripts/items/shields/wooden_shield_old"));
					xxlonexx.getFlags().increment("xxSkillBookTraining", 9999989);
					xxlonexx.setTitle("Templar");

					xxlonexx = roster.create("scripts/entity/tactical/player")
					xxlonexx.setStartValuesEx([
						"monk_background"
					]);
					xxlonexx.getSkills().add(this.new("scripts/skills/actives/sb_pincer_skill"));
					xxlonexx.getSkills().add(this.new("scripts/skills/actives/sb_holyspear_skill"));
					xxlonexx.getSkills().add(this.new("scripts/skills/actives/sb_command_skill"));
					items = xxlonexx.getItems();
					items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Body));
					items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Head));
					items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
					items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Offhand));
					items.equip(this.new("scripts/items/armor/basic_mail_shirt"));
					items.equip(this.new("scripts/items/helmets/mail_coif"));
					items.equip(this.new("scripts/items/weapons/militia_spear"));
					items.equip(this.new("scripts/items/shields/wooden_shield"));
					xxlonexx.getFlags().increment("xxSkillBookTraining", 9999989);
					xxlonexx.setTitle("Holy Knight");
					xxlonexx.getBackground().m.RawDescription = "True to their sacred oath, %name% the Holy Knight charges forward with a noble purpose, ready to face any foe that threatens to snuff out the justice.";
					xxlonexx.getBackground().buildDescription(true);
					xxlonexx.getBaseProperties().RangedSkill += 15;
					xxlonexx.getBaseProperties().MeleeSkill += 9;
				}
				else
				{
					xxlonexx.setStartValuesEx([
						hero_type[this.Math.rand(0, hero_type.len() - 1)]
					]);
				}
				xxlonexx.getSkills().removeByID("trait.survivor");
				xxlonexx.getSkills().removeByID("trait.greedy");
				xxlonexx.getSkills().removeByID("trait.loyal");
				xxlonexx.getSkills().removeByID("trait.disloyal");
				xxlonexx.getSkills().add(this.new("scripts/skills/traits/player_character_trait"));
				xxlonexx.setPlaceInFormation(4);
				xxlonexx.getFlags().set("IsPlayerCharacter", true);
				xxlonexx.m.HireTime = this.Time.getVirtualTimeF();
				xxlonexx.m.PerkPoints = 1;
				xxlonexx.m.LevelUps = 1;
				xxlonexx.m.Level = 2;
				xxlonexx.getBaseProperties().MeleeDefense -= 1;
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
				local xxbrothers = this.World.getPlayerRoster().getAll();
				foreach(zxz in xxbrothers)
				{
					if (zxz.getBackground().getID() == "background.beggar")
					{
						zxz.setName("DummyStarter");
						if (this.Const.DLC.Desert)
						{
							zxz.getSkills().onDeath(this.Const.FatalityType.None);
						}
						this.World.getPlayerRoster().remove(zxz);
						break;
					}
				}
				if (_event.m.Bought <= 100)
				{
					this.World.Assets.getStash().add(this.new("scripts/items/misc/xxsbook_se"));
				}
				else if (_event.m.Bought == 200)
				{
					this.World.Assets.getStash().add(this.new("scripts/items/misc/xxsbook_se"));
					this.World.Assets.getStash().add(this.new("scripts/items/misc/xxsbook_se"));
					this.World.Assets.getStash().add(this.new("scripts/items/misc/xxsbook_se"));
				}
				return 0;
			}
		});

		this.m.Screens.push({
			ID = "bpage1",
			Text = "[img]gfx/ui/events/event_78.png[/img]{The world is a dangerous place. Robbers and pillagers lay in ambush by the roads, wild beasts roam the dark forests and orc tribes are restless beyond the boundaries of civilization. There are rumors even of dark magic being at work, the dead rising from their graves and walking again. There is plenty of opportunity to earn good money, whether by taking on contracts you can find in the villages and cities all over the land, or by venturing out on your own to explore and raid. \n\n[color=#56e64c]Choose a background for your mercenaries[/color]}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Male",
					function getResult( _event )
					{
						_event.m.Bought = 1;
						return "GX";
					}
				},
				{
					Text = "Female",
					function getResult( _event )
					{
						_event.m.Bought = 2;
						return "GX";
					}
				},
				{
					Text = "Orc",
					function getResult( _event )
					{
						_event.m.Bought = 3;
						return "GX";
					}
				},
				{
					Text = "Goblin",
					function getResult( _event )
					{
						_event.m.Bought = 4;
						return "GX";
					}
				},
				{
					Text = "Undead",
					function getResult( _event )
					{
						_event.m.Bought = 5;
						return "GX";
					}
				},
				{
					Text = "[color=#04c949]Next Page[/color]",
					function getResult( _event )
					{
						return "bpage2";
					}

				}
			],
			function start( _event )
			{
			}
		});

		this.m.Screens.push({
			ID = "bpage2",
			Text = "[img]gfx/ui/events/event_78.png[/img]{The world is a dangerous place. Robbers and pillagers lay in ambush by the roads, wild beasts roam the dark forests and orc tribes are restless beyond the boundaries of civilization. There are rumors even of dark magic being at work, the dead rising from their graves and walking again. There is plenty of opportunity to earn good money, whether by taking on contracts you can find in the villages and cities all over the land, or by venturing out on your own to explore and raid. \n\n[color=#56e64c]Choose a background for your mercenaries[/color]}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Baku",
					function getResult( _event )
					{
						_event.m.Bought = 6;
						return "GX";
					}
				},
				{
					Text = "Elf",
					function getResult( _event )
					{
						_event.m.Bought = 7;
						return "GX";
					}
				},
				{
					Text = "Lizardman",
					function getResult( _event )
					{
						_event.m.Bought = 8;
						return "GX";
					}
				},
				{
					Text = "Back to single avatar selection",
					function getResult( _event )
					{
						return "apage1";
					}

				},
				{
					Text = "[color=#04c949]Next Page[/color]",
					function getResult( _event )
					{
						return "bpage1";
					}

				}
			],
			function start( _event )
			{
			}
		});

		this.m.Screens.push({
			ID = "GX",
			Text = "[img]gfx/ui/events/event_74.png[/img]{Think carefully and act wisely to survive in this wild and dangerous world. Good luck. \n\n[color=#56e64c]The game ends when all 12 starting members die.[/color]}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Start",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getPlayerRoster();
				local brotype;
				if (_event.m.Bought == 1)
				{
					brotype = "xxhero_male_background";
				}
				else if (_event.m.Bought == 2)
				{
					brotype = "xxhero_female_background";
				}
				else if (_event.m.Bought == 3)
				{
					brotype = "xxhero_orc_background";
				}
				else if (_event.m.Bought == 4)
				{
					brotype = "xxhero_goblin_background";
				}
				else if (_event.m.Bought == 5)
				{
					brotype = "xxhero_undead_background";
				}
				else if (_event.m.Bought == 6)
				{
					brotype = "xxhero_baku_background";
				}
				else if (_event.m.Bought == 8)
				{
					brotype = "xxhero_lizard_background";
				}
				else
				{
					brotype = "xxhero_elf_background";
				}

				local xxbro;
				for( local i = 0; i < 12; i = ++i )
				{
					xxbro = roster.create("scripts/entity/tactical/player");
					xxbro.m.HireTime = this.Time.getVirtualTimeF();
					xxbro.setStartValuesEx([
						brotype
					]);
					xxbro.getSkills().removeByID("trait.greedy");
					xxbro.getSkills().removeByID("trait.loyal");
					xxbro.getSkills().removeByID("trait.disloyal");
					xxbro.getSkills().add(this.new("scripts/skills/traits/player_character_trait"));
					xxbro.getFlags().set("IsPlayerCharacter", true);
				}

				local xxbrothers = this.World.getPlayerRoster().getAll();
				foreach(zxz in xxbrothers)
				{
					if (zxz.getBackground().getID() == "background.beggar")
					{
						zxz.setName("DummyStarter");
						if (this.Const.DLC.Desert)
						{
							zxz.getSkills().onDeath(this.Const.FatalityType.None);
						}
						this.World.getPlayerRoster().remove(zxz);
						break;
					}
				}
				return 0;
			}
		});
	}

	function onDetermineStartScreen()
	{
		return "apage1";
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "The " + this.World.Assets.getName();
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}
});

