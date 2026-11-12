this.vp_piro_background <- this.inherit("scripts/skills/backgrounds/character_background", {
    m = {},
    function create()
    {
        this.character_background.create();
        this.m.ID = "vp.piro.background";
        this.m.Icon = "ui/backgrounds/backgrounds_piro.png";
        this.m.Name = "Пиромант";
		this.m.BackgroundDescription = "Огонь не спрашивает разрешения. И пироманты тоже.";

        this.m.HiringCost = 3000;
        this.m.DailyCost = 35;
        this.m.ExcludedTalents = [
            ::Const.Attributes.Hitpoints
        ];
        this.m.Excluded = [
            "trait.impatient"
            "trait.iron_jaw"
            "trait.clubfooted"
            "trait.dumb"
            "trait.insecure"
            "trait.loyal"
            "trait.fainthearted"
            "trait.brute"
            "trait.superstitious"
        ];
        this.m.Titles = [
            "Пламенный",
            "Разрушающий",
            "Горячий",
            "Огненный",
        ];
		this.m.Bodies = ::Const.Bodies.SouthernMale;
		this.m.Faces = ::Const.Faces.SouthernMale;
		this.m.Hairs = ::Const.Hair.SouthernMale;
		this.m.HairColors = ::Const.HairColors.Southern;
		this.m.Beards = ::Const.Beards.Southern;
		this.m.BeardChance = 0;
		this.m.Ethnicity = 1;
		this.m.Names = this.Const.Strings.SouthernNames;
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

	function getGenericTooltip()
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
				text = this.getBackgroundDescription()
			}
		];
	}

    function onBuildDescription()
    {
//        return "{Некоторые думают, что он колдун. Другие — что он просто псих. %name% не спорит. Истина где-то посередине: он псих-колдун, который умеет делать так, чтобы враги превращались в факелы. | %name% утверждает, что мёртвым всё равно. Живым — нет. Поэтому он будет палить до тех пор, пока останется хоть один враг, способный кричать. А потом — ещё немного. Просто так. | Одетый в прожжённый балахон, пропахший серой и дешёвым вином, %name% скорее напоминает неудачливого фокусника, чем опасного мага. | Из-под капюшона %name%а видны лишь опалённые брови и бесконечная, немного безумная улыбка человека, который слишком много раз вдыхал дым. | %name% не любит говорить о прошлом. Но его руки помнят каждое возгорание. Шрамы от ожогов покрывают пальцы, ладони, запястья. Это не метки безумца. Это календарь.}";
        return "{С ранних лет %name% проявлял странную склонность к огню: свечи вспыхивали сами собой, стоило ему рассердиться. | Родившись в семье угольщика, %name% с детства проводил дни среди жара печей и вскоре открыл в себе необычный дар. | Старый отшельник, живший вдали от людских глаз, признал в %name% редкий талант и взял его в ученики. | Когда молния ударила в дом %name%а, тот вышел из пламени невредимым, словно сама стихия признала его своим. | В библиотеке города %townname% %name% нашёл древний трактат, посвящённый искусству повелевать пламенем, и посвятил ему долгие годы. | Говорят, %name% изучал забытые огненные ритуалы в руинах близ %randomtown%, где даже камни хранят следы древнего жара. | Будучи сыном кузнеца, %name% куда больше интересовался не металлом, а самим пламенем, рождавшимся в горне. | Никто не знает, кто научил %name% обращаться с огнём. Сам он лишь загадочно улыбается, когда его спрашивают об этом.} {Но жители деревни быстро решили, что такой дар — проклятие, и однажды ночью попытались сжечь его заживо. Им это не удалось. | Однако любопытство вскоре переросло в одержимость, и %name% начал искать всё более опасные способы подчинить себе пламя. | Со временем церковь объявила его искусство ересью, вынудив %name%а покинуть родные земли. | Но однажды неудачная попытка укротить пламя обратила в пепел дом его наставника. С тех пор %name% путешествует в одиночку. | Его знания становились всё глубже, а нрав — всё горячее. Вскоре ни один город не желал терпеть столь опасного человека. | Однажды %name% понял, что огонь требует не только власти, но и жертв. Ответ на вопрос, какую цену он уже заплатил, остаётся при нём. | После пожара, уничтожившего половину города, никто так и не смог доказать вину %name%а. Но ждать нового суда он не стал. | Чем лучше %name% овладевал пламенем, тем сильнее ему казалось, что где-то среди языков огня ему отвечает нечто древнее и чуждое. | Его мастерство принесло не славу, а страх. Люди охотнее нанимали палачей, чем человека, способного обратить улицу в костёр. | Даже среди тех, кто изучал тайные искусства, %name% считался человеком опасным: слишком часто его опыты выходили из-под контроля. | Когда его последняя лаборатория сгорела вместе со всеми записями, %name% решил, что знания лучше искать в дороге, чем восстанавливать утраченное. | Никто не знает, было ли это случайностью или умыслом, но после смерти наставника %name% больше никогда не называл себя учеником.} {Пожалуй, лучше иметь такого человека рядом, чем видеть его среди врагов. | Каждый вечер %name% подолгу смотрит в костёр так, словно разговаривает с ним. | Огонь — грозное оружие. Остаётся лишь надеяться, что %name% умеет управлять им не хуже, чем утверждает. | Пламя способно обратить в бегство целую толпу. Вопрос лишь в том, кого %name% сочтёт своим врагом. | Глядя на %name%а, вы невольно задумываетесь, кто представляет большую опасность — враги или его собственное пламя. | Даже стоя у обычного лагерного костра, %name% выглядит так, словно ему чего-то не хватает. | Вы замечаете, что %name% почти никогда не мёрзнет, независимо от времени года. | Говорят, иной раз огонь решает спор быстрее, чем самая острая сталь. | Одни называют %name% гением, другие — безумцем. Обычно это зависит от того, кто именно загорелся. | %name% говорит негромко, но искры, время от времени проскакивающие между его пальцами, убеждают лучше любых слов. | Воздух вокруг %name%а пахнет золой даже тогда, когда поблизости ничего не горит. | Если хотя бы половина слухов о %name% правдива, лучше не спорить с ним возле стога сена. | Во взгляде %name%а есть странное спокойствие, какое бывает лишь у людей, привыкших смотреть на пожар. | Даже когда %name% неподвижен, кажется, будто внутри него что-то продолжает гореть. | Если %name% действительно владеет огнём так, как говорят, он может стать ценным приобретением. Или большой ошибкой. | Возможно, %name% окажется именно тем человеком, которого стоит взять в отряд. А возможно, именно тем, кого следовало оставить позади.}"
    }

    function onChangeAttributes()
    {
        local c = {
            Hitpoints = [-10, 0]
            Bravery = [10, 20]
            Stamina = [-5, 10]
            MeleeSkill = [0, 0]
            RangedSkill = [10, 10]
            MeleeDefense = [0, 3]
            RangedDefense = [-3, 3]
            Initiative = [0, 10]
        };

        return c;
    }

    function onAdded()
    {
        this.character_background.onAdded();
        this.m.Container.add(::new("scripts/skills/actives/sb_fireball_skill"));
        if (!this.m.Container.hasSkill("trait.bright"))
        {
            this.m.Container.add(this.new("scripts/skills/traits/bright_trait"));
        }
    }

    function onSetAppearance()
    {
		local actor = this.getContainer().getActor();
		local xhead = actor.getSprite("head");
		local hair_type = [
			"01",
			"02",
			"04",
			"06",
			"07",
			"10",
			"13",
			"14",
			"15",
			"19",
			"20",
			"21",
			"southern_03"
		];
		xhead.setBrush("bust_head_787" + this.Math.rand(4, 5));
		actor.getSprite("hair").setBrush("hair_" + this.Const.HairColors.All[this.Math.rand(0, this.Const.HairColors.All.len() - 1)] + "_" + hair_type[this.Math.rand(0, hair_type.len() - 1)]);
    }

    function onAddEquipment()
    {
        local items = this.getContainer().getActor().getItems();
        local roll = ::Math.rand(1, 3);
        items.equip(::new("scripts/items/weapons/xxmagicstaff"));
        if (roll == 1) {
            items.equip(::new("scripts/items/armor/oriental/nomad_robe"));
        } else if (roll == 2) {
            items.equip(::new("scripts/items/armor/oriental/nomad_robe"));
            items.equip(::new("scripts/items/helmets/oriental/engineer_hat"));

        } else {
            items.equip(::new("scripts/items/armor/oriental/cloth_sash"));
            items.equip(::new("scripts/items/helmets/oriental/nomad_head_wrap"));
        }
    }
});
