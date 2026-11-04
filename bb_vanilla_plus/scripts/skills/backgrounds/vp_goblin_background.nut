this.vp_goblin_background <- this.inherit("scripts/skills/backgrounds/character_background", {
    m = {},
    function create()
    {
        this.character_background.create();
        this.m.ID = "vp.goblin.background";
        this.m.Icon = "ui/backgrounds/backgrounds_goblin.png";
        this.m.Name = "Гоблин";
		this.m.BackgroundDescription = "Он должен был сдохнуть под грудой своих сородичей. Но не сдох. Не захотел. И теперь ползёт за вами, как побитая собака, которая помнит, кто её ударил — и кто её накормил. И когда придёт время, она выберет.";

        this.m.HiringCost = 2000;
        this.m.DailyCost = 15;
        this.m.ExcludedTalents = [
            ::Const.Attributes.Hitpoints,
            ::Const.Attributes.Bravery
        ];
        this.m.Excluded = [
            "trait.night_blind"
            "trait.tough"
            "trait.teamplayer"
            "trait.loyal"
            "trait.iron_lungs"
            "trait.iron_jaw"
            "trait.huge"
        ];
        this.m.Titles = [
            "Чтоб Ты Сдох",
            "Плут",
            "Задохлик",
            "Подлый",
        ];
		this.m.Faces = this.Const.Faces.SmartMale;
		this.m.Hairs = null;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = null;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.BeardChance = 0;
		this.m.Names = this.Const.Strings.GoblinNames;
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
                text = "Ловкий и подвижный, имеет врожденный талант к преодолению пересеченной местности."
            }
        ];
    }

    function onBuildDescription()
    {
        return "{Маленький, коренастый, с кожей цвета болотной тины и глазами, которые смотрят на вас как на говяжью отбивную — этот гоблин по имени %name% вызывает желание пнуть его, а не нанять. | Забавный уродец, этот %name%. Он никогда не стоит прямо, всегда немного сгорблен и готов упасть на колени в любую секунду. Говорят, такую осанку даёт только долгая практика выживания. | Мало кто понимает, зачем %name% держат в отряде. Он сам не понимает, но благодарно молчит. | Где бы ни пахло жареным, %name% уже выбрал троих, кого предаст первым, и двое из них — вы. | Когда %name% двигается, его лохмотья издают звук, похожий на шорох крыс в амбаре. Вы привыкаете к этому звуку. Это плохая привычка. | %name% показывает зубы только когда улыбается. Это делает его похожим на живую мышеловку. | Кто он, этот %name%? Иногда в его глазах читается настоящая преданность, иногда — расчётливое ожидание, когда же вы умрёте, чтобы обчистить ваш труп.}";
        //"{%name% боится теней. Не потому что он трус. Потому что в тенях прячутся те, кто хочет его убить. Свои. Чужие. Все. Он выжил только потому, что всегда смотрит туда, куда другие не смотрят. | Он не смотрит вам в глаза. Не потому что врёт. Потому что привык, что взгляд означает удар. Он будет смотреть в пол, пока вы не докажете, что не поднимете руку. Но вы поднимете. Все поднимают. | Ходят слухи, что он продал своих братьев за миску похлёбки. Это правда. Он продал. Но сначала они продали его. Разница в том, что он выжил. А они — нет. | %name% не умеет драться честно. Он умеет только прятаться, ждать, бить в спину и убегать. Вы презираете его за это. Но почему-то именно эти навыки спасают отряду жизнь раз за разом. | Он ест объедки. Не потому что вы плохо кормите. Потому что боится, что хорошая еда — последняя. Он всегда доедает за вами, прячет хлеб за пазуху, копит на чёрный день. Чёрный день придёт. Он знает. | Вы спросили, почему он не сбежит. Он показал на шрам на шее. %SPEECH_ON%Там — нож. Тут — еда. Я не дурак. Вы злые, но сытые. Лес — голодный. И там меня убьют свои.%SPEECH_OFF%Вы не знаете, что страшнее — его логика или его правда. | Гоблины не умеют быть благодарными. Они умеют только бояться, подлизываться и ждать. %name% ждёт. Своего часа. Или вашей смерти. Или конца света. Что наступит раньше.}"
    }

    function onChangeAttributes()
    {
        local c = {
            Hitpoints = [-25, -15]
            Bravery = [-15, -10]
            Stamina = [-15, -5]
            MeleeSkill = [0, 0]
            RangedSkill = [20, 30]
            MeleeDefense = [10, 15]
            RangedDefense = [15, 25]
            Initiative = [35, 45]
        };

        return c;
    }

    function onAdded()
    {
        this.character_background.onAdded();
        if (!this.getContainer().getActor().getSkills().hasSkill("effects.xxzzvoice_skill"))
        {
            local actor = this.getContainer().getActor();
            actor.getSkills().add(this.new("scripts/skills/actives/xxzzvoice_skill"));
            actor.getFlags().add("xxzzvoice_goblin");
        }
        if (!this.m.Container.hasSkill("trait.tiny"))
        {
            this.m.Container.add(this.new("scripts/skills/traits/tiny_trait"));
        }
        if (!this.m.Container.hasSkill("trait.greedy"))
        {
            this.m.Container.add(this.new("scripts/skills/traits/greedy_trait"));
        }
//        this.m.Container.add(::new("scripts/skills/actives/sbp_goblin_skill"));
    }

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local xhead = actor.getSprite("head");
		local xbody = actor.getSprite("body");
		xbody.setBrush("bust_naked_body_7871");
		xhead.setBrush("xxgoblin_head_" + this.Math.rand(100, 103));
		xbody.Saturation = 0.9;
		xbody.varySaturation(0.1);
		xbody.varyColor(0.025, 0.025, 0.025);
		xhead.Color = xbody.Color;
		xhead.Saturation = xbody.Saturation;
	}

    function onUpdate( _properties )
    {
        this.character_background.onUpdate(_properties);

        _properties.MovementAPCostAdditional -= 1;
    }

    function onAddEquipment()
    {
        local items = this.getContainer().getActor().getItems();
        items.equip(::new("scripts/items/armor/barbarians/animal_hide_armor"));
    }
});
