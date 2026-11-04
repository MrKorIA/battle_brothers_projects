this.vp_ronin_background <- this.inherit("scripts/skills/backgrounds/character_background", {
    m = {},
    function create()
    {
        this.character_background.create();
        this.m.ID = "vp.ronin.background";
        this.m.Icon = "ui/backgrounds/backgrounds_ronin.png";
        this.m.Name = "Ронин";
		this.m.BackgroundDescription = "Обычно Ронин не помнит своего лица. Только чужие. Те, что смотрят на него перед смертью. Иногда ему кажется, что он умер уже много раз. Но ноги всё ещё идут. А руки — сжимают меч.";

        this.m.HiringCost = 100;
        this.m.DailyCost = 15;
        this.m.ExcludedTalents = [
            ::Const.Attributes.RangedSkill
        ];
		this.m.Excluded = [
			"trait.weasel",
			"trait.teamplayer",
			"trait.fear_undead",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.ailing",
			"trait.swift",
			"trait.clubfooted",
			"trait.irrational",
			"trait.hesitant",
			"trait.loyal",
			"trait.tiny",
			"trait.fragile",
			"trait.clumsy",
			"trait.fainthearted",
			"trait.craven",
			"trait.bleeder",
			"trait.dastard",
			"trait.insecure",
			"trait.asthmatic"
		];
        this.m.Titles = [
            "Изгнанник",
            "Защитник",
            "Странник",
            "Отступник",
            "Одинокий",
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
                text = "Ронин - мастер меча. Усиливает базовый навык атаки при использовании меча. +20% к урону, +10% к пробиванию брони."
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
                text = "Ронин - мастер меча. Усиливает базовый навык атаки при использовании меча. +20% к урону, +10% к пробиванию брони."
            }
		];
	}

    function onBuildDescription()
    {
        return "{%name% родился под сенью цветущей сакуры, в доме, где катана передавалась из поколения в поколение вместе с именем рода. | Ещё ребёнком %name% повторял за отцом древние стихи о чести и долге, и клинок стал ему первой игрушкой, а бусидо — азбукой. | Говорили, что %name% может срезать цветок с ветки, не коснувшись листьев, и что дождь огибает его в бою, боясь осквернить святую сталь. | Для %name% меч был не просто оружием, а воплощением души, и каждый раз, вынимая его из ножен, он шептал молитву предкам. | Его господин, старый даймё, самолично подарил ему клинок с именем, выкованным по звёздам, и сказал: \'Ты — моя правая рука.\' | В своём клане он считался самым стойким: ни боль, ни страх не могли заставить его дрогнуть, а враги говорили, что он сражается не как человек, а как ками. | %name% прошёл все положенные посвящения — от ученика до старшего вассала, и имя его знали при дворе даймё как имя самого верного из буси.} {После смерти старого господина его сын, движимый трусостью и завистью, ложно обвинил %name% в предательстве, и тот лишился чести, семьи, дома и был вынужден бежать, скитаясь по чужим землям, пока не добрался до этих мест. | Новый даймё, унаследовав власть, не мог простить %name% его верности старому господину, и вскоре за ним пришла стража, а после — изгнание, и вот он здесь, в чужом краю, без имени и без дома. | Когда старый князь ушёл в мир иной, его наследник, испугавшись силы и славы %name%, выдумал заговор и отправил его в темницу, а когда тот чудом спасся, объявил награду за его голову — так %name% оказался на чужбине, где его меч ценится лишь как кусок железа.} {Теперь %name% идёт в наёмники, потому что даже падшему воину нужно место, где он может держать клинок наточенным. | Он не ищет нового господина — он ищет врага, перед которым можно умереть стоя, ибо в чужих землях даже смерть должна быть достойной. | Если его меч уже не служит клану, пусть он служит золоту, но каждым ударом он будет напоминать этим варварам, как бьются на его родине. | Говорят, наёмникам плевать на честь, но %name% знает: даже среди головорезов есть те, кто ценит мастерство клинка больше, чем звон монет. | Ему нужны не друзья — ему нужны попутчики, которые не станут спрашивать о прошлом и не побегут к священнику, когда он будет читать молитву предкам перед боем. | %name% надеется, что в этом жестоком мире он встретит хотя бы одного человека, который поймёт, что война — это искусство, а не резня. | Если ему суждено умереть на чужбине, пусть его последний вздох будет подобен лепестку сакуры, упавшему на холодную землю — без крика, без жалоб. | Он пришёл не за богатством — он пришёл за тем, чтобы его катана снова запела в бою, даже если никто не запомнит её песню. | %name% больше не мечтает вернуться домой, но он мечтает о том, чтобы его смерть была такой же красивой, как закат над горами его родины.}";
    }

    function onChangeAttributes()
    {
        local c = {
            Hitpoints = [0, 5]
            Bravery = [10, 15]
            Stamina = [-5, 5]
            MeleeSkill = [15, 23]
            RangedSkill = [-10, -5]
            MeleeDefense = [5, 10]
            RangedDefense = [0, 5]
            Initiative = [15, 25]
        };

        return c;
    }

    function onAdded()
    {
        this.character_background.onAdded();
        this.m.Container.add(::new("scripts/skills/actives/sbp_kensei_skill"));
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
            items.equip(::new("scripts/items/weapons/xxnodachi"));
            items.equip(::new("scripts/items/armor/xxsamuraiarmor"));
            items.equip(::new("scripts/items/helmets/xxhat_samurai"));
        } else if (roll == 2) {
            items.equip(::new("scripts/items/weapons/named/xx_mob_katana"));
            items.equip(::new("scripts/items/armor/xxsamuraiarmor"));
            items.equip(::new("scripts/items/helmets/xxhat_kasa"));
        } else if (roll == 3) {
            items.equip(::new("scripts/items/weapons/named/xx_mob_katana"));
            items.equip(::new("scripts/items/armor/xxwokoulightarmor"));
            items.equip(::new("scripts/items/helmets/xxhat_hunshelm"));
        } else if (roll == 4) {
            items.equip(::new("scripts/items/weapons/named/xx_mob_katana"));
            items.equip(::new("scripts/items/armor/xxwokoulightarmor"));
            items.equip(::new("scripts/items/helmets/xxhat_hairband"));
        } else {
            items.equip(::new("scripts/items/weapons/xxnodachi"));
            items.equip(::new("scripts/items/armor/xxwokoulightarmor"));
            items.equip(::new("scripts/items/helmets/xxhat_kasa"));
        }
    }
});
