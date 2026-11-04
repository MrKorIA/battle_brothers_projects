this.hemovore_avatar_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {
	    IsFemale = false
	},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.hemovore_avatar";
		this.m.Icon = "ui/backgrounds/Background_hemovore_avatar.png"; 
		this.m.Name = "Прародитель"; //— 
		this.m.BackgroundDescription = "Вы прожили так много жизней - от низкородного батрака до одного из самых доверенных людей императора, но теперь вы охотитесь на себе подобных.";
		this.m.GoodEnding = "Благодаря тому, что вы нарушили мир, группа, бежавшая от древнего порядка, в конце концов была найдена - они замаскировались среди бандитов, воров и наёмников в одном из отрядов глубоко в сердце новой цивилизации. Когда пришло время, была предпринята попытка смыть их вместе с бесчисленными телами не связанных между собой смертных. Завеса была сохранена, и вы были хорошо вознаграждены.";
		this.m.BadEnding = "Из-за слабости или недостатка сосредоточенности группа, на которую вы охотились, продолжала ускользать от вас. Древние стали проявлять нетерпение и после вашей смерти полностью потеряли интерес к группе. Наказание после вашей окончательной смерти продолжалось - ваше имя было вычеркнуто из всех записей, которые ещё хранились в империи, а любые вещественные доказательства вашего существования были сожжены факелом. Или чем-то похуже.";		
		this.m.HiringCost = 999999999999999999999999;
		this.m.DailyCost = 0;
		this.m.Excluded = [
			"trait.craven",
			"trait.dastard",
			"trait.clubfooted",
			"trait.tiny",
			"trait.short_sighted",
			"trait.drunkard",
			"trait.insecure",
			"trait.night_blind",
			"trait.legend_fear_dark",
			"trait.deathwish", //Cannot lose res via being hit
			"trait.gluttonous", //does not eat
			"trait.asthmatic", //not really affected by fatigue
			"trait.fat", // doesn't eat
			"trait.spartan",  //no food required
			"trait.fear_nobles",
			"trait.fear_greenskins",
			"trait.greedy", //Not paid
			"trait.fear_beasts",
			"trait.fear_undead", //not scared of lesser dead
			"trait.legend_steady_hands",
			"trait.legend_sureshot",
			"trait.ailing" //cant be poisoned
		];

		this.m.ExcludedTalents = [
			this.Const.Attributes.RangedSkill
		];
		//Male
		this.m.Faces = ["bust_vampire_lord_head_04"]; //could also be 01 or 02 or 03
		this.m.Bodies = ["bust_vampire_lord_body_01"]; //could also be 02 or 03
		this.m.Hairs = this.Const.Hair.Vampire;
		this.m.HairColors = this.Const.HairColors.Zombie;
		// this.m.Beards = this.Const.Beards.Tidy;

		this.m.Level = 3;
		this.m.Names = this.Const.Strings.VampireLordNames;
		this.m.Titles = this.Const.Strings.FallenHeroTitles;
		//if (::Math.rand(0, 1) == 0) this.m.IsFemale = true;

	}

    function onSetAppearance()
    {
        if (this.m.IsFemale)
        {
                //Female
            local actor = this.getContainer().getActor();
            actor.getSprite("head").setBrush("bust_vampire_lady_head_02");
            actor.getSprite("body").setBrush("bust_vampire_lady_body_02");
            actor.getSprite("beard").setBrush("");
            actor.getSprite("beard_top").setBrush("");
            actor.setName(this.Const.Strings.SouthernFemaleNames[this.Math.rand(0, this.Const.Strings.SouthernFemaleNames.len() - 1)]);
            this.m.BackgroundDescription = "Вы прожили так много жизней - от низкородной батрачки до одной из самых доверенных людей императора, но теперь вы охотитесь на себе подобных.";
            this.m.GoodEnding = "Благодаря тому, что вы нарушили мир, группа, бежавшая от древнего порядка, в конце концов была найдена, среди замаскировавшихся бандитов, воров и наёмников в одном из отрядов далеко в сердце новой цивилизации. Когда пришло время - была предпринята попытка смыть их вместе с бесчисленными телами не связанных между собой смертных. Завеса была сохранена, и вы были хорошо вознаграждены.";
            this.m.BadEnding = "Из-за слабости или недостатка сосредоточенности группа, на которую вы охотились, продолжала ускользать от вас. Древние стали проявлять нетерпение и после вашей смерти полностью потеряли интерес к группе. Наказание после вашей окончательной смерти продолжалось - ваше имя было вычеркнуто из всех записей, которые ещё хранились в империи, а любые вещественные доказательства вашего существования были сожжены факелом. Или чем-то похуже.";
        }
    }

	function onBuildDescription()
	{
		if (this.m.IsFemale) //female
		{
			return "{Осколки воспоминаний бурлят в голове - кровь, камень и мрак, затем крики, огонь и наступившая после этого тишина. Воспоминания мельтешат и кружат, сталкиваются друг с другом и всё начинается сначала. Вы помните лица всех мужчин и женщин, что сгубили, но с трудом можете вспомнить своё собственное. Когда конклав мятежников покинул склеп, вам поручили выследить их. Ведь время ещё не пришло и наступит не скоро. Чем раньше вы их найдёте, тем больше у вас шансов избежать их участи.}";
		}
		else //male
		{
			return "{Осколки воспоминаний бурлят в голове - кровь, камень и мрак, затем крики, огонь и наступившая после этого тишина. Воспоминания мельтешат и кружат, сталкиваются друг с другом и всё начинается сначала. На протяжении многих жизней вы то возвышались, то падали. Теперь же, кажется, наступило время, в котором вы обрели постоянство. Будто мир застыл вокруг вас. Когда конклав мятежников покинул склеп, вам поручили выследить их. Ведь время ещё не пришло и наступит не скоро. Чем раньше вы их найдёте, тем больше у вас шансов избежать их участи.}";
		}
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				25,
				30
			],
			Bravery = [ //gets +10 from avatar
				10,
				10
			],
			Stamina = [
				30,
				35
			],
			MeleeSkill = [ 
				25,
				35
			],
			RangedSkill = [
				-50,
				-50
			],
			MeleeDefense = [
				14,
				18
			],
			RangedDefense = [
				8,
				12
			],
			Initiative = [
				15,
				15
			]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();
        if (!this.m.Container.hasSkill("trait.vampire"))
        {
            this.m.Container.add(this.new("scripts/skills/racial/vampire_racial"));
        }

		local actor = this.getContainer().getActor();
		actor.m.ExcludedInjuries = [ 
			"injury.infected_wound",
			"injury.sickness",
		];
	}

	function getTooltip()
	{
		local ret = this.character_background.getTooltip()
		ret.push(
			{
				id = 13,
				type = "text",
				icon = "ui/icons/armor_body.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Не может носить броню тела или головы[/color], но получает на [color=" + this.Const.UI.Color.PositiveValue + "]30%[/color] меньше урона от прямых атак. Порог получения травм увеличен на [color=" + this.Const.UI.Color.PositiveValue + "]90%[/color]"
			}
		)
		return ret
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();

		local r;
		r = this.Math.rand(0, 5);

		if (r == 0)
		{
		    items.equip(this.new("scripts/items/weapons/ancient/legend_fan_axe"));
		}
		else if (r == 1)
		{
		    items.equip(this.new("scripts/items/weapons/ancient/legend_kopis"));
		}
		else if (r == 2)
		{
		    items.equip(this.new("scripts/items/weapons/ancient/khopesh"));
		}
		else if (r == 3)
		{
		    items.equip(this.new("scripts/items/weapons/ancient/warscythe"));
		}
		else if (r == 4)
		{
		    items.equip(this.new("scripts/items/weapons/ancient/legend_spatha"));
		}
		else if (r == 5)
		{
		    items.equip(this.new("scripts/items/weapons/ancient/legend_decorated_sword"));
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.DamageReceivedRegularMult *= 0.70; //30% reduction
		_properties.ThresholdToReceiveInjuryMult *= 1.90; //+90% higher threshold
	}

});
