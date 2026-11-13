this.master_archer_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hackflows_master_archer";
		this.m.Name = "Мастер-лучник";
		this.m.Icon = "ui/backgrounds/background_master_archer.png";
		this.m.BackgroundDescription = "Эти стрелки положили всю жизнь на то, чтобы довести искусство владения луком до абсолютного совершенства. И хотя на дистанции они бьют без промаха, в яростной рукопашной схватке от них мало толку.";
        this.m.GoodEnding = "Легендарный лучник %name% оставался в отряде \'%companyname%\' до самого конца и умер не от стрелы, как следовало бы человеку с его именем, а от старости - тихо, в постели, на какой-то захудалой постоялой квартире. Говорят, до последнего дня он выходил во двор, ставил мишень и стрелял, ориентируясь на слух и память рук, и попадал куда чаще, чем следовало бы слепому старику. Барды по-прежнему поют о его прежних подвигах, хотя сами никогда не видели ни его лука, ни его самого, и от этого подвиги становятся всё краше с каждым годом.";
        this.m.BadEnding = "Мастер-лучник %name% не покинул отряд \'%companyname%\' до самой старости - и в этом была его ошибка. В одной из стычек {к северу | к югу | к западу | к востоку} отсюда он не расслышал, с какой стороны наступает наездник гоблинов на волке, и послал стрелу туда, где противник должен был быть. Тот оказался совсем рядом - на расстоянии меча. Тело его осталось на поле вместе с прочими: выносить старика, когда раненые ещё дышали, никому и в голову не пришло. А через год о нём вспомнили лишь барды, придумавшие к прежним подвигам ещё один, посмертный: будто бы %name% погиб, выпустив последнюю стрелу прямо в сердце врага.";
		this.m.HiringCost = 100;
		this.m.DailyCost = 35;
		this.m.Excluded = [
			"trait.clubfooted",
			"trait.clumsy",
			"trait.fear_beasts",
			"trait.hesitant",
			"trait.impatient",
			"trait.tough",
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.MeleeDefense,
			this.Const.Attributes.MeleeSkill
		];
		this.m.Titles = [
			"Мастер-стрелок",
			"Без промаха",
			"Снайпер",
			"Охотник за головами",
			"Лучник с длинным луком",
			"Бесподобный",
			"Меткий"
		];
		this.m.Faces = this.Const.Faces.SmartMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.Old;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.Level = this.Math.rand(3, 5);
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
        return "{%name% - легенда среди лучников, и, возможно, самый опасный стрелок из всех, кто когда-либо натягивал тетиву. | Одно лишь имя %name% в определённых кругах вызывает у одних благоговение, а у других - холодный пот. | %name% прославился настолько, что барды до сих пор поют о его меткости, хотя вживую его лук почти никто из ныне живущих не видел.} {Легенда гласит, что однажды он в одиночку уложил два десятка человек меньше чем за двадцать секунд, даже не сходя с места. | Говорят, он способен всадить три стрелы в одну и ту же точку мишени - настолько точно, что вторая и третья стрела просто раскалывают древко первой. | Рассказывают, что однажды он сбил стрелу другого лучника прямо в полёте - просто чтобы доказать, что может.} {Но годы, увы, оказались противником более искусным, чем любой человек: старость отняла у него самое важное для лучника - острое зрение. | С возрастом руки его, некогда твёрдые как сталь, начали предательски дрожать в самый неподходящий момент прицеливания, да и глаза уже не те, что раньше. Но за счёт опыта %name% по-прежнему остаётся грозной силой. | Годы забрали остроту его глаза, но не меткость: он больше не различает цель на расстоянии полёта стрелы, а бьёт туда, где цель должна быть, полагаясь на слух и многолетнее чутьё, и промахивается на удивление редко. | Дрожащие руки и мутнеющий взгляд отняли у него былую безупречность, но даже нынешний, ослабленный %name% стреляет быстрее и увереннее большинства молодых лучников.} {Подозревая, что стоит ему осесть на одном месте, как найдётся желающий свести с ним старые счёты, %name% предпочитает держаться поближе к полю боя, где его умения по-прежнему нужны. | Он щурится, вглядываясь в даль, и вы не уверены, высматривает ли он врага или просто пытается разобрать, где заканчивается дорога. | Он неохотно говорит о своей легендарной славе, отшучиваясь, что лучшие его выстрелы остались в те годы, когда он ещё мог разглядеть, во что стреляет. | Он предпочитает компанию наёмников тихой старости в одиночестве - вторая, по его словам, куда более смертоносна, чем работа наёмником.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [-16, -16]
			Bravery = [4, 4]
			Stamina = [-12, -5]
			MeleeSkill = [-12, -7]
			RangedSkill = [30, 30]
			MeleeDefense = [-5, -5]
			RangedDefense = [5, 8]
			Initiative = [10, 10]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		items.equip(this.new("scripts/items/weapons/war_bow"));
		items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.addToBag(this.new("scripts/items/weapons/dagger"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/ragged_surcoat"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/thick_tunic"));
		}
		else
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
		else
		{
			items.equip(this.new("scripts/items/helmets/hunters_hat"));
		}
	}

});

