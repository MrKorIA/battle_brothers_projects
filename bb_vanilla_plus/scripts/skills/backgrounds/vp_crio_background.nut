this.vp_crio_background <- this.inherit("scripts/skills/backgrounds/character_background", {
    m = {},
    function create()
    {
        this.character_background.create();
        this.m.ID = "vp.crio.background";
        this.m.Icon = "ui/backgrounds/backgrounds_crio.png";
        this.m.Name = "Буревестник";
		this.m.BackgroundDescription = "В каждой стае есть птица, которая чует шторм раньше других. Буревестник — такая птица. Только он не прячется от бури. Он идёт прямо в неё. А остальные следуют за ним, потому что бояться уже поздно.";

        this.m.HiringCost = 100;
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
            "Хлад",
            "Бурлящий",
            "Серый",
            "Ветролом",
        ];
		this.m.Faces = this.Const.Faces.WildMale;
		this.m.Hairs = this.Const.Hair.WildMale;
		this.m.HairColors = this.Const.HairColors.Old;
		this.m.Beards = this.Const.Beards.WildExtended;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.BeardChance = 100;
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
        return "{Ещё в колыбели %name% научился угадывать дождь за день до того, как тучи сгущались над горизонтом. | %name% родился в семье рыбаков, и ветер всегда дул в его паруса — даже когда вокруг штиль. | Старейшины деревни говорили, что %name% заключил сделку с северным ветром, но он просто слушал, о чём шепчут облака. | В детстве %name% мог разогнать тучи одним взглядом — и часто делал это, чтобы поиграть на улице. | Его дед был корабельным штурманом и научил %name% читать небо, но мальчик пошёл дальше: он научился небо переписывать. | Однажды во время засухи %name% призвал ливень, спасший урожай всей деревни — и с тех пор его боялись и благодарили одновременно. | %name% рос у моря и знал, что ураганы — это голоса древних богов, а он — единственный, кто может им отвечать. | Многие считали его просто удачливым, но %name% знал правду: погода слушается его, как пёс — свистка.} {Но однажды он не сумел сдержать бурю. Шторм, который он случайно вызвал, унёс жизни трёх рыбацких лодок, и среди погибших был его отец. | В портовом городе, где жил %name%, его прозвали \'Глазом бури\' — и не в похвалу, а в насмешку, когда он случайно заморозил рынок в самый разгар ярмарки. | Его попытка помочь иссохшим полям обернулась градом, который выбил все посевы. Крестьяне прогнали %name% камнями. | Влюбившись в дочь кузнеца, %name% однажды в порыве ревности вызвал такой ветер, что снёс полгорода. После этого ему оставалось только бежать. | Он пытался уйти в монастырь, чтобы заглушить свой дар молитвой, но каждый раз, когда он сердился на братьев, в келье начинался сквозняк, а за окнами — буря. | Моряки, нанявшие %name% попутным ветром, получили вместо этого ураган и разбились о скалы. Выжил только он один. | В детстве %name% нечаянно заморозил пруд, где купались его друзья, — все выбрались, но с тех пор он боится даже прикоснуться к воде. | Когда его сестра тяжело заболела, %name% попытался призвать дождь, чтобы сбить жар, но вместо этого наслал на деревню снегопад посреди лета. Сестру спасли, а его выгнали.} {После всего этого %name% понял, что мирным жителям не место рядом с ним — он как незапертая клетка с ураганом внутри. | Он ищет отряд, где его дар будут считать оружием, а не проклятием, и где за ошибки платят не жизнями соседей, а только его собственной шкурой. | %name% устал молить о прощении. Теперь он хочет, чтобы враги молили о пощаде — под его дождём и ветром. | Говорят, наёмники не боятся ни бурь, ни чародеев, и %name% надеется, что среди них найдётся место и для такого, как он. | Он больше не хочет прятаться в горах и лесах. Если его дар приносит только беду, пусть он приносит беду врагам — и плату за неё. | %name% слышал, что в отрядах ценят тех, кто может переломить ход битвы одним движением руки. Он может. И готов доказать это. | Ему нужны не золото и не слава. Ему нужны люди, которые не станут креститься при виде тучи над лагерем. | %name% надеется, что среди головорезов и изгоев он найдёт тех, кто примет его таким, какой он есть — с ветром в крови и грозой в груди. | Если его проклятие можно обратить в пользу, то почему бы не сделать это с мечом в руке и ветром за спиной? | %name% больше не бежит от бури. Он сам станет бурей — но той, что бьёт только во врагов отряда.}";
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
        this.m.Container.add(::new("scripts/skills/actives/sb_gale_skill"));
        if (!this.m.Container.hasSkill("trait.bright"))
        {
            this.m.Container.add(this.new("scripts/skills/traits/bright_trait"));
        }
    }

    function onSetAppearance()
    {
		local actor = this.getContainer().getActor();
		local xhead = actor.getSprite("head");
		local xbody = actor.getSprite("body");
		local xhair = actor.getSprite("hair");
		local xbeard = actor.getSprite("beard");
		local xbeard_top = actor.getSprite("beard_top");
		local tattoo_body = actor.getSprite("tattoo_body");
		local hair_type = [
			"southern_03",
			"southern_03",
			"southern_03",
			"03",
			"18",
			"21"
		];
		hair_type = hair_type[this.Math.rand(0, hair_type.len() - 1)];
		local beard_type = [
			"southern_01",
			"southern_02"
		];
		beard_type = beard_type[this.Math.rand(0, beard_type.len() - 1)];
		local pp;

		actor.getSprite("hair").setBrush("hair_grey_" + hair_type);
		pp = this.Math.rand(1, 3);
		if (pp == 1)
		{
			actor.getSprite("beard").setBrush("beard_grey_" + beard_type);
			actor.getSprite("beard_top").setBrush(actor.getSprite("beard").getBrush().Name + "_top");
		}
		tattoo_body.setBrush("tattoo_0" + this.Math.rand(2, 4) + "_" + actor.getSprite("body").getBrush().Name);
		tattoo_body.Visible = true;
		if (this.Math.rand(0, 1) != 1)
		{
			xhead.Color = this.createColor("#73a6ff");
			xhead.setBrightness(1.1);
			xbody.setBrightness(1.1);
		}
		else
		{
			xhead.Color = this.createColor("#669eff");
		}
		xbody.Color = xhead.Color;
		xhair.Color = this.createColor("#faffff");
		xbeard.Color = xhair.Color;
		xbeard_top.Color = xhair.Color;
		xhead.Saturation = 0.9;
		xbody.Saturation = xhead.Saturation;
		xhair.Saturation = 2.0;
		xbeard.Saturation = xhair.Saturation;
		xbeard_top.Saturation = xhair.Saturation;
    }

    function onAddEquipment()
    {
        local items = this.getContainer().getActor().getItems();
        local roll = ::Math.rand(1, 3);
        items.equip(::new("scripts/items/weapons/xxarcanespear"));
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
