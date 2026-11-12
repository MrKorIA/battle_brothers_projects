this.vp_electro_background <- this.inherit("scripts/skills/backgrounds/character_background", {
    m = {},
    function create()
    {
        this.character_background.create();
        this.m.ID = "vp.electro.background";
        this.m.Icon = "ui/backgrounds/backgrounds_electro.png";
        this.m.Name = "Громовержец";
		this.m.BackgroundDescription = "Громовержец никогда не слышит, как бьёт его молния. Грохот наступает позже. Сначала — вспышка. Потом — тишина. Потом — запах палёной плоти. Громовержец любит тишину.";

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
            "Фульгур",
            "Дуга",
            "Громкий",
            "Яркий",
        ];
		this.m.Faces = this.Const.Faces.WildMale;
		this.m.Hairs = this.Const.Hair.WildMale;
		this.m.HairColors = this.Const.HairColors.Old;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.BeardChance = 0;
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
        return "{С детства %name% притягивал грозы, словно сама буря звала его по имени. | В деревне, где родился %name%, ходила молва, что его поцеловала молния — и он выжил. | Отец %name% был кузнецом, и мальчик рано понял, что металл и искры — его стихия, но искры слушались его слишком хорошо. | В юности %name% нашёл древний амулет в руинах старой башни — и с тех пор пальцы его заискрились по ночам. | %name% не выбирал этот дар: молния выбрала его сама, ударив в пустое поле, где он пас овец. | Говорят, в день рождения %name% над домом разразилась небывалая буря, и с тех пор гром всегда гремит чуть громче, когда он сердится. | %name% был подмастерьем у алхимика, но однажды взорвал лабораторию — и понял, что сила не в склянках, а в нём самом. | В его жилах течёт не только кровь, но и голубой огонь — так говорила его бабка, и оказалась права.} {Но дар — это не только сила, но и проклятие. Однажды %name% случайно убил молнией своего друга, и с тех пор боится собственных рук. | Жители его деревни стали сторониться %name%, шепчась о порче и демонах, и ему пришлось бежать. | Он сжёг дотла амбар, который защищал от воров, — и понял, что не может контролировать свою силу в гневе. | Магистр из гильдии предсказал ему раннюю смерть от собственной молнии, если %name% не найдёт учителя. | Однажды, защищая сестру от пьяных солдат, %name% обрушил на них небесный огонь — и понял, что обратной дороги нет. | Он искал покоя в храме, но даже там свечи гасли от одного его дыхания, а статуи святых начинали светиться голубым. | После того как он нечаянно подпалил мост с отрядом рыцарей, на него объявили охоту как на опасного колдуна. | В нём борются два начала: желание помочь людям и страх, что он разрушит всё, к чему прикоснётся.} {Теперь %name% ищет не золота, а защиты — в одиночку он слишком заметная мишень для охотников за головами. | Он понял, что среди наёмников его сила пригодится, а странный дар перестанет быть проклятием, если будет приносить пользу. | Устав прятаться по заброшенным хуторам, %name% решил, что лучше умереть в бою с мечом в руке, чем сгнить в болоте от страха перед собственной мощью. | Он слышал, что в вольных отрядах ценят умельцев, а не боятся их, — и это дало ему надежду. | После того как его родная деревня сожгла его дом, %name% понял: ему нет места среди мирных людей. Остаётся только искать братьев по оружию. | Ему нужны не деньги, а люди, которые не станут шарахаться от каждого его чиха и не побегут к священнику при первой искре. | Говорят, наёмники живут недолго, но зато ярко — для %name% это звучит как лучший план из всех возможных. | Он надеется, что в отряде найдётся кто-то, кто сможет объяснить ему, как управлять даром, или хотя бы не станет кричать \'Колдун\'! при первой молнии. | %name% больше не хочет бежать. Он хочет стоять на своём месте и бить так, чтобы враги падали замертво — и чтобы при этом никто из своих не пострадал. | Потеряв всё, кроме своей странной силы, %name% решил продать её тому, кто не побоится платить сталью и риском.}";
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
        this.m.Container.add(::new("scripts/skills/actives/sb_electric_skill"));
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
		xbody.Saturation = 0.2;
		xhead.Saturation = xbody.Saturation;
		if (this.Math.rand(0, 1) == 1)
		{
			actor.getSprite("tattoo_head").setBrush("warpaint_02_head");
			actor.getSprite("tattoo_body").setBrush("tattoo_0" + this.Math.rand(6, 6) + "_" + actor.getSprite("body").getBrush().Name);
			actor.getSprite("tattoo_head").Saturation = 2.5;
			actor.getSprite("tattoo_body").Saturation = 2;
		}
		else
		{
			if (this.Math.rand(0, 1) == 1)
			{
				actor.getSprite("tattoo_head").setBrush("tattoo_01_head");
			}
			else
			{
				actor.getSprite("tattoo_head").setBrush("bust_skeleton_head_detail_01");
			}
			actor.getSprite("tattoo_body").setBrush("tattoo_03_" + actor.getSprite("body").getBrush().Name);
			actor.getSprite("tattoo_head").Saturation = 5.5;
			actor.getSprite("tattoo_body").Saturation = 3.5;
		}
		actor.getSprite("tattoo_head").Visible = true;
		actor.getSprite("tattoo_head").Color = this.createColor("#8cff00");
		actor.getSprite("tattoo_body").Visible = true;
		actor.getSprite("tattoo_body").Color = this.createColor("#8cff00");
		actor.getSprite("permanent_injury_4").setBrush("zombie_rage_eyes");
		actor.getSprite("permanent_injury_4").Visible = true;
		actor.getSprite("permanent_injury_4").Color = this.createColor("#1aff00");
		actor.getSprite("permanent_injury_4").Saturation = 0.7;
    }

    function onAddEquipment()
    {
        local items = this.getContainer().getActor().getItems();
        local roll = ::Math.rand(1, 3);
        items.equip(::new("scripts/items/weapons/xxmstaff"));
        if (roll == 1) {
            items.equip(::new("scripts/items/armor/wizard_robe"));
        } else if (roll == 2) {
            items.equip(::new("scripts/items/armor/wizard_robe"));
            items.equip(::new("scripts/items/helmets/wizard_hat"));

        } else {
            items.equip(::new("scripts/items/armor/wizard_robe"));
            items.equip(::new("scripts/items/helmets/xxhat_hairband"));
        }
    }

});
