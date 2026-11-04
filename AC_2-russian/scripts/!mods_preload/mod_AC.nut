::mods_registerMod("mod_AC", 2.1, "Accessory Companions (fixed by hackflow)");
::mods_queue("mod_AC", null, function()
{
	if (::mods_getRegisteredMod("stupid_game")) {
		this.Const.Companions.TameChance.Default *= 5;
		this.Const.Companions.TameChance.Beastmaster *= 5;
	}

	///// extends maximum tooltip height in order to fit companion details and makes sure long tooltips don't go outside of the window
	if (!::mods_getRegisteredMod("mod_nested_tooltips")) {
		::mods_registerCSS("companions_tooltip.css");
		::mods_registerJS("companions_tooltip.js");
	}


	///// make companions heal their wounds at the same time as brothers heal theirs
	::mods_hookNewObject("states/world/asset_manager", function(o)
	{
		local update = o.update;
		o.update = function(_worldState)
		{
			if (this.World.getTime().Hours != this.m.LastHourUpdated && this.m.IsConsumingAssets)
			{
				local roster = this.World.getPlayerRoster().getAll();
				foreach(bro in roster)
				{
					local acc = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
					if (acc != null && "setType" in acc)
					{
						if (acc.getType() != null && acc.m.Wounds > 0)
						{
							acc.m.Wounds = this.Math.max(0, this.Math.floor(acc.m.Wounds - 2));
						}
					}
				}

				local stash = this.World.Assets.getStash().getItems();
				foreach(item in stash)
				{
					if (item != null && item.getItemType() == this.Const.Items.ItemType.Accessory && "setType" in item)
					{
						if (item.getType() != null && item.m.Wounds > 0)
						{
							item.m.Wounds = this.Math.max(0, this.Math.floor(item.m.Wounds - 2));
						}
					}
				}
			}

			update(_worldState);
		}
	});


	///// hide the Beastmaster background within the Houndmaster background
	::mods_hookNewObject("skills/backgrounds/houndmaster_background", function(o)
	{
		o.applyBeastmasterModification <- function()
		{
			this.m.ID = "background.companions_beastmaster";
			this.m.Name = "Зверолов";
			this.m.Icon = "ui/backgrounds/background_beastmaster_ac.png";
			this.m.BackgroundDescription = "Зверолов обучает разнообразных чудищ.";
			this.m.GoodEnding = "Хотя %name% и был звероловом, он никогда не считал чудищ животными. По его словам, они были самыми верными друзьями в его жизни. Покинув отряд, он открыл гениальный способ разводить зверей, соответствующих пожеланиям дворян. Хотите огромного сторожевого зверя? Пожалуйста! Хотите маленьких и милых зверюшек на радость детям? Легко! Бывший наёмник сейчас зарабатывает баснословные деньги, занимаясь своим любимыми делом - работой со зверьми.";
			this.m.BadEnding = "%name% всегда относился к зверям с уважением и любовью, считая их лучшими друзьями. Покинув отряд, он устроился работать на псарню к одному из дворян. К несчастью, он так и не смог смириться с тем, что его питомцев использовали в битвах в качестве расходного материала для достижения кратковременного преимущества, и был повешен за 'вольнодумство'.";
			this.m.HiringCost = 100;
			this.m.DailyCost = 21;
			this.m.Excluded = [
				"trait.fear_beasts",
				"trait.hate_beasts",
				"trait.craven",
				"trait.dastard",
				"trait.fainthearted",
				"trait.insecure",
				"trait.ailing",
				"trait.bleeder",
				"trait.tiny",
				"trait.fragile",
				"trait.asthmatic",
				"trait.clubfooted",
				"trait.clumsy",
				"trait.cocky"
			];
			this.m.ExcludedTalents = [
				this.Const.Attributes.RangedSkill,
				this.Const.Attributes.RangedDefense
			];
			this.m.Titles = [
				"Зверолов",
				"Укротитель"
			];
			this.m.Faces = this.Const.Faces.AllMale;
			this.m.Hairs = this.Const.Hair.UntidyMale;
			this.m.HairColors = this.Const.HairColors.All;
			this.m.Beards = this.Const.Beards.Untidy;
			this.m.Bodies = this.Const.Bodies.AllMale;
			this.m.IsLowborn = false;
			this.m.Level = this.Math.rand(1, 3);
		}

		local getTooltip = o.getTooltip;
		o.getTooltip = function()
		{
			local tooltip = getTooltip();
			if (tooltip.len() >= 3)
			{
				if (tooltip[0].text == this.getName() && tooltip[1].text == this.getDescription() && tooltip[2].id == 14)
				{
					tooltip[2].text = "Чудища, спущенные с поводка этим персонажем, начнут бой с высоким боевым духом.";
					tooltip.insert(3, {id = 4, type = "text", icon = "ui/icons/xp_received.png", text = "Чудища, управляемые этим персонажем, получают больше опыта."});

					if (this.m.ID == "background.companions_beastmaster")
					{
						tooltip.insert(4, {id = 5, type = "text", icon = "ui/icons/special.png", text = "Повышенные шансы на успех при укрощении зверей."});
					}
				}
				else
				{
					this.logInfo("mod_AC: Исходные индексы советов о зверолове уже изменены или перемещены в другие позиции другим модом?");
				}
			}
			else
			{
				this.logInfo("mod_AC: Размер советов о зверолове уменьшен ниже исходного другим модом?");
			}

			return tooltip;
		}

		local onBuildDescription = o.onBuildDescription;
		o.onBuildDescription = function()
		{
			if (this.m.ID == "background.companions_beastmaster")
			{
				return "{%name% увлёкся чудищами с тех пор, как его отец выиграл змею в соревнованиях по стрельбе. | После того как лютоволк спас его от медведя, %name% посвятил свою жизнь чудищам. | Когда %name% увидел, как сетеплёт отвадил воришку, его привязанность к чудищам только возросла. | Ещё будучи молодым охотником на птиц, %name% заметил, что чудищам присущи честь, верность и мастерство. | После укуса дикой гиены, %name% смог победить свой страх перед чудищами и научился дрессировать их.} {Он провёл много лет на псарне, работая на местного дворянина. А ушёл он оттуда, после того как его господин сразил одного из его зверей ради развлечения. | Быстро поднатаскав своих чудищ, псарь отправил их на выставку, сулившую неплохие барыши. | Он сделал большие деньги на боях чудищ, ведь его питомцы хорошо слушались хозяина и были весьма свирепы, стоило только спустить их с привязи. | Работая на стражу, он использовал чуткие носы своих чудищ для поимки множества преступников. | Многие его чудища сражались за местного дворянина на поле боя. | Его чудища на протяжении многих лет развлекали детей-сирот и калек.} {Но теперь %name% стремится сменить род занятий. | Услышав о том, сколько зарабатывают наёмники, %name% решил испытать свои силы в качестве вольного клинка. | Пообщавшись с наёмником, купившим одного из его чудищ, %name% задумался о том, чтобы самому стать вольным клинком. | Устав натаскивать чудищ для той или иной цели, %name% решил натаскать самого себя... в той или иной области. | Очень перспективный кандидат: вы надеетесь, что %name% научился верности и преданности у чудищ, которых когда-то натаскивал.}";
			}
			else
			{
				return onBuildDescription();
			}
		}

		local onChangeAttributes = o.onChangeAttributes;
		o.onChangeAttributes = function()
		{
			if (this.m.ID == "background.companions_beastmaster")
			{
				local c = {
					Hitpoints = [10, 5],
					Bravery = [10, 10],
					Stamina = [10, 5],
					MeleeSkill = [0, 0],
					RangedSkill = [0, 0],
					MeleeDefense = [6, 6],
					RangedDefense = [0, 0],
					Initiative = [10, 5]
				};
				return c;
			}
			else
			{
				return onChangeAttributes();
			}
		}

		local onAddEquipment = o.onAddEquipment;
		o.onAddEquipment = function()
		{
			if (this.m.ID == "background.companions_beastmaster")
			{
				local items = this.getContainer().getActor().getItems();

				///// mainhand
				local r = this.Math.rand(1, 3);
				if (r == 1)
				{
					local rr;
					if (this.Const.DLC.Wildmen)
					{
						rr = this.Math.rand(1, 2);
					}
					else
					{
						rr = this.Math.rand(1, 1);
					}

					if (rr == 1)
					{
						items.equip(this.new("scripts/items/weapons/battle_whip"));
					}
					else if (rr == 2)
					{
						items.equip(this.new("scripts/items/weapons/barbarians/thorned_whip"));
					}
				}
				else
				{
					local rr;
					if (this.Const.DLC.Wildmen)
					{
						rr = this.Math.rand(1, 20);
					}
					else
					{
						rr = this.Math.rand(1, 15);
					}

					if (rr == 1)
					{
						items.equip(this.new("scripts/items/weapons/dagger"));
					}
					else if (rr == 2)
					{
						items.equip(this.new("scripts/items/weapons/shortsword"));
					}
					else if (rr == 3)
					{
						items.equip(this.new("scripts/items/weapons/falchion"));
					}
					else if (rr == 4)
					{
						items.equip(this.new("scripts/items/weapons/bludgeon"));
					}
					else if (rr == 5)
					{
						items.equip(this.new("scripts/items/weapons/morning_star"));
					}
					else if (rr == 6)
					{
						items.equip(this.new("scripts/items/weapons/militia_spear"));
					}
					else if (rr == 7)
					{
						items.equip(this.new("scripts/items/weapons/boar_spear"));
					}
					else if (rr == 8)
					{
						items.equip(this.new("scripts/items/weapons/hatchet"));
					}
					else if (rr == 9)
					{
						items.equip(this.new("scripts/items/weapons/hand_axe"));
					}
					else if (rr == 10)
					{
						items.equip(this.new("scripts/items/weapons/reinforced_wooden_flail"));
					}
					else if (rr == 11)
					{
						items.equip(this.new("scripts/items/weapons/flail"));
					}
					else if (rr == 12)
					{
						items.equip(this.new("scripts/items/weapons/butchers_cleaver"));
					}
					else if (rr == 13)
					{
						items.equip(this.new("scripts/items/weapons/scramasax"));
					}
					else if (rr == 14)
					{
						items.equip(this.new("scripts/items/weapons/pickaxe"));
					}
					else if (rr == 15)
					{
						items.equip(this.new("scripts/items/weapons/military_pick"));
					}
					else if (rr == 16)
					{
						items.equip(this.new("scripts/items/weapons/barbarians/claw_club"));
					}
					else if (rr == 17)
					{
						items.equip(this.new("scripts/items/weapons/barbarians/crude_axe"));
					}
					else if (rr == 18)
					{
						items.equip(this.new("scripts/items/weapons/barbarians/axehammer"));
					}
					else if (rr == 19)
					{
						items.equip(this.new("scripts/items/weapons/barbarians/antler_cleaver"));
					}
					else if (rr == 20)
					{
						items.equip(this.new("scripts/items/weapons/barbarians/blunt_cleaver"));
					}
				}

				///// offhand
				r = this.Math.rand(1, 3);
				if (r == 1)
				{
					items.equip(this.new("scripts/items/tools/throwing_net"));
				}
				else
				{
					local rr = this.Math.rand(1, 2);
					if (rr == 1)
					{
						items.equip(this.new("scripts/items/shields/buckler_shield"));
					}
					else if (rr == 2)
					{
						items.equip(this.new("scripts/items/shields/wooden_shield"));
					}
				}

				///// helmet
				if (this.Const.DLC.Wildmen)
				{
					r = this.Math.rand(1, 6);
				}
				else
				{
					r = this.Math.rand(1, 4);
				}

				if (r == 1)
				{
					items.equip(this.new("scripts/items/helmets/mouth_piece"));
				}
				else if (r == 2)
				{
					items.equip(this.new("scripts/items/helmets/open_leather_cap"));
				}
				else if (r == 3)
				{
					items.equip(this.new("scripts/items/helmets/full_leather_cap"));
				}
				else if (r == 4)
				{
					items.equip(this.new("scripts/items/helmets/rusty_mail_coif"));
				}
				else if (r == 5)
				{
					items.equip(this.new("scripts/items/helmets/barbarians/leather_headband"));
				}
				else if (r == 6)
				{
					items.equip(this.new("scripts/items/helmets/barbarians/bear_headpiece"));
				}

				///// armor
				if (this.Const.DLC.Wildmen)
				{
					r = this.Math.rand(1, 10);
				}
				else
				{
					r = this.Math.rand(1, 5);
				}

				if (r == 1)
				{
					items.equip(this.new("scripts/items/armor/ragged_surcoat"));
				}
				else if (r == 2)
				{
					items.equip(this.new("scripts/items/armor/blotched_gambeson"));
				}
				else if (r == 3)
				{
					items.equip(this.new("scripts/items/armor/padded_leather"));
				}
				else if (r == 4)
				{
					items.equip(this.new("scripts/items/armor/patched_mail_shirt"));
				}
				else if (r == 5)
				{
					items.equip(this.new("scripts/items/armor/worn_mail_shirt"));
				}
				else if (r == 6)
				{
					items.equip(this.new("scripts/items/armor/barbarians/thick_furs_armor"));
				}
				else if (r == 7)
				{
					items.equip(this.new("scripts/items/armor/barbarians/animal_hide_armor"));
				}
				else if (r == 8)
				{
					items.equip(this.new("scripts/items/armor/barbarians/reinforced_animal_hide_armor"));
				}
				else if (r == 9)
				{
					items.equip(this.new("scripts/items/armor/barbarians/scrap_metal_armor"));
				}
				else if (r == 10)
				{
					items.equip(this.new("scripts/items/armor/barbarians/hide_and_bone_armor"));
				}
			}
			else
			{
				onAddEquipment();
			}
		}

		o.serializeRawDescription <- function()
		{
			if (this.m.ID == "background.companions_beastmaster")
			{
				local cloneRawDescription = this.m.RawDescription;
				local serializedRawDescription = cloneRawDescription + "\nmod_AC=Beastmaster";
				return serializedRawDescription;
			}

			return this.m.RawDescription;
		}

		o.deserializeRawDescription <- function(_rd)
		{
			local nameMod = "\nmod_AC=Beastmaster";
			local findMod = _rd.find(nameMod);
			if (findMod != null)
			{
				local slicedRaw = _rd.slice(0, findMod);
				this.m.RawDescription = slicedRaw;
				this.applyBeastmasterModification();
			}
			else
			{
				this.m.RawDescription = _rd;
			}
		}

		o.onSerialize <- function(_out)
		{
			this.skill.onSerialize(_out);
			_out.writeString(this.m.Description);
			_out.writeString(this.serializeRawDescription());
			_out.writeU8(this.m.Level);
			_out.writeBool(this.m.IsNew);
			_out.writeF32(this.m.DailyCostMult);
		}

		o.onDeserialize <- function(_in )
		{
			this.skill.onDeserialize(_in);
			this.m.Description = _in.readString();
			this.deserializeRawDescription(_in.readString());
			this.m.Level = _in.readU8();
			this.m.IsNew = _in.readBool();

			if (_in.getMetaData().getVersion() >= 39)
			{
				this.m.DailyCostMult = _in.readF32();
			}
			else
			{
				this.m.DailyCostMult = 1.0;
			}
		}
	});


	///// arrays holding Descriptions of various settlements, part of the process to separate Beastmaster and Houndmaster drafting locations
	local BeastmasterSettlementsLarge = [
		// citadels
		"Громадная крепость, которая охраняет военную гавань и окружающие торговые пути. Средоточие власти знати и дом для большого гарнизона.",
		"Огромная каменная крепость, что высится над раздольными равнинами. Средоточие власти знати и дом для большой армии, держащей эту землю в узде.",
		"Крепость, что высится над густыми лесами и держит эту землю в узде.",
		"Эта огромная крепость возведена у крутых гор. Здесь размещён большой гарнизон, держащий эту землю в узде.",
		"Большая крепость, видимая издалека средь бесконечных снегов, служит оплотом против всего, что может прийти с северных земель. Люди стекались под её защиту многие годы, а дома и мастерские в её окрестностях даруют убежище и привлекают купцов, наёмников и искателей приключений с отдалённых земель.",
		"Могучая крепость, что высится над окружающей степью, средоточие власти в этих землях. Она служит домом для сильного гарнизона и предлагает приют путешественникам и наёмникам.",
		"Большая крепость, что высится над окружающей тундрой и защищает обширные и открытые земли. Многие останавливаются здесь, чтобы пополнить запасы, починить вещи и отдохнуть, прежде чем продолжить путь.",

		// cities
		"Большой город, окружённый пышными лугами, садами и полями. Здешние амбары полны до краёв.",
		"Большой портовый город, полагающийся на торговлю и рыболовство, который также служит важным перевалочным пунктом для путешественников, прибывающих на кораблях.",
		"Процветающий город, расположенный рядом с лесом, производящий в основном ценную древесину и оленину.",
		"Большой город далеко на севере. Купцы, путешественники и искатели приключений приходят сюда, чтобы укрыться от снега и штормов.",
		"Большой город в южной степи, что процветает благодаря торговле и искусствам.",
		"Множество маленьких поселений, раскинувшихся по клочкам сухой земли на болотах, образуют небольшой город.",
		"Большой город, окружённый бесплодной тундрой, известен как важный центр торговли и пристанище учёных и художников."
	];
	local BeastmasterSettlementsMedium = [
		// keeps
		"Могучий каменный замок, окружённый лесами, служит опорным пунктом в этих землях.",
		"Каменный замок, что высится над окружающими горами. С его смотровых башен можно заметить врага за много миль.",
		"Каменный замок, что надзирает над дорогами через окружающие болота.",

		// villages
		"Процветающая деревня неподалёку от леса, живущая, главным образом, за счёт торговли лесом и охоты.",
		"Большое поселение у подножия крутых гор. По окрестностям разносятся звуки ударов кирок о камни.",
		"Довольно большое поселение, раскинувшееся по клочкам сухой земли среди болота."
	];
	local HoundmasterSettlementsSmall = [
		// hamlets
		"Деревня, живущая за счет древесины и всего, что предлагает лес.",
		"Небольшое поселение в болотистой местности. Люди, живущие здесь, знают, что такое трудности."
	];


	///// add drafts to select settlements, part of the process to separate Beastmaster and Houndmaster drafting locations
	::mods_hookBaseClass("entity/world/settlement", function(o)
	{
		while(!("updateRoster" in o)) o = o[o.SuperName];
		local updateRoster = o.updateRoster;
		o.updateRoster = function(_force = false)
		{
			if (!this.m.DraftList.find("houndmaster_background"))
			{
				if (BeastmasterSettlementsLarge.find(this.m.Description))
				{
					this.m.DraftList.append("houndmaster_background");
					this.m.DraftList.append("houndmaster_background");
				}
				else if (BeastmasterSettlementsMedium.find(this.m.Description) || HoundmasterSettlementsSmall.find(this.m.Description))
				{
					this.m.DraftList.append("houndmaster_background");
				}
			}

			updateRoster(_force);
		}
	});


	///// give players the ability to tame beasts
	::mods_hookBaseClass("entity/tactical/human", function(o)
	{
		while(!("onInit" in o)) o = o[o.SuperName];
		local onInit = o.onInit;
		o.onInit = function()
		{
			onInit();
			if (this.m.IsControlledByPlayer && !this.getSkills().hasSkill("actives.companions_tame"))
				this.m.Skills.add(this.new("scripts/companions/player/companions_tame"));
		}
	});


	///// necromancers have a chance to drop the Tome of Reanimation when killed, webknecht eggs have a chance to drop a webknecht companion when killed
	::mods_hookBaseClass("entity/tactical/actor", function(o)
	{
		while(!("onDeath" in o)) o = o[o.SuperName];
		local onDeath = o.onDeath;
		o.onDeath = function(_killer, _skill, _tile, _fatalityType)
		{
			onDeath(_killer, _skill, _tile, _fatalityType);
			if ((this.m.Type == this.Const.EntityType.Necromancer || this.m.Type == this.Const.EntityType.SpiderEggs) && (_killer == null || _killer.getFaction() == this.Const.Faction.Player || _killer.getFaction() == this.Const.Faction.PlayerAnimals))
			{
				if (this.Math.rand(1, 1000) <= this.Const.Companions.TameChance.Default)
				{
					local type;
					if (this.m.Type == this.Const.EntityType.Necromancer)
					{
						type = this.Const.Companions.TypeList.TomeReanimation;
					}
					else if (this.m.Type == this.Const.EntityType.SpiderEggs)
					{
						type = this.Const.Companions.TypeList.Spider;
					}
					else
					{
						type = this.Const.Companions.TypeList.Wardog;
					}

					local matchNum = 0;
					local size = this.Tactical.getMapSize();
					for( local x = 0; x < size.X; x = ++x )
					{
						for( local y = 0; y < size.Y; y = ++y )
						{
							local tile = this.Tactical.getTileSquare(x, y);
							if (tile.IsContainingItems)
							{
								foreach( item in tile.Items )
								{
									if (item != null && item.getItemType() == this.Const.Items.ItemType.Accessory && "setType" in item)
									{
										if (item.getType() == type)
											++matchNum;
									}
								}
							}
						}
					}

					local stash = this.World.Assets.getStash().getItems();
					foreach(item in stash)
					{
						if (item != null && item.getItemType() == this.Const.Items.ItemType.Accessory && "setType" in item)
						{
							if (item.getType() == type)
								++matchNum;
						}
					}

					local brothers = this.World.getPlayerRoster().getAll();
					foreach(bro in brothers)
					{
						local acc = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
						if (acc != null && "setType" in acc)
						{
							if (acc.getType() == type)
								++matchNum;
						}
					}

					if (matchNum < this.Const.Companions.Library[type].MaxPerCompany)
					{
						local loot = this.new("scripts/items/accessory/wardog_item");
						loot.setType(type);
						loot.updateCompanion();
						loot.drop(_tile);
					}
				}
			}
		}
	});


	///// give companions experience when the player kills something, turn a newly drafted Houndmaster into a Beastmaster if drafted settlement is of "Beastmaster-type"
	::mods_hookNewObject("entity/tactical/player", function(o)
	{
		if (!("mod_AC" in o))
		{
			o.mod_AC <- true;
			local onActorKilled = o.onActorKilled;
			o.onActorKilled = function(_actor, _tile, _skill)
			{
				onActorKilled(_actor, _tile, _skill);
				local XPkiller = this.Math.floor(_actor.getXPValue() * this.Const.XP.XPForKillerPct);
				local XPgroup = _actor.getXPValue() * (1.0 - this.Const.XP.XPForKillerPct);
				local brothers = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);
				foreach(bro in brothers)
				{
					local cAcc = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
					if (cAcc != null && "setType" in cAcc)
					{
						if (cAcc.getType() != null)
							cAcc.addXP(this.Math.max(1, this.Math.floor(XPgroup / brothers.len())));
					}
				}

				local kAcc = this.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
				if (kAcc != null && "setType" in kAcc)
				{
					if (kAcc.getType() != null)
						kAcc.addXP(XPkiller);
				}
			}
		}

		local setStartValuesEx = o.setStartValuesEx;
		o.setStartValuesEx = function(_backgrounds, _addTraits = true)
		{
			setStartValuesEx(_backgrounds, _addTraits);
			if (this.m.Background.m.ID == "background.houndmaster" && this.World.State.getCurrentTown() != null && (BeastmasterSettlementsLarge.find(this.World.State.getCurrentTown().m.Description) || BeastmasterSettlementsMedium.find(this.World.State.getCurrentTown().m.Description)))
			{
				this.m.Background = null;
				this.m.Title = "";
				this.m.Talents = [];
				this.m.Items.clear();

				local remove = this.m.Skills.query(this.Const.SkillType.Background);
				foreach(r in remove)
				{
					if (r.getID() != "special.mood_check" && r.getID() != "special.VA11") // prevents removal of the "Mood Check" skill and mod_VA11's skill
						this.m.Skills.removeByID(r.getID());
				}
				remove = this.m.Skills.query(this.Const.SkillType.Trait);
				foreach(r in remove)
				{
					if (r.getID() != "special.mood_check" && r.getID() != "special.VA11") // prevents removal of the "Mood Check" skill and mod_VA11's skill
						this.m.Skills.removeByID(r.getID());
				}

				local background = this.new("scripts/skills/backgrounds/houndmaster_background");
				background.applyBeastmasterModification();
				this.m.Skills.add(background);
				this.m.Background = background;
				this.m.Ethnicity = this.m.Background.getEthnicity();
				background.buildAttributes();
				background.buildDescription();

				if (_addTraits)
				{
					local maxTraits = this.Math.rand(this.Math.rand(0, 1) == 0 ? 0 : 1, 2);
					local traits = [
						background
					];

					for( local i = 0; i < maxTraits; i = ++i )
					{
						for( local j = 0; j < 10; j = ++j )
						{
							local trait = this.Const.CharacterTraits[this.Math.rand(0, this.Const.CharacterTraits.len() - 1)];
							local nextTrait = false;

							for( local k = 0; k < traits.len(); k = ++k )
							{
								if (traits[k].getID() == trait[0] || traits[k].isExcluded(trait[0]))
								{
									nextTrait = true;
									break;
								}
							}

							if (!nextTrait)
							{
								traits.push(this.new(trait[1]));
								break;
							}
						}
					}

					for( local i = 1; i < traits.len(); i = ++i )
					{
						this.m.Skills.add(traits[i]);

						if (traits[i].getContainer() != null)
						{
							traits[i].addTitle();
						}
					}
				}

				background.addEquipment();
				background.setAppearance();
				background.buildDescription(true);
				this.m.Skills.update();
				local p = this.m.CurrentProperties;
				this.m.Hitpoints = p.Hitpoints;

				if (_addTraits)
				{
					this.fillTalentValues();
					this.fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
				}
			}
		}
	});


	///// make reanimated zombies grant the company experience when they kill something
	::mods_hookBaseClass("entity/tactical/enemies/zombie", function(o)
	{
		if (!("mod_AC" in o))
		{
			o.mod_AC <- true;
			if ("onActorKilled" in o)
			{
				local onActorKilled = o.onActorKilled;
				o.onActorKilled <- function(_actor, _tile, _skill)
				{
					if (this.getFaction() == this.Const.Faction.Player || this.getFaction() == this.Const.Faction.PlayerAnimals)
					{
						local XPgroup = _actor.getXPValue();
						local brothers = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);
						foreach( bro in brothers )
						{
							bro.addXP(this.Math.max(1, this.Math.floor(XPgroup / brothers.len())));

							local acc = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
							if (acc != null && "setType" in acc)
							{
								if (acc.getType() != null)
									acc.addXP(this.Math.max(1, this.Math.floor(XPgroup / brothers.len())));
							}
						}
					}
					onActorKilled(_actor, _tile, _skill);
				}
			}
			else
			{
				o.onActorKilled <- function(_actor, _tile, _skill)
				{
					if (this.getFaction() == this.Const.Faction.Player || this.getFaction() == this.Const.Faction.PlayerAnimals)
					{
						local XPgroup = _actor.getXPValue();
						local brothers = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);
						foreach( bro in brothers )
						{
							bro.addXP(this.Math.max(1, this.Math.floor(XPgroup / brothers.len())));

							local acc = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
							if (acc != null && "setType" in acc)
							{
								if (acc.getType() != null)
									acc.addXP(this.Math.max(1, this.Math.floor(XPgroup / brothers.len())));
							}
						}
					}
					this.actor.onActorKilled(_actor, _tile, _skill);
				}
			}
		}
	});


	///// make reanimated skeletons grant the company experience when they kill something
	::mods_hookBaseClass("entity/tactical/skeleton", function(o)
	{
		if (!("mod_AC" in o))
		{
			o.mod_AC <- true;
			if ("onActorKilled" in o)
			{
				local onActorKilled = o.onActorKilled;
				o.onActorKilled <- function(_actor, _tile, _skill)
				{
					if (this.getFaction() == this.Const.Faction.Player || this.getFaction() == this.Const.Faction.PlayerAnimals)
					{
						local XPgroup = _actor.getXPValue();
						local brothers = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);
						foreach( bro in brothers )
						{
							bro.addXP(this.Math.max(1, this.Math.floor(XPgroup / brothers.len())));

							local acc = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
							if (acc != null && "setType" in acc)
							{
								if (acc.getType() != null)
									acc.addXP(this.Math.max(1, this.Math.floor(XPgroup / brothers.len())));
							}
						}
					}
					onActorKilled(_actor, _tile, _skill);
				}
			}
			else
			{
				o.onActorKilled <- function(_actor, _tile, _skill)
				{
					if (this.getFaction() == this.Const.Faction.Player || this.getFaction() == this.Const.Faction.PlayerAnimals)
					{
						local XPgroup = _actor.getXPValue();
						local brothers = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);
						foreach( bro in brothers )
						{
							bro.addXP(this.Math.max(1, this.Math.floor(XPgroup / brothers.len())));

							local acc = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
							if (acc != null && "setType" in acc)
							{
								if (acc.getType() != null)
									acc.addXP(this.Math.max(1, this.Math.floor(XPgroup / brothers.len())));
							}
						}
					}
					this.actor.onActorKilled(_actor, _tile, _skill);
				}
			}
		}
	});


	///// equipped companions add to player party strength
	::mods_hookNewObject("entity/world/player_party", function(o)
	{
		if (!("mod_AC" in o))
		{
			o.mod_AC <- true;
			local updateStrength = o.updateStrength;
			o.updateStrength = function()
			{
				updateStrength();
				local company = this.World.getPlayerRoster().getAll();
				if (company.len() > this.World.Assets.getBrothersScaleMax())
				{
					company.sort(this.onLevelCompare);
				}

				foreach( i, bro in company )
				{
					if (i >= this.World.Assets.getBrothersScaleMax())
					{
						break;
					}

					local companion = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);
					if (companion != null && "setType" in companion)
					{
						this.m.Strength += this.Math.round(companion.m.Level * (this.Const.Companions.Library[companion.getType()].PartyStrength / 8.25));
					}
				}
			}
		}
	});


	///// wardogs and warhounds retain their name, variant, level, XP, attributes and quirks after an armor upgrade
	::mods_hookNewObject("items/misc/wardog_armor_upgrade_item", function(o)
	{
		o.onUse = function(_actor, _item = null)
		{
			local dog = _item == null ? _actor.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory) : _item;
			if (dog == null || !("setType" in dog))
			{
				return false;
			}
			if (dog.getType() != this.Const.Companions.TypeList.Wardog && dog.getType() != this.Const.Companions.TypeList.Warhound)
			{
				return false;
			}

			local new_dog;
			if (dog.getType() == this.Const.Companions.TypeList.Wardog)
			{
				new_dog = this.new("scripts/items/accessory/armored_wardog_item");
				new_dog.setType(this.Const.Companions.TypeList.WardogArmor);
			}
			else
			{
				new_dog = this.new("scripts/items/accessory/armored_warhound_item");
				new_dog.setType(this.Const.Companions.TypeList.WarhoundArmor);
			}

			new_dog.setName(dog.getName());
			new_dog.setVariant(dog.getVariant());
			new_dog.setLevel(dog.getLevel());
			new_dog.setXP(dog.getXP());
			new_dog.setWounds(dog.getWounds());
			new_dog.setAttributes(dog.getAttributes());
			new_dog.setQuirks(dog.getQuirks());
			new_dog.setEntity(dog.getEntity());
			new_dog.updateCompanion();
			_actor.getItems().unequip(dog);
			_actor.getItems().equip(new_dog);
			this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
			return true;
		}
	});


	///// wardogs and warhounds retain their name, variant, level, XP, attributes and quirks after an armor upgrade
	::mods_hookNewObject("items/misc/wardog_heavy_armor_upgrade_item", function(o)
	{
		o.onUse = function(_actor, _item = null)
		{
			local dog = _item == null ? _actor.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory) : _item;
			if (dog == null || !("setType" in dog))
			{
				return false;
			}
			if (dog.getType() != this.Const.Companions.TypeList.Wardog && dog.getType() != this.Const.Companions.TypeList.WardogArmor && dog.getType() != this.Const.Companions.TypeList.Warhound && dog.getType() != this.Const.Companions.TypeList.WarhoundArmor)
			{
				return false;
			}

			local new_dog;
			if (dog.getType() == this.Const.Companions.TypeList.Wardog || dog.getType() == this.Const.Companions.TypeList.WardogArmor)
			{
				new_dog = this.new("scripts/items/accessory/heavily_armored_wardog_item");
				new_dog.setType(this.Const.Companions.TypeList.WardogArmorHeavy);
			}
			else
			{
				new_dog = this.new("scripts/items/accessory/heavily_armored_warhound_item");
				new_dog.setType(this.Const.Companions.TypeList.WarhoundArmorHeavy);
			}

			new_dog.setName(dog.getName());
			new_dog.setVariant(dog.getVariant());
			new_dog.setLevel(dog.getLevel());
			new_dog.setXP(dog.getXP());
			new_dog.setWounds(dog.getWounds());
			new_dog.setAttributes(dog.getAttributes());
			new_dog.setQuirks(dog.getQuirks());
			new_dog.setEntity(dog.getEntity());
			new_dog.updateCompanion();
			_actor.getItems().unequip(dog);
			_actor.getItems().equip(new_dog);
			this.Sound.play("sounds/combat/armor_leather_impact_03.wav", this.Const.Sound.Volume.Inventory);
			return true;
		}
	});


	///// all the good stuff
	local mod_AC_foundation = function(o)
	{
		if ("setEntity" in o)
		{
			o.m.Skill <- null;
			o.m.Entity <- null;
			o.m.Script <- null;
			o.m.ArmorScript <- null;
			o.m.UnleashSounds <- null;
			o.m.InventorySounds <- null;
			o.m.Type <- null;
			o.m.Level <- 1;
			o.m.XP <- 0;
			o.m.Wounds <- 0;
			o.m.Quirks <- [];
			o.m.Attributes <- {	Hitpoints = 0,
								Stamina = 0,
								Bravery = 0,
								Initiative = 0,
								MeleeSkill = 0,
								RangedSkill = 0,
								MeleeDefense = 0,
								RangedDefense = 0	};

			o.create <- function()
			{
				this.accessory.create();
				this.m.SlotType = this.Const.ItemSlot.Accessory;
				this.m.IsDroppedAsLoot = true;
				this.m.IsAllowedInBag = false;
				this.m.ShowOnCharacter = false;
				this.m.IsChangeableInBattle = false;

				if (this.isKindOf(this, "wardog_item"))
				{
					this.m.ID = "accessory.wardog";
					this.setType(this.Const.Companions.TypeList.Wardog);
				}
				if (this.isKindOf(this, "armored_wardog_item"))
				{
					this.m.ID = "accessory.armored_wardog";
					this.setType(this.Const.Companions.TypeList.WardogArmor);
				}
				if (this.isKindOf(this, "heavily_armored_wardog_item"))
				{
					this.m.ID = "accessory.heavily_armored_wardog";
					this.setType(this.Const.Companions.TypeList.WardogArmorHeavy);
				}
				if (this.isKindOf(this, "warhound_item"))
				{
					this.m.ID = "accessory.warhound";
					this.setType(this.Const.Companions.TypeList.Warhound);
				}
				if (this.isKindOf(this, "armored_warhound_item"))
				{
					this.m.ID = "accessory.armored_warhound";
					this.setType(this.Const.Companions.TypeList.WarhoundArmor);
				}
				if (this.isKindOf(this, "heavily_armored_warhound_item"))
				{
					this.m.ID = "accessory.heavily_armored_warhound";
					this.setType(this.Const.Companions.TypeList.WarhoundArmorHeavy);
				}
				if (this.isKindOf(this, "wolf_item"))
				{
					this.m.ID = "accessory.warwolf";
					this.setType(this.Const.Companions.TypeList.Warwolf);
				}
				// This comes from Northern Expansion mod
				if (this.isKindOf(this, "direwolf_item"))
				{
					this.m.ID = "accessory.direwolf";
					this.setType(this.Const.Companions.TypeList.Direwolf);
				}
			}

			o.getType <- function()
			{
				return this.m.Type;
			}

			o.setType <- function(_t)
			{
				this.m.Type = _t;
				this.m.Name = this.Const.Companions.Library[this.m.Type].Name();
				this.m.Variant = this.Const.Companions.Library[this.m.Type].Variant();
				this.m.Attributes.Hitpoints = this.Const.Companions.Library[this.m.Type].BasicAttributes.Hitpoints;
				this.m.Attributes.Stamina = this.Const.Companions.Library[this.m.Type].BasicAttributes.Stamina;
				this.m.Attributes.Bravery = this.Const.Companions.Library[this.m.Type].BasicAttributes.Bravery;
				this.m.Attributes.Initiative = this.Const.Companions.Library[this.m.Type].BasicAttributes.Initiative;
				this.m.Attributes.MeleeSkill = this.Const.Companions.Library[this.m.Type].BasicAttributes.MeleeSkill;
				this.m.Attributes.RangedSkill = this.Const.Companions.Library[this.m.Type].BasicAttributes.RangedSkill;
				this.m.Attributes.MeleeDefense = this.Const.Companions.Library[this.m.Type].BasicAttributes.MeleeDefense;
				this.m.Attributes.RangedDefense = this.Const.Companions.Library[this.m.Type].BasicAttributes.RangedDefense;
				this.m.Quirks = [];
				if (this.Const.Companions.Library[this.m.Type].BasicQuirks.len() != 0)
				{
					foreach(quirk in this.Const.Companions.Library[this.m.Type].BasicQuirks)
					{
						if (this.m.Quirks.find(quirk) == null)
							this.m.Quirks.push(quirk);
					}
				}
				this.updateCompanion();
			}

			o.updateVariant <- function()
			{
			}

			o.updateCompanion <- function()
			{
				this.m.ID = this.Const.Companions.Library[this.m.Type].ID;
				this.m.Description = this.Const.Companions.Library[this.m.Type].Description;
				this.m.Value = this.Math.floor(this.Const.Companions.Library[this.m.Type].Value + ((this.m.Level - 1.00) * (this.Const.Companions.Library[this.m.Type].Value / 65.00)));
				this.m.Script = this.Const.Companions.Library[this.m.Type].Script;
				this.m.ArmorScript = this.Const.Companions.Library[this.m.Type].ArmorScript;
				this.m.UnleashSounds = this.Const.Companions.Library[this.m.Type].UnleashSounds;
				this.m.InventorySounds = this.Const.Companions.Library[this.m.Type].InventorySounds;
				this.setEntity(this.m.Entity);
			}

			o.getEntity <- function()
			{
				return this.m.Entity;
			}

			o.setEntity <- function(_e)
			{
				this.m.Entity = _e;

				if (this.m.Entity == null)
				{
					this.m.Icon = this.Const.Companions.Library[this.m.Type].IconLeashed(this.m.Variant);
				}
				else
				{
					this.m.Icon = this.Const.Companions.Library[this.m.Type].IconUnleashed;
				}
			}

			o.getName <- function()
			{
				if (this.m.Entity == null)
				{
					return this.m.Name;
				}
				else
				{
//					return this.Const.Companions.Library[this.m.Type].NameUnleashed + " (" + this.m.Name + ")";
					return "Поводок питомца " + this.m.Name;
				}
			}

			o.setName <- function(_n)
			{
				this.m.Name = _n;
			}

			o.getDescription <- function()
			{
				if (this.m.Entity == null)
				{
					return this.m.Description;
				}
				else
				{
					return this.Const.Companions.Library[this.m.Type].DescriptionUnleashed;
				}
			}

			o.getScript <- function()
			{
				return this.m.Script;
			}

			o.getArmorScript <- function()
			{
				return this.m.ArmorScript;
			}

			o.playInventorySound <- function(_eventType)
			{
				this.Sound.play(this.m.InventorySounds[this.Math.rand(0, this.m.InventorySounds.len() - 1)], this.Const.Sound.Volume.Inventory);
			}

			o.isUnleashed <- function()
			{
				return this.m.Entity != null;
			}

			o.getTooltip <- function()
			{
				local xpMax = this.m.XP;
				if (this.m.Level < this.Const.LevelXP.len())
					xpMax = this.Const.LevelXP[this.m.Level] - this.Const.LevelXP[this.m.Level - 1];

				local xpText = "МАКС УРОВЕНЬ";
				if (this.m.Level < this.Const.LevelXP.len())
					xpText = this.m.XP + " / " + this.Const.LevelXP[this.m.Level];

				local woundsCalc = (100 - this.m.Wounds);
				if (this.m.Entity != null)
					woundsCalc = this.Math.floor(this.m.Entity.getHitpointsPct() * 100.0);

				local nameText = this.getName() + " ([color=" + this.Const.UI.Color.PositiveValue + "]" + woundsCalc + "%[/color])";
				local levelText = "Уровень " + this.m.Level + ", Здоровье " + woundsCalc + "%";
				if (this.m.Type == this.Const.Companions.TypeList.TomeReanimation)
				{
					nameText = this.getName();
					levelText = "Уровень " + this.m.Level;
				}

				local result = [
					{
						id = 1,
						type = "title",
						text = nameText
					},
					{
						id = 2,
						type = "description",
						text = this.getDescription()
					},
					{
						id = 3,
						type = "text",
						text = this.getValueString()
					},
					{
						id = 4,
						type = "text",
						text = "Размещается в ячейке снаряжения"
					},
					{
						id = 5,
						type = "text",
						text = "Можно использовать в бою"
					},
					{
						id = 6,
						type = "text",
						text = levelText
					},
					{
						id = 7,
						type = "progressbar",
						icon = "ui/icons/xp_received.png",
						value = this.m.XP - this.Const.LevelXP[this.m.Level - 1],
						valueMax = xpMax,
						text = xpText,
						style = "armor-body-slim"
					}
				];

				local aHit = this.m.Attributes.Hitpoints;
				local aFat = this.m.Attributes.Stamina;
				local aRes = this.m.Attributes.Bravery;
				local aIni = this.m.Attributes.Initiative;
				local aMS = this.m.Attributes.MeleeSkill;
				local aRS = this.m.Attributes.RangedSkill;
				local aMD = this.m.Attributes.MeleeDefense;
				local aRD = this.m.Attributes.RangedDefense;

				local bufferHealth;
				local bufferStamina;
				local bufferBravery;
				local bufferInitiative;

				if (aHit < 10 || aFat < 10 || aRes < 10 || aIni < 10)
				{
					bufferHealth = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
					bufferStamina = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
					bufferBravery = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
					bufferInitiative = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
				}
				else
				{
					bufferHealth = "&nbsp;&nbsp;&nbsp;";
					bufferStamina = "&nbsp;&nbsp;&nbsp;";
					bufferBravery = "&nbsp;&nbsp;&nbsp;";
					bufferInitiative = "&nbsp;&nbsp;&nbsp;";

					if (aHit < 100 && aFat < 100 && aRes < 100 && aIni < 100)
					{
						bufferHealth += "&nbsp;&nbsp;";
						bufferStamina += "&nbsp;&nbsp;";
						bufferBravery += "&nbsp;&nbsp;";
						bufferInitiative += "&nbsp;&nbsp;";
					}
				}

				if (aHit < 10)
				{
					bufferHealth += "&nbsp;&nbsp;";
					bufferStamina += "&nbsp;&nbsp;";
					bufferBravery += "&nbsp;&nbsp;";
					bufferInitiative += "&nbsp;&nbsp;";
				}
				else if (aHit >= 10)
				{
					bufferStamina += "&nbsp;&nbsp;";
					bufferBravery += "&nbsp;&nbsp;";
					bufferInitiative += "&nbsp;&nbsp;";

					if (aHit >= 100)
					{
						bufferStamina += "&nbsp;&nbsp;";
						bufferBravery += "&nbsp;&nbsp;";
						bufferInitiative += "&nbsp;&nbsp;";

						if (aHit >= 1000)
						{
							bufferStamina += "&nbsp;&nbsp;";
							bufferBravery += "&nbsp;&nbsp;";
							bufferInitiative += "&nbsp;&nbsp;";
						}
					}
				}
				if (aFat < 10)
				{
					bufferHealth += "&nbsp;&nbsp;";
					bufferStamina += "&nbsp;&nbsp;";
					bufferBravery += "&nbsp;&nbsp;";
					bufferInitiative += "&nbsp;&nbsp;";
				}
				else if (aFat >= 10)
				{
					bufferHealth += "&nbsp;&nbsp;";
					bufferBravery += "&nbsp;&nbsp;";
					bufferInitiative += "&nbsp;&nbsp;";

					if (aFat >= 100)
					{
						bufferHealth += "&nbsp;&nbsp;";
						bufferBravery += "&nbsp;&nbsp;";
						bufferInitiative += "&nbsp;&nbsp;";
					}
				}
				if (aRes < 10)
				{
					bufferHealth += "&nbsp;&nbsp;";
					bufferStamina += "&nbsp;&nbsp;";
					bufferBravery += "&nbsp;&nbsp;";
					bufferInitiative += "&nbsp;&nbsp;";
				}
				else if (aRes >= 10)
				{
					bufferHealth += "&nbsp;&nbsp;";
					bufferStamina += "&nbsp;&nbsp;";
					bufferInitiative += "&nbsp;&nbsp;";

					if (aRes >= 100)
					{
						bufferHealth += "&nbsp;&nbsp;";
						bufferStamina += "&nbsp;&nbsp;";
						bufferInitiative += "&nbsp;&nbsp;";
					}
				}
				if (aIni < 10)
				{
					bufferHealth += "&nbsp;&nbsp;";
					bufferStamina += "&nbsp;&nbsp;";
					bufferBravery += "&nbsp;&nbsp;";
					bufferInitiative += "&nbsp;&nbsp;";
				}
				else if (aIni >= 10)
				{
					bufferHealth += "&nbsp;&nbsp;";
					bufferStamina += "&nbsp;&nbsp;";
					bufferBravery += "&nbsp;&nbsp;";

					if (aIni >= 100)
					{
						bufferHealth += "&nbsp;&nbsp;";
						bufferStamina += "&nbsp;&nbsp;";
						bufferBravery += "&nbsp;&nbsp;";
					}
				}

				local attribs = [
					{
						id = 8,
						type = "text",
						text = this.m.Type == this.Const.Companions.TypeList.TomeReanimation ? "Сила этого заклинания:" : "Базовые атрибуты персонажа:"
					},
					{
						id = 9,
						type = "text",
						text = "[img]gfx/ui/icons/health_ac.png[/img] " + aHit + bufferHealth + "[img]gfx/ui/icons/melee_skill_ac.png[/img] " + aMS + ""
					},
					{
						id = 10,
						type = "text",
						text = "[img]gfx/ui/icons/fatigue_ac.png[/img] " + aFat + bufferStamina + "[img]gfx/ui/icons/ranged_skill_ac.png[/img] " + aRS + ""
					},
					{
						id = 11,
						type = "text",
						text = "[img]gfx/ui/icons/bravery_ac.png[/img] " + aRes + bufferBravery + "[img]gfx/ui/icons/melee_defense_ac.png[/img] " + aMD + ""
					},
					{
						id = 12,
						type = "text",
						text = "[img]gfx/ui/icons/initiative_ac.png[/img] " + aIni + bufferInitiative + "[img]gfx/ui/icons/ranged_defense_ac.png[/img] " + aRD + ""
					}
				];
				result.extend(attribs);

				local quirkString = "";
				local knownQuirks = [];
				if (this.m.Quirks.len() != 0)
				{
					foreach(i, quirk in this.m.Quirks)
					{
						local getQuirk = new(quirk);
						knownQuirks.push(getQuirk.getName());
					}

					knownQuirks.sort();
					foreach(i, quirk in knownQuirks)
					{
						quirkString += quirk;

						if (i < this.m.Quirks.len() - 1)
						{
							quirkString += ", ";
						}
					}
				}

				if (this.m.Quirks.len() != 0)
				{
					result.push({
						id = 13,
						type = "text",
						text = this.m.Type == this.Const.Companions.TypeList.TomeReanimation ? "Дополнительные эффекты:" : "Черты, которыми он обладает:"
					});

					result.push({
						id = 14,
						type = "text",
						icon = "ui/icons/perks.png",
						text = quirkString
					});
				}

				if (this.getIconLarge() != null)
				{
					result.push({
						id = 15,
						type = "image",
						image = this.getIconLarge(),
						isLarge = true
					});
				}
				else
				{
					result.push({
						id = 15,
						type = "image",
						image = this.getIcon()
					});
				}

				return result;
			}

			o.onEquip <- function()
			{
				this.accessory.onEquip();
				local unleash = this.new(this.Const.Companions.Library[this.m.Type].Unleash.Script);
				unleash.setItem(this);
				unleash.applyCompanionModification();
				this.m.Skill = this.WeakTableRef(unleash);
				this.addSkill(unleash);
				local leash = this.new(this.Const.Companions.Library[this.m.Type].Leash.Script);
				leash.setItem(this);
				leash.applyCompanionModification();
				this.addSkill(leash);
			}

			o.onCombatFinished <- function()
			{
				if (this.m.Entity != null)
				{
					this.m.Wounds = this.Math.floor((1.0 - this.m.Entity.getHitpointsPct()) * 100.0);
				}

				this.setEntity(null);
			}

			o.onActorDied <- function(_onTile)
			{
				if (this.m.Type != null && !this.isUnleashed() && _onTile != null && this.getScript() != null && this.Const.Companions.Library[this.m.Type].Unleash.onActorDied)
				{
					local entity = this.Tactical.spawnEntity(this.getScript(), _onTile.Coords.X, _onTile.Coords.Y);
					entity.setItem(this);
					entity.setName(this.getName());
					entity.setVariant(this.getVariant());
					entity.setFaction(this.Const.Faction.PlayerAnimals);
					entity.applyCompanionScaling();
					this.setEntity(entity);

					if (this.getArmorScript() != null)
					{
						local item = this.new(this.getArmorScript());
						entity.getItems().equip(item);
					}

					if (!this.World.getTime().IsDaytime)
					{
						entity.getSkills().add(this.new("scripts/skills/special/night_effect"));
					}

					local healthPercentage = (100.0 - this.m.Wounds) / 100.0;
					entity.setHitpoints(this.Math.max(1, this.Math.floor(healthPercentage * entity.m.Hitpoints)));
					entity.setDirty(true);
					this.Sound.play(this.m.UnleashSounds[this.Math.rand(0, this.m.UnleashSounds.len() - 1)], this.Const.Sound.Volume.Skill, _onTile.Pos);
				}
			}

			o.isAmountShown <- function()
			{
				return true;
			}

			o.getAmountString <- function()
			{
				return "Уровень " + this.m.Level;
			}

			o.getXPToNextLevelPercentage <- function()
			{
				if (this.m.Level >= this.Const.LevelXP.len())
					return "МАКС";

				local tnl = this.Math.floor(((this.m.XP - this.Const.LevelXP[this.m.Level - 1]) / (this.Const.LevelXP[this.m.Level] - this.Const.LevelXP[this.m.Level - 1])) * 100);

				if (tnl > 99)
					tnl = 99;

				return "" + tnl + "%";
			}

			o.addXP <- function(_xp)
			{
				if (this.m.Level >= this.Const.LevelXP.len())
				{
					return;
				}

				_xp = _xp * 0.67;
				_xp = _xp * this.Const.Combat.GlobalXPMult;

				if (this.getContainer() != null && !this.getContainer().isNull() && this.getContainer().getActor() != null && !this.getContainer().getActor().isNull() && this.getContainer().getActor().m.Type == this.Const.EntityType.Player && this.m.Type != this.Const.Companions.TypeList.TomeReanimation)
				{
					local actor = this.getContainer().getActor();
					if (actor.getSkills().hasSkill("background.hackflows_druid"))
					{
						_xp = _xp * (1.2 + (actor.getLevel() / 50.0));
					}
					else if (actor.getSkills().hasSkill("background.companions_beastmaster"))
					{
						_xp = _xp * (1.15 + (actor.getLevel() / 66.667));
					}
					else if (actor.getSkills().hasSkill("background.houndmaster"))
					{
						_xp = _xp * (1.1 + (actor.getLevel() / 100.0));
					}
				}

				if (this.m.Level >= 11)
				{
					_xp = _xp * this.Const.Combat.GlobalXPVeteranLevelMult;
				}

				if (this.m.XP + _xp >= this.Const.LevelXP[this.Const.LevelXP.len() - 1])
				{
					this.m.XP = this.Const.LevelXP[this.Const.LevelXP.len() - 1];
					this.updateLevel();
					return;
				}

				this.m.XP += this.Math.floor(_xp);
				this.updateLevel();
			}

			o.updateLevel <- function()
			{
				local applyAttributeBonus = function(attribute)
				{
					local attributeMin = this.Const.AttributesLevelUp[attribute].Min;
					local attributeMax = this.Const.AttributesLevelUp[attribute].Max;
					local attributeValue = this.m.Level <= 11 ? this.Math.rand(attributeMin, attributeMax) : 1;
					switch (attribute)
					{
						case 0:
							this.m.Attributes.Hitpoints += attributeValue;
							break;
						case 1:
							this.m.Attributes.Bravery += attributeValue;
							break;
						case 2:
							this.m.Attributes.Stamina += attributeValue;
							break;
						case 3:
							this.m.Attributes.Initiative += attributeValue;
							break;
						case 4:
							this.m.Attributes.MeleeSkill += attributeValue;
							break;
						case 5:
							this.m.Attributes.RangedSkill += attributeValue;
							break;
						case 6:
							this.m.Attributes.MeleeDefense += attributeValue;
							break;
						case 7:
							this.m.Attributes.RangedDefense += attributeValue;
							break;
					}
				}

				local availableQuirks = [];
				foreach(quirk in this.Const.Companions.AttainableQuirks)
				{
					if (quirk == "scripts/skills/perks/perk_lone_wolf" && this.m.Type == this.Const.Companions.TypeList.Noodle)
						continue;

					if (this.m.Quirks.find(quirk) == null && availableQuirks.find(quirk) == null)
						availableQuirks.push(quirk);
				}
				foreach(quirk in this.Const.Companions.AttainableQuirksBeasts)
				{
					if (this.m.Type == this.Const.Companions.TypeList.TomeReanimation)
						continue;

					if (this.m.Quirks.find(quirk) == null && availableQuirks.find(quirk) == null)
						availableQuirks.push(quirk);
				}
				if (this.Const.DLC.Unhold)
				{
					foreach(quirk in this.Const.Companions.AttainableQuirksDLCUnhold)
					{
						if (this.m.Quirks.find(quirk) == null && availableQuirks.find(quirk) == null)
							availableQuirks.push(quirk);
					}
				}
				if (this.Const.DLC.Wildmen)
				{
					foreach(quirk in this.Const.Companions.AttainableQuirksDLCWildmen)
					{
						if (this.m.Quirks.find(quirk) == null && availableQuirks.find(quirk) == null)
							availableQuirks.push(quirk);
					}
				}
				if (this.Const.DLC.Desert)
				{
					foreach(quirk in this.Const.Companions.AttainableQuirksDLCDesert)
					{
						if (this.m.Quirks.find(quirk) == null && availableQuirks.find(quirk) == null)
							availableQuirks.push(quirk);
					}
				}

				while (this.m.Level < this.Const.LevelXP.len() && this.m.XP >= this.Const.LevelXP[this.m.Level])
				{
					++this.m.Level;
					this.updateCompanion();
					local attributeArray = [0, 1, 2, 3, 4, 5, 6, 7]; // all attributes
					applyAttributeBonus(this.Const.Companions.Library[this.m.Type].PreferredAttribute);
					attributeArray.remove(this.Const.Companions.Library[this.m.Type].PreferredAttribute);

					local bonusesSpent = 1;
					while (bonusesSpent < 3)
					{
						local randomAttribute = this.Math.rand(0, attributeArray.len() - 1);
						applyAttributeBonus(attributeArray[randomAttribute]);
						attributeArray.remove(randomAttribute);
						++bonusesSpent;
					}
					if (this.m.Level <= 11)
					{
						if (availableQuirks.len() != 0)
						{
							local rng = this.Math.rand(0, availableQuirks.len() - 1);
							this.m.Quirks.push(availableQuirks[rng]);
							availableQuirks.remove(rng);
						}

						if (this.m.Level == 11 && this.m.Type != this.Const.Companions.TypeList.TomeReanimation)
						{
							this.m.Quirks.push("scripts/companions/quirks/companions_good_boy");
						}
					}
				}
			}

			o.getLevel <- function()
			{
				return this.m.Level;
			}

			o.setLevel <- function(_l)
			{
				this.m.Level = _l;
			}

			o.getXP <- function()
			{
				return this.m.XP;
			}

			o.setXP <- function(_xp)
			{
				this.m.XP = _xp;
			}

			o.getQuirks <- function()
			{
				return this.m.Quirks;
			}

			o.setQuirks <- function(_q)
			{
				this.m.Quirks = _q;
			}

			o.getAttributes <- function()
			{
				local attr =
				{
					Hitpoints = this.m.Attributes.Hitpoints,
					Stamina = this.m.Attributes.Stamina,
					Bravery = this.m.Attributes.Bravery,
					Initiative = this.m.Attributes.Initiative,
					MeleeSkill = this.m.Attributes.MeleeSkill,
					RangedSkill = this.m.Attributes.RangedSkill,
					MeleeDefense = this.m.Attributes.MeleeDefense,
					RangedDefense = this.m.Attributes.RangedDefense
				};

				return attr;
			}

			o.setAttributes <- function(_a)
			{
				this.m.Attributes.Hitpoints = _a.Hitpoints;
				this.m.Attributes.Stamina = _a.Stamina;
				this.m.Attributes.Bravery = _a.Bravery;
				this.m.Attributes.Initiative = _a.Initiative;
				this.m.Attributes.MeleeSkill = _a.MeleeSkill;
				this.m.Attributes.RangedSkill = _a.RangedSkill;
				this.m.Attributes.MeleeDefense = _a.MeleeDefense;
				this.m.Attributes.RangedDefense = _a.RangedDefense;
			}

			o.getWounds <- function()
			{
				return this.m.Wounds;
			}

			o.setWounds <- function(_w)
			{
				this.m.Wounds = _w;
			}

			o.serializeCompanionName <- function()
			{
				local nameCopy = this.m.Name;
				local serializedName = nameCopy += "\nmod_AC=" + this.m.Type + "," + this.m.Level + "," + this.m.XP + "," + this.m.Wounds + ",A=" + this.m.Attributes.Hitpoints + "," + this.m.Attributes.Stamina + "," + this.m.Attributes.Bravery + "," + this.m.Attributes.Initiative + "," + this.m.Attributes.MeleeSkill + "," + this.m.Attributes.RangedSkill + "," + this.m.Attributes.MeleeDefense + "," + this.m.Attributes.RangedDefense + ",Q=";

				foreach(i, quirk in this.m.Quirks)
				{
					local getQuirk = this.new(quirk);
					serializedName += this.Const.Companions.SerializeQuirks.find(getQuirk.m.ID);
					if (i < this.m.Quirks.len() - 1) serializedName += ",";
				}

				return serializedName;
			}

			o.deserializeCompanionName <- function(_cn)
			{
				local nameMod = "\nmod_AC=";
				local findMod = _cn.find(nameMod);

				if (findMod != null && _cn.find("0x00000000") == null)
				{
					local slicedName = _cn.slice(0, findMod);
					local slicedDetails = _cn.slice(findMod + nameMod.len());
					local nameAttributes = "A=";
					local findAttributes = slicedDetails.find(nameAttributes);
					local slicedBasics = slicedDetails.slice(0, findAttributes - 1);
					local arrayBasics = split(slicedBasics, ",");
					this.m.Type = arrayBasics[0].tointeger();
					this.m.Level = arrayBasics[1].tointeger();
					this.m.XP = arrayBasics[2].tointeger();

					if (arrayBasics.len() == 4)
						this.m.Wounds = arrayBasics[3].tointeger();

					slicedDetails = slicedDetails.slice(findAttributes + nameAttributes.len());
					local nameQuirks = "Q=";
					local findQuirks = slicedDetails.find(nameQuirks);
					local slicedAttributes = slicedDetails.slice(0, findQuirks - 1);
					local arrayAttributes = split(slicedAttributes, ",");
					this.m.Attributes.Hitpoints = arrayAttributes[0].tointeger();
					this.m.Attributes.Stamina = arrayAttributes[1].tointeger();
					this.m.Attributes.Bravery = arrayAttributes[2].tointeger();
					this.m.Attributes.Initiative = arrayAttributes[3].tointeger();
					this.m.Attributes.MeleeSkill = arrayAttributes[4].tointeger();
					this.m.Attributes.RangedSkill = arrayAttributes[5].tointeger();
					this.m.Attributes.MeleeDefense = arrayAttributes[6].tointeger();
					this.m.Attributes.RangedDefense = arrayAttributes[7].tointeger();

					slicedDetails = slicedDetails.slice(findQuirks + nameQuirks.len());
					local arrayQuirks = split(slicedDetails, ",");
					this.m.Quirks.resize(arrayQuirks.len());
					foreach(i, quirk in this.m.Quirks)
					{
						this.m.Quirks[i] = this.Const.Companions.DeserializeQuirks[arrayQuirks[i].tointeger()];
					}

					this.m.Name = slicedName;
				}
				else
				{
					this.m.Name = _cn;
				}
			}

			o.onSerialize <- function(_out)
			{
				this.accessory.onSerialize(_out);
				_out.writeString(this.serializeCompanionName());
			}

			o.onDeserialize <- function(_in)
			{
				this.accessory.onDeserialize(_in);
				this.deserializeCompanionName(_in.readString());
				this.updateCompanion();
			}
		}
	}


	::mods_hookBaseClass("items/accessory/accessory", mod_AC_foundation);
	::mods_hookBaseClass("items/accessory/wardog_item", mod_AC_foundation);
	::mods_hookBaseClass("items/accessory/warhound_item", mod_AC_foundation);
});
