this.legend_qiyan_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.legend_qiyan";
		this.m.Name = "Циянь";
        this.m.Icon = "ui/backgrounds/background_qiyan.png";
        this.m.BackgroundDescription = "Циянь — это рабыня, обученная искусству обольщения, тайным знаниям и смертоносным ремёслам.";
        this.m.GoodEnding = "Впитав в себя всё, чему она научилась за время службы в отряде, %name% отправилась на север с твёрдым намерением убраться как можно дальше от жарких южных земель. В одном из глухих поселений посреди суровой тундры её ждал тёплый приём: лишних вопросов девушке не задавали, а платили щедро. Она быстро завоевала уважение местных ополченцев и со временем возглавила их, став полноправным капитаном.";
        this.m.BadEnding = "Когда вы ушли, %name% лишилась вашего покровительства, и её судьба повисла на волоске — чего нельзя было сказать о намерениях её прежних хозяев. Всего через несколько ночей после вашего ухода по её душу явились безжалостные охотники за рабами. Лишившись вашего твёрдого руководства, оставшиеся наёмники даже не попытались заступиться за боевую подругу. Что стало с %name% дальше — загадка. Последний раз её видели закованной в кандалы в невольничьем караване, идущем на юг, но её дальнейшая участь скрыта во мраке.";
		this.m.HiringCost = 500;
		this.m.DailyCost = 10;
		this.m.Excluded = [
		    "trait.tough",
		    "trait.strong",
		    "trait.clumsy",
		    "trait.fat",
		    "trait.ailing",
		    "trait.asthmatic",
		    "trait.spartan",
		    "trait.athletic",
		    "trait.huge",
		    "trait.craven"
		];
		this.m.Titles = [
			"Циянь"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Hitpoints,
			this.Const.Attributes.Fatigue
		];
		// this.m.IsGuaranteed = ["seductive_trait"]
		local howIs = this.Math.rand(1, 100);
		if (howIs <= 10)
		{
            this.m.Bodies = this.Const.Bodies.NorthernFemale;
            this.m.Faces = this.Const.Faces.NorthernFemale;
            this.m.HairColors = this.Const.HairColors.Young;
            this.m.Names = this.Const.Strings.CharacterNamesFemaleNorse;
		}
		else if (howIs <= 30)
		{
            this.m.Bodies = this.Const.Bodies.AfricanFemale;
            this.m.Faces = this.Const.Faces.AfricanFemale;
            this.m.HairColors = this.Const.HairColors.AfricanYoung;
            this.m.Names = this.Const.Strings.SouthernFemaleNames;
		}
		else
		{
            this.m.Bodies = this.Const.Bodies.SouthernFemale;
            this.m.Faces = this.Const.Faces.SouthernFemale;
            this.m.HairColors = this.Const.HairColors.SouthernYoung;
            this.m.Names = this.Const.Strings.SouthernFemaleNames;
		}
        this.m.Hairs = this.Const.Hair.Female;
		this.m.Beards = null;
		this.m.BeardChance = 0;
		this.m.Ethnicity = 1;

//		this.m.BackgroundType = this.Const.BackgroundType.Combat;
		this.m.IsCombatBackground = true;
