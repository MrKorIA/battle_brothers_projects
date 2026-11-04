this.vp_demon_background <- this.inherit("scripts/skills/backgrounds/character_background", {
    m = {},
    function create()
    {
        this.character_background.create();
        this.m.ID = "vp.demon.background";
        this.m.Icon = "ui/backgrounds/backgrounds_demon.png";
        this.m.Name = "Одержимый";
		this.m.BackgroundDescription = "Одержимый — человек, посвятивший себя изучению ужасов потустороннего. От изученного он обезумел. Возможно, в него вселился демон — этого никто не знает. Но он ищет временных союзников, а вы ищете полезного спутника.";
		this.m.GoodEnding = "Через несколько лет после расставания вы услышали о монастыре, где монахи нашли способ изгонять тьму не молитвами, а именами, — и назвали своим наставником человека, знающего эти имена лучше всех. %name% отвечал на письма коротко и аккуратно, о себе — ничего. Последняя строка последнего письма гласила: «Мы теперь в расчёте. Спи спокойно».";
		this.m.BadEnding = "От бывших соратников вы узнали, что однажды ночью %name% собрал свои вещи, поблагодарил отряд за гостеприимство и ушёл в сторону старых руин. Больше его не видели. Лишь спустя годы караванщики стали рассказывать о развалинах, где по ночам раздаётся чей-то вежливый голос, зовущий на помощь, — и о смелых глупцах, которые повелись на этот крик и никогда не вернулись назад.";

        this.m.HiringCost = 1000;
        this.m.DailyCost = 15;
        this.m.ExcludedTalents = [
            ::Const.Attributes.Hitpoints
        ];
        this.m.Excluded = [
            "trait.iron_jaw"
            "trait.clubfooted"
            "trait.dumb"
            "trait.insecure"
            "trait.fainthearted"
            "trait.brute"
        ];
        this.m.Titles = [
            "Одержимый",
            "Безумный",
            "Проклятый",
            "Чернокнижник",
        ];
		this.m.Bodies = ::Const.Bodies.Skinny;
		this.m.Faces = ::Const.Faces.Necromancer;
		this.m.Hairs = ::Const.Hair.Necromancer;
		this.m.HairColors = ::Const.HairColors.Zombie;
		this.m.Beards = ::Const.Beards.Raider;
		this.m.BeardChance = 30;
		this.m.Ethnicity = 0;
		this.m.Names = this.Const.Strings.BarbarianNames;
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
                text = "Владеет запретными путями силы: Путь крови или Путь демона. Выбор пути закрывает другой навсегда."
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
                text = "Владеет запретными путями силы: Путь крови или Путь демона. Выбор пути закрывает другой навсегда."
            }
		];
	}

    function onBuildDescription()
    {
        return "{%name% когда-то был учёным, решившим, что разум способен объять то, для чего не сотворена человеческая плоть. | В монастырской библиотеке %name% нашёл фолиант, переплетённый в кожу чего-то, о чём никто не решился спросить. | %name% начинал искателем древностей, скупая у гробарей и воров всё, что пахло тленом и было старше трёхсот лет. | Говорят, %name% спорил с тенями в развалинах близ %randomtown% — и спорил не как безумец, а как адвокат. | Коллеги-хронисты считали его безумцем ещё до того, как он перестал с этим спорить. | %name% родился в богатом доме, получил прекрасное образование, а затем заперся в кабинете, где ночами горела лампа, пока весь город спал.} {А однажды он заглянул достаточно глубоко — и что-то оттуда, по всей видимости, ответило. | И чем дальше забирался его разум, тем теснее становилось всё человеческое: сначала он перестал спать, потом — смеяться, а затем и вовсе начал здороваться с пустыми углами. | Однажды он понял, что изучает не мёртвые тексты и старые камни, а то, что смотрит на него сквозь них. С этого дня прежним его не видел никто. | А познание, как выяснилось, берёт своё: сперва ушёл сон, потом — аппетит, и вскоре знакомые стали обходить его стороной.} {Теперь он ищет тех, кому нужен его дар, — и не возражает против найма, пока вы не спрашиваете, кто именно в нём спит. | Он вежлив, услужлив и безупречно опрятен — и только кошки шипят на него с другого конца улицы. | В его глазах будто бы живёт нечто чужое; сам он лишь улыбается и предлагает свои услуги. | Наблюдательные люди замечают, что его тень движется с полусекундным опозданием. | Он охотно расскажет вам о звёздах, о письменах мёртвых цивилизаций и о цене обоих — главное, не спрашивайте, почему он рассказывает это вам так подробно.}";
    }

    function onChangeAttributes()
    {
        local c = {
            Hitpoints = [-10, 10]
            Bravery = [-10, 10]
            Stamina = [-10, 10]
            MeleeSkill = [-10, 10]
            RangedSkill = [-5, 5]
            MeleeDefense = [-5, 5]
            RangedDefense = [-5, 5]
            Initiative = [-10, 10]
        };

        return c;
    }

    function onAdded()
    {
        this.character_background.onAdded();
        this.m.Container.add(::new("scripts/skills/actives/sb_slander_skill"));
    }

    function onSetAppearance()
    {
		local actor = this.getContainer().getActor();
		local xbody = actor.getSprite("body");
		local xhead = actor.getSprite("head");
		local xhair = actor.getSprite("hair");
		local tattoo_head = actor.getSprite("tattoo_head");
		local tattoo_body = actor.getSprite("tattoo_body");
		local hair_color = this.Const.HairColors.Zombie[this.Math.rand(0, 1)]

		if (this.Math.rand(1, 2) == 1)
		{
			xhead.Color = this.createColor("#595350");
			xhead.Saturation = 0.5;
		}
		else
		{
			xhead.Color = this.createColor("#784b2f");
			xhead.Saturation = 0.9;
		}
		xbody.Color = xhead.Color;
		xbody.Saturation = xhead.Saturation;
		if (this.Math.rand(1, 2) == 1)
		{
			tattoo_head.setBrush("warpaint_01_head");
			tattoo_body.setBrush("warpaint_01_bust_naked_body_00");
		}
		else
		{
			tattoo_head.setBrush("scar_02_head");
			tattoo_body.setBrush("scar_02_bust_naked_body_00");
		}
		tattoo_body.Scale = 0.8;
		tattoo_head.Visible = true;
		tattoo_body.Visible = true;

		local hair_type = [
			"",
			"",
			"hair_black_03",
			"hair_brown_03",
			"hair_grey_03",
			"hair_black_03",
			"hair_brown_03",
			"hair_grey_03",
			"hair_black_southern_05",
			"hair_brown_southern_05",
			"hair_grey_southern_05"
		];
		xhair.setBrush(hair_type[this.Math.rand(0, hair_type.len() - 1)]);
    }

    function onAddEquipment()
    {
        local items = this.getContainer().getActor().getItems();
        local roll = ::Math.rand(1, 3);
        items.equip(::new("scripts/items/weapons/cp_reinforced_wooden_staff"));
        if (roll == 1) {
            items.equip(::new("scripts/items/armor/thick_dark_tunic"));
        } else if (roll == 2) {
            items.equip(::new("scripts/items/armor/ragged_dark_surcoat"));
            items.equip(::new("scripts/items/helmets/hood"));

        } else {
            items.equip(::new("scripts/items/armor/thick_dark_tunic"));
            items.equip(::new("scripts/items/helmets/barbarians/leather_headband"));
        }
    }
});
