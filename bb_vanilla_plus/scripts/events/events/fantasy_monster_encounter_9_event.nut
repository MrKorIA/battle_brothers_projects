this.fantasy_monster_encounter_9_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.fantasy_monster_encounter_9_event";
		this.m.Title = "Неожиданное события...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_36.png[/img]{Вы остановились перед небольшой, но ухоженной могилой. Судя по цветам, оставленным людьми, это, похоже, была могила кого-то очень уважаемого. На надгробном камне была высечена следующая надпись.%SPEECH_ON%Здесь покоится безымянный воин, пожертвовавший собой, чтобы спасти многих.%SPEECH_OFF%Вы вспомнили, что слышали об этой могиле раньше. Говорили, что это место упокоения доблестного воина, который пожертвовал своей жизнью, сражаясь со злом, чтобы защитить жизни других. Колдун, который был его товарищем, наложил заклятие на могилу, чтобы грабители не могли бездумно потревожить ее.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Раскопайте могилу в поисках предмета",
					function getResult( _event )
					{
						return "B";
					}
				},
				{
					Text = "Оставьте могилу в покое.",
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
			ID = "B",
			Text = "[img]gfx/ui/events/event_12.png[/img]{В конце раскопок гробницы вы обнаружили артефакт, которым когда-то владел воин. Однако, когда вы его извлекли, вас окружил тревожный туман. Может быть, в гробнице действительно таится проклятие?}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "У меня плохое предчувствие...",
					function getResult( _event )
					{
						return 0;
					}
				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();
				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 20)
					{
						if (!bro.getFlags().get("IsPlayerCharacter") && !bro.getSkills().hasSkill("trait.player") && this.Math.rand(1, 100) <= 9)
						{
							local fallen = {
								Name = bro.getName(),
								Time = this.World.getTime().Days,
								TimeWithCompany = this.Math.max(1, bro.getDaysWithCompany()),
								Kills = bro.getLifetimeStats().Kills,
								Battles = bro.getLifetimeStats().Battles,
								KilledBy = "Died suddenly",
								Expendable = false
							};
							this.World.Statistics.addFallen(fallen);
							this.List.push({
								id = 10,
								icon = "ui/icons/kills.png",
								text = bro.getName() + " умер"
							});
							bro.getItems().transferToStash(this.World.Assets.getStash());
							bro.getSkills().onDeath(this.Const.FatalityType.None);
							this.World.getPlayerRoster().remove(bro);
						}
						else
						{
							local injury = bro.addInjury(this.Const.Injury.Accident1);
							this.List.push({
								id = 10,
								icon = injury.getIcon(),
								text = bro.getName() + " страдает от " + injury.getNameOnly()
							});
							bro.addLightInjury();
						}
					}
				}

				local items = this.World.Assets.getStash().getItems();
				local noitem = true;
				local candidates = [];
				foreach( item in items )
				{
					if (item == null)
					{
						continue;
					}
					if (item.isItemType(this.Const.Items.ItemType.Legendary) || item.isIndestructible())
					{
						continue;
					}
					if (item.isItemType(this.Const.Items.ItemType.Weapon) || item.isItemType(this.Const.Items.ItemType.Shield) || item.isItemType(this.Const.Items.ItemType.Armor) || item.isItemType(this.Const.Items.ItemType.Helmet))
					{
						candidates.push(item);
						noitem = false;
					}
				}
				if (!noitem && this.Math.rand(1, 100) <= 20)
				{
					local iitem = candidates[this.Math.rand(0, candidates.len() - 1)];
					this.World.Assets.getStash().remove(iitem);
					this.List.push({
						id = 11,
						icon = "ui/items/" + iitem.getIcon(),
						text = "Вы проиграли " + this.Const.Strings.getArticle(iitem.getName()) + iitem.getName()
					});
				}

				if (this.World.Assets.getMoney() >= 100 && this.Math.rand(1, 100) <= 20)
				{
					local rr = this.Math.floor(this.World.Assets.getMoney() / 2);
					if (rr >= 10000)
					{
						rr = 10000;
					}
					this.World.Assets.addMoney(-rr);
					this.List.push({
						id = 12,
						icon = "ui/items/supplies/money.png",
						text = "Вы потеряли. " + rr + " золота"
					});
				}

				local weapons = [
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
					weapons.extend([
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
				local item = this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 15,
					icon = "ui/items/" + item.getIcon(),
					text = "Вы получаете "  + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}
		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 50)
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

