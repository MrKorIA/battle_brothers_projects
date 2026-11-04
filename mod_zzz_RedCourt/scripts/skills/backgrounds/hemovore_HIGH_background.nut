this.hemovore_HIGH_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {
	    IsFemale = false
	},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hemovore_HIGH"; //is very old. Is lord/lady
		this.m.Icon = "ui/backgrounds/Background_hemovore_HIGH_male.png";
		this.m.Name = "Патриарх";
		this.m.BackgroundDescription = "Возможно, прославленные воины или полководцы, эти древние питают непоколебимое отвращение ко всем живым существам - как большим, так и малым. Для них война никогда не заканчивается.";
		this.m.GoodEnding = "%name% довольно хорошо адаптировался в обществе, со временем приобретя влияние, чтобы перенаправлять отряды рейдеров и патрули подальше от мест, которые он называл своим домом. Эти действия позволили падшей империи выиграть время, чтобы организоваться и нанести удар там, где дворяне были слабее всего, что в конечном итоге позволило уничтожить цивилизацию жестоким и эффективным способом.";
		this.m.BadEnding = "Стремление к власти обернулось для него гибелью - %name% вернулся домой и использовал свою славу, чтобы собрать армию под своим знаменем, только чтобы забыть о том, что защитные чары могли бы изменить его судьбу в тот момент, как какой-то легионер пронзал его пикой.";		
		this.m.HiringCost = 1050;
		this.m.DailyCost = 58;
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
		this.m.Faces = ["bust_vampire_lord_head_04"]; //could also be 01 or 02 or 03
		this.m.Bodies = ["bust_vampire_lord_body_01"]; //could also be 02 or 03
		this.m.Hairs = this.Const.Hair.Vampire;
		this.m.HairColors = this.Const.HairColors.Zombie;
		// this.m.Beards = this.Const.Beards.Tidy;

		this.m.Level = this.Math.rand(2, 4);
		this.m.Names = this.Const.Strings.AncientSouthernNames;
		this.m.Titles = this.Const.Strings.AncientDeadTitles;
		// this.m.LastNames = this.Const.Strings.SouthernNamesLast;
		if (::Math.rand(0, 1) == 0) this.m.IsFemale = true;
	}

    function onSetAppearance()
    {
        if (this.m.IsFemale)
        {
                //Female
            local actor = this.getContainer().getActor();
            actor.getSprite("head").setBrush("bust_vampire_lady_head_02");
            actor.getSprite("body").setBrush("bust_vampire_lady_body_02");
            actor.getSprite("beard").setBrush("");
            actor.getSprite("beard_top").setBrush("");
            actor.setName(this.Const.Strings.SouthernFemaleNames[this.Math.rand(0, this.Const.Strings.SouthernFemaleNames.len() - 1)]);
            this.m.Name = "Матриарх";
            this.m.Icon = "ui/backgrounds/Background_hemovore_HIGH_female.png";
            this.m.BackgroundDescription = "Служа своему дому и действуя от имени своих партнеров, эти дамы тёмной крови удовлетворяют нужды своего дома так же, как и в прошлой жизни.";
            this.m.GoodEnding = "%name% довольно хорошо адаптировалась в обществе, со временем приобретя влияние, чтобы перенаправлять отряды рейдеров и патрули подальше от мест, которые она называла своим домом. Эти действия позволили падшей империи выиграть время, чтобы организоваться и нанести удар там, где дворяне были слабее всего, что в конечном итоге позволило уничтожить цивилизацию жестоким и эффективным способом.";
            this.m.BadEnding = "Стремление к власти обернулось для неё гибелью - %name% вернулась домой и использовала свою славу, чтобы собрать армию под своим знаменем, только чтобы забыть о том, что защитные чары могли бы изменить её судьбу в тот момент, как какой-то легионер пронзал её пикой.";
        }
    }

	function onBuildDescription()
	{
		if (this.m.IsFemale) //female
		{
			return "{Из всех женщин империи %name% была одной из самых влиятельных. | %name% всегда тяготела к сверкающим золотым побрякушкам высшей аристократии. | Некогда %name% была ничтожной служанкой, но её выдали за мужчину вдвое старше. | Старые жестокие шрамы говорят о мучительном прошлом, которое %name% предпочитает не вспоминать.} {Когда %name% достигла безбедной жизни и неслыханно разбогатела, на неё навалилась скука. Тогда-то она и попалась в ловушку повсеместных культов, в которых можно скоротать время и развлечься. | %name% утратила благосклонность высшего общества, когда оказалась причастна к неудачному перевороту. Она утверждает, что переворот должен был быть бескровным, но другие члены группы оказались влиятельнее. | Оставшись совершенно одна на свете, %name% не имела ничего, ради чего стоило бы жить, и покончила с собой после гибели мужа в походе. Культы предлагали быстрый способ 'начать всё с начала', но это было не то, чего стоило бы хотеть. | Ей очень нравилось посещать великую библиотеку на юге - труды учёных неизменно ублажали её ум. Когда наступил крах, она вынесла всё, что смогла, но оказалась погребена под горящим зданием - и то, что выбралось из-под завала, было уже не прежней %name%. | Когда-то она была прислугой у одного мистика и часто бывала на вершине его башни. Он постоянно говорил, что можно заглянуть так далеко, что увидишь даже наступление конца света. Это была ложь.} {%name%, покрытая древними, смертельными шрамами, теперь бродит по миру, стремясь разобраться в том, что произошло столько лет назад. | После ставшей легендой вашей размолвки с советом древних, %name% разыскала вас. Дворянка в душе, она кровожадна так же, как и любой другой представитель вашего рода. | После неудачного грабежа небольшой фермы %name% укрылась в лесу. Любая нормальная женщина скончалась бы от полученных ран. Может, так и было бы, но ей несказанно повезло наткнуться на вас. | В новой жизни мало что изменилось - войны продолжаются, людей убивают десятками... это заставляет задуматься, а изменилось ли вообще что-нибудь. | Время от времени %name% любит притвориться ведьмой, которая ест детей. Её ловят, приводят к костру для казни, но перед самым возжиганием %name% гогоча исчезает. Почему она это делает, остаётся загадкой.}";
		}
		else //male
		{
			return "{%name% был рождён править, и он правил крошечным гарнизоном на краю неизвестности. | Даже до превращения %name% был для многих чудовищем - он наслаждался страданиями и частенько наблюдал за казнями. | Никакие стратегические планы, карты и фигурки не могли подготовить к тому, что грядёт. | Спустя годы суровой и ответственной службы %name% остался лишь с ничего не значащим титулом и потёртыми доспехами.} {Его бесцеремонно сбросили с коня в далёкой безымянной битве. Следом топор пробил грудную клетку. %name% очнулся в палатке, где лекари делали всё возможное, чтобы облегчить муки. Вскоре пришёл человек в чёрном и предложил выход - тут-то всё и пошло наперекосяк. | Став наёмником, %name% исколесил всю империю, служа правителям, которые не желали даже видеть его. Во время ужасной бури конь оступился, и %name% упал в глубокую тёмную расщелину. Там он встретил свой конец. И там его нашли. | Позже %name% был надсмотрщиком на грандиозной стройке. В какой-то момент он оказался на остриях дюжины кинжалов в руках рабов, которыми управлял. | Годы верной службы вознаградили его спокойной смертью, но соблазн получить больше времени был слишком силён. | Один из многих почётных стражей в империи, %name% должен был вершить правосудие во имя императора. Многолетние военные кампании, казалось, так ни на что и не повлияли. Когда небо упало и мир остановился, %name% уже не смог найти в себе сил сражаться.} {Он провёл две человеческие жизни в попытке найти смысл в новом мире. Враги, кричавшие всякую чушь при виде него, немного скрашивали это время. | Он долгое время был один, но для безопасности путешествовал со стаями другой нежити. Иногда он заглядывал в пустые глазницы легионеров в надежде увидеть хоть что-нибудь. | Новый мир странен, новое существование - ещё страннее. %name% полагается только на надежду восстановить утраченное.}";
		}
	}

	function onChangeAttributes() //'tag' denotes a skill that is increased, 'untag' denotes a skill that is decreased below the base
	{
		local c = {
			Hitpoints = [//tag
				18,
				25
			],
			Bravery = [
				11,
				17
			],
			Stamina = [
				20,
				25
			],
			MeleeSkill = [ //raise by default
				20,
				30
			],
			RangedSkill = [
				-50,
				-50
			],
			MeleeDefense = [//tag
				12,
				16
			],
			RangedDefense = [
				5,
				7
			],
			Initiative = [//untag
				5,
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
		local ret = this.character_background.getTooltip();
		ret.push(
			{
				id = 13,
				type = "text",
				icon = "ui/icons/armor_body.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Не может носить броню тела или головы[/color], но получает на [color=" + this.Const.UI.Color.PositiveValue + "]20%[/color] меньше урона от прямых атак. Порог получения травм увеличен на [color=" + this.Const.UI.Color.PositiveValue + "]75%[/color]"
			}
		);
		return ret;
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
		    items.equip(this.new("scripts/items/weapons/ancient/legend_fan_axe"));
		}
		else if (r == 2)
		{
		    items.equip(this.new("scripts/items/weapons/ancient/rhomphaia"));
		}
		else if (r == 3)
		{
		    items.equip(this.new("scripts/items/weapons/ancient/crypt_cleaver"));
		}
		else if (r == 4)
		{
		    items.equip(this.new("scripts/items/weapons/ancient/legend_great_khopesh"));
		}
		else if (r == 5)
		{
		    items.equip(this.new("scripts/items/weapons/ancient/legend_broadhead_spear"));
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.DamageReceivedRegularMult *= 0.80; //20% reduction
		_properties.ThresholdToReceiveInjuryMult *= 1.75; //+75% higher threshold
	}

});
