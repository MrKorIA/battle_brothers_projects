this.myrmidon_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hackflows_myrmidon";
		this.m.Name = "Костолом";
		this.m.Icon = "ui/backgrounds/background_myrmidon.png";
		this.m.BackgroundDescription = "Недостаточно сильные, чтобы сколотить собственную банду разбойников, и слишком тупоголовые для хитрых воровских краж - костоломы восполняют нехватку ума и таланта абсолютной готовностью к любой бесчестной и грязной работе.";
        this.m.GoodEnding = "После нескольких лет в отряде \'%companyname%\' %name% так и не научился отдавать приказы, зато стал человеком, на которого командир мог положиться в любой передряге. Когда отряд однажды лишился предводителя, никто не ожидал, что именно %name% окажется тем, кто соберёт остальных и выведет их из окружения. Он по-прежнему не любил принимать решения, но теперь хотя бы понимал, что иногда другого выхода нет. После этого он стал держаться рядом с новым командиром и, похоже, впервые был вполне доволен своей судьбой.";
        this.m.BadEnding = "Когда %name% покинул отряд \'%companyname%\', он недолго оставался без хозяина. Главарь разбойников нашёл его почти сразу и предложил привычную работу за приличную плату. Спустя несколько месяцев %name% участвовал в нападении на обоз, но его уже ждали: охрана оказалась гораздо многочисленнее, чем обещал главарь. Когда остальные бросились бежать, %name% остался драться, потому что привык выполнять чужие приказы до конца. Когда всё закончилось, его нашли среди убитых, всё ещё сжимавшего в руке рукоять топора.";
		this.m.HiringCost = 30;
		this.m.DailyCost = 15;
		this.m.Excluded = [
			"trait.brave",
			"trait.bright",
			"trait.clubfooted",
			"trait.craven",
			"trait.determined",
			"trait.fragile",
			"trait.loyal",
		];
		this.m.Titles = [
			"Крыса",
			"Отброс",
			"Жестокий",
			"Преступник",
			"Разбойник"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Raider;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(1, 3);
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
        return "{Слишком крепкий телом, чтобы быть простым разбойником, но недостаточно хитрый, чтобы возглавить шайку, %name% годами служил правой рукой одного известного главаря окрестных грабителей. | %name% пробился в заместители главаря разбойничьей шайки не хитростью, а простой силой - в споре, кто должен стоять по правую руку атамана, обычно побеждает тот, чей кулак тяжелее. | Немногословный и безотказный, %name% стал незаменим для своего главаря именно потому, что никогда не задавал вопросов и никогда не оспаривал его решений. | %name% примкнул к банде голодным беглым крестьянином, но за годы разбоя дослужился до места подле самого атамана - должности, за которую многие в банде готовы были убить. | Никогда не мечтавший о собственной банде, %name% находил особое удовлетворение в том, чтобы служить чужой воле - лишь бы эта воля щедро платила за верность.} {Всё оборвалось разом, когда один из своих же выдал расположение лагеря, и дворянская дружина при поддержке наёмного отряда застала банду врасплох и вырезала её почти подчистую. | Однажды пьяная похвальба одного из разбойников в придорожном трактире стоила банде всего: уже на следующий день их лагерь штурмом взяли дворянские латники и нанятые ими мечи, не оставившие от банды почти никого. | Но жадность одного из своих погубила всех: он попытался в одиночку сбыть краденое дворянское добро, и вскоре по его следу пришла целая карательная экспедиция. | Однако стареющий главарь стал слишком неосторожен в своих набегах, и однажды дерзость обошлась банде слишком дорого - объединённый отряд дворян и наёмников разгромил их лагерь и никого не пощадив. | Но раздел добычи после особенно удачного грабежа перерос в кровавую свару внутри банды, а шум привлёк карательный отряд, довершивший дело.} С гибелью главаря и большей части товарищей %name% решил, что пришло время сменить род занятий. {Теперь он предлагает свою преданность и силу тому, кто готов платить не хуже прежнего главаря. | Он не привык принимать решения сам - и, судя по всему, ищет не столько работу, сколько нового человека, которому можно подчиняться. | Массивный и неразговорчивый, он производит впечатление человека, для которого приказы всегда были куда понятнее собственных мыслей. | Он ничего не смыслит в военной тактике и командовании - зато превосходно умеет исполнять чужие приказы, не задавая лишних вопросов.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [4, 4]
			Bravery = [-4, -4]
			Stamina = [4, 4]
			MeleeSkill = [5, 5]
			RangedSkill = [6, 8]
			MeleeDefense = [0, 3]
			RangedDefense = [0, 3]
			Initiative = [3, 3]
		};
		return c;
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local dirt = actor.getSprite("dirt");
		dirt.Visible = true;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 5);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/falchion"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/flail"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/hand_axe"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/morning_star"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/weapons/military_pick"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/weapons/boar_spear"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/shields/wooden_shield"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/padded_leather"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/patched_mail_shirt"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/worn_mail_shirt"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/leather_lamellar"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/dented_nasal_helmet"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/nasal_helmet_with_rusty_mail"));
		}
	}

});

