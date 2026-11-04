this.cobbler_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hackflows_cobbler";
		this.m.Name = "Сапожник";
		this.m.Icon = "ui/backgrounds/background_cobbler.png";
		this.m.BackgroundDescription = "Сапожники - это скромные люди, зарабатывающие на кусок хлеба пошивом и починкой любой обуви.";
        this.m.GoodEnding = "Покинув отряд \'%companyname%\', %name% вернулся к шилу и коже. Вы слышали, что вскоре у него появилась своя мастерская, а клиентами стали те самые наёмники, что знают цену крепким сапогам: люди, которые много ходят, не скупятся на хорошую подошву. Заказы идут один за другим, и работы хватает. Говорят, что лучшими клиентами он считает тех, кто возвращается за новой парой целым и невредимым, а вот тех, кто не вернулся, он старается не пересчитывать.";
        this.m.BadEnding = "Покинув отряд \'%companyname%\', %name% вернулся к своему ремеслу, но тишина мастерской оказалась ему не по душе: сапожник, сбежавший от скуки колодок, вдруг затосковал по дороге. Из письма, дошедшего до вас через третьи руки, следовало, что мастерскую он продал за бесценок и ушёл вслед за каким-то обозом. Где он теперь, никто толком не знает, но ходят слухи, что нашли его сапоги, добротные и крепко сшитые, а самого хозяина рядом с ними не оказалось.";
		this.m.HiringCost = 70;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.bloodthirsty",
			"trait.brute",
			"trait.cocky",
			"trait.clumsy",
			"trait.hate_beasts",
			"trait.huge",
			"trait.impatient",
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Bravery
		];
		this.m.Titles = [
			"Сапожник",
			"Башмачник",
			"Обувник",
			"Башмачник",
			"Сапожник",
			"Сапожник"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.IsLowborn = true;
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
        return "{%name%, сапожник, как и подавляющее большинство крестьян, не может похвастаться сколько-нибудь интересной историей. | %name% всю жизнь тачал сапоги в своей лавке, и, честно говоря, ничего примечательного за этим занятием с ним так и не произошло. | %name% лишь непонимающе смотрит на вас в ответ на вопрос о своём прошлом - рассказывать попросту нечего. | %name% - сапожник, и этим, пожалуй, исчерпывается всё, что о нём стоит знать.} Когда вы спрашиваете, почему он хочет стать наёмником, {он просто пожимает плечами и бормочет что-то про то, что сапожным делом на жизнь не заработаешь. | он лишь неопределённо машет рукой и бурчит, что кожа нынче дорога, а заказов - всё меньше. | он отвечает уклончиво: дескать, сапоги сапогами, а есть-то надо каждый день. | он бурчит что-то про конкурентов через дорогу, перебивших у него половину клиентов, и разводит руками - мол, что уж тут поделать. | он лишь неловко переминается с ноги на ногу и признаётся, что толком сам не знает зачем, просто дома сидеть надоело.} {Вы удивлённо приподнимаете брови: запрошенное им жалование и без того довольно скромное, так что вы резонно заключаете, что сапожное дело - ремесло не из прибыльных. | Судя по тому, сколько он просит, дела у него шли явно не блестяще - тут и к гадалке ходить не нужно. | Названная им сумма жалования настолько скромна, что вы невольно задаётесь вопросом: неужели починка обуви приносит настолько мало дохода? | Глядя на его более чем скромные запросы, вы делаете вывод, что в сапожном деле он явно не преуспел.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [0, 0]
			Bravery = [0, 0]
			Stamina = [0, 0]
			MeleeSkill = [2, 2]
			RangedSkill = [0, 0]
			MeleeDefense = [0, 0]
			RangedDefense = [0, 0]
			Initiative = [0, 0]
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
		items.equip(this.new("scripts/items/armor/linen_tunic"));
	}

});