//		this.m.Modifiers.Barter = this.Const.LegendMod.ResourceModifiers.Barter[3];
//		this.m.Modifiers.Stash = this.Const.LegendMod.ResourceModifiers.Stash[2];
//		this.m.Modifiers.Scout = this.Const.LegendMod.ResourceModifiers.Scout[1];
//		this.m.PerkTreeDynamic = {
//			Weapon = [
//				this.Const.Perks.DaggerTree,
//				this.Const.Perks.SwordTree,
//				this.Const.Perks.ThrowingTree,
//				this.Const.Perks.OneHandedTree
//			],
//			Defense = [
//				this.Const.Perks.ClothArmorTree,
//				this.Const.Perks.LightArmorTree
//			],
//			Traits = [ //lf 5
//				this.Const.Perks.AgileTree,
//				this.Const.Perks.InspirationalTree,
//				this.Const.Perks.FastTree,
//				this.Const.Perks.IntelligentTree
//			],
//			Enemy = [],
//			Class = [
//				this.Const.Perks.KnifeClassTree
//			],
//			Profession = [],
//			Magic = [
//				this.Const.Perks.BardMagicTree
//			]
//		}
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-10,
				3
			],
			Bravery = [
				5,
				10
			],
			Stamina = [
				5,
				8
			],
			MeleeSkill = [
				5,
				10
			],
			RangedSkill = [
				-5,
				5
			],
			MeleeDefense = [
				-5,
				10
			],
			RangedDefense = [
				-6,
				4
			],
			Initiative = [
				-5,
				5
			]
		};
		return c;
	}

	function onBuildDescription()
	{
		return "{%name% родилась при доме визиря — дочь рабыни, отданная наставникам в искусства, о которых на улицах предпочитают молчать. | Кочевники захватили её в плен и продали в богатый дом, где красивых девушек обучали не только пению и пляскам. | За долги отца её продали ещё девочкой, и покупатель оказался владельцем заведения, где ножны шили аккуратнее, чем сорочки. | %name% утверждает, что выучила стихов больше, чем любой служитель Златоликого, — за столами богатых мужчин молиться было некогда. | Хозяева звали её воспитанницей и щеголяли ею на пирах, но знающие люди платили не за пляски.} {Но однажды ночью она перерезала цепи, опустошила шкатулку хозяина и растворилась в караване, уходившем за город. | Однажды хозяин проиграл её в споре купцу; пока купец собирался за покупкой, она уже сорвала цепь с запястий и исчезла в ночном базаре. | Однажды охотники за рабами пришли за ней, но вернулись ни с чем: до сих пор не могут понять, как их добыча заперла их самих в каморке при постоялом дворе и ушла неспешным шагом. | Однажды она исчезла вместе со шкатулкой хозяина; за возвращение пропажи назначена награда — на юге имущество такой выучки не дешевеет. | Однажды она ушла тихо: к утру догорало крыло дома, а её след терялся в песках за городскими воротами, вперемешку со следами верблюжьего каравана.} {Теперь она вольна, как песок в пустыне, — и так же скользит сквозь пальцы: ни страже, ни охотникам за рабами её поймать пока не удалось. | В её манерах слышатся уроки старых наставников: улыбка, лёгкий поклон — и лезвие, появляющееся из ниоткуда. | Она пляшет так, что зрители не замечают пустеющих кошельков; всё остальное ей удаётся ещё незаметнее. | В её волосах по-прежнему заплетены травы и цветы, но два из них выращены вряд ли ради красоты. | Поговаривают, будто она умеет убить острым обломком, лентой для волос или одним лишь правильным словом, — и верят в это все, кроме неё самой.}";
	}

    function onAdded()
    {
        this.character_background.onAdded();
        if (!this.m.Container.hasSkill("effects.female_voice"))
        {
            this.m.Container.add(this.new("scripts/skills/effects/female_voice_effect"));
        }
    }
//
//	function onUpdate( _properties )
//	{
//        this.character_background.onUpdate(_properties);
//        if (!this.m.Container.hasSkill("effects.female_voice"))
//        {
//            this.m.Container.add(this.new("scripts/skills/effects/female_voice_effect"));
//        }
//	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();

		items.equip(this.new("scripts/items/armor/oriental/cloth_sash"));

        local helmet = ::MSU.Class.WeightedContainer([
            [1, ""],
            [1, "scripts/items/helmets/legend_headband_coin"],
            [1, "scripts/items/helmets/legend_headress_coin"],
            [1, "scripts/items/helmets/legend_earings"],
            [5, "scripts/items/helmets/legend_southern_veil"],
            [1, "scripts/items/helmets/legend_southern_cloth_headress"]
        ]).roll();

        if (helmet != "") items.equip(this.new(helmet));


//		local armor = this.Const.World.Common.pickArmor([
//			[1, ::Legends.Armor.Southern.cloth_sash]
//		]);
//		items.equip(armor);
//		items.equip(this.Const.World.Common.pickHelmet([
//			[1, ::Legends.Helmet.None],
//			[1, ::Legends.Helmet.Southern.legend_headband_coin],
//			[1, ::Legends.Helmet.Southern.legend_headress_coin],
//			[1, ::Legends.Helmet.Southern.legend_earings],
//			[5, ::Legends.Helmet.Southern.legend_southern_veil],
//			[1, ::Legends.Helmet.Southern.legend_southern_cloth_headress]
//		]));
	}
});

