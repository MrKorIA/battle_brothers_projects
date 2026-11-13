this.berserker_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {
		Tattoo = 0
	},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hackflows_berserker";
		this.m.Name = "Берсерк";
		this.m.Icon = "ui/backgrounds/background_berserker.png";
		this.m.BackgroundDescription = "Убей или умри - иного закона они не знают. Берсерки с младенчества выкованы в горниле жестокой борьбы за выживание, что превратило их в бесстрашных, яростных воинов, не ведающих жалости и боли.";
        this.m.GoodEnding = "%name% остался в отряде \'%companyname%\' - и, вопреки всем ожиданиям, не перегрыз горло ни новому командиру, ни казначею. Напротив, со временем он сделался чем-то вроде живой легенды: новые наёмники приходили посмотреть на дикаря и оставались, послушав, как он тихо и толково объясняет премудрости ремесла наёмника. Крестьяне в тех краях до сих пор пугают им детей, хотя сам %name% давно уже не берсерк, а скорее старый ворчливый ветеран, который знает цену и тишине, и людям.";
        this.m.BadEnding = "В одной из стычек отряда \'%companyname%\' %name% в очередной раз ушёл в бой впереди всех - и не вернулся. Тело его нашли далеко от места схватки, и по ранам на нём было видно, что умер он не от руки врага: он терзал сам себя в слепой ярости. Что именно в тот день сломало его - рана, потеря друга или просто накопившаяся усталость, - так и осталось неизвестным. Хоронили его в лесу, без слов и без могильного камня.";
		this.m.HiringCost = 800;
		this.m.DailyCost = 18;
		this.m.Excluded = [
			"trait.weasel",
			"trait.teamplayer",
			"trait.fear_beasts",
			"trait.hate_undead",
			"trait.paranoid",
			"trait.night_blind",
			"trait.ailing",
			"trait.clubfooted",
			"trait.fat",
			"trait.tiny",
			"trait.gluttonous",
			"trait.pessimist",
			"trait.optimist",
			"trait.short_sighted",
			"trait.dexterous",
			"trait.insecure",
			"trait.hesitant",
			"trait.asthmatic",
			"trait.greedy",
			"trait.fragile",
			"trait.fainthearted",
			"trait.craven",
			"trait.bleeder",
			"trait.bright",
			"trait.cocky",
			"trait.dastard",
			"trait.drunkard"
		];
		this.m.Titles = [
			"Берсерк",
			"Безумный",
			"Кровожадный",
			"Дикий",
			"Дикарь",
			"Закаленный в битвах"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.WildMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.Wild;
		this.m.BeardChance = 100;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(3, 5);
		this.m.IsCombatBackground = true;
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
	}

	function onBuildDescription()
	{
        return "{Говорят, что человек рождается с дикой природой внутри себя, и совершает ошибку, отворачиваясь от неё. Этот девиз чтят те, кто нашёл убежище в лесах, отвергнув скверну цивилизации ради старых обычаев. Но между людьми дикой природы и людьми цивилизации существует третий род людей, что осмеливаются жить на границе обоих миров. Их называют берсерками. | Одни говорят, что цивилизация - это клетка, а дикость - единственная подлинная свобода человека. Между этими двумя крайностями существуют немногие, кто не выбрал ни одну из сторон до конца. Их зовут берсерками. | Лес принимает беглецов от людской жестокости, но не всякий беглец способен полностью раствориться в его тишине. Те, кто застревает где-то между волчьим воем и людским гомоном, получили собственное имя - берсерки. | Немногие способны выжить, отвергнув и людские законы, и звериные повадки одновременно, взяв от каждого мира ровно то, что нужно для выживания. Таких людей называют берсерками. | Одни бегут от людей в чащу, другие остаются среди людей, но носят чащу внутри себя. Последних называют берсерками - и не зря их сторонятся как лесные жители, так и городские.} {%name% - один из таких людей. Он настолько огромен, что рядом с ним обычные мужчины кажутся почти детьми; всё его тело покрыто шрамами, а волосы растут спутанным клубком, не признавая ни гребня, ни ножниц. | %name% возвышается над любым мужчиной, которого вы когда-либо встречали, а его тело исполосовано шрамами настолько густо, что сложно сказать, где заканчивается один и начинается другой. | С первого взгляда на него сложно поверить, что перед вами вообще человек - настолько он огромен, настолько дико и неопрятно выглядят его спутанные волосы и заросшая борода. | Шрамы, покрывающие тело %name%, рассказывают историю без слов - не все из них похожи на боевые раны, и часть, кажется, была нанесена его собственной рукой в минуты, о которых лучше не расспрашивать. | Первое, что бросается в глаза, - его исполинский рост; лишь спустя мгновение вы замечаете шрамы, покрывающие каждый видимый дюйм его тела.} {На первый взгляд он кажется обычным дикарём, если такие вообще существуют. Но его пронзительный, разумный взгляд выдаёт: пусть тело его закалено жестокостью природы, разум закалён не менее жестокими людьми. | Его манеры дики, а взгляд - нет: в его глазах читается ум человека, повидавшего людскую подлость во всей её полноте, а вовсе не только звериные инстинкты. | Вы бы приняли его за простого безумца из леса, если бы не цепкий, оценивающий взгляд, каким он окидывает ваш отряд - взгляд человека, который явно бывал среди людей достаточно долго, чтобы научиться им не доверять. | Дикость его облика обманчива: во взгляде читается расчёт человека, которого куда больше пугают люди, чем любой зверь в чаще. | Кажется, будто дикая природа выковала его тело, а люди - его разум, и второе далось ему куда тяжелее первого.}";


	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [12, 12]
			Bravery = [15, 10]
			Stamina = [14, 25]
			MeleeSkill = [6, 2]
			RangedSkill = [-6, -6]
			MeleeDefense = [-2, -2]
			RangedDefense = [-10, -8]
			Initiative = [-5, -5]
		};
		return c;
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local dirt = actor.getSprite("dirt");
		dirt.Visible = true;
		this.m.Tattoo = this.Math.rand(0, 1);
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");
		local body = actor.getSprite("body");
		tattoo_body.setBrush((this.m.Tattoo == 0 ? "warpaint_01_" : "scar_02_") + body.getBrush().Name);
		tattoo_body.Visible = true;
		tattoo_head.setBrush(this.m.Tattoo == 0 ? "warpaint_01_head" : "scar_02_head");
		tattoo_head.Visible = true;
	}

	function updateAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");

		if (tattoo_body.HasBrush)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush((this.m.Tattoo == 0 ? "warpaint_01_" : "scar_02_") + body.getBrush().Name);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;

		if (this.Const.DLC.Unhold)
		{
			r = this.Math.rand(0, 7);

			if (r == 0)
			{
				items.equip(this.new("scripts/items/weapons/hatchet"));
			}
			else if (r == 1)
			{
				items.equip(this.new("scripts/items/weapons/wooden_stick"));
			}
			else if (r == 2)
			{
				items.equip(this.new("scripts/items/weapons/greenskins/orc_metal_club"));
			}
			else if (r == 3)
			{
				items.equip(this.new("scripts/items/weapons/greenskins/orc_wooden_club"));
			}
			else if (r == 4)
			{
				items.equip(this.new("scripts/items/weapons/boar_spear"));
			}
			else if (r == 5)
			{
				items.equip(this.new("scripts/items/weapons/woodcutters_axe"));
			}
			else if (r == 6)
			{
				items.equip(this.new("scripts/items/weapons/two_handed_wooden_hammer"));
			}
			else if (r == 7)
			{
				items.equip(this.new("scripts/items/weapons/two_handed_wooden_flail"));
			}
		}
		else
		{
			r = this.Math.rand(0, 6);

			if (r == 0)
			{
				items.equip(this.new("scripts/items/weapons/hatchet"));
			}
			else if (r == 1)
			{
				items.equip(this.new("scripts/items/weapons/wooden_stick"));
			}
			else if (r == 2)
			{
				items.equip(this.new("scripts/items/weapons/greenskins/orc_metal_club"));
			}
			else if (r == 3)
			{
				items.equip(this.new("scripts/items/weapons/greenskins/orc_wooden_club"));
			}
			else if (r == 4)
			{
				items.equip(this.new("scripts/items/weapons/boar_spear"));
			}
			else if (r == 5)
			{
				items.equip(this.new("scripts/items/weapons/woodcutters_axe"));
			}
		}

		if (this.Const.DLC.Wildmen)
		{
			r = this.Math.rand(0, 3);

			if (r == 0)
			{
				items.equip(this.new("scripts/items/armor/barbarians/thick_furs_armor"));
			}
			else if (r == 1)
			{
				items.equip(this.new("scripts/items/armor/barbarians/reinforced_animal_hide_armor"));
			}
			else if (r == 2)
			{
				items.equip(this.new("scripts/items/armor/barbarians/hide_and_bone_armor"));
			}
			else if (r == 3)
			{
				items.equip(this.new("scripts/items/armor/barbarians/scrap_metal_armor"));
			}
		}
		else
		{
			r = this.Math.rand(0, 2);

			if (r == 0)
			{
				items.equip(this.new("scripts/items/armor/leather_wraps"));
			}
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
	}

	function onSerialize( _out )
	{
		this.character_background.onSerialize(_out);
		_out.writeU8(this.m.Tattoo);
	}

	function onDeserialize( _in )
	{
		this.character_background.onDeserialize(_in);
		this.m.Tattoo = _in.readU8();
	}

});

