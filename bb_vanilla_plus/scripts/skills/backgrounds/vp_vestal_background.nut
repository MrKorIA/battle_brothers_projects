this.vp_vestal_background <- this.inherit("scripts/skills/backgrounds/character_background", {
    m = {},
    function create()
    {
        this.character_background.create();
        this.m.ID = "vp.vestal.background";
        this.m.Icon = "ui/backgrounds/backgrounds_vestal.png";
        this.m.Name = "Весталка";
		this.m.BackgroundDescription = "Весталка — жрица старых богов, посвятившая себя защите человечества от ужасов несмерти и потусторонних сил. Она ищет союзников, которым можно доверять во тьме.";
		this.m.GoodEnding = "Спустя годы после расставания священник одного захолустного храма спросил вас, не встречались ли вы с женщиной по имени %name%. Вы ответили как смогли. «Она вернула культ старых богов в трёх деревнях, — сказал он. — Мертвецы там больше не поднимаются. Люди спят спокойно». В ту ночь вы впервые за долгое время выпили с лёгким сердцем — за неё.";
		this.m.BadEnding = "Последнее, что вы узнали о женщине по имени %name%, был рассказ торговца, ночевавшего в разорённой деревне: перед рассветом из леса вышла фигура в обгоревшем одеянии, обошла дома, что-то тихо бормоча, — и мертвецы, поднявшиеся в сумерках, легли обратно в землю. Он не решился заговорить с ней. «Глаза у неё были как у статуй в старых капищах», — сказал он и сделал охранный знак. Больше о ней никто не слышал.";

        this.m.HiringCost = 500;
        this.m.DailyCost = 15;
        this.m.ExcludedTalents = [
            ::Const.Attributes.Hitpoints
        ];
        this.m.Excluded = [
            "trait.dumb"
            "trait.craven"
            "trait.fainthearted"
            "trait.insecure"
        ];
        this.m.Titles = [
            "Светлая",
            "Непоколебимая",
            "Верная",
            "Храмовая",
        ];
		this.m.Bodies = ::Const.Bodies.Skinny;
		this.m.Faces = ::Const.Faces.AllMale; // женский облик задаётся кистями в onSetAppearance (как в xxi_female)
		this.m.Hairs = null;
		this.m.HairColors = ::Const.HairColors.Old;
		this.m.Beards = null;
		this.m.BeardChance = 0;
		this.m.Ethnicity = 0;
		this.m.Names = this.Const.Strings.CharacterNamesFemale;
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
            },
            {
                id = 10,
                type = "text",
                icon = "ui/icons/special.png",
                text = "Жрица старых богов: исцеление, чудеса и защита от нежити."
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
			},
            {
                id = 10,
                type = "text",
                icon = "ui/icons/special.png",
                text = "Жрица старых богов: исцеление, чудеса и защита от нежити."
            }
		];
	}

    function onBuildDescription()
    {
        return "{%name% служила в храме, который стоит на холме и старше любого города в этих краях, — там же, где до неё провела жизнь её мать. | В детстве она пережила набег нежити, и монахини говорят, что с тех пор свет в её глазах стал немного другим. | %name% выучила наизусть все молитвы храма раньше, чем научилась читать по слогам. | Старые боги, которым она служит, уже не имеют ни алтарей, ни имён, что можно произнести вслух, — остались только храм да немногие верные. | Когда-то она была послушницей в храме у самого леса, пока не вернулась оттуда с ожогами от могильного света и твёрдым взглядом.} {Однажды её наставник вышел против нежити один — и не вернулся. | А вести о дальних логовах нежити копились быстрее, чем храм успевал их записывать. | Но однажды она поняла: молитвой могилу не закроешь — для этого нужны руки. | А прихожане беднели с каждым годом, и милостыни храму уже не хватало даже на ладан. | Но её жажда истребления нежити стала пугать даже тех, кто молился рядом.} {Теперь она нанимается к отрядам, что идут туда, куда не заходят священники, — и её молитвы там звучат иначе. | Она не говорит, скольких мертвецов отправила обратно в землю, но на её чётках столько зарубок, что места для новых почти не осталось. | Она вежлива, тиха и безотказна — но стоит заговорить о нежити, как свет в её глазах меняется, и собеседники невольно умолкают. | Она носит при себе храмовые книги, травы для окуривания и короткий посох — всё, что нужно для её службы.}";
    }

    function onChangeAttributes()
    {
        local c = {
            Hitpoints = [-10, 10]
            Bravery = [10, 20]
            Stamina = [0, 10]
            MeleeSkill = [0, 5]
            RangedSkill = [10, 0]
            MeleeDefense = [5, 10]
            RangedDefense = [5, 10]
            Initiative = [-10, 0]
        };

        return c;
    }

    function onAdded()
    {
        this.character_background.onAdded();
        this.m.Container.add(::new("scripts/skills/actives/sb_puri_skill"));
    }

    function onSetAppearance()
    {
		local actor = this.getContainer().getActor();
		local xbody = actor.getSprite("body");
		local xhead = actor.getSprite("head");
		local xhair = actor.getSprite("hair");
		local xtattoo_head = actor.getSprite("tattoo_head");
		xbody.setBrush("bust_naked_body_78" + this.Math.rand(69, 70));
		xhead.setBrush("bust_head_787" + this.Math.rand(0, 1));
		xhair.setBrush("hair_black_787" + this.Math.rand(0, 6));
		if (this.Math.rand(0, 3) == 0)
		{
			if (this.Math.rand(0, 1) == 0)
			{
				xtattoo_head.setBrush("bust_head_pox_01");
			}
			else
			{
				xtattoo_head.setBrush("bust_head_darkeyes_01");
			}
		}
    }

    function onAddEquipment()
    {
        local items = this.getContainer().getActor().getItems();
        items.equip(::new("scripts/items/armor/vp_vestal_armor"));
        items.equip(::new("scripts/items/helmets/vp_vestal_hood"));

        local weapon = ::MSU.Class.WeightedContainer().addMany(1, [
            "bludgeon",
            "winged_mace"
        ]).roll();

        items.equip(::new("scripts/items/weapons/" + weapon));
    }
});
