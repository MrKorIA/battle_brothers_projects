this.paladin_commander_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hackflows_paladin_commander";
		this.m.Name = "Паладин";
        this.m.Icon = "ui/backgrounds/background_paladin.png";
        this.m.BackgroundDescription = "Паладины - это живые легенды, чьи праведные свершения вошли в баллады. Редко встретишь столь грозного воина на пыльных дорогах, и ещё реже найдётся отряд, чья казна способна потянуть неподъёмный контракт.";
        this.m.GoodEnding = "Ходят слухи, что паладин %name% всё ещё жив - и это, пожалуй, лучшая новость, какую вы слышали за последние годы. Поговаривают, будто где-то далеко на севере он всё-таки отыскал то самое древнее чудовище, что не смел одолеть в одиночку, и что после той схватки леса в округе на много дней затихли. Крестьяне в тех краях до сих пор ставят ему свечи в часовнях, хотя сам он не просил ни свечей, ни памяти - только тишины, в которой больше ничего не рычит.";
        this.m.BadEnding = "Поговаривают, что паладин %name% нашёл-таки то самое логово - и что поход этот оказался последним. Крестьяне сложили о нём песню, в которой он побеждает, - так уж заведено: песни поют не о том, что было. Тела его так и не нашли; зато чудищ в тех краях заметно стало больше, и никто больше не приходит их выжигать.";
		this.m.HiringCost = 6000;
		this.m.DailyCost = 66;
		this.m.Excluded = [
			"trait.ailing",
			"trait.asthmatic",
			"trait.bleeder",
			"trait.bloodthirsty",
			"trait.bright",
			"trait.brute",
			"trait.clubfooted",
			"trait.clumsy",
			"trait.cocky",
			"trait.craven",
			"trait.dastard",
			"trait.deathwish",
			"trait.disloyal",
			"trait.drunkard",
			"trait.dumb",
			"trait.eagle_eyes",
			"trait.fainthearted",
			"trait.fat",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.fear_undead",
			"trait.fragile",
			"trait.gluttonous",
			"trait.greedy",
			"trait.hate_beasts",
			"trait.hate_greenskins",
			"trait.hesitant",
			"trait.impatient",
			"trait.insecure",
			"trait.irrational",
			"trait.lucky",
			"trait.night_blind",
			"trait.night_owl",
			"trait.paranoid",
			"trait.pessimist",
			"trait.quick",
			"trait.short_sighted",
			"trait.spartan",
			"trait.superstitious",
			"trait.tiny",
			"trait.weasel"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Initiative,
			this.Const.Attributes.RangedSkill,
			this.Const.Attributes.RangedDefense
		];
		this.m.Titles = [
			"Герой",
			"Легенда",
			"Паладин",
			"Львиное сердце",
			"Справедливый",
			"Каратель",
			"Благословенный",
			"Героический",
			"Светлый",
			"Убийца тьмы",
			"Несущий свет",
			"Рыцарь"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.AllMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(5, 6);
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
		];
	}

	function onBuildDescription()
	{
        return "{Расхожая поговорка гласит: бывает два типа людей - добрые и могущественные. %name% - редкое исключение из этого правила, живое опровержение этой поговорки. Крестьяне славят его как героя, ведь где бы он ни появился, нападения чудовищ неизменно становятся реже, а потом и вовсе прекращаются. | Немногие могут похвастать тем, что сила и добродетель уживаются в одном человеке, и почти никто - тем, что обе они изо дня в день брошены на охоту за чудовищами. %name% - редкое исключение. | Там, где обычный наёмник ищет выгодный контракт, %name%, по слухам, ищет очередное логово чудовищ, которое стоит выжечь дотла.} {На ваш вопрос, зачем такому человеку вообще искать место в наёмном отряде, он лишь пожимает плечами: ему известны логова, с которыми даже ему не совладать в одиночку. | Он признаётся, что в одиночку выследил и истребил немало тварей, но кое-какие гнёзда чудовищ ему не по силам уничтожить без помощи умелых клинков. | По его словам, где-то на севере залегло чудовище настолько древнее и могучее, что попытка одолеть его в одиночку была бы не героизмом, а глупостью. | Он говорит, что предпочёл бы работать один, но некоторые твари водятся стаями, а стаю в одиночку не перебить, каким бы умелым бойцом ты ни был.} {А его баснословное жалование - всего лишь плата за участие в обычных сражениях в перерывах между охотой на чудовищ. | Заламывая цену, от которой большинство нанимателей поперхнулось бы элем, %name% невозмутимо поясняет: это плата лишь за обычную работу, а охоту на чудовищ он ведёт по велению души, а не кошелька. | %name% равнодушен к золоту, когда речь идёт о монстрах, но за прочие поручения назначает такую цену, что вы начинаете подозревать в нём скрытую жадность - или просто хорошее чувство юмора.}";
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");

		if (this.Math.rand(1, 100) <= 25)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
			tattoo_body.Visible = true;
		}

		if (this.Math.rand(1, 100) <= 25)
		{
			tattoo_head.setBrush("scar_02_head");
			tattoo_head.Visible = true;
		}
	}

	function updateAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");

		if (tattoo_body.HasBrush)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
		}
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				14,
				20
			],
			Bravery = [
				15,
				23
			],
			Stamina = [
				14,
				18
			],
			MeleeSkill = [
				14,
				14
			],
			RangedSkill = [
				0,
				0
			],
			MeleeDefense = [
				8,
				8
			],
			RangedDefense = [
				-4,
				0
			],
			Initiative = [
				-8,
				0
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		items.equip(this.new("scripts/items/weapons/named/named_greatsword"));
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/coat_of_plates"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/coat_of_scales"));
		}

		items.equip(this.new("scripts/items/helmets/full_helm"));
	}
});

