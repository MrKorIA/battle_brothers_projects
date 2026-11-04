this.legend_legion_legionary_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.legend_legion_legionary";
        this.m.Name = "Легионер";
        this.m.Icon = "ui/backgrounds/background_puppet.png"; //TODO
        this.m.BackgroundDescription = "Хребет Империи. Легионер повидал ужасы во всех уголках мира - и теперь сам странствует по этим землям как одно из них.";
		// this.m.GoodEnding = ""; //to do
		// this.m.BadEnding = ""; //to do
		this.m.HiringCost = 0;
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
			// this.Const.Attributes.RangedSkill,
			//this.Const.Attributes.Hitpoints,
			this.Const.Attributes.Fatigue,
			this.Const.Attributes.Bravery
		];

		//apperance
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.BeardChance = 0;

		this.m.Names = this.Const.Strings.AncientDeadNames;
		// this.m.LastNames = this.Const.Strings.AncientDeadTitles;
		this.m.Level = this.Math.rand(2, 3);
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

	function onBuildDescription()
	{
        return "{Выходец из длинной череды воинов, %name% вступил в Легион, горя желанием служить Императору силой оружия. | Не имея особых перспектив в гражданской жизни, %name% избрал военную стезю, став рядовым солдатом. Попав в Легион, он посвятил новую жизнь оттачиванию боевых навыков в надежде однажды обрести покой. | Подписав краткосрочный контракт, чтобы расплатиться с долгами, %name% обнаружил, что его служба бессрочно продлена после призыва в Легион. Он всё ещё надеется когда-нибудь завершить контракт, но пока что - долг зовёт. | Перед выбором между наказанием в исправительной колонии и более коротким сроком в Легионе %name% решил, что второе звучит не так уж плохо. Ошибся в обоих пунктах, и теперь, связан посмертной службой, Легион - единственное место, которое у него осталось. | Уцелев в одиночку после разгрома своего отряда, %name% с готовностью влился в новое подразделение Легиона, ища хоть какую-то цель после потери прежних товарищей.} {Он пал вместе с бесчисленными братьями по оружию задолго до того, как небо обрушилось над Империей окончательно - но шёпот древних жрецов поднял его кости, когда он понадобился Легиону вновь. | Смерть пришла к нему на дальнем рубеже, в стычке, не оставившей о себе даже строчки в летописях - лишь безымянную могилу, из которой десятилетия спустя его подняли на службу давно мёртвому Императору. | Он не помнит собственной смерти - лишь внезапный холод, сменившийся зовом, которому невозможно было не подчиниться. Так он снова встал в строй, на этот раз навсегда. | Легион не делает различий между живыми новобранцами и павшими - и тех, и других ждёт один и тот же приказ. Когда его сердце остановилось, приказ не изменился - лишь стало проще ему следовать. | Оружие, которое его кости сжимали при жизни, они сжимают и по сей день - вот только между двумя эпохами его службы не осталось ничего, кроме забытых лет под землёй.} {Он отлично обучен бою в строю и затяжным сражениям - годы тренировок сделали из него искусное орудие смерти для врагов Императора. | Убивать - вот единственная специальность, что у него осталась. Он способен удерживать строй пикинёров с непоколебимой дисциплиной и возглавлять атаки в щитовом построении, а передовая для такого, как он, - законное место, а не выбор. | Между битвами бесконечная машина Легиона поддерживается множеством умелых рук. Он в частности помогает с логистикой и лагерными работами, прежде чем вновь затупить клинок о врагов Императора. | Когда отдаются приказы, нужны сильные и непреклонные бойцы, чтобы исполнять их беспрекословно. Он бесценен в любом строю - будь то защита товарищей или истребление врага. | Стоический и сдержанный, он посвящает остатки своей человечности тихим размышлениям, и его часто можно застать за созерцанием мелочей повседневности. Вопрос лишь в том, сохранил ли он достаточно ясности ума, чтобы понимать и ценить их. | Он привносит в ряды громкий и надменный нрав, выдающий глубокое удовлетворение своим положением. Кому-то это покажется простоватым, но он наслаждается честной рутиной, которую даёт ему его должность. | Питаясь насилием и почётной службой, он смакует каждую стычку с врагом как новую возможность повергнуть противников и приумножить славу империи. | Он избегает сослуживцев, когда может, бормоча бессвязные речи о том, что мёртвые не остаются мёртвыми. Хотя и бывает странноват, он остаётся сильным и преданным солдатом Императора. | За циничными насмешками над своим положением и дерзостью, часто граничащей с неповиновением, скрывается преданность Императору, и %name% готов пойти на что угодно ради своей миссии, даже если это будет стоить ему последних костей.}";
	}

	function onChangeAttributes() //uses Character_background.nut template (Skeleton)
	{
		local c = {
			Hitpoints = [
				1,
				3
			],
			Bravery = [ //not needed except for resisting charm and sleep
				5,
				10
			],
			Stamina = [ //not needed except for equipment weight
				15,
				15
			],
			MeleeSkill = [
				2,
				5
			],
			RangedSkill = [
				5,
				9
			],
			MeleeDefense = [
				2,
				4
			],
			RangedDefense = [
				3,
				6
			],
			Initiative = [
				10,
				10
			]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();
		local actor = this.getContainer().getActor();
        if (!actor.getSkills().hasSkill("trait.legend_fleshless"))
        {
            actor.getSkills().add(this.new("scripts/skills/traits/legend_fleshless_trait"));
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
            "injury.ripped_ear",
            "injury.pierced_chest",
            "injury.cut_arm_sinew",
            "injury.pierced_lung",
            "injury.cut_leg_muscles",
            "injury.pierced_side",
            "injury.pierced_cheek"
        ];
		actor.getFlags().add("legion_can_command");  //justfies if this background is subject to the legion command skill
	}

	function adjustHiringCostBasedOnEquipment() //reduces cost for equipment worn on skeletons to zero for recruiting purposes.
	{
		local actor = this.getContainer().getActor();
		actor.m.HiringCost = this.Math.floor(this.m.HiringCost + 500 * this.Math.pow(this.m.Level - 1, 1.5));
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();

        local weapon = ::MSU.Class.WeightedContainer([
            [1, "scripts/items/weapons/ancient/bladed_pike"],
            [1, "scripts/items/weapons/ancient/warscythe"],
            [1, "scripts/items/weapons/ancient/rhomphaia"],
            [1, "scripts/items/weapons/ancient/ancient_sword"],
            [1, "scripts/items/weapons/ancient/broken_ancient_sword"]
        ]).roll();
        items.equip(this.new(weapon));

		if (items.getItemAtSlot(this.Const.ItemSlot.Offhand) == null) {
            weapon = ::MSU.Class.WeightedContainer([
                [2, "scripts/items/shields/ancient/coffin_shield"],
                [1, "scripts/items/shields/ancient/tower_shield"]
            ]).roll();
            items.equip(this.new(weapon));
		}

		local r = this.Math.rand(0, 6);
		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/ancient/ancient_scale_harness"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/ancient/ancient_scale_harness"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/ancient/ancient_breastplate"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/ancient/ancient_breastplate"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/armor/ancient/ancient_mail"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/armor/ancient/ancient_mail"));
		}
		else if (r == 6)
		{
			items.equip(this.new("scripts/items/armor/ancient/ancient_double_layer_mail"));
		}

		r = this.Math.rand(0, 2);
        if (r == 0)
        {
            items.equip(this.new("scripts/items/helmets/ancient/ancient_honorguard_helmet"));
        }
        else if (r == 1)
        {
            items.equip(this.new("scripts/items/helmets/ancient/ancient_honorguard_helmet"));
        }

	}
});
