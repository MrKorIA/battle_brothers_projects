this.vp_nindja_background <- this.inherit("scripts/skills/backgrounds/character_background", {
    m = {},
    function create()
    {
        this.character_background.create();
        this.m.ID = "vp.nindja.background";
        this.m.Icon = "ui/backgrounds/backgrounds_nindja.png";
        this.m.Name = "Ниндзя";
		this.m.BackgroundDescription = "Ниндзя - убийца из далеких земель, что он забыл здесь - вопрос без ответа.";

        this.m.HiringCost = 800;
        this.m.DailyCost = 25;
        this.m.ExcludedTalents = [
            ::Const.Attributes.Hitpoints
        ];
		this.m.Excluded = [
			"trait.superstitious",
			"trait.huge",
			"trait.weasel",
			"trait.teamplayer",
			"trait.night_blind",
			"trait.clubfooted",
			"trait.brute",
			"trait.dumb",
			"trait.loyal",
			"trait.clumsy",
			"trait.fat",
			"trait.strong",
			"trait.hesitant",
			"trait.insecure",
			"trait.short_sighted",
			"trait.bloodthirsty"
		];
		this.m.Titles = [
			"Тень",
			"Изгнанник",
			"Коварный",
			"Вероломный",
			"Незримый",
			"Убийца",
			"Отступник",
			"Неуловимый"
		];
		this.m.Names = [
            "Юэ Фэй",
			"Юань Шао",
			"Ли Гуан",
			"Хань Синь",
			"Сян Юй",
			"И Шинь",
			"У Ци",
			"Сунь У",
			"Сунь Цюань",
			"Чжоу Юй",
			"Тайши Цы",
			"Гань Нин",
			"Дун Чжо",
			"Люй Бу",
			"Цао Цао",
			"Дянь Вэй",
			"Сюй Чу",
			"Сяхоу Дунь",
			"Цзя Сюй",
			"Го Цзя",
			"Сыма И",
			"Лю Бэй",
			"Гуань Юй",
			"Чжан Фэй",
			"Чжугэ Лян",
			"Ма Чао",
			"Ван Ци",
			"Чэнь"
		];
		this.m.Faces = this.Const.Faces.SmartMale;
		this.m.Hairs = null;
		this.m.HairColors = this.Const.HairColors.Zombie;
		this.m.Beards = null;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.BeardChance = 0;
		this.m.IsCombatBackground = true;
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
                text = "Ниндзя - ловкий убийца. Если он быстрее цели при атаке, то получает +9 к навыкам ближнего и дальнего боя. Если быстрее атакующего при атаке, то получает +9 к защите в ближнем и дальнем бою."
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
                text = "Ниндзя - ловкий убийца. Если его инициатива больше чем у цели, то при атаке получает +9 к навыкам ближнего и дальнего боя, а при защите +9 к защите в ближнем и дальнем бою."
            }
		];
	}

    function onBuildDescription()
    {
        return "{С детства %name%а учили не говорить лишнего, не оставлять следов и не доверять даже тени собственного брата. | В клане %name%а знали как того, кто может войти в дом через запертую дверь и выйти через окно, не разбудив даже собаки. | Для %name%а тишина стала родным языком, а клинок — продолжением дыхания, и никто в клане не мог сравниться с ним в искусстве исчезать на глазах у стражи. | Старейшины клана шептались, что %name% — лучший убийца за последние сто лет, и поручали ему только самые опасные и важные задания.} {Но однажды ему поручили задание в далёких землях — убить человека, который никогда не появлялся в одном и том же месте дважды, и %name% отправился в путь с полной уверенностью в успехе.} {Месяцы слежки, ночей на крышах и ложных следов не привели его к цели: враг оказался хитрее, и %name% так и не смог нанести решающий удар. | Он ждал удобного момента неделями, но тот так и не наступил, а время, отпущенное кланом, истекло, и %name% понял: возвращаться с пустыми руками нельзя.} {Провал задания означал для него одно — смерть. Клан не прощает ошибок, и %name% знал это лучше всех, ибо сам казнил тех, кто возвращался ни с чем. | Он мог бы попытаться сбежать на родину, спрятаться в горах или уйти в монастырь, но клан найдёт его даже под землёй — это тоже часть его обучения. | Тогда %name% принял решение: он останется здесь, на чужбине, где его никто не знает, и будет жить так, как умеет — убивая за деньги и исчезая до рассвета. | Клан, скорее всего, уже объявил его предателем или мёртвым, и %name% не будет их разубеждать — пусть считают его трупом, ибо труп не вызывает подозрений. | Теперь он не может вернуться домой, потому что там его ждёт только лезвие старого друга или яд в утреннем чае — и он знает это слишком хорошо.} {Ему нужны не спутники и не друзья — ему нужны приказы, деньги и свобода исчезать в любой момент, когда пахнет опасностью. | Говорят, наёмники не любят тех, кто дерётся из тени, но %name% знает: в бою побеждает тот, кто остаётся незамеченным, а не тот, кто громче кричит. | Он умеет только убивать, и это единственное ремесло, которое он может продать в этих землях, не вызывая лишних вопросов. | %name% надеется, что в отряде найдётся тот, кто оценит его умение появляться из ниоткуда и исчезать в никуда — и будет платить за это золотом. |  %name% больше не служит клану, но он всё ещё служит лезвию, а лезвие всегда находит того, кто готов за него заплатить. | Он пришёл в наёмники не за славой — он пришёл за тем, чтобы выжить, а в этом мире выживают либо сильные, либо незаметные. %name% умеет быть и тем, и другим.}";
    }

    function onChangeAttributes()
    {
        local c = {
            Hitpoints = [0, 5]
            Bravery = [-5, 5]
            Stamina = [-5, 5]
            MeleeSkill = [10, 15]
            RangedSkill = [10, 15]
            MeleeDefense = [0, 5]
            RangedDefense = [0, 5]
            Initiative = [20, 25]
        };

        return c;
    }

    function onAdded()
    {
        this.character_background.onAdded();
        this.m.Container.add(::new("scripts/skills/actives/sbp_agile_skill"));
    }

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
        local xhead = actor.getSprite("head");
        local xbody = actor.getSprite("body");
        local hair_type = [
            "hair_black_8010",
            "hair_black_8011",
            "hair_black_8012",
            "hair_black_8013",
            "hair_black_19"
        ];
        hair_type = hair_type[this.Math.rand(0, hair_type.len() - 1)]
        local beard_type = [
            "xxbeard_black_1000",
            "beard_black_05",
            "beard_black_06"
            "beard_black_07",
            "beard_black_08",
            "beard_black_09"
        ];
        beard_type = beard_type[this.Math.rand(0, beard_type.len() - 1)]
        local pp = this.Math.rand(1, 3);
        if (pp != 1)
        {
            actor.getSprite("beard").setBrush(beard_type);
        }
        actor.getSprite("hair").setBrush(hair_type);
        xhead.Color = this.createColor("#d6b074");
        xbody.Color = xhead.Color;
	}

    function onUpdate( _properties )
    {
        this.character_background.onUpdate(_properties);
    }

    function onAddEquipment()
    {
        local items = this.getContainer().getActor().getItems();
        local roll = ::Math.rand(1, 5);
        if (roll == 1) {
            items.equip(::new("scripts/items/weapons/xxkusarigama"));
            items.equip(this.new("scripts/items/armor/oriental/assassin_robe"));
            items.equip(this.new("scripts/items/helmets/oriental/assassin_head_wrap"));
        } else if (roll == 2) {
            items.equip(::new("scripts/items/weapons/xxbamboospear"));
            items.equip(::new("scripts/items/armor/thick_dark_tunic"));
            items.equip(::new("scripts/items/helmets/xxhat_kasa"));
        } else if (roll == 3) {
            items.equip(::new("scripts/items/weapons/xxmeteor"));
            items.equip(::new("scripts/items/armor/thick_dark_tunic"));
            items.equip(::new("scripts/items/helmets/mouth_piece"));
        } else if (roll == 4) {
            items.equip(::new("scripts/items/weapons/xxkatar"));
            items.equip(::new("scripts/items/armor/ragged_dark_surcoat"));
            items.equip(::new("scripts/items/helmets/mouth_piece"));
        } else {
            items.equip(::new("scripts/items/weapons/xxshuriken"));
            items.equip(::new("scripts/items/armor/ragged_dark_surcoat"));
            items.equip(::new("scripts/items/helmets/mouth_piece"));
        }
    }
});
