this.hemovore_LOW_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {
	    IsFemale = false
	},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hemovore_LOW"; //is young and therefore uses new sprites
		this.m.Icon = "ui/backgrounds/Background_hemovore_LOW_male.png";
		this.m.Name = "Новообращённый";
		this.m.BackgroundDescription = "Даже самые низшие слои общества некогда обретали блага, даруемые верами и культами империи, а ныне, застыв меж жизнью и смертью, эти слуги уже не способны различить настоящее и прошлое.";
		this.m.GoodEnding = "Жизнь, у которой нет конца, сложно завершить. %name% потерял всё во время падения империи, но благодаря заклятию ведьмы смог продолжить жить относительно обычной жизнью в лесу. Временами охотники за ведьмами пристально вглядывались сквозь чары, но %name% никогда не задерживался где-либо достаточно долго, чтобы проверить их силу на себе.";
		this.m.BadEnding = "Пробуждение в мире, который продолжал жить без него, было трудным. Используя свои способности, %name% нашёл несколько убежищ для себе подобных, разбросанных по пустыне, где они прятались в склепах и просто исчезали.";		
		this.m.HiringCost = 450;
		this.m.DailyCost = 20;
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
		this.m.Faces = ["bust_skeleton_head_05"]; //could also be 04 or 03
		this.m.Bodies = ["bust_skeleton_body_05"]; //could also be 04 or 03
		this.m.Hairs = this.Const.Hair.Vampire;
		this.m.HairColors = this.Const.HairColors.Zombie;
		// this.m.Beards = this.Const.Beards.Tidy;

		this.m.Level = this.Math.rand(1, 2);
		this.m.Names = this.Const.Strings.AncientSouthernNames;
		if (::TheRedCourt.FemaleSpawn && ::Math.rand(0, 1) == 0) this.m.IsFemale = true;
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
            this.m.Name = "Новообращённая";
            this.m.Icon = "ui/backgrounds/Background_hemovore_LOW_female.png";
            this.m.BackgroundDescription = "Обслуживающие девушки и рыбачки пользовались всеми привилегиями, к которым имели доступ их партнёры. Какое-то время жизнь была хороша - но сделки, которые они совершали, преследовали их гораздо дольше, чем предполагалось.";
            this.m.GoodEnding = "В жизни, где нет конца, бывает трудно найти завершение. %name% потерял всё во время обвала, но благодаря магии ведьмы смог продолжить жить вполне нормальной жизнью в лесу. Временами охотники за ведьмами пристально вглядывались сквозь чары, но %name% никогда не задерживался где-либо достаточно долго, чтобы проверить их силу на себе.";
            this.m.BadEnding = "Пробуждение в мире, который продолжал жить без него, было трудным. Используя свои способности, %name% нашёл несколько убежищ для себе подобных, разбросанных по пустыне, где они прятались в склепах и просто исчезали.";
        }
    }

	function onBuildDescription()
	{
		if (this.m.IsFemale) //female
		{
			return "{Империя была повсюду, те, кто находился под её властью, могли наслаждаться безопасной и спокойной жизнью. %name% была лишь маленьким муравьём в гигантском муравейнике, истинных масштабов которого ей было не постичь. | %name% была слугой в небольшой семье, которая обращалась с ней на удивление хорошо — и именно это должно было насторожить её с самого начала. | Более десяти лет %name% трудилась в поле вместе со своим мужем. Иногда она задаётся вопросом, осталось ли от него хоть что-то. В каком-нибудь безымянном склепе или впадине на краю мира. Узнает ли он её? | %name% провела большую часть жизни, меняя одну работу на другую. За долгие годы тяжёлого труда она сталкивалась с разными представителями высшего общества. Именно поэтому всё пошло не так.} {Для обывателя коррупция поначалу малозаметна - %name% была обывателем. | Наслаждения и власть могут развратить даже самые кроткие умы - за повышение своего статуса в обществе часто приходится жертвовать некой частью себя. Может быть, %name% потеряла слишком много в погоне за лучшей жизнью? Судить об этом не вправе никто, кроме неё самой. | %name% наскучила размеренная, однообразная жизнь - решение присоединиться к одной из многочисленных религий империи стало для неё не только увлекательным опытом, но и позволило сблизиться со многими богатыми и влиятельными людьми того времени. Всё началось с веселья и игр, но быстро переросло в нечто более мрачное. | Не имея ни дома, ни титула, в поисках милости %name% присоединилась к одному из многочисленных культов империи. | Позже %name% стала лекарем на поле боя - задолго до того, как стала той, кем стала сейчас. Она с особой заботой ухаживала за ранеными, пока по лагерю не прокатилась чума. На смертном одре перед ней встал выбор: умереть долгой и мучительной смертью, или присоединиться к великой цели.} {Пробудившись, она стала жить на задворках цивилизации. | После нескольких столкновений со сворами охотников на ведьм, %name% решила поберечь себя и поселилась в диких землях, где ни зверь, ни лесник не смогли бы ей противостоять. | Пробудившись много веков спустя, %name% наткнулась на группу варваров с мешками на головах. Быть может, не так уж много изменилось? | В поисках ответов %name% переходит из шабаша в шабаш, но каждый раз всё тщетно.}";
		}
		else //male
		{
			return "{Некоторым людям не суждено стать великими — %name% был одним из таких людей. Он боролся за жизнь, занимаясь любым посильным трудом. | Когда-то %name% был шахтёром у подножия большого города. Были времена, когда все воздавали подношения богам, прежде чем отправиться в шахты. Времена менялись, менялись и боги, а за ними и подношения за проход вниз. | %name% много лет трудился чернорабочим, но однажды раздался призыв на войну, и он принял его. | Когда-то давно %name% считался членом императорской семьи. Правда, он сознаётся, что был лишь тридцать вторым в линии наследования. Но ведь притязания есть притязания, верно?} {Несмотря на спокойную жизнь, %name% оказался втянут в заговор против вышестоящих. Правда, сам он настаивает, что не участвовал в нём. | Он был всем доволен — до поры до времени жизнь в империи была хороша. | В то время %name% служил в одной из многих императорских армий. Платили хорошо, но за риск могли бы платить и больше. Если бы не влияние религиозных культов, возможно, %name% не был бы здесь сегодня. | С каждым годом урожай становился всё скуднее и скуднее. Нечто тёмное охватило земли - птицы умирали, животные исчезали. Вскоре %name% пал жертвой той же участи, что и все остальные. | В последние дни империи %name% скитался из города в город, надеясь найти хоть какой-то проблеск света прежнего порядка. Когда надежды не стало, он покончил с собой - и каким-то образом проснулся спустя века.} {%name% вполне приспособился к новой жизни. В пустоте всего утраченного расцвела тёмная жизненная сила. | Поначалу %name% боролся со своей новой природой. Сложно привыкнуть к тому, что дети в ужасе убегают от тебя, а крестьяне хватаются за вилы. | %name% легко освоился в новом состоянии. Он получил то, чего всегда хотел, просто не так, как ожидал. | Столь категоричное изменение жизни далось ему с трудом. %name% побывал на месте, где когда-то стоял его дом, и нашёл только замшелый фундамент с лагерем бандитов. При виде него вооружённые люди тут же сбежали.}";
		}
	}

	function onChangeAttributes()  //'tag' denotes a skill that is increased, 'untag' denotes a skill that is decreased below the base
	{
		local c = {
			Hitpoints = [ //untag
				9,
				13
			],
			Bravery = [
				5,
				10
			],
			Stamina = [
				20,
				25
			],
			MeleeSkill = [
				8,
				10
			],
			RangedSkill = [
				-50,
				-50
			],
			MeleeDefense = [
				3,
				6
			],
			RangedDefense = [
				5,
				7
			],
			Initiative = [ //tag
				20,
				40
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
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Не может носить броню тела или головы[/color], но получает на [color=" + this.Const.UI.Color.PositiveValue + "]10%[/color] меньше урона от прямых атак. Порог получения травм увеличен на [color=" + this.Const.UI.Color.PositiveValue + "]30%[/color]"
			}
		)
		return ret
	}
	
	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();

		local r;
		r = this.Math.rand(0, 4);

		if (r == 0)
		{
		    items.equip(this.new("scripts/items/weapons/ancient/broken_ancient_sword"));
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
		else if (r == 4)
		{
		    items.equip(this.new("scripts/items/weapons/ancient/khopesh"));
		}
		else if (r == 4)
		{
		    items.equip(this.new("scripts/items/weapons/ancient/legend_sica"));
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.DamageReceivedRegularMult *= 0.90; //10% reduction
		_properties.ThresholdToReceiveInjuryMult *= 1.30; //+30% higher threshold
	}

});
