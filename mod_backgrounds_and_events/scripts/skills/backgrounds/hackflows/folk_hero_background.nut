this.folk_hero_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hackflows_folk_hero";
		this.m.Name = "Народный герой";
		this.m.Icon = "ui/backgrounds/background_folk_hero.png";
		this.m.BackgroundDescription = "Народные герои - это выходцы из простого люда, которые сумели достичь невероятных высот. Своими легендарными подвигами они завоевали искреннюю любовь крестьян и вырвали неохотное уважение у благородных рыцарей.";
        this.m.GoodEnding = "Народный герой %name% оставался в отряде \'%companyname%\' дольше многих - и, вопреки своей славе, ни разу не потребовал себе ни отдельного шатра, ни двойной доли добычи. Он дрался в первой шеренге, пил с новобранцами из одной кружки и терпеливо сносил, как крестьяне в каждой деревне снова и снова выпрашивают у него пересказать историю про двадцать пятерых. Дальше след его теряется: кто говорит, что он сложил голову где-то на юге, кто - что вернулся в родные края и живёт простым охотником. Впрочем, ни одна из этих историй не кажется особенно правдоподобной - молва уверяет, что %name% до сих пор жив, а люди, которых однажды превратили в легенду, редко позволяют точно узнать, где они закончили свой путь.";
        this.m.BadEnding = "Народный герой %name% покинул отряд \'%companyname%\' однажды весной - сказал, что нашёл дело поважнее наёмничества, и ушёл, не взяв ни доли, ни расчёта. Спустя год в отряде узнали, что он собрал в родных краях вооружённых мужиков и поднял их против лорда, обдиравшего деревню налогами. Чем всё кончилось, никто толком не знает: одни говорят, что его повесили на воротах усадьбы, другие - что он ушёл в горы и до сих пор оттуда совершает набеги. Достоверно известно лишь одно: история про двадцать пятерых разбойников со временем показалась людям почти будничной по сравнению с тем, что начали рассказывать о последнем бунте этого героя.";
		this.m.HiringCost = 5000;
		this.m.DailyCost = 25;
		this.m.Excluded = [
			"trait.ailing",
			"trait.asthmatic",
			"trait.bleeder",
			"trait.bloodthirsty",
			"trait.brute",
			"trait.cocky",
			"trait.craven",
			"trait.dastard",
			"trait.disloyal",
			"trait.drunkard",
			"trait.dumb",
			"trait.fainthearted",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.fear_undead",
			"trait.fragile",
			"trait.greedy",
			"trait.hesitant",
			"trait.impatient",
			"trait.insecure",
			"trait.irrational",
			"trait.quick",
			"trait.spartan",
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
			"Народный герой",
			"Львиное сердце",
			"Справедливый",
			"Великодушный",
			"Прославленный",
			"Скромный"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.AllMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.IsCombatBackground = true;
		this.m.IsLowborn = true;
		this.m.Level = this.Math.rand(5, 6);
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
        return "{Одни говорят, что человек рождается для своей доли: то, в какой семье и с каким именем он появился на свет, предрешает для него либо величие, либо беспросветную безызвестность. %name% - живое опровержение этой поговорки: рождённый в бедности, он возвышается над толпой на две головы, источая ауру силы, которую ни одно благородное происхождение дать не в силах. | Кто-то верит, что судьба человека определена ещё до его первого вздоха тем, в чьей семье он родился. %name%, начинавший жизнь нищим и безродным, а ныне возвышающийся над любым лордом одной лишь статью, - лучшее опровержение этого утверждения. | Многие уверены: без громкого имени за спиной в жизни ничего не добьёшься. %name% опровергает это одним своим видом - вчерашний безымянный бедняк, а держится и выглядит так, что перед ним впору расступаться самим лордам. | Считается, что бедность рождения предрешает и бедность судьбы, а безродный так навсегда безродным и останется. Но исполинская фигура %name%, некогда нищего сироты без гроша за душой, и почтительный шёпот, что стелется за ним по пятам, заставляют усомниться в этой мудрости.} {Поблизости крестьяне взволнованно перешёптываются между собой. Судя по всему, несмотря на то, что он родился в крайней нищете и рано осиротел, %name% со временем стал настоящим народным героем - в числе прочего рассказывают, что он в одиночку вышел против двух десятков разбойников и одержал победу. | Крестьяне у дороги указывают на него и оживлённо перешёптываются - по слухам, этот человек, начинавший жизнь без гроша за душой, в одиночку разогнал целую разбойничью шайку. | Стоит ему пройти мимо, как крестьяне начинают взволнованно шептаться - поговаривают, что этот бывший беспризорник голыми руками одолел не то два десятка, не то все тридцать головорезов, охранявших горный перевал.} {Вы спрашиваете его, где в этой легенде правда, а где вымысел. Не отрывая взгляда от своей кружки, он лишь коротко отвечает: \'Двадцать пять\'. | Вы пытаетесь выяснить, сколько в этой истории правды. Он делает неторопливый глоток и, не поднимая глаз, бросает: \'Двадцать пять крон. За меньшее не встаю из-за стола\'. | На ваш вопрос о том, насколько преувеличена эта история, он лишь фыркает и, не отрываясь от кружки, называет сумму - и по одному его тону ясно, что торговаться бесполезно. | Вы осторожно интересуетесь, сколько разбойников было на самом деле. Он на мгновение задумывается, будто что-то подсчитывая в уме, и наконец произносит: \'Двадцать шесть. Но один сбежал, так что не считается\'.}";
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
			Hitpoints = [14, 16]
			Bravery = [5, 5]
			Stamina = [15, 15]
			MeleeSkill = [10, 18]
			RangedSkill = [0, 0]
			MeleeDefense = [2, 6]
			RangedDefense = [2, 2]
			Initiative = [0, 0]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();

		if (this.Math.rand(0, 2) == 2)
		{
			local actor = this.getContainer().getActor();
			actor.setTitle(this.Const.Strings.HedgeKnightTitles[this.Math.rand(0, this.Const.Strings.HedgeKnightTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 1);

		if (r == 0 && this.Const.DLC.Wildmen)
		{
			items.equip(this.new("scripts/items/weapons/named/named_bardiche"));
		}
		else
		{
			items.equip(this.new("scripts/items/weapons/named/named_greataxe"));
		}

		items.equip(this.new("scripts/items/armor/scale_armor"));
		r = this.Math.rand(1, 100);

		if (r > 85)
		{
			items.equip(this.new("scripts/items/helmets/greatsword_hat"));
		}
		else if (r > 65)
		{
			items.equip(this.new("scripts/items/helmets/greatsword_faction_helm"));
		}
	}

});

