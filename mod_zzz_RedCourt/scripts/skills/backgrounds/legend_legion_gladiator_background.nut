this.legend_legion_gladiator_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.legend_legion_gladiator";
        this.m.Name = "Костяной гладиатор";
        this.m.Icon = "ui/backgrounds/background_puppet.png"; //TODO
        this.m.BackgroundDescription = "Вождь для немногих, раб для многих.";
		this.m.GoodEnding = "";
		this.m.BadEnding = "";
		this.m.HiringCost = 0;
		this.m.DailyCost = 0;
		this.m.Excluded = [
            "trait.ailing",
            "trait.asthmatic",
            "trait.bleeder",
            "trait.brave",
            "trait.gluttonous",
            "trait.craven",
            "trait.dastard",
            "trait.deathwish",
            "trait.determined",
            "trait.disloyal",
            "trait.drunkard",
            "trait.fainthearted",
            "trait.fat",
            "trait.fear_undead",
            "trait.fear_greenskins",
            "trait.fear_beasts",
            "trait.fearless",
            "trait.eagle_eyes",
            "trait.greedy",
            "trait.hate_undead",
            "trait.insecure",
            "trait.iron_lungs",
            "trait.irrational",
            "trait.loyal",
            "trait.night_owl",
            "trait.night_blind",
            "trait.optimist",
            "trait.paranoid",
            "trait.pessimist",
            "trait.spartan",
            "trait.superstitious",
            "trait.weasel",
            "trait.legend_fear_nobles",
            "trait.legend_slack",
            "trait.legend_double_tongued",
            "trait.legend_gift_of_people",
            "trait.legend_seductive"
            ];

		this.m.ExcludedTalents = [
			this.Const.Attributes.Bravery
		];

		//apperance
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.BeardChance = 0;
		//---
		this.m.Names = this.Const.Strings.AncientDeadNames;
		this.m.LastNames = this.Const.Strings.AncientDeadTitles;
		this.m.Level = this.Math.rand(4, 5);

	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor().get();

		if (::MSU.isKindOf(actor, "player"))
		{
			if (actor.getFlags().has("human"))
				actor.getSprite("injury_body").setBrush("bust_skeleton_body_injured");

			local hairColor = this.Const.HairColors.Zombie[this.Math.rand(0, this.Const.HairColors.Zombie.len() - 1)];
			local body = actor.getSprite("body");
			body.setBrush("bust_skeleton_body_0" + this.Math.rand(1, 2));
			body.Saturation = 0.8;

			actor.getSprite("injury_body").setBrush("bust_skeleton_body_injured");

			local head = actor.getSprite("head");
			head.setBrush("bust_skeleton_head");
			head.Color = body.Color;
			head.Saturation = body.Saturation;

			local beard = actor.getSprite("beard");
			if (beard == !null)
			{
				beard.setBrush("beard_" + hairColor + "_" + this.Const.Beards.ZombieOnly[this.Math.rand(0, this.Const.Beards.ZombieOnly.len() - 1)]);
				local beard_top = actor.getSprite("beard_top");
				if (beard.HasBrush && this.doesBrushExist(beard.getBrush().Name + "_top"))
				{
					beard_top.setBrush(beard.getBrush().Name + "_top");
					beard_top.Color = beard.Color;
				}
			}

			local face = actor.getSprite("scar_head");
			if (face == !null)
				face.setBrush("bust_skeleton_face_0" + this.Math.rand(1, 6));

			local hair = actor.getSprite("hair");
			if (hair == !null)
			{
				hair.Color = beard.Color;
				hair.setBrush("hair_" + hairColor + "_" + this.Const.Hair.ZombieOnly[this.Math.rand(0, this.Const.Hair.ZombieOnly.len() - 1)]);
				actor.setSpriteOffset("hair", this.createVec(0, -3));
			}

			local injury = actor.getSprite("injury");
			if (injury == !null)
				injury.setBrush("bust_skeleton_head_injured");

		}
	}

	function onBuildDescription()
	{
        return "{%name% начинал свой путь рабом на арене, но кровь, пролитая на песке, быстро превратила его из безымянного бойца в любимца толпы. | Завершив сезон на гладиаторской арене, %name% продал бы свою свободу за ещё один сезон славы на арене - таким было его ремесло, и другого он не желал. | Потерпев унизительное поражение на арене, %name% потерял и толпу, и покровителя, и, казалось, саму причину жить дальше. | %name% родом из одной из многочисленных имперских бойцовских ям - раба, которого кровавый спорт превратил в солдата не хуже любой армии. | На пике своей славы %name% внушал уважение и восторг доброй половине империи - его имя выкрикивали трибуны задолго до того, как оно стало известно легионным писцам. | Опыт схваток как с людьми, так и с чудовищами даровал %name% уникальные навыки, не имевшие ничего общего с щитовым строем или обращением с пикой у обычного солдата.} {Когда легион прошёл маршем через руины его школы, среди мёртвых бойцов, устилавших песок арены, не осталось ни одного, кто пролежал бы там долго - шёпот древних жрецов поднял их всех, и %name% поднялся вместе с прочими, всё ещё сжимая оружие, с которым умер. | Он пал на арене, как умирали десятками до него - под рёв толпы, требующей крови. Легион нашёл его тело много позже, среди прочих костей давно опустевших ям, и вернул ему подобие жизни, забрав взамен последний остаток покоя. | Смерть настигла его не на арене, а в день, когда небо рухнуло над империей: обрушившиеся трибуны похоронили под собой и бойцов, и зрителей в равной мере. Немногих из-под завала подняли снова - но среди них оказался и он. | Легион не спрашивает согласия. Его кости, пролежавшие в безымянной могиле для рабов дольше, чем он бы хотел это признать, откликнулись на зов жрецов так же покорно, как некогда откликались на приказы надсмотрщика. } {Он предпочитает более лёгкие доспехи и всё ещё уклоняется с прежней быстротой - кости, в отличие от плоти, не боятся глубоких порезов. | В бойцовских ямах он привык к зрелищным, жестоким поединкам один на один; в строю Легиона ему пришлось учиться сражаться плечом к плечу - получается это у него через раз. | Немногие в Легионе могут похвастаться таким опытом убийства зверей, рабов и осуждённых, каким обладает он - опыта крупных же сражений строем ему всё ещё недостаёт. | Пока другие в лагере точат оружие, он чинит сеть - ту же самую, которой ловил и зверей, и людей на арене, и которая исправно служит ему до сих пор. | Выбирая нестандартное оружие - сети, лассо, кнут, трезубец - он нашёл в Легионе редкую роль: единственного, кто предпочитает сражаться в одиночку, а не в строю. | Годы тренировок и лишений оставили свой след - даже в смерти он остаётся не более чем рабом, разве что теперь его хозяин безмолвен и вечен. | Он путается, когда когти зверя не находят на нём ни крови, ни плоти, а чужие клыки, что должны были разорвать его тело, лишь бессильно смыкаются на голых костях. | Хвастливый и громкий даже без плоти на костях, он требует внимания каждое мгновение - и то и дело получает за это выговор от старших, будто позабыв своё место в строю Легиона. | Он подолгу замирает неподвижно, обратив пустые глазницы туда, где давно нет никакой арены - то ли всё ещё мнит себя бойцом на песке, то ли просто не в силах расстаться с призраком былой славы. | Не все гладиаторы Легиона тоскуют по старому ремеслу - он, похоже, один из немногих, кто нашёл в новых братьях по оружию нечто лучшее, чем соперничество на арене. | Новым повелителям, которым он теперь подчиняется, %name% не выказывает ни радости, ни ропота - лишь смирение раба, которому напомнили, что на арене убийство хотя бы прославляли, а в Легионе это просто часть работы.}";
	}

	function onChangeAttributes() //uses Character_background.nut template (Skeleton)
	{
		local c = {
			Hitpoints = [
				20,
				30
			],
			Bravery = [ //not needed except for resisting charm and sleep
				5,
				10
			],
			Stamina = [ //not needed except for equipment weight
				10,
				15
			],
			MeleeSkill = [
				12,
				16
			],
			RangedSkill = [
				10,
				18
			],
			MeleeDefense = [
				5,
				8
			],
			RangedDefense = [
				4,
				7
			],
			Initiative = [
				20,
				30
			]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();
		local actor = this.getContainer().getActor();
        if (!actor.getSkills().hasSkill("trait.legend_fleshless"))
        {
            actor.getSkills().add(this.new("scripts/skills/traits/legend_fleshless_trait"));
        }

		actor.m.ExcludedInjuries = [
            "injury.cut_artery",
            "injury.cut_throat",
            "injury.deep_abdominal_cut",
            "injury.deep_chest_cut",
            "injury.exposed_ribs",
            "injury.grazed_kidney",
            "injury.grazed_neck",
            "injury.infected_wound",
            "injury.sickness",
            "injury.stabbed_guts",
            "injury.broken_nose",
            "injury.crushed_windpipe",
            "injury.fractured_ribs",
            "injury.inhaled_flames",
            "injury.pierced_chest",
            "injury.ripped_ear",
            "injury.cut_arm_sinew",
            "injury.pierced_lung",
            "injury.cut_leg_muscles",
            "injury.pierced_side",
            "injury.pierced_cheek"
        ];
		actor.getFlags().add("legion_can_command");  //justfies if this background is subject to the legion command skill
	}

	function adjustHiringCostBasedOnEquipment() //reduces cost for equipment worn on skeletons to zero for recruiting purposes.
	{
		local actor = this.getContainer().getActor();
		actor.m.HiringCost = this.Math.floor(this.m.HiringCost + 500 * this.Math.pow(this.m.Level - 1, 1.5));
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();

        local weapon = ::MSU.Class.WeightedContainer([
            [1, "scripts/items/weapons/ancient/ancient_spear"],
            [1, "scripts/items/weapons/ancient/legend_kopis"],
            [1, "scripts/items/weapons/ancient/legend_gladius"],
            [1, "scripts/items/weapons/throwing_spear"]
        ]).roll();
        items.equip(this.new(weapon));

		if (items.getItemAtSlot(this.Const.ItemSlot.Offhand) == null) {
            weapon = ::MSU.Class.WeightedContainer([
                [2, "scripts/items/tools/throwing_net"],
                [1, "scripts/items/shields/ancient/tower_shield"]
            ]).roll();
            items.equip(this.new(weapon));
		}

		items.equip(this.new("scripts/items/armor/ancient/ancient_ripped_cloth"));
		items.equip(this.new("scripts/items/helmets/ancient/legend_helmet_legend_ancient_gladiator"));

	}
});
