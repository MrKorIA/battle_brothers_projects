this.hemovore_praetorian_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hemovore_praetorian"; //-
		this.m.Name = "Преторианец";
		this.m.Icon = "ui/backgrounds/Background_hemovore_praetorian.png"; 
		this.m.BackgroundDescription = "Умелый, молчаливый и закалённый воин, которому поручено помочь вам.";
		this.m.GoodEnding = "Когда работа была почти завершена, %name% вернулся к монолиту, как он всегда это делал. Сняв шлем, он положил его на полку кургана внутри шахты, а сам укрылся в саркофаге. Используя собственную силу, он снова закрыл крышку каменного гроба и снова запечатал себя во тьме. Легионер лежал в темноте и думал о вас. Впервые за долгое время он мечтал о доме и лучшем завтра.";
		this.m.BadEnding = "После вашего расставания и провала вашего задания легионер, который был приставлен к вам, начал винить себя в вашей неудаче. Через некоторое время, он вернулся к монолиту и снова занял свой пост. Он стоял неподвижно под дождем, снегом и солнцем, пока мох не начал расти на его доспехах. Когда-нибудь всё может измениться для него, а пока %name% может делать только то, чему его обучали - ждать.";
		this.m.HiringCost = 600;
		this.m.DailyCost = 0;
		this.m.Excluded = [
            "trait.ailing",
            "trait.asthmatic",
            "trait.bleeder",
            "trait.brave",
            "trait.gluttonous",
            "trait.craven",
            "trait.dastard",
            "trait.deathwish",
            "trait.determined",
            "trait.disloyal",
            "trait.drunkard",
            "trait.fainthearted",
            "trait.fat",
            "trait.fear_undead",
            "trait.fear_greenskins",
            "trait.fear_beasts",
            "trait.fearless",
            "trait.eagle_eyes",
            "trait.greedy",
            "trait.hate_undead",
            "trait.insecure",
            "trait.iron_lungs",
            "trait.irrational",
            "trait.loyal",
            "trait.night_owl",
            "trait.night_blind",
            "trait.optimist",
            "trait.paranoid",
            "trait.pessimist",
            "trait.spartan",
            "trait.superstitious",
            "trait.weasel",
            "trait.legend_fear_nobles",
            "trait.legend_slack",
            "trait.legend_double_tongued",
            "trait.legend_gift_of_people",
            "trait.legend_seductive"
            ];

		this.m.ExcludedTalents = [
			this.Const.Attributes.Hitpoints,
			this.Const.Attributes.Fatigue,
			this.Const.Attributes.Initiative
		];
			//Apperance changes due to 'skeletal' trait anyway
		this.m.Names = this.Const.Strings.AncientDeadNames;
		this.m.Titles = this.Const.Strings.AncientDeadTitles;
		// this.m.LastNames = this.Const.Strings.SouthernNamesLast;		
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.YoungMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.BeardChance = 0;
		this.m.Level = this.Math.rand(3, 5);

	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor().get();
		if (::MSU.isKindOf(actor, "player"))
		{
			if (actor.getFlags().has("human"))
				actor.getSprite("injury_body").setBrush("bust_skeleton_body_injured");

			local hairColor = this.Const.HairColors.Zombie[this.Math.rand(0, this.Const.HairColors.Zombie.len() - 1)];
			local body = actor.getSprite("body");
			body.setBrush("bust_skeleton_body_0" + this.Math.rand(1, 2));
			body.Saturation = 0.8;

			actor.getSprite("injury_body").setBrush("bust_skeleton_body_injured");

			local head = actor.getSprite("head");
			head.setBrush("bust_skeleton_head");
			head.Color = body.Color;
			head.Saturation = body.Saturation;

			local beard = actor.getSprite("beard");
			if (beard == !null)
			{
				beard.setBrush("beard_" + hairColor + "_" + this.Const.Beards.ZombieOnly[this.Math.rand(0, this.Const.Beards.ZombieOnly.len() - 1)]);
				local beard_top = actor.getSprite("beard_top");
				if (beard.HasBrush && this.doesBrushExist(beard.getBrush().Name + "_top"))
				{
					beard_top.setBrush(beard.getBrush().Name + "_top");
					beard_top.Color = beard.Color;
				}
			}

			local face = actor.getSprite("scar_head");
			if (face == !null)
				face.setBrush("bust_skeleton_face_0" + this.Math.rand(1, 6));

			local hair = actor.getSprite("hair");
			if (hair == !null)
			{
				hair.Color = beard.Color;
				hair.setBrush("hair_" + hairColor + "_" + this.Const.Hair.ZombieOnly[this.Math.rand(0, this.Const.Hair.ZombieOnly.len() - 1)]);
				actor.setSpriteOffset("hair", this.createVec(0, -3));
			}

			local injury = actor.getSprite("injury");
			if (injury == !null)
				injury.setBrush("bust_skeleton_head_injured");

		}
	}


	function onAdded()
	{
		this.character_background.onAdded();
		local actor = this.getContainer().getActor();

        if (!actor.getSkills().hasSkill("trait.legend_fleshless"))
        {
            actor.getSkills().add(this.new("scripts/skills/traits/legend_fleshless_trait"));
            actor.getSkills().add(this.new("scripts/skills/perks/perk_vampire_maintenance"));
            actor.getSkills().add(this.new("scripts/skills/actives/legend_command_legion_skill"));
        }

		actor.m.ExcludedInjuries = [
            "injury.cut_artery",
            "injury.cut_throat",
            "injury.deep_abdominal_cut",
            "injury.deep_chest_cut",
            "injury.exposed_ribs",
            "injury.grazed_kidney",
            "injury.grazed_neck",
            "injury.infected_wound",
            "injury.sickness",
            "injury.stabbed_guts",
            "injury.broken_nose",
            "injury.crushed_windpipe",
            "injury.fractured_ribs",
            "injury.inhaled_flames",
            "injury.pierced_chest",
            "injury.cut_arm_sinew",
            "injury.pierced_lung",
            "injury.ripped_ear",
            "injury.pierced_side",
            "injury.cut_leg_muscles",
            "injury.pierced_cheek"
        ];
	}

	function onBuildDescription()
	{ //—
		return "{Стремление к совершенству может занять всю жизнь, | Освоить навык - одно, но совсем другое добиться такой известности, когда репутация тебя опережает, | Все ждут от тебя большего, чем от других, вот что значит быть лучшим,} {но когда время не имеет значения - какой смысл спешить? | но какой смысл следовать пути, если ты способен пережить и побороть каждого соперника, с которым сталкиваешься? | но когда твои глаза пусты и люди в ужасе бегут от тебя, кому передать знания?} {Вопреки ожиданиям, %name% способен говорить, но предпочитает, чтобы об этом никто не знал. | %name% безмолвно маячит позади вас. От него не исходит ни звука, кроме лёгкого скрипа сросшихся костей и бряцания доспехов. | %name% настолько тих, что вы порой забываете о его существовании. Лишь изредка он напоминает о себе, когда точит оружие или латает доспехи. | Когда-то %name% был легионером, участвовал почти во всех конфликтах до катастрофы. Как и тогда, он по-прежнему дежурит, патрулирует и марширует так, как его обучили. Иногда можно заметить, как он сидит и смотрит на пустую миску, в которой должна быть еда. | Его военное прошлое весьма туманно, но форма и знания указывают на годы, если не десятилетия, военной подготовки. Но изменилось ли что-то с того времени - остаётся загадкой. Иногда задаёшься вопросом, отказ отступить хоть на шаг - это признак солдата или сверхъестественной решимости.} {Когда-то давно %name% и его отряд попали в засаду наёмников, тогда перебили всех, кроме него. Наёмники собрали всё, что смогли и сбежали. | %name% почти вечность оберегал монолит от любопытных смертных глаз, не раз сражаясь с охотниками за сокровищами и разбойниками. И всё же его талант пропадал впустую. | Множество раз он восстанавливал расколовшиеся доспехи, множество раз крепил отвалившиеся детали, и всё же более мелкие сколы и порезы испещряют его панцирь. Трудно сказать, были ли эти следы получены до того, как он стал тем, кем он стал, или после.}";

        return "{Путь к мастерству может занять целую жизнь, | Изучить навык - одно дело, но стать настолько известным, чтобы ваша репутация опережала вас, - совсем другое, | Будучи лучшим, все ждут от вас большего, чем от остальных,} {но когда время не имеет значения - какой смысл спешить? | но какой смысл в пути, если вы способны пережить каждого встреченного врага? | но когда ваши глаза пусты, а люди бегут и кричат при виде вас, кому вы можете передать свои знания?} {Вопреки распространённому мнению, %name% умеет говорить, но предпочитает, чтобы никто не знал об этом. | %name% безмолвно возвышается за вашей спиной - ни звука не доносится от него, кроме тихого скрипа костей и дребезжания боевых доспехов. | %name% настолько тих, что вы часто забываете о его существовании. Он лишь изредка напоминает о себе, когда точит оружие или чинит доспехи. | Некогда легионер, %name% участвовал почти во всех конфликтах, предшествовавших катаклизму. Он всё ещё патрулирует, марширует и спит как легионер даже вне боя. Иногда вы замечаете, как он сидит и смотрит в пустую миску. | Его военное прошлое не совсем ясно, его выправка и знания указывают на годы, если не десятилетия военной подготовки. Что изменилось с тех пор - загадка. Иногда вы задаётесь вопросом, является ли его неспособность отступить с линии фронта признаком солдата или сверхъестественной решимости.} {Судя по зарубкам на его доспехах и отсутствующим костям, %name% пережил бойню, в которой не выжил больше никто из его легиона - но что послужило её причиной, он, конечно, никогда не расскажет. | %name% провёл почти вечность, охраняя монолит от любопытных глаз смертных, часто собирая защитников против охотников за сокровищами и бандитов. И всё же его таланты растрачивались впустую. | Множество костей было сломано, вправлено и сломано вновь по всему его телу - мелкие сколы и порезы усеивают его скелет. Трудно сказать, случились ли эти травмы до или после того, как он стал тем, кем является сейчас.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				15,
				20
			],
			Bravery = [
				15,
				15
			],
			Stamina = [
				35,
				35
			],
			MeleeSkill = [
				10,
				16
			],
			RangedSkill = [
				14,
				18
			],
			MeleeDefense = [
				9,
				15
			],
			RangedDefense = [
				5,
				0
			],
			Initiative = [
				-5,
				-10
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/ancient/rhomphaia"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/ancient/legend_gladius"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/ancient/khopesh"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/ancient/warscythe"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/weapons/ancient/crypt_cleaver"));
		}

		if (items.getItemAtSlot(this.Const.ItemSlot.Offhand))
		{
			items.equip(this.new("scripts/items/shields/ancient/tower_shield"));
		}

		r = this.Math.rand(0, 3);
		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/ancient/ancient_plate_harness"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/ancient/ancient_double_layer_mail"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/ancient/ancient_plated_mail_hauberk"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/ancient/ancient_scale_coat"));
		}

		r = this.Math.rand(0, 1);
		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/ancient/legend_helmet_legend_ancient_gladiator"));
		}
		else
		{
			items.equip(this.new("scripts/items/helmets/ancient/ancient_honorguard_helmet"));
		}

	}

});

