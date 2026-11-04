this.vp_orc_background <- this.inherit("scripts/skills/backgrounds/character_background", {
    m = {},
    function create()
    {
        this.character_background.create();
        this.m.ID = "vp.orc.background";
        this.m.Icon = "ui/backgrounds/backgrounds_orc.png";
        this.m.Name = "Орк";
		this.m.BackgroundDescription = "Он родился слишком зелёным для людей и слишком тонким для орков. Теперь он здесь. И не знает, кому мстить — и стоит ли вообще.";

        this.m.HiringCost = 2000;
        this.m.DailyCost = 10;
        this.m.ExcludedTalents = [
            ::Const.Attributes.RangedSkill,
            ::Const.Attributes.Initiative
        ];
        this.m.Excluded = [
            "trait.night_blind"
            "trait.ailing"
            "trait.asthmatic"
            "trait.bleeder"
            "trait.bright"
            "trait.craven"
            "trait.tiny"
        ];
        this.m.Titles = [
            "Могучий",
            "Изгнанник",
            "Полуорк",
            "Уродец",
        ];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = null;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = null;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.BeardChance = 0;
		this.m.Names = this.Const.Strings.OrcWarlordNames;
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
            }
//            {
//                id = 10,
//                type = "text",
//                icon = "ui/icons/special.png",
//                text = "Пусть и полукровка, но по прежнему сильнее обычного человека. При использовании оружия или щита орков: +8 к восстановлению усталости за ход."
//            }
        ];
    }

    function onBuildDescription()
    {
        return "{Одетый в рваную шкуру, которая когда-то была доспехом орка, и человеческие штаны, сшитые из парусины, %name% не похож ни на того, ни на другого. Слишком зелёный для человека, слишком тонкий для орка. | Из-под грязных косм, падающих на лицо, видны жёлтые глаза с вертикальным зрачком. Оркский глаз, посаженный в человеческую глазницу. Это пугает больше, чем если бы он был просто орком.}";
//        "{%name% пахнет кровью, шерстью и вечной усталостью. Вы думаете, он болен. Нет. Это запах того, кто никогда не был ничьим. Ни другом, ни врагом. Ни рабом, ни хозяином. Ничем. | Он не помнит своего имени. То, что дала мать, украли орки. То, что дали орки, украли люди. Теперь он просто %name%. И ему этого хватает. Имён у него всё равно нет. | Вы спросили, почему он не уйдёт в горы, к диким оркам. Он засмеялся — если это можно назвать смехом. %SPEECH_ON%Они убьют меня. Как и люди. Так какая разница? Здесь хотя бы платят.%SPEECH_OFF% | Он не умеет просить. Ни еды, ни воды, ни пощады. Он умеет только брать. И убивать. И молчать. Иногда вы забываете, что он человек. И напоминаете себе, что он — нет. | Шрамы на его спине не от битв. От цепей. Он был рабом большую часть жизни. Теперь он свободен. И не знает, что с этой свободой делать. Поэтому он дерётся. Потому что это единственное, чему его научили. | Он не верит никому. Ни вам, ни врагам, ни себе. Доверие — это роскошь, которой у него никогда не было. Он ждёт предательства. И когда оно придёт, он будет готов. Он всегда готов. | Вы спросили, чего он хочет. Он долго молчал. %SPEECH_ON%Чтобы перестало болеть. Внутри. И снаружи.%SPEECH_OFF%Вы не знаете, что ответить. Потому что у вас болит то же самое. Просто вы умеете это скрывать. А он — нет.}"
    }

    function onChangeAttributes()
    {
        local c = {
            Hitpoints = [35, 45]
            Bravery = [10, 20]
            Stamina = [25, 30]
            MeleeSkill = [8, 13]
            RangedSkill = [-20, -15]
            MeleeDefense = [-5, 0]
            RangedDefense = [-10, -5]
            Initiative = [-30, -20]
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
			actor.getFlags().add("xxzzvoice_orc");
		}
        if (!this.m.Container.hasSkill("trait.deathwish"))
        {
            this.m.Container.add(this.new("scripts/skills/traits/deathwish_trait"));
        }
        if (!this.m.Container.hasSkill("trait.huge"))
        {
            this.m.Container.add(this.new("scripts/skills/traits/huge_trait"));
        }
//        this.m.Container.add(::new("scripts/skills/actives/sbp_orc_skill"));
        this.m.Container.add(::new("scripts/skills/actives/sb_bkcharge_skill"));
    }

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local xbody = actor.getSprite("body");
		local xhead = actor.getSprite("head");
		local hair_color = [
			"black",
			"grey",
			"brown"
		];
		hair_color = hair_color[this.Math.rand(0, hair_color.len() - 1)]
		local hair_type = [
			"09",
			"19",
			"21"
		];
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");
		local pp;
		xbody.setBrush("bust_naked_body_7872");
		xhead.setBrush("bust_head_790" + this.Math.rand(0, 2));
		pp = this.Math.rand(1, 2);
		if (pp == 1)
		{
			pp = this.Math.rand(0, hair_type.len() - 1);
			hair_type = hair_type[pp]
			actor.getSprite("hair").setBrush("hair_" + hair_color + "_" + hair_type);
			if (pp == 1)
			{
				actor.getSprite("beard").setBrush("beard_" + hair_color + "_08");
				actor.getSprite("beard").Visible = true;
			}
		}
		pp = this.Math.rand(1, 3);
		if (pp == 1)
		{
			tattoo_body.setBrush("scar_01_bust_naked_body_southern_02");
			tattoo_head.setBrush("scar_02_head");
			tattoo_head.Saturation = 1.2;
			tattoo_body.Visible = true;
			tattoo_head.Visible = true;
		}
		else
		if (pp == 2)
		{
			tattoo_body.setBrush("warpaint_01_bust_naked_body_02");
			tattoo_head.setBrush("warpaint_01_head");
			tattoo_body.Color = this.createColor("#ff0000");
			tattoo_head.Color = this.createColor("#ff0000");
			tattoo_body.Saturation = 1.2;
			tattoo_head.Saturation = 1.2;
			tattoo_body.Visible = true;
			tattoo_head.Visible = true;
		}
		xhead.varyColor(0.05, 0.05, 0.05);
		xbody.Color = xhead.Color;
	}

    function onUpdate( _properties )
    {
        this.character_background.onUpdate(_properties);

        _properties.DamageTotalMult += 0.15;
    }

    function onAddEquipment()
    {
        local items = this.getContainer().getActor().getItems();
        items.equip(::new("scripts/items/armor/barbarians/animal_hide_armor"));
    }
});
