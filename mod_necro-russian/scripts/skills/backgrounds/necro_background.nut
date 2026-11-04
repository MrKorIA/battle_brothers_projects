this.necro_background <- this.inherit("scripts/skills/backgrounds/character_background", {
    m = {},
    function create()
    {
        this.character_background.create();
        this.m.ID = "background.necro";
        this.m.Icon = "ui/backgrounds/background_39.png";
        this.m.Name = "Некромант";

        this.m.HiringCost = 1500;
        this.m.DailyCost = 15;
        this.m.ExcludedTalents = [
            ::Const.Attributes.Initiative,
            ::Const.Attributes.RangedSkill
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
            "Некрота",
            "Некромант",
            "Тёмный",
            "Чародей",
        ];
        this.m.Faces = ::Const.Faces.SmartMale;
        this.m.Hairs = ::Const.Hair.Necromancer;
        this.m.HairColors = ::Const.HairColors.Old;
        this.m.Beards = ::Const.Beards.All;
        this.m.Bodies = ::Const.Bodies.Skinny;
    }

    // For Reforged
    function createPerkTreeBlueprint()
    {
        return ::new(::DynamicPerks.Class.PerkTree).init({
            DynamicMap = {
                "pgc.rf_exclusive_1": [],
                "pgc.rf_shared_1": [],
                "pgc.rf_weapon": ["pg.rf_dagger"],
                "pgc.rf_armor": [],
                "pgc.rf_fighting_style": []
            }
        });
    }

    PerkTreeMultipliers = {
        "pg.necro": -1
        "pg.rf_fast": 1.5,
        "pg.rf_tough": 0.5,
        "pg.special.rf_leadership": 1.5
        "pg.special.rf_student": 1.5
        "pg.rf_axe": 0
        "pg.rf_hammer": 0.3
        "pg.rf_spear": 0.3
        "pg.rf_cleaver": 1.7
        "pg.rf_polearm": 1.7
        "pg.rf_crossbow": 1.2
        "pg.rf_heavy_armor": 0
    }
    function getPerkGroupMultiplier(_groupID, _perkTree)
    {
        return ::std.Table.get(PerkTreeMultipliers, _groupID)
    }

    function getTooltip()
    {
        return [
            {
                id = 1,
                type = "title",
                text = this.getName()
            }
            {
                id = 2,
                type = "description",
                text = this.getDescription()
            }
            {
                id = 10,
                type = "text",
                icon = "ui/icons/morale.png",
                text = "При смерти или бегстве союзников проверка боевого духа не проводится"
            }
        ];
    }

    function onBuildDescription()
    {
        return "{Одетый в странный разноцветный балахон, %name% больше похож на посланника тьмы, чем на человека из плоти и крови. | Занятный парень, этот %name%. Он всегда ходит сгорбившись, будто на него нещадно давит вес приобретённых им потусторонних знаний. | %name% прячет лицо в глубокой тени капюшона - разглядеть можно лишь неровный полумесяц жёлтых зубов, единственное свидетельство того, что перед вами всё же человек, а не сгусток мрака, прикрытый тряпками. | Мало что известно о %name%е, но слухи о его приверженности тёмному колдовству ходят за ним по пятам. | Где бы ни начинали таинственным образом гибнуть животные, там непременно появлялся %name%. | Когда %name% движется, броши на его мантии напоминают звёзды, что кружатся и танцуют, как птицы в небе. | %name% показывает руки только тогда, когда нужно жестами подтвердить эмоции на лице, спрятанном в глубине его капюшона. | Кто этот парень, %name%, на самом деле? Иногда из сумрака капюшона на вас глядят глаза кошки, иногда - бельма слепца.} {Мало известно о том, откуда он пришёл. | Для большинства остаётся загадкой, откуда он родом. | Говорят, он путешествовал в глубь северных предгорий, вернувшись с багажом невероятных знаний. | Возможно, он адепт тёмной магии, а, может, просто важничает. | Прошлое этого человека - загадка. Кто-то находит это интересным, кто-то нет. | Ходят слухи, что он странствующий чародей. | Слухи о магии окружают этого человека, но они вряд ли впечатлят некоторых недоверчивых циников. | Судя по слухам, он был колдуном. Впрочем, кто-то считает его обычным аферистом. Вы не знаете, что предпочесть. | Слухи о необычайных происшествиях окружают этого человека. Похоже, его магические способности могут оказаться правдой. | Некоторые утверждают, что он вкушает жаб на завтрак, другие же клянутся, что на обед у него - чёрная кошка, запечённая с грушами. Однажды два именитых повара даже подрались, выясняя целесообразность такого меню для поддержания себя в магической форме.} {%name% выслушал немало ваших вопросов, но стоило ему взмахнуть руками и кивнуть, как вы вдруг понимаете, что забыли все его ответы. Или вы его вообще ни о чём не спрашивали? | %name% выпускает голубя из рукава. Старый трюк, которому никто не удивляется - до тех пор, пока голубь не превращается в ворона прямо в воздухе. | %name% умеет выпускать дым изо рта. Это не огонь, но близко: заставляет людей уважительно перешёптываться. | %name% заставляет золотую монету парить в воздухе. Демонстрация отнимает столько сил, что на вторую попытку их уже не остаётся. | Предсказаниями погоды никого не удивишь, вот только %name% никогда не ошибается. | %name% предлагает вам прочесть вашу судьбу по ладоням. Вы отказываетесь. Одно лишь присутствие этого человека рядом вызывает у вас желание убраться подальше. | %name% утверждает, что звёздное небо - это карта пути в другой мир. Он выглядит человеком сведущим. | %name% говорит, что рисунок созвездий - лишь отблеск бесконечных потоков бытия, растянутых во времени. Вот умора! | %name% указывает на одну из звёзд на небе и говорит, что он родом именно оттуда. Вы не хотите спрашивать его об этом.}";
    }

    function onChangeAttributes()
    {
        local c = {
            Hitpoints = [0, 0]
            Bravery = [10, 20]
            Stamina = [-5, 10]
            MeleeSkill = [0, 0]
            RangedSkill = [0, 0]
            MeleeDefense = [0, 3]
            RangedDefense = [-3, 3]
            Initiative = [-10, 0]
        };
        return c;
    }

    function onAdded()
    {
        this.character_background.onAdded();
        this.m.Container.add(::new("scripts/skills/actives/necro_raise_undead"));
        // Possess is available via perk now
    }

    function onUpdate( _properties )
    {
        this.character_background.onUpdate(_properties);
        _properties.IsAffectedByDyingAllies = false;
    }

    function onAddEquipment()
    {
        local items = this.getContainer().getActor().getItems();
        local roll = ::Math.rand(1, 3);
        if (roll == 1) {
            items.equip(::new("scripts/items/armor/wizard_robe"));
            items.equip(::new("scripts/items/helmets/wizard_hat"));
        } else if (roll == 2) {
            items.equip(::new("scripts/items/armor/thick_dark_tunic"));
            items.equip(::new("scripts/items/helmets/dark_cowl"));

        } else {
            items.equip(::new("scripts/items/armor/ragged_dark_surcoat"));
        }
    }
});
