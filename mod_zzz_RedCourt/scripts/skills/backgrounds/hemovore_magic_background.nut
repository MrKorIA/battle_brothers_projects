this.hemovore_magic_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {
	    IsFemale = false
	},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hemovore_magic"; //Spellcaster
		this.m.Icon = "ui/backgrounds/Background_hemovore_magic.png"; 
		this.m.Name = "Некропат";
		this.m.BackgroundDescription = "Там, где одни рассыпаются в кризисе, другие ищут ответы - %name% нашёл их и с тех пор жалеет об этом.";
		this.m.GoodEnding = "Когда наступил крах империи, %name% обратился за ответами к своим книгам и свиткам. Находясь под вашим крылом, он сделал то же самое и в итоге превзошёл свои прежние силы - с вновь обретёнными знаниями он вернулся в библиотеку и взял на себя охрану того, что осталось от архивов. Много лет он стоял на страже пустых залов и затопленных полок, и, возможно, однажды он найдёт способ исправить ошибки прошлого - или, возможно, продолжить их.";
		this.m.BadEnding = "Подобно тому, как орёл взмывает слишком высоко в небо, прежде чем его поражает стрела, гордость и амбиции привели его к подобной участи. Силы стали неуклонно брать верх над ним, превращая в мерзкую пародию на бессмертный гниющий труп. После борьбы с собственными внутренними амбициями %name% в конце концов вогнал кол в собственное сердце, чтобы положить конец страданиям.";
		this.m.HiringCost = 9999999999999999999999999999;
		this.m.DailyCost = 43; //-
		this.m.Excluded = [
			"trait.craven",
			"trait.dastard",
			"trait.clubfooted",
			"trait.tiny",
			"trait.short_sighted",
			"trait.drunkard",
			"trait.insecure",
			"trait.night_blind",
			"trait.legend_fear_dark",
			"trait.deathwish", //Cannot lose res via being hit
			"trait.gluttonous", //does not eat
			"trait.asthmatic", //not really affected by fatigue
			"trait.fat", // doesn't eat
			"trait.spartan",  //no food required
			"trait.fear_nobles",
			"trait.fear_greenskins",
			"trait.greedy", //Not paid
			"trait.fear_beasts",
			"trait.fear_undead", //not scared of lesser dead
			"trait.legend_steady_hands",
			"trait.legend_sureshot",
			"trait.ailing" //cant be poisoned
		];
		
		this.m.ExcludedTalents = [
			this.Const.Attributes.RangedSkill
		];		
		//Male
		this.m.Faces = ["bust_skeleton_head_04"]; //could also be 05 or 03
		this.m.Bodies = ["bust_skeleton_body_04"]; //could also be 05 or 03
		this.m.Hairs = this.Const.Hair.Vampire;
		this.m.HairColors = this.Const.HairColors.Zombie;
		// this.m.Beards = this.Const.Beards.Tidy;

		this.m.Level = this.Math.rand(3, 4);
		this.m.Names = this.Const.Strings.AncientSouthernNames;
		if (::Math.rand(0, 1) == 0) this.m.IsFemale = true;
	}

    function onSetAppearance()
    {
        if (this.m.IsFemale)
        {
                //Female
            local actor = this.getContainer().getActor();
            actor.getSprite("head").setBrush("bust_vampire_lady_head_01");
            actor.getSprite("body").setBrush("bust_vampire_lady_body_01");
            actor.getSprite("beard").setBrush("");
            actor.getSprite("beard_top").setBrush("");
            actor.setName(this.Const.Strings.SouthernFemaleNames[this.Math.rand(0, this.Const.Strings.SouthernFemaleNames.len() - 1)]);
            this.m.BackgroundDescription = "Там, где одни рассыпаются в кризисе, другие ищут ответы - %name% нашла их и с тех пор жалеет об этом.";
            this.m.GoodEnding = "Когда наступил крах империи, %name% обратилась за ответами к своим книгам и свиткам. Находясь под вашим крылом, она сделала то же самое и в итоге превзошла свои прежние силы - с вновь обретенными знаниями она вернулась в библиотеку и взяла на себя охрану того, что осталось от архивов. Много лет она стояла на страже пустых залов и затопленных полок, и, возможно, однажды она найдёт способ исправить ошибки прошлого - или, возможно, продолжить их.";
            this.m.BadEnding = "Подобно тому, как орёл взмывает слишком высоко в небо, прежде чем его поражает стрела, гордость и амбиции привели её к подобной участи. Силы стали неуклонно брать верх над ней, превращая в мерзкую пародию на бессмертный гниющий труп. После борьбы с собственными внутренними амбициями %name% в конце концов вогнала кол в собственное сердце, чтобы положить конец страданиям.";
        }
    }

	function onBuildDescription() //-
	{
		if (this.m.IsFemale) //female
		{
			return "{Когда небо над империей рухнуло, | Когда реки крови на улицах иссякли, | Когда пламя угасло, | Когда вопли стихли,} {%name% выбралась из разрушенного подвала, в котором пряталась от хаоса. | %name% выбралась из сгоревшей библиотеки, где укрылась под рухнувшими книжными полками. | %name% оказалась погребена под обломками здания, но сумела выбраться на поверхность. | %name% вышла из глубины леса, чтобы воочию увидеть разрушения.} {Используя учёный ум, она по всей бывшей империи искала ответы, но то, что уцелело, было вскоре разграблено. | Чужая в чужих землях, она искала ответы в руинах империи, находя лишь безмолвные склепы и покинутые подземелья. | Лишившись дома, она сразу же отправилась на поиски ответов. На вопрос о том, что она нашла, %name% лишь загадочно молчит.} {Когда же она нашла легендарную Чёрную библиотеку, её исстрадавшееся сердце вновь затрепетало, и хотя прошло слишком много лет, а большая часть архива была утеряна, всё было не зря. За время поисков она научилась многим хитростям.}";
		}
		else //male
		{
			return "{Когда небо над империей рухнуло, | Когда реки крови на улицах иссякли, | Когда пламя улеглось, | Когда вопли стихли,} {%name% выбрался из разрушенного подвала, в котором прятался от хаоса. | %name% выбрался из сгоревшей библиотеки, где укрылся под рухнувшими книжными полками. | %name% оказался погребён под обломками здания, но сумел выбраться на поверхность. | %name% вышел из глубины леса, чтобы воочию увидеть разрушения.} {Используя учёный ум, он по всей бывшей империи искал ответы, но то, что уцелело в катастрофе, было вскоре разграблено. | Чужой в чужих землях, он искал ответы в руинах империи, находя лишь безмолвные склепы и покинутые подземелья. | Лишившись дома, он сразу же отправился на поиски ответов. На вопрос о том, что он нашёл, %name% лишь загадочно молчит.} {Когда же он нашёл легендарную Чёрную библиотеку, его исстрадавшееся сердце вновь затрепетало, и хотя прошло слишком много лет, а большая часть архива была утеряна, всё было не зря. За время поисков он научился многим хитростям.}";
		}
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				25,
				35
			],
			Bravery = [
				8,
				14
			],
			Stamina = [
				10,
				10
			],
			MeleeSkill = [
				5,
				18
			],
			RangedSkill = [
				-50,
				-50
			],
			MeleeDefense = [
				3,
				7
			],
			RangedDefense = [
				3,
				7
			],
			Initiative = [
				15,
				10
			]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();
        if (!this.m.Container.hasSkill("trait.vampire"))
        {
            this.m.Container.add(this.new("scripts/skills/racial/vampire_racial"));
        }

		local actor = this.getContainer().getActor();
		actor.m.ExcludedInjuries = [ 
			"injury.infected_wound",
			"injury.sickness",
		];
	}

	function getTooltip()
	{
		local ret = this.character_background.getTooltip()
		ret.push(
			{
				id = 13,
				type = "text",
				icon = "ui/icons/armor_body.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Не может носить броню тела или головы[/color], но получает на [color=" + this.Const.UI.Color.PositiveValue + "]30%[/color] меньше урона от прямых атак. Порог получения травм увеличен на [color=" + this.Const.UI.Color.PositiveValue + "]90%[/color]"
			}
		)
		return ret
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();

		local r;
		r = this.Math.rand(0, 3);

		if (r == 0)
		{
		    items.equip(this.new("scripts/items/weapons/ancient/khopesh"));
		}
		else if (r == 1)
		{
		    items.equip(this.new("scripts/items/weapons/ancient/falx"));
		}
		else if (r == 2)
		{
		    items.equip(this.new("scripts/items/weapons/ancient/ancient_spear"));
		}
		else if (r == 3)
		{
		    items.equip(this.new("scripts/items/weapons/ancient/ancient_sword"));
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.DamageReceivedRegularMult *= 0.70; //30% reduction
		_properties.ThresholdToReceiveInjuryMult *= 1.90; //+90% higher threshold
	}

});
