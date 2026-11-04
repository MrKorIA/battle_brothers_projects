this.pirate_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hackflows_pirate";
		this.m.Name = "Пират";
        this.m.Icon = "ui/backgrounds/background_pirate.png";
        this.m.BackgroundDescription = "Хоть навыки мореплавания и бесполезны на суше, умение пускать кровь ценится везде. Пираты - это закалённые в боях головорезы, не понаслышке знакомые с кровавой жестокостью абордажных схваток.";
		this.m.GoodEnding = "Бывший пират, %name% хорошо вписался в \'%companyname%\' и проявил себя как отличный боец. Скопив целую гору монет, он ушел из отряда и вернулся туда, откуда пришел. В последний раз его видели плывущим на лодке в сторону маленькой деревни.";
		this.m.BadEnding = "Когда  отряд \'%companyname\' пришёл в упадок, пират %name% покинул его и снова пошёл своим путем. Он вернулся к пираству, неся свою жадную жестокость вдоль берегов речных деревень. Вы не уверены, правда ли это, но молва гласит, что он был пронзен вилами конюха. Говорят, что жители города вывесили части его тела вдоль внешних стен в качестве предупреждения будущим рейдерам.";
		this.m.HiringCost = 10;
		this.m.DailyCost = 21;
		this.m.Excluded = [
			"trait.weasel",
			"trait.hate_undead",
			"trait.night_blind",
			"trait.ailing",
			"trait.asthmatic",
			"trait.clubfooted",
			"trait.hesitant",
			"trait.loyal",
			"trait.tiny",
			"trait.fragile",
			"trait.clumsy",
			"trait.fainthearted",
			"trait.craven",
			"trait.bleeder",
			"trait.dastard",
			"trait.insecure"
		];
		this.m.Titles = [
			"Головорез",
			"Мародер",
			"Пират",
			"Деревянная нога",
			"Альбатрос",
			"Беззубый"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Raider;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(2, 4);
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
        return "{С детства влюблённый в море, %name% начал свой путь простым матросом на торговом судне. | %name% пошёл в торговый флот, как и его отец, и отец его отца - море у них в семье было делом привычным, почти наследственным. | Не имея иных перспектив в родном городе, %name% нанялся юнгой на первый попавшийся торговый корабль, лишь бы увидеть что-то, кроме родных крыш. | %name% сбежал из дома, заворожённый рассказами старых моряков о дальних портах и правдами и неправдами пробился на борт торгового судна.} {Море, как оказалось, было безопасно от чудовищ, но вовсе не от людской алчности: однажды, когда его корабль перевозил особо ценный груз пряностей, на него напали пираты. Почти всю команду вырезали до последнего человека - его одного пощадили лишь потому, что он выдал местоположение другого, ещё более богатого каравана, а устроенный по его наводке набег оказался настолько успешным, что его пригласили в команду. | Оказавшись на волосок от смерти во время абордажа, он купил себе жизнь единственной ценной вещью, что у него была - сведениями о маршруте другого торгового флота, гружённого пряностями, и вскоре после удачного набега по его наводке пираты предложили ему остаться. | Команда, в которой он служил, устала от грошового жалования и капитанской жадности и однажды ночью подняла бунт: капитана выбросили за борт, а на корабле подняли чёрный флаг. | Капитан, на чьём судне он служил, сам решил, что грабить куда прибыльнее, чем возить чужие грузы за скромный процент, и в одну ночь вся команда из торговцев превратилась в пиратов.} Так или иначе, оказавшись в пиратской команде, он провёл не один год, наводя страх на прибрежные воды. {Но в последнее время торговые суда встречаются всё реже, и он ищет, куда бы применить свои навыки на суше. Он полагает, что ремесло наёмника и пиратство не так уж далеки друг от друга - вы не вполне уверены, что готовы с этим согласиться. | Но его корабль пошёл ко дну во время внезапного шторма, и %name%, чудом выбравшись на берег, решил, что с него хватит зыбкой палубы под ногами - твёрдая земля неожиданно показалась ему куда привлекательнее. | Но, спустя время, его судно было потоплено дворянским флотом, посланным очистить побережье от разбоя, и %name%, оставшись без корабля и команды, решил попытать счастья на суше. | Но, спустя время, его корабль пошёл ко дну в стычке с более удачливыми конкурентами по их опасному ремеслу, и %name%, оставшись без судна, решил, что пришло время сменить палубу на твёрдую землю.}";
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

		if (this.Math.rand(1, 100) <= 40)
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
			Hitpoints = [0, 0]
			Bravery = [0, -3]
			Stamina = [5, 5]
			MeleeSkill = [6, 3]
			RangedSkill = [0, 0]
			MeleeDefense = [4, 2]
			RangedDefense = [4, 4]
			Initiative = [5, 5]
		};
		return c;
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

