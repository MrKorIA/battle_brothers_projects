this.torturer_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hackflows_torturer";
		this.m.Name = "Истязатель";
		this.m.Icon = "ui/backgrounds/background_torturer.png";
		this.m.BackgroundDescription = "Все благородные дома держат при себе заплечных дел мастеров, хоть мало кто признаётся в этом открыто. Нравы у этих истязателей разнятся: от хладнокровной, леденящей отрешённости до слепой и безумной злобы. Тем не менее, каждый из них невероятно искусен в причинении изощрённой боли и калечащих увечий.";
		this.m.GoodEnding = "Из всех людей, с которыми вы делили палатку в отряде \'%companyname%\', именно %name% пугал вас меньше всех - и это говорило о многом. Другие наёмники погибали от стали и стрел, а он неизменно оставался невредим, словно сама смерть обходила его стороной из брезгливости. Поговаривают, будто он осел где-то на юге и поступил на службу к тамошнему владыке - не то тюремщиком, не то заплечных дел мастером. В письмах он не нуждается, да вы и не писали бы: некоторые вещи лучше оставить в прошлом, как и людей, которых лучше не вспоминать.";
        this.m.BadEnding = "Покинув отряд \'%companyname%\', %name% нашёл-таки применение своим талантам - и, как водится, переоценил свою незаменимость. Новый господин, человек практичный, решил однажды, что палач, слишком увлечённый своей работой, рано или поздно начнёт путать приказ с желанием. Его нашли в собственной пыточной - {с инструментами, которые он так любовно точил, вставленными в него самого | на стуле, приколоченном к полу и кляпом из собственной рубахи во рту}. Судя по выражению его лица, он всё-таки успел удивиться - впервые в жизни.";
		this.m.HiringCost = 200;
		this.m.DailyCost = 8;
		this.m.Excluded = [
			"trait.athletic",
			"trait.bleeder",
			"trait.brave",
			"trait.clumsy",
			"trait.cocky",
			"trait.craven",
			"trait.dastard",
			"trait.deathwish",
			"trait.drunkard",
			"trait.dumb",
			"trait.eagle_eyes",
			"trait.fainthearted",
			"trait.fearless",
			"trait.fragile",
			"trait.hate_beasts",
			"trait.hate_greenskins",
			"trait.hate_undead",
			"trait.impatient",
			"trait.insecure",
			"trait.iron_lungs",
			"trait.loyal",
			"trait.lucky",
			"trait.optimist",
			"trait.paranoid",
			"trait.pessimist",
			"trait.quick",
			"trait.superstitious",
			"trait.sure_footing",
			"trait.swift",
			"trait.teamplayer",
			"trait.tiny"
		];
		this.m.Titles = [
			"Психопат",
			"Злобный",
			"Мучитель",
			"Кровопускатель",
			"Жестокий"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Thick;
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
        return "{Уже в детстве было ясно: %name% скроен не так, как остальные - он находил извращённое наслаждение в страданиях слабых, мучая лягушек, кроликов и даже кошек с нескрываемым восторгом. | %name% с малых лет держался особняком - соседские дети сами старались обходить его стороной, чуя не столько его силу, сколько то странное удовольствие, с которым он ловил и мучил бродячих животных. | %name% с ранних лет отличался пугающим спокойствием при виде чужой боли - пока другие дети морщились, глядя на подстреленную птицу, он лишь придвигался ближе, чтобы рассмотреть получше.} {Вскоре отец, не выдержав, взмолился местному лорду - пусть тот либо излечит мальчишку, либо запрёт его подальше от людей. Лорд, впрочем, разглядел в этом талант и не сделал ни того, ни другого - вместо этого он нанял парня палачом. | Слухи о жестоких забавах достигли ушей местного лорда, который, вместо того чтобы наказать юнца, предложил ему применить свои наклонности на благо правосудия - в застенках. | Когда терпение отца иссякло и он потребовал от лорда или излечить сына, или изгнать его из города, лорд рассудил иначе: такому таланту куда лучше подойдёт работа в пыточной его замка.} {Вы не знаете, почему он теперь ищет работу наёмника... но чувствуете, что лучше вам этого и не знать. | Вы уже собираетесь спросить, почему бывший палач ищет работу простого наёмника, но что-то в его спокойном взгляде отбивает всякое желание задавать этот вопрос. | Вы могли бы спросить, почему палач вдруг решил взяться за меч вместо привычных инструментов, но выражение его лица красноречиво советует вам этого не делать.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [5, 10]
			Bravery = [-5, 5]
			Stamina = [2, 3]
			MeleeSkill = [3, 4]
			RangedSkill = [0, 0]
			MeleeDefense = [0, -3]
			RangedDefense = [-3, 0]
			Initiative = [0, 0]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		items.equip(this.new("scripts/items/armor/butcher_apron"));
	}

});

