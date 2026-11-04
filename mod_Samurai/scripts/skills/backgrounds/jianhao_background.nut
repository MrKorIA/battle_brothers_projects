this.jianhao_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = { Tattoo = 0 },
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.jianhao";
		this.m.Name = "Кэнсэй";
		this.m.Icon = "ui/backgrounds/background_jianhao.png";
		this.m.BackgroundDescription = "Кэнсэй — живой миф, чье имя стало синонимом резни. Он рубил королей, сражался с чудовищами и побеждал толпы в одиночку. Даже лишившись пальцев и получив шрамы, он не утратил ни капли мастерства — его тело помнит бой лучше, чем разум помнит боль. Сломленный не возрастом, а бесконечной чередой предательств и битв, он ищет последнее поле, где сможет либо найти ученика, либо умереть так, как подобает истинному клинку.";
		this.m.GoodEnding = "Мечи с Дальнего Востока.";
		this.m.BadEnding = "Мечи с Дальнего Востока.";
		this.m.HiringCost = 600;
		this.m.DailyCost = 35;
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
			"Мастер меча"
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
			},
			{
				id = 3,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] к защите в ближнем бою если держит в руках катану со способностью \'[color=" + this.Const.UI.Color.PositiveValue + "]Быстрая цель[/color]\'"
			},
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
				text = this.getDescription()
			},
			{
				id = 3,
				type = "text",
				icon = "ui/icons/special.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10[/color] к защите в ближнем бою если держит в руках катану со способностью \'[color=" + this.Const.UI.Color.PositiveValue + "]Быстрая цель[/color]\'"
			},
		];
	}

	function onBuildDescription()
	{
		return "{Одно то, как %name% держит рукоять меча, выдаёт человека, чей клинок движется быстрее, чем вы успеете моргнуть. | Немногие удостаиваются титула кэнсэй - \'святой меч\'. %name% - один из них. | Взгляд %name% спокоен, как гладь горного озера, а рука столь же тверда, сколь безмятежен этот взгляд. | Говорят, %name% способен рассечь надвое падающий лепесток сакуры одним движением, будто клинок сам напросился на эту забаву.} {Легенда гласит, что в додзё, затерянном среди дальних гор, наставник заставлял его час за часом рубить связки бамбука, пока рука не начала двигаться быстрее мысли. | С раннего детства он держал деревянный меч чаще, чем палочки для еды, и к тому времени, когда взял в руки настоящую катану, ему уже нечему было учиться у сверстников. | Рассказывают, что однажды на горном перевале он в одиночку остановил дюжину разбойников, и лишь трое из них потом клялись, что вообще видели, как он обнажил клинок. | Его учитель верил, что истинный воин должен побеждать, ни разу не вынув меч из ножен. Сам он довёл это искусство до предела - иные так и не поняли, что уже мертвы. | Много лет он странствовал в поисках достойного соперника, вызывая на поединок каждого мастера меча, о ком только доводилось слышать, и ни разу не потерпел поражения.} {Но однажды учитель, давший ему всё, пал от руки предателя, и кодекс, которому он посвятил жизнь, впервые показался ему пустым звуком. | Но однажды он проиграл поединок, в котором поражение казалось ему невозможным, и отказался искупить позор клинком в собственный живот - с тех пор бывшие собратья считают его призраком, живым позором. | Но однажды землетрясение обратило додзё, где он когда-то постигал своё искусство, в груду камней вместе со всеми, кого он называл семьёй. Он остался единственным хранителем стиля, которому больше некого учить. | Но однажды его обвинили в трусости за спасённую, а не отнятую жизнь пленника, изгнали из клана и лишили права носить фамильный герб. | Но однажды он победил в поединке сына своего даймё и, вместо благодарности, был вынужден бежать за много земель отсюда, преследуемый жаждущей мести роднёй. | Но одна-единственная ошибка - и меч соперника оставил свой след на его теле там, где до этого не бывало ни царапины. С тех пор он ищет способ доказать себе, что та ошибка была случайностью.} {Теперь он ищет тех, кто готов заплатить за клинок, не спрашивая, что привело его в такие края. | Он всё ещё кланяется перед тем, как обнажить меч - привычка, въевшаяся глубже воспоминаний о доме. | Теперь он почти не разговаривает, но стоит ему коснуться катаны, как руки начинают говорить куда красноречивее слов. | Теперь он заваривает чай с той же неспешной точностью, с какой, по слухам, наносит смертельный удар - вы не уверены, какое из двух умений пугает вас больше. | %name% - кэнсэй без додзё и без учеников, и потому нанимается к тем, кто способен предложить хоть какую-то цель его клинку. | Немногословный и невозмутимый, он производит впечатление человека, для которого битва - не работа, а единственная оставшаяся форма молитвы.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-5,
				-5
			],
			Bravery = [
				12,
				10
			],
			Stamina = [
				-10,
				-10
			],
			MeleeSkill = [
				15,
				15
			],
			RangedSkill = [
				-10,
				-10
			],
			MeleeDefense = [
				5,
				5
			],
			RangedDefense = [
				0,
				0
			],
			Initiative = [
				-10,
				-10
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
				items.equip(this.new("scripts/items/weapons/wushiweapon36"));
			}
			else if (r == 1)
			{
				items.equip(this.new("scripts/items/weapons/wushiweapon36"));
			}
			else if (r == 2)
			{
				items.equip(this.new("scripts/items/weapons/wushiweapon36"));
			}
		}
		else
		{
			r = this.Math.rand(0, 1);

			if (r == 0)
			{
				items.equip(this.new("scripts/items/weapons/wushiweapon36"));
			}
			else if (r == 1)
			{
				items.equip(this.new("scripts/items/weapons/wushiweapon36"));
			}
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/wushi_armor15"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/wushi_armor15"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/wushi_armor15"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/wushi_armor15"));
		}

	}
    
	function onAfterUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		local item = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item != null)
		{
			if (this.getContainer().getActor().getSkills().hasSkill("actives.wushiweapon32_01"))
			{
				_properties.MeleeDefense += 10;
			}			
		}
	}

	function onSerialize( _out )
	{
		this.character_background.onSerialize(_out);
		_out.writeU8(this.m.Tattoo);
	}

	function onDeserialize( _in )
	{
		this.character_background.onDeserialize(_in);
		this.m.Tattoo = _in.readU8();
	}
});

