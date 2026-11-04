this.arbalester_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hackflows_arbalester";
		this.m.Name = "Арбалетчик";
		this.m.Icon = "ui/backgrounds/background_arbalester.png";
		this.m.BackgroundDescription = "Часто арбалетчики зарабатывают на жизнь как профессиональные стрелки, нанимаясь в гарнизоны благородных домов.";
        this.m.GoodEnding = "После нескольких лет в отряде \'%companyname%\' %name% наконец накопил достаточно денег, чтобы оставить наёмничество. Он купил небольшой дом на окраине города и занялся тем, что умел лучше всего: охотой и стрельбой. Поговаривали, что теперь он стреляет исключительно по зверю, хотя мало кто решался спросить его, действительно ли это так.";
        this.m.BadEnding = "Покинув отряд \'%companyname%\', %name% снова нанялся охранять обоз, но в одном из следующих переходов он получил стрелу в грудь раньше, чем успел натянуть тетиву. Его товарищи похоронили его у дороги и забрали с собой всё ценное. Арбалет они оставили на могиле - слишком уж хорошо знали, как дорог он ему был. Через несколько дней оружие исчезло, а могила осталась такой же безымянной, как и множество других вдоль этой дороги.";
		this.m.HiringCost = 30;
		this.m.DailyCost = 20;
		this.m.Excluded = [
			"trait.bloodthirsty",
			"trait.brute",
			"trait.clubfooted",
			"trait.clumsy",
			"trait.determined",
			"trait.drunkard",
			"trait.dumb",
			"trait.fearless",
			"trait.fragile",
			"trait.gluttonous",
			"trait.hate_undead",
			"trait.huge",
			"trait.impatient",
			"trait.insecure",
			"trait.iron_jaw",
			"trait.irrational",
			"trait.night_blind",
			"trait.quick",
			"trait.short_sighted",
			"trait.strong",
			"trait.weasel"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.MeleeSkill,
			this.Const.Attributes.MeleeDefense
		];
		this.m.Titles = [
			"Арбалетчик",
			"Арбалетчик",
			"Снайпер",
			"Меткий"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.IsCombatBackground = true;
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
        return "{%name% рос в мастерской своего отца, арбалетного мастера - но однажды знатный вельможа, впечатлённый качеством заказанного оружия, решил, что подобное оружие не должно достаться никому другому, и избавился от мастера. %name% забрал единственный уцелевший арбалет и поклялся, что однажды рассчитается за отца. | %name% годами браконьерствовал в лордских угодьях, набивая руку на оленях и кабанах, пока лесничие не поймали его с поличным - обвинение в убийстве королевского зверя каралось виселицей, и он бежал из родных мест, забрав с собой лишь арбалет. | %name% служил городским стражником и стрелком на воротах, пока город не пал перед осаждавшими, а гарнизон не распустили за ненадобностью - он остался без жалования, но при оружии. | Дезертировав из армии после кровавого поражения, в котором его отряд арбалетчиков полёг почти полностью, %name% решил, что служба короне того не стоит, и что дальше будет продавать свои умения тому, кто заплатит. | %name% был обычным охотником в глухой деревне, пока голодный год не заставил его продать всё, кроме арбалета, и отправиться в город на заработки. | %name% самостоятельно выучился обращению с арбалетом, охраняя купеческие обозы от разбойников на большой дороге, пока однажды не узнал, что именно перевозил его наниматель, и не пожелал участвовать в этом дальше. | Отслужив десять лет ротным стрелком, %name% вернулся домой - но нашёл на месте отчего дома лишь пепелище: соседи так и не смогли толком объяснить, что произошло и кто в этом виноват.} {Он не питает особых иллюзий насчёт будущего - ему просто нужны деньги, а стрелять он умеет лучше, чем делать что-либо ещё. | С тех пор он почти не расстаётся с флягой, но рука на спусковом крючке у него на удивление твёрже, чем у трезвого. | Он давно смирился с тем, что прежней жизни не вернуть, и теперь просто ищет отряд, который будет исправно платить. | О прошлом он рассказывает мало и неохотно, предпочитая, чтобы о нём судили по меткости выстрелов, а не по старым историям. | Он давно решил, что жалеть о прошлом - непозволительная роскошь для человека с арбалетом и почти без гроша в кармане. | Он редко заговаривает о случившемся, но что-то в его голосе ясно говорит: лучше не переспрашивать дважды.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [-5, 0]
			Bravery = [0, 0]
			Stamina = [4, 4]
			MeleeSkill = [0, 0]
			RangedSkill = [13, 15]
			MeleeDefense = [0, 0]
			RangedDefense = [0, 3]
			Initiative = [0, 0]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		items.equip(this.new("scripts/items/weapons/crossbow"));
		items.equip(this.new("scripts/items/ammo/quiver_of_bolts"));
		r = this.Math.rand(1, 100);

		if (r > 90)
		{
			items.equip(this.new("scripts/items/armor/leather_lamellar"));
		}
		else if (r > 70)
		{
			items.equip(this.new("scripts/items/armor/gambeson"));
		}
		else if (r > 40)
		{
			items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}
		else
		{
			items.equip(this.new("scripts/items/armor/padded_surcoat"));
		}

		r = this.Math.rand(1, 100);

		if (r > 75)
		{
			items.equip(this.new("scripts/items/helmets/feathered_hat"));
		}
		else if (r > 50)
		{
			items.equip(this.new("scripts/items/helmets/aketon_cap"));
		}
	}

});

