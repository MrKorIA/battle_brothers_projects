this.hemovore_MED_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {
	    IsFemale = false
	},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hemovore_MED"; //is somewhat old
		this.m.Icon = "ui/backgrounds/Background_hemovore_MED_male.png";
		this.m.Name = "Служитель";
		this.m.BackgroundDescription = "Адепты когда-то были основой вечной империи - в их рядах было много купцов, банкиров и мелких дворян. Закрытое общество, в котором они когда-то процветали, исчезло, но жажда власти осталась.";
		this.m.GoodEnding = "Несмотря на потерю всего, %name% смог вернуть часть потерянного заработка, хотя и в новой валюте, к которой он не привык. На вырученные кроны %name% купил дом в центре города и маскировался под торговца, переезжая из города в город каждые несколько десятилетий, чтобы местные жители не задавали вопросов о том, как ему удаётся сохранять молодость.";
		this.m.BadEnding = "Как и раньше, жадность в конце концов доконала его. Притягательность золота побудила присоединиться к другому отряду наёмников, которые обратили внимание на его сверхъестественные способности, и %name% оказался на другом конце кола, торчащего из его сердца.";			
		this.m.HiringCost = 600;
		this.m.DailyCost = 35;
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

		this.m.Level = this.Math.rand(1, 3);
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
            this.m.Icon = "ui/backgrounds/Background_hemovore_MED_female.png";
            this.m.Name = "Служительница";
            this.m.BackgroundDescription = "Мириады культов по всей империи привлекали людей из всех слоев общества, включая средний класс империи, который теперь служит той же силе, что поработила их раньше - только в более жёстокой форме.";
            this.m.GoodEnding = "Несмотря на потерю всего, %name% смогла вернуть часть потерянного заработка, хотя и в новой валюте, к которой она не привыкла. На вырученные кроны %name% купила дом в центре города и маскировалась под торговца, переезжая из города в город каждые несколько десятилетий, чтобы местные жители не задавали вопросов о том, как ей удаётся сохранять молодость.";
            this.m.BadEnding = "Как и раньше, жадность в конце концов доконала её. Притягательность золота побудила присоединиться к другому отряду наёмников, которые обратили внимание на её сверхъестественные способности, и %name% оказалась на другом конце кола, торчащего из её сердца.";
        }

    }

	function onBuildDescription()
	{


		if (this.m.IsFemale) //female
		{
			return "{Выходец из бедной крестьянской семьи, %name% всю жизнь карабкалась к вершинам славы и, в конце концов, стала известным торговцем. | %name% не была создана для тяжёлого труда или войны — зато она нашла себе место в самом сердце империи, в качестве управляющей в государственном ведомстве по общественным работам. | Бывшая некогда казначеем и торговцем, %name% всегда знала толк в звонкой монете. Некоторые шутят, что она с тех пор ничуть не изменилась.} {Но её должны были повесить за хищение средств у своего работодателя — вместо этого ей предложили расплатиться с долгами службой на империю. | Шли годы, и она воочию увидела падение империи — видела, как рушатся мраморные колоннады и горят библиотеки. | Тем временем религии империи перемешались и сплелись в единый культ, но за этим фасадом она обнаружила нечто гораздо более тёмное. Всё пошло наперекосяк прежде, чем она успела опубликовать свои открытия. | Ещё в юном возрасте она присоединилась к культу — с детства она была посвящена в его ряды. Так она пыталась сберечь наследие людей, которых любила, но взгляды культа и её собственные слишком разошлись. | Тогда же она заключила сделку, толком не зная, что та на самом деле таит, — но соблазн бессмертия и вечности за пределами привычного бытия был слишком велик} {В своей новой жизни %name% продолжает хранить традиции и честь империи. | Как бы страшно ни было, вы предлагаете ей окунуться в этот новый, пусть и примитивный, мир. | После долгих лет скитаний в тени прошлого %name% наконец готова дать отпор. | Монеты и имена изменились, но битва за существование продолжается. | %name% могла бы быть неприметной, если бы не острые клыки и выпирающая челюсть.}";
		}
		else //male
		{
			return "{%name% игнорировал прелести городской жизни, вместо этого посвятив годы карьере торговца. | По иронии судьбы, %name% был смотрителем одного из самых дорогих кладбищ империи. Днями и ночами он стерёг гробницы людей из высшего сословия от воров. | Когда-то %name% был известным поединщиком и гладиатором. | %name% служил легионером империи — одним из тех, кто покорял новые земли и расширял её границы.} {После многих лет верной службы его предал близкий друг и наставник, за свои старания %name% был вздёрнут на виселице. | Но он попал в шумную ссору, обернувшуюся жестокой поножовщиной, и, хоть оказался удачливее прочих, всё равно лежал в луже собственной крови. | Он всегда мечтал о чём-то большем, чем его прежняя жизнь. Когда к нему обратился некий деятель с предложением стать опорой для империи на долгие годы, %name% не смог отказаться. | Но, ввязавшись в затею, которая плачевно закончилась, он потерял расположение местного культа и оказался в сердце ритуала, о котором так много слышал. | Как он стал тем, кто он есть, остаётся загадкой, но %name%  воспринял это как должное и пользуется всеми преимуществами своего новообретённого бессмертия.} {Теперь он любит поохотиться по ночам. Хотя не обязательно заниматься этим ночью, но во тьме страх смертных намного сильнее и ярче. | Незадолго до встречи с вами %name% попался нескольким охотникам на ведьм. К счастью, простая верёвка не может надолго удержать существо такой силы. | Поначалу он беспокоился вопросом жажды крови и гибели своей пищи. Через некоторое время он кое-что придумал. Он носит с собой небольшую книгу, в которой указывает возраст, пол и даже местонахождение всех жертв, из которых пьёт кровь. Некоторые из них - домашний скот. | После близкого знакомства с алебардами, он отказался от попыток оживить свой боевой дух. Иногда благоразумие - лучшая сторона доблести, но овечья кровь порой удручает.}";
		}
	}

	function onChangeAttributes() //'tag' denotes a skill that is increased, 'untag' denotes a skill that is decreased below the base
	{
		local c = {
			Hitpoints = [
				10,
				28
			],
			Bravery = [ //raise as default
				8,
				14
			],
			Stamina = [ //tag
				20,
				40
			],
			MeleeSkill = [ //tag
				15,
				35
			],
			RangedSkill = [
				-50,
				-50
			],
			MeleeDefense = [
				5,
				15
			],
			RangedDefense = [
				5,
				15
			],
			Initiative = [
				10,
				30
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
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Не может носить броню тела или головы[/color], но получает на [color=" + this.Const.UI.Color.PositiveValue + "]10%[/color] меньше урона от прямых атак. Порог получения травм увеличен на [color=" + this.Const.UI.Color.PositiveValue + "]50%[/color]"
			}
		)
		return ret
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();

		local r;
		r = this.Math.rand(0, 5);

		if (r == 0)
		{
		    items.equip(this.new("scripts/items/weapons/ancient/khopesh"));
		}
		else if (r == 1)
		{
		    items.equip(this.new("scripts/items/weapons/ancient/warscythe"));
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
		    items.equip(this.new("scripts/items/weapons/ancient/legend_gladius"));
		}
		else if (r == 5)
		{
		    items.equip(this.new("scripts/items/weapons/ancient/crypt_cleaver"));
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.DamageReceivedRegularMult *= 0.90; //10% reduction
		_properties.ThresholdToReceiveInjuryMult *= 1.50; //+50% higher threshold
	}

});
