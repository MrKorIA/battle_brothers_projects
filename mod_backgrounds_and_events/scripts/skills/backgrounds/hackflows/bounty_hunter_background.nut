this.bounty_hunter_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hackflows_bounty_hunter";
		this.m.Name = "Охотник за головами";
		this.m.Icon = "ui/backgrounds/background_bounty_hunter.png";
		this.m.BackgroundDescription = "Главное - упорство. Охотникам за головами хорошо платят за поимку любого человека, живым или мёртвым.";
        this.m.GoodEnding = "Покинув отряд \'%companyname%\', %name% продолжил заниматься своим ремеслом, как и прежде. До вас дошли слухи, что где-то на востоке он выследил душегуба, больше года скрывавшегося под личиной уважаемого торговца. Награду он отдал вдовам тех, кого этот человек погубил, а себе оставил лишь немного на дорогу. О прошлом он по-прежнему не рассказывает никому, и, как говорят, ему это только на руку: человек, которого никто не знает, никому и не нужен, а значит, и никто не станет за ним охотиться.";
        this.m.BadEnding = "Покинув отряд \'%companyname%\', %name% взялся за заказ: выследить человека, за голову которого давали особенно щедрую награду. По слухам, дошедшим до вас, он шёл по следу почти месяц, и тот привёл его в глухую деревню, где жил обычный пахарь с женой и детьми. Правду он понял слишком поздно: настоящий душегуб сидел в замке и сам же назначил эту награду. Охотник, истреблявший чудовищ под человеческим лицом, оказался в итоге орудием одного из них, а его самого нашли в канаве рядом с мешком, в котором лежала голова невинного.";
		this.m.HiringCost = 30;
		this.m.DailyCost = 31;
		this.m.Excluded = [
			"trait.ailing",
			"trait.asthmatic",
			"trait.brute",
			"trait.clubfooted",
			"trait.clumsy",
			"trait.craven",
			"trait.dastard",
			"trait.deathwish",
			"trait.drunkard",
			"trait.dumb",
			"trait.fat",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.fear_undead",
			"trait.fragile",
			"trait.hesitant",
			"trait.huge",
			"trait.insecure",
			"trait.iron_jaw",
			"trait.iron_lungs",
			"trait.irrational",
			"trait.loyal",
			"trait.night_blind",
			"trait.night_owl",
			"trait.optimist",
			"trait.paranoid",
			"trait.superstitious",
			"trait.teamplayer",
			"trait.tough"
		];
		this.m.Titles = [
			"Охотник",
			"Охотник за головами",
			"Неумолимый",
			"Гончая",
			"Пес",
			"Орел",
			"Жнец",
			"Настойчивый",
			"Следопыт"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.IsCombatBackground = true;
		this.m.Level = this.Math.rand(2, 4);
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
        return "{%name% появился в этих землях несколько лет назад, но никто не может сказать, откуда он пришёл и что делал до этого. | %name% немногословен настолько, что за ним закрепилась дурная слава человека без прошлого - будто оно ему без надобности. | %name% известен немногим, и он явно не намерен ничего менять - на все расспросы он отвечает лишь долгим, изучающим взглядом. | %name% говорит ровно столько, сколько требует дело, и ни словом больше - расспрашивать его о чём-то ещё бесполезно. | Никто не помнит, чтобы %name% рассказывал о себе хоть что-то личное - те немногие, кто пытался разговорить его, быстро оставляли эту затею.} {Ходят слухи, что там, где охотники на чудовищ истребляют монстров природных, он истребляет монстров иного рода - тех, что прячутся под человеческим лицом. | Поговаривают, что не одна деревня облегчённо вздохнула после того, как он покидал её, оставляя за собой лишь труп очередного душегуба, выдававшего себя за честного человека. | Рассказывают, что он способен неделями идти по следу одного-единственного человека, если цена за его голову того стоит. | Слухи о его работе редко бывают приятными: убийцы, насильники, поддельные святые - все, кого он ищет, укрывались личиной обычных людей. | Говорят, что жертвы его ремесла никогда не бывают случайными людьми - если он взялся за кого-то, значит, у этого человека рыльце давно в пушку.} {Его ремесло и без того недалеко от наёмничьего дела - выложить кроны за такого человека, как %name%, любой уважающий себя отряд счёл бы вложением не из худших. | %name% не задаёт лишних вопросов о том, что от него потребуется - похоже, работа наёмника мало чем отличается от его обычного способа заработка. | %name% надеется, что в отряде найдутся люди, которые не станут задавать лишних вопросов и просто позволят ему делать свою работу. | Вас не смущает его немногословность - в конце концов, для человека его ремесла молчание куда полезнее, чем красноречие. | %name% готов работать с наёмниками, но предупреждает сразу - он не станет рассказывать о прошлом, и лучше не пытаться его разузнать.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [0, 0]
			Bravery = [6, 0]
			Stamina = [4, 2]
			MeleeSkill = [9, 12]
			RangedSkill = [8, 8]
			MeleeDefense = [4, 2]
			RangedDefense = [0, 0]
			Initiative = [8, 10]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		items.equip(this.new("scripts/items/tools/reinforced_throwing_net"));
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.addToBag(this.new("scripts/items/weapons/crossbow"));
			items.equip(this.new("scripts/items/ammo/quiver_of_bolts"));
		}
		else if (r == 1)
		{
			items.addToBag(this.new("scripts/items/weapons/rondel_dagger"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/fighting_axe"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/military_cleaver"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/scramasax"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}

		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/ragged_dark_surcoat"));
		}
	}

});

