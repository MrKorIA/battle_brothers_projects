this.vp_shaman_background <- this.inherit("scripts/skills/backgrounds/character_background", {
    m = {},
    function create()
    {
        this.character_background.create();
        this.m.ID = "vp.shaman.background";
        this.m.Icon = "ui/backgrounds/backgrounds_druid.png";
        this.m.Name = "Шаман";
		this.m.BackgroundDescription = "Шаманы говорят с деревьями. И деревья им отвечают. О погоде. О врагах. О смерти. Можно подумать, что он сумасшедший. Но если увидеть, как лес расступается перед ним — то приходит понимание, что сумасшедшие здесь не они.";

        this.m.HiringCost = 900;
        this.m.DailyCost = 25;
        this.m.ExcludedTalents = [
            ::Const.Attributes.RangedSkill,
            ::Const.Attributes.RangedDefense
        ];
        this.m.Excluded = [
            "trait.impatient"
            "trait.clubfooted"
            "trait.dumb"
            "trait.insecure"
            "trait.loyal"
            "trait.fainthearted"
            "trait.superstitious"
        ];
        this.m.Titles = [
            "Лесной",
            "Изгой",
            "Одичавший",
            "Дубовое Сердце",
            "Древень",
            "Опылитель",
            "Гнев Природы",
            "Саженец",
            "Зверь",
            "Мохнатый",
        ];
		this.m.Faces = this.Const.Faces.WildMale;
		this.m.Hairs = this.Const.Hair.WildMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.WildExtended;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.BeardChance = 100;
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
                text = "Шаманы чувствует себя в лесах и на болотах как дома. Получает повышенную мобильность при движении по пересеченной местности."
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
                text = "Шаманы чувствует себя в лесах и на болотах как дома. Получает повышенную мобильность при движении по пересеченной местности."
            }
		];
	}

    function onBuildDescription()
    {
        return "{%name% родился в племени, которое жило глубоко в лесах, где деревья помнят имена всех, кто проходил под их кронами. | Ещё мальчишкой %name% слышал голоса в шелесте листьев — и они отвечали ему, когда он звал. | В день совершеннолетия %name% прошёл обряд у древнего дуба, и корни оплели его ноги, принимая в семью леса. | Его бабка была последней хранительницей старых обычаев и передала %name% тайны земли, которым не учат в городах. | %name% никогда не учился у магов — он учился у муравьёв, волков и старых пней, в которых живут духи. | Однажды заблудившись в чаще, %name% призвал рой светлячков, и те вывели его к дому — с тех пор насекомые слушаются его. | В его племени говорили, что дух волка выбрал %name% ещё до его рождения, и мальчик часто видел во сне горящие жёлтые глаза. | %name% мог заставить корни подняться из земли одним прикосновением — и часто делал это, чтобы защищать младших детей от диких зверей. | Он знал, как говорить с мёртвыми через травы, и как просить землю о помощи — и земля никогда не отказывала ему.} {Но однажды старейшины племени решили, что дар %name% слишком силён и опасен. Они потребовали, чтобы он ушёл, иначе лес ответит гневом на всех. | Его собственный брат, завидовавший силе %name%, предал его, обвинив в том, что он навёл мор на скот. И племя поверило брату. | %name% призвал корни, чтобы остановить лесной пожар, но корни переплелись так сильно, что разорвали землю и погребли под собой священное капище. | Дух волка, которого он вызывал с детства, однажды не вернулся. %name% отправился искать его и нашёл только шкуру, содранную браконьерами. | Он пытался вылечить вождя древним снадобьем, но перепутал травы, и вождь умер. Племя объявило %name% отравителем. | Когда на деревню напали наёмники, %name% призвал рой ос, чтобы отогнать их, но осы покусали и своих, и чужих — слишком много гнева было в его сердце. | Дети боялись %name% после того, как он в шутку заставил плющ обвить их ноги, и никто не вступился за него, когда старейшины вынесли приговор. | Он утратил связь с землёй на год после того, как случайно убил оленя, в котором жил добрый дух. За этот год %name% понял, что его дар — не игрушка.} {Теперь %name% идёт в мир людей, чтобы найти тех, кто не боится древних сил — или хотя бы готов платить за них золотом. | Он понял, что среди наёмников его способности будут цениться по-настоящему: корни не разбирают, кто свой, а кто чужой, но враг есть враг. | %name% больше не хочет прятаться в чаще. Если его прокляли свои — пусть хотя бы чужие узнают, что такое гнев леса. | Он ищет отряд, где его назовут не колдуном, а оружием, и где за каждое колдовство платят монетой, а не изгнанием. | Говорят, на войне все средства хороши — и %name% готов стать тем средством, о котором враги будут слагать страшные легенды. | Ему нужны не друзья — ему нужны те, кто не станет креститься, когда из-под ног полезут корни. | %name% надеется, что в отряде найдётся место для того, кто говорит с мёртвыми деревьями и воет с волками по ночам. | Он пришёл не за славой. Он пришёл за тем, чтобы его дар наконец приносил пользу — даже если эта польза вымощена костями врагов. | Если его изгнали за то, что он слишком силён, то он покажет миру, насколько сильным может быть изгой. | %name% больше не станет просить у земли прощения. Он будет просить у неё силы — и земля даст ему её, как давала всегда.}";
    }

    function onChangeAttributes()
    {
        local c = {
            Hitpoints = [0, 5]
            Bravery = [10, 20]
            Stamina = [5, 10]
            MeleeSkill = [0, 10]
            RangedSkill = [-10, 10]
            MeleeDefense = [0, 5]
            RangedDefense = [0, 5]
            Initiative = [10, 20]
        };

        return c;
    }

    function onAdded()
    {
        this.character_background.onAdded();
        this.m.Container.add(::new("scripts/skills/actives/sb_fonature_skill"));
//					::logWarning("skillPath: " + skillPath);
        if (!this.m.Container.hasSkill("trait.bright"))
        {
            this.m.Container.add(this.new("scripts/skills/traits/bright_trait"));
        }
    }

    function onUpdate( _properties )
    {
        this.character_background.onUpdate(_properties);

        local actor = this.getContainer().getActor();
        if (actor.isPlacedOnMap())
        {
            local tile = actor.getTile();
            local isNatureObstacle = tile.Type == this.Const.World.TerrainType.Swamp
                                  || tile.Type == this.Const.World.TerrainType.Forest
                                  || tile.Type == this.Const.World.TerrainType.LeaveForest
                                  || tile.Type == this.Const.World.TerrainType.AutumnForest
                                  || tile.Type == this.Const.World.TerrainType.SnowyForest;

            if (isNatureObstacle)
            {
                _properties.MovementAPCostAdditional = 0;
                _properties.MovementFatigueCostMult *= 0.5;
                _properties.MovementAPCostAdditional -= 1;
            }
        }
    }

    function onSetAppearance()
    {
        local actor = this.getContainer().getActor();
        local tattoo_body = actor.getSprite("tattoo_body");
        local tattoo_head = actor.getSprite("tattoo_head");
//        local hair_color = [
//            "blonde",
//            "brown",
//            "red"
//        ];
//        hair_color = hair_color[this.Math.rand(0, hair_color.len() - 1)]
//        local hair_type = [
//            "03",
//            "08",
//            "18",
//            "21"
//        ];
//        hair_type = hair_type[this.Math.rand(0, hair_type.len() - 1)]
//        local beard_type = [
//            "12",
//            "13",
//            "14",
//            "15",
//            "17"
//        ];
//        beard_type = beard_type[this.Math.rand(0, beard_type.len() - 1)]

        tattoo_body.setBrush("tattoo_04_" + actor.getSprite("body").getBrush().Name);
        tattoo_body.Visible = true;
        tattoo_head.setBrush("warpaint_02_head");
        tattoo_head.Visible = true;
//        actor.getSprite("permanent_injury_4").setBrush("hair_black_zombie_04");
//        actor.getSprite("permanent_injury_4").Visible = true;
//        actor.getSprite("hair").setBrush("hair_" + hair_color + "_" + hair_type);
//        actor.getSprite("beard").setBrush("beard_" + hair_color + "_" + beard_type);
//        actor.getSprite("beard_top").setBrush(actor.getSprite("beard").getBrush().Name + "_top");
//        actor.getSprite("hair").Color = this.createColor("#61b06d");
//        actor.getSprite("beard").Color = this.createColor("#61b06d");
//        actor.getSprite("beard_top").Color = this.createColor("#61b06d");
    }

    function onAddEquipment()
    {
        local items = this.getContainer().getActor().getItems();
        local roll = ::Math.rand(1, 3);
        if (roll == 1) {
            items.equip(::new("scripts/items/weapons/cp_reinforced_wooden_staff"));
            items.equip(::new("scripts/items/armor/barbarians/animal_hide_armor"));
        } else if (roll == 2) {
            items.equip(::new("scripts/items/weapons/wooden_stick"));
            items.equip(::new("scripts/items/armor/barbarians/animal_hide_armor"));
            items.equip(::new("scripts/items/helmets/barbarians/bear_headpiece"));

        } else {
            items.equip(::new("scripts/items/weapons/cp_reinforced_wooden_staff"));
            items.equip(::new("scripts/items/helmets/barbarians/bear_headpiece"));
        }
    }

});
