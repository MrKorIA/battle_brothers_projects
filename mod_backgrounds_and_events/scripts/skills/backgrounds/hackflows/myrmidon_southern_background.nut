this.myrmidon_southern_background <- this.inherit("scripts/skills/backgrounds/hackflows/myrmidon_background", {
	m = {},
	function create()
	{
		this.myrmidon_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernMale;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.BeardChance = 90;
		this.m.Ethnicity = 1;
		this.m.Excluded = [
			"trait.brave",
			"trait.bright",
			"trait.clubfooted",
			"trait.craven",
			"trait.determined",
			"trait.fragile",
			"trait.loyal",
		];
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onBuildDescription()
    {
        return "{Слишком крепкий телом, чтобы быть простым разбойником, но недостаточно хитрый, чтобы возглавить шайку, %name% годами служил правой рукой одного известного главаря пустынных грабителей. | %name% пробился в замы главаря разбойничьей шайки не хитростью, а простой силой - в споре, кто должен стоять по правую руку атамана, обычно побеждает тот, чей кулак тяжелее. | Немногословный и безотказный, %name% стал незаменим для своего главаря именно потому, что никогда не задавал вопросов и никогда не оспаривал его решений. | Однажды купленный на невольничьем рынке главарём шайки для грязной работы, %name% годами исправно выполнял любой приказ - пока хозяин, оценив его преданность и кулаки больше, чем чужую собственность, не даровал ему вольную и не сделал своей правой рукой. | Никогда не мечтавший о собственной банде, %name% находил особое удовлетворение в том, чтобы служить чужой воле - лишь бы эта воля щедро платила за верность.} {Всё оборвалось разом, когда один из своих же выдал расположение лагеря, и банду вырезали почти подчистую внезапным ударом личной стражи визиря при поддержке нанятых им мечей. | Однако жадность одного из своих погубила всех: он попытался в одиночку сбыть краденое добро прямо на городском рынке, и вскоре по его следу пришёл целый карательный отряд, посланный визирем. | Однако стареющий главарь стал слишком неосторожен, нападая на караваны всё ближе к городским стенам, и однажды дерзость обошлась банде слишком дорого - визирь, устав терпеть убытки купцов, отправил на их лагерь целое войско. | Но раздел добычи после особенно удачного грабежа каравана перерос в кровавую свару внутри банды, а шум привлёк карательный отряд визиря, довершивший дело.} С гибелью главаря и большей части товарищей %name% решил, что пришло время сменить род занятий. {Теперь он предлагает свою преданность и силу тому, кто готов платить не хуже прежнего главаря. | Он не привык принимать решения сам - и, судя по всему, ищет не столько работу, сколько нового человека, которому можно подчиняться. | Массивный и неразговорчивый, он производит впечатление человека, для которого приказы всегда были куда понятнее собственных мыслей. | Он ничего не смыслит в военной тактике и командовании - зато превосходно умеет исполнять чужие приказы, не задавая лишних вопросов.}";
    }

	function onAddEquipment()
    {
        local items = this.getContainer().getActor().getItems();
        local r;
        r = this.Math.rand(0, 3);

        if (r == 0)
        {
            items.equip(this.new("scripts/items/weapons/knife"));
        }
        else if (r == 1)
        {
            items.equip(this.new("scripts/items/weapons/bludgeon"));
        }
        else if (r == 2)
        {
            items.equip(this.new("scripts/items/weapons/oriental/light_southern_mace"));
        }
        else if (r == 3)
        {
            items.equip(this.new("scripts/items/weapons/oriental/saif"));
        }

        r = this.Math.rand(0, 4);

        if (r == 0)
        {
            items.equip(this.new("scripts/items/armor/oriental/cloth_sash"));
        }
        else if (r == 1)
        {
            items.equip(this.new("scripts/items/armor/oriental/padded_vest"));
        }
        else if (r == 2)
        {
            items.equip(this.new("scripts/items/armor/oriental/nomad_robe"));
        }
        else
        {
            items.equip(this.new("scripts/items/armor/oriental/thick_nomad_robe"));
        }

        r = this.Math.rand(0, 3);

        if (r == 1)
        {
            items.equip(this.new("scripts/items/helmets/oriental/southern_head_wrap"));
        }
        else if (r == 2)
        {
            items.equip(this.new("scripts/items/helmets/oriental/nomad_head_wrap"));
        }
        else if (r == 2)
        {
            items.equip(this.new("scripts/items/helmets/oriental/nomad_leather_cap"));
        }
    }

});

