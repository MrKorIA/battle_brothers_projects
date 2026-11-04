this.wushi_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.wushi";
		this.m.Name = "Самурай";
		this.m.Icon = "ui/backgrounds/background_wushi.png";
		this.m.BackgroundDescription = "Самурай превосходит всех во владении двуручным оружием, но может быть уязвим на расстоянии.";
		this.m.GoodEnding = "Лучший мечник, которого ты когда-либо видел, %name% самурай, был естественным дополнением %companyname%. Но человек не может сражаться вечно. Несмотря на растущий успех отряда, становилось очевидно, что самурай просто не может больше физически. Он ушел на покой, купив хороший участок земли, и наслаждается уединением. По крайней мере, так ты думал. Ты отправился навестить его и обнаружил, что он тайно обучает дочь одного дворянина. Ты пообещал сохранить это в тайне.";
		this.m.BadEnding = "Жаль, что %name% самураю пришлось провести свои последние годы в приходящей в упадок наемной компании. Он ушел, заявив, что больше не может физически. Ты думаешь, он просто хотел смягчить удар для %companyname%, потому что через неделю он без труда убил десятерых разбойников на обочине дороги. Последнее, что ты слышал, он обучал неблагодарных принцев искусству фехтования.";
		this.m.HiringCost = 400;
		this.m.DailyCost = 25;
		this.m.Excluded = [
			"trait.huge",
			"trait.weasel",
			"trait.fear_undead",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.paranoid",
			"trait.impatient",
			"trait.clubfooted",
			"trait.irrational",
			"trait.athletic",
			"trait.gluttonous",
			"trait.dumb",
			"trait.bright",
			"trait.clumsy",
			"trait.tiny",
			"trait.insecure",
			"trait.fainthearted",
			"trait.craven",
			"trait.bleeder",
			"trait.dastard",
			"trait.hesitant",
			"trait.fragile",
			"trait.iron_lungs",
			"trait.tough",
			"trait.strong",
			"trait.bloodthirsty"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.RangedSkill
		];
		this.m.Titles = [
			"Самурай"
		];
		this.m.Names = this.Const.Strings.WushiNames;
		this.m.Faces = this.Const.Faces.WushiMale;
		this.m.Hairs = this.Const.Hair.WushiMaleOnly;
		this.m.HairColors = this.Const.HairColors.Wushi;
		this.m.Beards = this.Const.Beards.All;
		this.m.BeardChance = 0;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(1, 3);
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
		return "{%name% родился в семье воинов, служивших одному господину, и меч вложили ему в руку раньше, чем ложку. | Служба господину была для него не выбором, а наследством: так служили его отец и дед. | Говорят, в тех землях, откуда он родом, воин, не умеющий держать кисть так же твёрдо, как клинок, считается недоучкой. Потому будущего воина господина учили всему сразу. | Выросший при дворе господина, главы небольшого дома, он годами отрабатывал одни и те же удары, пока меч не стал продолжением руки. | Сын мелкого воина, он дослужился до собственных доспехов и места в строю своего господина, чего отцу не удалось за всю жизнь. | Он с юности считал, что честь воина измеряется службой господину, а не жалованьем, и жил соответственно.} {Но однажды господин отправил войско за море, и высадка обернулась разгромом: уцелевших разбросало по чужим берегам. Кое-кто сколотил шайку и принялся грабить окрестные деревни. Он отказался к ним присоединиться и ушёл один. | Но на чужбине армия сгнила от лихорадки, не дойдя до первой битвы. Выжившие подались в разбойники, кормясь за счёт крестьян, а он счёл, что лучше голодать, чем отнимать хлеб у тех, кого не победил в бою. | Но буря разбила корабли у незнакомого побережья. Те, кто выбрался на берег, быстро нашли себе ремесло грабителей. Он не взял ни одной монеты, которую не заработал бы мечом в честном деле. | Но господин пал в первом же сражении на чужом берегу, и войско рассыпалось: военачальники бежали, солдаты разбрелись кто куда. Он отверг предложение примкнуть к шайке бывших соратников. | Но поход на чужбине растянулся на годы, пока не опустела казна, а вместе с ней и верность людей. Вчерашние товарищи стали налётчиками. Он налётчиком не стал и с тех пор идёт своей дорогой. | Но господин вернулся на родину, бросив остатки войска без кораблей и без обещанного жалованья. Многие обратились в шайки, живущие поборами с местных. Ему это показалось хуже смерти.} {Доспехи на нём латаны много раз, но ни одна ремённая пряжка не болтается и каждая пластина начищена. | %name% стоит на площади прямо, как копьё, воткнутое в землю, и не ищет ничьего взгляда. | Он держит меч так, как другие держат хрупкую вещь: бережно и не выпуская из виду. | Люди на площади косятся на его чужеземный доспех и обходят его на шаг шире, чем нужно, а он делает вид, что не замечает. | Он кланяется вам коротко и сухо, не склоняя головы ниже, чем нужно, и не отводя глаз. | Нищета отразилась на нём только худобой: одежда чиста, сапоги целы, и ничто не выдаёт в нём человека, привыкшего просить. | Говорят, он по утрам в одиночку отрабатывает удары у городской стены и не пропустил ни единого дня. | %name% не просит у вас ни хлеба, ни монеты, лишь молча стоит в стороне, будто ждёт приказа.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				20,
				20
			],
			Bravery = [
				0,
				0
			],
			Stamina = [
				0,
				0
			],
			MeleeSkill = [
				10,
				10
			],
			RangedSkill = [
				-20,
				-20
			],
			MeleeDefense = [
				0,
				0
			],
			RangedDefense = [
				-10,
				-10
			],
			Initiative = [
				0,
				0
			]
		};
		return c;
	}


	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;

		if (this.Const.DLC.Unhold)
		{
			r = this.Math.rand(0, 2);

			if (r == 0)
			{
				items.equip(this.new("scripts/items/weapons/wushiweapon15"));
			}
			else if (r == 1)
			{
				items.equip(this.new("scripts/items/weapons/wushiweapon15"));
			}
			else if (r == 2)
			{
				items.equip(this.new("scripts/items/weapons/wushiweapon15"));
			}
		}
		else
		{
			r = this.Math.rand(0, 1);

			if (r == 0)
			{
				items.equip(this.new("scripts/items/weapons/wushiweapon17"));
			}
			else if (r == 1)
			{
				items.equip(this.new("scripts/items/weapons/wushiweapon17"));
			}
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/wushi_armor"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/wushi_armor"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/wushi_armor"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/wushi_armor"));
		}
        if (this.Math.rand(1, 100) <= 99)
		{
			items.equip(this.new("scripts/items/helmets/wushi_helmet11"));
		}
	}

});

