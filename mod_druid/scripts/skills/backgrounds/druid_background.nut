// Druid background methods. Defined as a plain table so they can be either inherited into our own
// standalone background (when XBE is absent) or copied wholesale onto XBE's druid (see mod_druid.nut).
local def = {
    m = {}
    function create()
    {
        this.character_background.create();
        this.m.ID = "background.hackflows_druid";
        this.m.Icon = "druid/background_druid.png";
        this.m.Name = "Друид";

        this.m.HiringCost = 1400;
        this.m.DailyCost = 14;
        this.m.ExcludedTalents = [
            ::Const.Attributes.RangedSkill
        ];
        this.m.Excluded = [
            "trait.brute"
            "trait.clubfooted"
            "trait.cocky"
            "trait.dumb"
            "trait.fat"
            "trait.gluttonous"
            "trait.greedy"
            "trait.hate_beasts"
            "trait.fear_beasts"
            "trait.impatient"
            "trait.insecure"
            "trait.night_blind",
            "trait.short_sighted"
            "trait.superstitious"
            "trait.teamplayer"
        ];
        this.m.Titles = [
            "Друид",
            "Ведун",
            "Зелёный Плащ",
            "Покровитель Зверей",
        ];
		this.m.Faces = this.Const.Faces.WildMale;
		this.m.Hairs = this.Const.Hair.WildMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.WildExtended;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.BeardChance = 100;
    }

    // For Reforged
    function createPerkTreeBlueprint()
    {
        return ::new(::DynamicPerks.Class.PerkTree).init({
            DynamicMap = {
                "pgc.rf_exclusive_1": [],
                "pgc.rf_shared_1": [],
                "pgc.rf_weapon": [],
                "pgc.rf_armor": [],
                "pgc.rf_fighting_style": []
            }
        });
    }

    function getPerkGroupMultiplier(_groupID, _perkTree)
    {
        return ::std.Table.get({
            "pg.druid": -1
            "pg.rf_vigorous": 1.5
            "pg.special.rf_student": 1.5
        }, _groupID)
    }

    // Borrowed from XBE's Reforged compat shim so we fully own the tree when both are present.
    function getPerkGroupCollectionMin(_collection)
    {
        switch (_collection.getID())
        {
            case "pgc.rf_shared_1":
                return _collection.getMin() + 1;

            case "pgc.rf_fighting_style":
                return _collection.getMin() - 1;
        }
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
                id = 10
                type = "text"
                icon = "ui/icons/special.png"
                text = "Призывает дикого хищника из окрестных земель на свободную клетку по соседству. Зверь будет охотиться на ваших врагов, но его первобытная природа не подчиняется чужим приказам."
            }
        ];
    }

    function onSetAppearance()
    {
        local actor = this.getContainer().getActor();
        local tattoo_body = actor.getSprite("tattoo_body");
        local tattoo_head = actor.getSprite("tattoo_head");
        local hair_color = [
            "blonde",
            "brown",
            "red"
        ];
        hair_color = hair_color[this.Math.rand(0, hair_color.len() - 1)]
        local hair_type = [
            "03",
            "08",
            "18",
            "21"
        ];
        hair_type = hair_type[this.Math.rand(0, hair_type.len() - 1)]
        local beard_type = [
            "12",
            "13",
            "14",
            "15",
            "17"
        ];
        beard_type = beard_type[this.Math.rand(0, beard_type.len() - 1)]

        tattoo_body.setBrush("tattoo_04_" + actor.getSprite("body").getBrush().Name);
        tattoo_body.Visible = true;
        tattoo_head.setBrush("warpaint_02_head");
        tattoo_head.Visible = true;
        actor.getSprite("permanent_injury_4").setBrush("hair_black_zombie_04");
        actor.getSprite("permanent_injury_4").Visible = true;
        actor.getSprite("hair").setBrush("hair_" + hair_color + "_" + hair_type);
        actor.getSprite("beard").setBrush("beard_" + hair_color + "_" + beard_type);
        actor.getSprite("beard_top").setBrush(actor.getSprite("beard").getBrush().Name + "_top");
        actor.getSprite("hair").Color = this.createColor("#61b06d");
        actor.getSprite("beard").Color = this.createColor("#61b06d");
        actor.getSprite("beard_top").Color = this.createColor("#61b06d");
    }

    function onBuildDescription()
    {
        return "{Закутанный в шкуры и ткань, крашенную корой, %name% пахнет мхом и давнишним дождём. | %name% немногословен с людьми, зато подолгу беседует с деревьями - по крайней мере, так кажется со стороны. | %name% не носит при себе никаких идолов, но то и дело опускается на колени, чтобы прижаться ухом к земле. | %name% носит волосы, спутанные не хуже лесного подлеска, а борода его полна сухой листвы и трухи. | %name% пахнет прелой листвой и дымом костра, разведённого будто бы не кресалом, а чем-то более древним. | %name% ступает совершенно бесшумно, будто сама земля стелется ему под ноги, чтобы не выдать его шагов. | %name% тихо произносит нечто на языке, которого вы не понимаете, и стая птиц над лагерем разом меняет направление полёта.} {Он рос на опушке леса, вдали от власти любого лорда. | Поговаривают, что он был отшельником, постигшим старые зелёные наречия. | Шепчутся, будто его изгнали из родной деревни за разговоры с волками. | Никто не знает, откуда он пришёл - известно лишь, что лес расступился, чтобы пропустить его. | Он утверждает, что его учил лесной народ, и вы не слишком склонны спорить. | Говорят, будто в детстве он потерялся в чаще на три дня и три ночи, а вышел оттуда уже совсем другим человеком. | Некоторые уверяют, что он вовсе не человеческого рода, а лишь носит человеческий облик, точно старый плащ.} {Но орки жгут древние рощи одну за другой, и старые обряды больше не в силах сдержать их натиск - %name% решил, что настало время искать иных союзников. | Однако мертвецы поднимаются из земель, что прежде считались священными, и лес больше не в силах сдержать их сам - %name% впервые вышел за его пределы искать помощи. | Но культисты осквернили один из священных кругов его леса, и в одиночку с этим ему не справиться, как бы %name% ни хотел обратного - пришлось искать помощи на стороне. | Однако земля под старыми дубами почернела и умерла там, где прошла нежить - %name% покинул чащу, чтобы найти тех, кто владеет сталью, и свершить месть. | Но %name% видел, как орочий отряд вырубил под корень священную рощу за одну ночь - выяснилось, что топоры и стрелы куда убедительнее любых уговоров и духов. | Однако что-то пробудилось под старым курганом, и с тех пор лес не знает покоя - %name% решил, что пришла пора научиться воевать, а не только слушать шёпот деревьев. | %name% долго жил в мире с природой, но ни с мечом наёмника, ни с орочьим топором на языке трав не договоришься - пришлось искать иные средства.}";
    }

    function onChangeAttributes()
    {
        local c = {
            Hitpoints = [0, 5]
            Bravery = [5, 12]
            Stamina = [-5, 10]
            MeleeSkill = [0, 0]
            RangedSkill = [-5, 0]
            MeleeDefense = [0, 3]
            RangedDefense = [0, 5]
            Initiative = [-5, 5]
        };
        return c;
    }

    function onAdded()
    {
        this.character_background.onAdded();
        this.m.Container.add(::new("scripts/skills/actives/druid_summon_beast"));
    }

    function onAddEquipment()
    {
        local items = this.getContainer().getActor().getItems();

        // A stout stick or a gnarled staff cut from the woods (the latter is XBE's druid weapon).
        items.equip(::new(::Math.rand(1, 2) == 1
            ? "scripts/items/weapons/wooden_stick"
            : "scripts/items/weapons/greenskins/goblin_staff"));

        // Rough woodsfolk garb - hides, robes and sackcloth under hoods and straw hats, never plate.
        switch (::Math.rand(1, 5)) {
            case 1:
                items.equip(::new("scripts/items/armor/leather_tunic"));
                break;
            case 2:
                items.equip(::new("scripts/items/armor/monk_robe"));
                items.equip(::new("scripts/items/helmets/straw_hat"));
                break;
            case 3:
                items.equip(::new("scripts/items/armor/thick_dark_tunic"));
                items.equip(::new("scripts/items/helmets/dark_cowl"));
                break;
            case 4:  // XBE's druid armor
                items.equip(::new("scripts/items/armor/tattered_sackcloth"));
                items.equip(::new("scripts/items/helmets/straw_hat"));
                break;
            case 5:  // XBE's druid armor
                items.equip(::new("scripts/items/armor/leather_wraps"));
                break;
        }
    }
}

// Expose the methods for the XBE-overwrite path, and build the standalone background by inheritance.
::Druid.BackgroundMethods <- def;
this.druid_background <- this.inherit("scripts/skills/backgrounds/character_background", clone def);
